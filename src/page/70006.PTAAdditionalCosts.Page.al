page 70006 "PTA Additional Costs"
{
    ApplicationArea = All;
    Caption = 'PTA Additional Costs';
    PageType = List;
    SourceTable = PTAAdditionalCostsMaster;
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
                }
                field(CostTypeId; Rec.CostTypeId)
                {
                    ToolTip = 'Specifies the value of the CostTypeId field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }
                field(isDeleted; Rec.isDeleted)
                {

                }
            }
        }
    }
}
