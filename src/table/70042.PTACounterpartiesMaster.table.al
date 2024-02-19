//MAPPING Contacts - Conveerted to Customers / Vendors
table 70042 "PTACounterpartiesMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    LookupPageId = "PTA CounterpartiesMaster";
    DrillDownPageId = "PTA CounterpartiesMaster";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(3; Name; Text[510])
        {
            Caption = 'Name';
        }
        field(5; DefaultCurrency; Integer)
        {
            Caption = 'DefaultCurrency';
        }
        field(6; TradingAddress; Integer)
        {
            Caption = 'TradingAddress';
        }
        field(7; AdminAddress; Integer)
        {
            Caption = 'AdminAddress';
        }
        field(8; Phone1; Text[100])
        {
            Caption = 'Phone1';
        }
        field(9; Phone2; Text[100])
        {
            Caption = 'Phone2';
        }
        field(10; Website; Text[1000])
        {
            Caption = 'Website';
        }
        field(11; isCustomer; boolean)
        {
            Caption = 'isCustomer';
        }
        field(12; isVendor; boolean)
        {
            Caption = 'isVendor';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        field(50001; Processed; Integer)
        {
            Caption = 'Processed';
        }
        field(50002; ProcessedDateTime; DateTime)
        {
            Caption = 'ProcessedDateTime';
        }
        field(50003; ErrorMessage; Text[250])
        {
            Caption = 'ErrorMessage';
        }
        field(50004; ErrorDateTime; DateTime)
        {
            Caption = 'ErrorDateTime';
        }
        field(50005; ExternalId; Integer)
        {
            Caption = 'ExternalId';
        }
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(50007; RecordSkippedDateTime; DateTime)
        {
            Caption = 'RecordSkippedDateTime';
        }
        field(50008; RecordSkippedBy; Text[50])
        {
            Caption = 'RecordSkippedBy';
        }
        field(50009; SkipMessage; Text[250])
        {
            Caption = 'SkipMessage';
        }
        field(95000; "BC Customer"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Customer"."No." where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = "Vendor";
            ValidateTableRelation = false;
            Caption = 'BC Customer';
        }
        field(95001; "BC Vendor"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Vendor"."No." where("PTA Index Link" = field(ID)));
            Editable = false;
            TableRelation = "Vendor";
            ValidateTableRelation = false;
            Caption = 'BC Vendor';
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Id; Id)
        {
        }
        key(AdminAddress; AdminAddress)
        {

        }
    }


    procedure SetStyle(): Text[30]
    begin
        if Rec.Processed = 2 then
            Exit('Unfavorable')
        else
            Exit('')
    end;
}
