pageextension 70023 "STO Bank Account List" extends "Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = all;
            }
        }
    }
}