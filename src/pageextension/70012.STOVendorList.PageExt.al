pageextension 70012 "STO Vendor List" extends "Vendor List"
{
    layout
    {
        modify("Country/Region Code")
        {
            Visible = true;
        }
        addafter(Blocked)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index ID field.';
                editable = false;
            }
            field("PTA IsDeleted"; Rec."PTA IsDeleted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Deleted field.';
                editable = false;
            }
        }
    }
}