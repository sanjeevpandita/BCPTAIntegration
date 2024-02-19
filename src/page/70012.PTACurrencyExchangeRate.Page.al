page 70012 "PTA Currency Exchange Rate"
{
    ApplicationArea = All;
    Caption = 'PTA Currency Exchange Rate';
    PageType = List;
    SourceTable = PTACurrencyExchRate;
    UsageCategory = lists;
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
                    StyleExpr = StyleText;
                }
                field(CurrencyID; Rec.CurrencyID)
                {
                    ToolTip = 'Specifies the value of the CurrencyID field.';
                    StyleExpr = StyleText;
                }
                field(RateDate; Rec.RateDate)
                {
                    ToolTip = 'Specifies the value of the RateDate field.';
                    StyleExpr = StyleText;
                }
                field(ConversionRate; Rec.ConversionRate)
                {
                    ToolTip = 'Specifies the value of the ConversionRate field.';
                    DecimalPlaces = 1 : 6;
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }
                field(Processed; Rec.Processed)
                {
                    Editable = false;
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    Editable = false;
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    Editable = false;
                }
                field(ErrorDateTime; Rec.ErrorDateTime)
                {
                    Editable = false;
                }
                field(SkipMessage; Rec.SkipMessage)
                {
                    editable = false;
                }
                field(RecordSkippedBy; Rec.RecordSkippedBy)
                {
                    Editable = false;
                }
                field(RecordSkippedDateTime; Rec.RecordSkippedDateTime)
                {
                    Editable = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        Area(Promoted)
        {
            actionref(PromotedSkipRecord; SkipRecord)
            {

            }
        }
        area(Processing)
        {
            action(SkipRecord)
            {
                ApplicationArea = All;
                Caption = 'Skip Record Integration';

                trigger OnAction()
                var
                    PTAHelperFunctions: Codeunit "PTA Helper Functions";
                    PTACurrencyExchRate: Record PTACurrencyExchRate;
                    ModifyPTACurrencyExchRate: Record PTACurrencyExchRate;
                    PageSkipComments: Page "STO Skip Comments";
                begin
                    Currpage.SetSelectionFilter(PTACurrencyExchRate);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTACurrencyExchRate.findfirst then
                            repeat
                                ModifyPTACurrencyExchRate := PTACurrencyExchRate;
                                ModifyPTACurrencyExchRate.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTACurrencyExchRate, PageSkipComments.GetSkipComnmets());
                            until PTACurrencyExchRate.next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleText := Rec.SetStyle();
    end;

    var
        StyleText: Text[30];
}
