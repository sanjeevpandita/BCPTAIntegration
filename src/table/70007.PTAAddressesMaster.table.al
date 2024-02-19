//NOMAPPING. PTAAddressesMaster is the master
table 70007 "PTAAddressesMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Addresses";
    LookupPageId = "PTA Addresses";

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; Phone1; Text[50])
        {
            Caption = 'Phone1';
        }
        field(3; Fax; Text[50])
        {
            Caption = 'Fax';
        }
        field(4; Email; Text[1000])
        {
            Caption = 'Email';
        }
        field(5; City; Integer)
        {
            Caption = 'City';
        }
        field(6; PostalCode; Text[30])
        {
            Caption = 'PostalCode';
        }
        field(7; Country; Integer)
        {
            Caption = 'Country';
        }
        field(8; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(9; AddressLine1; Text[250])
        {
            Caption = 'AddressLine1';
        }
        field(10; AddressLine2; Text[250])
        {
            Caption = 'AddressLine2';
        }
        field(11; AddressLine3; Text[250])
        {
            Caption = 'AddressLine3';
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

