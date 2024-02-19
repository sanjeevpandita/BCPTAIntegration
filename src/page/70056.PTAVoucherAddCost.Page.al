page 70056 "PTAVoucherAddCost"
{
    ApplicationArea = All;
    Caption = 'PTA VoucherAddCost';
    PageType = ListPart;
    SourceTable = PTAVoucherAddCost;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                }
                field(ID; Rec.ID)
                {
                }
                field(VoucherId; Rec.VoucherId)
                {
                }
                field(EnquiryAdditionalCostId; Rec.EnquiryAdditionalCostId)
                {
                }
                field(Price; Rec.Price)
                {
                }
                field(CurrencyId; Rec.CurrencyId)
                {
                }
                field(isDeleted; Rec.isDeleted)
                {
                }
                field(WeightingFactor; Rec.WeightingFactor)
                {
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                }
            }
        }
    }
}
