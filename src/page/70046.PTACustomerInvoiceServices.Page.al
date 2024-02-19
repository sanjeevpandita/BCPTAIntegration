page 70046 "PTACustomerInvoiceServices"
{
    ApplicationArea = All;
    Caption = 'PTA Customer Invoice Services';
    PageType = ListPart;
    SourceTable = PTACustomerInvoiceAddServ;
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
                field(InvoiceId; Rec.InvoiceId)
                {
                }
                field(EnquiryAdditionalServiceId; Rec.EnquiryAdditionalServiceId)
                {
                }
                field(Price; Rec.Price)
                {
                }
                field(CurrencyId; Rec.CurrencyId)
                {
                }
                field(ProductId; Rec.ProductId)
                {
                }
                field("Is VAT/GST Service"; Rec."Is VAT/GST Service")
                {

                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(UnitId; Rec.UnitId)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(WeightingFactor; Rec.WeightingFactor)
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
