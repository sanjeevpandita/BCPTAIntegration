table 70050 "PTA Integration Entry Log"
{
    Caption = 'PTA Integration Entry Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Indendation Level"; Integer)
        {
            Caption = 'Entry No.';
        }
        field(4; "Entity Name"; Text[100])
        {
            Caption = 'Entity Name';
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(20; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
        }
        field(22; "Integration Status"; Enum "PTA Integration Status")
        {
            Caption = 'Status';
        }
        field(23; HeaderEntryNo; Integer)
        {
            Caption = 'Header Entry No.';
        }
        field(24; ErrorMessage; Text[250])
        {
            Caption = 'Error Message';
        }
    }
    keys
    {
        key(PK; HeaderEntryNo, "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Entity Name", "Integration Status")
        {
        }

    }

    procedure SetStyle(): Text[30]
    begin
        if (Rec."Integration Status" = Rec."Integration Status"::Error) then
            Exit('Unfavorable')
        else
            Exit('')
    end;

    procedure ShowRecord()
    var
        RecRef: RecordRef;
        PageManagement: Codeunit "Page Management";

    begin
        if not RecRef.Get("Record ID") then
            exit;
        RecRef.SetRecFilter();
        PageManagement.PageRun(RecRef);
    end;

    procedure ShowBCRecord()
    var
        RecRef: RecordRef;
        PageManagement: Codeunit "Page Management";
        FldRef: FieldRef;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        custledgerentry: Record "Cust. Ledger Entry";
        Contact: Record "Contact";
    begin
        if not RecRef.Get("Record ID") then
            exit;

        case RecRef.Number() of
            database::PTAEnquiry:
                begin
                    FldRef := RecRef.Field(150);
                    SalesHeader.reset;
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.setfilter("No.", '%1', Format(FldRef.value));
                    if SalesHeader.FindFirst() then
                        Page.RunModal(0, SalesHeader)
                end;
            Database::PTACustomerInvoices:
                begin
                    FldRef := RecRef.Field(70);
                    Case Format(FldRef.value) of
                        '4':
                            begin
                                FldRef := RecRef.Field(80);
                                SalesInvoiceHeader.reset;
                                SalesInvoiceHeader.SetRange("No.", Format(FldRef.value));
                                if SalesInvoiceHeader.FindFirst() then
                                    Page.RunModal(0, SalesInvoiceHeader)
                            end;
                        '7':
                            begin
                                FldRef := RecRef.Field(80);
                                SalesCrMemoHeader.reset;
                                SalesCrMemoHeader.SetRange("Applies-to Doc. Type", SalesCrMemoHeader."Applies-to Doc. Type"::Invoice);
                                SalesCrMemoHeader.SetRange("Applies-to Doc. No.", Format(FldRef.value));
                                if SalesCrMemoHeader.FindFirst() then
                                    Page.RunModal(0, SalesCrMemoHeader)
                            end;
                    End;
                end;
            Database::PTAVouchers:
                begin
                    FldRef := RecRef.Field(30);
                    PurchInvHeader.reset;
                    PurchInvHeader.SetFilter("Vendor Invoice No.", StrSubstNo('%1*', Format(FldRef.value)));
                    if PurchInvHeader.FindFirst() then
                        Page.RunModal(0, PurchInvHeader)
                end;
            Database::PTAOutgoingPayments:
                begin
                    FldRef := RecRef.Field(20);
                    VendorLedgerEntry.reset;
                    VendorLedgerEntry.SetCurrentKey("Document No.");
                    VendorLedgerEntry.SetRange("Document No.", Format(FldRef.value));
                    FldRef := RecRef.Field(60);

                    Case format(FldRef.Value) of
                        '4':
                            VendorLedgerEntry.Setrange("Document Type", VendorLedgerEntry."Document Type"::Refund);
                        '2':
                            VendorLedgerEntry.Setrange("Document Type", VendorLedgerEntry."Document Type"::Payment);
                    End;
                    Page.RunModal(0, VendorLedgerEntry)
                end;
            Database::PTAInboundPaymentsReceived:
                begin
                    FldRef := RecRef.Field(20);
                    custledgerentry.reset;
                    custledgerentry.SetCurrentKey("Document No.");
                    custledgerentry.SetRange("Document No.", Format(FldRef.value));
                    FldRef := RecRef.Field(50006);

                    Case format(FldRef.Value).ToUpper() of
                        'TRUE':
                            custledgerentry.Setrange("Document Type", VendorLedgerEntry."Document Type"::Refund);
                        'FALSE':
                            custledgerentry.Setrange("Document Type", VendorLedgerEntry."Document Type"::Payment);
                    End;
                    Page.RunModal(0, custledgerentry)
                end;
            Database::PTACounterpartiesMaster:
                begin
                    FldRef := RecRef.Field(1);
                    Contact.reset;
                    contact.setrange("No.", format(FldRef.Value));
                    if contact.FindFirst() then
                        Page.RunModal(0, contact);
                end;
        END;
    end;
}
