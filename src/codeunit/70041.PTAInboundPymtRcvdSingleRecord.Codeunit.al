codeunit 70041 PTAInboundPymtRcvdSingleRecord
{

    TableNo = PTAInboundPaymentsReceived;

    trigger OnRun()
    var
        PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived;
    begin
        PTAInboundPaymentsReceived := Rec;
        PTAInboundPymtRcvdValidation.Run(PTAInboundPaymentsReceived);
        PTAInboundPymtRcvdProcess.run(PTAInboundPaymentsReceived);
    end;

    var
        PTAInboundPymtRcvdValidation: Codeunit PTAInboundPymtRcvdValidation;

        PTAInboundPymtRcvdProcess: Codeunit PTAInboundPymtRcvdProcess;

}