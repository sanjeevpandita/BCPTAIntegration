codeunit 70053 "PTA Run Integration"
{
    trigger OnRun()
    begin
        PTAExecuteIntegration.run();
    end;

    var
        PTAExecuteIntegration: Codeunit "PTA Execute Integration";

}