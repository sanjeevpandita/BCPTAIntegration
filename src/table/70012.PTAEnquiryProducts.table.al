table 70012 "PTAEnquiryProducts"
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
        field(40; ProductId; Integer)
        {
            Caption = 'ProductId';
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
        field(90; SupplierContractId; Integer)
        {
            Caption = 'SupplierContractId';
        }
        field(100; SupplierPaymentTermId; Integer)
        {
            Caption = 'SupplierPaymentTermId';
        }
        field(110; SupplierDeliveryType; Integer)
        {
            Caption = 'SupplierDeliveryType';
        }
        field(120; BuyMin; Decimal)
        {
            Caption = 'BuyMin';
        }
        field(130; BuyMax; Decimal)
        {
            Caption = 'BuyMax';
        }
        field(140; BuyPrice; Decimal)
        {
            Caption = 'BuyPrice';
        }
        field(150; BuyUnitId; Integer)
        {
            Caption = 'BuyUnitId';
        }
        field(160; BuyCurrencyId; Integer)
        {
            Caption = 'BuyCurrencyId';
        }
        field(170; SellMin; Decimal)
        {
            Caption = 'SellMin';
        }
        field(180; SellMax; Decimal)
        {
            Caption = 'SellMax';
        }
        field(190; SellPrice; Decimal)
        {
            Caption = 'SellPrice';
        }
        field(200; SellUnitId; Integer)
        {
            Caption = 'SellUnitId';
        }
        field(210; SellCurrencyId; Integer)
        {
            Caption = 'SellCurrencyId';
        }
        field(220; CustomerBrokerCommision; Decimal)
        {
            Caption = 'CustomerBrokerCommision';
        }
        field(230; SupplierBrokerCommision; Decimal)
        {
            Caption = 'SupplierBrokerCommision';
        }
        field(240; CreatedDate; DateTime)
        {
            Caption = 'CreatedDate';
        }
        field(250; CustomerContractId; Integer)
        {
            Caption = 'CustomerContractId';
        }
        field(260; TakePosition; Boolean)
        {
            Caption = 'TakePosition';
        }
        field(270; BuyPriceUOMId; Integer)
        {
            Caption = 'BuyPriceUOMId';
        }
        field(280; SellPriceUOMId; Integer)
        {
            Caption = 'SellPriceUOMId';
        }
        field(290; OwnCommission; Decimal)
        {
            Caption = 'OwnCommission';
        }
        field(300; BuyCurrencyExchangeRate; Decimal)
        {
            Caption = 'BuyCurrencyExchangeRate';
        }
        field(310; SellCurrencyExchangeRate; Decimal)
        {
            Caption = 'SellCurrencyExchangeRate';
        }
        field(320; Specification; Text[1000])
        {
            Caption = 'Specification';
        }
        field(330; ParentDealProductId; Integer)
        {
            Caption = 'ParentDealProductId';
        }
        field(340; CalsoftProductSequenceNumber; Integer)
        {
            Caption = 'CalsoftProductSequenceNumber';
        }
        field(350; DeliveredQuantity; Decimal)
        {
            Caption = 'DeliveredQuantity';
        }
        field(360; DeliveryUnitId; Integer)
        {
            Caption = 'DeliveryUnitId';
        }
        field(370; DeliveryDensity; Decimal)
        {
            Caption = 'DeliveryDensity';
        }
        field(380; GrossBBL; Decimal)
        {
            Caption = 'GrossBBL';
        }
        field(390; NetBBL; Decimal)
        {
            Caption = 'NetBBL';
        }
        field(400; SupplierExposure; Decimal)
        {
            Caption = 'SupplierExposure';
        }
        field(410; AutoAgencyProduct; Boolean)
        {
            Caption = 'AutoAgencyProduct';
        }
        field(420; BuyDeliveredQuantity; Decimal)
        {
            Caption = 'BuyDeliveredQuantity';
        }
        field(430; BuyDeliveryUnitId; Integer)
        {
            Caption = 'BuyDeliveryUnitId';
        }
        field(440; IsPaymentPaidInAdvance; Boolean)
        {
            Caption = 'IsPaymentPaidInAdvance';
        }
        field(450; QuantityInMT; Decimal)
        {
            Caption = 'QuantityInMT';
        }
        field(460; OperationalDeliveredQantity; Decimal)
        {
            Caption = 'OperationalDeliveredQantity';
        }
        field(470; IsDeliveredSellPrice; Boolean)
        {
            Caption = 'IsDeliveredSellPrice';
        }
        field(656; SalesTaxRate; Decimal)
        {
            Caption = 'SalesTaxRate';
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
        key(Key3; Id)
        {

        }

    }

    fieldgroups
    {
    }
}

