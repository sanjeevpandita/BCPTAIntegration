pageextension 70036 "STO General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        modify("User ID")
        {
            visible = true;
        }
        addafter("Document No.")
        {
            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enquiry Number field.';
            }
            field("PTA Linked Deal No."; Rec."PTA Linked Deal No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Linked Deal No. field.';
            }
            field("PTA Vessel Name"; Rec."PTA Vessel Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vessel Name field.';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}