page 70019 "PTA Setup"
{
    ApplicationArea = All;
    Caption = 'PTA Setup';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "PTA Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Master Company Name"; Rec."Master Company Name")
                {
                }
                field("Dummy Country Code"; Rec."Dummy Country Code")
                {
                    ToolTip = 'Specifies the value of the Dummy Country Code field.';
                }

                field("Resource Product Type"; Rec."Resource Product Type")
                {
                    ToolTip = 'Specifies the value of the Resource Product Type field.';
                }

                field("PTA Error Email Recipient"; Rec."PTA Error Email Recipient")
                {
                    ToolTip = 'Specifies the value of the PTA Error Email Recipient field.';
                    MultiLine = true;
                }
                field("Broking Comm. G/L Account"; Rec."Broking Comm. G/L Account")
                {
                    ToolTip = 'Specifies the value of the Broking Comm. G/L Account field.';
                }
                field("PTA Int Commission G/L Acc"; Rec."Int Commission G/L Acc")
                {
                    ToolTip = 'Specifies the value of the PTA Int Commission G/L Acc field.';
                }
                field("Drop Ship Code"; Rec."Drop Ship Code")
                {
                    ToolTip = 'Specifies the value of the Drop Ship Code field.';
                }
                field("Enquiry VAT Prod. Posting"; Rec."Enquiry VAT Prod. Posting")
                {
                    ToolTip = 'Specifies the value of the Enquiry VAT Prod. Posting field.';
                }
                field("Voucher Tolerance"; Rec."Voucher Tolerance")
                {
                    ToolTip = 'Specifies the value of the Voucherr Tolerance field.';
                }
                field("Voucher Tolerace G/L Acc."; Rec."Voucher Tolerace G/L Acc.")
                {
                    ToolTip = 'Specifies the value of the VAT Tolerace G/L Account field.';
                }

            }
            Group(PTAPayments)
            {

                field("Inbound Payment Template"; Rec."Inbound Payment Template")
                {
                    ToolTip = 'Specifies the value of the Inbound Payment Template field.';
                }
                field("Inbound Payment Batch"; Rec."Inbound Payment Batch")
                {
                    ToolTip = 'Specifies the value of the Inbound Payment Batch field.';
                }
                field("Inbound Payment Charge Account"; Rec."Inbound Payment Charge Account")
                {
                    ToolTip = 'Specifies the value of the Inbound Payment Charge Account field.';
                }
                field("Outbound Payment Template"; Rec."Outbound Payment Template")
                {
                    ToolTip = 'Specifies the value of the Outbound Payment Template field.';
                }
                field("Outbound Payment Batch"; Rec."Outbound Payment Batch")
                {
                    ToolTip = 'Specifies the value of the Outbound Payment Batch field.';
                }
                // field("Outbound Payment Charge Acc."; Rec."Outbound Payment Charge Acc.")
                // {
                //     ToolTip = 'Specifies the value of the Outbound Payment Charge Account field.';
                // }

            }
            group(dimension)
            {
                Caption = 'Dimension';
                field("Business Area Dimension"; Rec."Business Area Dimension")
                {
                }
                //DimensionMappingChanged

                // field("Supply Region Dimension"; Rec."Supply Region Dimension")
                // {

                // }
                field("Supply Market Dimension"; Rec."Supply Market Dimension")
                {

                }
                field("Supply Contract Dimension"; Rec."Supply Contract Dimension")
                {
                }
                field("Salesperson/User Dimension"; Rec."Trader Dimension")
                {
                }
                field("Office Dimension Code"; Rec."Office Dimension Code")
                {
                }
            }
            group(Templates)
            {
                field("Item Template Code"; Rec."Item Template Code")
                {
                    ToolTip = 'Specifies the value of the Item Template Code field.';
                }
                field("Resource Template Code"; Rec."Resource Template Code")
                {
                    ToolTip = 'Specifies the value of the Resource Template Code field.';
                }
                field("Customer Template Code"; Rec."Customer Template Code")
                {
                    ToolTip = 'Specifies the value of the Customer Template Code field.';
                }
                field("Vendor Template Code"; Rec."Vendor Template Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Template Code field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

    end;
}
