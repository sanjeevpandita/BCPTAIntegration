pageextension 70000 "STO Countries/Regions" extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
            field("PTA Abbreviation 2"; Rec."PTA Abbreviation 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Abbreviation 2 field.';
                Editable = false;
            }
            field("PTA Abbreviation 3"; Rec."PTA Abbreviation 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Abbreviation 3 field.';
                Editable = false;
            }
        }
    }

}