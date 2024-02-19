//MAPPING PTAPortMaster

tableextension 70002 "STO Location" extends Location
{
    fields
    {
        field(50000; "PTA Index Link"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'PTA Index Link';
        }
        field(50001; "PTA Port Abbreviation"; Code[20])
        {
            Caption = 'Port Abbreviation';
            DataClassification = CustomerContent;
        }
        field(50002; "PTA Supply Region ID"; Integer)
        {
            Caption = 'Supply Region ID';
            DataClassification = CustomerContent;
        }
        field(50003; "PTA Port Grouping"; Code[10])
        {
            TableRelation = Location;
            Caption = 'Port Grouping';
            DataClassification = CustomerContent;
        }
        field(80000; "PTA IsDeleted"; Boolean)
        {
            Caption = 'Is Deleted';
            DataClassification = CustomerContent;
        }

        field(80001; "PTA VAT Registration Code"; Code[20])
        {
            Caption = 'VAT Registration Code';
            DataClassification = CustomerContent;
        }
        field(80002; "PTA VAT Buss. Posting Grp."; Code[20])
        {
            Caption = 'VAT Buss. Posting Grp.';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }

    }

    keys
    {
        key(PTAIndexLink; "PTA Index Link", "PTA IsDeleted")
        {

        }
    }
}