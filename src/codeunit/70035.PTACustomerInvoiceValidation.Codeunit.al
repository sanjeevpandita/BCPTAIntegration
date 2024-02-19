codeunit 70035 PTACustomerInvoiceValidation
{

    TableNo = PTACustomerInvoices;

    trigger OnRun()
    var
        PTACustomerInvoice: Record PTACustomerInvoices;
    begin
        CompanyInfo.get();
        PTACustomerInvoice := Rec;

        DeleteCustomerInvoiceErrors(PTACustomerInvoice);


        Case PTACustomerInvoice.StatusId of
            4:
                ValidateCustomerInvoice(PTACustomerInvoice);
            7:
                ValidateVoidCustomerInvoice(PTACustomerInvoice);
        End;
    end;

    procedure ValidateCustomerInvoice(var PTACustomerInvoice: Record PTACustomerInvoices)
    var
        SalesHeader: Record "Sales Header";
        PTAEnquiry: Record PTAEnquiry;
        PTAProcessSingleEnquiryRecord: Codeunit PTAEnquiryProcessSingleRecord;
        PTAEnquiryModify: Record PTAEnquiry;
    begin

        if SalesInvoiceHeader.get(UpperCase(PTACustomerInvoice.InvoiceNumber)) then
            Error('Invoice already posted');

        if Not GetPTAEnquiryRecord(PTACustomerInvoice.EnquiryId, PTAEnquiry) then
            Error(StrSubstNo('Enquriy %1 Not found in PTA-BC Staging table for the invoice', PTACustomerInvoice.EnquiryId))
        else begin
            PTAEnquiry.FindLast();

            Case PTAEnquiry.Processed of
                0:
                    Error(StrSubstNo('Last Enquiry Status is unprocessed. %1 - %2', PTAEnquiry.id, PTAEnquiry.TransactionBatchId));
                2:
                    Error(StrSubstNo('Last Enquiry Status is in Error. Resolve the error.', PTAEnquiry.id, PTAEnquiry.TransactionBatchId))
            end;

            // if ((PTAEnquiry.HasVATAmount() AND (Not PTACustomerInvoice.HasVATAmount())) OR ((Not PTAEnquiry.HasVATAmount()) AND PTACustomerInvoice.HasVATAmount())) then
            //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoice, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
            //        PTACustomerInvoice.EntryNo, PTACustomerInvoice.EntryNo, StrSubstNo('VAT Exists in Enquiry and not in Invoice or vice versa', PTACustomerInvoice.ID));

            if not SalesHeader.get(SalesHeader."Document Type"::Order, Format(PTAEnquiry.EnquiryNumber)) then
                PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoice, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                   PTACustomerInvoice.EntryNo, PTACustomerInvoice.EntryNo, StrSubstNo('No Sales Order found to Invoice', PTACustomerInvoice.ID))
            else
                if (PTACustomerInvoice.CurrencyId <> 0) then begin
                    if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTACustomerInvoice.CurrencyId) = '' then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoice, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                       PTACustomerInvoice.EntryNo, PTACustomerInvoice.EntryNo, StrSubstNo('Currency %1 not found', PTACustomerInvoice.ID));

                    if PTACustomerInvoice.CurrencyId <> CompanyInfo."PTA Base Currency ID" then
                        if SalesHeader."Currency Code" <> PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTACustomerInvoice.CurrencyId) then
                            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoice, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                           PTACustomerInvoice.EntryNo, PTACustomerInvoice.EntryNo, StrSubstNo('Currency on Invoice different than Order', PTACustomerInvoice.ID));
                end;

            ValidateLineDetails(PTACustomerInvoice, PTAEnquiry);
            Commit();
            PTACustomerInvoice.Calcfields("Error Exists");
            if PTACustomerInvoice."Error Exists" then
                Error('Errors validating Invoice %1, Check Invoice Card for details', PTACustomerInvoice.ID);

        end;
    end;

    local procedure ValidateLineDetails(PTACustomerInvoice: Record PTACustomerInvoices; PTAEnquiry: Record PTAEnquiry)
    begin
        CheckCustomerInvoiceProducts(PTACustomerInvoice, PTAEnquiry);
        CheckCustomerInvoiceCosts(PTACustomerInvoice, PTAEnquiry);
        CheckCustomerInvoiceServices(PTACustomerInvoice, PTAEnquiry);
    end;

    local procedure CheckIFEnquriyRecordIsWaitingToBeProcessed(EnquiryId: Integer): Boolean
    var
        PTAEnquiry: Record PTAEnquiry;
    begin
        PTAEnquiry.reset;
        PTAEnquiry.SetRange(id, EnquiryId);
        PTAEnquiry.SetRange(Processed, 0);
        Exit(Not PTAEnquiry.IsEmpty);
    end;

    local procedure CheckCustomerInvoiceProducts(PTACustomerInvoice: Record PTACustomerInvoices; PTAEnquiry: Record PTAEnquiry)
    var
        PTACustomerInvoiceProducts: Record PTACustomerInvoiceProducts;
        SalesLine: Record "Sales Line";
        UnitFactor: Decimal;
    begin
        PTACustomerInvoiceProducts.Reset();
        PTACustomerInvoiceProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTACustomerInvoiceProducts.SetRange(CustomerInvoiceId, PTACustomerInvoice.ID);
        PTACustomerInvoiceProducts.SetRange(TransactionBatchId, PTACustomerInvoice.TransactionBatchId);
        if PTACustomerInvoiceProducts.FindFirst() then
            repeat
                if PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::Products, PTACustomerInvoiceProducts.EnquiryProductId, Format(PTAEnquiry.EnquiryNumber), SalesLine) then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceProducts, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                      PTACustomerInvoice.EntryNo, PTACustomerInvoiceProducts.EntryNo, StrSubstNo('Invoice Product not found on Sales Order', PTACustomerInvoice.ID))
                else begin
                    SalesLine.FindFirst();

                    if (PTAEnquiry.BusinessAreaId <> 2) then
                        if PTACustomerInvoiceProducts.ProductId <> 16 then begin
                            if SalesLine."No." <> PTABCMappingtoIndexID.GetItemFromPTAIndexID(PTACustomerInvoiceProducts.ProductId) then
                                PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceProducts, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                                PTACustomerInvoice.EntryNo, PTACustomerInvoiceProducts.EntryNo, StrSubstNo('Invoice Product does not match Sales Order', PTACustomerInvoice.ID));

                            UnitFactor := PTAEnquiryFunctions.GetQuantityUnitFactor(SalesLine."No.", PTACustomerInvoiceProducts.SellPriceUOMId, PTACustomerInvoiceProducts.DeliveryDensity);
                            if ROUND(PTACustomerInvoiceProducts.Quantity * UnitFactor, 0.001) > SalesLine."Outstanding Qty. (Base)" then
                                PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceProducts, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                                      PTACustomerInvoice.EntryNo, PTACustomerInvoiceProducts.EntryNo, StrSubstNo('Quantity to Invoice greater than Outstanding ', PTACustomerInvoice.ID));
                        end;
                end;
            until PTACustomerInvoiceProducts.Next() = 0;
    end;

    local procedure CheckCustomerInvoiceCosts(PTACustomerInvoice: Record PTACustomerInvoices; PTAEnquiry: Record PTAEnquiry)
    var
        PTACustomerInvoiceAddCost: Record PTACustomerInvoiceAddCost;
        SalesLine: Record "Sales Line";
        UnitFactor: Decimal;
    begin
        PTACustomerInvoiceAddCost.Reset();
        PTACustomerInvoiceAddCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTACustomerInvoiceAddCost.SetRange(InvoiceId, PTACustomerInvoice.ID);
        PTACustomerInvoiceAddCost.SetRange(TransactionBatchId, PTACustomerInvoice.TransactionBatchId);
        if PTACustomerInvoiceAddCost.FindFirst() then
            repeat
                if PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTACustomerInvoiceAddCost.EnquiryAdditionalCostId, Format(PTAEnquiry.EnquiryNumber), SalesLine) then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceAdditionalCosts, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                      PTACustomerInvoice.EntryNo, PTACustomerInvoiceAddCost.EntryNo, StrSubstNo('Cost %1 not found on Sales Order', PTACustomerInvoiceAddCost.EnquiryAdditionalCostId))
                else begin
                    SalesLine.FindFirst();
                    // if ((PTACustomerInvoiceAddCost.EnquiryAdditionalCostId <> 0) AND (SalesLine."No." <> PTABCMappingtoIndexID.GetCostTypeResourceFromPTAIndexID(PTACustomerInvoiceAddCost.EnquiryAdditionalCostId))) then
                    //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceAdditionalCosts, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                    //     PTACustomerInvoice.EntryNo, PTACustomerInvoiceAddCost.EntryNo, StrSubstNo('Invoice Cost does not match Sales Order', PTACustomerInvoice.ID));
                end;

            until PTACustomerInvoiceAddCost.Next() = 0;
    end;

    local procedure CheckCustomerInvoiceServices(PTACustomerInvoice: Record PTACustomerInvoices; PTAEnquiry: Record PTAEnquiry)
    var
        PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;
        SalesLine: Record "Sales Line";
        UnitFactor: Decimal;
    begin
        PTACustomerInvoiceAddServ.Reset();
        PTACustomerInvoiceAddServ.SetAutoCalcFields("Is VAT/GST Service");
        PTACustomerInvoiceAddServ.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange(InvoiceId, PTACustomerInvoice.ID);
        PTACustomerInvoiceAddServ.SetRange(TransactionBatchId, PTACustomerInvoice.TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange("Is VAT/GST Service", false);
        if PTACustomerInvoiceAddServ.FindFirst() then
            repeat
                if PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalServices, PTACustomerInvoiceAddServ.EnquiryAdditionalServiceId, Format(PTAEnquiry.EnquiryNumber), SalesLine) then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceAddServ, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                      PTACustomerInvoice.EntryNo, PTACustomerInvoiceAddServ.EntryNo, StrSubstNo('Service not found on Sales Order', PTACustomerInvoice.ID))
                else begin
                    SalesLine.FindFirst();
                    if SalesLine."No." <> PTABCMappingtoIndexID.GetServiceResourceFromPTAIndexID(PTACustomerInvoiceAddServ.ProductId) then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::CustomerInvoiceAddServ, PTACustomerInvoice.ID, PTACustomerInvoice.TransactionBatchId,
                        PTACustomerInvoice.EntryNo, PTACustomerInvoiceAddServ.EntryNo, StrSubstNo('Invoice Service does not match Sales Order', PTACustomerInvoice.ID));
                end;
            until PTACustomerInvoiceAddServ.Next() = 0;
    end;

    local procedure ValidateVoidCustomerInvoice(PTACustomerInvoice: Record PTACustomerInvoices)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PTAEnquiry: Record PTAEnquiry;
    begin
        if Not SalesInvoiceHeader.get(UpperCase(PTACustomerInvoice.InvoiceNumber)) then
            Error('Invoice not found to void');

        SalesCrMemoHeader.Reset();
        SalesCrMemoHeader.SetRange("Sell-to Customer No.", SalesInvoiceHeader."Sell-to Customer No.");
        SalesCrMemoHeader.SetRange("Applies-to Doc. No.", UpperCase(PTACustomerInvoice.InvoiceNumber));
        if not SalesCrMemoHeader.IsEmpty then
            Error('Invoice already voided.');

        if Not GetPTAEnquiryRecord(PTACustomerInvoice.EnquiryId, PTAEnquiry) then
            Error(StrSubstNo('Enquriy %1 Not found in PTA-BC Staging table for the invoice', PTACustomerInvoice.EnquiryId))

    end;

    procedure GetPTAEnquiryRecord(EnquiryId: Integer; var PTAEnquiry: Record PTAEnquiry): Boolean
    begin
        PTAEnquiry.reset;
        PTAEnquiry.SetCurrentKey(Id, TransactionBatchId);
        PTAEnquiry.SetRange(ID, EnquiryId);
        exit(NOT PTAEnquiry.IsEmpty);
    end;

    local procedure DeleteCustomerInvoiceErrors(PTACustomerInvoices: Record PTACustomerInvoices)
    var
        PTAEnquiryError: Record PTAEnquiryError;
    begin
        PTAEnquiryError.Reset();
        PTAEnquiryError.setfilter(EntityType, '%1|%2|%3|%4', PTAEnquiryError.EntityType::CustomerInvoice, PTAEnquiryError.EntityType::CustomerInvoiceProducts,
                pTAEnquiryError.EntityType::CustomerInvoiceAddServ, PTAEnquiryError.EntityType::CustomerInvoiceAdditionalCosts);
        PTAEnquiryError.SetRange(EnquiryID, PTACustomerInvoices.ID);
        PTAEnquiryError.SetRange(BatchID, PTACustomerInvoices.TransactionBatchId);
        PTAEnquiryError.SetRange(HeaderEntryNo, PTACustomerInvoices.EntryNo);
        PTAEnquiryError.Deleteall();
    end;

    var

        MktgSetup: Record "Marketing Setup";
        PTASetup: Record "PTA Setup";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;

        SalesInvoiceHeader: Record "Sales Invoice Header";
        CompanyInfo: Record "Company Information";
}