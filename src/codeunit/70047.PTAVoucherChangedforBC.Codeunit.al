codeunit 70047 PTAVoucherChangedforBC
{

    procedure PTACheckIfVoucherHasChanged(PTAVouchers: Record PTAVouchers): Boolean
    Var
        HasChanged: Boolean;
    begin
        HasChanged := false;
        CheckIFPTAVoucherHasChanged(PTAVouchers, HasChanged);

        if Not HasChanged then
            CheckIFAnyPTAVoucherProductHasChanged(PTAVouchers, HasChanged);
        if Not HasChanged then
            CheckIFAnyPTAVoucherAdditionalCostHasChanged(PTAVouchers, HasChanged);
        if Not HasChanged then
            CheckIFAnyPTAVoucherAdditionalServiceHasChanged(PTAVouchers, HasChanged);

        exit(HasChanged);
    end;

    local procedure CheckIFPTAVoucherHasChanged(var PTAVouchers: Record PTAVouchers; Var HasChanged: Boolean)
    var
        PreviousPTAVoucher: Record PTAVouchers;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryFunctions.GetPreviousBatchPTAVoucher(PTAVouchers, PreviousPTAVoucher);
        NewRecordRef.GetTable(PTAVouchers);
        OldRecordRef.GetTable(PreviousPTAVoucher);
        HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAVouchers);
    end;

    local procedure CheckIFAnyPTAVoucherProductHasChanged(var PTAVouchers: Record PTAVouchers; var HasChanged: Boolean)
    var
        PTAVoucherProducts: Record PTAVoucherProducts;
        PreviousPTAVoucherProducts: Record PTAVoucherProducts;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAVoucherProducts.Reset();
        PTAVoucherProducts.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherProducts.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherProducts.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherProducts.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchVoucherProductByID(PTAVoucherProducts, PreviousPTAVoucherProducts, PTAVoucherProducts.ID);
                HasChanged := (PreviousPTAVoucherProducts.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTAVoucherProducts);
                    OldRecordRef.GetTable(PreviousPTAVoucherProducts);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAVoucherProducts);
                end;
            Until (PTAVoucherProducts.next = 0) OR HasChanged
    end;

    local procedure CheckIFAnyPTAVoucherAdditionalCostHasChanged(var PTAVouchers: Record PTAVouchers; Var HasChanged: Boolean)
    var
        PTAVoucherAddCost: Record PTAVoucherAddCost;
        PreviousPTAVoucherAddCost: Record PTAVoucherAddCost;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAVoucherAddCost.Reset();
        PTAVoucherAddCost.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddCost.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddCost.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherAddCost.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchVoucherAdditionalCostByID(PTAVoucherAddCost, PreviousPTAVoucherAddCost, PTAVoucherAddCost.ID);
                HasChanged := (PreviousPTAVoucherAddCost.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTAVoucherAddCost);
                    OldRecordRef.GetTable(PreviousPTAVoucherAddCost);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAVoucherAddCost);
                end;
            Until (PTAVoucherAddCost.next = 0) OR HasChanged
    end;

    local procedure CheckIFAnyPTAVoucherAdditionalServiceHasChanged(var PTAVouchers: Record PTAVouchers; Var HasChanged: Boolean)
    var
        PTAVoucherAddServices: Record PTAVoucherAddServices;
        PreviousPTAVoucherAddServices: Record PTAVoucherAddServices;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAVoucherAddServices.Reset();
        PTAVoucherAddServices.SetCurrentKey(VoucherId, TransactionBatchId);
        PTAVoucherAddServices.SetRange(VoucherId, PTAVouchers.ID);
        PTAVoucherAddServices.SetRange(TransactionBatchId, PTAVouchers.TransactionBatchId);
        if PTAVoucherAddServices.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchVoucherServiceByID(PTAVoucherAddServices, PreviousPTAVoucherAddServices, PTAVoucherAddServices.ID);
                HasChanged := (PreviousPTAVoucherAddServices.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTAVoucherAddServices);
                    OldRecordRef.GetTable(PreviousPTAVoucherAddServices);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAVoucherAddServices);
                end;
            Until (PTAVoucherAddServices.next = 0) OR HasChanged
    end;

    var
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}