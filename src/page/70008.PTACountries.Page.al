page 70008 "PTA Countries"
{
    ApplicationArea = All;
    Caption = 'PTA Countries';
    PageType = List;
    SourceTable = PTACountryMaster;
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
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    StyleExpr = StyleText;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    StyleExpr = StyleText;
                }

                field(Abbreviation2; Rec.Abbreviation2)
                {
                    ToolTip = 'Specifies the value of the Abbreviation2 field.';
                    StyleExpr = StyleText;
                }
                field("BC Country"; Rec."BC Country")
                {
                    ToolTip = 'Specifies the value of the BC Country field.';
                }

                field(Abbreviation3; Rec.Abbreviation3)
                {
                    ToolTip = 'Specifies the value of the Abbreviation3 field.';
                }

                field(IsRestrictedForCounterparty; Rec.IsRestrictedForCounterparty)
                {
                    ToolTip = 'Specifies the value of the IsRestrictedForCounterparty field.';
                }
                field(IsRestrictedForVessel; Rec.IsRestrictedForVessel)
                {
                    ToolTip = 'Specifies the value of the IsRestrictedForVessel field.';
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
            part("PTA Cities"; "PTA Cities")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = CountryId = FIELD(Id);
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
                    PTACountryMaster: Record PTACountryMaster;
                    ModifyPTACountryMaster: Record PTACountryMaster;
                    PageSkipComments: Page "STO Skip Comments";

                begin
                    Currpage.SetSelectionFilter(PTACountryMaster);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTACountryMaster.findfirst then
                            repeat
                                ModifyPTACountryMaster := PTACountryMaster;
                                ModifyPTACountryMaster.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTACountryMaster, PageSkipComments.GetSkipComnmets());
                            until PTACountryMaster.next = 0;
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
