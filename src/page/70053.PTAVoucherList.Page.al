page 70053 "PTAVoucherList"
{
    ApplicationArea = All;
    Caption = 'PTA Voucher List';
    PageType = List;
    SourceTable = PTAVouchers;
    UsageCategory = Lists;
    CardPageId = "PTAVoucherCard";
    SourceTableView = SORTING(EntryNo) ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                }
                field(EntryNo; Rec.EntryNo)
                {
                }
                field(BuyingCompanyId; Rec.BCBuyingCompanyId)
                {
                }
                field(InvoiceNumber; Rec.InvoiceNumber)
                {
                }
                field(InvoiceDate; Rec.InvoiceDate)
                {
                }
                field(DueDate; Rec.DueDate)
                {
                }
                field(TotalInvoiceAmount; Rec.TotalInvoiceAmount)
                {
                }
                field(Processed; Rec.Processed)
                {
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                }
                field(VesselName; Rec.VesselName)
                {
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                    ToolTip = 'Specifies the value of the TransactionBatchId field.';
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
