table 70015 "PTAVouchers"
{

    DataPerCompany = false;
    DataClassification = CustomerContent;
    DrillDownPageID = "PTAVoucherList";
    LookupPageID = "PTAVoucherList";
    Caption = 'PTA Vouchers';

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }
        field(30; InvoiceNumber; Text[100])
        {
            Caption = 'InvoiceNumber';
        }
        field(40; InvoiceFileName; Text[1000])
        {
            Caption = 'InvoiceFileName';
        }
        field(50; InvoiceDate; DateTime)
        {
            Caption = 'InvoiceDate';
        }
        field(60; DueDate; DateTime)
        {
            Caption = 'DueDate';
        }
        field(70; PaymentTermId; Integer)
        {
            Caption = 'PaymentTermId';
        }
        field(80; TotalInvoiceAmount; Decimal)
        {
            Caption = 'TotalInvoiceAmount';
        }
        field(90; SupplierId; Integer)
        {
            Caption = 'SupplierId';
        }
        field(100; CurrencyId; Integer)
        {
            Caption = 'CurrencyId';
        }

        field(120; PaidAmountPrice; Decimal)
        {
            Caption = 'PaidAmountPrice';
        }
        field(130; PaidAmountCurrencyId; Integer)
        {
            Caption = 'PaidAmountCurrencyId';
        }
        field(140; OnHold; Boolean)
        {
            Caption = 'OnHold';
        }
        field(150; VesselId; Integer)
        {
            Caption = 'VesselId';
        }
        field(160; IsNonDealPurchaseInvoice; Boolean)
        {
            Caption = 'IsNonDealPurchaseInvoice';
        }
        field(170; LiveApplicationSourceId; Integer)
        {
            Caption = 'LiveApplicationSourceId';
        }
        field(180; VesselName; Text[250])
        {
            Caption = 'VesselName';
        }
        field(190; VouchedBy; Integer)
        {
            Caption = 'VouchedBy';
        }
        field(200; VouchedDate; DateTime)
        {
            Caption = 'VouchedDate';
        }
        field(210; IsTemporaryVoucher; Boolean)
        {
            Caption = 'IsTemporaryVoucher';
        }
        field(564; CommissionInvoice; Boolean)
        {
            Caption = 'CommissionInvoice';
        }
        field(570; LateCommissionEntry; Boolean)
        {
            Caption = 'LateCommissionEntry';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        Field(1000; TransactionBatchId; integer)
        {
            Caption = 'TransactionBatchId';
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
        field(50007; BCBuyingCompanyId; Integer)
        {
            CalcFormula = lookup(PTAVoucherEnquiries.MWBuyingCompanyId WHERE(VoucherId = field(ID), TransactionBatchId = FIELD(TransactionBatchId))); //Lookup
            FieldClass = FlowField;
            Editable = false;
        }
        field(95000; "Error Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(PTAEnquiryError where(EntityType = filter(Voucher | VoucherAddServ | VoucherAdditionalCosts | VoucherProducts), EnquiryID = field(id), BatchID = field(TransactionBatchId)));
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
        key(Key2; ID, TransactionBatchId)
        {
        }
    }

    fieldgroups
    {
    }
    procedure HasVATAmount(): Boolean
    var
        PTAVoucherAddServices: Record PTAVoucherAddServices;
        PTASetup: Record "PTA Setup";
    begin
        PTASetup.get();
        PTAVoucherAddServices.Reset();
        PTAVoucherAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddServices.SetRange(VoucherId, Rec.ID);
        PTAVoucherAddServices.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTAVoucherAddServices.SetRange("Is VAT/GST Service", true);
        EXIT(PTAVoucherAddServices.FindFirst())
    end;

    procedure GetSellVATAmount(): Decimal
    var
        PTAVoucherAddServices: Record PTAVoucherAddServices;
        VATAmount: Decimal;
    begin
        VATAmount := 0;
        PTAVoucherAddServices.Reset();
        PTAVoucherAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddServices.SetRange(VoucherId, Rec.ID);
        PTAVoucherAddServices.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTAVoucherAddServices.SetRange("Is VAT/GST Service", true);
        if PTAVoucherAddServices.FindSet() then
            repeat
                VATAmount += PTAVoucherAddServices.Price;
            Until PTAVoucherAddServices.next = 0;
        exit(VATAmount);
    end;
}

