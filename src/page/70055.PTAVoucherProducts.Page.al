page 70055 "PTAVoucherProducts"
{
    ApplicationArea = All;
    Caption = 'PTA VoucherProducts';
    PageType = ListPart;
    SourceTable = PTAVoucherProducts;

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
                field(EnquiryProductId; Rec.EnquiryProductId)
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
