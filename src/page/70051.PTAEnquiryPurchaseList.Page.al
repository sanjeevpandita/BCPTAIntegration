page 70051 "PTA Enquiry Purchase List"
{
    ApplicationArea = All;
    Caption = 'PTA Enquiry Purchase List';
    PageType = ListPart;
    SourceTable = "Purchase Header";
    Editable = false;

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
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                }
            }
        }
    }
}
