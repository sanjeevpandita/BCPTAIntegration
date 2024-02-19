codeunit 70054 "PTA Execute Integration"
{
    trigger OnRun()
    begin
        PTASyncStatus.Get();
        if PTASyncStatus.GetStatus() then
            Error('Sync is running in Company %1', PTASyncStatus."Running in Company")
        else begin
            PTASyncStatus.InsertStatus(CompanyName);
            Commit;
            PTAProcessTransactionData.Run();
            PTACustomerInvoiceProcess.Run();
            PTAInboundPymtReceivedProcess.Run();
            PTAVoucherProcess.Run();
            PTAOutboundPymtReceivedProcess.Run();
            PTASyncStatus.DeactivateStatus();
            Commit();
        end;
    end;

    var
        PTASyncStatus: Record "PTA Sync Status";
        PTAProcessMasterData: Codeunit "PTA Process Master Data";
        PTAProcessTransactionData: Codeunit PTAProcessTransactionData;
        PTACustomerInvoiceProcess: Codeunit PTACustomerInvoiceProcess;
        PTAInboundPymtReceivedProcess: Codeunit PTAInboundPymtReceivedProcess;
        PTAVoucherProcess: Codeunit PTAVoucherProcess;
        PTAOutboundPymtReceivedProcess: Codeunit PTAOutboundPymtReceivedProcess;

}