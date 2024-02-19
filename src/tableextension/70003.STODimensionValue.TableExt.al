//MAPPING PTABusinessAreasMaster

tableextension 70003 "STO Dimension Value" extends "Dimension Value"
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index Link';
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
