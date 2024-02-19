table 70017 "PTAVoucherAddServices"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {

        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(30; VoucherId; Integer)
        {
            Caption = 'VoucherId';
        }
        field(40; EnquiryAdditionalServiceId; Integer)
        {
            Caption = 'EnquiryAdditionalServiceId';
        }
        field(50; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(60; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }
        field(70; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(80; WeightingFactor; Decimal)
        {
            Caption = 'WeightingFactor';
        }
        field(90; ProductID; Integer)
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
        field(50001; "Is VAT/GST Service"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Resource."PTA VAT/GST Services" where("PTA Resource Type" = filter('Additional Service'), "PTA Index Link" = field(ProductID)));
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
        key(Key2; VoucherId, EnquiryAdditionalServiceId)
        {
        }
    }

    fieldgroups
    {
    }
}

