tableextension 70015 "STO Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Enquiry ID';
            BlankNumbers = BlankZero;
            editable = false;
        }
        field(70001; "PTA Linked Deal ID"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal ID';
            BlankNumbers = BlankZero;
            editable = false;

        }
        field(70002; "PTA Linked Deal No."; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Linked Deal No.';
            BlankNumbers = BlankZero;
            editable = false;
        }

        field(70003; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
            editable = false;
        }
        field(70004; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankZero = true;
            Caption = 'Enquiry Number';
            BlankNumbers = BlankZero;
            editable = false;
        }

        field(70005; "PTA Contract Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Contract Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = CONST('CONTRACTS'));
            editable = false;
        }
        field(80006; "PTA Assigned Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assigned Invoice No.';
            editable = false;
        }
        field(90003; "STO Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            editable = false;
            CaptionClass = '1,2,3';
        }
        field(90004; "STO Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            editable = false;
            CaptionClass = '1,2,4';
        }
        field(90005; "STO Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            editable = false;
            CaptionClass = '1,2,5';
        }
        field(90006; "STO Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            editable = false;
            CaptionClass = '1,2,6';
        }
        field(90007; "STO Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            editable = false;
            CaptionClass = '1,2,7';
        }
        field(90008; "STO Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code;
            editable = false;
            CaptionClass = '1,2,8';
        }
    }
}