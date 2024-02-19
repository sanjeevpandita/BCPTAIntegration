page 70059 PTAOutgoingPayments
{
    ApplicationArea = All;
    Caption = 'PTAOutgoingPayments';
    PageType = List;
    SourceTable = PTAOutgoingPayments;
    UsageCategory = Lists;
    CardPageId = "PTAOutgoingPayments Card";
    SourceTableView = SORTING(EntryNo) ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                }
                field(SupplierId; Rec.SupplierId)
                {
                }
                field(StatusId; Rec.StatusId)
                {
                }
                field(BCBuyingCompanyId; Rec.BCBuyingCompanyId)
                {
                    ToolTip = 'Specifies the value of the BCBuyingCompanyId field.';
                }
                field(BankExistsInThisCompany; Rec.BankExistsInThisCompany)
                {
                    ToolTip = 'Specifies the value of the BankExistsInThisCompany field.';
                }
                field(PaymentDate; Rec.PaymentDate)
                {
                }
                field(RequestedAmountPrice; Rec.RequestedAmountPrice)
                {
                }
                field(RequestedAmountCurrencyId; Rec.RequestedAmountCurrencyId)
                {
                }
                field(Processed; Rec.Processed)
                {
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                }
                field(PPLBankAccountId; Rec.PPLBankAccountId)
                {
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                }
            }
        }
    }
}
