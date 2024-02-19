//MAPPING PTACityMaster
tableextension 70001 "STO Post Code" extends "Post Code"
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index Link';
            DataClassification = CustomerContent;
        }
        field(70002; "PTA Country ID"; Integer)
        {
            Caption = 'Country ID';
            DataClassification = CustomerContent;
        }
        field(70003; "PTA Country Name"; Text[50])
        {
            Caption = 'Country Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Country/Region".Code where("PTA Index Link" = field("PTA Index Link")));
            Editable = false;
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
