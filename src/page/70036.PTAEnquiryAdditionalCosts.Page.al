page 70036 "PTA Enquiry Additional Costs"
{
    ApplicationArea = All;
    Caption = 'PTA Enquiry Additional Costs';
    PageType = ListPart;
    SourceTable = PTAEnquiryAdditionalCost;
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
                field(EnquiryId; Rec.EnquiryId)
                {
                    ToolTip = 'Specifies the value of the EnquiryId field.';
                }
                field(SupplierId; Rec.SupplierId)
                {
                    ToolTip = 'Specifies the value of the SupplierId field.';
                }
                field(SupplierContactId; Rec.SupplierContactId)
                {
                    ToolTip = 'Specifies the value of the SupplierContactId field.';
                }
                field(SupplierBrokerId; Rec.SupplierBrokerId)
                {
                    ToolTip = 'Specifies the value of the SupplierBrokerId field.';
                }
                field(SupplierBrokerContactId; Rec.SupplierBrokerContactId)
                {
                    ToolTip = 'Specifies the value of the SupplierBrokerContactId field.';
                }
                field(SupplierPaymentTermId; Rec.SupplierPaymentTermId)
                {
                    ToolTip = 'Specifies the value of the SupplierPaymentTermId field.';
                }
                field(SupplierDelivery; Rec.SupplierDelivery)
                {
                    ToolTip = 'Specifies the value of the SupplierDelivery field.';
                }
                field(BuyCurrencyId; Rec.BuyCurrencyId)
                {
                    ToolTip = 'Specifies the value of the BuyCurrencyId field.';
                }
                field(SellCurrencyId; Rec.SellCurrencyId)
                {
                    ToolTip = 'Specifies the value of the SellCurrencyId field.';
                }
                field(SupplierExposure; Rec.SupplierExposure)
                {
                    ToolTip = 'Specifies the value of the SupplierExposure field.';
                }
                field(IsPaymentPaidInAdvance; Rec.IsPaymentPaidInAdvance)
                {
                    ToolTip = 'Specifies the value of the IsPaymentPaidInAdvance field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(TotalAdditionalCost; Rec.TotalAdditionalCost)
                {
                    ToolTip = 'Specifies the value of the TotalAdditionalCost field.';
                }
                field(AdditionalCostDetailsId; Rec.AdditionalCostDetailsId)
                {
                    ToolTip = 'Specifies the value of the AdditionalCostDetailsId field.';
                }
                field(QuantityFrom; Rec.QuantityFrom)
                {
                    ToolTip = 'Specifies the value of the QuantityFrom field.';
                }
                field(QuantityTo; Rec.QuantityTo)
                {
                    ToolTip = 'Specifies the value of the QuantityTo field.';
                }
                field(SellRate; Rec.SellRate)
                {
                    ToolTip = 'Specifies the value of the SellRate field.';
                }
                field(BuyUOMId; Rec.BuyUOMId)
                {
                    ToolTip = 'Specifies the value of the BuyUOMId field.';
                }
                field(SellUOMId; Rec.SellUOMId)
                {
                    ToolTip = 'Specifies the value of the SellUOMId field.';
                }
                field(CostTypeId; Rec.CostTypeId)
                {
                    ToolTip = 'Specifies the value of the CostTypeId field.';
                }
                field(PortId; Rec.PortId)
                {
                    ToolTip = 'Specifies the value of the PortId field.';
                }
                field(ProductTypeId; Rec.ProductTypeId)
                {
                    ToolTip = 'Specifies the value of the ProductTypeId field.';
                }
                field(DeliveryTypeId; Rec.DeliveryTypeId)
                {
                    ToolTip = 'Specifies the value of the DeliveryTypeId field.';
                }
                field(FixedQuantity; Rec.FixedQuantity)
                {
                    ToolTip = 'Specifies the value of the FixedQuantity field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(BuyRate; Rec.BuyRate)
                {
                    ToolTip = 'Specifies the value of the BuyRate field.';
                }
                field(SellLumpsum; Rec.SellLumpsum)
                {
                    ToolTip = 'Specifies the value of the SellLumpsum field.';
                }
                field(EffectiveFrom; Rec.EffectiveFrom)
                {
                    ToolTip = 'Specifies the value of the EffectiveFrom field.';
                }
                field(EffectiveUntil; Rec.EffectiveUntil)
                {
                    ToolTip = 'Specifies the value of the EffectiveUntil field.';
                }
                field(BuyLumpsum; Rec.BuyLumpsum)
                {
                    ToolTip = 'Specifies the value of the BuyLumpsum field.';
                }
                field(SellIsApplicable; Rec.SellIsApplicable)
                {
                    ToolTip = 'Specifies the value of the SellIsApplicable field.';
                }
                field(BuyIsApplicable; Rec.BuyIsApplicable)
                {
                    ToolTip = 'Specifies the value of the BuyIsApplicable field.';
                }
                field(NativeSellExposure; Rec.NativeSellExposure)
                {
                    ToolTip = 'Specifies the value of the NativeSellExposure field.';
                }
                field(NativeBuyExposure; Rec.NativeBuyExposure)
                {
                    ToolTip = 'Specifies the value of the NativeBuyExposure field.';
                }
                field(ApplicableQuantity; Rec.ApplicableQuantity)
                {
                    ToolTip = 'Specifies the value of the ApplicableQuantity field.';
                }
                field(BatchID; Rec.TransactionBatchId)
                {
                    ToolTip = 'Specifies the value of the BatchID field.';
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
