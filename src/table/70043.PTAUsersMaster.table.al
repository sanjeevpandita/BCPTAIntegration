//MAPPING Salespersons
table 70043 "PTAUsersMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Users";
    LookupPageId = "PTA Users";

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
        }
        field(2; UserName; Text[100])
        {
            Caption = 'UserName';
        }
        field(3; FullName; Text[100])
        {
            Caption = 'FullName';
        }
        field(4; OfficeId; Integer)
        {
            Caption = 'OfficeId';
        }
        field(5; Email; Text[100])
        {
            Caption = 'Email';
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
        field(95000; "BC Salesperson"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Code where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = "Salesperson/Purchaser";
            ValidateTableRelation = false;
            Caption = 'BC Salesperson';
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
