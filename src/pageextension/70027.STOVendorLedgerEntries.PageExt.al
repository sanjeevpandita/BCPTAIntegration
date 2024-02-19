pageextension 70027 "STO Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {

        addafter("Vendor No.")
        {

            field("PTA Vessel Name"; Rec."PTA Vessel Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Vessel Name field.';
            }
            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enquiry Number field.';
            }
        }
    }
}
