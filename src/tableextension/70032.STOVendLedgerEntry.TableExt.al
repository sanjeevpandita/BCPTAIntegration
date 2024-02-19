tableextension 70032 "STO Vend. Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {

        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankNumbers = BlankZero;
            Caption = 'Enquiry ID';
        }
        field(70003; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankNumbers = BlankZero;
            Caption = 'Enquiry Number';
        }
        field(70004; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
        }
    }

}