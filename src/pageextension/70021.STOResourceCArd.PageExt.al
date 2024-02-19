pageextension 70021 "STO Resource CArd" extends "Resource Card"
{
    layout
    {
        addlast(General)
        {
            field("PTA VAT/GST Services"; Rec."PTA VAT/GST Services")
            {
                ApplicationArea = all;
            }
        }
    }
}