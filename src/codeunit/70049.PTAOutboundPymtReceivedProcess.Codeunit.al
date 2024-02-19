codeunit 70049 PTAOutboundPymtReceivedProcess
{
    trigger OnRun()
    var
        PTAOutgoingPayments: Record PTAOutgoingPayments;
        ProcessRecord: Boolean;
    begin
        HasError := false;
        companyID := PTAHelperFunctions.GetPTACompanyID();
        PTAOutgoingPayments.ReadIsolation := PTAOutgoingPayments.ReadIsolation::UpdLock;
        PTAOutgoingPayments.Reset();
        PTAOutgoingPayments.SetAutoCalcFields(BCBuyingCompanyId, BankExistsInThisCompany);
        PTAOutgoingPayments.SetCurrentKey(EntryNo);
        PTAOutgoingPayments.setrange(Processed, 0);
        PTAOutgoingPayments.SetRange(BankExistsInThisCompany, true);

        if not PTAOutgoingPayments.IsEmpty then begin
            HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
            CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::Outbound, 'Outgoing Payment', HeaderEntryNo);
        end else
            exit;

        if PTAOutgoingPayments.findset(true) then
            repeat
                ClearLastError();
                Commit();
                ProcessRecord := true;
                if (PTAOutgoingPayments.BCBuyingCompanyId <> 0) then
                    if not (PTAOutgoingPayments.BCBuyingCompanyId = companyID) then
                        ProcessRecord := false;

                if ProcessRecord then begin
                    if PTAOutPymtRcvdSingleRecord.Run(PTAOutgoingPayments) then begin
                        PTAHelperFunctions.SetStatusFlagsOnRecords(PTAOutgoingPayments, 1, '');
                        CuPTAIntegrationLog.InsertLogEntry(PTAOutgoingPayments, 1, DummyIntegrationStatus::Success, Format(PTAOutgoingPayments.ID), HeaderEntryNo);
                        CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::"Outbound Payment", Format(PTAOutgoingPayments.ID), DummyIntegrationStatus::Success, PTAOutgoingPayments.RecordId);
                    end else begin
                        PTAHelperFunctions.SetStatusFlagsOnRecords(PTAOutgoingPayments, 2, CopyStr(GetLastErrorText(), 1, maxstrlen(PTAOutgoingPayments.ErrorMessage)));
                        CuPTAIntegrationLog.InsertLogEntry(PTAOutgoingPayments, 1, DummyIntegrationStatus::Error, Format(PTAOutgoingPayments.ID), HeaderEntryNo);
                        CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::"Outbound Payment", Format(PTAOutgoingPayments.ID), DummyIntegrationStatus::Error, PTAOutgoingPayments.RecordId);
                        if not hasError then hasError := true;
                    end;
                end;
            until PTAOutgoingPayments.next = 0;

        if HasError then CuPTAIntegrationLog.SendPTAErrorEmail('Outgoing Payments', HeaderEntryNo);
    end;

    var
        companyID, HeaderEntryNo : Integer;

        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationProcessType: Enum "PTA Integration Process Type";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        hasError: Boolean;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        PTAOutPymtRcvdSingleRecord: Codeunit PTAOutPymtRcvdSingleRecord;
}