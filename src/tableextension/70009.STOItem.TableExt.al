tableextension 70009 "STO Item" extends Item
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index ID';
            DataClassification = ToBeClassified;
        }
        field(70001; "PTA IsFuel"; Boolean)
        {
            Caption = 'IsFuel';
            DataClassification = ToBeClassified;
        }
        field(70002; "PTA Density"; Decimal)
        {
            Caption = 'Density';
            DataClassification = ToBeClassified;
        }
        field(70005; "PTA isPhysicalSupplyProduct"; Boolean)
        {
            Caption = 'isPhysicalSupplyProduct';
            DataClassification = ToBeClassified;
        }
        field(70006; "PTA IsAgency"; Boolean)
        {
            Caption = 'IsAgency';
            DataClassification = ToBeClassified;
        }
        field(70007; "PTA IsClaimSettlement"; Boolean)
        {
            Caption = 'IsClaimSettlement';
            DataClassification = ToBeClassified;
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
