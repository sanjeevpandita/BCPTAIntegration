//MAPPING PTAUnitMaster

tableextension 70005 "STO Unit Of Measure" extends "Unit of Measure"
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index Link';
            DataClassification = CustomerContent;
        }
        field(70001; "PTA Abbreviation"; text[100])
        {
            Caption = 'Abbreviation';
            DataClassification = CustomerContent;
        }
        field(70002; "PTA isBaseUnit"; Boolean)
        {
            Caption = 'Is Base Unit';
            DataClassification = CustomerContent;
        }
        field(70003; "PTA ConversionFactor"; Decimal)
        {
            Caption = 'Conversion Factor';
            DataClassification = CustomerContent;
        }
        field(70004; "PTA ConvertFactorForOtherUnit"; Decimal)
        {
            Caption = 'Conversion Factor for Other Unit';
            DataClassification = CustomerContent;
        }
        field(70005; "PTA IsGlobalBaseUnit"; Boolean)
        {
            Caption = 'IsGlobalBaseUnit';
            DataClassification = CustomerContent;
        }
        field(70006; "PTA IsDefaultUnitForPurchase"; Boolean)
        {
            Caption = 'IsDefaultUnitForPurchase';
            DataClassification = CustomerContent;
        }
        field(80000; "PTA IsDeleted"; Boolean)
        {
            Caption = 'Is Deleted';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PTAIndexLink; "PTA Index Link", "PTA IsDeleted")
        {

        }
    }
}