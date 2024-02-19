tableextension 70024 "STO Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(70000; "PTA Enquiry ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry ID';
            BlankNumbers = BlankZero;
            Editable = false;
        }
        field(70001; "PTA Vessel Name"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vessel Name';
            Editable = false;
        }
        field(70002; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry Number';
            BlankNumbers = BlankZero;
            Editable = false;
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
        field(80007; "PTA Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Created By';
            Editable = false;
        }
        field(80008; "PTA Created At"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Created At';
            Editable = false;
        }
        field(90000; "PTA No. Of Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Purchase Line" where("Document Type" = field("Document Type"), "Document No." = field("No."), "No." = filter(<> ''), Type = filter(> 0)));
            Caption = 'No. Of Lines';
            Editable = false;
        }
        field(90003; "STO Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,3';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "STO Shortcut Dimension 3 Code");
            end;
        }
        field(90004; "STO Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,4';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "STO Shortcut Dimension 4 Code");
            end;
        }
        field(90005; "STO Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,5';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "STO Shortcut Dimension 5 Code");
            end;
        }
        field(90006; "STO Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,6';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "STO Shortcut Dimension 6 Code");
            end;
        }
        field(90007; "STO Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,7';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "STO Shortcut Dimension 7 Code");
            end;
        }
        field(90008; "STO Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,8';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "STO Shortcut Dimension 8 Code");
            end;
        }
    }
    trigger OnInsert()
    begin
        "PTA Created By" := copystr(userid, strpos(userid, '\') + 1);
        "PTA Created At" := CurrentDateTime;
    end;
}