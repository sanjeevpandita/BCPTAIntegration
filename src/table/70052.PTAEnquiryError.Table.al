table 70052 PTAEnquiryError //PTAVoucherError //PTAInvoiceError 
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {

        field(1; EntityType; Enum "PTA Enquiry Entities")
        {
            Caption = 'EntityType';
        }
        field(2; EnquiryID; Integer)
        {
            Caption = 'EnquiryID';
        }
        field(3; BatchID; Integer)
        {
            Caption = 'BatchID';
        }
        field(4; RecordEntryNo; Integer)
        {
            Caption = 'RecordEntryNo';
        }
        field(5; ErrorDescription; Text[500])
        {
            Caption = 'ErrorDescription';
        }
        field(6; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        field(7; HeaderEntryNo; Integer)
        {
            Caption = 'HeaderEntryNo';
        }
        field(8; ErrorDateTime; DateTime)
        {
            Caption = 'ErrorDateTime';
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