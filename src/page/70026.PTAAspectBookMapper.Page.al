page 70026 "PTA Aspect Book Mapper"
{
    ApplicationArea = All;
    Caption = 'PTA Aspect Book Mapper';
    PageType = List;
    SourceTable = PTAAspectBookMapper;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                    Visible = false;
                }
                field(PTAAspectBookMapperId; Rec.PTAAspectBookMapperId)
                {
                    ToolTip = 'Specifies the value of the PTAAspectBookMapperId field.';
                }
                field(PortId; Rec.PortId)
                {
                    ToolTip = 'Specifies the value of the PortId field.';
                }
                field(PortName; Rec.PortName)
                {
                    ToolTip = 'Specifies the value of the PortName field.';
                }
                field(SupplyRegionId; Rec.SupplyRegionId)
                {
                    ToolTip = 'Specifies the value of the SupplyRegionId field.';
                }
                field(SupplyRegionName; Rec.SupplyRegionName)
                {
                    ToolTip = 'Specifies the value of the SupplyRegionName field.';
                }
                field(BookTradeAssignmentId; Rec.BookTradeAssignmentId)
                {
                    ToolTip = 'Specifies the value of the BookTradeAssignmentId field.';
                }
                field(BookTradeAssignmentDeliveryTypeId; Rec.BookTradeAssignmentDelTypeId)
                {
                    ToolTip = 'Specifies the value of the BookTradeAssignmentDeliveryTypeId field.';
                }
                field(PTABookId; Rec.PTABookId)
                {
                    ToolTip = 'Specifies the value of the PTABookId field.';
                }
                field(PTABookName; Rec.PTABookName)
                {
                    ToolTip = 'Specifies the value of the PTABookName field.';
                }
                field(MW_AspectBookId; Rec.MW_AspectBookId)
                {
                    ToolTip = 'Specifies the value of the MW_AspectBookId field.';
                }
                field(AspectBookName; Rec.AspectBookName)
                {
                    ToolTip = 'Specifies the value of the AspectBookName field.';
                }
                field(StartDate; Rec.StartDate)
                {
                    ToolTip = 'Specifies the value of the StartDate field.';
                }
                field(EndDate; Rec.EndDate)
                {
                    ToolTip = 'Specifies the value of the EndDate field.';
                }
                field(IsCurrent; Rec.IsCurrent)
                {
                    ToolTip = 'Specifies the value of the IsCurrent field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }
                field(ErrorDateTime; Rec.ErrorDateTime)
                {
                    ToolTip = 'Specifies the value of the ErrorDateTime field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }

            }
        }
    }
}
