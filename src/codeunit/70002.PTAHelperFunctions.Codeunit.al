codeunit 70002 "PTA Helper Functions"
{
    trigger OnRun()
    begin
    end;

    procedure InsertDimensionValue(DimensionCode: Code[20]; DimensionValueCode: Text; DimensionValueName: Text; PTAIndexID: Integer; PTAisDeleted: Boolean)
    var
        DimensionValue: Record "Dimension Value";
    begin
        if Not DimensionValue.Get(DimensionCode, DimensionValueCode) then begin
            DimensionValue.Init();
            DimensionValue."Dimension Code" := DimensionCode;
            DimensionValue.Code := CopyStr(DimensionValueCode, 1, MaxStrLen(DimensionValue.Code));
            DimensionValue.Name := CopyStr(DimensionValueName, 1, MaxStrLen(DimensionValue.Name));
            DimensionValue."PTA Index Link" := PTAIndexID;
            DimensionValue."PTA IsDeleted" := PTAisDeleted;
            DimensionValue.insert(true);
        end else begin
            DimensionValue.Name := CopyStr(DimensionValueName, 1, MaxStrLen(DimensionValue.Name));
            DimensionValue."PTA Index Link" := PTAIndexID;
            DimensionValue."PTA IsDeleted" := PTAisDeleted;
            DimensionValue.Modify()
        end;
    end;

    procedure CheckAndInsertItemUnitOfMeasure(ProductId: Code[20]; UOMCode: code[20]; QtyPerUnitOfMeasure: Decimal)
    Var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if Not ItemUnitOfMeasure.get(ProductId, UOMCode) then begin
            ItemUnitOfMeasure.Init();
            ItemUnitOfMeasure."Item No." := ProductId;
            ItemUnitOfMeasure.Code := UOMCode;
            ItemUnitOfMeasure."Qty. per Unit of Measure" := QtyPerUnitOfMeasure;
            ItemUnitOfMeasure.Insert();
        end else begin
            ItemUnitOfMeasure."Qty. per Unit of Measure" := QtyPerUnitOfMeasure;
            ItemUnitOfMeasure.Modify();
        end;
    end;

    procedure CheckAndInsertResourceUnitOfMeasure(ResourceCode: Code[20]; UOMCode: code[20])
    Var
        ResourceUnitOfMeasure: Record "Resource Unit of Measure";
    begin
        if Not ResourceUnitOfMeasure.get(ResourceCode, UOMCode) then begin
            ResourceUnitOfMeasure.Init();
            ResourceUnitOfMeasure."Resource No." := ResourceCode;
            ResourceUnitOfMeasure.Code := UOMCode;
            ResourceUnitOfMeasure."Qty. per Unit of Measure" := 1;
            ResourceUnitOfMeasure.Insert();
        end else begin
            ResourceUnitOfMeasure."Qty. per Unit of Measure" := 1;
            ResourceUnitOfMeasure.Modify();
        end;
    end;

    procedure ChangeProcessedFlagTo99(RecordVariant: Variant; SkipMessage: text[250])
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if not RecordVariant.IsRecord then exit;


        RecRef.GetTable(RecordVariant);

        FldRef := RecRef.field(50001);
        if Format(FldRef.Value) <> '2' then Error('Only Error records can be skipped.');

        FldRef.Value := 99;

        FldRef := RecRef.field(50007);
        FldRef.Value := CurrentDateTime;

        FldRef := RecRef.field(50008);
        FldRef.Value := UserId;

        FldRef := RecRef.field(50009);
        FldRef.Value := SkipMessage;

        RecRef.Modify();
    end;

    procedure SetRecordToNotProcessed(var PTATransactionStatus: Record "PTA Transaction Status");
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
        PTAEnquiry: Record PTAEnquiry;
        PTAVouchers: Record PTAVouchers;
        PTACustomerInvoice: Record PTACustomerInvoices;
        PTAInboundPaymentsReceived: Record PTAInboundPaymentsReceived;
        PTAOutgoingPayments: Record PTAOutgoingPayments;
    begin
        if PTATransactionStatus.FindSet() then
            repeat
                Case PTATransactionStatus."Transaction Type" OF
                    PTATransactionStatus."Transaction Type"::Enquiries:
                        begin
                            RecRef.Open(database::PTAEnquiry);
                            RecRef.get(PTATransactionStatus."Last Record ID");
                        end;
                    PTATransactionStatus."Transaction Type"::CustomerInvoice:
                        begin
                            RecRef.Open(database::PTACustomerInvoices);
                            RecRef.get(PTATransactionStatus."Last Record ID");
                        end;
                    PTATransactionStatus."Transaction Type"::Voucher:
                        begin
                            RecRef.Open(database::PTAVouchers);
                            RecRef.get(PTATransactionStatus."Last Record ID");
                        end;
                    PTATransactionStatus."Transaction Type"::"Inbound Payment":
                        begin
                            RecRef.Open(database::PTAInboundPaymentsReceived);
                            RecRef.get(PTATransactionStatus."Last Record ID");
                        end;
                    PTATransactionStatus."Transaction Type"::"Outbound Payment":
                        begin
                            RecRef.Open(database::PTAOutgoingPayments);
                            RecRef.get(PTATransactionStatus."Last Record ID");
                        end;
                End;
                FldRef := RecRef.field(50001);
                FldRef.Value := 0;
                FldRef := RecRef.field(50003);
                FldRef.Value := '';
                FldRef := RecRef.field(50002);
                FldRef.Value := 0DT;
                FldRef := RecRef.field(50004);
                FldRef.Value := 0DT;
                RecRef.Modify();
                RecRef.Close();

                PTATransactionStatus."Error Message" := '';
                PTATransactionStatus."Last Status" := PTATransactionStatus."Last Status"::" ";
                PTATransactionStatus.Modify();
            until PTATransactionStatus.Next() = 0;

        Message('Record(s) is/are set to NOT PROCESSED. It will be processed when the Job runs again');
    end;

    procedure ForceEnquiryCreationWithoutValidation(PTATransactionStatus: Record "PTA Transaction Status");
    var
        RecRef: RecordRef;
        PtaEnquiry: Record PTAEnquiry;
        SetVATToleranceOnSalesOrder: Codeunit SetVATToleranceOnSalesOrder;
        PTAProcessSingleEnquiryRecord: Codeunit PTAEnquiryProcessSingleRecord;
        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        HeaderEntryNo: Integer;
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        ModifyPTATransactionStatus: Record "PTA Transaction Status";
    begin
        if PTATransactionStatus."Transaction Type" <> PTATransactionStatus."Transaction Type"::Enquiries then exit;
        // ModifyPTATransactionStatus := PTATransactionStatus;
        // ModifyPTATransactionStatus."Manually Processed" := true;
        // ModifyPTATransactionStatus.Modify();

        RecRef.Open(database::PTAEnquiry);
        RecRef.get(PTATransactionStatus."Last Record ID");
        RecRef.SetTable(PtaEnquiry);
        PtaEnquiry.SetRecFilter();

        clear(SetVATToleranceOnSalesOrder);
        BindSubscription(SetVATToleranceOnSalesOrder);
        if PTAEnquiry.findset(true) then begin
            HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
            CuPTAIntegrationLog.InsertHeaderRecord(Enum::"PTA Integration Process Type"::Enquiry, 'Enquiries', HeaderEntryNo);

            ClearLastError();
            Commit();
            if PTAProcessSingleEnquiryRecord.Run(PTAEnquiry) then begin
                PTAHelperFunctions.SetStatusFlagsOnRecords(PTAEnquiry, 1, '');
                CuPTAIntegrationLog.InsertLogEntry(PTAEnquiry, 1, DummyIntegrationStatus::Success, Format(PTAEnquiry.EnquiryNumber), HeaderEntryNo);
                CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::Enquiries, Format(PTAEnquiry.EnquiryNumber), DummyIntegrationStatus::Success, PTAEnquiry.RecordId)
            end else begin
                PTAHelperFunctions.SetStatusFlagsOnRecords(PTAEnquiry, 2, CopyStr(GetLastErrorText(), 1, maxstrlen(PTAEnquiry.ErrorMessage)));
                CuPTAIntegrationLog.InsertLogEntry(PTAEnquiry, 1, DummyIntegrationStatus::Error, Format(PTAEnquiry.EnquiryNumber), HeaderEntryNo);
                CuPTAIntegrationLog.CheckAndUpdateTransactionStatus(enum::"PTA Enquiry Entities"::Enquiries, Format(PTAEnquiry.EnquiryNumber), DummyIntegrationStatus::Error, PTAEnquiry.RecordId);
            end;
        end;
        UnbindSubscription(SetVATToleranceOnSalesOrder);
    end;

    procedure SetStatusFlagsOnRecords(RecordVariant: Variant; FlagValue: Integer; ErrorMessage: Text)
    var
        RecRef: RecordRef;
        FldRef: FieldRef;
    begin
        if not RecordVariant.IsRecord then exit;
        RecRef.GetTable(RecordVariant);

        FldRef := RecRef.field(50001);
        FldRef.Value := FlagValue;

        Case true of
            ErrorMessage <> '':
                begin
                    FldRef := RecRef.field(50003);
                    FldRef.Value := ErrorMessage;
                    FldRef := RecRef.field(50004);
                    FldRef.Value := CurrentDateTime;
                end;
            ErrorMessage = '':
                begin
                    FldRef := RecRef.field(50002);
                    FldRef.Value := CurrentDateTime;
                    FldRef := RecRef.field(50003);
                    FldRef.Value := '';
                end;
        End;
        RecRef.Modify();
    end;

    procedure HasRecordChanged(NewRecRef: RecordRef; OldRecRef: RecordRef; VarTableID: Integer): Boolean
    var
        PTABCEnquiryField: Record "PTA BC Enquiry Field";
        NewFieldRef: FieldRef;
        OldFieldRef: FieldRef;
        HasChanged: Boolean;

        PTAEnquiry: Record PTAEnquiry;
        PreviousPTAEnquiry: Record PTAEnquiry;

    begin
        if NewRecRef.Number = Database::PTAEnquiry then begin
            if OldRecRef.FieldExist(50001) then begin
                OldFieldRef := OldRecRef.field(50001);
                if Format(OldFieldRef.Value) = '2' then exit(true);
            end;
            NewRecRef.SetTable(PTAEnquiry);
            OldRecRef.SetTable(PreviousPTAEnquiry);
            if PTAEnquiry.HasVATAmount() <> PreviousPTAEnquiry.HasVATAmount() then
                exit(true);
        end;

        HasChanged := False;
        PTABCEnquiryField.Reset();
        PTABCEnquiryField.SetRange(TableID, VarTableID);
        if PTABCEnquiryField.Findset then
            repeat
                NewFieldRef := NewRecRef.Field(PTABCEnquiryField.FieldID);
                OldFieldRef := OldRecRef.Field(PTABCEnquiryField.FieldID);
                HasChanged := (NewFieldRef.Value <> OldFieldRef.Value);
            until (PTABCEnquiryField.next = 0) OR HasChanged;
        exit(HasChanged);
    end;

    procedure GetNewNextCode(NewUserCode: Text; TableId: Integer): Code[20]
    var
        i: integer;
        Item: Record item;
    begin
        NewUserCode := Copystr(NewUserCode, 1, 15).ToUpper();
        for i := 1 to 100 do begin
            if TableHasRecord(TableId, NewUserCode) then begin
                if i = 1 then
                    NewUserCode := NewUserCode + ' #2'
                else
                    NewUserCode := INCSTR(NewUserCode)
            end else
                exit(NewUserCode);
        end;
    end;

    local Procedure TableHasRecord(TableID: Integer; PKCode: Code[20]): Boolean
    var
        item: Record Item;
        Resource: Record Resource;
        Salespeople: Record "Salesperson/Purchaser";
        Currency: Record Currency;
        UnitofMeasure: Record "Unit of Measure";
        ShipmentMethod: Record "Shipment Method";
        CountryRegion: Record "Country/Region";
        Location: Record Location;
        PostCode: Record "Post Code";
        DimensionValues: Record "Dimension Value";
        itemCategory: Record "Item Category";
    begin
        Case TableID of
            database::"item category":
                exit(itemCategory.get(PKCode));
            Database::Item:
                Exit(item.get(PKCode));
            Database::Resource:
                Exit(Resource.get(PKCode));
            Database::"Salesperson/Purchaser":
                Exit(Salespeople.get(PKCode));
            Database::Currency:
                Exit(Currency.get(PKCode));
            Database::"Unit of Measure":
                Exit(UnitofMeasure.get(PKCode));
            Database::"Shipment Method":
                Exit(ShipmentMethod.get(PKCode));
            Database::"Country/Region":
                Exit(CountryRegion.get(PKCode));
            Database::Location:
                Exit(Location.get(PKCode));
            Database::"Post Code":
                begin
                    PostCode.Reset();
                    PostCode.setrange(Code, PKCode);
                    exit(NOT PostCode.IsEmpty())
                end;
            Database::"Dimension Value":
                begin
                    DimensionValues.Reset();
                    DimensionValues.SetCurrentKey("Code", "Global Dimension No.");
                    DimensionValues.setrange(Code, PKCode);
                    exit(Not DimensionValues.IsEmpty())
                end;

        end;
    end;

    procedure Return15CharactersOfPK(PKValue: code[20]): code[15]
    begin
        if STRPOS(PKValue, ' #') <> 0 then
            Exit(copystr(PKValue, 1, STRPOS(PKValue, ' #') - 1))
        else
            exit(PKValue)
    end;

    procedure GetCompanyPTAPurchaseCurrency(): Integer
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        exit(CompanyInfo."PTA Base Currency ID")
    end;

    procedure GetPTACompanyID(): Integer
    var
        CompanyInfo: Record "Company Information";
    begin
        CompanyInfo.get();
        exit(CompanyInfo."PTA Index Link");
    end;

    procedure UpdateGlobalAndShortcutDimensionsOnSalesHeaders(var SalesHeader: Record "Sales Header")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        ShortcutDimCode: array[8] of Code[20];
    begin
        if SalesHeader."Dimension Set ID" = 0 then exit;
        GetShortcutDimensionValues.GetShortcutDimensions(SalesHeader."Dimension Set ID", ShortcutDimCode);
        SalesHeader."STO Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        SalesHeader."STO Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        SalesHeader."STO Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        SalesHeader."STO Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        SalesHeader."STO Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        SalesHeader."STO Shortcut Dimension 8 Code" := ShortcutDimCode[8];
    end;

    procedure UpdateGlobalAndShortcutDimensionsOnOnPurchaseHeaders(var PurchaseHeader: Record "Purchase Header")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        ShortcutDimCode: array[8] of Code[20];
    begin
        if PurchaseHeader."Dimension Set ID" = 0 then exit;
        GetShortcutDimensionValues.GetShortcutDimensions(PurchaseHeader."Dimension Set ID", ShortcutDimCode);
        PurchaseHeader."STO Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        PurchaseHeader."STO Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        PurchaseHeader."STO Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        PurchaseHeader."STO Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        PurchaseHeader."STO Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        PurchaseHeader."STO Shortcut Dimension 8 Code" := ShortcutDimCode[8];
    end;

    procedure UpdateGlobalAndShortcutDimensionsOnSalesLine(var SalesLine: Record "Sales Line")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        ShortcutDimCode: array[8] of Code[20];
    begin
        if SalesLine."Dimension Set ID" = 0 then exit;
        GetShortcutDimensionValues.GetShortcutDimensions(SalesLine."Dimension Set ID", ShortcutDimCode);
        SalesLine."STO Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        SalesLine."STO Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        SalesLine."STO Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        SalesLine."STO Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        SalesLine."STO Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        SalesLine."STO Shortcut Dimension 8 Code" := ShortcutDimCode[8];
    end;

    procedure UpdateGlobalAndShortcutDimensionsOnOnPurchaseLine(var PurchaseLine: Record "Purchase Line")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
        ShortcutDimCode: array[8] of Code[20];
    begin
        if PurchaseLine."Dimension Set ID" = 0 then exit;
        GetShortcutDimensionValues.GetShortcutDimensions(PurchaseLine."Dimension Set ID", ShortcutDimCode);
        PurchaseLine."STO Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        PurchaseLine."STO Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        PurchaseLine."STO Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        PurchaseLine."STO Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        PurchaseLine."STO Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        PurchaseLine."STO Shortcut Dimension 8 Code" := ShortcutDimCode[8];
    end;

    internal procedure BothDealsAreTrading(VarPTAEnquiry: Record PTAEnquiry): Boolean
    var
        LinkedEnquiry: Record PtaEnquiry;
    begin
        LinkedEnquiry.reset;
        LinkedEnquiry.SetCurrentKey(id, TransactionBatchId);
        LinkedEnquiry.SetRange(id, VarPTAEnquiry.LinkedDealId);
        LinkedEnquiry.FindLast();
        exit((LinkedEnquiry.BusinessAreaId = VarPTAEnquiry.BusinessAreaId) and (LinkedEnquiry.BusinessAreaId = 1));
    end;

    internal procedure OneOfTheDealIsPhysical(VarPTAEnquiry: Record PTAEnquiry): Boolean
    var
        LinkedEnquiry: Record PtaEnquiry;
    begin
        LinkedEnquiry.reset;
        LinkedEnquiry.SetCurrentKey(id, TransactionBatchId);
        LinkedEnquiry.SetRange(id, VarPTAEnquiry.LinkedDealId);
        LinkedEnquiry.FindLast();
        exit((LinkedEnquiry.BusinessAreaId <> VarPTAEnquiry.BusinessAreaId) AND ((LinkedEnquiry.BusinessAreaId = 3) Or (VarPTAEnquiry.BusinessAreaId = 3)));
    end;

}