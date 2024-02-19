pageextension 70032 "STO Posted Purch. Inv. Subform" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Line Amount")
        {
            field("PTA Deal ID"; Rec."PTA Enquiry ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deal ID field.';
                Editable = false;
            }
            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Enquiry Number field.';
                Editable = false;
            }
            field("PTA Line Entity ID"; Rec."PTA Line Entity ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enquiry Product ID field.';
                Editable = false;
            }
            field("PTA Line Entity Type"; Rec."PTA Line Entity Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Type field.';
                Editable = false;
            }
            field("PTA Linked Deal ID"; Rec."PTA Linked Deal ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Linked Deal ID field.';
                Editable = false;
            }
            field("PTA Linked Deal No."; Rec."PTA Linked Deal No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Linked Deal No. field.';
                Editable = false;
            }
        }
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
    }
}