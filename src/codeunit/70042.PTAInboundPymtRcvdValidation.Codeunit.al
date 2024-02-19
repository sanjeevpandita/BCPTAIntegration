codeunit 70042 PTAInboundPymtRcvdValidation
{

    TableNo = PTAInboundPaymentsReceived;

    trigger OnRun()
    var
        PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived;
    begin
        CompanyInfo.get();
        PTASetup.get();

        PTASetup.TestField("Inbound Payment Template");
        PTASetup.TestField("Inbound Payment Batch");
        PTASetup.TestField("Inbound Payment Charge Account");

        PTAInboundPaymentsReceived := Rec;
        DeleteInboundPaymentErrors(PTAInboundPaymentsReceived);
        ValidateInboundPaymentReceived(PTAInboundPaymentsReceived);
    end;

    procedure ValidateInboundPaymentReceived(var PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    begin
        CheckIfPaymentAlreadyPosted(PTAInboundPaymentsReceived);

        if PTAInboundPaymentsReceived.AmountReceivedPrice + PTAInboundPaymentsReceived.Charges = 0 then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
               PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('No Amount to process', PTAInboundPaymentsReceived.ID));

        if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAInboundPaymentsReceived.AmountReceivedCurrencyId) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
               PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('Amount Received Currency Not found', PTAInboundPaymentsReceived.ID));

        CheckCustomerAccountExits(PTAInboundPaymentsReceived);
        CheckBankExists(PTAInboundPaymentsReceived);

        ValidatePaymentAllocationDetails(PTAInboundPaymentsReceived);
        Commit();
        PTAInboundPaymentsReceived.Calcfields("Error Exists");
        if PTAInboundPaymentsReceived."Error Exists" then
            Error('Errors validating Payment %1, Check Payment Card for details', PTAInboundPaymentsReceived.ID);
    end;

    local procedure CheckCustomerAccountExits(PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        // Contact: Record Contact;
        // ContactBusinessRelation: Record "Contact Business Relation";
        // PTAProcessCounterparties: Codeunit PTAProcessCounterparties;
        // MktgSetup: Record "Marketing Setup";
        Customer: Record "Customer";

    begin
        // MktgSetup.get();
        // Contact.reset;
        // Contact.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        // Contact.SetRange("PTA IsDeleted", false);
        // Contact.SETRANGE("PTA Index Link", PTAInboundPaymentsReceived.CounterpartyId);
        // if Contact.IsEmpty then begin
        //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
        //        PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('Counteparty %1 not found', PTAInboundPaymentsReceived.CounterPartyID));
        //     exit;
        // end;

        // Contact.FindFirst();
        // IF NOT ContactBusinessRelation.GET(Contact."No.", MktgSetup."Bus. Rel. Code for Customers") THEN
        //     PTAProcessCounterparties.ConvertContactToCustomer(Contact);
        Customer.reset;
        customer.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        customer.setrange("PTA Index Link", PTAInboundPaymentsReceived.CounterpartyId);
        Customer.setrange("PTA IsDeleted", false);
        if customer.IsEmpty then begin
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
                PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('Customer %1 not found', PTAInboundPaymentsReceived.CounterPartyID));
            exit;
        end;
    end;

    local procedure CheckBankExists(PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Reset();
        BankAccount.SetRange("PTA Index Link", PTAInboundPaymentsReceived.BankAccountId);
        if BankAccount.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
                PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('Bank Account %1 not found', PTAInboundPaymentsReceived.BankAccountId));
    end;


    local procedure ValidatePaymentAllocationDetails(PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        PTAInboundPayAllocDetails: Record PTAInboundPayAllocDetails;
        PTACustomerInvoices: Record PTACustomerInvoices;
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        PTAInboundPayAllocDetails.Reset();
        PTAInboundPayAllocDetails.SetRange(PaymentReceivedId, PTAInboundPaymentsReceived.ID);
        PTAInboundPayAllocDetails.SetRange(TransactionBatchId, PTAInboundPaymentsReceived.TransactionBatchId);
        PTAInboundPayAllocDetails.SetFilter(InvoiceId, '<>%1', 0);
        if PTAInboundPayAllocDetails.FindSet() then
            repeat
                PTACustomerInvoices.RESET;
                PTACustomerInvoices.SETRANGE(ID, PTAInboundPayAllocDetails.InvoiceId);
                PTACustomerInvoices.SetRange(StatusId, 4);
                IF not PTACustomerInvoices.FindFirst() THEN
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
                        PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('Invoice ID %1 not found', PTAInboundPayAllocDetails.InvoiceId))
                else
                    if not SalesInvoiceHeader.get(PTACustomerInvoices.InvoiceNumber) then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Inbound Payment", PTAInboundPaymentsReceived.ID, PTAInboundPaymentsReceived.TransactionBatchId,
                            PTAInboundPaymentsReceived.EntryNo, PTAInboundPaymentsReceived.EntryNo, StrSubstNo('Invoice Number %1 for Payment allocation not posted in BC', PTACustomerInvoices.InvoiceNumber))
            until PTAInboundPayAllocDetails.next = 0
    end;

    local procedure DeleteInboundPaymentErrors(PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        PTAEnquiryError: Record PTAEnquiryError;
    begin
        PTAEnquiryError.Reset();
        PTAEnquiryError.SetRange(EntityType, PTAEnquiryError.EntityType::"Inbound Payment");
        PTAEnquiryError.SetRange(EnquiryID, PTAInboundPaymentsReceived.ID);
        PTAEnquiryError.SetRange(BatchID, PTAInboundPaymentsReceived.TransactionBatchId);
        PTAEnquiryError.SetRange(HeaderEntryNo, PTAInboundPaymentsReceived.EntryNo);
        PTAEnquiryError.Deleteall();
    end;

    local procedure CheckIfPaymentAlreadyPosted(var PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETCURRENTKEY("Document No.");
        CustLedgerEntry.SetRange("Customer No.", PTABCMappingtoIndexID.GetCustomerCodeFromPTAIndedID(PTAInboundPaymentsReceived.CounterpartyId));

        IF NOT PTAInboundPaymentsReceived.IsDeleted THEN BEGIN
            CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
            CustLedgerEntry.SETRANGE("Document No.", FORMAT(PTAInboundPaymentsReceived.ID));
            IF Not CustLedgerEntry.IsEmpty THEN
                ERROR(STRSUBSTNO('Payment ID %1 already posted.', FORMAT(PTAInboundPaymentsReceived.ID)));
        END ELSE BEGIN
            CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Refund);
            CustLedgerEntry.SETRANGE("Document No.", FORMAT(PTAInboundPaymentsReceived.ID));
            IF Not CustLedgerEntry.IsEmpty THEN
                ERROR(STRSUBSTNO('Refund ID %1 already posted posted.', FORMAT(PTAInboundPaymentsReceived.ID)));
        END;
    end;

    var

        PTASetup: Record "PTA Setup";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;

        SalesInvoiceHeader: Record "Sales Invoice Header";
        CompanyInfo: Record "Company Information";
}