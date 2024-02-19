table 70049 "PTA Integration Log"
{
    Caption = 'PTA Integration Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            //AutoIncrement = true;
        }
        field(2; "Integration Date/Time"; DateTime)
        {
            Caption = 'Integration Date/Time';
        }
        field(3; "Process Type"; Enum "PTA Integration Process Type")
        {
            Caption = 'Process Type';
        }
        field(4; "Entity Name"; Text[100])
        {
            Caption = 'Entity Name';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(6; "Has Error"; Boolean)
        {
            Caption = 'Has Errors';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Exist("PTA integration Entry Log" where("Integration Status" = filter(Error), HeaderEntryNo = field("Entry No.")));
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(Key2; "Integration Date/Time")
        {

        }
    }

    procedure SetStyle(): Text[30]
    begin
        CalcFields("Has Error");
        if (Rec."Has Error") then
            Exit('Unfavorable')
        else
            Exit('')
    end;

}
