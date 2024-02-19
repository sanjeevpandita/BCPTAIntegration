page 70052 "PTA Enquiry Sales Order"
{
    ApplicationArea = All;
    Caption = 'PTA Enquiry Sales Order';
    PageType = ListPart;
    SourceTable = "Sales header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    trigger OnDrillDown()
                    begin
                        page.RunModal(0, rec);
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
            }
        }
    }
}
