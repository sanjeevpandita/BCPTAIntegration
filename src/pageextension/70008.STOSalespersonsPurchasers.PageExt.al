pageextension 70008 "STO Salespersons/Purchasers" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter(Name)
        {


            field("PTA Ignore Expense Claims"; Rec."PTA Ignore Expense Claims")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Ignore Expense Claims field.';
                Editable = false;
            }
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
            field("PTA User Short Name"; Rec."PTA User Short Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA User Short Name field.';
                Editable = false;
            }
        }
    }
}