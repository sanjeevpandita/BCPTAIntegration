pageextension 70022 "STO Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = all;
            }
        }
    }
}