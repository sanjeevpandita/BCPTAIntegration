codeunit 70020 PTAEnquiryProcess
{
    trigger OnRun()
    var
        PTAEnquiry: Record PTAEnquiry;
    begin
        HasError := false;
        Comapnyid := PTAHelperFunctions.GetPTACompanyID();
        PTAEnquiry.ReadIsolation := PTAEnquiry.ReadIsolation::UpdLock;
        PTAEnquiry.Reset();
        PTAEnquiry.SetCurrentKey(EntryNo);
        PTAEnquiry.setrange(Processed, 0);
        PTAEnquiry.SetRange(BuyingCompanyId, Comapnyid);

        if not PTAEnquiry.IsEmpty then begin
            HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
            CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::Enquiry, 'Enquiries', HeaderEntryNo);
        end else
            exit;

        if PTAEnquiry.findset(true) then
            repeat
                ClearLastError();
                Commit();
                if PTAProcessSingleEnquiryRecord.Run(PTAEnquiry) then begin
                    PTAHelperFunctions.SetStatusFlagsOnRecords(PTAEnquiry, 1, '');
                    CuPTAIntegrationLog.InsertLogEntry(PTAEnquiry, 1, DummyIntegrationStatus::Success, Format(PTAEnquiry.EnquiryNumber), HeaderEntryNo);
                    CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::Enquiries, Format(PTAEnquiry.EnquiryNumber), DummyIntegrationStatus::Success, PTAEnquiry.RecordId);
                end else begin
                    PTAHelperFunctions.SetStatusFlagsOnRecords(PTAEnquiry, 2, CopyStr(GetLastErrorText(), 1, maxstrlen(PTAEnquiry.ErrorMessage)));
                    CuPTAIntegrationLog.InsertLogEntry(PTAEnquiry, 1, DummyIntegrationStatus::Error, Format(PTAEnquiry.EnquiryNumber), HeaderEntryNo);
                    CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::Enquiries, Format(PTAEnquiry.EnquiryNumber), DummyIntegrationStatus::Error, PTAEnquiry.RecordId);
                    if not hasError then hasError := true;
                end;
            until PTAEnquiry.next = 0;
        if HasError then CuPTAIntegrationLog.SendPTAErrorEmail('Enquiries', HeaderEntryNo);
    end;

    var
        HeaderEntryNo: Integer;
        PTAProcessSingleEnquiryRecord: Codeunit PTAEnquiryProcessSingleRecord;
        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationProcessType: Enum "PTA Integration Process Type";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        hasError: Boolean;
        Comapnyid: Integer;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";

}