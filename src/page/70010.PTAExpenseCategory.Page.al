page 70010 "PTA Expense Category"
{
    ApplicationArea = All;
    Caption = 'PTA Expense Category';
    PageType = List;
    SourceTable = PTAExpenseCategoryMaster;
    UsageCategory = Lists;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field(ExpenseCategory; Rec.ExpenseCategory)
                {
                    ToolTip = 'Specifies the value of the ExpenseCategory field.';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.';
                }
            }
        }
    }
}
