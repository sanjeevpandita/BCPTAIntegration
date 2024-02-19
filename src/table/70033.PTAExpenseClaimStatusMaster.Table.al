//NOMAPPING. PTAExpenseClaimStatusMaster is the master

table 70033 "PTAExpenseClaimStatusMaster"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageId = "PTA Expense Claim Status";
    LookupPageId = "PTA Expense Claim Status";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; ExpenseClaimStatus; Text[100])
        {
            Caption = 'ExpenseClaimStatus';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        field(50005; ExternalId; Integer)
        {
            Caption = 'ExternalId';
        }

    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Id; Id)
        {
        }
    }

    fieldgroups
    {
    }
}

