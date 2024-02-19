page 70001 "PTA Units"
{
    ApplicationArea = All;
    Caption = 'PTA Units';
    PageType = List;
    SourceTable = PTAUnitMaster;
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
                    Visible = false;
                }
                field(Id; Rec.Id)
                {
                    StyleExpr = StyleText;
                }
                field(Name; Rec.Name)
                {
                    StyleExpr = StyleText;
                }
                field(Abbreviation; Rec.Abbreviation)
                {
                    StyleExpr = StyleText;
                }
                field("BC Unit"; Rec."BC Unit")
                {
                    ToolTip = 'Specifies the value of the BC Unit field.';
                }

                field(IsBaseUnit; Rec.IsBaseUnit)
                {
                }
                field(ConversionFactor; Rec.ConversionFactor)
                {
                }
                field(ConversionFactorForOtherUnit; Rec.ConversionFactorForOtherUnit)
                {
                }
                field(IsGlobalBaseUnit; Rec.IsGlobalBaseUnit)
                {
                }
                field(IsDefaultUnitForPurchase; Rec.IsDefaultUnitForPurchase)
                {
                }
                field(ExternalId; Rec.ExternalId)
                {
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
                    PTAUnitMaster: Record PTAUnitMaster;
                    ModifyPTAUnitMaster: Record PTAUnitMaster;
                    PageSkipComments: Page "STO Skip Comments";
                begin
                    Currpage.SetSelectionFilter(PTAUnitMaster);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTAUnitMaster.findfirst then
                            repeat
                                ModifyPTAUnitMaster := PTAUnitMaster;
                                ModifyPTAUnitMaster.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTAUnitMaster, PageSkipComments.GetSkipComnmets());
                            until PTAUnitMaster.next = 0;
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
