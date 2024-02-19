pageextension 70026 "STO Cust. Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {

        addafter("Customer No.")
        {
            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Enquiry Number field.';
            }
            field("PTA Linked Deal No."; Rec."PTA Linked Deal No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Linked Deal No. field.';
            }
            field("PTA Vessel Name"; Rec."PTA Vessel Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Vessel Name field.';
            }
        }
    }
}