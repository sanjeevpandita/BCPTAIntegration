page 70048 PTAInboundPaymentsReceivedCard
{
    ApplicationArea = All;
    Caption = 'PTAInboundPaymentsReceivedCard';
    PageType = Card;
    SourceTable = PTAInboundPaymentsReceived;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(PaymentDate; Rec.PaymentDate)
                {
                    ToolTip = 'Specifies the value of the PaymentDate field.';
                }
                field(Charges; Rec.Charges)
                {
                    ToolTip = 'Specifies the value of the Charges field.';
                }
                field(Notes; Rec.Notes)
                {
                    ToolTip = 'Specifies the value of the Notes field.';
                }
                field(CounterpartyId; Rec.CounterpartyId)
                {
                    ToolTip = 'Specifies the value of the CounterpartyId field.';
                }
                field(BankAccountId; Rec.BankAccountId)
                {
                    ToolTip = 'Specifies the value of the BankAccountId field.';
                }
                field(PaymentRef; Rec.PaymentRef)
                {
                    ToolTip = 'Specifies the value of the PaymentRef field.';
                }
                field(LiveApplicationSourceId; Rec.LiveApplicationSourceId)
                {
                    ToolTip = 'Specifies the value of the LiveApplicationSourceId field.';
                }
                field(IsRefund; Rec.IsRefund)
                {
                    ToolTip = 'Specifies the value of the IsRefund field.';
                }
            }
            group(Amounts)
            {
                Caption = 'Amounts';

                field(AmountReceivedPrice; Rec.AmountReceivedPrice)
                {
                    ToolTip = 'Specifies the value of the AmountReceivedPrice field.';
                }
                field(AmountReceivedCurrencyId; Rec.AmountReceivedCurrencyId)
                {
                    ToolTip = 'Specifies the value of the AmountReceivedCurrencyId field.';
                }
                field(AllocatedAmountPrice; Rec.AllocatedAmountPrice)
                {
                    ToolTip = 'Specifies the value of the AllocatedAmountPrice field.';
                }
                field(AllocatedAmountCurrencyId; Rec.AllocatedAmountCurrencyId)
                {
                    ToolTip = 'Specifies the value of the AllocatedAmountCurrencyId field.';
                }
                field(ApplicableAmountCurrencyId; Rec.ApplicableAmountCurrencyId)
                {
                    ToolTip = 'Specifies the value of the ApplicableAmountCurrencyId field.';
                }
                field(ApplicableAmountPrice; Rec.ApplicableAmountPrice)
                {
                    ToolTip = 'Specifies the value of the ApplicableAmountPrice field.';
                }
                field(AmountInUSD; Rec.AmountInUSD)
                {
                    ToolTip = 'Specifies the value of the AmountInUSD field.';
                }
            }
            part(PTAInbPayAllocDetailsSubPage; PTAInbPayAllocDetailsSubPage)
            {
                Caption = 'Allocations';
                SubPageLink = PaymentReceivedId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part(PTAEnquiryError; PTAEnquiryError)
            {
                ApplicationArea = All;
                Caption = 'Payment Errors';
                SubPageLink = EntityType = filter("Inbound Payment"), EnquiryID = field(ID), BatchID = field(TransactionBatchId), HeaderEntryNo = field(EntryNo);
            }

            group(Dates)
            {
                Caption = 'Dates';

                field(CreatedDate; Rec.CreatedDate)
                {
                    ToolTip = 'Specifies the value of the CreatedDate field.';
                }
                field(CreatedBy; Rec.CreatedBy)
                {
                    ToolTip = 'Specifies the value of the CreatedBy field.';
                }
                field(DeletedDate; Rec.DeletedDate)
                {
                    ToolTip = 'Specifies the value of the DeletedDate field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }
                field(ErrorDateTime; Rec.ErrorDateTime)
                {
                    ToolTip = 'Specifies the value of the ErrorDateTime field.';
                }
            }
        }
    }
}
