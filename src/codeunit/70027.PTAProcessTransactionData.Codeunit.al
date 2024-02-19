codeunit 70027 PTAProcessTransactionData
{
    trigger OnRun()
    begin
        PTAProcessEnquiries.Run();

    end;

    var
        PTAProcessEnquiries: Codeunit PTAEnquiryProcess;
}