codeunit 70031 PTAReprocessEnquiryToDocuments
{
    TableNo = PTAEnquiry;

    trigger OnRun()
    begin
        PTAEnquiry := Rec;
        PTASetup.Get();

        ReprocessEnquiry(PTAEnquiry)
    end;

    local procedure ReprocessEnquiry(VarPTAEnquiry: Record PTAEnquiry)
    var
        SalesHeader: Record "Sales Header";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
    begin
        SalesHeader.get(SalesHeader."Document Type"::Order, Format(VarPTAEnquiry.EnquiryNumber));
        SalesHeader.SetRecFilter();
        if SalesHeader.Status = SalesHeader.Status::Released then
            ReleaseSalesDocument.Reopen(SalesHeader);
        CheckUdpateOrDeleteSalesHeader(VarPTAEnquiry, SalesHeader);
    end;

    local procedure CheckUdpateOrDeleteSalesHeader(VarPTAEnquiry: Record PTAEnquiry; Var SalesHeader: Record "Sales Header")
    var
        PreviousPTAEnquiry: Record PTAEnquiry;
        PTAConvertEnquiryToDocuments: Codeunit PTAEnquiryConvertToDocuments;
        NewRecordRef, OldRecordRef : Recordref;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        TempPurchaseOrders: Record "Purchase Header" temporary;

    begin
        PTAEnquiryFunctions.GetPreviousBatchPTAEnquiry(VarPTAEnquiry, PreviousPTAEnquiry);
        NewRecordRef.gettable(VarPTAEnquiry);
        OldRecordRef.GetTable(PreviousPTAEnquiry);
        ReporcessEnquiry := False;

        if PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiry) then begin

            OneOfTheDimensionhasChanged := false;
            if ((VarPTAEnquiry.BusinessAreaId <> PreviousPTAEnquiry.BusinessAreaId) OR
                (VarPTAEnquiry.SupplierId <> PreviousPTAEnquiry.SupplierId) OR
                (VarPTAEnquiry.CustomerId <> PreviousPTAEnquiry.CustomerId) OR
                (VarPTAEnquiry.EnquiryPort <> PreviousPTAEnquiry.EnquiryPort) OR
                (SalesHeader."Currency Code" <> PTAEnquiryFunctions.GetCurrencyCodeFromEnquiry(VarPTAEnquiry)) or
                VarPTAEnquiry.HasVATAmount() <> PreviousPTAEnquiry.HasVATAmount()) then begin

                PTAEnquiryFunctions.DeleteAllRelatedPOsWithSalesOrder(VarPTAEnquiry, SalesHeader);
                if not SalesHeader.delete(true) then
                    Error(StrSubstNo('Error deleting previous version of Sales order. Error - %1', GetLastErrorText()));

                clear(PTAConvertEnquiryToDocuments);
                SalesHeader.init();
                PTAConvertEnquiryToDocuments.CreateEnquiry(VarPTAEnquiry, SalesHeader);
                ReporcessEnquiry := true;

            end else begin
                SalesHeader.SetHideValidationDialog(true);
                if VarPTAEnquiry.EnquiryPort <> PreviousPTAEnquiry.EnquiryPort then begin
                    PTAConvertEnquiryToDocuments.SetLocationDetailsOnSalesHeader(VarPTAEnquiry, SalesHeader);
                    PTAConvertEnquiryToDocuments.SetHeaderDetailsOnAllSalesLines(SalesHeader, SalesHeader.FieldNo("Location Code"));
                end;

                if (VarPTAEnquiry.ETD <> PreviousPTAEnquiry.ETD) or (VarPTAEnquiry.EnquiryDate <> PreviousPTAEnquiry.EnquiryDate) then
                    PTAConvertEnquiryToDocuments.SetSalesHeaderDates(VarPTAEnquiry, SalesHeader);

                if (VarPTAEnquiry.BusinessAreaId <> PreviousPTAEnquiry.BusinessAreaId) OR
                (VarPTAEnquiry.EnquirySupplyRegionID <> PreviousPTAEnquiry.EnquirySupplyRegionID) OR
                (VarPTAEnquiry.SupplierContractId <> PreviousPTAEnquiry.SupplierContractId) then begin
                    PTAConvertEnquiryToDocuments.InsertAndUpdateDimensionsOnSalesHeader(SalesHeader, VarPTAEnquiry);
                    OneOfTheDimensionhasChanged := true;
                end;

                PTAConvertEnquiryToDocuments.UpdateSalesHeaderWithPTAEnquiryFields(VarPTAEnquiry, SalesHeader);
            end;
        end;

        if Not ReporcessEnquiry then begin
            PTAConvertEnquiryToDocuments.CheckAndUpdateSalesVATDetailsFromLocation(VarPTAEnquiry, SalesHeader);
            SalesHeader.Modify();

            CreateOrUpdateSalesLines(VarPTAEnquiry, SalesHeader);
            ProcessAnyHardDeleteLines(VarPTAEnquiry, SalesHeader);
            PTAConvertEnquiryToDocuments.CreateSalesBrokerCommissionLines(VarPTAEnquiry, SalesHeader, true);

            if VarPTAEnquiry.HasVATAmount() then
                PTAConvertEnquiryToDocuments.CreateAndCalculateVATToleranceOnSalesOrder(SalesHeader);

            PTAConvertEnquiryToDocuments.CreateRelatedPurchaseOrder(VarPTAEnquiry, SalesHeader);
            PTAConvertEnquiryToDocuments.GetAllPurchaseOrdersCreated(SalesHeader, TempPurchaseOrders);
            PTAConvertEnquiryToDocuments.CreateAndCalculateVATToleranceOnPurchaseOrder(VarPTAEnquiry, TempPurchaseOrders);
            PTAConvertEnquiryToDocuments.UpdateUnitCostsOnSalesLineFromPurchaseOrders(SalesHeader);
        end;
    end;

    local procedure CreateOrUpdateSalesLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    begin
        GetLastSalesLineNumberToInsertNewRecords(SalesHeader);
        CreateOrUpdateEnquiryProductLines(VarPTAEnquiry, SalesHeader);
        CreateOrUpdateEnquiryAddCostLines(VarPTAEnquiry, SalesHeader);
        CreateOrUpdateEnquiryAddServiceLines(VarPTAEnquiry, SalesHeader);

        if OneOfTheDimensionhasChanged then
            PTAConvertEnquiryToDocuments.SetHeaderDetailsOnAllSalesLines(SalesHeader, SalesHeader.FieldNo("Dimension Set ID"));
    end;

    local procedure CreateOrUpdateEnquiryProductLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PreviousPTAEnquiryProducts: Record PTAEnquiryProducts;
        CustomerBrokerComm: Decimal;
        SalesLine: Record "Sales Line";
        EntireLineValidated: Boolean;
        NewRecordRef, OldRecordRef : Recordref;

    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if PTAEnquiryProducts.FindFirst() then begin
            repeat
                EntireLineValidated := false;
                if PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::Products, PTAEnquiryProducts.ID, Format(VarPTAEnquiry.EnquiryNumber), SalesLine) then begin
                    IF (PTAEnquiryProducts.DeliveredQuantity <> 0) or (PTAEnquiryProducts.SellMax <> 0) THEN begin
                        PTAConvertEnquiryToDocuments.SetLineNo(SalesLineNo);
                        SalesLineNo += 10000;
                        PTAConvertEnquiryToDocuments.CreateSingleSalesOrderProductLine(VarPTAEnquiry, PTAEnquiryProducts, SalesHeader);
                    end
                end else begin
                    SalesLine.FindFirst();
                    PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryProductByID(PTAEnquiryProducts, PreviousPTAEnquiryProducts, PTAEnquiryProducts.ID);
                    NewRecordRef.gettable(PTAEnquiryProducts);
                    OldRecordRef.GetTable(PreviousPTAEnquiryProducts);

                    if PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiryProducts) then begin
                        if PreviousPTAEnquiryProducts.ProductId <> PTAEnquiryProducts.ProductId then begin
                            DecouplePurchaseLineToSalesLine(SalesLine);
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineCode(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineQuantity(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineUnitPrice(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineUnitCost(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
                            EntireLineValidated := true;
                        end;

                        if ((PTAEnquiryProducts.DeliveredQuantity <> PreviousPTAEnquiryProducts.DeliveredQuantity) or
                                (PTAEnquiryProducts.DeliveryUnitId <> PreviousPTAEnquiryProducts.DeliveryUnitId) or
                                (PTAEnquiryProducts.SellMax <> PreviousPTAEnquiryProducts.SellMax) or
                                (PTAEnquiryProducts.SellUnitId <> PreviousPTAEnquiryProducts.SellUnitId) or
                                (PTAEnquiryProducts.SellPriceUOMId <> PreviousPTAEnquiryProducts.SellPriceUOMId) or
                                (PTAEnquiryProducts.SellPrice <> PreviousPTAEnquiryProducts.SellPrice) or
                                (PTAEnquiryProducts.OwnCommission <> PreviousPTAEnquiryProducts.OwnCommission)) and (NOT EntireLineValidated) then begin
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineQuantity(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineUnitPrice(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
                        end;


                        if ((PreviousPTAEnquiryProducts.BuyPrice <> PTAEnquiryProducts.BuyPrice) OR
                        (PreviousPTAEnquiryProducts.BuyPriceUOMId <> PTAEnquiryProducts.BuyPriceUOMId)) and (NOT EntireLineValidated) then
                            PTAConvertEnquiryToDocuments.SetEnquiryProductLineUnitCost(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);

                        PTAConvertEnquiryToDocuments.UpdateSalesLineDetailsFromEnquiryProducts(SalesLine, PTAEnquiryProducts, VarPTAEnquiry, SalesHeader);

                        if Not EntireLineValidated then begin
                            if ((PreviousPTAEnquiryProducts.SupplierId <> PTAEnquiryProducts.SupplierId) OR (PreviousPTAEnquiryProducts.BuyCurrencyId <> PTAEnquiryProducts.BuyCurrencyId)) then
                                HandleSalesLineSupplierUpdateForEnquiry(SalesLine, PreviousPTAEnquiryProducts.SupplierId, PreviousPTAEnquiryProducts.BuyCurrencyId, PreviousPTAEnquiryProducts.BuyPriceUOMId)
                            else
                                HandleSalesLineOtherFieldsUpdateForEnquiry(SalesLine, SalesHeader);
                        end;

                        SalesLine.Modify();
                    end;
                end;
            Until PTAEnquiryProducts.next = 0;

        end;
    end;

    local procedure CreateOrUpdateEnquiryAddCostLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        PreviousPTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        SalesLine: Record "Sales Line";
        PTAConvertEnquiryToDocuments: Codeunit PTAEnquiryConvertToDocuments;
        EntireLineValidated: Boolean;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryAdditionalCost.Reset();
        PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if PTAEnquiryAdditionalCost.FindFirst() then
            repeat
                EntireLineValidated := false;
                if PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAEnquiryAdditionalCost.ID, Format(VarPTAEnquiry.EnquiryNumber), SalesLine) then begin
                    IF (PTAEnquiryAdditionalCost.SellIsApplicable) OR (PTAEnquiryAdditionalCost.BuyIsApplicable) THEN begin
                        PTAConvertEnquiryToDocuments.SetLineNo(SalesLineNo);
                        SalesLineNo += 10000;
                        PTAConvertEnquiryToDocuments.CreateSingleEnquiryAdditionalCostLine(VarPTAEnquiry, PTAEnquiryAdditionalCost, SalesHeader)
                    end
                end else begin
                    SalesLine.FindFirst();
                    PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryAdditionalCostByID(PTAEnquiryAdditionalCost, PreviousPTAEnquiryAdditionalCost, PTAEnquiryAdditionalCost.ID);
                    NewRecordRef.gettable(PTAEnquiryAdditionalCost);
                    OldRecordRef.GetTable(PreviousPTAEnquiryAdditionalCost);

                    if PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiryAdditionalCost) then begin
                        IF ((Not PTAEnquiryAdditionalCost.SellIsApplicable) AND (Not PTAEnquiryAdditionalCost.BuyIsApplicable)) THEN begin
                            if SalesLine."PTA Related PO" <> '' then
                                DecouplePurchaseLineToSalesLine(SalesLine);
                            SalesLine.Delete();
                        end else begin
                            if ((PreviousPTAEnquiryAdditionalCost.AdditionalCostDetailsId <> PTAEnquiryAdditionalCost.AdditionalCostDetailsId) OR (PreviousPTAEnquiryAdditionalCost.SellUOMId <> PTAEnquiryAdditionalCost.SellUOMId)) then begin
                                DecouplePurchaseLineToSalesLine(SalesLine);
                                PTAConvertEnquiryToDocuments.SetEnquiryEnquiryAdditionalCostCode(PTAEnquiryAdditionalCost, SalesLine, SalesHeader);
                                PTAConvertEnquiryToDocuments.SetEnquiryAdditionalCostUnitPrice(PTAEnquiryAdditionalCost, SalesLine, SalesHeader);
                                PTAConvertEnquiryToDocuments.SetEnquiryAdditionalCostUnitCost(PTAEnquiryAdditionalCost, SalesLine, SalesHeader);
                                EntireLineValidated := true
                            end;
                            if ((PreviousPTAEnquiryAdditionalCost.SellIsApplicable <> PTAEnquiryAdditionalCost.SellIsApplicable) OR
                                 (PreviousPTAEnquiryAdditionalCost.BuyIsApplicable <> PTAEnquiryAdditionalCost.BuyIsApplicable) or
                                 (PreviousPTAEnquiryAdditionalCost.NativeSellExposure <> PTAEnquiryAdditionalCost.NativeSellExposure) or
                                 (PreviousPTAEnquiryAdditionalCost.NativeBuyExposure <> PTAEnquiryAdditionalCost.NativeBuyExposure)) and (NOT EntireLineValidated) then Begin
                                PTAConvertEnquiryToDocuments.SetEnquiryAdditionalCostUnitPrice(PTAEnquiryAdditionalCost, SalesLine, SalesHeader);
                                PTAConvertEnquiryToDocuments.SetEnquiryAdditionalCostUnitCost(PTAEnquiryAdditionalCost, SalesLine, SalesHeader);
                            end;

                            PTAConvertEnquiryToDocuments.UpdateSalesLineDetailsFromEnquiryAdditionCosts(SalesLine, PTAEnquiryAdditionalCost, VarPTAEnquiry, SalesHeader);

                            if Not EntireLineValidated then begin
                                if ((PTAEnquiryAdditionalCost.SupplierId <> PreviousPTAEnquiryAdditionalCost.SupplierId) OR (PTAEnquiryAdditionalCost.BuyCurrencyId <> PreviousPTAEnquiryAdditionalCost.BuyCurrencyId)) then
                                    HandleSalesLineSupplierUpdateForEnquiry(SalesLine, PTAEnquiryAdditionalCost.SupplierId, PTAEnquiryAdditionalCost.BuyCurrencyId, PTAEnquiryAdditionalCost.BuyUOMId)
                                else
                                    HandleSalesLineOtherFieldsUpdateForEnquiry(SalesLine, SalesHeader);
                            end;
                            SalesLine.modify(true);
                        end;
                    end;
                end;
            until PTAEnquiryAdditionalCost.Next() = 0;
    end;

    local procedure CreateOrUpdateEnquiryAddServiceLines(VarPTAEnquiry: Record PTAEnquiry; var
                                                                                               SalesHeader: Record "Sales Header")
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        PreviousPTAEnquiryAddServices: Record PTAEnquiryAddServices;
        EvaluateQuantity: Decimal;
        SalesLine: Record "Sales Line";
        EntireLineValidated: Boolean;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        PTAEnquiryAddServices.SetRange("Is VAT/GST Service", False);
        if PTAEnquiryAddServices.FindFirst() then
            repeat
                EntireLineValidated := false;
                Evaluate(EvaluateQuantity, PTAEnquiryAddServices.Quantity);
                if PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalServices, PTAEnquiryAddServices.ID, Format(VarPTAEnquiry.EnquiryNumber), SalesLine) then begin
                    if EvaluateQuantity <> 0 then begin
                        PTAConvertEnquiryToDocuments.SetLineNo(SalesLineNo);
                        SalesLineNo += 10000;
                        PTAConvertEnquiryToDocuments.CreateSingleAdditionalServiceLine(VarPTAEnquiry, PTAEnquiryAddServices, SalesHeader)
                    end
                end else begin
                    SalesLine.FindFirst();
                    PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryServiceByID(PTAEnquiryAddServices, PreviousPTAEnquiryAddServices, PTAEnquiryAddServices.ID);
                    NewRecordRef.gettable(PTAEnquiryAddServices);
                    OldRecordRef.GetTable(PreviousPTAEnquiryAddServices);

                    if PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiryAddServices) then begin
                        if (PreviousPTAEnquiryAddServices.ProductId <> PTAEnquiryAddServices.ProductId) or (PreviousPTAEnquiryAddServices.UOMId <> PTAEnquiryAddServices.UOMId) then begin
                            DecouplePurchaseLineToSalesLine(SalesLine);
                            PTAConvertEnquiryToDocuments.SetEnquiryEnquiryAdditionalServiceCode(PTAEnquiryAddServices, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryAdditionalServiceQuantity(PTAEnquiryAddServices, SalesLine);
                            PTAConvertEnquiryToDocuments.SetEnquiryAdditionalServiceUnitPrice(PTAEnquiryAddServices, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryAdditionalServiceUnitCost(PTAEnquiryAddServices, SalesLine, SalesHeader);
                            EntireLineValidated := true
                        end;

                        if ((PreviousPTAEnquiryAddServices.Quantity <> PTAEnquiryAddServices.Quantity) or
                            (PreviousPTAEnquiryAddServices.SellRate <> PTAEnquiryAddServices.SellRate) OR
                            (PreviousPTAEnquiryAddServices.BuyRate <> PTAEnquiryAddServices.BuyRate) or
                            (PreviousPTAEnquiryAddServices.NativeBuyExposure <> PTAEnquiryAddServices.NativeBuyExposure) or
                            (PreviousPTAEnquiryAddServices.NativeSellExposure <> PTAEnquiryAddServices.NativeSellExposure)) and (NOT EntireLineValidated) then begin
                            PTAConvertEnquiryToDocuments.SetEnquiryAdditionalServiceQuantity(PTAEnquiryAddServices, SalesLine);
                            PTAConvertEnquiryToDocuments.SetEnquiryAdditionalServiceUnitPrice(PTAEnquiryAddServices, SalesLine, SalesHeader);
                            PTAConvertEnquiryToDocuments.SetEnquiryAdditionalServiceUnitCost(PTAEnquiryAddServices, SalesLine, SalesHeader);
                        end;

                        PTAConvertEnquiryToDocuments.UpdateSalesLineDetailsFromEnquiryServices(SalesLine, PTAEnquiryAddServices, VarPTAEnquiry, SalesHeader);
                        if Not EntireLineValidated then begin
                            if ((PTAEnquiryAddServices.SupplierId <> PreviousPTAEnquiryAddServices.SupplierId) OR (PTAEnquiryAddServices.CurrencyId <> PreviousPTAEnquiryAddServices.CurrencyId)) then
                                HandleSalesLineSupplierUpdateForEnquiry(SalesLine, PTAEnquiryAddServices.SupplierId, PTAEnquiryAddServices.CurrencyId, PTAEnquiryAddServices.UOMId)
                            else
                                HandleSalesLineOtherFieldsUpdateForEnquiry(SalesLine, SalesHeader);
                        end;
                        SalesLine.Modify();
                    end;
                end;
            until PTAEnquiryAddServices.Next() = 0;
    end;

    local procedure GetLastSalesLineNumberToInsertNewRecords(SalesHeader: Record "Sales Header")
    var
        salesline: Record "Sales Line";
    begin
        SalesLine.ReadIsolation := SalesLine.ReadIsolation::ReadCommitted;
        SalesLine.Reset();
        SalesLine.setrange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.setrange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            SalesLineNo := salesline."Line No." + 10000
        else
            SalesLineNo := 10000;
    end;

    Procedure DecouplePurchaseLineToSalesLine(var SalesLine: Record "Sales Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
    begin
        if SalesLine."PTA Related PO" = '' then EXIT;
        PurchaseHeader.get(PurchaseHeader."Document Type"::Order, SalesLine."PTA Related PO");
        if PurchaseHeader.Status <> PurchaseHeader.status::Open then
            ReleasePurchaseDocument.Reopen(PurchaseHeader);
        PurchaseLine.get(PurchaseLine."Document Type"::Order, SalesLine."PTA Related PO", SalesLine."PTA Related PO line No.");
        PurchaseLine.delete();
        SalesLine."PTA Related PO" := '';
        SalesLine."PTA Related PO line No." := 0;
    end;

    local procedure HandleSalesLineSupplierUpdateForEnquiry(var SalesLine: Record "Sales Line"; SupplierId: Integer; BuyCurrencyId: Integer; BuyPriceUOMId: Integer);
    begin
        DecouplePurchaseLineToSalesLine(SalesLine);
        SalesLine."PTA Purch. Currency ID" := BuyCurrencyId;
        SalesLine."PTA Purch. Currency Code" := PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(BuyCurrencyId);
        SalesLine."PTA Vendor ID" := SupplierId;
        SalesLine."PTA Vendor Code" := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(SupplierId);
        SalesLine."PTA Purch. Price UOM" := PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(BuyPriceUOMId);
    end;

    local procedure HandleSalesLineOtherFieldsUpdateForEnquiry(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        if SalesLine."PTA Related PO" = '' then exit;
        PurchaseHeader.get(PurchaseHeader."Document Type"::Order, SalesLine."PTA Related PO");
        PurchaseLine.get(PurchaseLine."Document Type"::Order, SalesLine."PTA Related PO", SalesLine."PTA Related PO line No.");
        PurchaseLine.SetHasBeenShown;
        // if (SalesLine."Location Code" <> PurchaseLine."Location Code") OR
        //         (SalesLine."Unit Cost (LCY)" <> PurchaseLine."Direct Unit Cost") OR
        //             (SalesLine."Quantity (Base)" <> PurchaseLine."Quantity (Base)") then
        PTAConvertEnquiryToDocuments.SetPurchaseLineFromSalesLine(PurchaseHeader, PurchaseLine, SalesLine);

        PTAConvertEnquiryToDocuments.TransStaticfldsFromSalesToPurchLine(SalesLine, PurchaseLine);
        PurchaseLine.Modify();
    end;

    local procedure ProcessAnyHardDeleteLines(VarPTAEnquiry: Record PTAEnquiry; SalesHeader: Record "Sales Header")
    begin
        CheckAndHardDeleteEnquiryProductLine(VarPTAEnquiry);
        CheckAndHardDeleteEnquiryAddCostLine(VarPTAEnquiry);
        CheckAndHardDeleteEnquiryService(VarPTAEnquiry);
    end;

    local procedure CheckAndHardDeleteEnquiryProductLine(VarPTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryProducts, PreviousPTAEnquiryProducts : Record PTAEnquiryProducts;
    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if Not PTAEnquiryProducts.FindFirst() then begin
            PTAEnquiryProducts.Init;
            PTAEnquiryProducts.EnquiryId := VarPTAEnquiry.ID;
            PTAEnquiryProducts.TransactionBatchId := VarPTAEnquiry.TransactionBatchId;
        end;
        PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryProductByID(PTAEnquiryProducts, PreviousPTAEnquiryProducts, 0);

        if PreviousPTAEnquiryProducts.FindFirst() then
            repeat
                PTAEnquiryProducts.SetRange(id, PreviousPTAEnquiryProducts.ID);
                if NOT PTAEnquiryProducts.FindFirst() then begin
                    CheckAndDeleteLine(VarPTAEnquiry.EnquiryNumber, PreviousPTAEnquiryProducts.ID, Enum::"PTA Enquiry Entities"::Products);
                end;
            until PreviousPTAEnquiryProducts.next = 0;
    end;

    local procedure CheckAndHardDeleteEnquiryAddCostLine(VarPTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryAdditionalCost, PreviousPTAEnquiryAdditionalCost : Record PTAEnquiryAdditionalCost;
    begin
        PTAEnquiryAdditionalCost.Reset();
        PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if Not PTAEnquiryAdditionalCost.FindFirst() then begin
            PTAEnquiryAdditionalCost.Init;
            PTAEnquiryAdditionalCost.EnquiryId := VarPTAEnquiry.ID;
            PTAEnquiryAdditionalCost.TransactionBatchId := VarPTAEnquiry.TransactionBatchId;
        end;
        PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryAdditionalCostByID(PTAEnquiryAdditionalCost, PreviousPTAEnquiryAdditionalCost, 0);

        if PreviousPTAEnquiryAdditionalCost.FindFirst() then
            repeat
                PTAEnquiryAdditionalCost.SetRange(id, PreviousPTAEnquiryAdditionalCost.ID);
                if NOT PTAEnquiryAdditionalCost.FindFirst() then begin
                    CheckAndDeleteLine(VarPTAEnquiry.EnquiryNumber, PreviousPTAEnquiryAdditionalCost.ID, Enum::"PTA Enquiry Entities"::AdditionalCosts);
                end;
            until PreviousPTAEnquiryAdditionalCost.next = 0;
    end;

    local procedure CheckAndHardDeleteEnquiryService(VarPTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryAddServices, PreviousPTAEnquiryAddServices : Record PTAEnquiryAddServices;
    begin
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if Not PTAEnquiryAddServices.FindFirst() then begin
            PTAEnquiryAddServices.Init;
            PTAEnquiryAddServices.EnquiryId := VarPTAEnquiry.ID;
            PTAEnquiryAddServices.TransactionBatchId := VarPTAEnquiry.TransactionBatchId;
        end;
        PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryServiceByID(PTAEnquiryAddServices, PreviousPTAEnquiryAddServices, 0);

        if PreviousPTAEnquiryAddServices.FindFirst() then
            repeat
                PTAEnquiryAddServices.SetRange(id, PreviousPTAEnquiryAddServices.ID);
                if NOT PTAEnquiryAddServices.FindFirst() then begin
                    CheckAndDeleteLine(VarPTAEnquiry.EnquiryNumber, PreviousPTAEnquiryAddServices.ID, Enum::"PTA Enquiry Entities"::AdditionalServices);
                end;
            until PreviousPTAEnquiryAddServices.next = 0;
    end;

    local procedure CheckAndDeleteLine(EnquiryID: Integer; LineEntityID: Integer; LineEntityType: Enum "PTA Enquiry Entities")
    var
        VarSalesLine: Record "Sales Line";
        VarPurchaseLine: Record "Purchase Line";
    begin
        VarSalesLine.reset;
        VarSalesLine.SetRange("Document Type", VarSalesLine."Document Type"::Order);
        VarSalesLine.SetRange("Document No.", Format(EnquiryID));
        VarSalesLine.SetRange("PTA Line Entity Type", LineEntityType);
        VarSalesLine.setrange("PTA Line Entity ID", LineEntityID);
        if VarSalesLine.FindFirst() then begin
            if VarSalesLine."PTA Related PO" <> '' then
                if VarPurchaseLine.get(VarPurchaseLine."Document Type"::ORder, VarSalesLine."PTA Related PO", VarSalesLine."PTA Related PO line No.") then
                    VarPurchaseLine.Delete();
            VarSalesLine.Delete();
        end;
    end;


    var
        PTAEnquiry: Record PTAEnquiry;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAHelperFunctions: codeunit "PTA Helper Functions";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        HeaderEntryNo, SalesLineNo : Integer;
        PTASetup: Record "PTA Setup";
        TotalOrderQty: Decimal;
        PTAConvertEnquiryToDocuments: Codeunit PTAEnquiryConvertToDocuments;
        PTAProcessEnquiries: Codeunit PTAEnquiryProcess;
        OneOfTheDimensionhasChanged: Boolean;
        HasAnythgingRelevantChangedForPOs: Boolean;
        ChangedPurchaseOrders: List of [Code[20]];
        ReporcessEnquiry: Boolean;
}
