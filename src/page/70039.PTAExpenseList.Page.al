page 70039 PTAExpenseList
{
    ApplicationArea = All;
    Caption = 'PTAExpenseList';
    PageType = List;
    SourceTable = PTAInboundExpenses;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(ExpenseClaimId; Rec.ExpenseClaimId)
                {
                    ToolTip = 'Specifies the value of the ExpenseClaimId field.';
                }
                field(ExpenseDate; Rec.ExpenseDate)
                {
                    ToolTip = 'Specifies the value of the ExpenseDate field.';
                }
                field(TripId; Rec.TripId)
                {
                    ToolTip = 'Specifies the value of the TripId field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Flagged; Rec.Flagged)
                {
                    ToolTip = 'Specifies the value of the Flagged field.';
                }
                field(Rate; Rec.Rate)
                {
                    ToolTip = 'Specifies the value of the Rate field.';
                }
                field(CurrencyID; Rec.CurrencyID)
                {
                    ToolTip = 'Specifies the value of the CurrencyID field.';
                }
                field(VatRateID; Rec.VatRateID)
                {
                    ToolTip = 'Specifies the value of the VatRateID field.';
                }
                field(VatAmount; Rec.VatAmount)
                {
                    ToolTip = 'Specifies the value of the VatAmount field.';
                }
                field(VATCurrencyID; Rec.VATCurrencyID)
                {
                    ToolTip = 'Specifies the value of the VATCurrencyID field.';
                }
                field(ReceiptAvailable; Rec.ReceiptAvailable)
                {
                    ToolTip = 'Specifies the value of the ReceiptAvailable field.';
                }
                field(ExpenseCategoryID; Rec.ExpenseCategoryID)
                {
                    ToolTip = 'Specifies the value of the ExpenseCategoryID field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(old_expense_claim_id; Rec.old_expense_claim_id)
                {
                    ToolTip = 'Specifies the value of the old_expense_claim_id field.';
                }
                field(old_expense_id; Rec.old_expense_id)
                {
                    ToolTip = 'Specifies the value of the old_expense_id field.';
                }
                field(old_trip_id; Rec.old_trip_id)
                {
                    ToolTip = 'Specifies the value of the old_trip_id field.';
                }
                field(old_cash_withdrawal_id; Rec.old_cash_withdrawal_id)
                {
                    ToolTip = 'Specifies the value of the old_cash_withdrawal_id field.';
                }
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
            }
        }
    }
}
