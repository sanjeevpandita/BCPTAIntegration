pageextension 70018 "STO Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("STO Shortcut Dimension 3 Code"; Rec."STO Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 3 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 4 Code"; Rec."STO Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 4 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 5 Code"; Rec."STO Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 5 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 6 Code"; Rec."STO Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 6 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 7 Code"; Rec."STO Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 7 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 8 Code"; Rec."STO Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 8 Code field.';
                Visible = false;
            }
        }
        addafter("Buy-from Vendor Name")
        {
            field("PTA Deal ID"; Rec."PTA Enquiry ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Deal ID field.';
                Visible = false;
            }
            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Enquiry Number field.';
            }
            field("PTA Linked Deal ID"; Rec."PTA Linked Deal ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Linked Deal ID field.';
                Visible = false;
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
            field("PTA No. Of Lines"; Rec."PTA No. Of Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. Of Lines field.';
            }
        }
        addfirst(factboxes)
        {
            part("PTA Enquiry Sales Order"; "PTA Enquiry Sales Order")
            {
                ApplicationArea = All;
                Caption = 'Related Enquiry';
                SubPageLink = "Document Type" = Filter('Order'),
                              "PTA Enquiry ID" = field("PTA Enquiry ID");
            }
        }
    }


}