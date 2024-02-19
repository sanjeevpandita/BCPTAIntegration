page 70031 "PTA CounterpartiesMaster"
{
    ApplicationArea = All;
    Caption = 'PTACounterpartiesMaster';
    PageType = List;
    SourceTable = PTACounterpartiesMaster;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    StyleExpr = StyleText;
                }
                field(DefaultCurrency; Rec.DefaultCurrency)
                {
                    ToolTip = 'Specifies the value of the DefaultCurrency field.';
                }
                field(TradingAddress; Rec.TradingAddress)
                {
                    ToolTip = 'Specifies the value of the TradingAddress field.';
                }
                field(AdminAddress; Rec.AdminAddress)
                {
                    ToolTip = 'Specifies the value of the AdminAddress field.';
                }
                field(Phone1; Rec.Phone1)
                {
                    ToolTip = 'Specifies the value of the Phone1 field.';
                }
                field(Phone2; Rec.Phone2)
                {
                    ToolTip = 'Specifies the value of the Phone2 field.';
                }
                field(Website; Rec.Website)
                {
                    ToolTip = 'Specifies the value of the Website field.';
                }
                field(isDeleted; Rec.isDeleted)
                {
                    ToolTip = 'Specifies the value of the isDeleted field.';
                }
                field("BC Customer"; Rec."BC Customer")
                {
                    ToolTip = 'Specifies the value of the BC Customer field.';
                }
                field("BC Vendor"; Rec."BC Vendor")
                {
                    ToolTip = 'Specifies the value of the BC Vendor field.';
                }
                field(isCustomer; Rec.isCustomer)
                {
                    ToolTip = 'Specifies the value of the isCustomer field.';
                }
                field(isVendor; Rec.isVendor)
                {
                    ToolTip = 'Specifies the value of the isVendor field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
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
    actions
    {
        area(Promoted)
        {
            actionref(PromotedSkipRecord; SkipRecord) { }
            actionref(PromotedRoles; Roles) { }

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
                    PTACounterpartiesMaster: Record PTACounterpartiesMaster;
                    ModifyPTACounterpartiesMaster: Record PTACounterpartiesMaster;
                    PageSkipComments: Page "STO Skip Comments";
                begin
                    Currpage.SetSelectionFilter(PTACounterpartiesMaster);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTACounterpartiesMaster.findfirst then
                            repeat
                                ModifyPTACounterpartiesMaster := PTACounterpartiesMaster;
                                ModifyPTACounterpartiesMaster.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTACounterpartiesMaster, PageSkipComments.GetSkipComnmets());
                            until PTACounterpartiesMaster.next = 0;
                    end;
                end;
            }

            action(Roles)
            {
                ApplicationArea = All;
                RunObject = page PTACounterpartyRoleMapping;
                RunPageLink = CounterpartyId = field(Id);
                Image = ReceiveLoaner;
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