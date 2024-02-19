tableextension 70018 "STO Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry ID';
        }
        field(70001; "PTA Linked Deal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Linked Deal ID';
        }
        field(70002; "PTA Linked Deal No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Linked Deal No.';
        }
        field(70003; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry Number';
        }
        field(70004; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
        }

    }

}