table 70047 PTASupplyRegions
{
    Caption = 'PTASupplyRegions';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[255])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
            DataClassification = CustomerContent;
        }
        field(5; isPermanent; Boolean)
        {
            Caption = 'isPermanent';
            DataClassification = CustomerContent;
        }
        field(6; ModifiedOn; Date)
        {
            Caption = 'ModifiedOn';
            DataClassification = CustomerContent;
        }
        field(7; isPhysical; Boolean)
        {
            Caption = 'isPhysical';
            DataClassification = CustomerContent;
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
