codeunit 70050 PTAOutPymtRcvdSingleRecord
{

    TableNo = PTAOutgoingPayments;

    trigger OnRun()
    var
        PTAOutgoingPayments: Record PTAOutgoingPayments;
    begin
        PTAOutgoingPayments := Rec;
        if Not (PTAOutgoingPayments.StatusId in [2, 4]) then exit;
        PTAOutboundPymtValidation.Run(PTAOutgoingPayments);
        PTAOutboundPymtProcess.run(PTAOutgoingPayments);
    end;

    var
        PTAOutboundPymtValidation: Codeunit PTAOutboundPymtValidation;

        PTAOutboundPymtProcess: Codeunit PTAOutboundPymtProcess;

}