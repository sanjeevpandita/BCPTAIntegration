//MAPPING Dimension Values
table 70005 "PTACompanyOfficesMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Company Office";
    LookupPageId = "PTA Company Office";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; Name; Text[200])
        {
            Caption = 'Name';
        }
        field(3; CompanyID; Integer)
        {
            Caption = 'CompanyID';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        field(50001; Processed; Integer)
        {
            Caption = 'Processed';
        }
        field(50002; ProcessedDateTime; DateTime)
        {
            Caption = 'ProcessedDateTime';
        }
        field(50003; ErrorMessage; Text[250])
        {
            Caption = 'ErrorMessage';
        }
        field(50004; ErrorDateTime; DateTime)
        {
            Caption = 'ErrorDateTime';
        }
        field(50005; ExternalId; Integer)
        {
            Caption = 'ExternalId';
        }
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(50007; RecordSkippedDateTime; DateTime)
        {
            Caption = 'RecordSkippedDateTime';
        }
        field(50008; RecordSkippedBy; Text[50])
        {
            Caption = 'RecordSkippedBy';
        }
        field(50009; SkipMessage; Text[250])
        {
            Caption = 'SkipMessage';
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Id; Id)
        {
        }
    }
    procedure SetStyle(): Text[30]
    begin
        if Rec.Processed = 2 then
            Exit('Unfavorable')
        else
            Exit('')
    end;

}