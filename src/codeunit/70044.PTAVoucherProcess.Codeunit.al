codeunit 70044 PTAVoucherProcess
{
    trigger OnRun()
    var
        PTAVouchers: Record PTAVouchers;
    begin
        HasError := false;
        companyID := PTAHelperFunctions.GetPTACompanyID();
        PTAVouchers.ReadIsolation := PTAVouchers.ReadIsolation::UpdLock;
        PTAVouchers.Reset();
        PTAVouchers.SetAutoCalcFields(BCBuyingCompanyId);
        PTAVouchers.SetCurrentKey(EntryNo);
        PTAVouchers.setrange(Processed, 0);
        PTAVouchers.SetRange(IsTemporaryVoucher, false);
        PTAVouchers.SetRange(BCBuyingCompanyId, companyID);


        if Not PTAVouchers.IsEmpty then begin
            HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
            CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::Outbound, 'Vouchers', HeaderEntryNo);
        end else
            exit;

        if PTAVouchers.findset(true) then
            repeat
                ClearLastError();
                Commit();
                if PTAVoucherProcessSingleRecord.Run(PTAVouchers) then begin
                    PTAHelperFunctions.SetStatusFlagsOnRecords(PTAVouchers, 1, '');
                    CuPTAIntegrationLog.InsertLogEntry(PTAVouchers, 1, DummyIntegrationStatus::Success, Format(PTAVouchers.InvoiceNumber), HeaderEntryNo);
                    CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::Voucher, Format(PTAVouchers.InvoiceNumber), DummyIntegrationStatus::Success, PTAVouchers.RecordId);
                end else begin
                    PTAHelperFunctions.SetStatusFlagsOnRecords(PTAVouchers, 2, CopyStr(GetLastErrorText(), 1, maxstrlen(PTAVouchers.ErrorMessage)));
                    CuPTAIntegrationLog.InsertLogEntry(PTAVouchers, 1, DummyIntegrationStatus::Error, Format(PTAVouchers.InvoiceNumber), HeaderEntryNo);
                    CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::Voucher, Format(PTAVouchers.InvoiceNumber), DummyIntegrationStatus::Error, PTAVouchers.RecordId);
                    if not hasError then hasError := true;
                end;
            until PTAVouchers.next = 0;
        if HasError then CuPTAIntegrationLog.SendPTAErrorEmail('Vouchers', HeaderEntryNo);
    end;

    var
        companyID, HeaderEntryNo : Integer;

        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationProcessType: Enum "PTA Integration Process Type";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        hasError: Boolean;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        PTAVoucherProcessSingleRecord: Codeunit PTAVoucherProcessSingleRecord;
}