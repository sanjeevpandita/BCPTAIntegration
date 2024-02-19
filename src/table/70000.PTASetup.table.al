table 70000 "PTA Setup"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; PK; Code[20])
        {
            Caption = 'PK';
        }
        field(2; "Master Company Name"; text[30])
        {
            TableRelation = Company.Name;
            Caption = 'Master Company Name';
        }
        field(3; "Business Area Dimension"; code[20])
        {
            TableRelation = Dimension;
            Caption = 'Business Area Dimension';
        }
        field(4; "Trader Dimension"; code[20])
        {
            TableRelation = Dimension;
            Caption = 'Trader Dimension';
        }
        field(5; "Office Dimension Code"; code[20])
        {
            TableRelation = Dimension;
            Caption = 'Office Dimension Code';
        }
        field(6; "Item Template Code"; Code[20])
        {
            TableRelation = "Config. Template Header" where("Table ID" = filter(27));
            Caption = 'Item Template Code';
        }
        field(7; "Resource Template Code"; Code[20])
        {
            TableRelation = "Config. Template Header" where("Table ID" = filter(156));
            Caption = 'Resource Template Code';
        }
        field(8; "Resource Product Type"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource Product Type';
        }
        //DimensionMappingChanged

        // field(9; "Supply Region Dimension"; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = Dimension;
        //     Caption = 'Supply Region Dimension';
        // }
        field(10; "PTA Error Email Recipient"; text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Error Email Recipient';
        }
        field(11; "Customer Template Code"; Code[20])
        {
            TableRelation = "Customer Templ.";
            Caption = 'Customer Template Code';
        }
        field(12; "Vendor Template Code"; Code[20])
        {
            TableRelation = "Vendor Templ.";
            Caption = 'Vendor Template Code';
        }
        field(13; "Supply Market Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            Caption = 'Supply Market Dimension';
        }

        field(14; "Broking Comm. G/L Account"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Broking Comm. G/L Account';
        }
        field(15; "Drop Ship Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Drop Ship Code';
        }
        field(16; "Int Commission G/L Acc"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Int Commission G/L Acc';
        }
        field(17; "Supply Contract Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
            Caption = 'Supply Contract Dimension';
        }
        field(18; "Enquiry VAT Prod. Posting"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "VAT Product Posting Group";
            Caption = 'Enquiry VAT Prod. Posting';
        }
        field(20; "Voucher Tolerace G/L Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Voucher Tolerace G/L Account';
        }
        field(21; "Inbound Payment Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
            Caption = 'Inbound Payment Template';
        }
        field(22; "Inbound Payment Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Inbound Payment Template"));
            Caption = 'Inbound Payment Batch';
        }
        field(23; "Inbound Payment Charge Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            Caption = 'Inbound Payment Charge Account';
        }
        field(19; "Voucher Tolerance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Outbound Payment Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
            Caption = 'Outbound Payment Template';
        }
        field(25; "Outbound Payment Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Outbound Payment Template"));
            Caption = 'Outbound Payment Batch';
        }

        // field(26; "Outbound Payment Charge Acc."; Code[20])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "G/L Account";
        //     Caption = 'Outbound Payment Charge Account';
        // }
        field(27; "Dummy Country Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; PK)
        {
            Clustered = true;
        }
    }
}