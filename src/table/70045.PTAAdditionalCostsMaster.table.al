//NOMAPPING. PTAAdditionalCostsMaster is the master

table 70045 "PTAAdditionalCostsMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Additional Costs";
    LookupPageId = "PTA Additional Costs";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; CostTypeId; Integer)
        {
            Caption = 'CostTypeId';
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
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
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
}
