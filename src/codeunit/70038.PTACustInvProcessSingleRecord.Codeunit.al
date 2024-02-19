codeunit 70038 PTACustInvProcessSingleRecord
{

    TableNo = PTACustomerInvoices;

    trigger OnRun()
    var
        PTACustomerInvoices: Record PTACustomerInvoices;
    begin
        PTACustomerInvoices := Rec;
        case PTACustomerInvoices.StatusId of
            4:
                begin
                    PTACustomerInvoiceValidation.Run(PTACustomerInvoices);
                    PTACustomerInvoiceProcessPost.run(PTACustomerInvoices);
                end;
            7:
                begin
                    PTACustomerInvoiceValidation.Run(PTACustomerInvoices);
                    PTAVoidCustomerInvoice.run(PTACustomerInvoices);
                end;
            else
                exit;
        end;

    end;

    var
        PTACustomerInvoiceValidation: Codeunit PTACustomerInvoiceValidation;

        PTACustomerInvoiceProcessPost: Codeunit PTACustomerInvoiceProcessPost;
        PTAVoidCustomerInvoice: Codeunit PTAVoidCustomerInvoice;

}