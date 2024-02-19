pageextension 70006 "STO Shipment Methods" extends "Shipment Methods"
{
    layout
    {
        addafter(Description)
        {

            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
            field("PTA Abbreviation"; Rec."PTA Abbreviation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Abbreviation field.';
                Editable = false;
            }
        }
    }
}