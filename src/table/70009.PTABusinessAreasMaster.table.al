//MAPPING  Dimension Value
table 70009 "PTABusinessAreasMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Business Areas";
    LookupPageId = "PTA Business Areas";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; BusinessAreaName; Text[200])
        {
            Caption = 'BusinessAreaName';
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

    }
    procedure SetStyle(): Text[30]
    begin
        if Rec.Processed = 2 then
            Exit('Unfavorable')
        else
            Exit('')
    end;
}
