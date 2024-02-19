table 70035 "PTAInboundExpenses"
{

    Caption = 'PTA Inbound Expenses';
    DataPerCompany = false;
    DataClassification = CustomerContent;
    //DrillDownPageID = "PTA Inbound Expenses";
    //LookupPageID = "PTA Inbound Expenses";

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }

        field(160; ExpenseClaimId; Integer)
        {
            Caption = 'ExpenseClaimId';
        }
        field(180; ExpenseDate; Text[30])
        {
            Caption = 'ExpenseDate';
        }
        field(190; TripId; Integer)
        {
            Caption = 'TripId';
        }
        field(200; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(210; Flagged; Boolean)
        {
            Caption = 'Flagged';
        }
        field(220; Rate; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Caption = 'Rate';
        }
        field(230; CurrencyID; Integer)
        {
            Caption = 'CurrencyID';
        }
        field(240; VatRateID; Integer)
        {
            Caption = 'VatRateID';
        }
        field(241; VatAmount; Text[20])
        {
            Caption = 'VatAmount';
        }
        field(242; VATCurrencyID; Integer)
        {
            Caption = 'VATCurrencyID';
        }
        field(243; ReceiptAvailable; Boolean)
        {
            Caption = 'ReceiptAvailable';
        }
        field(244; ExpenseCategoryID; Integer)
        {
            Caption = 'ExpenseCategoryID';
        }
        field(245; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(246; old_expense_claim_id; Integer)
        {
            Caption = 'old_expense_claim_id';
        }
        field(247; old_expense_id; Integer)
        {
            Caption = 'old_expense_id';
        }
        field(248; old_trip_id; Text[10])
        {
            Caption = 'old_trip_id';
        }
        field(249; old_cash_withdrawal_id; Integer)
        {
            Caption = 'old_cash_withdrawal_id';
        }
        Field(1000; TransactionBatchId; integer)
        {
            Caption = 'TransactionBatchId';
        }

        field(1001; "PTA Expense ActualDate"; Date)
        { }
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

