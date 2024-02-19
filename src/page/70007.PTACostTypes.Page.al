page 70007 "PTA Cost Types"
{
    ApplicationArea = All;
    Caption = 'PTA Cost Types';
    PageType = List;
    SourceTable = PTACostTypeMaster;
    Editable = false;

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
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }
                field(isDeleted; Rec.isDeleted)
                {

                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }
                field(ErrorDateTime; Rec.ErrorDateTime)
                {
                    ToolTip = 'Specifies the value of the ErrorDateTime field.';
                }
                field(SkipMessage; Rec.SkipMessage)
                {
                    ToolTip = 'Specifies the value of the SkipMessage field.';
                }
                field(RecordSkippedBy; Rec.RecordSkippedBy)
                {
                    ToolTip = 'Specifies the value of the RecordSkippedBy field.';
                }
                field(RecordSkippedDateTime; Rec.RecordSkippedDateTime)
                {
                    ToolTip = 'Specifies the value of the RecordSkippedDateTime field.';
                }
            }
        }
    }
}
