page 70041 "PTA Locations VAT Registration"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Location;
    Editable = true;
    Caption = 'Locations VAT Registration';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name or address of the location.';
                    Editable = false;
                }
                field("PTA VAT Registration Code"; Rec."PTA VAT Registration Code")
                {
                    ToolTip = 'Specifies the value of the VAT Registration Code field.';
                }
                field("PTA VAT Buss. Posting Grp."; Rec."PTA VAT Buss. Posting Grp.")
                {
                    ToolTip = 'Specifies the value of the VAT Buss. Posting Grp. field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}