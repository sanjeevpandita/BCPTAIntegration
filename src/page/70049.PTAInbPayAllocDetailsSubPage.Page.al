page 70049 PTAInbPayAllocDetailsSubPage
{
    ApplicationArea = All;
    Caption = 'PTAInboundPayAllocDetailsSubPa';
    PageType = ListPart;
    SourceTable = PTAInboundPayAllocDetails;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(InvoiceId; Rec.InvoiceId)
                {
                    ToolTip = 'Specifies the value of the InvoiceId field.';
                }
                field(AllocateAmountPrice; Rec.AllocateAmountPrice)
                {
                    ToolTip = 'Specifies the value of the AllocateAmountPrice field.';
                }
                field(AllocateAmountCurrencyId; Rec.AllocateAmountCurrencyId)
                {
                    ToolTip = 'Specifies the value of the AllocateAmountCurrencyId field.';
                }
                field(EnquiryId; Rec.EnquiryId)
                {
                    ToolTip = 'Specifies the value of the EnquiryId field.';
                }
                field(BuyingCompanyId; Rec.MWBuyingCompanyId)
                {
                    ToolTip = 'Specifies the value of the BuyingCompanyId field.';
                }
                field(OutgoingPaymentId; Rec.OutgoingPaymentId)
                {
                    ToolTip = 'Specifies the value of the OutgoingPaymentId field.';
                }
                field(VoucherId; Rec.VoucherId)
                {
                    ToolTip = 'Specifies the value of the VoucherId field.';
                }
                field(AllocatedPaymentReceivedId; Rec.AllocatedPaymentReceivedId)
                {
                    ToolTip = 'Specifies the value of the AllocatedPaymentReceivedId field.';
                }
            }
        }
    }
}
