codeunit 70037 "PTA CustInvoice Changed for BC"
{

    procedure PTACheckIfCustomerInvoiceHasChanged(PTACustomerInvoices: Record PTACustomerInvoices): Boolean
    Var
        HasChanged: Boolean;
    begin
        HasChanged := false;
        CheckIFPTACustomerInvoicesHasChanged(PTACustomerInvoices, HasChanged);

        if Not HasChanged then
            CheckIFAnyPTACustomerInvoicesProductHasChanged(PTACustomerInvoices, HasChanged);
        if Not HasChanged then
            CheckIFAnyPTACustomerInvoicesAdditionalCostHasChanged(PTACustomerInvoices, HasChanged);
        if Not HasChanged then
            CheckIFAnyPTACustomerInvoicesAdditionalServiceHasChanged(PTACustomerInvoices, HasChanged);

        exit(HasChanged);
    end;

    local procedure CheckIFPTACustomerInvoicesHasChanged(var PTACustomerInvoices: Record PTACustomerInvoices; Var HasChanged: Boolean)
    var
        PreviousPTACustomerInvoices: Record PTACustomerInvoices;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryFunctions.GetPreviousBatchPTACustomerInvoice(PTACustomerInvoices, PreviousPTACustomerInvoices);
        NewRecordRef.GetTable(PTACustomerInvoices);
        OldRecordRef.GetTable(PreviousPTACustomerInvoices);
        HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTACustomerInvoices);
    end;

    local procedure CheckIFAnyPTACustomerInvoicesProductHasChanged(var PTACustomerInvoices: Record PTACustomerInvoices; var HasChanged: Boolean)
    var
        PTACustomerInvoiceProducts: Record PTACustomerInvoiceProducts;
        PreviousPTACustomerInvoiceProducts: Record PTACustomerInvoiceProducts;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTACustomerInvoiceProducts.Reset();
        PTACustomerInvoiceProducts.SetCurrentKey(CustomerInvoiceId, TransactionBatchId);
        PTACustomerInvoiceProducts.SetRange(CustomerInvoiceId, PTACustomerInvoices.ID);
        PTACustomerInvoiceProducts.SetRange(TransactionBatchId, PTACustomerInvoices.TransactionBatchId);
        if PTACustomerInvoiceProducts.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchCustomerInvoiceProductByID(PTACustomerInvoiceProducts, PreviousPTACustomerInvoiceProducts, PTACustomerInvoiceProducts.ID);
                HasChanged := (PreviousPTACustomerInvoiceProducts.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTACustomerInvoiceProducts);
                    OldRecordRef.GetTable(PreviousPTACustomerInvoiceProducts);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTACustomerInvoiceProducts);
                end;
            Until (PTACustomerInvoiceProducts.next = 0) OR HasChanged
    end;

    local procedure CheckIFAnyPTACustomerInvoicesAdditionalCostHasChanged(var PTACustomerInvoices: Record PTACustomerInvoices; Var HasChanged: Boolean)
    var
        PTACustomerInvoiceAddCost: Record PTACustomerInvoiceAddCost;
        PreviousPTACustomerInvoiceAddCost: Record PTACustomerInvoiceAddCost;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTACustomerInvoiceAddCost.Reset();
        PTACustomerInvoiceAddCost.SetCurrentKey(InvoiceId, TransactionBatchId);
        PTACustomerInvoiceAddCost.SetRange(InvoiceId, PTACustomerInvoices.ID);
        PTACustomerInvoiceAddCost.SetRange(TransactionBatchId, PTACustomerInvoices.TransactionBatchId);
        if PTACustomerInvoiceAddCost.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchCustomerInvoiceAdditionalCostByID(PTACustomerInvoiceAddCost, PreviousPTACustomerInvoiceAddCost, PTACustomerInvoiceAddCost.ID);
                HasChanged := (PreviousPTACustomerInvoiceAddCost.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTACustomerInvoiceAddCost);
                    OldRecordRef.GetTable(PreviousPTACustomerInvoiceAddCost);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTACustomerInvoiceAddCost);
                end;
            Until (PTACustomerInvoiceAddCost.next = 0) OR HasChanged
    end;

    local procedure CheckIFAnyPTACustomerInvoicesAdditionalServiceHasChanged(var PTACustomerInvoices: Record PTACustomerInvoices; Var HasChanged: Boolean)
    var
        PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;
        PreviousPTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTACustomerInvoiceAddServ.Reset();
        PTACustomerInvoiceAddServ.SetCurrentKey(InvoiceId, TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange(InvoiceId, PTACustomerInvoices.ID);
        PTACustomerInvoiceAddServ.SetRange(TransactionBatchId, PTACustomerInvoices.TransactionBatchId);
        if PTACustomerInvoiceAddServ.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchCustomerInvoiceServiceByID(PTACustomerInvoiceAddServ, PreviousPTACustomerInvoiceAddServ, PTACustomerInvoiceAddServ.ID);
                HasChanged := (PreviousPTACustomerInvoiceAddServ.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTACustomerInvoiceAddServ);
                    OldRecordRef.GetTable(PreviousPTACustomerInvoiceAddServ);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTACustomerInvoiceAddServ);
                end;
            Until (PTACustomerInvoiceAddServ.next = 0) OR HasChanged
    end;

    var
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}