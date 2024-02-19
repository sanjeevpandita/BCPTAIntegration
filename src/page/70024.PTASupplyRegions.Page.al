page 70024 "PTA Supply Regions"
{
    ApplicationArea = All;
    Caption = 'PTA Supply Regions';
    PageType = List;
    SourceTable = PTASupplyRegions;
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
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                    StyleExpr = StyleText;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    StyleExpr = StyleText;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }

                field(isPermanent; Rec.isPermanent)
                {
                    ToolTip = 'Specifies the value of the isPermanent field.';
                }
                field(ModifiedOn; Rec.ModifiedOn)
                {
                    ToolTip = 'Specifies the value of the ModifiedOn field.';
                }
                field(isPhysical; Rec.isPhysical)
                {
                    ToolTip = 'Specifies the value of the isPhysical field.';
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
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
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
                    PTASupplyRegion: Record PTASupplyRegions;
                    ModifySuppleRegion: Record PTASupplyRegions;
                    PageSkipComments: Page "STO Skip Comments";
                begin
                    Currpage.SetSelectionFilter(PTASupplyRegion);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTASupplyRegion.findfirst then
                            repeat
                                ModifySuppleRegion := PTASupplyRegion;
                                ModifySuppleRegion.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifySuppleRegion, PageSkipComments.GetSkipComnmets());
                            until PTASupplyRegion.next = 0;
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
