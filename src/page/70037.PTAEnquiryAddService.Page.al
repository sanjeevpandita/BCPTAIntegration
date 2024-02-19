page 70037 "PTA Enquiry Add. Service"
{
    ApplicationArea = All;
    Caption = 'PTA Enquiry Add. Service';
    PageType = ListPart;
    SourceTable = PTAEnquiryAddServices;
    UsageCategory = Lists;

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
                field(CurrencyId; Rec.CurrencyId)
                {
                }
                field(SupplierId; Rec.SupplierId)
                {
                }
                field(SupplierPaymentTermId; Rec.SupplierPaymentTermId)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(SellRate; Rec.SellRate)
                {
                }
                field(BuyRate; Rec.BuyRate)
                {
                }
                field(UOMId; Rec.UOMId)
                {
                }
                field(ProductId; Rec.ProductId)
                {
                }
                field("Is VAT/GST Service"; Rec."Is VAT/GST Service")
                {

                }
                field(Description; Rec.Description)
                {
                }
                field(SupplierExposure; Rec.SupplierExposure)
                {
                }
                field(IsPaymentPaidInAdvance; Rec.IsPaymentPaidInAdvance)
                {
                }
                field(DeliveryDate; Rec.DeliveryDate)
                {
                }
                field(SellCurrencyId; Rec.SellCurrencyId)
                {
                }
                field(SupplierToEmail; Rec.SupplierToEmail)
                {
                }
                field(SupplierCCEmail; Rec.SupplierCCEmail)
                {
                }
                field(NativeSellExposure; Rec.NativeSellExposure)
                {
                }
                field(NativeBuyExposure; Rec.NativeBuyExposure)
                {
                }
                field(BatchID; Rec.TransactionBatchId)
                {
                }
                field(EntryNo; Rec.EntryNo)
                {
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}
