tableextension 70010 "STO Resource" extends Resource
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index ID';
            DataClassification = ToBeClassified;
        }

        field(70003; "PTA Resource Type"; Option)
        {
            OptionMembers = " ","Additional Cost","Additional Service","Cost Type";
            Caption = 'PTA Resource Type';
        }
        field(80000; "PTA IsDeleted"; Boolean)
        {
            Caption = 'Is Deleted';
            DataClassification = CustomerContent;
        }
        field(70004; "PTA VAT/GST Services"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT/GST Service';
        }

    }
    keys
    {
        key(PTAIndexLink; "PTA Index Link", "PTA IsDeleted")
        {

        }
    }
}
