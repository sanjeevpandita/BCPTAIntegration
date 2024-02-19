pageextension 70020 "STO Company Information" extends "Company Information"
{
    layout
    {
        Addlast(general)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
            }
            field("PTA Base Currency ID"; Rec."PTA Base Currency ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Base Currency ID field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
}