pageextension 70007 "STO Item Categories" extends "Item Categories"
{
    layout
    {
        addafter(Description)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
        }
    }
}