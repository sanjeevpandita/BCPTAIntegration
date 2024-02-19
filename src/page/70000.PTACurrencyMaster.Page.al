page 70000 "PTA Currency Master"
{
    ApplicationArea = All;
    Caption = 'PTA Currencies';
    PageType = List;
    SourceTable = PTACurrenciesMaster;
    UsageCategory = Lists;
    Editable = True;


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
                field(ID; Rec.ID)
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
                field("BC Currency"; Rec."BC Currency")
                {
                    ToolTip = 'Specifies the value of the BC Currency field.';
                    editable = false;
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
                    editable = false;
                    Visible = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    editable = false;
                    Visible = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    editable = false;
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    editable = false;
                    Visible = false;
                }
            }
            part("PTA Currency Exchange Rate"; "PTA Currency Exchange Rate")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = CurrencyID = FIELD(ID);
                UpdatePropagation = Both;
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
                    PTACurrenciesMaster: Record PTACurrenciesMaster;
                    ModifyPTACurrenciesMaster: Record PTACurrenciesMaster;

                begin
                    Currpage.SetSelectionFilter(PTACurrenciesMaster);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTACurrenciesMaster.findfirst then
                            repeat
                                ModifyPTACurrenciesMaster := PTACurrenciesMaster;
                                ModifyPTACurrenciesMaster.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTACurrenciesMaster, PageSkipComments.GetSkipComnmets());
                            until PTACurrenciesMaster.next = 0;
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
