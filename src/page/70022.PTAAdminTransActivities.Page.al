page 70022 "PTA Admin Trans. Activities"
{
    Caption = 'PTA Transactions in Error';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "PTA Cue";

    layout
    {
        area(content)
        {
            cuegroup(MasterInError)
            {
                CuegroupLayout = Wide;

                Caption = 'Transactions Records in Error';

                field("Enquiries in Error"; Rec."Enquiries in Error")
                {
                    Caption = 'Enquiries';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enquiries in Error field.';
                }
                field("Customer Invoices in Error"; Rec."Customer Invoices in Error")
                {
                    Caption = 'Customer Invoices';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Invoices in Error field.';
                }
                field("Inbound Payments in Error"; Rec."Inbound Payments in Error")
                {
                    Caption = 'Inbound Payments';
                    ApplicationArea = All;
                }
                field("Parked Invoices"; Rec."Parked Invoices")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supply Regions in Error field.';
                }
                field("Vouchers in Error"; Rec."Vouchers in Error")
                {
                    Caption = 'Vouchers';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vouchers in Error field.';
                }
                field("Outbound Payments in Error"; Rec."Outbound Payments in Error")
                {
                    Caption = 'Outbound Payments';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

    end;

    var
        IsPageReady: Boolean;

}

