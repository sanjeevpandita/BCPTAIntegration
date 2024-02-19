//NOMAPPING. PTAExpenseCategoryMaster is the master

table 70032 "PTAExpenseCategoryMaster"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageId = "PTA Expense Category";
    LookupPageId = "PTA Expense Category";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; ExpenseCategory; Text[100])
        {
            Caption = 'ExpenseCategory';
        }
        field(3; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
            Caption = 'G/L Account';
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