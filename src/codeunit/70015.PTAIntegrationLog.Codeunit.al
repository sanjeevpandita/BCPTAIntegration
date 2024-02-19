codeunit 70015 "PTA Integration Log"
{
    trigger OnRun()
    begin
    end;

    procedure GetLastHeaderEntryNo(): Integer
    var
        PTAIntegrationLog: Record "PTA Integration Log";
    begin
        PTAIntegrationLog.reset;
        if PTAIntegrationLog.FindLast() then
            exit(PTAIntegrationLog."Entry No." + 1)
        else
            exit(1);
    end;


    procedure InsertHeaderRecord(ProcessType: Enum "PTA Integration Process Type"; IntegrationText: text; HeaderEntryNo: Integer)
    var
        PTAIntegrationLog: Record "PTA Integration Log";
    begin
        PTAIntegrationLog.Init();
        PTAIntegrationLog."Entry No." := 0;
        PTAIntegrationLog."Integration Date/Time" := CurrentDateTime;
        PTAIntegrationLog."Process Type" := ProcessType;
        PTAIntegrationLog."Entity Name" := IntegrationText;
        PTAIntegrationLog.Description := Copystr(IntegrationText, 1, 250);
        PTAIntegrationLog."Entry No." := HeaderEntryNo;
        PTAIntegrationLog.insert(true);
    end;

    procedure InsertLogEntry(RecordVariant: Variant; IndentationLevel: Integer; Status: Enum "PTA Integration Status"; IntegrationText: text;
                                                                                            HeaderEntryNo: integer)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        DummyGuid: Guid;
        PTAIntegrationLog: Record "PTA Integration Entry Log";
    begin
        if HeaderEntryNo = 0 then Error('HeaderEntryNo is blank');
        PTAIntegrationLog.Init();
        PTAIntegrationLog."Entry No." := 0;

        if RecordVariant.IsRecord then begin
            RecRef.GetTable(RecordVariant);
            PTAIntegrationLog."Record ID" := RecRef.RecordId;
            PTAIntegrationLog."Entity Name" := RecRef.Name;

            //FldRef := RecRef.field(50003);
            //if (Format(FldRef.Value) <> '') then
            //   PTAIntegrationLog.ErrorMessage := Copystr(FldRef.Value, 1, 250);
            PTAIntegrationLog.ErrorMessage := CopyStr(GetLastErrorText(), 1, 250)
        end else
            PTAIntegrationLog."Entity Name" := IntegrationText;

        PTAIntegrationLog.Description := Copystr(IntegrationText, 1, 250);
        PTAIntegrationLog."Integration Status" := Status;
        PTAIntegrationLog.HeaderEntryNo := HeaderEntryNo;
        PTAIntegrationLog."Indendation Level" := IndentationLevel;
        PTAIntegrationLog.insert(true);
    end;

    procedure SendPTAErrorEmail(EntityName: Text; HeaderEntryNo: Integer)
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        URLToOpen: Text;
        PTASetup: Record "PTA Setup";
        PTAIntegrationLog: Record "PTA Integration Log";
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        PTASetup.Get();

        if PTASetup."PTA Error Email Recipient" = '' then exit;

        PTAIntegrationLog.get(HeaderEntryNo);
        PTAIntegrationLog.SetRecFilter();

        URLToOpen := GETURL(ClientType::Current, CompanyName, ObjectType::Page, 70028, PTAIntegrationLog);
        Body := '<h3> Company Name - ' + CompanyName + '</h3></br></br>';
        Body += '<h3>PTA Integration Error - Entity Name : <b>' + EntityName + '</b></h3></br></br>There are errors processing ' + EntityName + ' at ' + Format(PTAIntegrationLog."Integration Date/Time") + '</br></br>';
        Body += '<p>Please <a href="' + URLToOpen + '">login</a> to Business Central to check the PTA integration Error Log.</p>';
        Body += '<p><p>You do not need to reply to this message.</p></p>';

        EmailMessage.Create(PTASetup."PTA Error Email Recipient", StrSubstNo('PTA Integration %1 Error in %2 :' + EntityName, CompanyName), Body, true);

        Email.Send(EmailMessage, Enum::"Email Scenario"::"PTA Integration");

    end;

    internal procedure CheckAndUpdateTransactionStatus(PTAEnquiryEntities: Enum "PTA Enquiry Entities"; DocumentNo: Code[50]; DummyIntegrationStatus: Enum "PTA Integration Status"; VarRecordId: RecordId)
    var
        PTATransactionStatus: Record "PTA Transaction Status";
    begin
        if not PTATransactionStatus.get(PTAEnquiryEntities, DocumentNo) then begin
            PTATransactionStatus.Init();
            PTATransactionStatus."Transaction Type" := PTAEnquiryEntities;
            PTATransactionStatus."Transaction Document No." := DocumentNo;
            PTATransactionStatus."Last Status" := DummyIntegrationStatus;
            PTATransactionStatus."Last Record ID" := VarRecordId;
            PTATransactionStatus."Company Name" := CompanyName;
            if DummyIntegrationStatus = DummyIntegrationStatus::Error then
                PTATransactionStatus."Error Message" := GetLastErrorText();
            PTATransactionStatus.insert(true);

        end else begin
            PTATransactionStatus."Last Status" := DummyIntegrationStatus;
            PTATransactionStatus."Last Record ID" := VarRecordId;
            if DummyIntegrationStatus = DummyIntegrationStatus::Error then
                PTATransactionStatus."Error Message" := GetLastErrorText()
            else
                PTATransactionStatus."Error Message" := '';
            PTATransactionStatus."Last Record ID" := VarRecordId;
            PTATransactionStatus.modify(true);
        end;
    end;

    var
        PTASetupFound: Boolean;

}