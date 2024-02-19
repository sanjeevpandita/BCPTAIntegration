table 70023 "PTACustomerInvoiceAddServ"
{
    Caption = 'PTA Inbound Invoice Add Serv';
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
        field(50; EnquiryAdditionalServiceId; Integer)
        {
            Caption = 'EnquiryAdditionalServiceId';
        }
        field(60; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(70; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }
        field(80; ProductId; Integer)
        {
            Caption = 'ProductId';
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(100; UnitId; Integer)
        {
            Caption = 'UnitId';
        }
        field(110; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(120; WeightingFactor; Decimal)
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
        key(Key2; InvoiceId, TransactionBatchId)
        {
        }

    }

    fieldgroups
    {
    }
}

