page 70018 "PTA Products"
{
    ApplicationArea = All;
    Caption = 'PTA Products';
    PageType = List;
    SourceTable = PTAProductMaster;
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
                field(ProductName; Rec.ProductName)
                {
                    ToolTip = 'Specifies the value of the ProductName field.';
                    StyleExpr = StyleText;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    StyleExpr = StyleText;
                }
                field(ProductType; Rec.ProductType)
                {
                    ToolTip = 'Specifies the value of the ProductType field.';
                }
                field("BC Product"; Rec."BC Product")
                {
                    ToolTip = 'Specifies the value of the BC Product field.';
                }
                field("BC Resource"; Rec."BC Resource")
                {
                    ToolTip = 'Specifies the value of the BC Resource field.';
                }

                field(Density; Rec.Density)
                {
                    ToolTip = 'Specifies the value of the Density field.';
                }
                field(IsFuel; Rec.IsFuel)
                {
                    ToolTip = 'Specifies the value of the IsFuel field.';
                }
                field(IsPhysicalSupplyProduct; Rec.IsPhysicalSupplyProduct)
                {
                    ToolTip = 'Specifies the value of the IsPhysicalSupplyProduct field.';
                }
                field(IsAgency; Rec.IsAgency)
                {
                    ToolTip = 'Specifies the value of the IsAgency field.';
                }
                field(IsClaimSettlement; Rec.IsClaimSettlement)
                {
                    ToolTip = 'Specifies the value of the IsClaimSettlement field.';
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
                    Editable = true;
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
                    PTAProducts: Record PTAProductMaster;
                    ModifyPTAProducts: Record PTAProductMaster;
                    PageSkipComments: Page "STO Skip Comments";
                begin
                    Currpage.SetSelectionFilter(PTAProducts);
                    if PageSkipComments.RunModal() = Action::OK then begin
                        if PTAProducts.findfirst then
                            repeat
                                ModifyPTAProducts := PTAProducts;
                                ModifyPTAProducts.SetRecFilter();
                                PTAHelperFunctions.ChangeProcessedFlagTo99(ModifyPTAProducts, PageSkipComments.GetSkipComnmets());
                            until PTAProducts.next = 0;
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
