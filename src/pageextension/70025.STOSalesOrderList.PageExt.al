pageextension 70025 "STO Sales Order List" extends "Sales Order List"
{
    layout
    {
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
            StyleExpr = StyleText;
        }
        modify("Sell-to Customer Name")
        {
            StyleExpr = StyleText;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
        addafter("Shortcut Dimension 2 Code")
        {

            field("STO Shortcut Dimension 3 Code"; Rec."STO Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 3 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 4 Code"; Rec."STO Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 4 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 5 Code"; Rec."STO Shortcut Dimension 5 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 5 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 6 Code"; Rec."STO Shortcut Dimension 6 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 6 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 7 Code"; Rec."STO Shortcut Dimension 7 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 7 Code field.';
                Visible = false;
            }
            field("STO Shortcut Dimension 8 Code"; Rec."STO Shortcut Dimension 8 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the STO Shortcut Dimension 8 Code field.';
                Visible = false;
            }
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        addafter("Sell-to Customer Name")
        {

            field("PTA Enquiry Number"; Rec."PTA Enquiry Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Enquiry Number field.';
            }
            field("PTA Linked Deal No."; Rec."PTA Linked Deal No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Linked Deal No. field.';
            }
            field("PTA Assigned Invoice No."; Rec."PTA Assigned Invoice No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assigned Invoice No. field.';
            }
            field("PTA Vessel Name"; Rec."PTA Vessel Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA Vessel Name field.';
            }
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting No. field.';
            }

            field("PTA PARK Invoice"; Rec."PTA Parked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the PTA PARK Invoice field.';
            }
            field("PTA UnParked"; Rec."PTA UnParked")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the UnParked field.';
            }
            field("PTA Contract Dimension"; Rec."PTA Contract Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Contract Dimension field.';
            }
            field("PTA VAT Updated By BC"; Rec."PTA VAT Updated By BC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Updated By BC field.';
                Visible = false;
            }
            field("PTA unparked By"; Rec."PTA UnParked By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unparked By field.';
            }
            field("PTA Unparked DateTime"; Rec."PTA UnParked DateTime")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unparked DateTime field.';
                Visible = false;
            }

        }

        addfirst(factboxes)
        {
            part("PTA Enquiry Purchase List"; "PTA Enquiry Purchase List")
            {
                ApplicationArea = All;
                Caption = 'Trading Purchase Orders';
                SubPageLink = "Document Type" = Filter('Order'),
                              "PTA Enquiry ID" = field("PTA Enquiry ID");
            }
        }
    }


    actions
    {
        addfirst(Promoted)
        {
            actionref(PromotedPostUnparkedInvoices; PostUnparkedInvoices)
            { }
        }
        addfirst("F&unctions")
        {
            group(parkUnpark)
            {
                Caption = 'Park / UnPark';
                ShowAs = SplitButton;

                action(UnPark)
                {
                    ApplicationArea = All;
                    Caption = 'UnPark Invoices';
                    image = "Invoicing-MailCanceled";

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
                    begin
                        AreParametersPresent();

                        CurrPage.SetSelectionFilter(SalesHeader);
                        PTAEnquiryFunctions.UnparkSalesOrders(SalesHeader);
                    end;
                }
                action(Park)
                {
                    ApplicationArea = All;
                    Caption = 'Park Invoices';
                    image = "Invoicing-Cancel";

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        PTAEnquiryFunctions: Codeunit PTAEnquiryFunctions;
                    begin
                        AreParametersPresent();
                        CurrPage.SetSelectionFilter(SalesHeader);
                        PTAEnquiryFunctions.ParkSalesOrders(SalesHeader);
                    end;
                }
            }

        }
        addafter(Post)
        {
            action(PostUnparkedInvoices)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post Unparked Invoices';
                Ellipsis = true;
                Image = PostDocument;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    AreParametersPresent();
                    SalesHeader.Reset();
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetFilter("PTA Enquiry Number", '<>%1', 0);
                    SalesHeader.SetRange("PTA UnParked", true);
                    SalesHeader.SetFilter("Posting No.", '<>%1', '');
                    SalesHeader.SetFilter("PTA Contract Code", Rec.getfilter("PTA Contract Code"));
                    SalesHeader.SetFilter("Posting Date", Rec.getfilter("Posting Date"));
                    IF SalesHeader.FINDSET then
                        REPORT.RunModal(REPORT::"Batch Post Sales Orders", true, true, SalesHeader);
                    CurrPage.Update(false);
                end;
            }

        }
    }

    views
    {
        addfirst
        {
            view(PhysicalInvoice)
            {
                Caption = 'Physical Deals';
                Filters = where("Shortcut Dimension 1 Code" = filter('PHYSICAL SUPPLY'));
                SharedLayout = false;
                layout
                {

                }
            }
            view(ParkedInvoices)
            {
                Caption = 'Parked Invoices';
                Filters = where("PTA Parked" = const(true), "PTA UnParked" = const(false), "Posting No." = filter(<> ''));
                SharedLayout = false;
                layout
                {

                }
            }
            view(UnparkedInvoices)
            {
                Caption = 'Un-Parked Invoices';
                Filters = where("PTA Parked" = const(false), "PTA UnParked" = const(true), "Posting No." = filter(<> ''));
                SharedLayout = false;

                layout
                {

                }
            }
        }
    }

    Procedure AreParametersPresent()
    begin
        if Rec.GetFilter("PTA Contract Code") = '' then Error('Please select a Contract Dimension');
        if Rec.GetFilter("Posting Date") = '' then Error('Please select a Posting Date');
    end;

    trigger OnAfterGetRecord()
    begin
        StyleText := Rec.getParkedStyleText();
    end;

    var
        StyleText: Text;
}