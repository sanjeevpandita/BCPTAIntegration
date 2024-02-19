//MAPPING PTADeliveryTypeMaster

tableextension 70006 "STO Shipment Method" extends "Shipment Method"
{
    fields
    {
        field(70000; "PTA Index Link"; Integer)
        {
            Caption = 'PTA Index Link';
            DataClassification = CustomerContent;
        }
        field(70001; "PTA Abbreviation"; text[100])
        {
            Caption = 'Abbreviation';
            DataClassification = CustomerContent;
        }
        field(80000; "PTA IsDeleted"; Boolean)
        {
            Caption = 'Is Deleted';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PTAIndexLink; "PTA Index Link", "PTA IsDeleted")
        {

        }
    }
}