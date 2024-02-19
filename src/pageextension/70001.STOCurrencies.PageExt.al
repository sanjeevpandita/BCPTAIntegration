pageextension 70001 "STO Currencies" extends Currencies
{
    layout
    {
        addafter(code)
        {

            field("PTA Abbreviation"; Rec."PTA Abbreviation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Abbreviation field.';
                Editable = false;
            }
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                Editable = false;
            }
        }
    }
}