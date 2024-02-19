table 70011 "PTAEnquiry"
{
    DataPerCompany = false;
    Caption = 'PTA Enquiry';
    DataClassification = CustomerContent;
    LookupPageId = PTAEnquiryList;
    DrillDownPageId = PTAEnquiryList;

    fields
    {
        field(20; ID; Integer)
        {
            Caption = 'ID';
        }

        field(150; EnquiryNumber; Integer)
        {
            Caption = 'EnquiryNumber';
        }
        field(160; BusinessAreaId; Integer)
        {
            Caption = 'BusinessAreaId';
        }
        field(180; EnquiryTypeId; Integer)
        {
            Caption = 'EnquiryTypeId';
        }
        field(190; StatusId; Integer)
        {
            Caption = 'StatusId';
        }
        field(200; VesselId; Integer)
        {
            Caption = 'VesselId';
        }
        field(210; BuyingCompanyId; Integer)
        {
            Caption = 'BuyingCompanyId';
        }
        field(220; SellingCompanyId; Integer)
        {
            Caption = 'SellingCompanyId';
        }
        field(230; BrokingCompanyId; Integer)
        {
            Caption = 'BrokingCompanyId';
        }
        field(240; CustomerTraderId; Integer)
        {
            Caption = 'CustomerTraderId';
        }
        field(250; SupplierTraderId; Integer)
        {
            Caption = 'SupplierTraderId';
        }
        field(260; CustomerId; Integer)
        {
            Caption = 'CustomerId';
        }
        field(270; CustomerContactId; Integer)
        {
            Caption = 'CustomerContactId';
        }
        field(280; CustomerBrokerId; Integer)
        {
            Caption = 'CustomerBrokerId';
        }
        field(290; CustomerBrokerContactId; Integer)
        {
            Caption = 'CustomerBrokerContactId';
        }
        field(300; CustomerContractId; Integer)
        {
            Caption = 'CustomerContractId';
        }
        field(310; CustomerPaymentTermId; Integer)
        {
            Caption = 'CustomerPaymentTermId';
        }
        field(320; EnquiryDealType; Integer)
        {
            Caption = 'EnquiryDealType';
        }
        field(330; SellingOrderId; Integer)
        {
            Caption = 'SellingOrderId';
        }
        field(340; BuyingOrderId; Integer)
        {
            Caption = 'BuyingOrderId';
        }
        field(350; BrokingOrderId; Integer)
        {
            Caption = 'BrokingOrderId';
        }
        field(360; SellOfficeId; Integer)
        {
            Caption = 'SellOfficeId';
        }
        field(370; BuyOfficeId; Integer)
        {
            Caption = 'BuyOfficeId';
        }
        field(380; AgentId; Integer)
        {
            Caption = 'AgentId';
        }
        field(390; AgentContactId; Integer)
        {
            Caption = 'AgentContactId';
        }
        field(400; IsCustomerNotified; Boolean)
        {
            Caption = 'IsCustomerNotified';
        }
        field(410; IsAgentAppointed; Boolean)
        {
            Caption = 'IsAgentAppointed';
        }
        field(420; IsSupplierNotified; Boolean)
        {
            Caption = 'IsSupplierNotified';
        }
        field(430; EnquiryDate; DateTime)
        {
            Caption = 'EnquiryDate';
        }
        field(431; CreatonDate; DateTime)
        {
            Caption = 'CreatonDate';
        }
        field(440; IsContractDeal; Boolean)
        {
            Caption = 'IsContractDeal';
        }
        field(450; ContractName; Text[1000])
        {
            Caption = 'ContractName';
        }
        field(460; IsExWharfDeal; Boolean)
        {
            Caption = 'IsExWharfDeal';
        }
        field(470; ParentDeal; Integer)
        {
            Caption = 'ParentDeal';
        }
        field(480; CreditApprovalDate; DateTime)
        {
            Caption = 'CreditApprovalDate';
        }
        field(490; BrokingEnquiryNumber; BigInteger)
        {
            Caption = 'BrokingEnquiryNumber';
        }
        field(500; BDRLastReminderDate; DateTime)
        {
            Caption = 'BDRLastReminderDate';
        }
        field(510; IsService; Boolean)
        {
            Caption = 'IsService';
        }
        field(520; IsCustomerPaidInAdvance; Boolean)
        {
            Caption = 'IsCustomerPaidInAdvance';
        }
        field(530; PartialStatus; Integer)
        {
            Caption = 'PartialStatus';
        }
        field(540; VesselName; Text[1000])
        {
            Caption = 'VesselName';
        }
        field(550; SupplierId; Integer)
        {
            Caption = 'SupplierId';
        }
        field(560; SupplierContactId; Integer)
        {
            Caption = 'SupplierContactId';
        }
        field(570; SupplierPaymentTermId; Integer)
        {
            Caption = 'SupplierPaymentTermId';
        }
        field(580; SupplierDeliveryTypeId; Integer)
        {
            Caption = 'SupplierDeliveryTypeId';
        }
        field(590; SupplierContractId; Integer)
        {
            Caption = 'SupplierContractId';
        }
        field(600; IsDoubleDeal1; Boolean)
        {
            Caption = 'IsDoubleDeal1';
        }
        field(610; IsDoubleDeal2; Boolean)
        {
            Caption = 'IsDoubleDeal2';
        }
        field(620; LinkedDealId; Integer)
        {
            Caption = 'LinkedDealId';
        }
        field(630; IsDeliveredFromBargeMovement; Boolean)
        {
            Caption = 'IsDeliveredFromBargeMovement';
        }
        field(640; CreatedBy; Integer)
        {
            Caption = 'CreatedBy';
        }
        field(650; EnquiryPort; Integer)
        {
            Caption = 'EnquiryPort';
        }

        field(653; EnquirySupplyRegionID; Integer)
        {
            Caption = 'EnquirySupplyRegionID';
        }
        field(654; EnquiryBookID; Integer)
        {
            Caption = 'EnquiryBookID';
        }
        field(655; IsApplicableForSalesTax; Boolean)
        {
            Caption = 'IsApplicableForSalesTax';
        }

        field(657; EnquiryPortID; Integer)
        {
            Caption = 'EnquiryPortID';
        }
        field(658; DeliveryDate; Date)
        {
            Caption = 'DeliveryDate';
        }
        field(659; PortId; Integer)
        {
            Caption = 'PortId';
        }
        field(660; ETA; DateTime)
        {
            Caption = 'ETA';
        }
        field(662; ETD; DateTime)
        {
            Caption = 'ETD';
        }
        field(663; LinkedDealNumber; Integer)
        {
            Caption = 'LinkedDealNumber';
        }
        Field(1000; TransactionBatchId; integer)
        {
            Caption = 'TransactionBatchId';
        }
        field(50000; EntryNo; Integer)
        {
            AutoIncrement = true;
            Caption = 'EntryNo';
        }
        field(50001; Processed; Integer)
        {
            Caption = 'Processed';
        }
        field(50002; ProcessedDateTime; DateTime)
        {
            Caption = 'ProcessedDateTime';
        }
        field(50003; ErrorMessage; Text[250])
        {
            Caption = 'ErrorMessage';
        }
        field(50004; ErrorDateTime; DateTime)
        {
            Caption = 'ErrorDateTime';
        }
        field(50006; isDeleted; Boolean)
        {
            Caption = 'isDeleted';
        }
        field(95000; "Error Exists"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(PTAEnquiryError where(EntityType = filter(Enquiries | Products | AdditionalCosts | AdditionalServices), EnquiryID = field(id), BatchID = field(TransactionBatchId)));
            Editable = false;
            Caption = 'Error Exists';
        }

        field(95001; "No. Of Product Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAEnquiryProducts where(EnquiryID = field(id), TransactionBatchId = field(TransactionBatchId)));
            Editable = false;
        }
        field(95002; "No. Of Service Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAEnquiryAddServices where(EnquiryID = field(id), TransactionBatchId = field(TransactionBatchId)));
            Editable = false;
        }
        field(9500; "No. Of Cost Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAEnquiryAdditionalCost where(EnquiryID = field(id), TransactionBatchId = field(TransactionBatchId)));
            Editable = false;
        }
    }


    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
        key(EnquiryID; ID, TransactionBatchId)
        {
        }

    }

    fieldgroups
    {
    }

    procedure SetStyle(): Text[30]
    begin
        if Rec.Processed = 2 then
            Exit('Unfavorable')
        else
            Exit('')
    end;

    trigger OnDelete()
    var
        PTAEnquiryProducts: Record PTAEnquiryProducts;
        PTAEnquiryAdditionalCost: Record PTAEnquiryAdditionalCost;
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        PTAEnquiryError: Record PTAEnquiryError;
    begin

        PTAEnquiryProducts.reset;
        PTAEnquiryProducts.SetRange(EnquiryId, rec.ID);
        PTAEnquiryProducts.SetRange(TransactionBatchId, rec.TransactionBatchId);
        PTAEnquiryProducts.DeleteAll();

        PTAEnquiryAdditionalCost.reset;
        PTAEnquiryAdditionalCost.SetRange(EnquiryId, rec.ID);
        PTAEnquiryAdditionalCost.SetRange(TransactionBatchId, rec.TransactionBatchId);
        PTAEnquiryAdditionalCost.DeleteAll();

        PTAEnquiryAddServices.reset;
        PTAEnquiryAddServices.SetRange(EnquiryId, rec.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, rec.TransactionBatchId);
        PTAEnquiryAddServices.DeleteAll();

        PTAEnquiryError.reset;
        PTAEnquiryError.SetRange(EnquiryId, rec.ID);
        PTAEnquiryError.SetRange(BatchID, rec.TransactionBatchId);
        PTAEnquiryError.DeleteAll();
    end;

    procedure HasVATAmount(): Boolean
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        PTASetup: Record "PTA Setup";
    begin
        PTASetup.get();
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, Rec.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTAEnquiryAddServices.SetRange("Is VAT/GST Service", true);
        EXIT(PTAEnquiryAddServices.FindFirst())
    end;

    procedure GetSellVATAmount(): Decimal
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        TotalSellVat, VatSellRate : Decimal;
    begin
        VatSellRate := 0;
        TotalSellVat := 0;
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, Rec.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTAEnquiryAddServices.SetRange("Is VAT/GST Service", true);
        if PTAEnquiryAddServices.FindSet() then
            repeat
                Evaluate(VatSellRate, PTAEnquiryAddServices.SellRate);
                TotalSellVat += VatSellRate;
            Until PTAEnquiryAddServices.next = 0;
        exit(TotalSellVat);
    end;

    procedure GetBuyVATAmount(VarSupplierID: Integer): Decimal
    var
        PTAEnquiryAddServices: Record PTAEnquiryAddServices;
        TotalBuyVat, VatBuyRate : Decimal;
    begin
        VatBuyRate := 0;
        TotalBuyVat := 0;
        PTAEnquiryAddServices.Reset();
        PTAEnquiryAddServices.SetAutoCalcFields("Is VAT/GST Service");
        PTAEnquiryAddServices.SetCurrentKey(EnquiryId, TransactionBatchId);
        PTAEnquiryAddServices.SetRange(EnquiryId, Rec.ID);
        PTAEnquiryAddServices.SetRange(TransactionBatchId, Rec.TransactionBatchId);
        PTAEnquiryAddServices.SetRange("Is VAT/GST Service", true);
        PTAEnquiryAddServices.SetRange(SupplierID, VarSupplierID);
        if PTAEnquiryAddServices.FindSet() then
            repeat
                Evaluate(VatBuyRate, PTAEnquiryAddServices.BuyRate);
                TotalBuyVat += VatBuyRate;
            Until PTAEnquiryAddServices.next = 0;
        exit(TotalBuyVat);
    end;
}

