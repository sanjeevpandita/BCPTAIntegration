table 70037 "PTAOutgoingPaymentVouchers"
{
    Caption = 'PTA Outgoing Payment Vouchers';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {

        field(20; ID; Integer)
        {
            Caption = 'ID';
        }

        field(40; OutGoingPaymentId; Integer)
        {
            Caption = 'OutGoingPaymentId';
        }
        field(50; VoucherId; Integer)
        {
            Caption = 'VoucherId';
        }
        field(60; PaidAmount; Decimal)
        {
            Caption = 'PaidAmount';
        }
        field(65; PaidAmountCurrencyId; Integer)
        {
            Caption = 'PaidAmountCurrencyId';
        }
        field(70; EnquiryId; Integer)
        {
            Caption = 'EnquiryId';
        }
        field(80; PaymentReceivedId; Integer)
        {
            Caption = 'PaymentReceivedId';
        }
        field(90; CustomerInvoiceId; Integer)
        {
            Caption = 'CustomerInvoiceId';
        }
        field(100; AllocatedOutgoingPaymentId; Integer)
        {
            Caption = 'AllocatedOutgoingPaymentId';
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
        key(key2; OutGoingPaymentId, VoucherId)
        {

        }

    }

    fieldgroups
    {
    }
}

