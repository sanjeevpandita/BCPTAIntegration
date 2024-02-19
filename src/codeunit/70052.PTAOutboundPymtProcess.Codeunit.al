codeunit 70052 PTAOutboundPymtProcess
{
    TableNo = PTAOutgoingPayments;

    trigger OnRun()
    var
        PTAOutgoingPayments: Record PTAOutgoingPayments;

    begin
        PTAOutgoingPayments := rec;
        PTASetup.get();
        PostPayment(PTAOutgoingPayments);
    end;

    local procedure PostPayment(PTAOutgoingPayments: Record PTAOutgoingPayments)
    var
        GenJournalLine: Record "Gen. Journal Line";
        PTAOutgoingPaymentVouchers: Record PTAOutgoingPaymentVouchers;
        PTAVouchers: Record PTAVouchers;
        VendLedgerEntry: Record "Vendor Ledger Entry";
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";

        PurchInvoiceHeader: Record "Purch. Inv. Header";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", PTASetup."Outbound Payment Template");
        GenJournalLine.SETRANGE("Journal Batch Name", PTASetup."Outbound Payment Batch");
        IF GenJournalLine.FINDLAST THEN
            NextLineNo := GenJournalLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;

        GenJournalLine.INIT;
        GenJournalLine.SetHideValidation(TRUE);
        GenJournalLine.VALIDATE("Journal Template Name", PTASetup."Outbound Payment Template");
        GenJournalLine.VALIDATE("Journal Batch Name", PtaSetup."Outbound Payment Batch");
        GenJournalLine.VALIDATE("Line No.", NextLineNo);
        GenJournalLine.VALIDATE("Document No.", FORMAT(PTAOutgoingPayments.ID));
        GenJournalLine.VALIDATE("Posting Date", DT2Date(PTAOutgoingPayments.PaymentDate));
        GenJournalLine.VALIDATE("Document Date", DT2Date(PTAOutgoingPayments.PaymentDate));
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Vendor);
        GenJournalLine.VALIDATE("Account No.", PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAOutgoingPayments.SupplierId));

        IF PTAOutgoingPayments.StatusId = 4 THEN BEGIN
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Refund);
            GenJournalLine.VALIDATE(Amount, -PTAOutgoingPayments.RequestedAmountPrice);
        END
        ELSE BEGIN
            GenJournalLine.VALIDATE(Amount, PTAOutgoingPayments.RequestedAmountPrice);
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Payment);
        END;

        GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.VALIDATE("Bal. Account No.", PTABCMappingtoIndexID.GetBankAccountFromPTAIndexID(PTAOutgoingPayments.PPLBankAccountId));
        if PTAOutgoingPayments.RequestedAmountCurrencyId <> PTAHelperFunctions.GetCompanyPTAPurchaseCurrency() then
            GenJournalLine.VALIDATE("Currency Code", PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAOutgoingPayments.RequestedAmountCurrencyId))
        else
            GenJournalLine.VALIDATE("Currency Code", '');
        GenJournalLine.VALIDATE("Source Code", 'AUTOPOST');
        GenJournalLine.INSERT();

        PTAOutgoingPaymentVouchers.Reset();
        PTAOutgoingPaymentVouchers.SetRange(OutGoingPaymentId, PTAOutgoingPayments.ID);
        PTAOutgoingPaymentVouchers.SetFilter(voucherId, '<>%1', 0);
        PTAOutgoingPaymentVouchers.SetRange(TransactionBatchId, PTAOutgoingPayments.TransactionBatchId);
        if PTAOutgoingPaymentVouchers.FindSet() then begin
            GenJournalLine.VALIDATE("Applies-to ID", GenJournalLine."Document No.");
            REPEAT
                PTAVouchers.RESET;
                PTAVouchers.SETRANGE(ID, PTAOutgoingPaymentVouchers.VoucherId);
                PTAVouchers.FindLast();

                PurchInvoiceHeader.RESET;
                PurchInvoiceHeader.SETRANGE("Buy-from Vendor No.", PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAOutgoingPayments.SupplierId));
                PurchInvoiceHeader.SETFILTER("Vendor Invoice No.", StrSubstNo('%1*', PTAEnquiryFunctions.RemoveIllegalCharactersInvoiceNumber(PTAVouchers.InvoiceNumber)));
                PurchInvoiceHeader.FindFirst();

                VendLedgerEntry.RESET;
                VendLedgerEntry.SETCURRENTKEY("Document No.");
                VendLedgerEntry.SETRANGE("Vendor No.", GenJournalLine."Account No.");
                VendLedgerEntry.SETRANGE("Document No.", PurchInvoiceHeader."No.");
                VendLedgerEntry.SETRANGE(Open, TRUE);
                IF VendLedgerEntry.FINDFIRST THEN BEGIN
                    IF PTAOutgoingPayments.StatusId = 4 THEN
                        VendLedgerEntry.VALIDATE("Applies-to Doc. Type", VendLedgerEntry."Applies-to Doc. Type"::Refund)
                    ELSE
                        VendLedgerEntry.VALIDATE("Applies-to Doc. Type", VendLedgerEntry."Applies-to Doc. Type"::Payment);
                    VendLedgerEntry.VALIDATE("Applies-to Doc. No.", GenJournalLine."Document No.");
                    VendLedgerEntry.VALIDATE("Applies-to ID", GenJournalLine."Document No.");
                    Case VendLedgerEntry."Applies-to Doc. Type" of
                        VendLedgerEntry."Applies-to Doc. Type"::Payment:
                            VendLedgerEntry.VALIDATE("Amount to Apply", -PTAOutgoingPaymentVouchers.PaidAmount);
                        VendLedgerEntry."Applies-to Doc. Type"::Refund:
                            VendLedgerEntry.VALIDATE("Amount to Apply", PTAOutgoingPaymentVouchers.PaidAmount);
                    End;
                    VendEntryEdit.RUN(VendLedgerEntry);
                END;
            UNTIL PTAOutgoingPaymentVouchers.NEXT = 0;
            GenJournalLine.Modify();
        end;

        GenJnlPostLine.RunWithCheck(GenJournalLine);
    end;

    var
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        PTASetup: Record "PTA Setup";
        NextLineNo: Integer;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAHelperFunctions: codeunit "PTA Helper Functions";

}