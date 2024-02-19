page 70023 "PTA Admin Master Activities"
{
    Caption = 'PTA Master in Error';
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

                Caption = 'Master Records in Error';
                field("Currencies in Error"; Rec."Currencies in Error")
                {
                    Caption = 'Currencies';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currencies in Error field.';
                    DrillDownPageID = "PTA Currency Master";
                }
                field("Currency Exch. in Error"; Rec."Currency Exch. in Error")
                {
                    Caption = 'Currency Exch.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Exch. in Error field.';
                }
                field("Units in Error"; Rec."Units in Error")
                {
                    Caption = 'Units';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Units in Error field.';
                }
                field("Delivery Types in Error"; Rec."Delivery Types in Error")
                {
                    Caption = 'Delivery Types';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Types in Error field.';
                }
                field("Business Areas in Error"; Rec."Business Areas in Error")
                {
                    Caption = 'Business Areas';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Business Areas in Error field.';
                }
                field("Supply Regions in Error"; Rec."Supply Regions in Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supply Regions in Error field.';
                    Caption = 'Supply Regions';
                }
                field("Countries in Error"; Rec."Countries in Error")
                {
                    Caption = 'Countries';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Countries in Error field.';
                }
                field("City in Error"; Rec."City in Error")
                {
                    Caption = 'City';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City in Error field.';
                }
                field("Company Offices in Error"; Rec."Company Offices in Error")
                {
                    Caption = 'Company Offices';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Offices in Error field.';
                }
                field("Product Types in Error"; Rec."Product Types in Error")
                {
                    Caption = 'Product Types';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Types in Error field.';
                }
                field("Products in Error"; Rec."Products in Error")
                {
                    ApplicationArea = All;
                    Caption = 'Products/Resources';
                    ToolTip = 'Specifies the value of the Products in Error field.';
                }
                field("Ports in Error"; Rec."Ports in Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ports in Error field.';
                    Caption = 'Ports';
                }
                field("Counterparites in Error"; Rec."Counterparites in Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Counterparites in Error field.';
                    Caption = 'Counterparties';
                }
                field("Users in Error"; Rec."Users in Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Users in Error field.';
                    Caption = 'Users';
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

