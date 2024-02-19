tableextension 70016 "STO Sales Invoice Header" extends "Sales Invoice Header"
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
        field(70005; "PTA Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = CONST('CONTRACTS'));
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
        field(80004; "PTA UnParked By"; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unparked By';
        }
        field(80005; "PTA Unparked DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unparked DateTime';
        }
        field(80006; "PTA Assigned Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assigned Invoice No.';
            Editable = false;
        }
        field(90003; "STO Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,3';
        }
        field(90004; "STO Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,4';
        }
        field(90005; "STO Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,5';
        }
        field(90006; "STO Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,6';
        }
        field(90007; "STO Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,7';
        }
        field(90008; "STO Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,8';
        }
    }

    keys
    {
        key(EnquiryID; "PTA Enquiry ID")
        {

        }
    }
}