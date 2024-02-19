page 70045 "PTACustomerInvoiceCosts"
{
    ApplicationArea = All;
    Caption = 'PTA Customer Invoice Costs';
    PageType = ListPart;
    SourceTable = PTACustomerInvoiceAddCost;
    UsageCategory = None;
    editable = false;

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
                field(EnquiryAdditionalCostId; Rec.EnquiryAdditionalCostId)
                {
                }
                field(Price; Rec.Price)
                {
                }
                field(CurrencyId; Rec.CurrencyId)
                {
                }
                field(CostTypeId; Rec.CostTypeId)
                {
                }
                field(ApplicableQuantity; Rec.ApplicableQuantity)
                {
                }
                field(ApplicableUnitId; Rec.ApplicableUnitId)
                {
                }
                field(SellLumpsum; Rec.SellLumpsum)
                {
                }
                field(FixedQuantity; Rec.FixedQuantity)
                {
                }
                field(WeightingFactor; Rec.WeightingFactor)
                {
                }
                field(PercentileAdditionalCostTypeId; Rec.PercentileAdditionalCostTypeId)
                {
                }
                field(PercentAddCostTotAmtCurrencyId; Rec.PercentAddCostTotAmtCurrencyId)
                {
                }
                field(PercentileAddCostTotalAmount; Rec.PercentileAddCostTotalAmount)
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
