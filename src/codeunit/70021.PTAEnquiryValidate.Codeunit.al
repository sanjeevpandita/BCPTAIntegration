
codeunit 70021 PTAEnquiryValidate
{
    TableNo = PTAEnquiry;

    trigger OnRun()
    var
        PTAEnquiry: Record PTAEnquiry;
    begin
        PTAEnquiry := Rec;

        GetSetups();
        DeletePTAEnquiryErrors(PTAEnquiry);

        if CheckEnquiryAlreadyInvoiced(PTAEnquiry.EnquiryNumber) then begin
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Enquiry %1 already invoiced', PTAEnquiry.EnquiryNumber));
            Error(StrSubstNo('Enquiry %1 already invoiced', PTAEnquiry.EnquiryNumber));
        end;

        ValidateEnquiryDetails(PTAEnquiry);
        Commit();
        PTAEnquiry.Calcfields("Error Exists");
        if PTAEnquiry."Error Exists" then
            Error('Errors validating Enquiry ID %1, Check Enquiry Card for details', PTAEnquiry.ID);
    end;

    local procedure GetSetups()
    begin
        MktgSetup.GET();
        PTASetup.GET();
    end;

    local procedure DeletePTAEnquiryErrors(PTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryError: Record PTAEnquiryError;
    begin
        PTAEnquiryError.Reset();
        PTAEnquiryError.setfilter(EntityType, '%1|%2|%3|%4|%5', PTAEnquiryError.EntityType::Ports, PTAEnquiryError.EntityType::Enquiries, PTAEnquiryError.EntityType::AdditionalCosts, PTAEnquiryError.EntityType::AdditionalServices, PTAEnquiryError.EntityType::Products);
        PTAEnquiryError.SetRange(EnquiryID, PTAEnquiry.ID);
        PTAEnquiryError.SetRange(BatchID, PTAEnquiry.TransactionBatchId);
        PTAEnquiryError.SetRange(HeaderEntryNo, PTAEnquiry.EntryNo);
        //if PTAEnquiryError.FindSet() then
        PTAEnquiryError.Deleteall();
    end;

    local procedure ValidateEnquiryDetails(PTAEnquiry: Record PTAEnquiry)
    begin
        PTAEnquiryFunctions.CheckCustomerAccountExits(PTAEnquiry);
        PTAEnquiryFunctions.CheckVendorAccountExits(PTAEnquiry, PTAEnquiry.SupplierId);
        CheckEnquiryPortExists(PTAEnquiry, PTAEnquiry.EnquiryPort);
        CheckBusinessAreaDimensionCodeFromBusinessAreaId(PTAEnquiry, PTAEnquiry.BusinessAreaId);
        CheckSupplyRegionDimensionFromEnquirySupplyRegionID(PTAEnquiry, PTAEnquiry.EnquirySupplyRegionID);
        if PTAEnquiry.CustomerBrokerId <> 0 then
            PTAEnquiryFunctions.CheckVendorAccountExits(PTAEnquiry, PTAEnquiry.CustomerBrokerId);
        //uncomment later TODO  
        //CheckSupplyMarketDimensionFromEnquiryBookID(PTAEnquiry, PTAEnquiry.EnquiryBookID);

        CheckContractDimensionFromSupplyContractID(PTAEnquiry, PTAEnquiry.SupplierContractId);
        CheckSalesPersonCodeFromCreatedBy(PTAEnquiry, PTAEnquiry.CreatedBy);
        CheckProductAdditionalCostsandServicesExist(PTAEnquiry);
        CheckIfEnquiryMultiCurrency(PTAEnquiry);
        CheckIfVATSetupExistsIfApplicable(PTAEnquiry);
    end;


    local procedure EnquiryNotAlreadyCreated(PTAEnquiry: Record PTAEnquiry): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", Format(PTAEnquiry.EnquiryNumber));
        Exit(SalesHeader.IsEmpty);
    end;



    local procedure CheckEnquiryPortExists(PTAEnquiry: Record PTAEnquiry; EnquiryPortID: Integer)
    begin
        if EnquiryPortID = 0 then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
            PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Port is Blank'));

        if PTABCMappingtoIndexID.GetLocationFromPTAIndexID(EnquiryPortID) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                    PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Enquiry Port not found'));
    end;

    local procedure CheckSupplyRegionDimensionFromEnquirySupplyRegionID(PTAEnquiry: Record PTAEnquiry; EnquirySupplyRegionID: Integer)
    var
        DimensionValue: Record "Dimension Value";
    begin
        if EnquirySupplyRegionID = 0 then exit;
        //if PTABCMappingtoIndexID.GetSupplyRegionDimensionByPTAIndexID(EnquirySupplyRegionID) = '' then //DimensionMappingChanged
        if PTABCMappingtoIndexID.GetSupplyMarketDimensionByPTAIndexID(EnquirySupplyRegionID) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Supplier Region ID %1 not found', EnquirySupplyRegionID));
    end;

    // local procedure CheckSupplyMarketDimensionFromEnquiryBookID(PTAEnquiry: Record PTAEnquiry; EnquiryBookID: Integer)
    // var
    //     DimensionValue: Record "Dimension Value";
    // begin
    //     if EnquiryBookID = 0 then exit;
    //     if PTABCMappingtoIndexID.GetSupplyMarketDimensionByPTAIndexID(EnquiryBookID) = '' then
    //         PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
    //                PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Book Detail ID %1 not found', EnquiryBookID));
    // end;

    local procedure CheckBusinessAreaDimensionCodeFromBusinessAreaId(PTAEnquiry: Record PTAEnquiry; BusinessAreaId: Integer)
    var
        DimensionValue: Record "Dimension Value";
    begin
        if BusinessAreaId = 0 then
            exit;

        if PTABCMappingtoIndexID.GetBusinessAreaDimensionByPTAIndexID(BusinessAreaId) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                    PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Business Area ID %1 not found', BusinessAreaId));
    end;

    local procedure CheckContractDimensionFromSupplyContractID(PTAEnquiry: Record PTAEnquiry; SupplierContractID: Integer)
    var
        DimensionValue: Record "Dimension Value";
    begin
        if SupplierContractID = 0 then exit;
        if PTABCMappingtoIndexID.GetSupplyContractDimensionByPTAIndexID(SupplierContractID) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                   PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Supplier Contract ID %1 not found', SupplierContractID));
    end;

    local procedure CheckSalesPersonCodeFromCreatedBy(PTAEnquiry: Record PTAEnquiry; CreatedBy: Integer)
    var
        Salesperson: Record "Salesperson/Purchaser";
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        if CreatedBy = 0 then
            exit;
        if PTABCMappingtoIndexID.GetSalespersonFromPTAIndexID(CreatedBy) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                 PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Salesperson ID %1 not found', CreatedBy));
    end;

    local procedure CheckProductAdditionalCostsandServicesExist(PTAEnquiry: Record PTAEnquiry)
    begin
        CheckEnquiryProducts(PTAEnquiry);
        CheckEnquiryAdditionalCosts(PTAEnquiry);
        CheckEnquiryAdditionalServices(PTAEnquiry);
    end;

    local procedure CheckEnquiryProducts(PTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryProducts.FindFirst() then
            repeat
                if (PTAEnquiryProducts.SellCurrencyId <> 0) then
                    if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.SellCurrencyId) = '' then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                     PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('Currency for %1 not found.', PTAEnquiryProducts.SellCurrencyId));

                if (PTAEnquiryProducts.BuyCurrencyId <> 0) then
                    if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.BuyCurrencyId) = '' then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                     PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('Currency for %1 not found.', PTAEnquiryProducts.BuyCurrencyId));

                if (PTAEnquiryProducts.SupplierId <> 0) then
                    PTAEnquiryFunctions.CheckVendorAccountExits(PTAEnquiry, PTAEnquiryProducts.SupplierId);

                Case true of
                    (PTAEnquiry.BusinessAreaId = 2):
                        begin
                            if PTASetup."Broking Comm. G/L Account" = '' then
                                PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                             PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('PTA setup Broking Comm. G/L Account missing', PTAEnquiryProducts.ProductId));
                        end;

                    (PTAEnquiry.BusinessAreaId <> 2):
                        begin
                            if PTAEnquiryProducts.ProductId <> 16 then begin
                                if PTABCMappingtoIndexID.GetItemFromPTAIndexID(PTAEnquiryProducts.ProductId) = '' then begin
                                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                                 PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('Item ID %1 not found', PTAEnquiryProducts.ProductId));
                                end;

                                if PTAEnquiryProducts.DeliveredQuantity <> 0 then begin
                                    if PTAEnquiryProducts.DeliveryUnitId <> 1 then
                                        if PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.DeliveryUnitId) = '' then
                                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                                         PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('DeliveryUnitId %1 not found', PTAEnquiryProducts.DeliveryUnitId));
                                end else
                                    if PTAEnquiryProducts.SellUnitId <> 1 then
                                        if PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.SellUnitId) = '' then
                                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                                         PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('SellUnitId %1 not found', PTAEnquiryProducts.SellUnitId));

                                if PTAEnquiryProducts.SellPriceUOMId <> 1 then
                                    if PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.SellPriceUOMId) = '' then
                                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                                     PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('SellPriceUOMId %1 not found', PTAEnquiryProducts.SellPriceUOMId));

                                if PTAEnquiryProducts.BuyPriceUOMId <> 1 then
                                    if PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryProducts.BuyPriceUOMId) = '' then
                                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                                     PTAEnquiry.EntryNo, PTAEnquiryProducts.EntryNo, StrSubstNo('BuyPriceUOMId %1 not found', PTAEnquiryProducts.BuyPriceUOMId));

                            end;
                        end;
                end;
            until PTAEnquiryProducts.Next() = 0;
    end;

    local procedure CheckEnquiryAdditionalCosts(PTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
    begin
        PTAEnquiryAdditionalCost.Reset();
        PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryAdditionalCost.FindFirst() then
            repeat
                IF (PTAEnquiryAdditionalCost.SellIsApplicable) OR (PTAEnquiryAdditionalCost.BuyIsApplicable) THEN begin
                    if (PTAEnquiryAdditionalCost.SellCurrencyId <> 0) then
                        if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryAdditionalCost.SellCurrencyId) = '' then
                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                         PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('Currency for %1 not found.', PTAEnquiryAdditionalCost.SellCurrencyId));

                    if (PTAEnquiryAdditionalCost.BuyCurrencyId <> 0) then
                        if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryAdditionalCost.BuyCurrencyId) = '' then
                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                         PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('Currency for %1 not found.', PTAEnquiryAdditionalCost.BuyCurrencyId));

                    if (PTAEnquiryAdditionalCost.SupplierId <> 0) then begin
                        PTAEnquiryFunctions.CheckVendorAccountExits(PTAEnquiry, PTAEnquiryAdditionalCost.SupplierId);
                        // if PTAEnquiryAdditionalCost.NativeBuyExposure = 0 then
                        //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                        //                  PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('NativeBuyExposure is 0 when Supplier is Specified', PTAEnquiryAdditionalCost.NativeBuyExposure));
                    end;

                    if (PTAEnquiryAdditionalCost.AdditionalCostDetailsId = 0) and (PTAEnquiryAdditionalCost.CostTypeId = 0) then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                     PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('AdditionalCostDetailsId and Cost Type Blank', PTAEnquiryAdditionalCost.AdditionalCostDetailsId));

                    if PTAEnquiryAdditionalCost.AdditionalCostDetailsId <> 0 then
                        if PTABCMappingtoIndexID.GetAdditionalCostResourceFromPTAIndexID(PTAEnquiryAdditionalCost.AdditionalCostDetailsId) = '' then
                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                         PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('AdditionalCostDetailsId ID %1 not found', PTAEnquiryAdditionalCost.AdditionalCostDetailsId));

                    if PTAEnquiryAdditionalCost.CostTypeId <> 0 then
                        if PTABCMappingtoIndexID.GetCostTypeResourceFromPTAIndexID(PTAEnquiryAdditionalCost.CostTypeId) = '' then
                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                         PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('Cost Type ID %1 not found', PTAEnquiryAdditionalCost.CostTypeId));

                    if PTAEnquiryAdditionalCost.BuyUOMId <> 1 then
                        if PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(PTAEnquiryAdditionalCost.BuyUOMId) = '' then
                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                         PTAEnquiry.EntryNo, PTAEnquiryAdditionalCost.EntryNo, StrSubstNo('BuyPriceUOMId %1 not found', PTAEnquiryAdditionalCost.BuyUOMId));
                end;
            until PTAEnquiryAdditionalCost.Next() = 0;
    end;

    local procedure CheckEnquiryAdditionalServices(PTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        BuyRate: Decimal;
    begin
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryAddServices.FindFirst() then
            repeat
                if PTABCMappingtoIndexID.GetServiceResourceFromPTAIndexID(PTAEnquiryAddServices.ProductId) = '' then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::AdditionalServices, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                 PTAEnquiry.EntryNo, PTAEnquiryAddServices.EntryNo, StrSubstNo('Add. Service ID %1 not found', PTAEnquiryAddServices.ProductId));
                if (PTAEnquiryAddServices.SellCurrencyId <> 0) then
                    if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryAddServices.SellCurrencyId) = '' then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                     PTAEnquiry.EntryNo, PTAEnquiryAddServices.EntryNo, StrSubstNo('Currency for %1 not found.', PTAEnquiryAddServices.SellCurrencyId));
                if (PTAEnquiryAddServices.CurrencyId <> 0) then
                    if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryAddServices.CurrencyId) = '' then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Products, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                                     PTAEnquiry.EntryNo, PTAEnquiryAddServices.EntryNo, StrSubstNo('Currency for %1 not found.', PTAEnquiryAddServices.CurrencyId));

                if (PTAEnquiryAddServices.SupplierId <> 0) then begin
                    PTAEnquiryFunctions.CheckVendorAccountExits(PTAEnquiry, PTAEnquiryAddServices.SupplierId);
                    // Evaluate(BuyRate, PTAEnquiryAddServices.BuyRate);
                    // if BuyRate = 0 then
                    //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::AdditionalServices, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                    //                  PTAEnquiry.EntryNo, PTAEnquiryAddServices.EntryNo, StrSubstNo('BuyRate is 0 when Supplier is Specified', PTAEnquiryAddServices.NativeBuyExposure));
                end;
            until PTAEnquiryAddServices.Next() = 0;
    end;

    local procedure CheckEnquiryAlreadyInvoiced(VarEnquiryNumber: Integer): Boolean
    var
        // CustLedgerEntry: Record "Cust. Ledger Entry";
        InvoicePTACustomerInvoices, EnquiryPTACustomerInvoices : Record PTACustomerInvoices;
        isInvoiced: Boolean;
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.get(SalesHeader."Document Type"::Order, VarEnquiryNumber) then
            exit;
        // This means an Open Sales Order is still waiting to be posted. 
        // we only check posted invoice is a New Enquiry  or a completely posted invoice.

        isInvoiced := false;
        EnquiryPTACustomerInvoices.Reset();
        EnquiryPTACustomerInvoices.SetCurrentKey(EnquiryNumber);
        EnquiryPTACustomerInvoices.SetRange(EnquiryNumber, VarEnquiryNumber);
        EnquiryPTACustomerInvoices.SetRange(StatusId, 4);
        EnquiryPTACustomerInvoices.SetRange(processed, 1);
        if EnquiryPTACustomerInvoices.FindFirst() then
            repeat
                InvoicePTACustomerInvoices.Reset();
                InvoicePTACustomerInvoices.SetCurrentKey(EnquiryNumber);
                InvoicePTACustomerInvoices.SetRange(EnquiryNumber, VarEnquiryNumber);
                InvoicePTACustomerInvoices.SetRange(InvoiceNumber, EnquiryPTACustomerInvoices.InvoiceNumber);
                InvoicePTACustomerInvoices.SetRange(StatusId, 7);
                isInvoiced := (InvoicePTACustomerInvoices.IsEmpty);
            until (EnquiryPTACustomerInvoices.Next() = 0) or isInvoiced;

        exit(isInvoiced);
    end;

    local procedure CheckCurrencyExchangeRate(PTAEnquiry: Record PTAEnquiry; SellCurrencyID: Integer)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        DeliveryDate: Date;
    begin
        DeliveryDate := DT2DATE(PTAEnquiry.ETD);
        if DeliveryDate = 0D then DeliveryDate := DT2DATE(PTAEnquiry.EnquiryDate);

        CurrencyExchangeRate.Reset();
        CurrencyExchangeRate.SetRange("Currency Code", PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(SellCurrencyID));
        CurrencyExchangeRate.SetRange("Starting Date", 0D, DeliveryDate);
        if CurrencyExchangeRate.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
            PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Exchange Rate not found for %1 - %2', PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(SellCurrencyID), DeliveryDate));
    end;

    local procedure CheckIfEnquiryMultiCurrency(PTAEnquiry: Record PTAEnquiry)
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        FirstCurrency: Integer;
    begin
        FirstCurrency := 0;
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        PTAEnquiryProducts.SetFilter(SellPrice, '<>%1', 0);
        if PTAEnquiryProducts.FindFirst() then
            repeat
                if FirstCurrency = 0 then begin
                    FirstCurrency := PTAEnquiryProducts.SellCurrencyId;
                    CheckCurrencyExchangeRate(PTAEnquiry, FirstCurrency);
                end else
                    if PTAEnquiryProducts.SellCurrencyId <> FirstCurrency then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                        PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, 'Multi Currency On Products');
            until PTAEnquiryProducts.Next() = 0;

        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        PTAEnquiryAddServices.SetFilter(Sellrate, '<>%1', '0');
        if PTAEnquiryAddServices.FindFirst() then
            repeat
                if FirstCurrency = 0 then
                    FirstCurrency := PTAEnquiryAddServices.SellCurrencyId
                else
                    if PTAEnquiryAddServices.SellCurrencyId <> FirstCurrency then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                        PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, 'Multi Currency on Additional Services');
            until PTAEnquiryAddServices.Next() = 0;

        PTAEnquiryAdditionalCost.Reset();
        PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        PTAEnquiryAdditionalCost.SetFilter(Sellrate, '<>%1', 0);
        if PTAEnquiryAdditionalCost.FindFirst() then
            repeat
                if FirstCurrency = 0 then
                    FirstCurrency := PTAEnquiryAdditionalCost.SellCurrencyId
                else
                    if PTAEnquiryAdditionalCost.SellCurrencyId <> FirstCurrency then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                        PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, 'Multi Currency On Additonal Costs');
            until PTAEnquiryAddServices.Next() = 0;
    end;

    local procedure CheckIfVATSetupExistsIfApplicable(PTAEnquiry: Record PTAEnquiry)
    var
        Location: Record Location;
    begin
        if Not PTAEnquiry.HasVATAmount() then exit;
        if PTAEnquiry.EnquiryPort = 0 then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
            PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('VAT applicable on the Invoice, No Port mentioned.'));

        if (Not Location.get(PTABCMappingtoIndexID.GetLocationFromPTAIndexID(PTAEnquiry.EnquiryPort))) or (Location."PTA VAT Buss. Posting Grp." = '') then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                    PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Location/Port VAT Setup Missing'));
    end;

    var
        MktgSetup: Record "Marketing Setup";
        PTASetup: Record "PTA Setup";

        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;


}
