pageextension 70035 "STO Customer Card" extends "Customer Card"
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