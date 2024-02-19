pageextension 70010 "STO Resources" extends "Resource List"
{
    layout
    {
        addafter(Name)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index ID field.';
                Editable = false;
            }
            field("PTA Resource Type"; Rec."PTA Resource Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Resource Type field.';
            }
            field("PTA VAT/GST Services"; Rec."PTA VAT/GST Services")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA VAT/GST Services field.';
            }
        }
        modify(type) { Visible = false; }
        modify("Price/Profit Calculation") { Visible = false; }
        modify("Profit %") { Visible = false; }


    }
}