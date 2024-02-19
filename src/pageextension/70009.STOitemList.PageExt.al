pageextension 70009 "STO Item List" extends "Item List"
{
    layout
    {
        addafter(Description)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index ID field.';
                Editable = false;
            }
            field("PTA IsFuel"; Rec."PTA IsFuel")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IsFuel field.';
                Editable = false;
            }
            field("PTA isPhysicalSupplyProduct"; Rec."PTA isPhysicalSupplyProduct")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the isPhysicalSupplyProduct field.';
                Editable = false;
            }
        }
        modify("Substitutes Exist") { Visible = false; }
        modify("Assembly BOM") { Visible = false; }
        modify("Production BOM No.") { Visible = false; }
        modify("Routing No.") { Visible = false; }
    }
}