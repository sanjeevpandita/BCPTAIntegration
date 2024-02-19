//MAPPING Item Category
table 70008 "PTAProductTypeMaster"
{
    Caption = 'PTA Product Types';
    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageId = "PTA Product Types";
    LookupPageId = "PTA Product Types";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; ProductType; Text[200])
        {
            Caption = 'ProductType';
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

        field(95000; "BC Item Categoy"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category".Code where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = Currency;
            ValidateTableRelation = false;
            Caption = 'BC Item Categoy';
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
