//MAPPING Country/Region
table 70001 "PTACountryMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Countries";
    LookupPageId = "PTA Countries";

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            TableRelation = "Country/Region"."PTA Index Link" where("PTA Index Link" = field(ID));
            ValidateTableRelation = false;
        }
        field(2; Name; Text[200])
        {
            Caption = 'Name';
        }
        field(3; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(4; IsRestrictedForCounterparty; Boolean)
        {
            Caption = 'IsRestrictedForCounterparty';
        }
        field(5; IsRestrictedForVessel; Boolean)
        {
            Caption = 'IsRestrictedForVessel';
        }
        field(6; Abbreviation2; Text[10])
        {
            Caption = 'Abbreviation2';
        }
        field(7; Abbreviation3; Text[10])
        {
            Caption = 'Abbreviation3';
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
        field(95000; "BC Country"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region".Code where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = "Country/Region";
            ValidateTableRelation = false;
            Caption = 'BC Country';
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
