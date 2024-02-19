table 70022 "PTACustomerInvoiceAddCost"
{
    Caption = 'PTA Inbound Invoice Add Cost';
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
        field(40; InvoiceId; Integer)
        {
            Caption = 'InvoiceId';
        }
        field(50; EnquiryAdditionalCostId; Integer)
        {
            Caption = 'EnquiryAdditionalCostId';
        }
        field(60; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(70; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }
        field(80; CostTypeId; Integer)
        {
            Caption = 'CostTypeId';
        }
        field(90; ApplicableQuantity; Decimal)
        {
            Caption = 'ApplicableQuantity';
        }
        field(100; ApplicableUnitId; Integer)
        {
            Caption = 'ApplicableUnitId';
        }
        field(110; SellLumpsum; Decimal)
        {
            Caption = 'SellLumpsum';
        }
        field(120; FixedQuantity; Decimal)
        {
            Caption = 'FixedQuantity';
        }
        field(130; WeightingFactor; Decimal)
        {
            Caption = 'WeightingFactor';
        }
        field(140; PercentileAdditionalCostTypeId; Integer)
        {
            Caption = 'PercentileAdditionalCostTypeId';
        }
        field(150; PercentAddCostTotAmtCurrencyId; Integer)
        {
            Caption = 'PercentAddCostTotAmtCurrencyId';
        }
        field(160; PercentileAddCostTotalAmount; Decimal)
        {
            Caption = 'PercentileAddCostTotalAmount';
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
        key(Key2; InvoiceId, TransactionBatchId)
        {
        }

    }

    fieldgroups
    {
    }
}

