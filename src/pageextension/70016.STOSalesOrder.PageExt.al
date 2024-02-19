pageextension 70016 "STO Sales Order" extends "Sales Order"
{
    layout
    {
        modify("Shortcut Dimension 1 Code") { Visible = false; }
        modify("Shortcut Dimension 2 Code") { Visible = false; }
        addafter("External Document No.")
        {
            field("PTA Assigned Invoice No."; Rec."PTA Assigned Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assigned Invoice No. field.';
            }
        }

        addafter(General)
        {
            Group(PTA)
            {
                field("PTA Enquiry ID"; Rec."PTA Enquiry ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PTA Enquiry ID field.';
                    Editable = false;
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
                field("PTA Created By"; Rec."PTA Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("PTA Created At"; Rec."PTA Created At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created At field.';
                }
            }
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
        }
        addfirst(factboxes)
        {
            part("PTA Enquiry Purchase List"; "PTA Enquiry Purchase List")
            {
                ApplicationArea = All;
                Caption = 'Trading Purchase Orders';
                SubPageLink = "Document Type" = Filter('Order'),
                              "PTA Enquiry ID" = field("PTA Enquiry ID");
            }
        }
    }
}