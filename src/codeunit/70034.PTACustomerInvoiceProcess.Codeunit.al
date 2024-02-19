codeunit 70034 PTACustomerInvoiceProcess
{
    trigger OnRun()
    var
        PTACustomerInvoices: Record PTACustomerInvoices;
    begin
        HasError := false;
        PTACustomerInvoices.ReadIsolation := PTACustomerInvoices.ReadIsolation::UpdLock;
        companyID := PTAHelperFunctions.GetPTACompanyID();
        PTACustomerInvoices.Reset();
        PTACustomerInvoices.SetCurrentKey(EntryNo);
        PTACustomerInvoices.setrange(Processed, 0);
        PTACustomerInvoices.SetRange(IsProformaInvoice, false);
        PTACustomerInvoices.SetRange(MWBuyingCompanyId, companyID);

        if not PTACustomerInvoices.IsEmpty then begin
            HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
            CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::Inbound, 'Customer Invoices', HeaderEntryNo);
        end else
            exit;

        if PTACustomerInvoices.findset(true) then
            repeat
                ClearLastError();
                Commit();
                if PTACustInvProcessSingleRecord.Run(PTACustomerInvoices) then begin
                    PTAHelperFunctions.SetStatusFlagsOnRecords(PTACustomerInvoices, 1, '');
                    CuPTAIntegrationLog.InsertLogEntry(PTACustomerInvoices, 1, DummyIntegrationStatus::Success, Format(PTACustomerInvoices.InvoiceNumber), HeaderEntryNo);
                    CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::CustomerInvoice, PTACustomerInvoices.InvoiceNumber, DummyIntegrationStatus::Success, PTACustomerInvoices.RecordId);
                end else begin
                    PTAHelperFunctions.SetStatusFlagsOnRecords(PTACustomerInvoices, 2, CopyStr(GetLastErrorText(), 1, maxstrlen(PTACustomerInvoices.ErrorMessage)));
                    CuPTAIntegrationLog.InsertLogEntry(PTACustomerInvoices, 1, DummyIntegrationStatus::Error, Format(PTACustomerInvoices.InvoiceNumber), HeaderEntryNo);
                    CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::CustomerInvoice, PTACustomerInvoices.InvoiceNumber, DummyIntegrationStatus::Error, PTACustomerInvoices.RecordId);
                    if not hasError then hasError := true;
                end;
            until PTACustomerInvoices.next = 0;
        if HasError then CuPTAIntegrationLog.SendPTAErrorEmail('Customer Invoices', HeaderEntryNo);
    end;

    var

        companyID, HeaderEntryNo : Integer;

        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationProcessType: Enum "PTA Integration Process Type";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        hasError: Boolean;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        PTACustInvProcessSingleRecord: Codeunit PTACustInvProcessSingleRecord;
}