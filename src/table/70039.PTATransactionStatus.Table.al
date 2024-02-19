table 70039 "PTA Transaction Status"
{
    Caption = 'PTA Transaction Status';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Transaction Type"; Enum "PTA Enquiry Entities")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Transaction Document No."; code[50])
        {
            Caption = 'Transaction Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "Last Status"; enum "PTA Integration Status")
        {
            Caption = 'Last Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Last Record ID"; RecordId)
        {
            Caption = 'Last Record ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Error Message"; Text[1025])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Last Update Date/Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; Comments; text[2048])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Comments <> '' then
                    "Comment Details" := StrSubstNo('Added by %1 at %2', Copystr(UserId, StrPos(UserId, '\') + 1), FORMAT(TIME, 0, '<Hours24>.<Minutes,2>.<Seconds,2>'))
                else
                    "Comment Details" := '';
            end;
        }
        field(9; "Comment Details"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Manually Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Enquiry Number"; Integer)
        {

        }
    }
    keys
    {
        key(PK; "Transaction Type", "Transaction Document No.")
        {
            Clustered = true;
        }
        Key(CompanyName; "Company Name")
        {
        }
    }

    trigger OnInsert()
    begin
        "Last Update Date/Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Update Date/Time" := CurrentDateTime;
    end;


    procedure ShowRecord()
    var
        RecRef: RecordRef;
        PageManagement: Codeunit "Page Management";

    begin
        if not RecRef.Get("Last Record ID") then
            exit;
        RecRef.SetRecFilter();
        PageManagement.PageRun(RecRef);
    end;

    procedure SetStyle(): Text[30]
    begin
        if Rec."Last Status" = Rec."Last Status"::Error then
            Exit('Unfavorable')
        else
            if rec."Manually Processed" then
                Exit('Strong')
            else
                Exit('')
    end;

    procedure ShowBCRecord()
    var
        PageManagement: Codeunit "Page Management";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        custledgerentry: Record "Cust. Ledger Entry";
    begin
        case Rec."Transaction Type" of
            Rec."Transaction Type"::Enquiries:
                begin
                    SalesHeader.reset;
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.setfilter("No.", '%1', Format(Rec."Transaction Document No."));
                    if SalesHeader.FindFirst() then
                        Page.RunModal(0, SalesHeader)
                end;
            Rec."Transaction Type"::CustomerInvoice:
                begin
                    SalesInvoiceHeader.reset;
                    SalesInvoiceHeader.setfilter("No.", '%1', Format(Rec."Transaction Document No."));
                    if SalesInvoiceHeader.FindFirst() then
                        Page.RunModal(0, SalesInvoiceHeader)
                End;
            Rec."Transaction Type"::Voucher:
                begin
                    PurchInvHeader.reset;
                    PurchInvHeader.SetFilter("Vendor Invoice No.", Format(Rec."Transaction Document No."));
                    if PurchInvHeader.FindFirst() then
                        Page.RunModal(0, PurchInvHeader)
                end;
        END;
    end;
}
