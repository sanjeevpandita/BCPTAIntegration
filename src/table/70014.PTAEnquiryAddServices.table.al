table 70014 "PTAEnquiryAddServices"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(21; EnquiryId; Integer)
        {
            Caption = 'EnquiryId';
        }

        field(30; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }
        field(40; SupplierId; Integer)
        {
            Caption = 'SupplierId';
        }
        field(50; SupplierPaymentTermId; Integer)
        {
            Caption = 'SupplierPaymentTermId';
        }
        field(60; Quantity; Text[30])
        {
            Caption = 'Quantity';
        }
        field(70; SellRate; Text[30])
        {
            Caption = 'SellRate';
        }
        field(80; BuyRate; Text[30])
        {
            Caption = 'BuyRate';
        }
        field(90; UOMId; Integer)
        {
            Caption = 'UOMId';
        }
        field(100; ProductId; Integer)
        {
            Caption = 'ProductId';
        }

        field(120; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(130; SupplierExposure; Decimal)
        {
            Caption = 'SupplierExposure';
        }
        field(140; IsPaymentPaidInAdvance; Boolean)
        {
            Caption = 'IsPaymentPaidInAdvance';
        }
        field(150; DeliveryDate; DateTime)
        {
            Caption = 'DeliveryDate';
        }
        field(160; SellCurrencyId; Integer)
        {
            Caption = 'SellCurrencyId';
        }
        field(170; SupplierToEmail; Text[250])
        {
            Caption = 'SupplierToEmail';
        }
        field(180; SupplierCCEmail; Text[250])
        {
            Caption = 'SupplierCCEmail';
        }
        field(190; NativeSellExposure; Decimal)
        {
            Caption = 'NativeSellExposure';
        }
        field(200; NativeBuyExposure; Decimal)
        {
            Caption = 'NativeBuyExposure';
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
        field(50001; "Is VAT/GST Service"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Resource."PTA VAT/GST Services" where("PTA Resource Type" = filter('Additional Service'), "PTA Index Link" = field(ProductId)));
            Editable = false;
            Caption = 'Is VAT/GST Service';
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
}

