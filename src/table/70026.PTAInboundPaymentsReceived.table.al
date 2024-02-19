table 70026 "PTAInboundPaymentsReceived"
{
    Caption = 'PTA Inbound Payments Received';
    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageID = "PTA Inbound Payments Received";
    LookupPageID = "PTA Inbound Payments Received";

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }

        field(40; PaymentDate; DateTime)
        {
            Caption = 'PaymentDate';
        }
        field(50; Charges; Decimal)
        {
            Caption = 'Charges';
        }
        field(60; Notes; Text[2048])
        {
            Caption = 'Notes';
        }

        field(80; AmountReceivedPrice; Decimal)
        {
            Caption = 'AmountReceivedPrice';
        }
        field(90; AmountReceivedCurrencyId; Integer)
        {
            Caption = 'AmountReceivedCurrencyId';
        }
        field(100; AllocatedAmountPrice; Decimal)
        {
            Caption = 'AllocatedAmountPrice';
        }
        field(110; AllocatedAmountCurrencyId; Integer)
        {
            Caption = 'AllocatedAmountCurrencyId';
        }
        field(120; CounterpartyId; Integer)
        {
            Caption = 'CounterpartyId';
        }
        field(130; BankAccountId; Integer)
        {
            Caption = 'BankAccountId';
        }
        field(140; ApplicableAmountCurrencyId; Integer)
        {
            Caption = 'ApplicableAmountCurrencyId';
        }
        field(150; ApplicableAmountPrice; Decimal)
        {
            Caption = 'ApplicableAmountPrice';
        }
        field(160; IsRefund; Boolean)
        {
            Caption = 'IsRefund';
        }
        field(170; PaymentRef; Text[510])
        {
            Caption = 'PaymentRef';
        }
        field(180; LiveApplicationSourceId; Integer)
        {
            Caption = 'LiveApplicationSourceId';
        }
        field(190; AmountInUSD; Decimal)
        {
            Caption = 'AmountInUSD';
        }
        field(200; CreatedDate; DateTime)
        {
            Caption = 'CreatedDate';
        }
        field(210; CreatedBy; Integer)
        {
            Caption = 'CreatedBy';
        }
        field(220; DeletedDate; DateTime)
        {
            Caption = 'DeletedDate';
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
        field(50001; Processed; Integer)
        {
            Caption = 'Processed';
        }
        field(50002; ProcessedDateTime; DateTime)
        {
            Caption = 'ProcessedDateTime';
        }
        field(50003; ErrorMessage; Text[250])
        {
            Caption = 'ErrorMessage';
        }
        field(50004; ErrorDateTime; DateTime)
        {
            Caption = 'ErrorDateTime';
        }
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(50007; BCBuyingCompanyId; Integer)
        {
            CalcFormula = lookup(PTAInboundPayAllocDetails.MWBuyingCompanyId WHERE(PaymentReceivedId = field(ID), TransactionBatchId = field(TransactionBatchId))); //Lookup
            FieldClass = FlowField;
            Editable = false;
        }
        field(50008; BankExistsInThisCompany; Boolean)
        {
            CalcFormula = exist("Bank Account" where("PTA Index Link" = field(BankAccountId)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(95000; "Error Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(PTAEnquiryError where(EntityType = filter("Inbound Payment"), EnquiryID = field(id), BatchID = field(TransactionBatchId)));
            Editable = false;
            Caption = 'Error Exists';
        }

    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; ID)
        {
        }
    }

    fieldgroups
    {
    }
}

