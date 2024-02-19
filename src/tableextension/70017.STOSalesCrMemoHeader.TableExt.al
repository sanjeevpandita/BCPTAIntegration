tableextension 70017 "STO Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Enquiry ID';
            BlankNumbers = BlankZero;
        }
        field(70001; "PTA Linked Deal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal ID';
            BlankNumbers = BlankZero;

        }
        field(70002; "PTA Linked Deal No."; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal No.';
            BlankNumbers = BlankZero;
        }

        field(70003; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
        }
        field(70004; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Enquiry Number';
            BlankNumbers = BlankZero;
        }
        field(80000; "PTA VAT Updated By BC"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Updated By BC';
        }
        field(80001; "PTA Sales VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales VAT Amount';
            BlankNumbers = BlankZero;
        }

    }
}