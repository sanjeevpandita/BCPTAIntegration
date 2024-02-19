tableextension 70031 "STO Purch CrMemo Line" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(70001; "PTA Deal ID"; Integer)
        {
            Caption = 'Deal ID';
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
            Caption = 'Commission Line';
        }
        field(90003; "STO Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
        }
        field(90004; "STO Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
        }
        field(90005; "STO Shortcut Dimension 5 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
        }
        field(90006; "STO Shortcut Dimension 6 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
        }
        field(90007; "STO Shortcut Dimension 7 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
            CaptionClass = '1,2,7';
        }
        field(90008; "STO Shortcut Dimension 8 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));

        }
    }
}
