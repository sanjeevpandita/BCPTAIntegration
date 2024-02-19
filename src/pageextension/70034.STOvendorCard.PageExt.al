pageextension 70034 "STO vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'PTA Index Link';
            }
        }
    }
}