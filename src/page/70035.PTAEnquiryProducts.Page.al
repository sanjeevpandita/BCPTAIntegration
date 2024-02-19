page 70035 PTAEnquiryProducts
{
    ApplicationArea = All;
    Caption = 'PTAEnquiryProducts';
    PageType = ListPart;
    SourceTable = PTAEnquiryProducts;
    UsageCategory = Lists;
    Editable = true; //TODO

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
                field(ProductId; Rec.ProductId)
                {
                }
                field(SupplierId; Rec.SupplierId)
                {
                }
                field(SupplierContactId; Rec.SupplierContactId)
                {
                }
                field(SupplierBrokerId; Rec.SupplierBrokerId)
                {
                }
                field(SupplierBrokerContactId; Rec.SupplierBrokerContactId)
                {
                }
                field(SupplierContractId; Rec.SupplierContractId)
                {
                }
                field(SupplierPaymentTermId; Rec.SupplierPaymentTermId)
                {
                }
                field(SupplierDeliveryType; Rec.SupplierDeliveryType)
                {
                }
                field(BuyMin; Rec.BuyMin)
                {
                }
                field(BuyMax; Rec.BuyMax)
                {
                }
                field(BuyPrice; Rec.BuyPrice)
                {
                }
                field(BuyUnitId; Rec.BuyUnitId)
                {
                }
                field(BuyCurrencyId; Rec.BuyCurrencyId)
                {
                }
                field(SellMin; Rec.SellMin)
                {
                }
                field(SellMax; Rec.SellMax)
                {
                }
                field(SellPrice; Rec.SellPrice)
                {
                }
                field(SellUnitId; Rec.SellUnitId)
                {
                }
                field(SellCurrencyId; Rec.SellCurrencyId)
                {
                }
                field(CustomerBrokerCommision; Rec.CustomerBrokerCommision)
                {
                }
                field(SupplierBrokerCommision; Rec.SupplierBrokerCommision)
                {
                }
                field(CreatedDate; Rec.CreatedDate)
                {
                }
                field(CustomerContractId; Rec.CustomerContractId)
                {
                }
                field(TakePosition; Rec.TakePosition)
                {
                }
                field(BuyPriceUOMId; Rec.BuyPriceUOMId)
                {
                }
                field(SellPriceUOMId; Rec.SellPriceUOMId)
                {
                }
                field(OwnCommission; Rec.OwnCommission)
                {
                }
                field(BuyCurrencyExchangeRate; Rec.BuyCurrencyExchangeRate)
                {
                }
                field(SellCurrencyExchangeRate; Rec.SellCurrencyExchangeRate)
                {
                }
                field(Specification; Rec.Specification)
                {
                }
                field(ParentDealProductId; Rec.ParentDealProductId)
                {
                }
                field(CalsoftProductSequenceNumber; Rec.CalsoftProductSequenceNumber)
                {
                }
                field(DeliveredQuantity; Rec.DeliveredQuantity)
                {
                }
                field(DeliveryUnitId; Rec.DeliveryUnitId)
                {
                }
                field(DeliveryDensity; Rec.DeliveryDensity)
                {
                }
                field(GrossBBL; Rec.GrossBBL)
                {
                }
                field(NetBBL; Rec.NetBBL)
                {
                }
                field(SupplierExposure; Rec.SupplierExposure)
                {
                }
                field(AutoAgencyProduct; Rec.AutoAgencyProduct)
                {
                }
                field(BuyDeliveredQuantity; Rec.BuyDeliveredQuantity)
                {
                }
                field(BuyDeliveryUnitId; Rec.BuyDeliveryUnitId)
                {
                }
                field(IsPaymentPaidInAdvance; Rec.IsPaymentPaidInAdvance)
                {
                }
                field(QuantityInMT; Rec.QuantityInMT)
                {
                }
                field(OperationalDeliveredQantity; Rec.OperationalDeliveredQantity)
                {
                }
                field(IsDeliveredSellPrice; Rec.IsDeliveredSellPrice)
                {
                }
                field(BatchID; Rec.TransactionBatchId)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                    editable = false;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                    editable = false;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.';
                    editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                    editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                    editable = false;
                }
            }
        }
    }
}
