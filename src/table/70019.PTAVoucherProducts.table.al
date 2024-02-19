table 70019 "PTAVoucherProducts"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;
    Caption = 'PTA Vouchers Products';


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
        field(80; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(90; WeightingFactor; Decimal)
        {
            Caption = 'WeightingFactor';
        }
        field(100; ProductID; Integer)
        {
            Caption = 'ProductID';
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
        key(Key2; VoucherId, EnquiryProductId)
        {
        }
    }

    fieldgroups
    {
    }
}

