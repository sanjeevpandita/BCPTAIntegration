codeunit 70043 PTAInboundPymtRcvdProcess
{
    TableNo = PTAInboundPaymentsReceived;

    trigger OnRun()
    var
        PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived;

    begin
        PTAInboundPaymentsReceived := rec;
        PTASetup.get();
        PostPayment(PTAInboundPaymentsReceived);
        if PTAInboundPaymentsReceived.Charges <> 0 then
            PostCharges(PTAInboundPaymentsReceived);
    end;

    local procedure PostPayment(PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        GenJournalLine: Record "Gen. Journal Line";
        PTAInboundPayAllocDetails: Record PTAInboundPayAllocDetails;
        PTACustomerInvoices: Record PTACustomerInvoices;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CustEntryEdit: Codeunit "Cust. Entry-Edit";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", PTASetup."Inbound Payment Template");
        GenJournalLine.SETRANGE("Journal Batch Name", PTASetup."Inbound Payment Batch");
        IF GenJournalLine.FINDLAST THEN
            NextLineNo := GenJournalLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;

        GenJournalLine.INIT;
        GenJournalLine.SetHideValidation(TRUE);
        GenJournalLine.VALIDATE("Journal Template Name", PTASetup."Inbound Payment Template");
        GenJournalLine.VALIDATE("Journal Batch Name", PtaSetup."Inbound Payment Batch");
        GenJournalLine.VALIDATE("Line No.", NextLineNo);
        GenJournalLine.VALIDATE("Document No.", FORMAT(PTAInboundPaymentsReceived.ID));
        GenJournalLine.VALIDATE("Posting Date", DT2Date(PTAInboundPaymentsReceived.PaymentDate));
        GenJournalLine.VALIDATE("Document Date", DT2Date(PTAInboundPaymentsReceived.PaymentDate));
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
        GenJournalLine.VALIDATE("Account No.", PTABCMappingtoIndexID.GetCustomerCodeFromPTAIndedID(PTAInboundPaymentsReceived.CounterpartyId));

        IF PTAInboundPaymentsReceived.IsDeleted THEN BEGIN
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Refund);
            GenJournalLine.VALIDATE(Amount, (PTAInboundPaymentsReceived.AmountReceivedPrice + PTAInboundPaymentsReceived.Charges));
        END
        ELSE BEGIN
            GenJournalLine.VALIDATE(Amount, -(PTAInboundPaymentsReceived.AmountReceivedPrice + PTAInboundPaymentsReceived.Charges));
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Payment);
        END;

        GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.VALIDATE("Bal. Account No.", PTABCMappingtoIndexID.GetBankAccountFromPTAIndexID(PTAInboundPaymentsReceived.BankAccountId));
        if PTAInboundPaymentsReceived.AmountReceivedCurrencyId <> PTAHelperFunctions.GetCompanyPTAPurchaseCurrency() then
            GenJournalLine.VALIDATE("Currency Code", PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAInboundPaymentsReceived.AmountReceivedCurrencyId))
        else
            GenJournalLine.VALIDATE("Currency Code", '');
        GenJournalLine.VALIDATE("Source Code", 'AUTOPOST');
        GenJournalLine.INSERT();

        PTAInboundPayAllocDetails.Reset();
        PTAInboundPayAllocDetails.SetRange(PaymentReceivedId, PTAInboundPaymentsReceived.ID);
        PTAInboundPayAllocDetails.SetFilter(InvoiceId, '<>%1', 0);
        PTAInboundPayAllocDetails.SetRange(TransactionBatchId, PTAInboundPaymentsReceived.TransactionBatchId);
        if PTAInboundPayAllocDetails.FindSet() then begin
            GenJournalLine.VALIDATE("Applies-to ID", GenJournalLine."Document No.");
            REPEAT
                PTACustomerInvoices.RESET;
                PTACustomerInvoices.SETRANGE(ID, PTAInboundPayAllocDetails.InvoiceId);
                PTACustomerInvoices.SetRange(StatusId, 4);
                PTACustomerInvoices.FINDFIRST;

                CustLedgerEntry.RESET;
                CustLedgerEntry.SETCURRENTKEY("Document No.");
                CustLedgerEntry.SETRANGE("Customer No.", GenJournalLine."Account No.");
                CustLedgerEntry.SETRANGE("Document No.", PTACustomerInvoices.InvoiceNumber);
                CustLedgerEntry.SETRANGE(Open, TRUE);
                IF CustLedgerEntry.FINDFIRST THEN BEGIN
                    IF PTAInboundPaymentsReceived.IsDeleted THEN
                        CustLedgerEntry.VALIDATE("Applies-to Doc. Type", CustLedgerEntry."Applies-to Doc. Type"::Refund)
                    ELSE
                        CustLedgerEntry.VALIDATE("Applies-to Doc. Type", CustLedgerEntry."Applies-to Doc. Type"::Payment);
                    CustLedgerEntry.VALIDATE("Applies-to Doc. No.", GenJournalLine."Document No.");
                    CustLedgerEntry.VALIDATE("Applies-to ID", GenJournalLine."Document No.");
                    CustLedgerEntry.VALIDATE("Amount to Apply", PTAInboundPayAllocDetails.AllocateAmountPrice);
                    CustEntryEdit.RUN(CustLedgerEntry);
                END;
            UNTIL PTAInboundPayAllocDetails.NEXT = 0;
            GenJournalLine.Modify();
        end;

        GenJnlPostLine.RunWithCheck(GenJournalLine);
    end;

    local procedure PostCharges(PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived)
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJournalLine.INIT;
        GenJournalLine.SetHideValidation(TRUE);
        GenJournalLine.VALIDATE("Journal Template Name", PTASetup."Inbound Payment Template");
        GenJournalLine.VALIDATE("Journal Batch Name", PtaSetup."Inbound Payment Batch");
        //GenJournalLine.VALIDATE("Line No.", NextLineNo);
        GenJournalLine.VALIDATE("Document No.", FORMAT(PTAInboundPaymentsReceived.ID));
        GenJournalLine.VALIDATE("Posting Date", DT2Date(PTAInboundPaymentsReceived.PaymentDate));
        GenJournalLine.VALIDATE("Document Date", DT2Date(PTAInboundPaymentsReceived.PaymentDate));

        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.VALIDATE("Account No.", PTASetup."Inbound Payment Charge Account");

        if PTAInboundPaymentsReceived.AmountReceivedCurrencyId <> PTAHelperFunctions.GetCompanyPTAPurchaseCurrency() then
            GenJournalLine.VALIDATE("Currency Code", PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAInboundPaymentsReceived.AmountReceivedCurrencyId));


        IF PTAInboundPaymentsReceived.IsDeleted THEN BEGIN
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Refund);
            GenJournalLine.VALIDATE(Amount, -PTAInboundPaymentsReceived.Charges);
        END
        ELSE BEGIN
            GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Payment);
            GenJournalLine.VALIDATE(Amount, PTAInboundPaymentsReceived.Charges);
        END;

        GenJournalLine.VALIDATE("Document No.", FORMAT(PTAInboundPaymentsReceived.ID));
        GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.VALIDATE("Bal. Account No.", PTABCMappingtoIndexID.GetBankAccountFromPTAIndexID(PTAInboundPaymentsReceived.BankAccountId));
        GenJournalLine.Description := COPYSTR(StrSubstNo('Charges for Payment Received ID %1', PTAInboundPaymentsReceived.ID), 1, MAXSTRLEN(GenJournalLine.Description));
        GenJnlPostLine.RunWithCheck(GenJournalLine);
    end;

    var
        PTASetup: Record "PTA Setup";
        NextLineNo: Integer;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAHelperFunctions: codeunit "PTA Helper Functions";

}