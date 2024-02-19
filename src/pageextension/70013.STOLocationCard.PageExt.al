pageextension 70013 "STO Location Card" extends "Location Card"
{
    layout
    {
        addlast(General)
        {

            field("PTA Port Grouping"; Rec."PTA Port Grouping")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Port Grouping field.';
            }
        }
    }
}