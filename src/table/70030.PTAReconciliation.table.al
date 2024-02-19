table 70030 "PTAReconciliation"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(12; "Month No."; Integer)
        {
            Caption = 'Month No.';
        }
        field(16; "Year No."; Integer)
        {
            Caption = 'Year No.';
        }
        field(20; Office; Text[50])
        {
            Caption = 'Office';
        }
        field(30; "Customer Trader"; Text[50])
        {
            Caption = 'Customer Trader';
        }
        field(40; "Business Type"; Text[20])
        {
            Caption = 'Business Type';
        }
        field(50; Contract; Text[50])
        {
            Caption = 'Contract';
        }
        field(60; Customer; Text[250])
        {
            Caption = 'Customer';
        }
        field(70; "Account Country"; Text[50])
        {
            Caption = 'Account Country';
        }
        field(80; Vessel; Text[100])
        {
            Caption = 'Vessel';
        }
        field(90; "Enquiry Number"; Integer)
        {
            Caption = 'Enquiry Number';
        }
        field(100; Port; Text[100])
        {
            Caption = 'Port';
        }
        field(110; Country; Text[50])
        {
            Caption = 'Country';
        }
        field(120; "Delivery Date"; Date)
        {
            Caption = 'Delivery Date';
        }
        field(130; Broker; Text[100])
        {
            Caption = 'Broker';
        }
        field(140; Supplier; Text[100])
        {
            Caption = 'Supplier';
        }
        field(150; "Supplier Trader"; Text[100])
        {
            Caption = 'Supplier Trader';
        }
        field(160; MT; Decimal)
        {
            Caption = 'MT';
        }
        field(170; Margin; Decimal)
        {
            Caption = 'Margin';
        }
        field(172; "Margin Incl. Hedging"; Decimal)
        {
            Caption = 'Margin Incl. Hedging';
        }
        field(175; "Unit Margin"; Decimal)
        {
            Caption = 'Unit Margin';
        }
        field(177; "Sale Total"; Decimal)
        {
            Caption = 'Sale Total';
        }
        field(178; "Assigned To"; Text[50])
        {
            Caption = 'Assigned To';
        }
        field(179; "Invoice No."; Text[50])
        {
            Caption = 'Invoice No.';
        }
        field(180; "Navision MT"; Decimal)
        {
            Caption = 'Navision MT';
        }
        field(190; "Navision Margin"; Decimal)
        {
            Caption = 'Navision Margin';
        }
        field(200; "Reconciled Ok"; Boolean)
        {
            Caption = 'Reconciled Ok';
            trigger OnValidate()
            begin
                if "Reconciled Ok" then
                    "Reconcile Error" := '';
            end;
        }
        field(201; "Reconcile Error"; Text[250])
        {
            Caption = 'Reconcile Error';
        }
        // field(202; "Credits Exists"; Boolean)
        // {
        //     CalcFormula = Exist("Sales Cr.Memo Header" WHERE("External Document No." = FIELD("Enquiry Number")));
        //     FieldClass = FlowField;
        // }
        field(203; "Navision Posted Costs"; Decimal)
        {
            Caption = 'Navision Posted Costs';
        }
        field(204; "G/L Margin"; Decimal)
        {
            Caption = 'G/L Margin';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Delivery Date")
        {
        }
    }

    fieldgroups
    {
    }
}

