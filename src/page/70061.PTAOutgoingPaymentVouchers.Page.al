page 70061 PTAOutgoingPaymentVouchers
{
    ApplicationArea = All;
    Caption = 'PTAOutgoingPaymentVouchers';
    PageType = ListPart;
    SourceTable = PTAOutgoingPaymentVouchers;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                }
                field(OutGoingPaymentId; Rec.OutGoingPaymentId)
                {
                }
                field(VoucherId; Rec.VoucherId)
                {
                }
                field(PaidAmount; Rec.PaidAmount)
                {
                }
                field(PaidAmountCurrencyId; Rec.PaidAmountCurrencyId)
                {
                }
                field(EnquiryId; Rec.EnquiryId)
                {
                }
                field(BuyingCompanyId; Rec.MWBuyingCompanyId)
                {
                }
                field(PaymentReceivedId; Rec.PaymentReceivedId)
                {
                }
                field(CustomerInvoiceId; Rec.CustomerInvoiceId)
                {
                }
                field(AllocatedOutgoingPaymentId; Rec.AllocatedOutgoingPaymentId)
                {
                }
            }
        }
    }
}
