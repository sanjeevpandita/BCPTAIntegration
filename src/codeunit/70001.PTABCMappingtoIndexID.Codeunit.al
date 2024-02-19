codeunit 70001 "PTA BC Mapping to IndexID"
{
    trigger OnRun()
    begin

    end;

    procedure GetCurrencyCodeByPTAIndexID(PTAIndexID: Integer): code[10];
    var
        Currency: Record "Currency";
    begin
        if PTAIndexID = 0 then exit('');

        Currency.RESET;
        Currency.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Currency.SETRANGE("PTA Index Link", PTAIndexID);
        Currency.SetRange("PTA IsDeleted", false);
        if Currency.FindLast() then
            exit(Currency.Code)
        else
            exit('');
    end;

    procedure GetUnitOfMeasureCodeByPTAIndex(PTAIndexID: Integer): Code[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        UnitOfMeasure.Reset();
        UnitOfMeasure.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        UnitOfMeasure.SetRange("PTA Index Link", PTAIndexID);
        UnitOfMeasure.SetRange("PTA IsDeleted", false);
        if UnitOfMeasure.findlast() then
            exit(UnitOfMeasure.Code)
        else
            exit('');
    end;

    procedure GetExpenseClaimStatusByPTAIndexID(PTAIndexID: Integer): text[100]
    var
        PTAExpenseClaimStatusMaster: Record PTAExpenseClaimStatusMaster;
    begin
        if PTAIndexID = 0 then exit('');

        PTAExpenseClaimStatusMaster.RESET;
        PTAExpenseClaimStatusMaster.SETRANGE(ID, PTAIndexID);
        if PTAExpenseClaimStatusMaster.findlast then
            exit(PTAExpenseClaimStatusMaster.ExpenseClaimStatus)
        else
            exit('');
    end;

    procedure GetPTAExpenseCategoryByPTAIndexID(PTAIndexID: Integer): text[100]
    var
        PTAExpenseCategoryMaster: Record PTAExpenseCategoryMaster;
    begin
        if PTAIndexID = 0 then exit('');

        PTAExpenseCategoryMaster.RESET;
        PTAExpenseCategoryMaster.SETRANGE(ID, PTAIndexID);
        if PTAExpenseCategoryMaster.findlast then
            exit(PTAExpenseCategoryMaster.ExpenseCategory)
        else
            exit('');
    end;

    procedure GetShipmentMethodFromDeliveryTypeID(PTAIndexID: Integer): Code[10]
    var
        ShipmentMethod: Record "Shipment Method";
    begin
        if PTAIndexID = 0 then exit('');

        ShipmentMethod.Reset();
        ShipmentMethod.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        ShipmentMethod.SetRange("PTA Index Link", PTAIndexID);
        ShipmentMethod.SetRange("PTA IsDeleted", false);
        if ShipmentMethod.findlast() then
            exit(ShipmentMethod.Code)
        else
            exit('');
    end;

    procedure GetItemFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        Item: Record Item;
    begin
        if PTAIndexID = 0 then exit('');

        Item.Reset();
        Item.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Item.SetRange("PTA Index Link", PTAIndexID);
        Item.SetRange("PTA IsDeleted", false);
        if Item.findlast() then
            exit(Item."No.")
        else
            exit('');
    end;

    procedure GetLocationFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        Location: Record Location;
    begin
        if PTAIndexID = 0 then exit('');

        Location.Reset();
        Location.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Location.SetRange("PTA Index Link", PTAIndexID);
        Location.SetRange("PTA IsDeleted", false);
        if Location.findlast() then
            exit(Location.Code)
        else
            exit('');
    end;

    procedure GetSalespersonFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if PTAIndexID = 0 then exit('');

        Salesperson.Reset();
        Salesperson.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Salesperson.SetRange("PTA Index Link", PTAIndexID);
        Salesperson.SetRange("PTA IsDeleted", false);
        if Salesperson.findlast() then
            exit(Salesperson.Code)
        else
            exit('');
    end;

    procedure GetAdditionalCostIDFromAdditionalCostDetails(PTAIndexID: Integer): Integer
    var
        PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster;
    begin
        if PTAIndexID = 0 then exit(0);

        PTAAddCostDetailsMaster.RESET;
        PTAAddCostDetailsMaster.SETRANGE(AdditionalCostDetailID, PTAIndexID);
        if PTAAddCostDetailsMaster.findlast then
            exit(PTAAddCostDetailsMaster.AdditionalCostID)
        else
            exit(0);
    end;

    procedure GetCostTypeFromAdditionalCostsID(AdditionalCostID: Integer): Integer
    var
        PTAAdditionalCostsMaster: Record PTAAdditionalCostsMaster;
    begin
        if AdditionalCostID = 0 then exit(0);

        PTAAdditionalCostsMaster.RESET;
        PTAAdditionalCostsMaster.SETRANGE(Id, AdditionalCostID);
        if PTAAdditionalCostsMaster.findlast then
            exit(PTAAdditionalCostsMaster.CostTypeId)
        else
            exit(0);
    end;

    procedure GetPTACostTypeNameByCostTypeId(CostTypeId: Integer): text[100]
    var
        PTACostTypeMaster: Record PTACostTypeMaster;
    begin
        if CostTypeId = 0 then exit('');

        PTACostTypeMaster.RESET;
        PTACostTypeMaster.SETRANGE(ID, CostTypeId);
        if PTACostTypeMaster.findlast then
            exit(PTACostTypeMaster.Name)
        else
            exit('');
    end;

    procedure GetBusinessAreaDimensionByPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        PTASetup: Record "PTA Setup";
        DimensionValue: Record "Dimension Value";
    begin
        if PTAIndexID = 0 then exit('');

        PTASetup.Get();
        PTASetup.TestField("Business Area Dimension");

        DimensionValue.Reset();
        DimensionValue.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        DimensionValue.SetRange("Dimension Code", PTASetup."Business Area Dimension");
        DimensionValue.SetRange("PTA Index Link", PTAIndexID);
        DimensionValue.SetRange("PTA IsDeleted", false);
        If DimensionValue.findlast() then
            Exit(DimensionValue.Code)
        else
            exit('');
    end;

    procedure GetOfficeDimensionByPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        PTASetup: Record "PTA Setup";
        DimensionValue: Record "Dimension Value";
    begin
        if PTAIndexID = 0 then exit('');

        PTASetup.Get();
        if PTASetup."Office Dimension Code" = '' then exit('');

        DimensionValue.Reset();
        DimensionValue.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        DimensionValue.SetRange("Dimension Code", PTASetup."Office Dimension Code");
        DimensionValue.SetRange("PTA Index Link", PTAIndexID);
        DimensionValue.SetRange("PTA IsDeleted", false);
        If DimensionValue.findlast() then
            Exit(DimensionValue.Code)
        else
            exit('');
    end;

    procedure GetSupplyMarketDimensionByPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        PTASetup: Record "PTA Setup";
        DimensionValue: Record "Dimension Value";
    begin
        if PTAIndexID = 0 then exit('');

        PTASetup.Get();
        PTASetup.TestField("Supply Market Dimension");

        DimensionValue.Reset();
        DimensionValue.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        DimensionValue.SetRange("Dimension Code", PTASetup."Supply Market Dimension");
        DimensionValue.SetRange("PTA Index Link", PTAIndexID);
        DimensionValue.SetRange("PTA IsDeleted", false);
        If DimensionValue.findlast() then
            Exit(DimensionValue.Code)
        else
            exit('');
    end;

    procedure GetSupplyContractDimensionByPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        PTASetup: Record "PTA Setup";
        DimensionValue: Record "Dimension Value";
    begin
        PTASetup.Get();
        PTASetup.TestField("Supply Market Dimension");

        DimensionValue.Reset();
        DimensionValue.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        DimensionValue.SetRange("Dimension Code", PTASetup."Supply Contract Dimension");
        DimensionValue.SetRange("PTA Index Link", PTAIndexID);
        DimensionValue.SetRange("PTA IsDeleted", false);
        If DimensionValue.findfirst() then
            Exit(DimensionValue.Code)
        else
            exit('');
    end;
    //DimensionMappingChanged
    // procedure GetSupplyRegionDimensionByPTAIndexID(PTAIndexID: Integer): Code[20]
    // var
    //     PTASetup: Record "PTA Setup";
    //     DimensionValue: Record "Dimension Value";
    // begin
    //     if PTAIndexID = 0 then exit('');

    //     PTASetup.Get();
    //     //PTASetup.TestField("Supply Region Dimension");
    //     PTASetup.TestField("Supply Market Dimension");

    //     DimensionValue.Reset();
    //     DimensionValue.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
    //     //DimensionValue.SetRange("Dimension Code", PTASetup."Supply Region Dimension");
    //     DimensionValue.SetRange("Dimension Code", PTASetup."Supply Market Dimension");
    //     DimensionValue.SetRange("PTA Index Link", PTAIndexID);
    //     DimensionValue.SetRange("PTA IsDeleted", false);
    //     If DimensionValue.findlast() then
    //         Exit(DimensionValue.Code)
    //     else
    //         exit('');
    // end;

    procedure GetPostCodeByPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        PostCode: Record "Post Code";
    begin
        if PTAIndexID = 0 then exit('');

        PostCode.Reset();
        PostCode.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        PostCode.SetRange("PTA Index Link", PTAIndexID);
        PostCode.SetRange("PTA IsDeleted", false);
        if PostCode.findlast() then
            exit(PostCode.City)
        else
            exit('');
    end;

    procedure GetCountryCodeByPTAIndexID(PTAIndexID: Integer): Code[10]
    var
        CountryRegion: Record "Country/Region";
    begin
        if PTAIndexID = 0 then exit('');

        CountryRegion.Reset();
        CountryRegion.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        CountryRegion.SetRange("PTA Index Link", PTAIndexID);
        CountryRegion.SetRange("PTA IsDeleted", false);
        if CountryRegion.findlast() then
            exit(CountryRegion.Code)
        else
            exit('');
    end;

    procedure GetCityCodeByPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        PostCode: Record "Post Code";
    begin
        if PTAIndexID = 0 then exit('');

        PostCode.Reset();
        PostCode.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        PostCode.SetRange("PTA Index Link", PTAIndexID);
        PostCode.SetRange("PTA IsDeleted", false);
        if PostCode.findlast() then
            exit(PostCode.Code)
        else
            exit('');
    end;

    procedure GetCompanOfficeNameFromOffice(OfficeID: Integer): Text[100]
    var
        PTACompanyOfficesMaster: Record PTACompanyOfficesMaster;
    begin
        if OfficeID = 0 then exit('');

        PTACompanyOfficesMaster.Reset();
        PTACompanyOfficesMaster.SetRange(Id, OfficeID);
        if PTACompanyOfficesMaster.FindLast() then
            exit(PTACompanyOfficesMaster.Name)
        else
            exit('');
    end;

    procedure GetItemCategoryByPTAIndex(PTAIndexID: Integer): Code[20]
    var
        ItemCategory: Record "Item Category";
    begin
        if PTAIndexID = 0 then exit('');

        ItemCategory.Reset();
        ItemCategory.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        ItemCategory.SetRange("PTA Index Link", PTAIndexID);
        ItemCategory.SetRange("PTA IsDeleted", false);
        if ItemCategory.findlast() then
            exit(ItemCategory.Code)
        else
            exit('');
    end;

    procedure PTAProductTypeMasterExists(PTAIndexID: Integer): Boolean
    var
        PTAProductTypeMaster: Record PTAProductTypeMaster;
    begin
        if PTAIndexID = 0 then exit(false);

        PTAProductTypeMaster.Reset();
        PTAProductTypeMaster.SetRange(Id, PTAIndexID);
        PTAProductTypeMaster.setrange(IsDeleted, false);
        Exit(NOT PTAProductTypeMaster.IsEmpty)
    end;

    procedure GetPTAAddressbyID(PTAAddressID: Integer; var PTAAddressesMaster: Record PTAAddressesMaster)
    var
        ModifyPTAAddressesMaster: Record PTAAddressesMaster;
    begin
        PTAAddressesMaster.Reset();
        PTAAddressesMaster.SetCurrentKey("ID");
        PTAAddressesMaster.SetRange(Id, PTAAddressID);
        PTAAddressesMaster.setrange(IsDeleted, false);
        if Not PTAAddressesMaster.FindLast() then
            PTAAddressesMaster.Init()
        else begin
            PTAAddressesMaster.SetRange(Processed, 0);
            if PTAAddressesMaster.FindSet() then begin
                PTAAddressesMaster.ModifyAll(Processed, 0);
                PTAAddressesMaster.ModifyAll(ProcessedDateTime, CurrentDateTime);
            end;
            //if PTAAddressesMaster.Processed = 0 then begin
            // ModifyPTAAddressesMaster := PTAAddressesMaster;
            // ModifyPTAAddressesMaster.Processed := 1;
            // ModifyPTAAddressesMaster.ProcessedDateTime := CurrentDateTime;
            // ModifyPTAAddressesMaster.Modify();
            //end;
        end;
    end;

    procedure GetServiceResourceFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        Resource: Record Resource;
    begin
        if PTAIndexID = 0 then exit('');

        Resource.Reset();
        Resource.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Resource.SetRange("PTA Index Link", PTAIndexID);
        Resource.SetRange("PTA IsDeleted", false);
        Resource.SetRange("PTA Resource Type", Resource."PTA Resource Type"::"Additional Service");
        if Resource.findlast() then
            exit(Resource."No.")
        else
            exit('');
    end;

    procedure GetAdditionalCostResourceFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        Resource: Record Resource;
    begin
        if PTAIndexID = 0 then exit('');

        Resource.Reset();
        Resource.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Resource.SetRange("PTA Index Link", PTAIndexID);
        Resource.SetRange("PTA IsDeleted", false);
        Resource.SetRange("PTA Resource Type", Resource."PTA Resource Type"::"Additional Cost");
        if Resource.findlast() then
            exit(Resource."No.")
        else
            exit('');
    end;

    procedure GetCostTypeResourceFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        Resource: Record Resource;
    begin
        if PTAIndexID = 0 then exit('');

        Resource.Reset();
        Resource.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Resource.SetRange("PTA Index Link", PTAIndexID);
        Resource.SetRange("PTA IsDeleted", false);
        Resource.SetRange("PTA Resource Type", Resource."PTA Resource Type"::"Cost Type");
        if Resource.findlast() then
            exit(Resource."No.")
        else
            exit('');
    end;

    procedure GetBankAccountFromPTAIndexID(PTAIndexID: Integer): Code[20]
    var
        BankAccount: Record "Bank Account";
    begin
        if PTAIndexID = 0 then exit('');

        BankAccount.Reset();
        BankAccount.SetCurrentKey("PTA Index Link");
        BankAccount.SetRange("PTA Index Link", PTAIndexID);
        if BankAccount.findlast() then
            exit(BankAccount."No.")
        else
            exit('');
    end;

    procedure GetConversionFactorByUOM(UOMCode: Code[10]): Decimal
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.get(UOMCode) then
            exit(UnitOfMeasure."PTA ConversionFactor")
        else
            exit(1);
    end;

    procedure GetCustomerCodeFromPTAIndedID(PTAIndexID: Integer): Code[20]
    var
        // contact: Record Contact;
        // ContactBusinessRelation: Record "Contact Business Relation";
        // MktgSetup: Record "Marketing Setup";
        Customer: Record Customer;
    begin
        // MktgSetup.Get();
        // contact.reset;
        // contact.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        // contact.SetRange("PTA Index Link", PTAIndexID);
        // contact.SetRange("PTA IsDeleted", false);
        // if contact.FindFirst() then begin
        //     IF ContactBusinessRelation.GET(Contact."No.", MktgSetup."Bus. Rel. Code for Customers") THEN
        //         exit(ContactBusinessRelation."No.")
        //     else
        //         exit('');
        // end else
        //     exit('');
        Customer.reset;
        customer.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        customer.setrange("PTA Index Link", PTAIndexID);
        Customer.SetRange("PTA IsDeleted", false);
        if customer.findlast then
            exit(customer."No.")
        else
            exit('');

    end;

    procedure GetVendorCodeFromPTAIndedID(PTAIndexID: Integer): Code[20]
    var
        // Contact: Record Contact;
        // ContactBusinessRelation: Record "Contact Business Relation";
        // MktgSetup: Record "Marketing Setup";
        Vendor: Record Vendor;
    begin
        // MktgSetup.Get();
        // Contact.reset;
        // Contact.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        // Contact.SetRange("PTA Index Link", PTAIndexID);
        // Contact.SetRange("PTA IsDeleted", false);
        // if Contact.FindFirst() then begin
        //     IF ContactBusinessRelation.GET(Contact."No.", MktgSetup."Bus. Rel. Code for Vendors") THEN
        //         exit(ContactBusinessRelation."No.")
        //     else
        //         exit('');
        // end else
        //     exit('');
        Vendor.reset;
        vendor.SetCurrentKey("PTA Index Link", "PTA IsDeleted");
        Vendor.setrange("PTA Index Link", PTAIndexID);
        Vendor.SetRange("PTA IsDeleted", false);
        if Vendor.findlast then
            exit(Vendor."No.")
        else
            exit('');
    end;
}