//MAPPING PTADeliveryTypeMaster

tableextension 70008 "STO Salesperson/Purchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index Link';
            DataClassification = CustomerContent;
        }
        field(70001; "PTA User Short Name"; text[50])
        {
            Caption = 'User Short Name';
            DataClassification = CustomerContent;
        }
        field(70002; "PTA Ignore Expense Claims"; Boolean)
        {
            Caption = 'Ignore Expense Claims';
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