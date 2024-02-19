table 70048 PTAAspectBookMapper
{
    Caption = 'PTAAspectBookMapper';
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; PTAAspectBookMapperId; Integer)
        {
            Caption = 'PTAAspectBookMapperId';
        }
        field(2; PortId; Integer)
        {
            Caption = 'PortId';
        }
        field(3; PortName; Text[250])
        {
            Caption = 'PortName';
        }
        field(4; SupplyRegionId; Integer)
        {
            Caption = 'SupplyRegionId';
        }
        field(5; SupplyRegionName; Text[250])
        {
            Caption = 'SupplyRegionName';
        }
        field(6; BookTradeAssignmentId; Integer)
        {
            Caption = 'BookTradeAssignmentId';
        }
        field(7; BookTradeAssignmentDelTypeId; Integer)
        {
            Caption = 'BookTradeAssignmentDeliveryTypeId';
        }
        field(8; PTABookId; Integer)
        {
            Caption = 'PTABookId';
        }
        field(9; PTABookName; Text[250])
        {
            Caption = 'PTABookName';
        }
        field(10; MW_AspectBookId; Integer)
        {
            Caption = 'MW_AspectBookId';
        }
        field(11; AspectBookName; Text[250])
        {
            Caption = 'AspectBookName';
            DataClassification = AccountData;
        }
        field(12; StartDate; Date)
        {
            Caption = 'StartDate';
        }
        field(13; EndDate; Date)
        {
            Caption = 'EndDate';
        }
        field(14; IsCurrent; Boolean)
        {
            Caption = 'IsCurrent';
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
    }

    procedure SetStyle(): Text[30]
    begin
        if Rec.Processed = 2 then
            Exit('Unfavorable')
        else
            Exit('')
    end;
}
