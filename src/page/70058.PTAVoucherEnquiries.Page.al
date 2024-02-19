page 70058 PTAVoucherEnquiries
{
    ApplicationArea = All;
    Caption = 'PTAVoucherEnquiries';
    PageType = ListPart;
    SourceTable = PTAVoucherEnquiries;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(VoucherId; Rec.VoucherId)
                {
                }
                field(EnquiryId; Rec.EnquiryId)
                {
                }
                field(MWBuyingCompanyId; Rec.MWBuyingCompanyId)
                {
                }
            }
        }
    }
}
