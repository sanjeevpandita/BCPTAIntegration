table 70051 PTACounterpartyRoleMapping
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {

        field(2; CounterpartyId; Integer)
        {
            Caption = 'CounterpartyId';
        }
        field(3; CounterpartyRoleId; Integer)
        {
            Caption = 'CounterpartyRoleId';
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
    }
}