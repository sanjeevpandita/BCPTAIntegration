page 70057 "PTAVoucherAddServices"
{
    ApplicationArea = All;
    Caption = 'PTA VoucherAddServices';
    PageType = ListPart;
    SourceTable = PTAVoucherAddServices;

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
                field(EnquiryAdditionalServiceId; Rec.EnquiryAdditionalServiceId)
                {
                }
                field("Is VAT/GST Service"; Rec."Is VAT/GST Service")
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
