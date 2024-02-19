table 70013 "PTAEnquiryAdditionalCost"
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
        field(50; SupplierId; Integer)
        {
            Caption = 'SupplierId';
        }
        field(60; SupplierContactId; Integer)
        {
            Caption = 'SupplierContactId';
        }
        field(70; SupplierBrokerId; Integer)
        {
            Caption = 'SupplierBrokerId';
        }
        field(80; SupplierBrokerContactId; Integer)
        {
            Caption = 'SupplierBrokerContactId';
        }
        field(100; SupplierPaymentTermId; Integer)
        {
            Caption = 'SupplierPaymentTermId';
        }
        field(110; SupplierDelivery; Integer)
        {
            Caption = 'SupplierDelivery';
        }
        field(160; BuyCurrencyId; Integer)
        {
            Caption = 'BuyCurrencyId';
        }
        field(210; SellCurrencyId; Integer)
        {
            Caption = 'SellCurrencyId';
        }
        field(400; SupplierExposure; Decimal)
        {
            Caption = 'SupplierExposure';
        }
        field(440; IsPaymentPaidInAdvance; Boolean)
        {
            Caption = 'IsPaymentPaidInAdvance';
        }

        field(670; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(680; TotalAdditionalCost; Decimal)
        {
            Caption = 'TotalAdditionalCost';
        }
        field(690; AdditionalCostDetailsId; Integer)
        {
            Caption = 'AdditionalCostDetailsId';
        }
        field(700; QuantityFrom; Decimal)
        {
            Caption = 'QuantityFrom';
        }
        field(710; QuantityTo; Decimal)
        {
            Caption = 'QuantityTo';
        }
        field(720; SellRate; Decimal)
        {
            Caption = 'SellRate';
        }
        field(730; BuyUOMId; Integer)
        {
            Caption = 'BuyUOMId';
        }
        field(740; SellUOMId; Integer)
        {
            Caption = 'SellUOMId';
        }
        field(750; CostTypeId; Integer)
        {
            Caption = 'CostTypeId';
        }
        field(760; PortId; Integer)
        {
            Caption = 'PortId';
        }
        field(761; ProductTypeId; Integer)
        {
            Caption = 'ProductTypeId';
        }
        field(762; DeliveryTypeId; Integer)
        {
            Caption = 'DeliveryTypeId';
        }
        field(763; FixedQuantity; Decimal)
        {
            Caption = 'FixedQuantity';
        }
        field(764; Description; Text[2048])
        {
            Caption = 'Description';
        }

        field(766; BuyRate; Decimal)
        {
            Caption = 'BuyRate';
        }
        field(767; SellLumpsum; Decimal)
        {
            Caption = 'SellLumpsum';
        }
        field(768; EffectiveFrom; DateTime)
        {
            Caption = 'EffectiveFrom';
        }
        field(769; EffectiveUntil; DateTime)
        {
            Caption = 'EffectiveUntil';
        }
        field(770; BuyLumpsum; Decimal)
        {
            Caption = 'BuyLumpsum';
        }
        field(771; SellIsApplicable; Boolean)
        {
            Caption = 'SellIsApplicable';
        }
        field(772; BuyIsApplicable; Boolean)
        {
            Caption = 'BuyIsApplicable';
        }
        field(773; NativeSellExposure; Decimal)
        {
            Caption = 'NativeSellExposure';
        }
        field(774; NativeBuyExposure; Decimal)
        {
            Caption = 'NativeBuyExposure';
        }
        field(775; ApplicableQuantity; Decimal)
        {
            Caption = 'ApplicableQuantity';
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
        key(Key2; EnquiryId, TransactionBatchId)
        {
        }
    }

    fieldgroups
    {
    }
}

