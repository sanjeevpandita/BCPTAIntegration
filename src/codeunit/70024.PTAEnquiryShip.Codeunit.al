codeunit 70024 "PTAEnquiryShip"
{
    TableNo = PTAEnquiry;
    trigger OnRun()
    begin
        if SalesHeader.get(SalesHeader."Document Type"::Order, Format(Rec.EnquiryNumber)) then begin
            SalesHeader.SetRecFilter();
            SalesHeader.SetHideValidationDialog(true);
            SalesHeader.VALIDATE("Posting Date", DT2DATE(Rec.EnquiryDate));
            SalesHeader.Ship := TRUE;
            SalesHeader.Invoice := FALSE;
            SalesHeader.MODIFY;
            ReleaseSalesDocument.Run(SalesHeader);
            PTAEnquiryConvertToDocuments.CreateAndCalculateVATToleranceOnSalesOrder(SalesHeader);
        end else
            Error('Enquiry does not exist');
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";

        ReleaseSalesDocument: Codeunit "Release Sales Document";
        PTAEnquiryConvertToDocuments: Codeunit PTAEnquiryConvertToDocuments;
}