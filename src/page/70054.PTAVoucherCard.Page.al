page 70054 "PTAVoucherCard"
{
    ApplicationArea = All;
    Caption = 'PTA Voucher Card';
    PageType = Card;
    SourceTable = PTAVouchers;

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
                field(InvoiceNumber; Rec.InvoiceNumber)
                {
                    ToolTip = 'Specifies the value of the InvoiceNumber field.';
                }
                field(InvoiceFileName; Rec.InvoiceFileName)
                {
                    ToolTip = 'Specifies the value of the InvoiceFileName field.';
                }
                field(InvoiceDate; Rec.InvoiceDate)
                {
                    ToolTip = 'Specifies the value of the InvoiceDate field.';
                }
                field(DueDate; Rec.DueDate)
                {
                    ToolTip = 'Specifies the value of the DueDate field.';
                }
                field(TotalInvoiceAmount; Rec.TotalInvoiceAmount)
                {
                    ToolTip = 'Specifies the value of the TotalInvoiceAmount field.';
                }
                field(CurrencyId; Rec.CurrencyId)
                {
                    ToolTip = 'Specifies the value of the CurrencyId field.';
                }
                field(VesselId; Rec.VesselId)
                {
                    ToolTip = 'Specifies the value of the VesselId field.';
                }
                field(VesselName; Rec.VesselName)
                {
                    ToolTip = 'Specifies the value of the VesselName field.';
                }
                field(VouchedBy; Rec.VouchedBy)
                {
                    ToolTip = 'Specifies the value of the VouchedBy field.';
                }
                field(VouchedDate; Rec.VouchedDate)
                {
                    ToolTip = 'Specifies the value of the VouchedDate field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                    MultiLine = true;
                }
                field(ErrorDateTime; Rec.ErrorDateTime)
                {
                    ToolTip = 'Specifies the value of the ErrorDateTime field.';
                }
            }
            part(PTAVoucherProducts; "PTAVoucherProducts")
            {
                Caption = 'Products';
                SubPageLink = VoucherId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part(PTAEnquiryError; PTAEnquiryError)
            {
                ApplicationArea = All;
                Caption = 'Voucher Errors';
                SubPageLink = EntityType = filter(Voucher | VoucherAddServ | VoucherAdditionalCosts | VoucherProducts), EnquiryID = field(ID), BatchID = field(TransactionBatchId), HeaderEntryNo = field(EntryNo);
            }
            part(PTAVoucherAddCost; "PTAVoucherAddCost")
            {
                Caption = 'Additional Costs';
                SubPageLink = VoucherId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part(PTAVoucherAddServices; "PTAVoucherAddServices")
            {
                Caption = 'Additional Services';
                SubPageLink = VoucherId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            group(Others)
            {
                Caption = 'Others';

                field(PaymentTermId; Rec.PaymentTermId)
                {
                    ToolTip = 'Specifies the value of the PaymentTermId field.';
                }
                field(SupplierId; Rec.SupplierId)
                {
                    ToolTip = 'Specifies the value of the SupplierId field.';
                }
                field(PaidAmountPrice; Rec.PaidAmountPrice)
                {
                    ToolTip = 'Specifies the value of the PaidAmountPrice field.';
                }
                field(PaidAmountCurrencyId; Rec.PaidAmountCurrencyId)
                {
                    ToolTip = 'Specifies the value of the PaidAmountCurrencyId field.';
                }
                field(OnHold; Rec.OnHold)
                {
                    ToolTip = 'Specifies the value of the OnHold field.';
                }
                field(IsNonDealPurchaseInvoice; Rec.IsNonDealPurchaseInvoice)
                {
                    ToolTip = 'Specifies the value of the IsNonDealPurchaseInvoice field.';
                }
                field(LiveApplicationSourceId; Rec.LiveApplicationSourceId)
                {
                    ToolTip = 'Specifies the value of the LiveApplicationSourceId field.';
                }
                field(IsTemporaryVoucher; Rec.IsTemporaryVoucher)
                {
                    ToolTip = 'Specifies the value of the IsTemporaryVoucher field.';
                }
                field(CommissionInvoice; Rec.CommissionInvoice)
                {
                    ToolTip = 'Specifies the value of the CommissionInvoice field.';
                }
                field(LateCommissionEntry; Rec.LateCommissionEntry)
                {
                    ToolTip = 'Specifies the value of the LateCommissionEntry field.';
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                    ToolTip = 'Specifies the value of the TransactionBatchId field.';
                }
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }

                field(isDeleted; Rec.isDeleted)
                {
                    ToolTip = 'Specifies the value of the isDeleted field.';
                }
            }
        }

        area(FactBoxes)
        {
            part(PTAVoucherEnquiries; PTAVoucherEnquiries)
            {
                ApplicationArea = All;
                Caption = 'Related Enquiries';
                SubPageLink = VoucherId = field(ID), TransactionBatchId = field(TransactionBatchId);
            }
        }
    }
}
