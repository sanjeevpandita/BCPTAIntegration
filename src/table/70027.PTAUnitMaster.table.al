//MAPPING Unit of Measure
table 70027 "PTAUnitMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Units";
    LookupPageId = "PTA Units";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Abbreviation; Text[100])
        {
            Caption = 'Abbreviation';
        }
        field(4; IsBaseUnit; Boolean)
        {
            Caption = 'IsBaseUnit';
        }
        field(5; ConversionFactor; Decimal)
        {
            Caption = 'ConversionFactor';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(7; ConversionFactorForOtherUnit; Decimal)
        {
            Caption = 'ConversionFactorForOtherUnit';
        }
        field(8; IsGlobalBaseUnit; Boolean)
        {
            Caption = 'IsGlobalBaseUnit';
        }
        field(9; IsDefaultUnitForPurchase; Boolean)
        {
            Caption = 'IsDefaultUnitForPurchase';
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
        field(95001; "BC Unit"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Unit of Measure".code where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = Resource;
            ValidateTableRelation = false;
            Caption = 'BC Unit';
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
