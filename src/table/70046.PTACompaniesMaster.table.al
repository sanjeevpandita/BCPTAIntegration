//NOMAPPING. PTACompaniesMaster is the master

table 70046 "PTACompaniesMaster"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;
    DrillDownPageId = "PTA Companies";
    LookupPageId = "PTA Companies";

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
        }
        field(2; Name; text[100])
        {
            Caption = 'Name';
        }
        field(3; "BCCompanyName"; text[30])
        {
            TableRelation = Company;
            Caption = 'BCCompanyName';
        }
        field(4; CompanyId; Integer)
        {
            Caption = 'CompanyId';
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