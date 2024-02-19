page 70060 "PTAOutgoingPayments Card"
{
    ApplicationArea = All;
    Caption = 'PTAOutgoingPayments Card';
    PageType = Card;
    SourceTable = PTAOutgoingPayments;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(ID; Rec.ID)
                {
                }
                field(SupplierId; Rec.SupplierId)
                {
                }
                field(PPLBankAccountId; Rec.PPLBankAccountId)
                {
                }
                field(PaymentDate; Rec.PaymentDate)
                {
                }
                field(Notes; Rec.Notes)
                {
                }
                field(RequestedAmountPrice; Rec.RequestedAmountPrice)
                {
                }
                field(RequestedAmountCurrencyId; Rec.RequestedAmountCurrencyId)
                {
                }
                field(RequestedBy; Rec.RequestedBy)
                {
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                }
            }
            part(PTAOutgoingPaymentVouchers; PTAOutgoingPaymentVouchers)
            {
                Caption = 'Allocations';
                SubPageLink = OutGoingPaymentId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part(PTAEnquiryError; PTAEnquiryError)
            {
                ApplicationArea = All;
                Caption = 'Payment Errors';
                SubPageLink = EntityType = filter("Outbound Payment"), EnquiryID = field(ID), BatchID = field(TransactionBatchId), HeaderEntryNo = field(EntryNo);
            }
            group(Others)
            {
                Caption = 'Others';

                field(StatusId; Rec.StatusId)
                {
                }
                field(AdvancePaymentFileName; Rec.AdvancePaymentFileName)
                {
                }
                field(IsPaymentInAdvance; Rec.IsPaymentInAdvance)
                {
                }
                field(IsRefund; Rec.IsRefund)
                {
                }
                field(LiveApplicationSourceId; Rec.LiveApplicationSourceId)
                {
                }
                field(PaidSourceId; Rec.PaidSourceId)
                {
                }
                field(AmountInUSD; Rec.AmountInUSD)
                {
                }
                field(OutstandingAmount; Rec.OutstandingAmount)
                {
                }
                field(PaymentCreatedDate; Rec.PaymentCreatedDate)
                {
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                }
                field(isDeleted; Rec.isDeleted)
                {
                }
                field("Error Exists"; Rec."Error Exists")
                {
                }
            }
        }
    }
}
