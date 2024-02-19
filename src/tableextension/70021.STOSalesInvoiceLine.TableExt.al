tableextension 70021 "STO Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(70000; "PTA Sell Price"; Decimal)
        {
            Caption = 'Sell Price';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70001; "PTA Purch. Currency ID"; Integer)
        {
            Caption = 'Purch. Currency ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70002; "PTA Vendor ID"; Integer)
        {
            Caption = 'Vendor ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70003; "PTA Purchase Price"; Decimal)
        {
            Caption = 'Purchase Price';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70005; "PTA Enquiry ID"; Integer)
        {
            Caption = 'Enquiry ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70006; "PTA Linked Deal ID"; Integer)
        {
            Caption = 'Linked Deal ID';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70007; "PTA Linked Deal No."; Integer)
        {
            Caption = 'Linked Deal No.';
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
        }
        field(70009; "PTA Purch. Currency Code"; Code[20])
        {
            Caption = 'Purch. Currency Code';
            DataClassification = CustomerContent;
        }
        field(70010; "PTA Vendor Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Code';
        }
        field(70011; "PTA Density Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
            Caption = 'Density Factor';
        }
        field(70012; "PTA BDR Del. Quantity"; Decimal)
        {
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
            Caption = 'BDR Del. Quantity';
        }
        field(70013; "PTA BDR Unit of Measure"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'BDR Unit of Measure';
        }
        field(70014; "PTA Line Entity Type"; Enum "PTA Enquiry Entities")
        {
            DataClassification = CustomerContent;
            Caption = 'Line Entity Type';
        }
        field(70015; "PTA Line Entity ID"; Integer)
        {
            DataClassification = CustomerContent;
            BlankNumbers = BlankZero;
            Caption = 'Line Entity ID';
        }
        field(70016; "PTA Purch. UOM Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purchase UOM';
        }
        field(70017; "PTA Purch. Price UOM"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Purch. Price UOM';
        }
        field(700018; "PTA Enquiry Number"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Enquiry Number';
        }
        field(70019; "PTA Related PO"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Related PO';
            TableRelation = "Purchase Header"."No." where("Document Type" = filter(Order));
            ValidateTableRelation = false;
        }
        field(70020; "PTA Related PO line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Related PO line No.';
            TableRelation = "Purchase Line"."Line No." where("Document Type" = filter(order), "Document No." = field("PTA Related PO"));
            ValidateTableRelation = false;
        }
        field(70021; "PTA CustomerBrokerComm Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PTA CustomerBrokerComm Line';
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
    keys
    {
        key(PTA; "PTA Enquiry ID", "PTA Vendor ID", "PTA Purch. Currency ID")
        {
        }
        key(PTA2; "PTA Line Entity Type", "PTA Line Entity ID")
        {
        }
    }

}
