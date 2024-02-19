page 70042 "PTACustomerInvoicesList"
{
    ApplicationArea = All;
    Caption = 'PTA CustomerInvoices';
    PageType = List;
    SourceTable = PTACustomerInvoices;
    UsageCategory = Lists;
    CardPageId = "PTACustomerInvoiceCard";
    SourceTableView = SORTING(EntryNo) ORDER(Descending);

    //Editable = false;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    StyleExpr = StyleText;
                }
                field(ID; Rec.ID)
                {
                    StyleExpr = StyleText;
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                    StyleExpr = StyleText;
                }
                field(EnquiryId; Rec.EnquiryId)
                {
                    StyleExpr = StyleText;
                }
                field(EnquiryNumber; Rec.EnquiryNumber)
                {

                }
                field(StatusId; Rec.StatusId)
                {
                    ToolTip = 'Specifies the value of the StatusId field.';
                }
                field(CreditNoteId; Rec.CreditNoteId)
                {
                }
                field(BuyingCompanyId; Rec.MWBuyingCompanyId)
                {
                }
                field(CurrencyId; Rec.CurrencyId)
                {
                }
                field(InvoiceNumber; Rec.InvoiceNumber)
                {
                }
                field(InvoiceDate; Rec.InvoiceDate)
                {
                    Editable = false;
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }

                field(FinalizeDate; Rec.FinalizeDate)
                {
                }
                field(DueDate; Rec.DueDate)
                {
                }
                field(DraftedOn; Rec.DraftedOn)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field(IsCreditNote; Rec.IsCreditNote)
                {
                }
                field(IsMultipleInvoice; Rec.IsMultipleInvoice)
                {
                }
                field(IsProformaInvoice; Rec.IsProformaInvoice)
                {
                }
                field(IsReversal; Rec.IsReversal)
                {
                }

                field(ApprovedOn; Rec.ApprovedOn)
                {
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
            action(ViewSalesOrder)
            {
                ApplicationArea = All;
                Caption = 'View Sales Order';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.reset;
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.setfilter("No.", '%1', Format(rec.EnquiryNumber));
                    if SalesHeader.FindFirst() then
                        Page.RunModal(0, SalesHeader)
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        StyleText := Rec.SetStyle();
    end;

    var
        StyleText: Text[30];
}
