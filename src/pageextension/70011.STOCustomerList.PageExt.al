pageextension 70011 "STO Customer List" extends "Customer List"
{
    layout
    {
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