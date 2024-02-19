codeunit 70036 PTACustomerInvoiceProcessPost
{
    TableNo = PTACustomerInvoices;

    trigger OnRun()
    var
        PTACustomerInvoices: Record PTACustomerInvoices;
        SalesHeader: Record "Sales Header";
        PTACustomerInvoiceValidation: Codeunit PTACustomerInvoiceValidation;
        PTAEnquiry: Record PTAEnquiry;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPost: Codeunit "Sales-Post";
        PTACustInvoiceChangedforBC: Codeunit "PTA CustInvoice Changed for BC";

    begin
        PTACustomerInvoices := rec;
        if not PTACustInvoiceChangedforBC.PTACheckIfCustomerInvoiceHasChanged(PTACustomerInvoices) then
            exit;

        PTACustomerInvoiceValidation.GetPTAEnquiryRecord(PTACustomerInvoices.EnquiryId, PTAEnquiry);
        PTAEnquiry.FindLast();

        InitAllSalesLineToInvoice(Format(PTACustomerInvoices.EnquiryNumber));

        if SalesHeader.get(SalesHeader."Document Type"::Order, Format(PTACustomerInvoices.EnquiryNumber)) then begin
            SalesHeader.SetRecFilter();
            if SalesHeader.Status = SalesHeader.Status::Released then
                ReleaseSalesDocument.Reopen(SalesHeader);
            SalesHeader.SetHideValidationDialog(true);
            SalesHeader.VALIDATE("Posting Date", DT2DATE(PTACustomerInvoices.InvoiceDate));
            SalesHeader.VALIDATE("Due Date", DT2DATE(PTACustomerInvoices.DueDate));
            SalesHeader."Posting No." := UpperCase(PTACustomerInvoices.InvoiceNumber);
            SalesHeader.Ship := TRUE;
            SalesHeader.Invoice := TRUE;
            SalesHeader.MODIFY;
        end else
            Error('Sales order for Enquiry not found');

        ProcessLines(PTACustomerInvoices, PTAEnquiry);
        ProcessGLAccounts(SalesHeader);
        CreateAndCalculateVATToleranceOnSalesInvoice(PTACustomerInvoices, SalesHeader);

        if PTAEnquiry.LinkedDealId = 0 then begin
            if PTAEnquiry.BusinessAreaId <> 3 then begin
                Commit();
                SalesPost.run(SalesHeader)
            End else begin
                SalesHeader."PTA Parked" := true;
                SalesHeader."PTA UnParked" := false;
                SalesHeader.Modify();
                ReleaseSalesDocument.Run(SalesHeader);
            end
        end else
            ProcessLinkedDeal(PTACustomerInvoices, PTAEnquiry, SalesHeader);
    end;

    local procedure InitAllSalesLineToInvoice(PTAEnquiryNumber: Code[20])
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.reset;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", PTAEnquiryNumber);
        if SalesLine.FindSet(true) then begin
            SalesLine.ModifyAll("Qty. to Ship", 0, false);
            SalesLine.ModifyAll("Qty. to Invoice", 0, false);
        end;
    end;

    local procedure ProcessLines(PTACustomerInvoice: Record PTACustomerInvoices; PTAEnquiry: Record PTAEnquiry)
    begin
        CheckCustomerInvoiceProducts(PTACustomerInvoice, PTAEnquiry);
        CheckCustomerInvoiceCosts(PTACustomerInvoice);
        CheckCustomerInvoiceServices(PTACustomerInvoice);
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
                PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::Products, PTACustomerInvoiceProducts.EnquiryProductId, Format(PTACustomerInvoice.EnquiryNumber), SalesLine);
                SalesLine.FindFirst();
                if PTAEnquiry.BusinessAreaId <> 2 then begin
                    UnitFactor := PTAEnquiryFunctions.GetQuantityUnitFactor(SalesLine."No.", PTACustomerInvoiceProducts.SellPriceUOMId, PTACustomerInvoiceProducts.DeliveryDensity);
                    SalesLine.validate("Qty. to Ship", ROUND(PTACustomerInvoiceProducts.Quantity * UnitFactor, 0.001));
                    SalesLine.validate("Qty. to Invoice", SalesLine."Qty. to Ship");
                end else begin
                    SalesLine.validate("Qty. to ship", 1);
                    SalesLine.validate("Qty. to Invoice", 1);
                end;
                SalesLine.Modify()
            until PTACustomerInvoiceProducts.Next() = 0;
    end;

    local procedure CheckCustomerInvoiceCosts(PTACustomerInvoice: Record PTACustomerInvoices)
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
                PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTACustomerInvoiceAddCost.EnquiryAdditionalCostId, Format(PTACustomerInvoice.EnquiryNumber), SalesLine);
                SalesLine.FindFirst();
                SalesLine.validate("Qty. to ship", SalesLine.Quantity);
                SalesLine.validate("Qty. to Invoice", SalesLine.Quantity);
                SalesLine.Modify()
            until PTACustomerInvoiceAddCost.Next() = 0;
    end;

    local procedure CheckCustomerInvoiceServices(PTACustomerInvoice: Record PTACustomerInvoices)
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
                PTAEnquiryFunctions.CheckPTASalesLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalServices, PTACustomerInvoiceAddServ.EnquiryAdditionalServiceId, Format(PTACustomerInvoice.EnquiryNumber), SalesLine);
                SalesLine.FindFirst();
                SalesLine.validate("Qty. to ship", SalesLine.Quantity);
                SalesLine.validate("Qty. to Invoice", SalesLine.Quantity);
                SalesLine.Modify()
            until PTACustomerInvoiceAddServ.Next() = 0;
    end;

    local procedure ProcessGLAccounts(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Reset();
        SalesLine.setrange("Document Type", SalesHeader."Document Type");
        SalesLine.setrange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::"G/L Account");
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet(true) then
            repeat
                SalesLine.Validate("Qty. to Ship", SalesLine."Outstanding Qty. (Base)");
                SalesLine.validate("Qty. to Invoice", SalesLine."Qty. to Ship");
                SalesLine.Modify();
            until SalesLine.next = 0;

    end;

    local procedure ProcessLinkedDeal(PTACustomerInvoices: Record PTACustomerInvoices; PTAEnquiry: Record PTAEnquiry; var SalesHeader: Record "Sales Header")
    var
        PTACustomerInvoiceValidation: Codeunit PTACustomerInvoiceValidation;
        LinkedPTAEnquiry: Record PTAEnquiry;
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        SalesPost: Codeunit "Sales-Post";
        PostInvoice: Boolean;
    begin
        PTACustomerInvoiceValidation.GetPTAEnquiryRecord(PTAEnquiry.LinkedDealId, LinkedPTAEnquiry);
        LinkedPTAEnquiry.FindLast();

        PostInvoice := (LinkedPTAEnquiry.BusinessAreaId = PTAEnquiry.BusinessAreaId) and (PTAEnquiry.BusinessAreaId = 1);

        if (Not PostInvoice) then
            PostInvoice := (LinkedPTAEnquiry.BusinessAreaId <> PTAEnquiry.BusinessAreaId) AND (PTAEnquiry.BusinessAreaId = 1);

        if Not PostInvoice then begin
            SalesHeader."PTA Parked" := true;
            SalesHeader."PTA UnParked" := false;
            SalesHeader.Modify();
            ReleaseSalesDocument.Run(SalesHeader);
        end else begin
            Commit();
            SalesPost.run(SalesHeader)
        end;
    end;

    procedure CreateAndCalculateVATToleranceOnSalesInvoice(PTACustomerInvoices: Record PTACustomerInvoices; var SalesHeader: Record "Sales Header")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesPost: Codeunit "Sales-Post";
        SalesLine: Record "Sales Line";
        PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;
        TotalSellVat: Decimal;
        PtaSetup: Record "PTA Setup";
    begin
        PtaSetup.Get();

        if SalesHeader."PTA Sales VAT Amount" = 0 then exit;

        TotalSellVat := PTACustomerInvoices.GetSellVATAmount();

        GeneralLedgerSetup.get();
        SalesReceivablesSetup.get();

        if Not SalesReceivablesSetup."Allow VAT Difference" then
            Error('VAT Difference is not allowed in Sales Setup');

        TempVATAmountLine.DELETEALL;
        SalesLine.CalcVATAmountLines(1, SalesHeader, SalesLine, TempVATAmountLine);
        TempVATAmountLine.FINDFIRST;
        if ABS(TotalSellVat - TempVATAmountLine."VAT Amount") > GeneralLedgerSetup."Max. VAT Difference Allowed" then
            Error(StrSubstNo('VAT Difference between BC (%1) and PTA (%2) is more than allowed in General Ledger Setup', TotalSellVat, TempVATAmountLine."VAT Amount"));
        TempVATAmountLine.VALIDATE("VAT Amount", TotalSellVat);
        TempVATAmountLine."Amount Including VAT" := TempVATAmountLine."VAT Amount" + TempVATAmountLine."VAT Base";
        TempVATAmountLine.Modified := TRUE;
        TempVATAmountLine.MODIFY;

        SalesLine.UpdateVATOnLines(1, SalesHeader, SalesLine, TempVATAmountLine);
    end;

    var
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
}