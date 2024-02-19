//MAPPING: PTACountryMaster
tableextension 70000 "STO Country" extends "Country/Region"
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index Link';
            DataClassification = CustomerContent;
        }
        Field(70002; "PTA Abbreviation 2"; code[10])
        {
            Caption = 'Abbreviation 2';
            DataClassification = CustomerContent;
        }
        Field(70003; "PTA Abbreviation 3"; code[10])
        {
            Caption = 'Abbreviation 3';
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
