codeunit 70040 PTAInboundPymtReceivedProcess
{
    trigger OnRun()
    var
        PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived;
        ProcessRecord: Boolean;
    begin
        HasError := false;
        companyID := PTAHelperFunctions.GetPTACompanyID();
        PTAInboundPaymentsReceived.ReadIsolation := PTAInboundPaymentsReceived.ReadIsolation::UpdLock;
        PTAInboundPaymentsReceived.Reset();
        PTAInboundPaymentsReceived.SetAutoCalcFields(BCBuyingCompanyId, BankExistsInThisCompany);
        PTAInboundPaymentsReceived.SetCurrentKey(EntryNo);
        PTAInboundPaymentsReceived.setrange(Processed, 0);
        PTAInboundPaymentsReceived.SetRange(BankExistsInThisCompany, true);

        if not PTAInboundPaymentsReceived.IsEmpty then begin
            HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
            CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::Inbound, 'Inbound Payment', HeaderEntryNo);
        end else
            exit;

        if PTAInboundPaymentsReceived.findset(true) then
            repeat
                ClearLastError();
                Commit();
                ProcessRecord := true;
                if (PTAInboundPaymentsReceived.BCBuyingCompanyId <> 0) then
                    if not (PTAInboundPaymentsReceived.BCBuyingCompanyId = companyID) then
                        ProcessRecord := false;

                if ProcessRecord then begin
                    if PTAInboundPymtReceivedSingleRecord.Run(PTAInboundPaymentsReceived) then begin
                        PTAHelperFunctions.SetStatusFlagsOnRecords(PTAInboundPaymentsReceived, 1, '');
                        CuPTAIntegrationLog.InsertLogEntry(PTAInboundPaymentsReceived, 1, DummyIntegrationStatus::Success, Format(PTAInboundPaymentsReceived.ID), HeaderEntryNo);
                        CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::"Inbound Payment", Format(PTAInboundPaymentsReceived.ID), DummyIntegrationStatus::Success, PTAInboundPaymentsReceived.RecordId);
                    end else begin
                        PTAHelperFunctions.SetStatusFlagsOnRecords(PTAInboundPaymentsReceived, 2, CopyStr(GetLastErrorText(), 1, maxstrlen(PTAInboundPaymentsReceived.ErrorMessage)));
                        CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::"Inbound Payment", Format(PTAInboundPaymentsReceived.ID), DummyIntegrationStatus::Error, PTAInboundPaymentsReceived.RecordId);
                        if not hasError then hasError := true;
                    end;
                end;
            until PTAInboundPaymentsReceived.next = 0;

        if HasError then CuPTAIntegrationLog.SendPTAErrorEmail('Inbound Payments', HeaderEntryNo);
    end;

    var
        companyID, HeaderEntryNo : Integer;

        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationProcessType: Enum "PTA Integration Process Type";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        hasError: Boolean;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        PTAInboundPymtReceivedSingleRecord: Codeunit PTAInboundPymtRcvdSingleRecord;
}