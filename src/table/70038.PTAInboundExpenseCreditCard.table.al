table 70038 "PTAInboundExpenseCreditCard"
{
    Caption = 'PTA Inbound Expense CreditCard';
    DataPerCompany = false;
    DataClassification = CustomerContent;
    //DrillDownPageID = "PTA Inbound Expenses";
    //LookupPageID = "PTA Inbound Expenses";

    fields
    {

        field(160; ExpenseClaimId; Integer)
        {
            Caption = 'ExpenseClaimId';
        }
        field(180; DueDate; Text[30])
        {
            Caption = 'DueDate';
        }
        field(190; StatementDate; Text[30])
        {
            Caption = 'StatementDate';
        }
        field(200; Month; Integer)
        {
            Caption = 'Month';
        }
        field(210; Year; Integer)
        {
            Caption = 'Year';
        }
        field(220; StatementFilename; Text[1000])
        {
            Caption = 'StatementFilename';
        }
        field(230; CreditCardTypeId; Integer)
        {
            Caption = 'CreditCardTypeId';
        }
        field(240; ImportLogId; Integer)
        {
            Caption = 'ImportLogId';
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
    }
}

