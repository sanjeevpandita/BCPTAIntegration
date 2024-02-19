page 70043 "PTACustomerInvoiceCard"
{
    ApplicationArea = All;
    Caption = 'PTA CustomerInvoice Card';
    PageType = Card;
    SourceTable = PTACustomerInvoices;
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
                field(InvoiceNumber; Rec.InvoiceNumber)
                {
                    ToolTip = 'Specifies the value of the InvoiceNumber field.';
                }
                field(InvoiceDate; Rec.InvoiceDate)
                {
                    ToolTip = 'Specifies the value of the InvoiceDate field.';
                }
                field(FinalizeDate; Rec.FinalizeDate)
                {
                    ToolTip = 'Specifies the value of the FinalizeDate field.';
                }
                field(EnquiryId; Rec.EnquiryId)
                {
                    ToolTip = 'Specifies the value of the EnquiryId field.';
                }
                field(DueDate; Rec.DueDate)
                {
                    ToolTip = 'Specifies the value of the DueDate field.';
                }
                field(DraftedOn; Rec.DraftedOn)
                {
                    ToolTip = 'Specifies the value of the DraftedOn field.';
                }
                field(CurrencyId; Rec.CurrencyId)
                {
                    ToolTip = 'Specifies the value of the CurrencyId field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(CustomerTradingAddress; Rec.CustomerTradingAddress)
                {
                    ToolTip = 'Specifies the value of the CustomerTradingAddress field.';
                }
                field(CreditNoteId; Rec.CreditNoteId)
                {
                    ToolTip = 'Specifies the value of the CreditNoteId field.';
                }
                field(BuyingCompanyId; Rec.BuyingCompanyId)
                {
                    ToolTip = 'Specifies the value of the BuyingCompanyId field.';
                }
                field(StatusId; Rec.StatusId)
                {
                    ToolTip = 'Specifies the value of the StatusId field.';
                }
            }
            part(PTACustomerInvoiceProducts; PTACustomerInvoicesProducts)
            {
                Caption = 'CustomerProducts';
                SubPageLink = CustomerInvoiceId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part(PTACustomerInvoiceError; PTAEnquiryError)
            {
                ApplicationArea = All;
                Caption = 'Enquiry Errors';
                SubPageLink = EntityType = filter(CustomerInvoice | CustomerInvoiceProducts | CustomerInvoiceAdditionalCosts | CustomerInvoiceAddServ), EnquiryID = field(ID), BatchID = field(TransactionBatchId), HeaderEntryNo = field(EntryNo);
            }
            part(PTACustomerInvoiceCosts; PTACustomerInvoiceCosts)
            {
                Caption = 'Additional Costs';
                SubPageLink = InvoiceId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part("PTA Enquiry Add. Service"; PTACustomerInvoiceServices)
            {
                Caption = 'Additional Services';
                SubPageLink = InvoiceId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }

            group(Other)
            {
                Caption = 'Other';

                field(ApprovedOn; Rec.ApprovedOn)
                {
                    ToolTip = 'Specifies the value of the ApprovedOn field.';
                }
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(IsCreditNote; Rec.IsCreditNote)
                {
                    ToolTip = 'Specifies the value of the IsCreditNote field.';
                }
                field(IsMultipleInvoice; Rec.IsMultipleInvoice)
                {
                    ToolTip = 'Specifies the value of the IsMultipleInvoice field.';
                }
                field(IsProformaInvoice; Rec.IsProformaInvoice)
                {
                    ToolTip = 'Specifies the value of the IsProformaInvoice field.';
                }
                field(IsReversal; Rec.IsReversal)
                {
                    ToolTip = 'Specifies the value of the IsReversal field.';
                }
                field(LiveApplicationSourceId; Rec.LiveApplicationSourceId)
                {
                    ToolTip = 'Specifies the value of the LiveApplicationSourceId field.';
                }
                field(MergeOrderLines; Rec.MergeOrderLines)
                {
                    ToolTip = 'Specifies the value of the MergeOrderLines field.';
                }
                field(NoteForCustomer; Rec.NoteForCustomer)
                {
                    ToolTip = 'Specifies the value of the NoteForCustomer field.';
                }
                field(OfficeId; Rec.OfficeId)
                {
                    ToolTip = 'Specifies the value of the OfficeId field.';
                }
                field(PPLBankAccountId; Rec.PPLBankAccountId)
                {
                    ToolTip = 'Specifies the value of the PPLBankAccountId field.';
                }
                field(PaidAmountCurrencyId; Rec.PaidAmountCurrencyId)
                {
                    ToolTip = 'Specifies the value of the PaidAmountCurrencyId field.';
                }
                field(PaidAmountPrice; Rec.PaidAmountPrice)
                {
                    ToolTip = 'Specifies the value of the PaidAmountPrice field.';
                }
                field(PaymentDate; Rec.PaymentDate)
                {
                    ToolTip = 'Specifies the value of the PaymentDate field.';
                }
                field(PaymentTermId; Rec.PaymentTermId)
                {
                    ToolTip = 'Specifies the value of the PaymentTermId field.';
                }
                field(ReasonForDeleteInvoice; Rec.ReasonForDeleteInvoice)
                {
                    ToolTip = 'Specifies the value of the ReasonForDeleteInvoice field.';
                }
                field(ReceiverId; Rec.ReceiverId)
                {
                    ToolTip = 'Specifies the value of the ReceiverId field.';
                }
                field(Reference; Rec.Reference)
                {
                    ToolTip = 'Specifies the value of the Reference field.';
                }
                field(ReversalInvoiceId; Rec.ReversalInvoiceId)
                {
                    ToolTip = 'Specifies the value of the ReversalInvoiceId field.';
                }
                field(SenderId; Rec.SenderId)
                {
                    ToolTip = 'Specifies the value of the SenderId field.';
                }
                field(VAT; Rec.VAT)
                {
                    ToolTip = 'Specifies the value of the VAT field.';
                }
                field(isDeleted; Rec.isDeleted)
                {
                    ToolTip = 'Specifies the value of the isDeleted field.';
                }
            }
        }
    }

    actions
    {
        Area(Promoted)
        {
            actionref(PromotedViewSalesInvoice; ViewSalesInvoice)
            {

            }
        }
        area(Processing)
        {
            action(ViewSalesInvoice)
            {
                ApplicationArea = All;
                Caption = 'View Sales Invoices';

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeader.reset;
                    SalesInvoiceHeader.SetRange("No.", Format(Rec.InvoiceNumber));
                    if SalesInvoiceHeader.FindFirst() then
                        Page.RunModal(0, SalesInvoiceHeader)
                end;
            }
        }
    }
}
