page 70005 "PTA Additional Cost Details"
{
    ApplicationArea = All;
    Caption = 'PTA Additional Cost Details';
    PageType = List;
    SourceTable = PTAAddCostDetailsMaster;
    UsageCategory = Lists;
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
                field(AdditionalCostDetailID; Rec.AdditionalCostDetailID)
                {
                    ToolTip = 'Specifies the value of the AdditionalCostDetailID field.';
                }
                field(AdditionalCostID; Rec.AdditionalCostID)
                {
                    ToolTip = 'Specifies the value of the AdditionalCostID field.';
                }
                field(EffectiveFrom; Rec.EffectiveFrom)
                {
                    ToolTip = 'Specifies the value of the EffectiveFrom field.';
                }
                field(EffectiveTill; Rec.EffectiveTill)
                {
                    ToolTip = 'Specifies the value of the EffectiveTill field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the Ex ternalId field.';
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
            part("PTA Additional Costs"; "PTA Additional Costs")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = ID = FIELD(AdditionalCostID);
                UpdatePropagation = Both;
            }
            part("PTA Cost Types"; "PTA Cost Types")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = ID = FIELD(CostTypeId);
                UpdatePropagation = Both;
                Provider = "PTA Additional Costs";
            }
        }
    }
}
