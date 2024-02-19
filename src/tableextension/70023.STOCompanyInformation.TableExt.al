tableextension 70023 "STO Company Information" extends "Company Information"
{
    fields
    {
        field(70000; "PTA Base Currency ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Base Currency ID';
        }

        field(70001; "PTA Index Link"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Index Link';
        }
    }
}