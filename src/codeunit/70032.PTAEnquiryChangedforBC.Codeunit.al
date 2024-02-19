codeunit 70032 "PTA Enquiry Changed for BC"
{

    procedure PTAProcessEnquiryForBC(PTAEnquiry: Record PTAEnquiry): Boolean
    Var
        HasChanged: Boolean;
    begin
        HasChanged := false;
        CheckIFPTAEnquiryHasChanged(PTAEnquiry, HasChanged);

        if Not HasChanged then
            CheckIFAnyPTAEnquiryProductHasChanged(PTAEnquiry, HasChanged);
        if Not HasChanged then
            CheckIFAnyPTAEnquiryAdditionalCostHasChanged(PTAEnquiry, HasChanged);
        if Not HasChanged then
            CheckIFAnyPTAEnquiryAdditionalServiceHasChanged(PTAEnquiry, HasChanged);

        exit(HasChanged);
    end;

    local procedure CheckIFPTAEnquiryHasChanged(PTAEnquiry: Record PTAEnquiry; Var HasChanged: Boolean)
    var
        PreviousPTAEnquiry: Record PTAEnquiry;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryFunctions.GetPreviousBatchPTAEnquiry(PTAEnquiry, PreviousPTAEnquiry);

        if (PreviousPTAEnquiry.StatusId in [15, 16]) AND (NOT (PTAEnquiry.StatusId in [15, 16])) then begin
            HasChanged := true;
            exit;
        end;

        PreviousPTAEnquiry.CalcFields("No. Of Product Lines", "No. Of Cost Lines", "No. Of Service Lines");
        PTAEnquiry.CalcFields("No. Of Product Lines", "No. Of Cost Lines", "No. Of Service Lines");

        HasChanged := (PTAEnquiry."No. Of Service Lines" <> PreviousPTAEnquiry."No. Of Service Lines") or (PTAEnquiry."No. Of Cost Lines" <> PreviousPTAEnquiry."No. Of Cost Lines") or (PTAEnquiry."No. Of Product Lines" <> PreviousPTAEnquiry."No. Of Product Lines");
        if HasChanged then
            exit;

        NewRecordRef.GetTable(PTAEnquiry);
        OldRecordRef.GetTable(PreviousPTAEnquiry);
        HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiry);
    end;

    local procedure CheckIFAnyPTAEnquiryProductHasChanged(PTAEnquiry: Record PTAEnquiry; var HasChanged: Boolean)
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PreviousPTAEnquiryProducts: Record PTAEnquiryProducts;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryProducts.Reset();
        PTAEnquiryProducts.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryProducts.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryProducts.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryProductByID(PTAEnquiryProducts, PreviousPTAEnquiryProducts, PTAEnquiryProducts.ID);
                HasChanged := (PreviousPTAEnquiryProducts.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTAEnquiryProducts);
                    OldRecordRef.GetTable(PreviousPTAEnquiryProducts);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiryProducts);
                end;
            Until (PTAEnquiryProducts.next = 0) OR HasChanged
    end;

    local procedure CheckIFAnyPTAEnquiryAdditionalCostHasChanged(PTAEnquiry: Record PTAEnquiry; var HasChanged: Boolean)
    var
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        PreviousPTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryAdditionalCost.Reset();
        PTAEnquiryAdditionalCost.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryAdditionalCost.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryAdditionalCostByID(PTAEnquiryAdditionalCost, PreviousPTAEnquiryAdditionalCost, PTAEnquiryAdditionalCost.ID);
                HasChanged := (PreviousPTAEnquiryAdditionalCost.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTAEnquiryAdditionalCost);
                    OldRecordRef.GetTable(PreviousPTAEnquiryAdditionalCost);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiryAdditionalCost);
                end;
            Until (PTAEnquiryAdditionalCost.next = 0) OR HasChanged
    end;

    local procedure CheckIFAnyPTAEnquiryAdditionalServiceHasChanged(PTAEnquiry: Record PTAEnquiry; var HasChanged: Boolean)
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        PreviousPTAEnquiryAddServices: Record PTAEnquiryAddServices;
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        NewRecordRef, OldRecordRef : Recordref;
    begin
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, PTAEnquiry.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, PTAEnquiry.TransactionBatchId);
        if PTAEnquiryAddServices.FindFirst() then
            repeat
                PTAEnquiryFunctions.GetPreviousBatchPTAEnquiryServiceByID(PTAEnquiryAddServices, PreviousPTAEnquiryAddServices, PTAEnquiryAddServices.ID);
                HasChanged := (PreviousPTAEnquiryAddServices.ID = 0); //New Line Added in the Enquiry
                if Not HasChanged then begin
                    NewRecordRef.gettable(PTAEnquiryAddServices);
                    OldRecordRef.GetTable(PreviousPTAEnquiryAddServices);
                    HasChanged := PTAHelperFunctions.HasRecordChanged(NewRecordRef, OldRecordRef, Database::PTAEnquiryAddServices);
                end;
            Until (PTAEnquiryAddServices.next = 0) OR HasChanged
    end;

    var
        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}