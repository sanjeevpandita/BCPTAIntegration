page 70002 "PTA Expense Claim Status"
{
    ApplicationArea = All;
    Caption = 'PTA Expense Claim Status';
    PageType = List;
    SourceTable = PTAExpenseClaimStatusMaster;
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
                }
                field(ExpenseClaimStatus; Rec.ExpenseClaimStatus)
                {
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }
            }
        }
    }
}
