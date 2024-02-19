pageextension 70019 "STO Posted SalevInv. List" extends "Posted Sales Invoices"
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
        addafter("Sell-to Customer Name")
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
            field("PTA Assigned Invoice No."; Rec."PTA Assigned Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assigned Invoice No. field.';
            }
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
    }
}