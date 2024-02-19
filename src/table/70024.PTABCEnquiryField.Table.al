table 70024 "PTA BC Enquiry Field"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; TableID; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'TableID';
        }
        field(2; "Table Name"; text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Table Name';
        }
        field(3; FieldID; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'FieldID';
        }
        field(4; "Field Name"; text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Field Name';
        }
    }

    keys
    {
        key(Key1; TableID, FieldID)
        {
            Clustered = true;
        }
    }
}