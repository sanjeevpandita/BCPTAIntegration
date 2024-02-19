tableextension 70025 "STO Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry ID';
            BlankNumbers = BlankZero;
        }
        field(70001; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
        }
        field(70002; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry Number';
            BlankNumbers = BlankZero;
        }
        field(70003; "PTA Vendor ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            BlankNumbers = BlankZero;
            Editable = false;
        }
        field(70004; "PTA Purch. Currency ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Currency ID';
            BlankNumbers = BlankZero;
            Editable = false;
        }
        field(70005; "PTA Linked Deal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal ID';
            BlankNumbers = BlankZero;
        }
        field(70006; "PTA Linked Deal No."; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal No.';
            BlankNumbers = BlankZero;
        }
        field(80000; "PTA VAT Updated By BC"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Updated By BC';
            Editable = false;
        }
        field(80002; "PTA Purch. VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. VAT Amount';
            BlankNumbers = BlankZero;
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

}