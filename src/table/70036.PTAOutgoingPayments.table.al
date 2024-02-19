table 70036 "PTAOutgoingPayments"
{
    Caption = 'PTA Outgoing Payments';
    DataPerCompany = false;
    DataClassification = CustomerContent;
    LookupPageId = PTAOutgoingPayments;
    DrillDownPageId = PTAOutgoingPayments;

    fields
    {

        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(40; SupplierId; Integer)
        {
            Caption = 'SupplierId';
        }
        field(50; BankAccountId; Integer)
        {
            Caption = 'BankAccountId';
        }
        field(60; StatusId; Integer)
        {
            Caption = 'StatusId';
        }
        field(65; PaymentDate; DateTime)
        {
            Caption = 'PaymentDate';
        }
        field(80; AdvancePaymentFileName; Text[1000])
        {
            Caption = 'AdvancePaymentFileName';
        }
        field(90; IsPaymentInAdvance; Boolean)
        {
            Caption = 'IsPaymentInAdvance';
        }
        field(100; IsRefund; Boolean)
        {
            Caption = 'IsRefund';
        }
        field(110; Notes; Text[250])
        {
            Caption = 'Notes';
        }
        field(120; PPLBankAccountId; Integer)
        {
            Caption = 'PPLBankAccountId';
        }
        field(130; LiveApplicationSourceId; Integer)
        {
            Caption = 'LiveApplicationSourceId';
        }
        field(140; PaidSourceId; Integer)
        {
            Caption = 'PaidSourceId';
        }
        field(190; AmountInUSD; Decimal)
        {
            Caption = 'AmountInUSD';
        }
        field(200; RequestedBy; Integer)
        {
            Caption = 'RequestedBy';
        }
        field(210; RequestedAmountPrice; Decimal)
        {
            Caption = 'RequestedAmountPrice';
        }
        field(220; RequestedAmountCurrencyId; Integer)
        {
            Caption = 'RequestedAmountCurrencyId';
        }
        field(230; OutstandingAmount; Decimal)
        {
            Caption = 'OutstandingAmount';
        }
        field(240; PaymentCreatedDate; DateTime)
        {
            Caption = 'PaymentCreatedDate';
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
            CalcFormula = lookup(PTAOutgoingPaymentVouchers.MWBuyingCompanyId WHERE(OutGoingPaymentId = field(ID), TransactionBatchId = field(TransactionBatchId))); //Lookup
            FieldClass = FlowField;
            Editable = false;
        }

        field(50008; BankExistsInThisCompany; Boolean)
        {
            CalcFormula = exist("Bank Account" where("PTA Index Link" = field(PPLBankAccountId)));
            FieldClass = FlowField;
            Editable = false;
        }
        field(95000; "Error Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(PTAEnquiryError where(EntityType = filter("Outbound Payment"), EnquiryID = field(id), BatchID = field(TransactionBatchId)));
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
    }
}

