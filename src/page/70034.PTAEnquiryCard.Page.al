page 70034 "PTA Enquiry Card"
{
    ApplicationArea = All;
    Caption = 'PTA Enquiry Card';
    PageType = Card;
    SourceTable = PTAEnquiry;
    Editable = true; //TODO

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    editable = false;
                }
                field(EnquiryNumber; Rec.EnquiryNumber)
                {
                    ToolTip = 'Specifies the value of the EnquiryNumber field.';
                    editable = false;
                }
                field(EnquiryBookID; Rec.EnquiryBookID)
                {
                    ToolTip = 'Specifies the value of the EnquiryBookID field.';
                    editable = false;
                }
                field(EnquiryDate; Rec.EnquiryDate)
                {
                    ToolTip = 'Specifies the value of the EnquiryDate field.';
                    editable = false;
                }
                field(EnquiryDealType; Rec.EnquiryDealType)
                {
                    ToolTip = 'Specifies the value of the EnquiryDealType field.';
                    editable = false;
                }
                field(EnquiryPort; Rec.EnquiryPort)
                {
                    ToolTip = 'Specifies the value of the EnquiryPort field.';
                    editable = false;
                }
                field(EnquirySupplyRegionID; Rec.EnquirySupplyRegionID)
                {
                    ToolTip = 'Specifies the value of the EnquirySupplyRegionID field.';
                    editable = false;
                }
                field(EnquiryTypeId; Rec.EnquiryTypeId)
                {
                    ToolTip = 'Specifies the value of the EnquiryTypeId field.';
                    editable = false;
                }
                field(BrokingCompanyId; Rec.BrokingCompanyId)
                {
                    ToolTip = 'Specifies the value of the BrokingCompanyId field.';
                    editable = false;
                }
                field(BrokingEnquiryNumber; Rec.BrokingEnquiryNumber)
                {
                    ToolTip = 'Specifies the value of the BrokingEnquiryNumber field.';
                    editable = false;
                }
                field(BrokingOrderId; Rec.BrokingOrderId)
                {
                    ToolTip = 'Specifies the value of the BrokingOrderId field.';
                    editable = false;
                }
                field(BusinessAreaId; Rec.BusinessAreaId)
                {
                    ToolTip = 'Specifies the value of the BusinessAreaId field.';
                    editable = false;
                }
                field(BuyOfficeId; Rec.BuyOfficeId)
                {
                    ToolTip = 'Specifies the value of the BuyOfficeId field.';
                    editable = false;
                }
                field(BuyingCompanyId; Rec.BuyingCompanyId)
                {
                    ToolTip = 'Specifies the value of the BuyingCompanyId field.';
                    editable = false;
                }
                field(BuyingOrderId; Rec.BuyingOrderId)
                {
                    ToolTip = 'Specifies the value of the BuyingOrderId field.';
                    editable = false;
                }
                field(CreditApprovalDate; Rec.CreditApprovalDate)
                {
                    ToolTip = 'Specifies the value of the CreditApprovalDate field.';
                    editable = false;
                }
                field(SellOfficeId; Rec.SellOfficeId)
                {
                    ToolTip = 'Specifies the value of the SellOfficeId field.';
                    editable = false;
                }
                field(SellingCompanyId; Rec.SellingCompanyId)
                {
                    ToolTip = 'Specifies the value of the SellingCompanyId field.';
                    editable = false;
                }
                field(SellingOrderId; Rec.SellingOrderId)
                {
                    ToolTip = 'Specifies the value of the SellingOrderId field.';
                    editable = false;
                }
                field(ContractName; Rec.ContractName)
                {
                    ToolTip = 'Specifies the value of the ContractName field.';
                    editable = false;
                }

                field(LinkedDealId; Rec.LinkedDealId)
                {
                    ToolTip = 'Specifies the value of the LinkedDealId field.';
                    editable = false;
                }
                field(ParentDeal; Rec.ParentDeal)
                {
                    ToolTip = 'Specifies the value of the ParentDeal field.';
                    editable = false;
                }
                field(StatusId; Rec.StatusId)
                {
                    ToolTip = 'Specifies the value of the StatusId field.';
                    editable = false;
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                    MultiLine = true;
                    editable = false;
                }

            }
            part(PTAEnquiryProducts; PTAEnquiryProducts)
            {
                Caption = 'Products';
                SubPageLink = EnquiryId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part(PTAEnquiryError; PTAEnquiryError)
            {
                ApplicationArea = All;
                Caption = 'Enquiry Errors';
                SubPageLink = EntityType = filter(Enquiries | Products | AdditionalCosts | AdditionalServices), EnquiryID = field(ID), BatchID = field(TransactionBatchId), HeaderEntryNo = field(EntryNo);
            }
            part("PTA Enquiry Additional Costs"; "PTA Enquiry Additional Costs")
            {
                Caption = 'Additional Costs';
                SubPageLink = EnquiryId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            part("PTA Enquiry Add. Service"; "PTA Enquiry Add. Service")
            {
                Caption = 'Additional Services';
                SubPageLink = EnquiryId = field(ID), TransactionBatchId = field(TransactionBatchId);
                ApplicationArea = all;
                UpdatePropagation = Both;
            }
            // part("PTA Enquiry Ports"; "PTA Enquiry Ports")
            // {
            //     Caption = 'Ports';
            //     SubPageLink = EnquiryId = field(ID), BatchID = field(TransactionBatchId);
            //     ApplicationArea = all;
            //     UpdatePropagation = Both;
            // }

            group(Customer)
            {
                Caption = 'Customer';

                field(CustomerBrokerContactId; Rec.CustomerBrokerContactId)
                {
                    ToolTip = 'Specifies the value of the CustomerBrokerContactId field.';
                    editable = false;
                }
                field(CustomerBrokerId; Rec.CustomerBrokerId)
                {
                    ToolTip = 'Specifies the value of the CustomerBrokerId field.';
                    editable = false;
                }
                field(CustomerContactId; Rec.CustomerContactId)
                {
                    ToolTip = 'Specifies the value of the CustomerContactId field.';
                    editable = false;
                }
                field(CustomerContractId; Rec.CustomerContractId)
                {
                    ToolTip = 'Specifies the value of the CustomerContractId field.';
                    editable = false;
                }
                field(CustomerId; Rec.CustomerId)
                {
                    ToolTip = 'Specifies the value of the CustomerId field.';
                    editable = false;
                }
                field(CustomerPaymentTermId; Rec.CustomerPaymentTermId)
                {
                    ToolTip = 'Specifies the value of the CustomerPaymentTermId field.';
                    editable = false;
                }
                field(CustomerTraderId; Rec.CustomerTraderId)
                {
                    ToolTip = 'Specifies the value of the CustomerTraderId field.';
                    editable = false;
                }
                field(BDRLastReminderDate; Rec.BDRLastReminderDate)
                {
                    ToolTip = 'Specifies the value of the BDRLastReminderDate field.';
                    editable = false;
                }
                field(AgentContactId; Rec.AgentContactId)
                {
                    ToolTip = 'Specifies the value of the AgentContactId field.';
                    editable = false;
                }
                field(AgentId; Rec.AgentId)
                {
                    ToolTip = 'Specifies the value of the AgentId field.';
                    editable = false;
                }
                field(BatchID; Rec.TransactionBatchId)
                {
                    ToolTip = 'Specifies the value of the BatchID field.';
                    editable = false;
                }
            }
            group(Supplier)
            {
                Caption = 'Supplier';

                field(SupplierContactId; Rec.SupplierContactId)
                {
                    ToolTip = 'Specifies the value of the SupplierContactId field.';
                    editable = false;
                }
                field(SupplierContractId; Rec.SupplierContractId)
                {
                    ToolTip = 'Specifies the value of the SupplierContractId field.';
                    editable = false;
                }
                field(SupplierDeliveryTypeId; Rec.SupplierDeliveryTypeId)
                {
                    ToolTip = 'Specifies the value of the SupplierDeliveryTypeId field.';
                    editable = false;
                }
                field(SupplierId; Rec.SupplierId)
                {
                    ToolTip = 'Specifies the value of the SupplierId field.';
                    editable = false;
                }
                field(SupplierPaymentTermId; Rec.SupplierPaymentTermId)
                {
                    ToolTip = 'Specifies the value of the SupplierPaymentTermId field.';
                    editable = false;
                }
                field(SupplierTraderId; Rec.SupplierTraderId)
                {
                    ToolTip = 'Specifies the value of the SupplierTraderId field.';
                    editable = false;
                }
                field(VesselId; Rec.VesselId)
                {
                    ToolTip = 'Specifies the value of the VesselId field.';
                    editable = false;
                }
                field(VesselName; Rec.VesselName)
                {
                    ToolTip = 'Specifies the value of the VesselName field.';
                    editable = false;
                }
            }
            group(Attributes)
            {
                Caption = 'Attributes';
                field(IsDoubleDeal1; Rec.IsDoubleDeal1)
                {
                    ToolTip = 'Specifies the value of the IsDoubleDeal1 field.';
                    editable = false;
                }
                field(IsDoubleDeal2; Rec.IsDoubleDeal2)
                {
                    ToolTip = 'Specifies the value of the IsDoubleDeal2 field.';
                    editable = false;
                }
                field(IsExWharfDeal; Rec.IsExWharfDeal)
                {
                    ToolTip = 'Specifies the value of the IsExWharfDeal field.';
                    editable = false;
                }
                field(IsService; Rec.IsService)
                {
                    ToolTip = 'Specifies the value of the IsService field.';
                    editable = false;
                }
                field(IsSupplierNotified; Rec.IsSupplierNotified)
                {
                    ToolTip = 'Specifies the value of the IsSupplierNotified field.';
                    editable = false;
                }
                field(IsAgentAppointed; Rec.IsAgentAppointed)
                {
                    ToolTip = 'Specifies the value of the IsAgentAppointed field.';
                    editable = false;
                }
                field(IsContractDeal; Rec.IsContractDeal)
                {
                    ToolTip = 'Specifies the value of the IsContractDeal field.';
                    editable = false;
                }
                field(IsCustomerNotified; Rec.IsCustomerNotified)
                {
                    ToolTip = 'Specifies the value of the IsCustomerNotified field.';
                    editable = false;
                }
                field(IsCustomerPaidInAdvance; Rec.IsCustomerPaidInAdvance)
                {
                    ToolTip = 'Specifies the value of the IsCustomerPaidInAdvance field.';
                    editable = false;
                }
                field(isDeleted; Rec.isDeleted)
                {
                    ToolTip = 'Specifies the value of the isDeleted field.';
                    editable = false;
                }
                field(IsDeliveredFromBargeMovement; Rec.IsDeliveredFromBargeMovement)
                {
                    ToolTip = 'Specifies the value of the IsDeliveredFromBargeMovement field.';
                    editable = false;
                }
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
}
