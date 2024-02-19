codeunit 70039 PTAVoidCustomerInvoice
{
    TableNo = PTACustomerInvoices;

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
        PTACustomerInvoices: Record PTACustomerInvoices;
        SalesPost: Codeunit "Sales-Post";
    begin
        PTACustomerInvoices := Rec;
        CreateCreditMemo(SalesHeader, Format(PTACustomerInvoices.InvoiceNumber));

        SalesHeader.SetRecFilter();
        SalesHeader.Invoice := TRUE;
        SalesHeader.Receive := TRUE;
        SalesHeader.MODIFY;
        COMMIT;
        CLEAR(SalesPost);
        SalesPost.RUN(SalesHeader);
    end;

    procedure CreateCreditMemo(Var NewSalesHeader: Record "Sales Header"; PostedInvoiceNo: Code[20])
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.get(PostedInvoiceNo);

        NewSalesHeader.init;
        NewSalesHeader."Document Type" := NewSalesHeader."Document Type"::"Credit Memo";
        NewSalesHeader."No." := '';
        NewSalesHeader.insert(true);
        NewSalesHeader.SetHideValidationDialog(true);
        NewSalesHeader.validate("Sell-to Customer No.", SalesInvoiceHeader."Sell-to Customer No.");
        NewSalesHeader.modify(true);

        CopyDocMgt.SetProperties(
            True, false, FALSE, FALSE, FALSE, True, FALSE);
        CopyDocMgt.CopySalesDoc(Enum::"Sales Document Type From"::"Posted Invoice", PostedInvoiceNo, NewSalesHeader);
        NewSalesHeader.VALIDATE("Applies-to Doc. Type", NewSalesHeader."Applies-to Doc. Type"::Invoice);
        NewSalesHeader.VALIDATE("Applies-to Doc. No.", PostedInvoiceNo);
        NewSalesHeader.MODIFY(TRUE);
    end;

}