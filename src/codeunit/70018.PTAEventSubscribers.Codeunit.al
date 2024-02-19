codeunit 70018 "PTA Event Subscribers"
{

    [EventSubscriber(ObjectType::Table, Database::"Dimension Value", 'OnBeforeUpdateCostAccFromDim', '', false, false)]
    local procedure OnBeforeUpdateCostAccFromDim(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnBeforeAddDefaultDimensionAllowedDimensionValue', '', false, false)]
    local procedure OnBeforeAddDefaultDimensionAllowedDimensionValue(DimensionValue: Record "Dimension Value"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCheckShipmentDateBeforeWorkDate', '', false, false)]
    local procedure OnBeforeCheckShipmentDateBeforeWorkDate(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCheckAssocPurchOrder', '', false, false)]
    local procedure OnBeforeCheckAssocPurchOrder(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeUpdateSalesLinesByFieldNo', '', false, false)]
    local procedure OnBeforeUpdateSalesLinesByFieldNo(var AskQuestion: Boolean)
    begin
        AskQuestion := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeConfirmUpdateCurrencyFactor', '', false, false)]
    local procedure OnBeforeConfirmUpdateCurrencyFactor(var HideValidationDialog: Boolean)
    begin
        HideValidationDialog := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeMessageIfSalesLinesExist', '', false, false)]
    local procedure OnBeforeMessageIfSalesLinesExist(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::table, database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PTA Enquiry ID" := SalesHeader."PTA Enquiry ID";
        GenJournalLine."PTA Enquiry Number" := SalesHeader."PTA Enquiry Number";
        GenJournalLine."PTA Linked Deal ID" := SalesHeader."PTA Linked Deal ID";
        GenJournalLine."PTA Linked Deal No." := SalesHeader."PTA Linked Deal No.";
        GenJournalLine."PTA Vessel Name" := SalesHeader."PTA Vessel Name";
    end;

    [EventSubscriber(ObjectType::table, database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PTA Vessel Name" := PurchaseHeader."PTA Vessel Name";
        GenJournalLine."PTA Enquiry ID" := PurchaseHeader."PTA Enquiry ID";
        GenJournalLine."PTA Enquiry Number" := PurchaseHeader."PTA Enquiry Number";
    end;

    [EventSubscriber(ObjectType::table, database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GLEntry."PTA Enquiry ID" := GenJournalLine."PTA Enquiry ID";
        GLEntry."PTA Linked Deal ID" := GenJournalLine."PTA Linked Deal ID";
        GLEntry."PTA Linked Deal No." := GenJournalLine."PTA Linked Deal No.";
        GLEntry."PTA Enquiry number" := GenJournalLine."PTA Enquiry number";
        GLEntry."PTA Vessel Name" := GenJournalLine."PTA Vessel Name";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', False, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."PTA Vessel Name" := GenJournalLine."PTA Vessel Name";
        VendorLedgerEntry."PTA Enquiry ID" := GenJournalLine."PTA Enquiry ID";
        VendorLedgerEntry."PTA Enquiry Number" := GenJournalLine."PTA Enquiry Number";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', False, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."PTA Enquiry ID" := GenJournalLine."PTA Enquiry ID";
        CustLedgerEntry."PTA Linked Deal ID" := GenJournalLine."PTA Linked Deal ID";
        CustLedgerEntry."PTA Linked Deal No." := GenJournalLine."PTA Linked Deal No.";
        CustLedgerEntry."PTA Enquiry number" := GenJournalLine."PTA Enquiry number";
        CustLedgerEntry."PTA Vessel Name" := GenJournalLine."PTA Vessel Name";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateLocationCodeOnBeforeDropShipmentError', '', false, false)]
    local procedure OnValidateLocationCodeOnBeforeDropShipmentError(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateQuantityOnBeforeDropShptCheck', '', false, false)]
    local procedure OnValidateQuantityOnBeforeDropShptCheck(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnUpdateSalesCostOnBeforeGetSalesOrderLine', '', false, false)]
    local procedure OnUpdateSalesCostOnBeforeGetSalesOrderLine(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeCheckAssosiatedSalesOrder', '', false, false)]
    local procedure OnBeforeCheckAssosiatedSalesOrder(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateUnitOfMeasureCodeOnBeforeDropShipmentError', '', false, false)]
    local procedure OnValidateUnitOfMeasureCodeOnBeforeDropShipmentError(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCheckAssociatedOrderLinesOnAfterSetFilters', '', false, false)]
    local procedure OnCheckAssociatedOrderLinesOnAfterSetFilters(var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; var HideProgressWindow: Boolean)
    begin
        if SalesHeader."PTA Enquiry Number" = 0 then exit;
        HideProgressWindow := (Not GuiAllowed);
        if SalesHeader."PTA Parked" then Error('Cannot post Parked Sales documents');
    end;

    [EventSubscriber(ObjectType::Report, REPORT::"Batch Post Sales Orders", 'OnBeforeSalesBatchPostMgt', '', false, false)]
    local procedure OnBeforeSalesBatchPostMgt(var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader.GetFilter("PTA Contract Code") = '' then
            error('Batch Posting requires a Contract Dimension to be selected');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var HideProgressWindow: Boolean)
    begin
        if PurchaseHeader."PTA Enquiry Number" = 0 then exit;
        HideProgressWindow := (Not GuiAllowed);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeSendICDocument', '', False, false)]
    local procedure PurchPost_OnBeforeSendICDocument(var IsHandled: Boolean; var ModifyHeader: Boolean; var PurchHeader: Record "Purchase Header")
    var
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
    begin
        if PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice then exit;

        if PurchHeader."Send IC Document" and (PurchHeader."IC Status" = PurchHeader."IC Status"::New) and (PurchHeader."IC Direction" = PurchHeader."IC Direction"::Outgoing) then begin
            ICInboxOutboxMgt.SendPurchDoc(PurchHeader, true);
            PurchHeader."IC Status" := PurchHeader."IC Status"::Pending;
            ModifyHeader := true;
        end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateVATProdPostingGroup', '', false, false)]
    local procedure OnBeforeValidateVATProdPostingGroup(var IsHandled: Boolean; var PurchaseLine: Record "Purchase Line")
    begin
        IsHandled := (PurchaseLine."VAT Prod. Posting Group" = '');
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateVATProdPostingGroupOnAfterTestStatusOpen', '', false, false)]
    local procedure OnValidateVATProdPostingGroupOnAfterTestStatusOpen(var IsHandled: Boolean; var PurchaseLine: Record "Purchase Line")
    begin
        IsHandled := (PurchaseLine."VAT Prod. Posting Group" = '');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Customer Card", 'OnQueryClosePageEvent', '', false, false)]
    local procedure CustomerCard_OnQueryClosePageEvent(var Rec: Record Customer)
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if Rec."Country/Region Code" = '' then
            Error('Country/Region Code is not set, Cannot close the page');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Contact Card", 'OnQueryClosePageEvent', '', false, false)]
    local procedure ContactCard_OnQueryClosePageEvent(var Rec: Record Contact)
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if Rec."Country/Region Code" = '' then
            Error('Country/Region Code is not set, Cannot close the page');
    end;

    [EventSubscriber(ObjectType::Page, Page::"Vendor Card", 'OnQueryClosePageEvent', '', false, false)]
    local procedure VendorCard_OnQueryClosePageEvent(var Rec: Record Vendor)
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if Rec."Country/Region Code" = '' then
            Error('Country/Region Code is not set, Cannot close the page');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateShortcutDimCode', '', false, false)]
    local procedure Salesheader_OnAfterValidateShortcutDimCode(var SalesHeader: Record "Sales Header")
    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
    begin
        if SalesHeader."Dimension Set ID" = 0 then exit;
        PTAHelperFunctions.UpdateGlobalAndShortcutDimensionsOnSalesHeaders(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateShortcutDimCode', '', false, false)]
    local procedure PurchaseHeader_OnAfterValidateShortcutDimCode(var PurchHeader: Record "Purchase Header")
    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
    begin
        if PurchHeader."Dimension Set ID" = 0 then exit;
        PTAHelperFunctions.UpdateGlobalAndShortcutDimensionsOnOnPurchaseHeaders(PurchHeader);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateShortcutDimCode', '', false, false)]
    local procedure SalesLine_OnAfterValidateShortcutDimCode(var SalesLine: Record "Sales Line")
    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
    begin
        if SalesLine."Dimension Set ID" = 0 then exit;
        PTAHelperFunctions.UpdateGlobalAndShortcutDimensionsOnSalesLine(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateShortcutDimCode', '', false, false)]
    local procedure PurchaseLine_OnAfterValidateShortcutDimCode(var PurchaseLine: Record "Purchase Line")
    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
    begin
        if PurchaseLine."Dimension Set ID" = 0 then exit;
        PTAHelperFunctions.UpdateGlobalAndShortcutDimensionsOnOnPurchaseLine(PurchaseLine);
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Master Data Synch.", 'OnQueryPostFilterIgnoreRecord', '', false, false)]
    // local procedure IgnoreCompanyContactOnQueryPostFilterIgnoreRecord(SourceRecordRef: RecordRef; var IgnoreRecord: Boolean)
    // var
    //     Contact: Record Contact;
    // begin
    //     if IgnoreRecord then
    //         exit;

    //     if SourceRecordRef.Number = DATABASE::Contact then begin
    //         SourceRecordRef.SetTable(Contact);
    //         if Contact.Type = Contact.Type::Company then
    //             IgnoreRecord := true;
    //     end;
    // end;
}