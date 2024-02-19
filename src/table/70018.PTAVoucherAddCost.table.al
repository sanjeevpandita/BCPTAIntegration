table 70018 "PTAVoucherAddCost"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {

        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(40; VoucherId; Integer)
        {
            Caption = 'VoucherId';
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
        field(80; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(90; WeightingFactor; Decimal)
        {
            Caption = 'WeightingFactor';
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
        key(Key2; VoucherId, EnquiryAdditionalCostId)
        {
        }
    }

    fieldgroups
    {
    }
}

