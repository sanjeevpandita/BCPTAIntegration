tableextension 70019 "STO G/L Entry" extends "G/L Entry"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry ID';
            BlankNumbers = BlankZero;
        }
        field(70001; "PTA Linked Deal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Linked Deal ID';
            BlankNumbers = BlankZero;
        }
        field(70002; "PTA Linked Deal No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Linked Deal No.';
            BlankNumbers = BlankZero;
        }
        field(70003; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry Number';
            BlankNumbers = BlankZero;
        }
        field(70004; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
        }
    }

}