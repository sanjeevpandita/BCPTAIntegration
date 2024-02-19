//MAPPING Currency
table 70006 "PTACurrenciesMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Currency Master";
    LookupPageId = "PTA Currency Master";

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Abbreviation; Text[100])
        {
            Caption = 'Abbreviation';
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
        field(95000; "BC Currency"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Currency".Code where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = Currency;
            ValidateTableRelation = false;
            Caption = 'BC Currency';
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
