table 70016 "PTAVoucherEnquiries"
{

    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {

        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(30; EnquiryId; Integer)
        {
            Caption = 'EnquiryId';
        }
        field(40; VoucherId; Integer)
        {
            Caption = 'VoucherId';
        }
        field(50; MWBuyingCompanyId; Integer)
        {
            Caption = 'MWBuyingCompanyId';
        }

        Field(1000; TransactionBatchId; integer)
        {
            Caption = 'TransactionBatchId';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }

        field(50001; "Enquiry Number"; Integer)
        {
            CalcFormula = Lookup(PTAEnquiry.EnquiryNumber WHERE(ID = field(EnquiryId)));
            FieldClass = FlowField;
        }
        // field(50000; "Invoice Date"; Date)
        // {
        //     CalcFormula = Lookup("PTA Inbound Vouchers"."Invoice Date" WHERE(ID = FIELD(VoucherId)));
        //     FieldClass = FlowField;
        // }
        // field(50001; "Invoice Number"; Code[50])
        // {
        //     CalcFormula = Lookup("PTA Inbound Vouchers".InvoiceNumber WHERE(ID = FIELD(VoucherId)));
        //     FieldClass = FlowField;
        // }
        // field(50002; "Late Commission Entry"; Boolean)
        // {
        // }
        // field(50003; "Total Invoice Amount"; Decimal)
        // {
        //     CalcFormula = Lookup("PTA Inbound Vouchers".TotalInvoiceAmount WHERE(ID = FIELD(VoucherId)));
        //     FieldClass = FlowField;
        // }
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; EnquiryId, VoucherId)
        { }
    }

    fieldgroups
    {
    }
}

