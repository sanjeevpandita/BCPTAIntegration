tableextension 70029 "STO Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(70001; "PTA Enquiry ID"; Integer)
        {
            Caption = 'Enquiry ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70002; "PTA Linked Deal ID"; Integer)
        {
            Caption = 'Linked Deal ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;

        }
        field(70003; "PTA Linked Deal No."; Integer)
        {
            Caption = 'Linked Deal No.';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;

        }
        field(70004; "PTA Line Entity Type"; Enum "PTA Enquiry Entities")
        {
            Caption = 'Line Type';
            DataClassification = CustomerContent;
        }
        field(70005; "PTA Line Entity ID"; Integer)
        {
            Caption = 'Enquiry Product ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;

        }
        field(70006; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            BlankNumbers = BlankZero;
            Caption = 'Enquiry No.';
        }
        field(70007; "PTA CustomerBrokerComm Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'CustomerBrokerComm Line';
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

    keys
    {

        key(PTAEnquiryID; "PTA Enquiry ID", "PTA Line Entity Type", "PTA Linked Deal ID")
        {

        }
    }


}
