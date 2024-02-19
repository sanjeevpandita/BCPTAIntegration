pageextension 70004 "STO Location List" extends "Location List"
{
    layout
    {
        addafter(Name)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
            field("PTA Port Abbreviation"; Rec."PTA Port Abbreviation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Port Abbreviation field.';
                Editable = false;
            }
            field("PTA Supply Region ID"; Rec."PTA Supply Region ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Supply Region ID field.';
                Editable = false;
            }
            field("PTA IsDeleted"; Rec."PTA IsDeleted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Deleted field.';
            }
            field("PTA Port Grouping"; Rec."PTA Port Grouping")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Port Grouping field.';
            }
        }
    }
}