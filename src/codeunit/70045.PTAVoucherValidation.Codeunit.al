codeunit 70045 PTAVoucherValidation
{

    TableNo = PTAVouchers;

    trigger OnRun()
    var
        PTAVouchers: Record PTAVouchers;
    begin
        CompanyInfo.get();
        PTAVouchers := Rec;
        Clear(POList);
        DeletePTAVoucherErrors(PTAVouchers);
        ValidateVoucher(PTAVouchers);
    end;

    procedure ValidateVoucher(var PTAVouchers: Record PTAVouchers)
    var
        PurchaseHeader: Record "Purchase Header";
        PTAEnquiry: Record PTAEnquiry;
        PTAProcessSingleEnquiryRecord: Codeunit PTAEnquiryProcessSingleRecord;
        PTAEnquiryModify: Record PTAEnquiry;
        PTAVoucherEnquiries: Record PTAVoucherEnquiries;

    begin

        isCommissionInv := false;
        GetPTAEnquiryRecordFromVoucher(PTAVouchers, PTAEnquiry, PTAVoucherEnquiries);

        if PTAEnquiry.ID = 0 then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                      PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('No Enquiry found for the Voucher %1', PTAVouchers.InvoiceNumber));

        if PTAEnquiry.CustomerBrokerId <> 0 then
            isCommissionInv := (PTAVouchers.SupplierId = PTAEnquiry.CustomerBrokerId) OR (PTAEnquiry.ID = 0);

        if isCommissionInv then
            CheckComissionLineExists(PTAVouchers, PTAEnquiry);

        if PTAEnquiry.ID <> 0 then begin
            Case PTAEnquiry.Processed of
                0:
                    Error(StrSubstNo('Last Enquiry Status is unprocessed. %1 - %2', PTAEnquiry.id, PTAEnquiry.TransactionBatchId));
                2:
                    Error(StrSubstNo('Last Enquiry Status is in Error. Resolve the error.', PTAEnquiry.id, PTAEnquiry.TransactionBatchId))
            end;

            VoucherAlreadyInvoiced(PTAVouchers, PTAVoucherEnquiries);
            CheckIfPurchaseOrdersExist(PTAVouchers, PTAEnquiry, PurchaseHeader);
            CheckIfSalesInvoicePosted(PTAVouchers, PTAVoucherEnquiries);


            if PTABCMappingtoIndexID.GetVendorCodeFromPTAIndedID(PTAVouchers.SupplierId) = '' then
                PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                   PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Supplier %1 not found', PTAVouchers.SupplierId));

            if (PTAVouchers.CurrencyId <> 0) then begin
                if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAVouchers.CurrencyId) = '' then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                   PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Currency %1 not found', PTAVouchers.ID));

                if PTAVouchers.CurrencyId <> CompanyInfo."PTA Base Currency ID" then
                    if PurchaseHeader."Currency Code" <> PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTAVouchers.CurrencyId) then
                        PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                       PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Currency on Voucher different than Order', PTAVouchers.ID));
            end;
            ValidateLineDetails(PTAVouchers, PTAEnquiry);
            // if ((PTAEnquiry.HasVATAmount() AND (Not PTAVouchers.HasVATAmount())) OR ((Not PTAEnquiry.HasVATAmount()) AND PTAVouchers.HasVATAmount())) then
            //     PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
            //        PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('VAT Exists in Enquiry and not on Voucher or vice versa', PTAVouchers.ID));
        end;

        if POList.Count > 1 then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Multiple Purchase orders on Voucher', PTAVouchers.ID));

        Commit();
        PTAVouchers.Calcfields("Error Exists");
        if PTAVouchers."Error Exists" then
            Error('Errors validating Voucher %1, Check Voucher Card for details', PTAVouchers.ID);
    end;

    local procedure ValidateLineDetails(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    begin
        SetProductCodesOnLines(PTAVouchers, PTAEnquiry);
        CheckVoucherProducts(PTAVouchers, PTAEnquiry);
        CheckVoucherCosts(PTAVouchers, PTAEnquiry);
        CheckVoucherServices(PTAVouchers, PTAEnquiry);
    end;

    local procedure CheckVoucherProducts(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PTAVouchersProducts: Record PTAVoucherProducts;
        PurchaseLine: Record "Purchase Line";
        UnitFactor: Decimal;
    begin
        PTAVouchersProducts.Reset();
        PTAVouchersProducts.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVouchersProducts.SetRange(VoucherId, PTAVouchers.ID);
        PTAVouchersProducts.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVouchersProducts.FindFirst() then
            repeat
                if PTAEnquiryFunctions.CheckPTAPurchaseLineDoesNotExist(Enum::"PTA Enquiry Entities"::Products, PTAVouchersProducts.EnquiryProductId, PTAEnquiry.ID, PurchaseLine) then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::VoucherProducts, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                      PTAVouchers.EntryNo, PTAVouchersProducts.EntryNo, StrSubstNo('Voucher Product not found on Purchase Order', PTAVouchers.ID))
                else begin
                    PurchaseLine.FindFirst();

                    if Not POList.Contains(PurchaseLine."Document No.") then
                        POList.Add(PurchaseLine."Document No.");

                end;
            until PTAVouchersProducts.Next() = 0;
    end;

    local procedure CheckVoucherCosts(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PTAVoucherAddCost: Record PTAVoucherAddCost;
        PurchaseLine: Record "Purchase Line";
        UnitFactor: Decimal;
    begin
        PTAVoucherAddCost.Reset();
        PTAVoucherAddCost.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddCost.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddCost.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherAddCost.FindFirst() then
            repeat
                if PTAEnquiryFunctions.CheckPTAPurchaseLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAVoucherAddCost.EnquiryAdditionalCostId, PTAEnquiry.ID, PurchaseLine) then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::VoucherAdditionalCosts, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                      PTAVouchers.EntryNo, PTAVoucherAddCost.EntryNo, StrSubstNo('Cost %1 not found on Purchase Order', PTAVoucherAddCost.EnquiryAdditionalCostId))
                else begin
                    PurchaseLine.FindFirst();
                    if Not POList.Contains(PurchaseLine."Document No.") then
                        POList.Add(PurchaseLine."Document No.");
                end;

            until PTAVoucherAddCost.Next() = 0;
    end;

    local procedure CheckVoucherServices(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PTAVoucherAddServices: Record PTAVoucherAddServices;
        PurchaseLine: Record "Purchase Line";
        UnitFactor: Decimal;
    begin
        PTAVoucherAddServices.Reset();
        PTAVoucherAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddServices.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddServices.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        PTAVoucherAddServices.SetRange("Is VAT/GST Service", false);
        if PTAVoucherAddServices.FindFirst() then
            repeat
                if PTAEnquiryFunctions.CheckPTAPurchaseLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalServices, PTAVoucherAddServices.EnquiryAdditionalServiceId, PTAEnquiry.ID, PurchaseLine) then
                    PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::VoucherAddServ, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                      PTAVouchers.EntryNo, PTAVoucherAddServices.EntryNo, StrSubstNo('Service not found on Purchase Order', PTAVouchers.ID))
                else begin
                    PurchaseLine.FindFirst();

                    if Not POList.Contains(PurchaseLine."Document No.") then
                        POList.Add(PurchaseLine."Document No.");
                end;
            until PTAVoucherAddServices.Next() = 0;
    end;

    local procedure VoucherAlreadyInvoiced(PTAVouchers: Record PTAVouchers; PTAVoucherEnquiries: Record PTAVoucherEnquiries): Boolean
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PTAVoucherEnquiries.calcfields("Enquiry Number");
        PurchInvHeader.reset;
        PurchInvHeader.setrange("Vendor Invoice No.", PTAVouchers.InvoiceNumber);
        if PurchInvHeader.FindFirst() then begin
            if Not isCommissionInv then
                PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                       PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Invoice %1 already exists for this voucher.', PurchInvHeader."No."));
        end;

        if PTAVoucherEnquiries.EnquiryId <> 0 then begin
            PurchInvHeader.setfilter("Vendor Invoice No.", PTAVouchers.InvoiceNumber + '/' + FORMAT(PTAVoucherEnquiries."Enquiry Number"));
            if PurchInvHeader.FindFirst() then begin
                if Not isCommissionInv then
                    Error(StrSubstNo('Invoice %1 already exists for this voucher and Enquiy %2', PurchInvHeader."No.", FORMAT(PTAVoucherEnquiries."Enquiry Number")));
            end;
        end;
    end;

    procedure GetPTAEnquiryRecordFromVoucher(PTAVouchers: Record PTAVouchers; var PTAEnquiry: Record PTAEnquiry; var PTAVoucherEnquiries: Record PTAVoucherEnquiries)
    begin
        PTAVoucherEnquiries.reset;
        PTAVoucherEnquiries.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherEnquiries.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherEnquiries.FindLast() then begin
            if PTAVoucherEnquiries.EnquiryId <> 0 then begin
                PTAEnquiry.reset;
                PTAEnquiry.SetCurrentKey(Id, TransactionBatchId);
                PTAEnquiry.SetRange(ID, PTAVoucherEnquiries.EnquiryId);
                if not PTAEnquiry.FindLast() then
                    PTAEnquiry.init
            end else
                PTAEnquiry.Init();
        end else begin
            PTAEnquiry.Init();
            PTAVoucherEnquiries.Init();
        end;
    end;

    local procedure DeletePTAVoucherErrors(PTAVouchers: Record PTAVouchers)
    var
        PTAEnquiryError: Record PTAEnquiryError;
    begin
        PTAEnquiryError.Reset();
        PTAEnquiryError.setfilter(EntityType, '%1|%2|%3|%4', PTAEnquiryError.EntityType::Voucher, PTAEnquiryError.EntityType::VoucherAddServ,
                pTAEnquiryError.EntityType::VoucherAdditionalCosts, PTAEnquiryError.EntityType::VoucherProducts);
        PTAEnquiryError.SetRange(EnquiryID, PTAVouchers.ID);
        PTAEnquiryError.SetRange(BatchID, PTAVouchers.TransactionBatchId);
        PTAEnquiryError.SetRange(HeaderEntryNo, PTAVouchers.EntryNo);
        PTAEnquiryError.Deleteall();
    end;

    local procedure CheckIfSalesInvoicePosted(PTAVouchers: Record PTAVouchers; PTAVoucherEnquiries: Record PTAVoucherEnquiries)
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if PTAVoucherEnquiries.EnquiryId = 0 then exit;

        SalesInvoiceHeader.reset;
        SalesInvoiceHeader.SetCurrentKey("PTA Enquiry ID");
        SalesInvoiceHeader.SetRange("PTA Enquiry ID", PTAVoucherEnquiries.EnquiryId);
        if SalesInvoiceHeader.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                   PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Sales Invoice not posted for Enquiry %1', PTAVoucherEnquiries.EnquiryId));
    end;

    local procedure CheckIfPurchaseOrdersExist(var PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry; var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.reset;
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        purchaseheader.SetRange("PTA Enquiry ID", PTAEnquiry.ID);
        purchaseheader.setrange("PTA Vendor ID", PTAVouchers.SupplierId);
        purchaseheader.setrange("PTA Purch. Currency ID", PTAVouchers.CurrencyId);
        if PurchaseHeader.IsEmpty then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                   PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Purchase Order not found for Enquiry %1', PTAEnquiry.ID))
        else
            PurchaseHeader.FindFirst();
    end;

    local procedure CheckComissionLineExists(var PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.reset;
        PurchaseLine.SetCurrentKey("PTA Enquiry ID", "PTA Line Entity Type", "PTA Linked Deal ID");
        PurchaseLine.SetRange("PTA Enquiry ID", PTAEnquiry.ID);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.setrange("PTA CustomerBrokerComm Line", true);
        if not PurchaseLine.FindFirst() then
            PTAEnquiryFunctions.InsertEnquiryErrorLogEntry(Enum::"PTA Enquiry Entities"::Voucher, PTAVouchers.ID, PTAVouchers.TransactionBatchId,
                   PTAVouchers.EntryNo, PTAVouchers.EntryNo, StrSubstNo('Commission Line not found for Enquiry %1', PTAEnquiry.ID));
    end;

    local procedure SetProductCodesOnLines(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PTAVoucherProducts: Record PTAVoucherProducts;
        PTAVoucherAddServices: Record PTAVoucherAddServices;
    begin
        PTAVoucherProducts.Reset();
        PTAVoucherProducts.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherProducts.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherProducts.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherProducts.FindFirst() then
            repeat
                PTAVoucherProducts.ProductID := PTAEnquiryFunctions.GetEnquiryProductId(PTAEnquiry.id, enum::"PTA Enquiry Entities"::Products, PTAVoucherProducts.EnquiryProductId);
                PTAVoucherProducts.Modify();
            until PTAVoucherProducts.Next() = 0;

        PTAVoucherAddServices.Reset();
        PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddServices.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddServices.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherAddServices.FindFirst() then
            repeat
                PTAVoucherAddServices.ProductID := PTAEnquiryFunctions.GetEnquiryProductId(PTAEnquiry.id, enum::"PTA Enquiry Entities"::AdditionalServices, PTAVoucherAddServices.EnquiryAdditionalServiceId);
                PTAVoucherAddServices.Modify();
            until PTAVoucherAddServices.Next() = 0;
    end;

    var
        isCommissionInv: Boolean;
        MktgSetup: Record "Marketing Setup";
        PTASetup: Record "PTA Setup";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;

        PurchInvHeader: Record "Purch. Inv. Header";
        CompanyInfo: Record "Company Information";
        POList: List of [Code[20]];

}