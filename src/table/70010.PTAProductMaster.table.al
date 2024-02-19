//MAPPING : Item and Resource
table 70010 "PTAProductMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Products";
    LookupPageId = "PTA Products";
    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; ProductName; Text[250])
        {
            Caption = 'ProductName';
        }
        field(3; ProductType; Integer)
        {
            Caption = 'ProductType';
        }
        field(4; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(5; Density; Decimal)
        {
            Caption = 'Density';
        }
        field(7; IsFuel; Boolean)
        {
            Caption = 'IsFuel';
        }
        field(9; IsPhysicalSupplyProduct; Boolean)
        {
            Caption = 'IsPhysicalSupplyProduct';
        }
        field(10; IsAgency; Boolean)
        {
            Caption = 'IsAgency';
        }
        field(11; IsClaimSettlement; Boolean)
        {
            Caption = 'IsClaimSettlement';
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
        field(95000; "BC Product"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("item"."No." where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = Item;
            ValidateTableRelation = false;
            Caption = 'BC Product';
        }
        field(95001; "BC Resource"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Resource"."No." where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = Resource;
            ValidateTableRelation = false;
            Caption = 'BC Resource';
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
