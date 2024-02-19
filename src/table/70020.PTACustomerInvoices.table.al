table 70020 "PTACustomerInvoices"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageId = "PTACustomerInvoicesList";
    LookupPageId = "PTACustomerInvoicesList";

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(30; EnquiryId; Integer)
        {
            Caption = 'EnquiryId';
        }
        field(40; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(50; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }
        field(60; InvoiceDate; DateTime)
        {
            Caption = 'InvoiceDate';
        }
        field(70; StatusId; Integer)
        {
            Caption = 'StatusId';
        }
        field(80; InvoiceNumber; Text[40])
        {
            Caption = 'InvoiceNumber';
        }
        field(90; SenderId; Integer)
        {
            Caption = 'SenderId';
        }
        field(100; ReceiverId; Integer)
        {
            Caption = 'ReceiverId';
        }
        field(110; DueDate; DateTime)
        {
            Caption = 'DueDate';
        }
        field(120; NoteForCustomer; Text[2048])
        {
            Caption = 'NoteForCustomer';
        }
        field(140; IsProformaInvoice; Boolean)
        {
            Caption = 'IsProformaInvoice';
        }
        field(150; CreditNoteId; Integer)
        {
            Caption = 'CreditNoteId';
        }
        field(160; FinalizeDate; DateTime)
        {
            Caption = 'FinalizeDate';
        }
        field(170; VAT; Decimal)
        {
            Caption = 'VAT';
        }
        field(180; PaymentDate; DateTime)
        {
            Caption = 'PaymentDate';
        }
        field(190; MergeOrderLines; Boolean)
        {
            Caption = 'MergeOrderLines';
        }
        field(200; IsCreditNote; Boolean)
        {
            Caption = 'IsCreditNote';
        }
        field(210; CustomerTradingAddress; Text[500])
        {
            Caption = 'CustomerTradingAddress';
        }
        field(220; ReasonForDeleteInvoice; Text[250])
        {
            Caption = 'ReasonForDeleteInvoice';
        }
        field(230; PaidAmountPrice; Decimal)
        {
            Caption = 'PaidAmountPrice';
        }
        field(240; PaidAmountCurrencyId; Integer)
        {
            Caption = 'PaidAmountCurrencyId';
        }
        field(250; IsReversal; Boolean)
        {
            Caption = 'IsReversal';
        }
        field(260; ReversalInvoiceId; Integer)
        {
            Caption = 'ReversalInvoiceId';
        }
        field(270; DraftedOn; DateTime)
        {
            Caption = 'DraftedOn';
        }
        field(280; ApprovedOn; DateTime)
        {
            Caption = 'ApprovedOn';
        }
        field(290; IsMultipleInvoice; Boolean)
        {
            Caption = 'IsMultipleInvoice';
        }
        field(300; PaymentTermId; Integer)
        {
            Caption = 'PaymentTermId';
        }
        field(310; PPLBankAccountId; Integer)
        {
            Caption = 'PPLBankAccountId';
        }
        field(320; LiveApplicationSourceId; Integer)
        {
            Caption = 'LiveApplicationSourceId';
        }
        field(330; Reference; Text[250])
        {
            Caption = 'Reference';
        }
        field(340; BuyingCompanyId; Integer)
        {
            Caption = 'BuyingCompanyId';
        }
        field(350; OfficeId; Integer)
        {
            Caption = 'OfficeId';
        }
        field(351; EnquiryNumber; Integer)
        {
            Caption = 'EnquiryNumber';
        }
        field(600; MWBuyingCompanyId; Integer)
        {
            Caption = 'MWBuyingCompanyId';
        }
        Field(1000; TransactionBatchId; integer)
        {
            Caption = 'TransactionBatchId';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        field(50001; Processed; Integer)
        {
            Caption = 'Processed';
        }
        field(50002; ProcessedDateTime; DateTime)
        {
            Caption = 'ProcessedDateTime';
        }
        field(50003; ErrorMessage; Text[250])
        {
            Caption = 'ErrorMessage';
        }
        field(50004; ErrorDateTime; DateTime)
        {
            Caption = 'ErrorDateTime';
        }
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(95000; "Error Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(PTAEnquiryError where(EntityType = filter(CustomerInvoice | CustomerInvoiceProducts | CustomerInvoiceAdditionalCosts | CustomerInvoiceAddServ), EnquiryID = field(id), BatchID = field(TransactionBatchId)));
            Editable = false;
            Caption = 'Error Exists';
        }
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
        key(Key2; ID)
        {
        }
        key(EnquiryNumber; EnquiryNumber)
        {
        }
    }

    fieldgroups
    {
    }


    procedure SetStyle(): Text[30]
    begin
        if Rec.Processed = 2 then
            Exit('Unfavorable')
        else
            Exit('')
    end;

    procedure HasVATAmount(): Boolean
    var
        PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;
        PTASetup: Record "PTA Setup";
    begin
        PTASetup.get();
        PTACustomerInvoiceAddServ.Reset();
        PTACustomerInvoiceAddServ.SetAutoCalcFields("Is VAT/GST Service");
        PTACustomerInvoiceAddServ.SetCurrentKey(InvoiceID, TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange(InvoiceID, Rec.ID);
        PTACustomerInvoiceAddServ.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange("Is VAT/GST Service", true);
        EXIT(PTACustomerInvoiceAddServ.FindFirst())
    end;

    procedure GetSellVATAmount(): Decimal
    var
        PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;
        VATAmount: Decimal;
    begin
        VATAmount := 0;
        PTACustomerInvoiceAddServ.Reset();
        PTACustomerInvoiceAddServ.SetAutoCalcFields("Is VAT/GST Service");
        PTACustomerInvoiceAddServ.SetCurrentKey(InvoiceID, TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange(InvoiceID, Rec.ID);
        PTACustomerInvoiceAddServ.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTACustomerInvoiceAddServ.SetRange("Is VAT/GST Service", true);
        if PTACustomerInvoiceAddServ.FindSet() then
            repeat
                VATAmount += PTACustomerInvoiceAddServ.Price;
            Until PTACustomerInvoiceAddServ.next = 0;
        exit(VATAmount);
    end;
}

