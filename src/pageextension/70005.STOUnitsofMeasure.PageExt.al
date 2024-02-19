pageextension 70005 "STO Units of Measure" extends "Units of Measure"
{
    layout
    {
        addafter("International Standard Code")
        {

            field("PTA Abbreviation"; Rec."PTA Abbreviation")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Abbreviation field.';
                editable = false;
            }
            field("PTA ConversionFactor"; Rec."PTA ConversionFactor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Conversion Factor field.';
                editable = false;
            }
            field("PTA ConvertFactorForOtherUnit"; Rec."PTA ConvertFactorForOtherUnit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Conversion Factor for Other Unit field.';
                editable = false;
            }
            field("PTA Index Link"; Rec."PTA Index Link")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Index Link field.';
                editable = false;
            }
            field("PTA isBaseUnit"; Rec."PTA isBaseUnit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Base Unit field.';
                editable = false;
            }
            field("PTA IsDefaultUnitForPurchase"; Rec."PTA IsDefaultUnitForPurchase")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IsDefaultUnitForPurchase field.';
                editable = false;
            }
            field("PTA IsGlobalBaseUnit"; Rec."PTA IsGlobalBaseUnit")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the IsGlobalBaseUnit field.';
                editable = false;
            }
        }

    }
}