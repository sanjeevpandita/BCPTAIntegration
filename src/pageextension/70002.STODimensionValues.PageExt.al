pageextension 70002 "STO Dimension Values" extends "Dimension Values"
{
    layout
    {
        addafter(Name)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
            }
        }
    }

}