codeunit 70051 PTAOutboundPymtValidation
{

    TableNo = PTAOutgoingPayments;

    trigger OnRun()
    var
        PTAOutgoingPayments: Record PTAOutgoingPayments;
    begin
        CompanyInfo.get();
        PTASetup.get();

        PTASetup.TestField("Outbound Payment Template");
        PTASetup.TestField("Outbound Payment Batch");
        PTAOutgoingPayments := Rec;

        DeleteOutboundPaymentErrors(PTAOutgoingPayments);
        ValidateOutboundPaymentReceived(PTAOutgoingPayments);
    end;

    procedure ValidateOutboundPaymentReceived(var PTAOutgoingPayments: Record PTAOutgoingPayments)
    begin
        CheckIfPaymentAlreadyPosted(PTAOutgoingPayments);

        if PTAOutgoingPayments.RequestedAmountPrice = 0 then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
               PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('No Amount to process', PTAOutgoingPayments.ID));

        if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAOutgoingPayments.RequestedAmountCurrencyId) = '' then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
               PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('Amount requested Currency Not found', PTAOutgoingPayments.ID));

        CheckVendorAccountExits(PTAOutgoingPayments);
        CheckBankExists(PTAOutgoingPayments);

        ValidatePaymentAllocationDetails(PTAOutgoingPayments);
        Commit();
        PTAOutgoingPayments.Calcfields("Error Exists");
        if PTAOutgoingPayments."Error Exists" then
            Error('Errors validating Payment %1, Check Payment Card for details', PTAOutgoingPayments.ID);
    end;

    local procedure CheckVendorAccountExits(PTAOutgoingPayments: Record PTAOutgoingPayments)
    var
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        PTAProcessCounterparties: Codeunit PTAProcessCounterparties;
        MktgSetup: Record "Marketing Setup";
        Vendor: Record Vendor;
    begin
        // MktgSetup.get();
        // Contact.reset;
        // Contact.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        // Contact.SetRange("PTA IsDeleted", false);
        // Contact.SETRANGE("PTA Index Link", PTAOutgoingPayments.SupplierId);
        // if Contact.IsEmpty then begin
        //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
        //        PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('Counterparty %1 not found', PTAOutgoingPayments.SupplierId));
        //     exit;
        // end;

        // Contact.FindFirst();
        // IF NOT ContactBusinessRelation.GET(Contact."No.", MktgSetup."Bus. Rel. Code for Vendors") THEN
        //     PTAProcessCounterparties.ConvertContactToVendor(Contact);
        Vendor.reset;
        vendor.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Vendor.setrange("PTA Index Link", PTAOutgoingPayments.SupplierId);
        if Vendor.IsEmpty then begin
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
               PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('Counterparty %1 not found', PTAOutgoingPayments.SupplierId));
            exit;
        end;
    end;

    local procedure CheckBankExists(PTAOutgoingPayments: Record PTAOutgoingPayments)
    var
        BankAccount: Record "Bank Account";
    begin
        BankAccount.Reset();
        BankAccount.SetRange("PTA Index Link", PTAOutgoingPayments.PPLBankAccountId);
        if BankAccount.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
                PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('Bank Account %1 not found', PTAOutgoingPayments.PPLBankAccountId));
    end;


    local procedure ValidatePaymentAllocationDetails(PTAOutgoingPayments: Record PTAOutgoingPayments)
    var
        PTAOutgoingPaymentVouchers: Record PTAOutgoingPaymentVouchers;
        PTAVouchers: Record PTAVouchers;
        PurchInvoiceHeader: Record "Purch. Inv. Header";
    begin
        PTAOutgoingPaymentVouchers.Reset();
        PTAOutgoingPaymentVouchers.SetRange(OutGoingPaymentId, PTAOutgoingPayments.ID);
        PTAOutgoingPaymentVouchers.SetRange(TransactionBatchId, PTAOutgoingPayments.TransactionBatchId);
        PTAOutgoingPaymentVouchers.SetFilter(VoucherId, '<>%1', 0);
        if PTAOutgoingPaymentVouchers.FindSet() then
            repeat
                PTAVouchers.RESET;
                PTAVouchers.SETRANGE(ID, PTAOutgoingPaymentVouchers.VoucherId);
                IF not PTAVouchers.FindFirst() THEN
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
                        PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('VoucherId ID %1 not found in Staging Table', PTAOutgoingPaymentVouchers.VoucherId))
                else begin
                    PurchInvoiceHeader.RESET;
                    PurchInvoiceHeader.SETRANGE("Buy-from Vendor No.", PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAOutgoingPayments.SupplierId));
                    PurchInvoiceHeader.SETFILTER("Vendor Invoice No.", StrSubstNo('%1*', PTAEnquiryFunctions.RemoveIllegalCharactersInvoiceNumber(PTAVouchers.InvoiceNumber)));
                    if PurchInvoiceHeader.IsEmpty then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::"Outbound Payment", PTAOutgoingPayments.ID, PTAOutgoingPayments.TransactionBatchId,
                            PTAOutgoingPayments.EntryNo, PTAOutgoingPayments.EntryNo, StrSubstNo('Invoice Number %1 for Payment allocation not posted in BC', PTAVouchers.InvoiceNumber))
                end;
            until PTAOutgoingPaymentVouchers.next = 0
    end;


    local procedure DeleteOutboundPaymentErrors(PTAOutgoingPayments: Record PTAOutgoingPayments)
    var
        PTAEnquiryError: Record PTAEnquiryError;
    begin
        PTAEnquiryError.Reset();
        PTAEnquiryError.SetRange(EntityType, PTAEnquiryError.EntityType::"Outbound Payment");
        PTAEnquiryError.SetRange(EnquiryID, PTAOutgoingPayments.ID);
        PTAEnquiryError.SetRange(BatchID, PTAOutgoingPayments.TransactionBatchId);
        PTAEnquiryError.SetRange(HeaderEntryNo, PTAOutgoingPayments.EntryNo);
        PTAEnquiryError.Deleteall();
    end;

    local procedure CheckIfPaymentAlreadyPosted(var PTAOutgoingPayments: Record PTAOutgoingPayments)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETCURRENTKEY("Document No.");
        VendorLedgerEntry.SetRange("Vendor No.", PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAOutgoingPayments.SupplierId));
        Case PTAOutgoingPayments.StatusId of
            4:
                begin
                    VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Refund);
                    VendorLedgerEntry.SETRANGE("Document No.", FORMAT(PTAOutgoingPayments.ID));
                    IF Not VendorLedgerEntry.IsEmpty THEN
                        ERROR(STRSUBSTNO('Refund ID %1 already posted posted.', FORMAT(PTAOutgoingPayments.ID)));
                end;
            2:
                begin
                    VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Payment);
                    VendorLedgerEntry.SETRANGE("Document No.", FORMAT(PTAOutgoingPayments.ID));
                    IF Not VendorLedgerEntry.IsEmpty THEN
                        ERROR(STRSUBSTNO('Payments ID %1 already posted posted.', FORMAT(PTAOutgoingPayments.ID)));
                end;
        End;

        // IF NOT PTAOutgoingPayments.IsDeleted THEN BEGIN
        //     VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Payment);
        //     VendorLedgerEntry.SETRANGE("Document No.", FORMAT(PTAOutgoingPayments.ID));
        //     IF Not VendorLedgerEntry.IsEmpty THEN
        //         ERROR(STRSUBSTNO('Payment ID %1 already posted.', FORMAT(PTAOutgoingPayments.ID)));
        // END ELSE BEGIN
        // END;
    end;

    var

        PTASetup: Record "PTA Setup";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;

        SalesInvoiceHeader: Record "Sales Invoice Header";
        CompanyInfo: Record "Company Information";
}