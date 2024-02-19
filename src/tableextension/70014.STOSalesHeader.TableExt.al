tableextension 70014 "STO Sales Header" extends "Sales Header"
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
        field(80002; "PTA Parked"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Parked';
        }
        field(80003; "PTA UnParked"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'UnParked';
            trigger OnValidate()
            begin
                if "PTA UnParked" then begin
                    "PTA UnParked By" := USERID;
                    "PTA UnParked DateTime" := CURRENTDATETIME;
                end else begin
                    "PTA UnParked By" := '';
                    "PTA UnParked DateTime" := 0DT;
                end;
            end;
        }
        field(80004; "PTA UnParked By"; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Unparked By';
        }
        field(80005; "PTA UnParked DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Unparked DateTime';
        }
        field(80006; "PTA Assigned Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assigned Invoice No.';
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

    procedure getParkedStyleText(): Text
    begin
        Case True of
            (Rec."PTA Parked") and (NOT rec."PTA UnParked"):
                exit('Attention');
            (Not Rec."PTA Parked") and (rec."PTA UnParked"):
                exit('Favorable');
            else
                Exit('')
        End;
    end;

    trigger OnInsert()
    begin
        "PTA Created By" := copystr(userid, strpos(userid, '\') + 1);
        "PTA Created At" := CurrentDateTime;
    end;
}