codeunit 70022 PTAEnquiryConvertToDocuments
{
    TableNo = PTAEnquiry;

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        PTAEnquiry := Rec;
        SkipVATToleranceCheck := false;

        if Not PTAEnquiryFunctions.EnquiryExists(Format(PTAEnquiry.EnquiryNumber)) then
            CreateEnquiry(PTAEnquiry, SalesHeader)
        else begin
            if PTAProcessEnquiryForBC.PTAProcessEnquiryForBC(PTAEnquiry) then begin
                if NOT PTAReprocessEnquiryToDocuments.run(PTAEnquiry) then
                    Error(StrSubstNo('Error Reprocessing - %1', GetLastErrorText()))
            end else
                exit;
        end;
    end;

    procedure CreateEnquiry(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        TempPurchaseOrders: Record "Purchase Header" temporary;
    begin
        GetPTASetup();
        SalesLineNo := 10000;
        CreateSalesHeader(VarPTAEnquiry, SalesHeader);
        CreateSalesLines(VarPTAEnquiry, SalesHeader);
        CreateSalesBrokerCommissionLines(VarPTAEnquiry, SalesHeader, false);

        CreateAndCalculateVATToleranceOnSalesOrder(SalesHeader);

        if SalesHeader."No." <> '' then begin
            CreateRelatedPurchaseOrder(VarPTAEnquiry, SalesHeader);
            GetAllPurchaseOrdersCreated(SalesHeader, TempPurchaseOrders);
            CreateAndCalculateVATToleranceOnPurchaseOrder(VarPTAEnquiry, TempPurchaseOrders);
            UpdateUnitCostsOnSalesLineFromPurchaseOrders(SalesHeader);
        end;
    end;

    procedure CreateSalesHeader(VarPTAEnquiry: Record PTAEnquiry; Var SalesHeader: Record "Sales Header")
    var
    begin
        InitSalesHeaderCreation(VarPTAEnquiry, SalesHeader);
        SetCustomerDetailsOnSalesHeader(VarPTAEnquiry, SalesHeader);
        SetSalesHeaderDates(VarPTAEnquiry, SalesHeader);
        SetLocationDetailsOnSalesHeader(VarPTAEnquiry, SalesHeader);
        CheckAndUpdateSalesVATDetailsFromLocation(VarPTAEnquiry, SalesHeader);
        UpdateSalesHeaderWithPTAEnquiryFields(VarPTAEnquiry, SalesHeader);
        InsertAndUpdateDimensionsOnSalesHeader(SalesHeader, VarPTAEnquiry);
        SalesHeader.Modify(true);
        SalesLineNo := 10000;
    end;

    procedure InitSalesHeaderCreation(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Init();
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.SetHideCreditCheckDialogue(true);
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader."No." := Format(VarPTAEnquiry.EnquiryNumber);
        SalesHeader.validate("External Document No.", format(VarPTAEnquiry.EnquiryNumber));
        SalesHeader."PTA Enquiry ID" := VarPTAEnquiry.ID;
        SalesHeader."PTA Enquiry Number" := VarPTAEnquiry.EnquiryNumber;
        SalesHeader.Insert(true);
    end;

    procedure SetCustomerDetailsOnSalesHeader(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    begin
        if VarPTAEnquiry.BusinessAreaId = 2 then
            SalesHeader.validate("Sell-to Customer No.", PTABCMappingtoIndexID.GetCustomerCodeFromPTAIndedID(VarPTAEnquiry.SupplierId))
        else
            SalesHeader.validate("Sell-to Customer No.", PTABCMappingtoIndexID.GetCustomerCodeFromPTAIndedID(VarPTAEnquiry.CustomerId));
        SalesHeader.validate("Salesperson Code", PTABCMappingtoIndexID.GetSalespersonFromPTAIndexID(VarPTAEnquiry.CreatedBy));
    end;

    procedure SetLocationDetailsOnSalesHeader(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        Location: Record Location;
    begin
        Location.get(PTABCMappingtoIndexID.GetLocationFromPTAIndexID(VarPTAEnquiry.EnquiryPort));
        IF VarPTAEnquiry.BusinessAreaId = 3 THEN
            IF (Location."PTA Port Grouping" <> '') THEN
                Location.GET(Location."PTA Port Grouping");

        if SalesHeader."Location Code" <> Location.Code then
            SalesHeader.validate("Location Code", Location.Code);
    end;

    procedure SetSalesHeaderDates(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        DeliveryDate: Date;
    begin
        DeliveryDate := DT2DATE(VarPTAEnquiry.ETD);
        if DeliveryDate = 0D then DeliveryDate := DT2DATE(VarPTAEnquiry.EnquiryDate);
        SalesHeader.VALIDATE("Posting Date", DeliveryDate);
        SalesHeader.VALIDATE("Document Date", DeliveryDate);
        SalesHeader.VALIDATE("Shipment Date", DeliveryDate);
        SalesHeader.VALIDATE("Promised Delivery Date", 0D);
        SalesHeader.VALIDATE("Order Date", DT2DATE(VarPTAEnquiry.EnquiryDate));
        SalesHeader.VALIDATE("Requested Delivery Date", DeliveryDate);
        SalesHeader.VALIDATE("Promised Delivery Date", DeliveryDate);
    end;

    procedure UpdateSalesHeaderWithPTAEnquiryFields(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader."PTA Enquiry ID" := VarPTAEnquiry.ID;
        SalesHeader."PTA Enquiry Number" := VarPTAEnquiry.EnquiryNumber;
        SalesHeader."PTA Linked Deal ID" := VarPTAEnquiry.LinkedDealId;
        SalesHeader."PTA Linked Deal No." := VarPTAEnquiry.LinkedDealNumber;
        SalesHeader."PTA Vessel Name" := copystr(VarPTAEnquiry.VesselName, 1, MaxStrLen(SalesHeader."PTA Vessel Name"));
        SalesHeader."Send IC Document" := FALSE;
        SalesHeader."Sell-to IC Partner Code" := '';
        SalesHeader."Bill-to IC Partner Code" := '';
    end;

    procedure InsertAndUpdateDimensionsOnSalesHeader(var SalesHeader: Record "Sales Header"; VarPTAEnquiry: Record PTAEnquiry)
    var
        DimMgt: Codeunit "DimensionManagement";
    begin
        if VarPTAEnquiry.BusinessAreaId <> 0 then begin
            if VarPTAEnquiry.LinkedDealId = 0 then
                AddAndCreateDimensions(SalesHeader, PTASetup."Business Area Dimension", PTABCMappingtoIndexID.GetBusinessAreaDimensionByPTAIndexID(VarPTAEnquiry.BusinessAreaId))
            else begin
                If PTAHelperFunctions.BothDealsAreTrading(VarPTAEnquiry) then
                    AddAndCreateDimensions(SalesHeader, PTASetup."Business Area Dimension", PTABCMappingtoIndexID.GetBusinessAreaDimensionByPTAIndexID(VarPTAEnquiry.BusinessAreaId));
                if PTAHelperFunctions.OneOfTheDealIsPhysical(VarPTAEnquiry) then
                    AddAndCreateDimensions(SalesHeader, PTASetup."Business Area Dimension", PTABCMappingtoIndexID.GetBusinessAreaDimensionByPTAIndexID(3));
            end;
        end;

        if VarPTAEnquiry.EnquirySupplyRegionID <> 0 then
            AddAndCreateDimensions(SalesHeader, PTASetup."Supply Market Dimension", PTABCMappingtoIndexID.GetSupplyMarketDimensionByPTAIndexID(VarPTAEnquiry.EnquirySupplyRegionID));

        if PTABCMappingtoIndexID.GetSupplyContractDimensionByPTAIndexID(VarPTAEnquiry.SupplierContractId) <> '' then
            AddAndCreateDimensions(SalesHeader, PTASetup."Supply Contract Dimension", PTABCMappingtoIndexID.GetSupplyContractDimensionByPTAIndexID(VarPTAEnquiry.SupplierContractId));

        DimMgt.UpdateGlobalDimFromDimSetID(SalesHeader."Dimension Set ID", SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code");
        PTAHelperFunctions.UpdateGlobalAndShortcutDimensionsOnSalesHeaders(SalesHeader);
        UpdateContractDimensionsOnSalesHeaders(SalesHeader);
    end;

    local procedure CreateSalesLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    begin
        CreateEnquiryProductLines(VarPTAEnquiry, SalesHeader);
        CreateEnquiryAddCostLines(VarPTAEnquiry, SalesHeader);
        CreateEnquiryAddServiceLines(VarPTAEnquiry, SalesHeader);
    end;


    local procedure CreateEnquiryProductLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        CustomerBrokerComm: Decimal;
    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if PTAEnquiryProducts.FindFirst() then begin
            if (PTAEnquiryProducts.SellCurrencyId <> 0) AND (PTAEnquiryProducts.SellCurrencyId <> PTAHelperFunctions.GetCompanyPTAPurchaseCurrency()) then
                if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.SellCurrencyId) <> '' then begin
                    if salesheader."Currency Code" <> PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.SellCurrencyId) then begin
                        SalesHeader.Validate("Currency Code", PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.SellCurrencyId));
                        SalesHeader.Modify();
                    end
                end;
            repeat
                IF (PTAEnquiryProducts.DeliveredQuantity <> 0) or (PTAEnquiryProducts.SellMax <> 0) THEN
                    CreateSingleSalesOrderProductLine(VarPTAEnquiry, PTAEnquiryProducts, SalesHeader);

            Until PTAEnquiryProducts.next = 0;
        end
    end;

    procedure CreateSingleSalesOrderProductLine(VarPTAEnquiry: Record PTAEnquiry; PTAEnquiryProducts: Record PTAEnquiryProducts; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        UnitOfMeasure: Record "Unit of Measure";
        Item: Record Item;
        UnitFactor: Decimal;
    begin
        UnitFactor := 0;
        SalesLine.init();
        SalesLine.SetHideValidationDialog(true);
        InitSalesLineDetails(SalesLine, Format(VarPTAEnquiry.EnquiryNumber));
        SetEnquiryProductLineCode(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
        SetEnquiryProductLineQuantity(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
        SetEnquiryProductLineUnitPrice(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
        SetEnquiryProductLineUnitCost(VarPTAEnquiry, PTAEnquiryProducts, SalesLine, SalesHeader);
        UpdateSalesLineDetailsFromEnquiryProducts(SalesLine, PTAEnquiryProducts, VarPTAEnquiry, SalesHeader);
        SalesLine.Modify();
    end;

    procedure SetEnquiryProductLineCode(VarPTAEnquiry: Record PTAEnquiry; PTAEnquiryProducts: Record PTAEnquiryProducts; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        Item: Record Item;
    begin
        GetPTASetup();

        Case true of
            (VarPTAEnquiry.BusinessAreaId = 2):
                begin
                    SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
                    SalesLine.VALIDATE("No.", PTASetup."Int Commission G/L Acc");
                end;
            (VarPTAEnquiry.BusinessAreaId <> 2):
                begin
                    if PTAEnquiryProducts.ProductId <> 16 then begin
                        SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                        Item.get(PTABCMappingtoIndexID.GetItemFromPTAIndexID(PTAEnquiryProducts.ProductId));
                        SalesLine.VALIDATE("No.", Item."No.");
                    end else begin
                        SalesLine.VALIDATE(Type, SalesLine.Type::Resource);
                        SalesLine.VALIDATE("No.", PTABCMappingtoIndexID.GetServiceResourceFromPTAIndexID(274));
                    end;
                end;
        end;
        if SalesHeader."PTA VAT Updated By BC" then
            if SalesLine."VAT Prod. Posting Group" <> PTASetup."Enquiry VAT Prod. Posting" then
                SalesLine.VALIDATE("VAT Prod. Posting Group", PTASetup."Enquiry VAT Prod. Posting");
    end;

    procedure SetEnquiryProductLineQuantity(VarPTAEnquiry: Record PTAEnquiry; PTAEnquiryProducts: Record PTAEnquiryProducts; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        UnitOfMeasure: Record "Unit of Measure";
        Item: Record Item;
        UnitFactor: Decimal;
    begin
        GetPTASetup();

        Case true of
            (VarPTAEnquiry.BusinessAreaId = 2):
                SalesLine.VALIDATE(Quantity, 1);
            (VarPTAEnquiry.BusinessAreaId <> 2):
                begin
                    if SalesLine.Type = SalesLine.Type::Item then begin
                        Item.get(SalesLine."No.");

                        if PTAEnquiryProducts.DeliveredQuantity <> 0 then begin
                            UnitFactor := PTAEnquiryFunctions.GetQuantityUnitFactor(SalesLine."No.", PTAEnquiryProducts.DeliveryUnitId, PTAEnquiryProducts.DeliveryDensity);
                            UnitOfMeasure.get(PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(1));
                            PTAHelperFunctions.CheckAndInsertItemUnitOfMeasure(SalesLine."No.", UnitOfMeasure.Code, 1 / UnitOfMeasure."PTA ConversionFactor");
                            if UnitFactor = 0 then UnitFactor := 1;
                            SalesLine."PTA Density Factor" := UnitFactor;

                            //if (SalesLine.Quantity = 0) OR (SalesLine.Quantity <> ROUND(PTAEnquiryProducts.DeliveredQuantity * UnitFactor, 0.001)) then
                            if (SalesLine.Quantity <> ROUND(PTAEnquiryProducts.DeliveredQuantity * UnitFactor, 0.001)) then
                                SalesLine.VALIDATE(Quantity, ROUND(PTAEnquiryProducts.DeliveredQuantity * UnitFactor, 0.001));

                            if UnitOfMeasure.Code <> SalesLine."Unit of Measure Code" then
                                SalesLine.VALIDATE(SalesLine."Unit of Measure Code", UnitOfMeasure.Code);

                            SalesLine.Validate("Qty. to Ship", ROUND(PTAEnquiryProducts.DeliveredQuantity * UnitFactor, 0.001));
                            SalesLine.validate("Qty. to Invoice", SalesLine."qty. to ship");
                            //SalesLine.validate("Qty. to Invoice", 0);
                        end else begin
                            UnitFactor := PTAEnquiryFunctions.GetQuantityUnitFactor(SalesLine."No.", PTAEnquiryProducts.SellUnitId, PTAEnquiryProducts.DeliveryDensity);
                            UnitOfMeasure.get(PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(1));
                            PTAHelperFunctions.CheckAndInsertItemUnitOfMeasure(SalesLine."No.", UnitOfMeasure.Code, 1 / UnitOfMeasure."PTA ConversionFactor");
                            if UnitFactor = 0 then UnitFactor := 1;
                            SalesLine."PTA Density Factor" := UnitFactor;

                            if SalesLine.Quantity <> ROUND(PTAEnquiryProducts.SellMax * UnitFactor, 0.001) then
                                SalesLine.VALIDATE(Quantity, ROUND(PTAEnquiryProducts.SellMax * UnitFactor, 0.001));

                            if UnitOfMeasure.Code <> SalesLine."Unit of Measure Code" then
                                SalesLine.VALIDATE(SalesLine."Unit of Measure Code", UnitOfMeasure.Code);
                            //SalesLine.Validate("Qty. to Ship", 0);
                            //SalesLine.validate("Qty. to Invoice", 0);
                            SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
                            SalesLine.validate("Qty. to Invoice", SalesLine."qty. to ship");
                        end;

                        IF (VarPTAEnquiry.BusinessAreaId = 1) AND (SalesLine.Type = SalesLine.Type::Item) And (Not Salesline."Drop Shipment") THEN BEGIN
                            SalesLine.VALIDATE("Drop Shipment", TRUE);
                            SalesLine.VALIDATE("Purchasing Code", PTASetup."Drop Ship Code");
                        END;

                    end else begin
                        UnitOfMeasure.get(PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.SellUnitId));
                        PTAHelperFunctions.CheckAndInsertResourceUnitOfMeasure(SalesLine."No.", UnitOfMeasure.Code);
                        SalesLine.Validate(Quantity, 1);
                        SalesLine.VALIDATE(SalesLine."Unit of Measure Code", UnitOfMeasure.Code);
                    end;
                end;
        end;
    end;

    procedure SetEnquiryProductLineUnitPrice(VarPTAEnquiry: Record PTAEnquiry; PTAEnquiryProducts: Record PTAEnquiryProducts; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
    begin
        Case true of
            (VarPTAEnquiry.BusinessAreaId = 2):
                begin
                    IF PTAEnquiryProducts.DeliveredQuantity <> 0 THEN
                        SalesLine.VALIDATE("Unit Price", ROUND(PTAEnquiryProducts.DeliveredQuantity * PTAEnquiryProducts.OwnCommission, 0.01))
                    ELSE
                        SalesLine.VALIDATE("Unit Price", ROUND(PTAEnquiryProducts.SellMax * PTAEnquiryProducts.OwnCommission, 0.01));

                    // IF SalesHeader."Currency Factor" <> 0 THEN
                    //     SalesLine.VALIDATE("Unit Price", SalesLine."Unit Price" / SalesHeader."Currency Factor");
                end;
            (VarPTAEnquiry.BusinessAreaId <> 2):
                SetProductSalesLineUnitPrice(PTAEnquiryProducts, SalesLine, SalesHeader)
        end;
    end;

    procedure SetEnquiryProductLineUnitCost(VarPTAEnquiry: Record PTAEnquiry; PTAEnquiryProducts: Record PTAEnquiryProducts; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
    begin
        Case true of
            (VarPTAEnquiry.BusinessAreaId = 2):
                SalesLine.VALIDATE(SalesLine."Unit Cost (LCY)", 0);
            (VarPTAEnquiry.BusinessAreaId <> 2):
                SetProductSalesLineUnitCost(PTAEnquiryProducts, SalesLine, SalesHeader)
        end;
    end;

    local procedure SetProductSalesLineUnitPrice(PTAEnquiryProducts: Record PTAEnquiryProducts; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        UnitOfMeasure: Record "Unit of Measure";
        UnitFactor: decimal;
        Item: Record Item;
    begin
        UnitFactor := 0;
        if SalesLine.Type = SalesLine.Type::item then begin
            IF (PTAEnquiryProducts.SellPriceUOMId <> 1) THEN begin
                UnitFactor := PTAEnquiryFunctions.GetQuantityUnitFactor(SalesLine."No.", PTAEnquiryProducts.SellPriceUOMId, PTAEnquiryProducts.DeliveryDensity);
                SalesLine."PTA Density Factor" := UnitFactor;
                SalesLine.VALIDATE("Unit Price", ROUND(PTAEnquiryProducts.SellPrice / UnitFactor, 0.01));
            end else
                SalesLine.VALIDATE("Unit Price", PTAEnquiryProducts.SellPrice);
        end else
            SalesLine.VALIDATE("Unit Price", PTAEnquiryProducts.SellPrice);

        // IF SalesHeader."Currency Factor" <> 0 THEN
        //     SalesLine.VALIDATE("Unit Price", SalesLine."Unit Price" / SalesHeader."Currency Factor");
    end;

    local procedure SetProductSalesLineUnitCost(PTAEnquiryProducts: Record PTAEnquiryProducts; VAR SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        UnitOfMeasure: Record "Unit of Measure";
        UnitFactor: decimal;
        Item: Record Item;
    begin
        UnitFactor := 0;
        if SalesLine.Type = SalesLine.Type::item then begin
            IF (PTAEnquiryProducts.BuyPriceUOMId <> 1) THEN begin
                UnitFactor := PTAEnquiryFunctions.GetQuantityUnitFactor(SalesLine."No.", PTAEnquiryProducts.BuyPriceUOMId, PTAEnquiryProducts.DeliveryDensity);
                SalesLine."PTA Density Factor" := UnitFactor;
                SalesLine.VALIDATE("Unit Cost (LCY)", ROUND(PTAEnquiryProducts.BuyPrice / UnitFactor, 0.01));
            end else
                SalesLine.VALIDATE("Unit Cost (LCY)", PTAEnquiryProducts.BuyPrice);
        end else
            SalesLine.VALIDATE("Unit Cost (LCY)", PTAEnquiryProducts.BuyPrice);

        // IF SalesHeader."Currency Factor" <> 0 THEN
        //     SalesLine.VALIDATE("Unit Cost (LCY)", SalesLine."Unit Cost (LCY)" / SalesHeader."Currency Factor");
    End;

    local procedure CreateEnquiryAddCostLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
    begin
        PTAEnquiryAdditionalCost.Reset();
        PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if PTAEnquiryAdditionalCost.FindFirst() then
            repeat
                IF (PTAEnquiryAdditionalCost.SellIsApplicable) OR (PTAEnquiryAdditionalCost.BuyIsApplicable) THEN
                    CreateSingleEnquiryAdditionalCostLine(VarPTAEnquiry, PTAEnquiryAdditionalCost, SalesHeader);
            until PTAEnquiryAdditionalCost.Next() = 0;
    end;

    procedure CreateSingleEnquiryAdditionalCostLine(VarPTAEnquiry: Record PTAEnquiry; var PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.init();
        InitSalesLineDetails(SalesLine, Format(VarPTAEnquiry.EnquiryNumber));
        SetEnquiryEnquiryAdditionalCostCode(PTAEnquiryAdditionalCost, SalesLine, Salesheader);
        SetEnquiryAdditionalCostUnitPrice(PTAEnquiryAdditionalCost, SalesLine, Salesheader);
        SetEnquiryAdditionalCostUnitCost(PTAEnquiryAdditionalCost, SalesLine, Salesheader);
        UpdateSalesLineDetailsFromEnquiryAdditionCosts(SalesLine, PTAEnquiryAdditionalCost, VarPTAEnquiry, Salesheader);
        SalesLine.Modify();
    end;

    procedure SetEnquiryEnquiryAdditionalCostCode(var PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        UnitOfMeasure: Record "Unit of Measure";
        Resource: Record Resource;
    begin
        GetPTASetup();

        if PTAEnquiryAdditionalCost.AdditionalCostDetailsId <> 0 then
            Resource.get(PTABCMappingtoIndexID.GetAdditionalCostResourceFromPTAIndexID(PTAEnquiryAdditionalCost.AdditionalCostDetailsId))
        else
            Resource.get(PTABCMappingtoIndexID.GetCostTypeResourceFromPTAIndexID(PTAEnquiryAdditionalCost.CostTypeId));

        UnitOfMeasure.get(PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryAdditionalCost.SellUOMId));
        PTAHelperFunctions.CheckAndInsertResourceUnitOfMeasure(Resource."No.", UnitOfMeasure.code);
        SalesLine.VALIDATE(Type, SalesLine.Type::Resource);
        SalesLine.VALIDATE("No.", Resource."No.");
        if SalesHeader."PTA VAT Updated By BC" then
            SalesLine.VALIDATE("VAT Prod. Posting Group", PTASetup."Enquiry VAT Prod. Posting");
        SalesLine.VALIDATE(Description, Copystr(PTAEnquiryAdditionalCost.Name, 1, MaxStrLen(SalesLine.Description)));
        SalesLine.VALIDATE(SalesLine."Unit of Measure Code", UnitOfMeasure.Code);
        SalesLine.VALIDATE(Quantity, 1);
        //SalesLine.Validate("Qty. to Ship", 0);
        //SalesLine.validate("Qty. to Invoice", 0);
        SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
        SalesLine.validate("Qty. to Invoice", SalesLine."qty. to ship");

    end;

    procedure SetEnquiryAdditionalCostUnitPrice(var PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        IF PTAEnquiryAdditionalCost.SellIsApplicable THEN
            SalesLine.VALIDATE("Unit Price", PTAEnquiryAdditionalCost.NativeSellExposure);

        // IF SalesHeader."Currency Factor" <> 0 THEN
        //     SalesLine.VALIDATE("Unit Price", SalesLine."Unit Price" / SalesHeader."Currency Factor");
    end;

    procedure SetEnquiryAdditionalCostUnitCost(var PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        IF PTAEnquiryAdditionalCost.BuyIsApplicable THEN
            SalesLine.VALIDATE(SalesLine."Unit Cost (LCY)", PTAEnquiryAdditionalCost.NativeBuyExposure);

        // IF SalesHeader."Currency Factor" <> 0 THEN
        //     SalesLine.VALIDATE("Unit Cost (LCY)", SalesLine."Unit Cost (LCY)" / SalesHeader."Currency Factor");
    end;

    local procedure CreateEnquiryAddServiceLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        EvaluateQuantity: Decimal;
    begin
        GetPTASetup();

        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        PTAEnquiryAddServices.SetRange("Is VAT/GST Service", false);
        if PTAEnquiryAddServices.FindFirst() then
            repeat
                Evaluate(EvaluateQuantity, PTAEnquiryAddServices.Quantity);
                if EvaluateQuantity <> 0 then
                    CreateSingleAdditionalServiceLine(VarPTAEnquiry, PTAEnquiryAddServices, SalesHeader);
            until PTAEnquiryAddServices.Next() = 0;
    end;

    procedure CreateSingleAdditionalServiceLine(var VarPTAEnquiry: Record PTAEnquiry; var PTAEnquiryAddServices: Record PTAEnquiryAddServices; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.init();
        InitSalesLineDetails(SalesLine, Format(VarPTAEnquiry.EnquiryNumber));
        SetEnquiryEnquiryAdditionalServiceCode(PTAEnquiryAddServices, SalesLine, SalesHeader);
        SetEnquiryAdditionalServiceQuantity(PTAEnquiryAddServices, SalesLine);
        SetEnquiryAdditionalServiceUnitPrice(PTAEnquiryAddServices, SalesLine, SalesHeader);
        SetEnquiryAdditionalServiceUnitCost(PTAEnquiryAddServices, SalesLine, SalesHeader);
        UpdateSalesLineDetailsFromEnquiryServices(SalesLine, PTAEnquiryAddServices, VarPTAEnquiry, SalesHeader);
        SalesLine.MODIFY(TRUE);
    end;

    procedure SetEnquiryEnquiryAdditionalServiceCode(PTAEnquiryAddServices: Record PTAEnquiryAddServices; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        Resource: Record Resource;
        UnitOfMeasure: Record "Unit of Measure";
    begin
        GetPTASetup();

        Resource.get(PTABCMappingtoIndexID.GetServiceResourceFromPTAIndexID(PTAEnquiryAddServices.ProductId));
        UnitOfMeasure.get(PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryAddServices.UOMId));
        PTAHelperFunctions.CheckAndInsertResourceUnitOfMeasure(Resource."No.", UnitOfMeasure.Code);
        SalesLine.VALIDATE(Type, SalesLine.Type::Resource);
        SalesLine.VALIDATE("No.", Resource."No.");
        SalesLine.Description := Resource.Name;
        SalesLine.VALIDATE(SalesLine."Unit of Measure Code", PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryAddServices.UOMId));
        if SalesHeader."PTA VAT Updated By BC" then
            SalesLine.VALIDATE("VAT Prod. Posting Group", PTASetup."Enquiry VAT Prod. Posting");
    end;

    procedure SetEnquiryAdditionalServiceQuantity(PTAEnquiryAddServices: Record PTAEnquiryAddServices; var SalesLine: Record "Sales Line")
    var
    begin
        Evaluate(SalesLine.Quantity, PTAEnquiryAddServices.Quantity);
        SalesLine.VALIDATE(Quantity);
        //SalesLine.Validate("Qty. to Ship", 0);
        //SalesLine.validate("Qty. to Invoice", 0);
        SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
        SalesLine.validate("Qty. to Invoice", SalesLine."qty. to ship");
    end;

    procedure SetEnquiryAdditionalServiceUnitPrice(PTAEnquiryAddServices: Record PTAEnquiryAddServices; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
    begin
        Evaluate(SalesLine."Unit Price", PTAEnquiryAddServices.SellRate);
        SalesLine.VALIDATE("Unit Price");
        // IF SalesHeader."Currency Factor" <> 0 THEN
        //     SalesLine.VALIDATE("Unit Price", SalesLine."Unit Price" / SalesHeader."Currency Factor");
    end;

    procedure SetEnquiryAdditionalServiceUnitCost(PTAEnquiryAddServices: Record PTAEnquiryAddServices; var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
    begin
        Evaluate(SalesLine."Unit Cost (LCY)", PTAEnquiryAddServices.BuyRate);
        SalesLine.VALIDATE(SalesLine."Unit Cost (LCY)");

        // IF SalesHeader."Currency Factor" <> 0 THEN
        //     SalesLine.VALIDATE("Unit Cost (LCY)", SalesLine."Unit Cost (LCY)" / SalesHeader."Currency Factor");
    end;


    procedure AddAndCreateDimensions(var SalesHeader: Record "Sales Header"; DimensionCode: Code[20]; DimensionValueCode: Code[20])
    var
        ToAddDimensionSet: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit "DimensionManagement";
        TempDimensionSetEntry: Record "Dimension Set Entry";
    begin
        DimMgt.GetDimensionSet(ToAddDimensionSet, SalesHeader."Dimension Set ID");
        if Not ToAddDimensionSet.get(SalesHeader."Dimension Set ID", DimensionCode) then begin
            ToAddDimensionSet.init();
            ToAddDimensionSet.validate("Dimension Code", DimensionCode);
            ToAddDimensionSet.validate("Dimension Value Code", DimensionValueCode);
            ToAddDimensionSet."Dimension Set ID" := -1;
            ToAddDimensionSet.Insert();
        end else begin
            ToAddDimensionSet.validate("Dimension Value Code", DimensionValueCode);
            ToAddDimensionSet.Modify();
        end;
        SalesHeader."Dimension Set ID" := DimMgt.GetDimensionSetID(ToAddDimensionSet);
    end;

    procedure InitSalesLineDetails(var SalesLine: Record "Sales Line"; EnquiryNumber: Code[20])
    begin
        SalesLine."Document Type" := SalesLine."Document Type"::Order;
        SalesLine."Document No." := EnquiryNumber;
        SalesLine."Line No." := SalesLineNo;
        SalesLine.Insert();
        SalesLineNo += 10000;
    end;

    procedure UpdateSalesLineDetailsFromEnquiryProducts(var SalesLine: Record "Sales Line"; PTAEnquiryProducts: Record PTAEnquiryProducts; VarPTAEnquiry: Record PTAEnquiry; Salesheader: Record "Sales Header")
    begin
        SalesLine.VALIDATE("PTA BDR Del. Quantity", PTAEnquiryProducts.DeliveredQuantity);
        SalesLine.VALIDATE("PTA BDR Unit of Measure", PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.DeliveryUnitId));
        SalesLine."PTA Line Entity Type" := Enum::"PTA Enquiry Entities"::Products;
        SalesLine."PTA Line Entity ID" := PTAEnquiryProducts.ID;
        SalesLine."PTA Sell Price" := SalesLine."Unit Price";
        SalesLine."PTA Purchase Price" := PTAEnquiryProducts.BuyPrice;
        SalesLine."PTA Purch. Currency ID" := PTAEnquiryProducts.BuyCurrencyId;
        SalesLine."PTA Purch. Currency Code" := PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.BuyCurrencyId);
        SalesLine."PTA Vendor ID" := PTAEnquiryProducts.SupplierId;
        SalesLine."PTA Vendor Code" := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAEnquiryProducts.SupplierId);
        SalesLine."PTA Enquiry ID" := VarPTAEnquiry.ID;
        SalesLine."PTA Enquiry Number" := VarPTAEnquiry.EnquiryNumber;
        //SalesLine."PTA Purch. UOM Code" := PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.BuyUnitId);
        SalesLine."PTA Purch. UOM Code" := PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(1);
        SalesLine."PTA Purch. Price UOM" := PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.BuyPriceUOMId);
        SalesLine."PTA Linked Deal ID" := VarPTAEnquiry.LinkedDealId;
        SalesLine."PTA Linked Deal No." := VarPTAEnquiry.LinkedDealNumber;
        SalesLine."Description 2" := CopyStr(PTAEnquiryProducts.Specification, 1, MaxStrLen(SalesLine."Description 2"));
        SalesLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
        SalesLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
    end;

    procedure UpdateSalesLineDetailsFromEnquiryAdditionCosts(var SalesLine: Record "Sales Line"; PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; VarPTAEnquiry: Record PTAEnquiry; SalesHeader: Record "Sales Header")
    begin
        SalesLine."PTA Line Entity Type" := Enum::"PTA Enquiry Entities"::AdditionalCosts;
        SalesLine."PTA Line Entity ID" := PTAEnquiryAdditionalCost.ID;

        IF ((PTAEnquiryAdditionalCost.SellRate > 0) AND (PTAEnquiryAdditionalCost.SellLumpsum > 0) AND (PTAEnquiryAdditionalCost.BuyRate > 0) AND (PTAEnquiryAdditionalCost.FixedQuantity > 0)) THEN
            SalesLine."PTA Sell Price" := PTAEnquiryAdditionalCost.SellRate
        ELSE BEGIN
            IF PTAEnquiryAdditionalCost.SellRate > 0 THEN
                SalesLine."PTA Sell Price" := PTAEnquiryAdditionalCost.SellRate
            ELSE
                SalesLine."PTA Sell Price" := PTAEnquiryAdditionalCost.SellLumpsum;
        END;

        IF PTAEnquiryAdditionalCost.BuyIsApplicable THEN begin
            SalesLine."PTA Purchase Price" := PTAEnquiryAdditionalCost.NativeBuyExposure;
            SalesLine."PTA Purch. Currency ID" := PTAEnquiryAdditionalCost.BuyCurrencyId;
            SalesLine."PTA Purch. Currency Code" := PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryAdditionalCost.BuyCurrencyId);
            SalesLine."PTA Vendor ID" := PTAEnquiryAdditionalCost.SupplierId;
            SalesLine."PTA Vendor Code" := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAEnquiryAdditionalCost.SupplierId);
            SalesLine."PTA Purch. UOM Code" := SalesLine."Unit of Measure Code";
            SalesLine."PTA Purch. Price UOM" := PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryAdditionalCost.BuyUOMId);
        end ELSE begin
            SalesLine."PTA Purchase Price" := 0;
            SalesLine."PTA Purch. Currency ID" := 0;
            SalesLine."PTA Purch. Currency Code" := '';
            SalesLine."PTA Vendor ID" := 0;
            SalesLine."PTA Vendor Code" := '';
            SalesLine."PTA Purch. UOM Code" := '';
            SalesLine."PTA Purch. Price UOM" := '';
        end;

        SalesLine."PTA Enquiry ID" := VarPTAEnquiry.ID;
        SalesLine."PTA Enquiry Number" := VarPTAEnquiry.EnquiryNumber;
        SalesLine."PTA Linked Deal ID" := VarPTAEnquiry.LinkedDealId;
        SalesLine."PTA Linked Deal No." := VarPTAEnquiry.LinkedDealNumber;
        SalesLine.Description := CopyStr(PTAEnquiryAdditionalCost.name, 1, MaxStrLen(SalesLine.Description));
        SalesLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
        SalesLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
    end;

    procedure UpdateSalesLineDetailsFromEnquiryServices(var SalesLine: Record "Sales Line"; PTAEnquiryAddServices: Record PTAEnquiryAddServices; VarPTAEnquiry: Record PTAEnquiry; SalesHeader: Record "Sales Header")
    var
        VarbuyRate: Decimal;
    begin
        SalesLine."PTA Line Entity Type" := Enum::"PTA Enquiry Entities"::AdditionalServices;
        SalesLine."PTA Line Entity ID" := PTAEnquiryAddServices.ID;
        SalesLine."PTA Sell Price" := SalesLine."Unit Price";
        evaluate(VarbuyRate, PTAEnquiryAddServices.BuyRate);

        if (PTAEnquiryAddServices.SupplierId <> 0) AND (VarbuyRate <> 0) then begin
            SalesLine."PTA Purchase Price" := SalesLine."Unit Cost (LCY)";
            SalesLine."PTA Purch. Currency ID" := PTAEnquiryAddServices.CurrencyId;
            SalesLine."PTA Purch. Currency Code" := PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryAddServices.CurrencyId);
            SalesLine."PTA Vendor ID" := PTAEnquiryAddServices.SupplierId;
            SalesLine."PTA Vendor Code" := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAEnquiryAddServices.SupplierId);
            SalesLine."PTA Purch. UOM Code" := SalesLine."Unit of Measure Code";
            SalesLine."PTA Purch. Price UOM" := '';
        end;

        SalesLine."PTA Enquiry ID" := VarPTAEnquiry.ID;
        SalesLine."PTA Enquiry Number" := VarPTAEnquiry.EnquiryNumber;
        SalesLine."PTA Linked Deal ID" := VarPTAEnquiry.LinkedDealId;
        SalesLine."PTA Linked Deal No." := VarPTAEnquiry.LinkedDealNumber;
        SalesLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
        SalesLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
    end;

    internal procedure SetHeaderDetailsOnAllSalesLines(SalesHeader: Record "Sales Header"; FieldNo: Integer)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.LockTable();
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                case FieldNo of
                    SalesHeader.FieldNo("Location Code"):
                        SalesLine.validate("Location Code", SalesHeader."Location Code");
                    SalesHeader.FieldNo("Dimension Set ID"):
                        SalesLine.validate("Dimension Set ID", SalesHeader."Dimension Set ID");
                end;
                SalesLine.Modify();
            until SalesLine.Next() = 0
    end;

    procedure CreateRelatedPurchaseOrder(VarPTAEnquiry: Record PTAEnquiry; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        BuyCurrency, VendorID : Integer;
        PurchaseHeader: Record "Purchase Header";
        CurrencyCode, VendorCode : Code[20];
        ReleasePO: Codeunit "Release Purchase Document";
    begin
        GetPTASetup();
        SalesLineNo := 10000;
        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("PTA Enquiry ID", "PTA Vendor ID", "PTA Purch. Currency ID");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF (VarPTAEnquiry.BusinessAreaId <> 1) THEN
            SalesLine.SETRANGE(Type, SalesLine.Type::Resource);
        SalesLine.SETFILTER("Outstanding Quantity", '<>0');
        SalesLine.SETFILTER("No.", '<>%1', '');
        SalesLine.SETFILTER(SalesLine."PTA Vendor ID", '<>%1', 0);
        if not SalesLine.findfirst then exit;
        repeat
            CurrencyCode := '';
            IF ((BuyCurrency <> SalesLine."PTA Purch. Currency ID") OR (VendorID <> SalesLine."PTA Vendor ID")) THEN BEGIN
                if SalesLine."PTA Vendor ID" <> 0 then
                    VendorCode := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(SalesLine."PTA Vendor ID")
                else
                    VendorCode := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(VarPTAEnquiry.SupplierId);

                IF SalesLine."PTA Purch. Currency ID" <> 0 then
                    if SalesLine."PTA Purch. Currency ID" <> PTAHelperFunctions.GetCompanyPTAPurchaseCurrency() then
                        CurrencyCode := PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(SalesLine."PTA Purch. Currency ID");

                if SalesLine."PTA Related PO" = '' then begin
                    if PurchaseOrderNotFound(VendorCode, CurrencyCode, VarPTAEnquiry.ID, PurchaseHeader) then begin
                        InsertPurchaseHeader(VendorCode, CurrencyCode, VarPTAEnquiry, PurchaseHeader, SalesHeader, SalesLine."PTA Vendor ID", SalesLine."PTA Purch. Currency ID");
                        CopySalesheaderFieldsToPurchaseHeader(PurchaseHeader, SalesHeader);
                    end else begin
                        PurchaseHeader.FindFirst();
                        IF PurchaseHeader.Status = PurchaseHeader.Status::Released THEN
                            ReleasePO.Reopen(PurchaseHeader);
                        CopySalesheaderFieldsToPurchaseHeader(PurchaseHeader, SalesHeader);
                        SalesLineNo := GetNextLineNo(PurchaseHeader);
                    end;
                end ELSE BEGIN
                    PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, SalesLine."PTA Related PO");
                    CopySalesheaderFieldsToPurchaseHeader(PurchaseHeader, SalesHeader);
                    SalesLineNo := GetNextLineNo(PurchaseHeader);
                END
            end;

            if SalesLine."PTA Related PO" = '' then
                InsertPurchaseLine(SalesLine, PurchaseHeader);

            BuyCurrency := SalesLine."PTA Purch. Currency ID";
            VendorID := SalesLine."PTA Vendor ID";
        until SalesLine.next = 0;
    end;

    local procedure PurchaseOrderNotFound(VendorCode: Code[20]; CurrencyCode: Code[20]; EnquiryID: Integer; Var PurchHeader: Record "Purchase Header"): Boolean
    begin
        PurchHeader.reset;
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SETRANGE("PTA Enquiry ID", EnquiryID);
        PurchHeader.SETRANGE("Currency Code", CurrencyCode);
        PurchHeader.SETRANGE("Buy-from Vendor No.", VendorCode);
        exit(PurchHeader.IsEmpty);
    end;

    local procedure InsertPurchaseHeader(VendorCode: Code[20]; CurrencyCode: Code[20]; VarPTAEnquiry: Record PTAEnquiry; Var PurchHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; PTAVendorID: Integer; PTACurrencyID: Integer)
    begin
        CLEAR(PurchHeader);
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader."No." := '';
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("Buy-from Vendor No.", VendorCode);
        PurchHeader.VALIDATE("Location Code", SalesHeader."Location Code");

        IF CurrencyCode <> '' then
            PurchHeader.VALIDATE("Currency Code", CurrencyCode);

        PurchHeader.VALIDATE("Posting Date", SalesHeader."Posting Date");
        PurchHeader."PTA Vendor ID" := PTAVendorID;
        PurchHeader."PTA Purch. Currency ID" := PTACurrencyID;
        CheckAndUpdatePurchaseVATDetails(PurchHeader, SalesHeader, VarPTAEnquiry);
        PurchHeader.MODIFY;
        SalesLineNo := 10000;
    end;

    procedure CopySalesheaderFieldsToPurchaseHeader(Var PurchHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
        PurchHeader."Requested Receipt Date" := SalesHeader."Requested Delivery Date";
        PurchHeader."PTA Enquiry ID" := SalesHeader."PTA Enquiry ID";
        PurchHeader."PTA Linked Deal ID" := SalesHeader."PTA Linked Deal ID";
        PurchHeader."PTA Linked Deal No." := SalesHeader."PTA Linked Deal No.";
        PurchHeader."PTA Enquiry Number" := SalesHeader."PTA Enquiry Number";
        PurchHeader."PTA Vessel Name" := copystr(SalesHeader."PTA Vessel Name", 1, MaxStrLen(PurchHeader."PTA Vessel Name"));
        PurchHeader."Send IC Document" := FALSE;
        PurchHeader."Buy-from IC Partner Code" := '';
        PurchHeader."Pay-to IC Partner Code" := '';
        PurchHeader.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        CopySalesDimensionsToPurchase(PurchHeader, SalesHeader);
        PurchHeader.MODIFY;
    end;

    procedure CopySalesDimensionsToPurchase(Var PurchHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin
        PurchHeader."Dimension Set ID" := SalesHeader."Dimension Set ID";
        PurchHeader."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
        PurchHeader."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
        PurchHeader."STO Shortcut Dimension 3 Code" := SalesHeader."STO Shortcut Dimension 3 Code";
        PurchHeader."STO Shortcut Dimension 4 Code" := SalesHeader."STO Shortcut Dimension 4 Code";
        PurchHeader."STO Shortcut Dimension 5 Code" := SalesHeader."STO Shortcut Dimension 5 Code";
        PurchHeader."STO Shortcut Dimension 6 Code" := SalesHeader."STO Shortcut Dimension 6 Code";
        PurchHeader."STO Shortcut Dimension 7 Code" := SalesHeader."STO Shortcut Dimension 7 Code";
        PurchHeader."STO Shortcut Dimension 8 Code" := SalesHeader."STO Shortcut Dimension 8 Code";
    end;

    procedure InsertPurchaseLine(SalesLine: Record "Sales Line"; PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        ModifySalesLine: Record "Sales Line";
    begin
        InitPurchaseLine(PurchaseLine, PurchaseHeader);
        SetPurchaseLineCode(PurchaseLine, SalesLine);
        SetPurchaseLineFromSalesLine(PurchaseHeader, PurchaseLine, SalesLine);
        TransStaticfldsFromSalesToPurchLine(SalesLine, PurchaseLine);
        PurchaseLine.modify;
        SalesLineNo += 10000;

        ModifySalesLine := SalesLine;
        ModifySalesLine."Purchase Order No." := PurchaseLine."Document No.";
        ModifySalesLine."Purch. Order Line No." := PurchaseLine."Line No.";
        ModifySalesLine."PTA Related PO" := PurchaseLine."Document No.";
        ModifySalesLine."PTA Related PO Line No." := PurchaseLine."line No.";
        ModifySalesLine.Modify();
    end;

    procedure InitPurchaseLine(var PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := SalesLineNo;
        PurchaseLine.insert(true);
    end;

    procedure SetPurchaseLineCode(var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    var
        PostingSetup: Record "General Posting Setup";
    begin
        PTAHelperFunctions.CheckAndInsertItemUnitOfMeasure(PurchaseLine."No.", SalesLine."PTA Purch. UOM Code", 1);
        IF SalesLine.Type <> SalesLine.Type::Resource THEN BEGIN
            PurchaseLine.VALIDATE(Type, SalesLine.Type);
            PurchaseLine.VALIDATE("No.", SalesLine."No.");
        END
        ELSE BEGIN
            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
            IF PostingSetup.GET(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group") THEN
                PurchaseLine.VALIDATE("No.", PostingSetup."Purch. Account");
        END;
    end;

    procedure SetPurchaseLineFromSalesLine(Purchaseheader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; SalesLine: Record "Sales Line")
    begin
        PurchaseLine.VALIDATE("Location Code", SalesLine."Location Code");

        if Purchaseheader."PTA VAT Updated By BC" then begin
            GetPTASetup();
            PurchaseLine.Validate("VAT Prod. Posting Group", PTASetup."Enquiry VAT Prod. Posting");
        end;

        PurchaseLine.VALIDATE("Unit of Measure Code", SalesLine."PTA Purch. UOM Code");
        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN
            PurchaseLine.UpdateUOMQtyPerStockQty;
        IF PurchaseLine."Qty. per Unit of Measure" <> 0 THEN
            PurchaseLine.VALIDATE(Quantity, ROUND(SalesLine."Outstanding Qty. (Base)" / PurchaseLine."Qty. per Unit of Measure", 0.01))
        ELSE
            PurchaseLine.VALIDATE(Quantity, SalesLine."Outstanding Qty. (Base)");
        PurchaseLine.VALIDATE("Direct Unit Cost", SalesLine."Unit Cost (LCY)");
        //PurchaseLine.Validate("Qty. to Receive", 0);
        //PurchaseLine.Validate("Qty. to Invoice", 0);
        PurchaseLine.Validate("Qty. to Receive", PurchaseLine.Quantity);
        PurchaseLine.Validate("Qty. to Invoice", PurchaseLine."Qty. to Receive");
    end;

    procedure TransStaticfldsFromSalesToPurchLine(SalesLine: Record "Sales Line"; Var PurchaseLine: Record "Purchase Line")
    begin
        PurchaseLine."Expected Receipt Date" := SalesLine."Shipment Date";
        PurchaseLine."Bin Code" := SalesLine."Bin Code";
        PurchaseLine."Return Reason Code" := SalesLine."Return Reason Code";
        PurchaseLine.Description := Copystr(SalesLine.Description, 1, MaxStrLen(PurchaseLine.Description));
        PurchaseLine."Description 2" := Copystr(SalesLine."Description 2", 1, maxstrlen(PurchaseLine."Description 2"));

        IF SalesLine."Drop Shipment" THEN BEGIN
            PurchaseLine."Sales Order No." := SalesLine."Document No.";
            PurchaseLine."Sales Order Line No." := SalesLine."Line No.";
            PurchaseLine."Drop Shipment" := TRUE;
            PurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
        END;
        PurchaseLine."PTA Enquiry ID" := SalesLine."PTA Enquiry ID";
        PurchaseLine."PTA Enquiry Number" := SalesLine."PTA Enquiry Number";
        PurchaseLine."PTA Linked Deal ID" := salesline."PTA Line Entity ID";
        PurchaseLine."PTA Linked Deal No." := SalesLine."PTA Linked Deal No.";
        PurchaseLine."PTA Line Entity Type" := SalesLine."PTA Line Entity Type";
        PurchaseLine."PTA Line Entity ID" := SalesLine."PTA Line Entity ID";
        PurchaseLine."Dimension Set ID" := SalesLine."Dimension Set ID";
        PurchaseLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        PurchaseLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        PurchaseLine."PTA CustomerBrokerComm Line" := SalesLine."PTA CustomerBrokerComm Line";
    end;


    procedure CreateSalesBrokerCommissionLines(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header"; CheckPrevious: Boolean)
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        CustomerBrokerComm: Decimal;
    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, VarPTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, VarPTAEnquiry.TransactionBatchId);
        if PTAEnquiryProducts.FindFirst() then begin
            repeat
                IF PTAEnquiryProducts.CustomerBrokerCommision <> 0 THEN BEGIN
                    IF PTAEnquiryProducts.DeliveredQuantity <> 0 THEN
                        CustomerBrokerComm += (PTAEnquiryProducts.CustomerBrokerCommision * PTAEnquiryProducts.DeliveredQuantity)
                    ELSE
                        CustomerBrokerComm += (PTAEnquiryProducts.CustomerBrokerCommision * PTAEnquiryProducts.SellMax);
                END;
            Until PTAEnquiryProducts.next = 0;

            if CustomerBrokerComm <> 0 then
                CreateSalesBrokerCommissionLine(CustomerBrokerComm, VarPTAEnquiry, SalesHeader, PTAEnquiryProducts.BuyCurrencyId, CheckPrevious);
        end
    end;

    procedure CreateSalesBrokerCommissionLine(CustomerBrokerComm: Decimal; VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header"; BuyCurrencyId: integer; CheckPrevious: Boolean)
    var
        SalesLine: Record "Sales Line";
        PTAReprocessEnquiryToDocuments: Codeunit PTAReprocessEnquiryToDocuments;
    begin
        GetPTASetup();

        if CheckPrevious then begin
            SalesLine.Reset();
            SalesLine.setrange("Document Type", SalesLine."Document Type"::Order);
            SalesLine.setrange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
            SalesLine.SetRange("PTA CustomerBrokerComm Line", true);
            if SalesLine.FindFirst() then
                if CustomerBrokerComm = SalesLine."Unit Cost (LCY)" then
                    exit
                else begin
                    PTAReprocessEnquiryToDocuments.DecouplePurchaseLineToSalesLine(SalesLine);
                    SalesLine.delete(true);
                end;
        end;

        SalesLine.init();
        SalesLine.SetHideValidationDialog(true);
        InitSalesLineDetails(SalesLine, Format(VarPTAEnquiry.EnquiryNumber));
        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.", PTASetup."Broking Comm. G/L Account");
        if SalesHeader."PTA VAT Updated By BC" then
            SalesLine.validate("VAT Prod. Posting Group", PTASetup."Enquiry VAT Prod. Posting");

        SalesLine.VALIDATE(Quantity, 1);
        //IF SalesHeader."Currency Factor" <> 0 THEN
        //    SalesLine.VALIDATE(SalesLine."Unit Cost (LCY)", CustomerBrokerComm / SalesHeader."Currency Factor")
        //ELSE
        SalesLine.VALIDATE(SalesLine."Unit Cost (LCY)", CustomerBrokerComm);
        SalesLine.VALIDATE("Unit Price", 0);
        SalesLine."PTA Sell Price" := 0;
        SalesLine."PTA Vendor ID" := VarPTAEnquiry.CustomerBrokerId;
        SalesLine."PTA Vendor Code" := PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(VarPTAEnquiry.CustomerBrokerId);
        SalesLine."PTA Purch. Currency ID" := BuyCurrencyId;
        SalesLine."PTA CustomerBrokerComm Line" := True;
        SalesLine.MODIFY(TRUE);
    end;

    local procedure GetNextLineNo(PurchaseHeader: Record "Purchase Header"): Integer
    var
        PurchLineCheck: Record "Purchase Line";
    begin
        PurchLineCheck.RESET;
        PurchLineCheck.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchLineCheck.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchLineCheck.FINDLAST THEN
            Exit(PurchLineCheck."Line No." + 10000)
        ELSE
            exit(10000);
    end;

    local procedure GetVATSetupFromLocationCode(LocationCode: Code[20]): Code[20]
    var
        Location: Record Location;
    begin
        Location.get(LocationCode);
        if Location."PTA VAT Buss. Posting Grp." = '' then
            Error('No VAT Business Posting Group is defined for Location %1', LocationCode)
        else
            exit(Location."PTA VAT Buss. Posting Grp.")
    end;

    procedure UpdateUnitCostsOnSalesLineFromPurchaseOrders(SalesHeader: Record "Sales Header")
    var
        salesline: Record "Sales Line";
        ModifySalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
    begin
        salesline.Reset();
        salesline.SetRange("Document Type", salesline."Document Type"::Order);
        salesline.SetRange("Document No.", SalesHeader."No.");
        salesline.SetFilter(Type, '>0');
        salesline.setfilter("PTA Related PO", '<>%1', '');
        if salesline.FindSet() then
            repeat
                PurchaseLine.get(PurchaseLine."Document Type"::Order, salesline."PTA Related PO", salesline."PTA Related PO Line No.");
                ModifySalesLine := salesline;
                ModifySalesLine.validate("Unit Cost (LCY)", PurchaseLine."Unit Cost (LCY)");
                ModifySalesLine.Modify();
            until salesline.next = 0;
    end;

    procedure UpdateContractDimensionsOnSalesHeaders(var SalesHeader: Record "Sales Header")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        GetPTASetup();
        if SalesHeader."Dimension Set ID" = 0 then exit;
        if DimensionSetEntry.get(SalesHeader."Dimension Set ID", PTASetup."Supply Contract Dimension") then
            SalesHeader."PTA Contract Code" := DimensionSetEntry."Dimension Value Code";
    end;

    procedure CheckAndUpdateSalesVATDetailsFromLocation(VarPTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        //Location: Record Location;
        VatBussPostingGroup: Code[20];
    begin
        SalesHeader."PTA Sales VAT Amount" := VarPTAEnquiry.GetSellVATAmount();
        SalesHeader."PTA VAT Updated By BC" := (SalesHeader."PTA Sales VAT Amount" <> 0);
        if SalesHeader."PTA VAT Updated By BC" then begin
            VatBussPostingGroup := GetVATSetupFromLocationCode(SalesHeader."Location Code");
            if SalesHeader."VAT Bus. Posting Group" <> VatBussPostingGroup then
                SalesHeader.validate("VAT Bus. Posting Group", VatBussPostingGroup);
        end;
    end;

    procedure CreateAndCalculateVATToleranceOnSalesOrder(var SalesHeader: Record "Sales Header");
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesPost: Codeunit "Sales-Post";
        SalesLine: Record "Sales Line";
    begin

        if SalesHeader."PTA Sales VAT Amount" = 0 then exit;

        OnBeforeSalesDocumentVATValidation(SkipVATToleranceCheck);

        IF SkipVATToleranceCheck THEN exit;

        SalesHeader.CalcFields(Amount, "Amount Including VAT");
        GeneralLedgerSetup.get();
        SalesReceivablesSetup.get();

        TempVATAmountLine.DELETEALL;
        SalesLine.CalcVATAmountLines(1, SalesHeader, SalesLine, TempVATAmountLine);
        TempVATAmountLine.FINDFIRST;

        if ABS(TempVATAmountLine."VAT Amount" - SalesHeader."PTA Sales VAT Amount") > GeneralLedgerSetup."Max. VAT Difference Allowed" then
            Error(StrSubstNo('Sales VAT Difference between BC (%1) and PTA (%2) is more than allowed in General Ledger Setup', TempVATAmountLine."VAT Amount", SalesHeader."PTA Sales VAT Amount"));

        if Not SalesReceivablesSetup."Allow VAT Difference" then
            Error('VAT Difference is not allowed in Sales Setup');

        TempVATAmountLine.VALIDATE("VAT Amount", SalesHeader."PTA Sales VAT Amount");
        TempVATAmountLine."Amount Including VAT" := TempVATAmountLine."VAT Amount" + TempVATAmountLine."VAT Base";
        TempVATAmountLine.Modified := TRUE;
        TempVATAmountLine.MODIFY;

        SalesLine.UpdateVATOnLines(0, SalesHeader, SalesLine, TempVATAmountLine);
        SalesLine.UpdateVATOnLines(1, SalesHeader, SalesLine, TempVATAmountLine);
    end;

    procedure CheckAndUpdatePurchaseVATDetails(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; VarPTAEnquiry: Record PTAEnquiry);
    var
        VatBussPostingGroup: Code[20];
    begin
        Purchaseheader."PTA Purch. VAT Amount" := VarPTAEnquiry.GetBuyVATAmount(Purchaseheader."PTA Vendor ID");
        Purchaseheader."PTA VAT Updated By BC" := (Purchaseheader."PTA Purch. VAT Amount" <> 0);

        if Purchaseheader."PTA Purch. VAT Amount" <> 0 then begin
            VatBussPostingGroup := GetVATSetupFromLocationCode(PurchaseHeader."Location Code");
            if PurchaseHeader."VAT Bus. Posting Group" <> VatBussPostingGroup then
                PurchaseHeader.validate("VAT Bus. Posting Group", VatBussPostingGroup);
        end;
    end;

    procedure CreateAndCalculateVATToleranceOnPurchaseOrder(VarPTAEnquiry: Record PTAEnquiry; var TempPurchaseOrder: Record "Purchase Header" temporary);
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        PurchaseLine: Record "Purchase Line";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        PurchHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        ReleasePO: Codeunit "Release Purchase Document";
    begin
        GeneralLedgerSetup.get();
        PurchasesPayablesSetup.get();

        TempPurchaseOrder.reset;
        if TempPurchaseOrder.IsEmpty then exit;
        TempPurchaseOrder.FindFirst();
        repeat
            PurchHeader.get(PurchHeader."Document Type"::Order, TempPurchaseOrder."No.");
            PurchHeader.calcfields("PTA No. Of Lines");
            if PurchHeader."PTA No. Of Lines" = 0 then begin
                IF PurchHeader.Status = PurchHeader.Status::Released THEN
                    ReleasePO.Reopen(PurchHeader);
                PurchHeader.Delete(true);
            end else begin
                OnBeforePurchaseDocumentVATValidation(SkipVATToleranceCheck);
                PurchHeader."PTA Purch. VAT Amount" := VarPTAEnquiry.GetBuyVATAmount(PurchHeader."PTA Vendor ID");
                PurchHeader."PTA VAT Updated By BC" := (PurchHeader."PTA Purch. VAT Amount" <> 0);
                PurchHeader.modify();

                if (PurchHeader."PTA Purch. VAT Amount" <> 0) And (Not SkipVATToleranceCheck) then begin
                    PurchHeader.CalcFields(Amount, "Amount Including VAT");

                    TempVATAmountLine.DELETEALL;
                    PurchaseLine.CalcVATAmountLines(1, PurchHeader, PurchaseLine, TempVATAmountLine);
                    TempVATAmountLine.FINDFIRST;
                    if ABS(TempVATAmountLine."VAT Amount" - PurchHeader."PTA Purch. VAT Amount") > GeneralLedgerSetup."Max. VAT Difference Allowed" then
                        Error(StrSubstNo('Purchase VAT Difference between BC (%1) and PTA (%2) is more than allowed in General Ledger Setup', TempVATAmountLine."VAT Amount", PurchHeader."PTA Purch. VAT Amount"));
                    if Not PurchasesPayablesSetup."Allow VAT Difference" then
                        Error('VAT Difference is not allowed in Purchase Setup');

                    TempVATAmountLine.VALIDATE("VAT Amount", PurchHeader."PTA Purch. VAT Amount");
                    TempVATAmountLine."Amount Including VAT" := TempVATAmountLine."VAT Amount" + TempVATAmountLine."VAT Base";
                    TempVATAmountLine.Modified := TRUE;
                    TempVATAmountLine.MODIFY;
                    PurchaseLine.UpdateVATOnLines(0, PurchHeader, PurchaseLine, TempVATAmountLine);
                    PurchaseLine.UpdateVATOnLines(1, PurchHeader, PurchaseLine, TempVATAmountLine);

                end
            end;
        until TempPurchaseOrder.next = 0;
    end;

    procedure GetAllPurchaseOrdersCreated(SalesHeader: Record "Sales Header"; var
                                                                                  TempPurchaseOrders: Record "Purchase Header" temporary);

    var
        SalesLine: Record "Sales Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        TempPurchaseOrders.DeleteAll();
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetRange("PTA Enquiry ID", SalesHeader."PTA Enquiry ID");
        if PurchaseHeader.FindSet() then
            repeat
                TempPurchaseOrders.init();
                TempPurchaseOrders."Document Type" := PurchaseHeader."Document Type";
                TempPurchaseOrders."No." := PurchaseHeader."No.";
                TempPurchaseOrders.insert();
            until PurchaseHeader.next = 0;
    end;

    procedure SetLineNo(varSalesLineNo: Integer)
    begin
        SalesLineNo := varSalesLineNo;
    end;

    procedure GetPTASetup()
    begin
        if not PTASetupFound then begin
            PTASetup.Get();
            PTASetupFound := True;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesDocumentVATValidation(var SkipVATToleranceCheck: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchaseDocumentVATValidation(var SkipVATToleranceCheck: Boolean);
    begin
    end;

    var
        SkipVATToleranceCheck: Boolean;
        PTAEnquiry: Record PTAEnquiry;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAHelperFunctions: codeunit "PTA Helper Functions";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        HeaderEntryNo, SalesLineNo : Integer;
        PTASetup: Record "PTA Setup";
        PTASetupFound: Boolean;
        PTAReprocessEnquiryToDocuments: Codeunit PTAReprocessEnquiryToDocuments;
        PTAProcessEnquiries: Codeunit PTAEnquiryProcess;
        PTAProcessEnquiryForBC: Codeunit "PTA Enquiry Changed for BC";

}
