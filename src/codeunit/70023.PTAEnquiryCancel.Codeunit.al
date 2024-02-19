codeunit 70023 PTAEnquiryCancel
{
    TableNo = PTAEnquiry;
    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.get(SalesHeader."Document Type"::Order, Format(Rec.EnquiryNumber)) then begin
            PTAEnquiryFunctions.DeleteAllRelatedPOsWithSalesOrder(Rec, SalesHeader);
            SalesHeader.SetRecFilter();
            SalesHeader.delete(true);
        end else
            Error('Enquiry does not exist');
    end;

    var
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
}