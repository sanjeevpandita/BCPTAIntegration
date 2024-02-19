page 70033 PTAEnquiryList
{
    ApplicationArea = All;
    Caption = 'PTAEnquiryList';
    PageType = List;
    SourceTable = PTAEnquiry;
    UsageCategory = Lists;
    SourceTableView = SORTING(EntryNo) ORDER(Descending);
    CardPageId = "PTA Enquiry Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field(ID; Rec.ID)
                {
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field(EnquiryNumber; Rec.EnquiryNumber)
                {
                    Editable = false;
                    StyleExpr = StyleText;
                }
                field(BusinessAreaId; Rec.BusinessAreaId)
                {
                }
                field(BuyingCompanyId; Rec.BuyingCompanyId)
                {
                }
                field(TransactionBatchId; Rec.TransactionBatchId)
                {
                    ToolTip = 'Specifies the value of the BatchID field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }

                field(EnquiryBookID; Rec.EnquiryBookID)
                {
                }
                field(EnquiryDate; Rec.EnquiryDate)
                {
                }
                field(StatusId; Rec.StatusId)
                {
                }
                field(EnquirySupplyRegionID; Rec.EnquirySupplyRegionID)
                {
                }
                field(EnquiryTypeId; Rec.EnquiryTypeId)
                {
                }
                field(EnquiryPort; Rec.EnquiryPort)
                {
                }
                field(EnquiryDealType; Rec.EnquiryDealType)
                {
                }
                field(CustomerId; Rec.CustomerId)
                {
                }
                field(CustomerBrokerId; Rec.CustomerBrokerId)
                {
                }
                field(CustomerBrokerContactId; Rec.CustomerBrokerContactId)
                {
                }
                field(VesselId; Rec.VesselId)
                {
                }
                field(VesselName; Rec.VesselName)
                {
                }
                field(AgentId; Rec.AgentId)
                {
                }

                field(CreatedBy; Rec.CreatedBy)
                {
                }
                field(CreatonDate; Rec.CreatonDate)
                {
                }
                field(IsDoubleDeal1; Rec.IsDoubleDeal1)
                {
                }
                field(IsService; Rec.IsService)
                {
                }
            }
        }
        area(FactBoxes)
        {
            part("PTA Enquiry Sales Order"; "PTA Enquiry Sales Order")
            {
                ApplicationArea = All;
                Caption = 'Related Enquiry';
                SubPageLink = "Document Type" = Filter('Order'),
                              "PTA Enquiry ID" = field(ID);
            }
            part("PTA Enquiry Purchase List"; "PTA Enquiry Purchase List")
            {
                ApplicationArea = All;
                Caption = 'Trading Purchase Orders';
                SubPageLink = "Document Type" = Filter('Order'),
                              "PTA Enquiry ID" = field(ID);
            }
            part(PTAEnquiryError; PTAEnquiryError)
            {
                ApplicationArea = All;
                Caption = 'Enquiry Errors';
                SubPageLink = EnquiryID = field(ID), BatchID = field(TransactionBatchId), RecordEntryNo = field(EntryNo);
            }
        }
    }
    actions
    {
        Area(Promoted)
        {
            actionref(PromotedViewSalesOrder; ViewSalesOrder)
            {

            }
        }
        area(Processing)
        {
            action(ViewSalesOrder)
            {
                ApplicationArea = All;
                Caption = 'View Sales Order';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.reset;
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.setfilter("No.", '%1', Format(rec.EnquiryNumber));
                    if SalesHeader.FindFirst() then
                        Page.RunModal(0, SalesHeader)
                end;
            }
        }

    }

    views
    {
        view(ToProcess)
        {
            Caption = 'Enquiries to Process';
            Filters = where(Processed = filter(0));
            SharedLayout = false;
        }
        view(Error)
        {
            Caption = 'Enquiries in Error';
            Filters = where(Processed = filter(2));
            SharedLayout = false;
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleText := Rec.SetStyle();
    end;

    var
        StyleText: Text[30];
}