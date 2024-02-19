
codeunit 70046 PTAVoucherProcessPost
{
    TableNo = PTAVouchers;


    trigger OnRun()
    var
        PTAVouchers: Record PTAVouchers;
        PTAVoucherValidation: Codeunit PTAVoucherValidation;
        PTAEnquiry: Record PTAEnquiry;
        PTAVoucherChangedforBC: Codeunit PTAVoucherChangedforBC;
        PTAVoucherEnquiries: Record PTAVoucherEnquiries;
    begin
        PTAVouchers := rec;
        Clear(POList);

        GetPTASetup();
        PTASetup.TestField("Voucher Tolerace G/L Acc.");

        if not PTAVoucherChangedforBC.PTACheckIfVoucherHasChanged(PTAVouchers) then
            exit;

        if PTAVouchers.LateCommissionEntry then exit;

        isCommissionInv := false;
        PTAVoucherValidation.GetPTAEnquiryRecordFromVoucher(PTAVouchers, PTAEnquiry, PTAVoucherEnquiries);
        if PTAEnquiry.CustomerBrokerId <> 0 then
            isCommissionInv := (PTAVouchers.SupplierId = PTAEnquiry.CustomerBrokerId) OR (PTAEnquiry.ID = 0);
        InitAllPurchaseLineToInvoice(PTAEnquiry);
        InvoiceVoucherLines(PTAVouchers, PTAEnquiry);
        totalValue := CreateAndCalculateVATToleranceOnPurchaseOrder();

        if ABS(totalValue - PTAVouchers.TotalInvoiceAmount) > PTASetup."Voucher Tolerance" then
            Error(StrSubstNo('Invoice total %1 does not match Voucher total %2 and if more than tolerance', totalValue, PTAVouchers.TotalInvoiceAmount));

        // if ABS(totalValue - PTAVouchers.TotalInvoiceAmount) <> 0 then
        //     if ABS(totalValue - PTAVouchers.TotalInvoiceAmount) > PTASetup."Voucher Tolerance" then
        //         Error(StrSubstNo('Invoice total %1 does not match Voucher total %2 and if more than tolerance', totalValue, PTAVouchers.TotalInvoiceAmount));
        // else
        //     InsertToleranceLine(PTAVouchers, PTAVouchers.TotalInvoiceAmount - totalValue, PTAEnquiry);

        UpdateAndPostPurchaseOrder(PTAVouchers, PTAVoucherEnquiries);
    end;

    local procedure InitAllPurchaseLineToInvoice(PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.reset;
        PurchaseLine.SetCurrentKey("PTA Enquiry ID", "PTA Line Entity Type", "PTA Linked Deal ID");
        PurchaseLine.SetRange("PTA Enquiry ID", PTAEnquiry.Id);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if PurchaseLine.FindSet(true) then begin
            PurchaseLine.ModifyAll("Qty. to Receive", 0, false);
            PurchaseLine.ModifyAll("Qty. to Invoice", 0, false);
        end;
    end;

    local procedure InvoiceVoucherLines(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if isCommissionInv then
            ProcessComissionline(PTAVouchers, PTAEnquiry)
        else
            ProcessVoucherProducts(PTAVouchers, PTAEnquiry);
        ProcessVocuherAddCosts(PTAVouchers, PTAEnquiry);
        ProcessVoucherAddServices(PTAVouchers, PTAEnquiry);
    end;

    local procedure ProcessVoucherProducts(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
        PTAVoucherProducts: Record PTAVoucherProducts;
    begin
        PTAVoucherProducts.Reset();
        PTAVoucherProducts.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherProducts.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherProducts.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherProducts.FindFirst() then
            repeat
                PTAEnquiryFunctions.CheckPTAPurchaseLineDoesNotExist(Enum::"PTA Enquiry Entities"::Products, PTAVoucherProducts.EnquiryProductId, PTAEnquiry.ID, PurchaseLine);
                PurchaseLine.FindFirst();
                PurchaseLine.validate("Qty. to Invoice", PurchaseLine."Qty. Rcd. Not Invoiced");
                PurchaseLine.Modify();

                if Not dropShipPO then
                    dropShipPO := PurchaseLine."Drop Shipment" AND (PurchaseLine."Qty. Rcd. Not Invoiced" > 0);

                if not POList.Contains(PurchaseLine."Document No.") then
                    POList.Add(PurchaseLine."Document No.");

            until PTAVoucherProducts.Next() = 0;
    end;

    local procedure ProcessVocuherAddCosts(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
        PTAVoucherAddCost: Record PTAVoucherAddCost;
    begin
        PTAVoucherAddCost.Reset();
        PTAVoucherAddCost.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddCost.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddCost.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherAddCost.FindFirst() then
            repeat
                PTAEnquiryFunctions.CheckPTAPurchaseLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalCosts, PTAVoucherAddCost.EnquiryAdditionalCostId, PTAEnquiry.ID, PurchaseLine);
                PurchaseLine.FindFirst();
                if PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
                    PurchaseLine.VALIDATE("Qty. to Receive", PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced");

                PurchaseLine.validate("Qty. to Invoice", PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced");
                PurchaseLine.Modify();

                if not POList.Contains(PurchaseLine."Document No.") then
                    POList.Add(PurchaseLine."Document No.");

            until PTAVoucherAddCost.Next() = 0;
    end;

    local procedure ProcessVoucherAddServices(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
        PTAVoucherAddServices: Record PTAVoucherAddServices;
    begin
        PTAVoucherAddServices.Reset();
        PTAVoucherAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddServices.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddServices.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        PTAVoucherAddServices.SetRange("Is VAT/GST Service", false);
        if PTAVoucherAddServices.FindFirst() then
            repeat
                PTAEnquiryFunctions.CheckPTAPurchaseLineDoesNotExist(Enum::"PTA Enquiry Entities"::AdditionalServices, PTAVoucherAddServices.EnquiryAdditionalServiceId, PTAEnquiry.ID, PurchaseLine);
                PurchaseLine.FindFirst();
                if PurchaseLine.Type = PurchaseLine.Type::"G/L Account" then
                    PurchaseLine.VALIDATE("Qty. to Receive", PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced");

                PurchaseLine.validate("Qty. to Invoice", PurchaseLine.Quantity - PurchaseLine."Quantity Invoiced");

                PurchaseLine.Modify();

                if not POList.Contains(PurchaseLine."Document No.") then
                    POList.Add(PurchaseLine."Document No.");
            until PTAVoucherAddServices.Next() = 0;
    end;

    local procedure insertToleranceLine(PTAVouchers: Record PTAVouchers; totalValue: Decimal; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.get(PurchaseHeader."Document Type"::Order, POList.get(POList.Count));
        PurchaseHeader.SetRecFilter();
        if PurchaseHeader.Status <> PurchaseHeader.status::Open then
            ReleasePurchaseDocument.Reopen(PurchaseHeader);

        PurchaseLine.init();
        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
        PurchaseLine."Document No." := POList.get(POList.Count);
        PurchaseLine."Line No." := GetLastLineNo(PurchaseLine."Document No.");
        PurchaseLine.Insert();
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.VALIDATE("No.", PTASetup."Voucher Tolerace G/L Acc.");
        PurchaseLine.VALIDATE(Quantity, 1);
        PurchaseLine.VALIDATE("Direct Unit Cost", totalValue);
        PurchaseLine."PTA Enquiry ID" := PTAEnquiry.ID;
        PurchaseLine."PTA Enquiry Number" := PTAEnquiry.EnquiryNumber;
        PurchaseLine.Modify();
    end;

    local procedure GetLastLineNo(PODocumentNo: Code[20]): Integer
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset();
        PurchaseLine.setrange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.setrange("Document No.", PODocumentNo);
        if PurchaseLine.FindLast() then
            Exit(PurchaseLine."Line No." + 10000)
        else
            exit(10000)
    end;

    local procedure UpdateAndPostPurchaseOrder(var PTAVouchers: Record PTAVouchers; var PTAVoucherEnquiries: Record PTAVoucherEnquiries)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
    begin
        PurchaseHeader.get(PurchaseHeader."Document Type"::Order, POList.get(POList.Count));
        PurchaseHeader.SetRecFilter();
        if PurchaseHeader.Status <> PurchaseHeader.status::Open then
            ReleasePurchaseDocument.Reopen(PurchaseHeader);

        if PTAVoucherEnquiries.EnquiryId <> 0 then begin
            PTAVoucherEnquiries.CalcFields("Enquiry Number");
            PurchaseHeader."Vendor Invoice No." := PTAVouchers.InvoiceNumber + '/' + FORMAT(PTAVoucherEnquiries."Enquiry Number")
        end ELSE
            PurchaseHeader."Vendor Invoice No." := PTAVouchers.InvoiceNumber;
        PurchaseHeader."Posting Date" := DT2Date(PTAVouchers.InvoiceDate);
        PurchaseHeader."Document Date" := DT2Date(PTAVouchers.InvoiceDate);
        PurchaseHeader."Due Date" := DT2Date(PTAVouchers.DueDate);
        PurchaseHeader.Receive := true;

        // if dropShipPO then begin
        //     PurchaseHeader.Invoice := false;
        //     PurchaseHeader.Modify();
        //     Clear(PurchPost);
        //     PurchPost.run(PurchaseHeader);
        //     PurchaseHeader.FindFirst();
        // end;
        PurchaseHeader.Invoice := true;
        PurchaseHeader.Modify();
        Clear(PurchPost);
        PurchPost.run(PurchaseHeader);
        if PurchaseHeader.FindFirst() then;
    end;

    procedure GetPTASetup()
    begin
        if not PTASetupFound then begin
            PTASetup.Get();
            PTASetupFound := True;
        end;
    end;

    local procedure ProcessComissionline(PTAVouchers: Record PTAVouchers; PTAEnquiry: Record PTAEnquiry)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.reset;
        PurchaseLine.SetCurrentKey("PTA Enquiry ID", "PTA Line Entity Type", "PTA Linked Deal ID");
        PurchaseLine.SetRange("PTA Enquiry ID", PTAEnquiry.ID);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.setrange("PTA CustomerBrokerComm Line", true);
        PurchaseLine.FindFirst();
        PurchaseLine.validate("Qty. to Receive", PurchaseLine.Quantity);
        PurchaseLine.validate("Qty. to Invoice", PurchaseLine.Quantity);
        PurchaseLine.Modify();
        if not POList.Contains(PurchaseLine."Document No.") then
            POList.Add(PurchaseLine."Document No.");
    end;

    procedure CreateAndCalculateVATToleranceOnPurchaseOrder(): Decimal
    var
        PurchaseLine: Record "Purchase Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        Purchaseheader: Record "Purchase Header";
        PurchasePost: Codeunit "Purch.-Post";
        AmountIncludingVAT: Decimal;
    begin
        Purchaseheader.get(Purchaseheader."Document Type"::Order, POList.get(POList.Count));
        TempVATAmountLine.DELETEALL;

        PurchaseLine.CalcVATAmountLines(1, Purchaseheader, PurchaseLine, TempVATAmountLine);
        if TempVATAmountLine.FindFirst() then
            repeat
                AmountIncludingVAT += TempVATAmountLine."Amount Including VAT";
            until TempVATAmountLine.Next() = 0;

        exit(AmountIncludingVAT);
    end;

    var
        isCommissionInv: Boolean;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        totalValue: Decimal;
        dropShipPO: Boolean;
        POList: List of [Code[20]];
        PTASetup: Record "PTA Setup";
        PTASetupFound: Boolean;

}