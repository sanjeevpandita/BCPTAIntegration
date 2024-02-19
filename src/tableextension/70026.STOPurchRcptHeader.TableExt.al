tableextension 70026 "STO Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry ID';
            editable = false;
            BlankNumbers = BlankZero;
        }
        field(70001; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
            editable = false;
        }
        field(70002; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry Number';
            editable = false;
            BlankNumbers = BlankZero;
        }
        field(70003; "PTA Vendor ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor ID';
            editable = false;
            BlankNumbers = BlankZero;
        }
        field(70004; "PTA Purch. Currency ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Currency ID';
            editable = false;
            BlankNumbers = BlankZero;
        }
        field(70005; "PTA Linked Deal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal ID';
            editable = false;
            BlankNumbers = BlankZero;
        }
        field(70006; "PTA Linked Deal No."; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal No.';
            editable = false;
            BlankNumbers = BlankZero;
        }
        field(90003; "STO Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,3';
            editable = false;
        }
        field(90004; "STO Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,4';
            editable = false;
        }
        field(90005; "STO Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,5';
            editable = false;
        }
        field(90006; "STO Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,6';
            editable = false;
        }
        field(90007; "STO Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,7';
            editable = false;
        }
        field(90008; "STO Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            CaptionClass = '1,2,8';
            editable = false;
        }
    }

}