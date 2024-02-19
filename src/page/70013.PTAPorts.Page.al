page 70013 "PTA Ports"
{
    ApplicationArea = All;
    Caption = 'PTA Ports';
    PageType = List;
    SourceTable = PTAPortMaster;
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
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    StyleExpr = StyleText;
                }
                field(Abbreviation; Rec.Abbreviation)
                {
                    ToolTip = 'Specifies the value of the Abbreviation field.';
                }
                field("BC Location"; Rec."BC Location")
                {
                    ToolTip = 'Specifies the value of the BC Location field.';
                }
                field(IsActive; Rec.IsActive)
                {
                    ToolTip = 'Specifies the value of the IsActive field.';
                }
                field(SupplyRegionId; Rec.SupplyRegionId)
                {
                    ToolTip = 'Specifies the value of the SupplyRegionId field.';
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
                    PTAPorts: Record PTAPortMaster;
                    ModifyPTAPorts: Record PTAPortMaster;
                    PageSkipComments: Page "STO Skip Comments";
                begin
                    Currpage.SetSelectionFilter(PTAPorts);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTAPorts.findfirst then
                            repeat
                                ModifyPTAPorts := PTAPorts;
                                ModifyPTAPorts.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTAPorts, PageSkipComments.GetSkipComnmets());
                            until PTAPorts.next = 0;
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
