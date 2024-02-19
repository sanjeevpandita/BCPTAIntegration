table 70029 "PTAInboundPayAllocDetails"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;


    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(40; PaymentReceivedId; Integer)
        {
            Caption = 'PaymentReceivedId';
        }
        field(50; InvoiceId; Integer)
        {
            Caption = 'InvoiceId';
        }
        field(60; AllocateAmountPrice; Decimal)
        {
            Caption = 'AllocateAmountPrice';
        }
        field(70; AllocateAmountCurrencyId; Integer)
        {
            Caption = 'AllocateAmountCurrencyId';
        }
        field(80; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(90; EnquiryId; Integer)
        {
            Caption = 'EnquiryId';
        }
        field(100; OutgoingPaymentId; Integer)
        {
            Caption = 'OutgoingPaymentId';
        }
        field(110; VoucherId; Integer)
        {
            Caption = 'VoucherId';
        }
        field(120; AllocatedPaymentReceivedId; Integer)
        {
            Caption = 'AllocatedPaymentReceivedId';
        }
        field(130; MWBuyingCompanyId; Integer)
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
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
        key(key2; PaymentReceivedId, InvoiceId)
        {

        }
    }

    fieldgroups
    {
    }

}

