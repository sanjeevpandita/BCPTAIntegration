pageextension 70033 "STO Posted Sales Inv. Subform " extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
        }
        addafter("Line Amount")
        {
            field("PTA Deal ID"; Rec."PTA Enquiry ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Deal ID field.';
                editable = false;
            }
            field("PTA Density Factor"; Rec."PTA Density Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Density Factor field.';
                editable = false;
            }
            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Enquiry Number field.';
                editable = false;
            }
            field("PTA Line Entity Type"; Rec."PTA Line Entity Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Entity Type field.';
                editable = false;
            }
            field("PTA Line Entity ID"; Rec."PTA Line Entity ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line Entity ID field.';
                editable = false;
            }

            field("PTA Linked Deal ID"; Rec."PTA Linked Deal ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Linked Deal ID field.';
                editable = false;
            }
            field("PTA Linked Deal No."; Rec."PTA Linked Deal No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Linked Deal No. field.';
                editable = false;
            }
            field("PTA Purch. Currency Code"; Rec."PTA Purch. Currency Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purch. Currency Code field.';
                editable = false;
            }
            field("PTA Purch. Currency ID"; Rec."PTA Purch. Currency ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purch. Currency ID field.';
                editable = false;
            }
            field("PTA Purch. Price UOM"; Rec."PTA Purch. Price UOM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BDR Unit of Measure field.';
                editable = false;
            }
            field("PTA Purch. UOM Code"; Rec."PTA Purch. UOM Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BDR Unit of Measure field.';
                editable = false;
            }
            field("PTA Purchase Price"; Rec."PTA Purchase Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Price field.';
                editable = false;
            }
            field("PTA Related PO"; Rec."PTA Related PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Related PO field.';
                editable = false;
            }
            field("PTA Related PO line No."; Rec."PTA Related PO line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Related PO line No. field.';
                editable = false;
            }
            field("PTA Sell Price"; Rec."PTA Sell Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sell Price field.';
                editable = false;
            }
            field("PTA Vendor Code"; Rec."PTA Vendor Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Code field.';
                editable = false;
            }
            field("PTA Vendor ID"; Rec."PTA Vendor ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor ID field.';
                editable = false;
            }
            field("PTA BDR Del. Quantity"; Rec."PTA BDR Del. Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BDR Del. Quantity field.';
                editable = false;
            }
            field("PTA BDR Unit of Measure"; Rec."PTA BDR Unit of Measure")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BDR Unit of Measure field.';
                editable = false;
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