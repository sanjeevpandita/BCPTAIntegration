page 70050 "PTA Location VAT Setup"
{
    ApplicationArea = All;
    Caption = 'Location VAT Setup';
    AdditionalSearchTerms = 'Port VAT Setup,PTA VAT Setup';
    PageType = List;
    SourceTable = location;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("PTA Index Link"; Rec."PTA Index Link")
                {
                    ToolTip = 'Specifies the value of the PTA Index Link field.';
                    Editable = false;
                }
                field("PTA Port Abbreviation"; Rec."PTA Port Abbreviation")
                {
                    ToolTip = 'Specifies the value of the Port Abbreviation field.';
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
}
