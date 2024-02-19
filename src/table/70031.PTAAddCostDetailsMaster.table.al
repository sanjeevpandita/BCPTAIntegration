//NOMAPPING. PTAAddCostDetailsMaster is the master

table 70031 "PTAAddCostDetailsMaster"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageId = "PTA Additional Cost Details";
    LookupPageId = "PTA Additional Cost Details";

    fields
    {
        field(1; AdditionalCostDetailID; Integer)
        {
            Caption = 'AdditionalCostDetailID';
        }
        field(2; AdditionalCostID; Integer)
        {
            Caption = 'AdditionalCostID';
        }
        field(3; EffectiveFrom; Date)
        {
            Caption = 'EffectiveFrom';
        }
        field(4; EffectiveTill; Date)
        {
            Caption = 'EffectiveTill';
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
        field(50005; ExternalId; Integer)
        {
            Caption = 'ExternalId';
        }
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(50007; RecordSkippedDateTime; DateTime)
        {
            Caption = 'RecordSkippedDateTime';
        }
        field(50008; RecordSkippedBy; Text[50])
        {
            Caption = 'RecordSkippedBy';
        }
        field(50009; SkipMessage; Text[250])
        {
            Caption = 'SkipMessage';
        }

    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
        key(Id; AdditionalCostDetailID)
        {
        }
    }

    fieldgroups
    {
    }

}

