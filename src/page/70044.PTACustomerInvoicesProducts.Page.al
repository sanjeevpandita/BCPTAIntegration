page 70044 PTACustomerInvoicesProducts
{
    ApplicationArea = All;
    Caption = 'Customer Invoices Products';
    PageType = ListPart;
    SourceTable = PTACustomerInvoiceProducts;
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                }
                field(EnquiryId; Rec.EnquiryId)
                {
                }
                field(CustomerInvoiceId; Rec.CustomerInvoiceId)
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
                field(Specification; Rec.Specification)
                {
                }
                field(ProductId; Rec.ProductId)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(UnitId; Rec.UnitId)
                {
                }
                field(SellPriceUOMId; Rec.SellPriceUOMId)
                {
                }
                field(WeightingFactor; Rec.WeightingFactor)
                {
                }
                field(DeliveryDensity; Rec.DeliveryDensity)
                {
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                }
                field(EntryNo; Rec.EntryNo)
                {
                }
            }
        }
    }
}
