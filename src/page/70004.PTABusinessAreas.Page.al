page 70004 "PTA Business Areas"
{
    ApplicationArea = All;
    Caption = 'PTA Business Areas';
    PageType = List;
    SourceTable = PTABusinessAreasMaster;
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
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                    StyleExpr = StyleText;
                }
                field(BusinessAreaName; Rec.BusinessAreaName)
                {
                    ToolTip = 'Specifies the value of the BusinessAreaName field.';
                    StyleExpr = StyleText;
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }
                field(isDeleted; Rec.isDeleted)
                {
                    Editable = false;
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
                    PageSkipComments: Page "STO Skip Comments";
                    PTABusinessArea: Record PTABusinessAreasMaster;
                    ModifyPTABusinessArea: Record PTABusinessAreasMaster;
                begin
                    Currpage.SetSelectionFilter(PTABusinessArea);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTABusinessArea.findfirst then
                            repeat
                                ModifyPTABusinessArea := PTABusinessArea;
                                ModifyPTABusinessArea.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTABusinessArea, PageSkipComments.GetSkipComnmets());
                            until PTABusinessArea.next = 0;
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
