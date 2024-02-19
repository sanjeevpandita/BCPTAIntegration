pageextension 70003 "STO Post Codes" extends "Post Codes"
{
    layout
    {
        addafter("Country/Region Code")
        {

            field("PTA Country ID"; Rec."PTA Country ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Country ID field.';
                Editable = false;
            }
            field("PTA Country Name"; Rec."PTA Country Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Country Name field.';
                Editable = false;
            }
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}