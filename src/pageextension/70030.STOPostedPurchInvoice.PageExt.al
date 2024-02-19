pageextension 70030 "STO Posted Purch. Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        modify("Shortcut Dimension 1 Code") { Visible = false; }
        modify("Shortcut Dimension 2 Code") { Visible = false; }

        addafter(General)
        {
            Group(Dimensions)
            {
                field("STO Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("STO Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("STO Shortcut Dimension 3 Code"; Rec."STO Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the STO Shortcut Dimension 3 Code field.';
                }
                field("STO Shortcut Dimension 4 Code"; Rec."STO Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the STO Shortcut Dimension 4 Code field.';
                }
                field("STO Shortcut Dimension 5 Code"; Rec."STO Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the STO Shortcut Dimension 5 Code field.';
                }
                field("STO Shortcut Dimension 6 Code"; Rec."STO Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the STO Shortcut Dimension 6 Code field.';
                }
                field("STO Shortcut Dimension 7 Code"; Rec."STO Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the STO Shortcut Dimension 7 Code field.';
                }
                field("STO Shortcut Dimension 8 Code"; Rec."STO Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the STO Shortcut Dimension 8 Code field.';
                }
            }
            Group(PTA)
            {

                field("PTA Deal ID"; Rec."PTA Enquiry ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the PTA Deal ID field.';
                }
                field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PTA Enquiry Number field.';
                    Editable = false;
                }
                field("PTA Linked Deal ID"; Rec."PTA Linked Deal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PTA Linked Deal ID field.';
                    Editable = false;
                }
                field("PTA Linked Deal No."; Rec."PTA Linked Deal No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PTA Linked Deal No. field.';
                    Editable = false;
                }
                field("PTA Vessel Name"; Rec."PTA Vessel Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PTA Vessel Name field.';
                    Editable = false;
                }
                field("PTA VAT Updated By BC"; Rec."PTA VAT Updated By BC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Updated By BC field.';
                }
                field("PTA Purch. VAT Amount"; Rec."PTA Purch. VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purch. VAT Amount field.';
                }
                field("PTA Vendor ID"; Rec."PTA Vendor ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor ID field.';
                }
                field("PTA Purch. Currency ID"; Rec."PTA Purch. Currency ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Purch. Currency ID field.';
                }
            }
        }
    }
}