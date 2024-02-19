table 70034 "PTAInboundExpenseClaim"
{
    Caption = 'PTA Inbound Expense Claim';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }

        field(160; StatusID; Integer)
        {
            Caption = 'StatusID';
        }
        field(180; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(190; BaseCurrencyId; Integer)
        {
            Caption = 'BaseCurrencyId';
        }
        field(200; BeneficiaryId; Integer)
        {
            Caption = 'BeneficiaryId';
        }
        field(210; IsCreditCard; Boolean)
        {
            Caption = 'IsCreditCard';
        }
        field(230; DateSubmitted; DateTime)
        {
            Caption = 'DateSubmitted';
        }
        field(232; CompanyOfficeID; Integer)
        {
            Caption = 'CompanyOfficeID';
        }
        field(235; DepartmentId; Integer)
        {
            Caption = 'DepartmentId';
        }
        field(240; old_expense_claim_id; Integer)
        {
            Caption = 'old_expense_claim_id';
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

    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }
}

