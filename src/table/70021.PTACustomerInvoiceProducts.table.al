table 70021 "PTACustomerInvoiceProducts"
{
    Caption = 'PTA Inbound Invoice Products';
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
        field(40; CustomerInvoiceId; Integer)
        {
            Caption = 'CustomerInvoiceId';
        }
        field(50; EnquiryProductId; Integer)
        {
            Caption = 'EnquiryProductId';
        }
        field(60; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(70; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }
        field(80; Specification; Text[1000])
        {
            Caption = 'Specification';
        }
        field(90; ProductId; Integer)
        {
            Caption = 'ProductId';
        }
        field(100; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(110; UnitId; Integer)
        {
            Caption = 'UnitId';
        }
        field(120; SellPriceUOMId; Integer)
        {
            Caption = 'SellPriceUOMId';
        }
        field(130; WeightingFactor; Decimal)
        {
            Caption = 'WeightingFactor';
        }
        field(140; DeliveryDensity; Decimal)
        {
            Caption = 'DeliveryDensity';
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
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; CustomerInvoiceId, TransactionBatchId)
        {
        }
    }

    fieldgroups
    {
    }
}

