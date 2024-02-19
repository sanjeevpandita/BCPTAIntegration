codeunit 70026 PTAEnquiryFunctions
{
    procedure EnquiryExists(EnquiryNumber: Code[20]): Boolean
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesHeader: Record "Sales Header";
    begin
        exit(SalesHeader.get(SalesHeader."Document Type"::Order, format(EnquiryNumber)));
    end;

    procedure CheckPTASalesLineDoesNotExist(PTAEnquiryEntities: Enum "PTA Enquiry Entities"; EntityID: Integer; EnquiryNumber: Code[20]; var SalesLine: Record "Sales Line"): Boolean
    begin
        SalesLine.reset;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", EnquiryNumber);
        SalesLine.setrange("PTA Line Entity Type", PTAEnquiryEntities);
        SalesLine.SetRange("PTA Line Entity ID", EntityID);
        Exit(SalesLine.IsEmpty)
    end;

    procedure CheckPTAPurchaseLineDoesNotExist(PTAEnquiryEntities: Enum "PTA Enquiry Entities"; EntityID: Integer; EnquiryID: Integer; var PurchaseLine: Record "Purchase Line"): Boolean
    begin
        PurchaseLine.reset;
        PurchaseLine.SetCurrentKey("PTA Enquiry ID", "PTA Line Entity Type", "PTA Linked Deal ID");
        PurchaseLine.SetRange("PTA Enquiry ID", EnquiryID);
        PurchaseLine.setrange("PTA Line Entity Type", PTAEnquiryEntities);
        PurchaseLine.SetRange("PTA Line Entity ID", EntityID);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        Exit(PurchaseLine.IsEmpty)
    end;

    procedure InsertEnquiryErrorLogEntry(EntityType: Enum "PTA Enquiry Entities"; EnquiryID: Integer;
                   BatchID: Integer; HeaderEntryRecordyNo: Integer; EntryRecordyNo: Integer; VarErrorDescription: Text)
    var
        PTAEnquiryError: Record PTAEnquiryError;
    begin
        PTAEnquiryError.Init();
        PTAEnquiryError.EntryNo := 0;
        PTAEnquiryError.EntityType := EntityType;
        PTAEnquiryError.EnquiryID := EnquiryID;
        PTAEnquiryError.BatchID := BatchID;
        PTAEnquiryError.RecordEntryNo := EntryRecordyNo;
        PTAEnquiryError.ErrorDescription := VarErrorDescription;
        PTAEnquiryError.HeaderEntryNo := HeaderEntryRecordyNo;
        PTAEnquiryError.insert(true);
    end;

    procedure DeleteAllRelatedPOsWithSalesOrder(PTAEnquiry: Record PTAEnquiry; Salesheader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PoList: List of [Code[20]];
        PoCode: Code[20];
    begin
        Clear(PoList);
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.setrange("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER("PTA Related PO", '<>%1', '');
        if SalesLine.findset(true) then Begin
            repeat
                PurchaseHeader.get(PurchaseHeader."Document Type"::Order, SalesLine."PTA Related PO");
                if PurchaseHeader.Status <> PurchaseHeader.status::Open then
                    ReleasePurchaseDocument.Reopen(PurchaseHeader);

                if not PoList.contains(PurchaseHeader."No.") then
                    PoList.Add(PurchaseHeader."No.");

            until SalesLine.next = 0;

            if PoList.Count > 0 then begin
                foreach PoCode in PoList DO begin
                    PurchaseHeader.get(PurchaseHeader."Document Type"::Order, PoCode);
                    PurchaseHeader.Delete(true);
                end;
            end;
        end;

    end;

    internal procedure GetPreviousBatchPTAEnquiry(PTAEnquiry: Record PTAEnquiry; var PreviousPTAEnquiry: Record PTAEnquiry)
    begin
        PreviousPTAEnquiry.ReadIsolation := PreviousPTAEnquiry.ReadIsolation::ReadCommitted;
        PreviousPTAEnquiry.Reset();
        PreviousPTAEnquiry.SetCurrentKey(ID, TransactionBatchId);
        PreviousPTAEnquiry.SetRange(ID, PTAEnquiry.ID);
        PreviousPTAEnquiry.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAEnquiry.ID, PTAEnquiry.TransactionBatchId, Database::PTAEnquiry));
        PreviousPTAEnquiry.SetRange(Processed, 1);
        if Not PreviousPTAEnquiry.FindLast() then
            PreviousPTAEnquiry.Init();
    end;

    internal procedure GetPreviousBatchPTAEnquiryProductByID(PTAEnquiryProducts: Record PTAEnquiryProducts; var PreviousPTAEnquiryProducts: Record PTAEnquiryProducts; SearchID: Integer)
    begin
        PreviousPTAEnquiryProducts.ReadIsolation := PreviousPTAEnquiryProducts.ReadIsolation::ReadCommitted;
        PreviousPTAEnquiryProducts.Reset();
        PreviousPTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PreviousPTAEnquiryProducts.SetRange(EnquiryId, PTAEnquiryProducts.EnquiryId);
        PreviousPTAEnquiryProducts.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAEnquiryProducts.EnquiryId, PTAEnquiryProducts.TransactionBatchId, Database::PTAEnquiryProducts));
        if SearchID <> 0 then
            PreviousPTAEnquiryProducts.SetRange(ID, SearchID);
        if Not PreviousPTAEnquiryProducts.FindLast() then
            PreviousPTAEnquiryProducts.Init();
    end;

    internal procedure GetPreviousBatchPTAEnquiryAdditionalCostByID(PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; var PreviousPTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost; SearchID: Integer)
    begin
        PreviousPTAEnquiryAdditionalCost.ReadIsolation := PreviousPTAEnquiryAdditionalCost.ReadIsolation::ReadCommitted;
        PreviousPTAEnquiryAdditionalCost.Reset();
        PreviousPTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PreviousPTAEnquiryAdditionalCost.SetRange(EnquiryId, PTAEnquiryAdditionalCost.EnquiryId);
        PreviousPTAEnquiryAdditionalCost.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAEnquiryAdditionalCost.EnquiryId, PTAEnquiryAdditionalCost.TransactionBatchId, Database::PTAEnquiryAdditionalCost));
        if SearchID <> 0 then
            PreviousPTAEnquiryAdditionalCost.SetRange(ID, SearchID);
        if Not PreviousPTAEnquiryAdditionalCost.FindLast() then
            PreviousPTAEnquiryAdditionalCost.Init();
    end;

    internal procedure GetPreviousBatchPTAEnquiryServiceByID(PTAEnquiryAddServices: Record PTAEnquiryAddServices; var PreviousPTAEnquiryAddServices: Record PTAEnquiryAddServices; SearchID: Integer)
    begin
        PreviousPTAEnquiryAddServices.ReadIsolation := PreviousPTAEnquiryAddServices.ReadIsolation::ReadCommitted;
        PreviousPTAEnquiryAddServices.Reset();
        PreviousPTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PreviousPTAEnquiryAddServices.SetRange(EnquiryId, PTAEnquiryAddServices.EnquiryId);
        PreviousPTAEnquiryAddServices.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAEnquiryAddServices.EnquiryID, PTAEnquiryAddServices.TransactionBatchId, Database::PTAEnquiryAddServices));
        if SearchID <> 0 then
            PreviousPTAEnquiryAddServices.SetRange(ID, SearchID);
        if Not PreviousPTAEnquiryAddServices.FindLast() then
            PreviousPTAEnquiryAddServices.Init();
    end;


    internal procedure GetPreviousBatchPTACustomerInvoice(PTACustomerInvoices: Record PTACustomerInvoices; var PreviousPTACustomerInvoices: Record PTACustomerInvoices)
    begin
        PreviousPTACustomerInvoices.ReadIsolation := PreviousPTACustomerInvoices.ReadIsolation::ReadCommitted;
        PreviousPTACustomerInvoices.Reset();
        PreviousPTACustomerInvoices.SetCurrentKey(ID, TransactionBatchId);
        PreviousPTACustomerInvoices.SetRange(ID, PTACustomerInvoices.ID);
        PreviousPTACustomerInvoices.setrange(TransactionBatchId, GetLastTransactonBatchID(PTACustomerInvoices.Id, PTACustomerInvoices.TransactionBatchId, Database::PTACustomerInvoices));
        if Not PreviousPTACustomerInvoices.FindLast() then
            PreviousPTACustomerInvoices.Init();
    end;

    internal procedure GetPreviousBatchCustomerInvoiceProductByID(PTACustomerInvoiceProducts: Record PTACustomerInvoiceProducts; var PreviousPTACustomerInvoiceProducts: Record PTACustomerInvoiceProducts; SearchID: Integer)
    begin
        PreviousPTACustomerInvoiceProducts.ReadIsolation := PreviousPTACustomerInvoiceProducts.ReadIsolation::ReadCommitted;
        PreviousPTACustomerInvoiceProducts.Reset();
        PreviousPTACustomerInvoiceProducts.SetCurrentKey(CustomerInvoiceId, TransactionBatchId);
        PreviousPTACustomerInvoiceProducts.SetRange(CustomerInvoiceId, PTACustomerInvoiceProducts.CustomerInvoiceId);
        PreviousPTACustomerInvoiceProducts.setrange(TransactionBatchId, GetLastTransactonBatchID(PTACustomerInvoiceProducts.CustomerInvoiceId, PTACustomerInvoiceProducts.TransactionBatchId, Database::PTACustomerInvoiceProducts));
        if SearchID <> 0 then
            PreviousPTACustomerInvoiceProducts.SetRange(ID, SearchID);
        if Not PreviousPTACustomerInvoiceProducts.FindLast() then
            PreviousPTACustomerInvoiceProducts.Init();
    end;

    internal procedure GetPreviousBatchCustomerInvoiceAdditionalCostByID(PTACustomerInvoiceAddCost: Record PTACustomerInvoiceAddCost; var PreviousPTACustomerInvoiceAddCost: Record PTACustomerInvoiceAddCost; SearchID: Integer)
    begin
        PreviousPTACustomerInvoiceAddCost.ReadIsolation := PreviousPTACustomerInvoiceAddCost.ReadIsolation::ReadCommitted;
        PreviousPTACustomerInvoiceAddCost.Reset();
        PreviousPTACustomerInvoiceAddCost.SetCurrentKey(InvoiceId, TransactionBatchId);
        PreviousPTACustomerInvoiceAddCost.SetRange(InvoiceId, PTACustomerInvoiceAddCost.InvoiceId);
        PreviousPTACustomerInvoiceAddCost.setrange(TransactionBatchId, GetLastTransactonBatchID(PTACustomerInvoiceAddCost.InvoiceId, PTACustomerInvoiceAddCost.TransactionBatchId, Database::PTACustomerInvoiceAddCost));
        if SearchID <> 0 then
            PreviousPTACustomerInvoiceAddCost.SetRange(ID, SearchID);
        if Not PreviousPTACustomerInvoiceAddCost.FindLast() then
            PreviousPTACustomerInvoiceAddCost.Init();
    end;

    internal procedure GetPreviousBatchCustomerInvoiceServiceByID(PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ; var PreviousPTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ; SearchID: Integer)
    begin
        PreviousPTACustomerInvoiceAddServ.ReadIsolation := PreviousPTACustomerInvoiceAddServ.ReadIsolation::ReadCommitted;
        PreviousPTACustomerInvoiceAddServ.Reset();
        PreviousPTACustomerInvoiceAddServ.SetCurrentKey(InvoiceId, TransactionBatchId);
        PreviousPTACustomerInvoiceAddServ.SetRange(InvoiceId, PTACustomerInvoiceAddServ.InvoiceId);
        PreviousPTACustomerInvoiceAddServ.setrange(TransactionBatchId, GetLastTransactonBatchID(PTACustomerInvoiceAddServ.InvoiceId, PTACustomerInvoiceAddServ.TransactionBatchId, Database::PTACustomerInvoiceAddServ));
        if SearchID <> 0 then
            PreviousPTACustomerInvoiceAddServ.SetRange(ID, SearchID);
        if Not PreviousPTACustomerInvoiceAddServ.FindLast() then
            PreviousPTACustomerInvoiceAddServ.Init();
    end;

    internal procedure GetPreviousBatchPTAVoucher(PTAVouchers: Record PTAVouchers; var PreviousPTAVouchers: Record PTAVouchers)
    begin
        PreviousPTAVouchers.ReadIsolation := PreviousPTAVouchers.ReadIsolation::ReadCommitted;
        PreviousPTAVouchers.Reset();
        PreviousPTAVouchers.SetCurrentKey(ID, TransactionBatchId);
        PreviousPTAVouchers.SetRange(ID, PTAVouchers.ID);
        PreviousPTAVouchers.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAVouchers.Id, PTAVouchers.TransactionBatchId, Database::PTAVouchers));
        if Not PreviousPTAVouchers.FindLast() then
            PreviousPTAVouchers.Init();
    end;

    internal procedure GetPreviousBatchVoucherProductByID(PTAVoucherProducts: Record PTAVoucherProducts; var PreviousPTAVoucherProducts: Record PTAVoucherProducts; SearchID: Integer)
    begin
        PreviousPTAVoucherProducts.ReadIsolation := PreviousPTAVoucherProducts.ReadIsolation::ReadCommitted;
        PreviousPTAVoucherProducts.Reset();
        PreviousPTAVoucherProducts.SetCurrentKey(VoucherId, TransactionBatchId);
        PreviousPTAVoucherProducts.SetRange(VoucherId, PTAVoucherProducts.VoucherId);
        PreviousPTAVoucherProducts.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAVoucherProducts.VoucherId, PTAVoucherProducts.TransactionBatchId, Database::PTAVoucherProducts));
        if SearchID <> 0 then
            PreviousPTAVoucherProducts.SetRange(ID, SearchID);
        if Not PreviousPTAVoucherProducts.FindLast() then
            PreviousPTAVoucherProducts.Init();
    end;

    internal procedure GetPreviousBatchVoucherAdditionalCostByID(PTAVoucherAddCost: Record PTAVoucherAddCost; var PreviousPTAVoucherAddCost: Record PTAVoucherAddCost; SearchID: Integer)
    begin
        PreviousPTAVoucherAddCost.ReadIsolation := PreviousPTAVoucherAddCost.ReadIsolation::ReadCommitted;
        PreviousPTAVoucherAddCost.Reset();
        PreviousPTAVoucherAddCost.SetCurrentKey(VoucherId, TransactionBatchId);
        PreviousPTAVoucherAddCost.SetRange(VoucherId, PTAVoucherAddCost.VoucherId);
        PreviousPTAVoucherAddCost.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAVoucherAddCost.VoucherId, PTAVoucherAddCost.TransactionBatchId, Database::PTAVoucherAddCost));
        if SearchID <> 0 then
            PreviousPTAVoucherAddCost.SetRange(ID, SearchID);
        if Not PreviousPTAVoucherAddCost.FindLast() then
            PreviousPTAVoucherAddCost.Init();
    end;

    internal procedure GetPreviousBatchVoucherServiceByID(PTAVoucherAddServices: Record PTAVoucherAddServices; var PreviousPTAVoucherAddServices: Record PTAVoucherAddServices; SearchID: Integer)
    begin
        PreviousPTAVoucherAddServices.ReadIsolation := PreviousPTAVoucherAddServices.ReadIsolation::ReadCommitted;
        PreviousPTAVoucherAddServices.Reset();
        PreviousPTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PreviousPTAVoucherAddServices.SetRange(VoucherId, PTAVoucherAddServices.VoucherId);
        PreviousPTAVoucherAddServices.setrange(TransactionBatchId, GetLastTransactonBatchID(PTAVoucherAddServices.VoucherId, PTAVoucherAddServices.TransactionBatchId, Database::PTAVoucherAddCost));

        if SearchID <> 0 then
            PreviousPTAVoucherAddServices.SetRange(ID, SearchID);
        if Not PreviousPTAVoucherAddServices.FindLast() then
            PreviousPTAVoucherAddServices.Init();
    end;

    internal procedure GetCurrencyCodeFromEnquiry(PTAEnquiry: Record PTAEnquiry): code[20]
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryProducts.FindFirst() then begin
            exit(PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAEnquiryProducts.SellCurrencyId))
        end;
    end;

    procedure GetQuantityUnitFactor(ItemNo: Code[20]; UnitID: Integer; DeliveryDensity: Decimal): Decimal
    var
        UnitOfMeasure: Record "Unit of Measure";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        Item: Record Item;
    begin
        IF (UnitID <> 1) THEN begin
            Item.get(ItemNo);
            UnitOfMeasure.get(PTABCMappingtoIndexID.GetUnitOfMeasureCodeByPTAIndex(UnitID));
            if UnitOfMeasure."PTA ConversionFactor" = 0 then UnitOfMeasure."PTA ConversionFactor" := 1;

            if DeliveryDensity = 0 then
                DeliveryDensity := Item."PTA Density";

            Exit(DeliveryDensity / UnitOfMeasure."PTA ConversionFactor");
        end else
            Exit(1);
    end;

    procedure UnparkSalesOrders(var Salesheader: Record "Sales Header")
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ModifySalesHeader: Record "Sales Header";
        Counter: Integer;
    begin
        if Not ConfirmManagement.GetResponseOrDefault('Do you want to UnPark the selected Invoices ?', false) then exit;
        Counter := 0;
        Salesheader.SetRange("PTA Parked", TRUE);
        Salesheader.SetFilter("Posting No.", '<>%1', '');
        if Salesheader.FindSet(true) then
            repeat
                ModifySalesHeader := Salesheader;
                ModifySalesHeader.validate("PTA UnParked", true);
                ModifySalesHeader."PTA Parked" := false;
                ModifySalesHeader.Modify();
                Counter += 1;
            until Salesheader.Next() = 0;

        Message('%1 Sales Orders Unparked', Counter);
    end;

    procedure ParkSalesOrders(var Salesheader: Record "Sales Header")
    var
        ConfirmManagement: Codeunit "Confirm Management";
        ModifySalesHeader: Record "Sales Header";
        Counter: Integer;

    begin
        if Not ConfirmManagement.GetResponseOrDefault('Do you want to Park the selected Invoices ?', false) then exit;
        Counter := 0;

        Salesheader.SetRange("PTA UnParked", TRUE);
        Salesheader.SetFilter("Posting No.", '<>%1', '');
        if Salesheader.FindSet(true) then
            repeat
                ModifySalesHeader := Salesheader;
                ModifySalesHeader.validate("PTA Parked", true);
                ModifySalesHeader."PTA UnParked" := False;
                ModifySalesHeader."PTA UnParked By" := '';
                ModifySalesHeader."PTA UnParked DateTime" := 0DT;
                ModifySalesHeader.Modify();
                Counter += 1;
            until Salesheader.Next() = 0;
        Message('%1 Sales Orders Parked', Counter);
    end;

    procedure CheckCustomerAccountExits(PTAEnquiry: Record PTAEnquiry)
    var
        // Contact: Record Contact;
        // ContactBusinessRelation: Record "Contact Business Relation";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        // MktgSetup: Record "Marketing Setup";
        Customer: Record Customer;
    begin
        // MktgSetup.get;
        // Contact.reset;
        // Contact.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        // Contact.SetRange("PTA IsDeleted", false);
        // if PTAEnquiry.BusinessAreaId = 2 then begin
        //     Contact.SETRANGE("PTA Index Link", PTAEnquiry.SupplierId);
        //     if Contact.IsEmpty then begin
        //         PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
        //             PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Customer Counterparty ID %1 not found', PTAEnquiry.SupplierId));
        //         exit;
        //     end;
        // end else begin
        //     Contact.SETRANGE("PTA Index Link", PTAEnquiry.CustomerId);
        //     if Contact.IsEmpty then begin
        //         PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
        //             PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Customer Counterparty ID %1 not found', PTAEnquiry.CustomerId));
        //         exit;
        //     end;
        // end;
        // Contact.FindFirst();
        // IF NOT ContactBusinessRelation.GET(Contact."No.", MktgSetup."Bus. Rel. Code for Customers") THEN
        Customer.reset;
        customer.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        if PTAEnquiry.BusinessAreaId = 2 then
            Customer.SetRange("PTA Index Link", PTAEnquiry.SupplierId)
        else
            Customer.SetRange("PTA Index Link", PTAEnquiry.CustomerId);
        Customer.SetRange("PTA IsDeleted", false);
        if Customer.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Customer ID %1 not found', PTAEnquiry.CustomerId));
    end;

    procedure CheckVendorAccountExits(PTAEnquiry: Record PTAEnquiry; SupplierId: Integer)
    var
        // Contact: Record Contact;
        // ContactBusinessRelation: Record "Contact Business Relation";
        // PTAProcessCounterparties: Codeunit PTAProcessCounterparties;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        // MktgSetup: Record "Marketing Setup";
        Vendor: Record Vendor;
    begin
        // MktgSetup.get;
        // Contact.reset;
        // Contact.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        // Contact.SetRange("PTA IsDeleted", false);
        // Contact.SETRANGE("PTA Index Link", SupplierId);
        Vendor.reset;
        vendor.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Vendor.SetRange("PTA Index Link", SupplierId);
        Vendor.SetRange("PTA IsDeleted", false);
        if Vendor.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Enquiries, PTAEnquiry.ID, PTAEnquiry.TransactionBatchId,
                PTAEnquiry.EntryNo, PTAEnquiry.EntryNo, StrSubstNo('Supplier Counterparty ID %1 not found', SupplierId));
        exit;
        // end;
        // Contact.FindFirst();

        // IF NOT ContactBusinessRelation.GET(Contact."No.", MktgSetup."Bus. Rel. Code for Vendors") THEN
        //     PTAProcessCounterparties.ConvertContactToVendor(Contact);
    end;

    procedure GetLastTransactonBatchID(VarEnquiryID: Integer; VarTransactionBatchID: Integer; TableNo: Integer): Integer
    var
        PTAEnquiry: Record PTAEnquiry;
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;

        PTACustomerInvoices: Record PTACustomerInvoices;
        PTACustomerInvoiceProducts: Record PTACustomerInvoiceProducts;
        PTACustomerInvoiceAddCost: Record PTACustomerInvoiceAddCost;
        PTACustomerInvoiceAddServ: Record PTACustomerInvoiceAddServ;

        PTAVouchers: Record PTAVouchers;
        PTAVoucherProducts: Record PTAVoucherProducts;
        PTAVoucherAddCost: Record PTAVoucherAddCost;
        PTAVoucherAddServices: Record PTAVoucherAddServices;
    begin
        Case TableNo of
            Database::PTAEnquiry:
                begin
                    PTAEnquiry.Reset();
                    PTAEnquiry.SetCurrentKey(ID, TransactionBatchId);
                    PTAEnquiry.SetRange(ID, VarEnquiryID);
                    PTAEnquiry.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAEnquiry.FindLast() then
                        exit(PTAEnquiry.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTAEnquiryProducts:
                begin
                    PTAEnquiryProducts.Reset();
                    PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
                    PTAEnquiryProducts.SetRange(EnquiryId, VarEnquiryID);
                    PTAEnquiryProducts.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAEnquiryProducts.FindLast() then
                        exit(PTAEnquiryProducts.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTAEnquiryAdditionalCost:
                begin
                    PTAEnquiryAdditionalCost.Reset();
                    PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
                    PTAEnquiryAdditionalCost.SetRange(EnquiryId, VarEnquiryID);
                    PTAEnquiryAdditionalCost.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAEnquiryAdditionalCost.FindLast() then
                        exit(PTAEnquiryAdditionalCost.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTAEnquiryAddServices:
                begin
                    PTAEnquiryAddServices.Reset();
                    PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
                    PTAEnquiryAddServices.SetRange(EnquiryId, VarEnquiryID);
                    PTAEnquiryAddServices.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAEnquiryAddServices.FindLast() then
                        exit(PTAEnquiryAddServices.TransactionBatchId)
                    else
                        Exit(0);
                end;

            Database::PTACustomerInvoices:
                begin
                    PTACustomerInvoices.Reset();
                    PTACustomerInvoices.SetCurrentKey(ID, TransactionBatchId);
                    PTACustomerInvoices.SetRange(ID, VarEnquiryID);
                    PTACustomerInvoices.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTACustomerInvoices.FindLast() then
                        exit(PTACustomerInvoices.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTACustomerInvoiceProducts:
                begin
                    PTACustomerInvoiceProducts.Reset();
                    PTACustomerInvoiceProducts.SetCurrentKey(CustomerInvoiceId, TransactionBatchId);
                    PTACustomerInvoiceProducts.SetRange(CustomerInvoiceId, VarEnquiryID);
                    PTACustomerInvoiceProducts.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTACustomerInvoiceProducts.FindLast() then
                        exit(PTACustomerInvoiceProducts.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTACustomerInvoiceAddCost:
                begin
                    PTACustomerInvoiceAddCost.Reset();
                    PTACustomerInvoiceAddCost.SetCurrentKey(InvoiceId, TransactionBatchId);
                    PTACustomerInvoiceAddCost.SetRange(InvoiceId, VarEnquiryID);
                    PTACustomerInvoiceAddCost.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTACustomerInvoiceAddCost.FindLast() then
                        exit(PTACustomerInvoiceAddCost.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTACustomerInvoiceAddServ:
                begin
                    PTACustomerInvoiceAddServ.Reset();
                    PTACustomerInvoiceAddServ.SetCurrentKey(InvoiceId, TransactionBatchId);
                    PTACustomerInvoiceAddServ.SetRange(InvoiceId, VarEnquiryID);
                    PTACustomerInvoiceAddServ.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTACustomerInvoiceAddServ.FindLast() then
                        exit(PTACustomerInvoiceAddServ.TransactionBatchId)
                    else
                        Exit(0);
                end;

            Database::PTAVouchers:
                begin
                    PTAVouchers.Reset();
                    PTAVouchers.SetCurrentKey(ID, TransactionBatchId);
                    PTAVouchers.SetRange(ID, VarEnquiryID);
                    PTAVouchers.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAVouchers.FindLast() then
                        exit(PTAVouchers.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTAVoucherProducts:
                begin
                    PTAVoucherProducts.Reset();
                    PTAVoucherProducts.SetCurrentKey(VoucherId, TransactionBatchId);
                    PTAVoucherProducts.SetRange(VoucherId, VarEnquiryID);
                    PTAVoucherProducts.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAVoucherProducts.FindLast() then
                        exit(PTAVoucherProducts.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTAVoucherAddCost:
                begin
                    PTAVoucherAddCost.Reset();
                    PTAVoucherAddCost.SetCurrentKey(VoucherId, TransactionBatchId);
                    PTAVoucherAddCost.SetRange(VoucherID, VarEnquiryID);
                    PTAVoucherAddCost.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAVoucherAddCost.FindLast() then
                        exit(PTAVoucherAddCost.TransactionBatchId)
                    else
                        Exit(0);
                end;
            Database::PTAVoucherAddServices:
                begin
                    PTAVoucherAddServices.Reset();
                    PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
                    PTAVoucherAddServices.SetRange(VoucherID, VarEnquiryID);
                    PTAVoucherAddServices.SetFilter(TransactionBatchId, '..%1', VarTransactionBatchID - 1);
                    if PTAVoucherAddServices.FindLast() then
                        exit(PTAVoucherAddServices.TransactionBatchId)
                    else
                        Exit(0);
                end;
        End;
    end;

    procedure RemoveIllegalCharactersInvoiceNumber(InvoiceNumber: Text[50]): Text[50]
    begin
        exit(InvoiceNumber.Replace('(', '').Replace(')', ''));
    end;

    procedure GetEnquiryProductId(EnquiryID: Integer; LineEntityType: Enum "PTA Enquiry Entities"; LineEntityID: Integer): Integer
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
    begin
        case LineEntityType Of
            LineEntityType::Products:
                begin
                    PTAEnquiryProducts.Reset();
                    PTAEnquiryProducts.SetCurrentKey(ID);
                    PTAEnquiryProducts.SetRange(ID, LineEntityID);
                    PTAEnquiryProducts.SetRange(EnquiryId, EnquiryID);
                    if PTAEnquiryProducts.FindFirst() then
                        exit(PTAEnquiryProducts.ProductId)
                    else
                        exit(0);
                end;
            LineEntityType::AdditionalServices:
                begin
                    PTAEnquiryAddServices.Reset();
                    PTAEnquiryAddServices.SetCurrentKey(ID);
                    PTAEnquiryAddServices.SetRange(ID, LineEntityID);
                    PTAEnquiryAddServices.SetRange(EnquiryId, EnquiryID);
                    if PTAEnquiryAddServices.FindFirst() then
                        exit(PTAEnquiryAddServices.ProductId)
                    else
                        exit(0);
                end;
        end;
    end;
}