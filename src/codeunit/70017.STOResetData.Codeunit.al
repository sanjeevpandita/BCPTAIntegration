codeunit 70017 "STO Reset Data"
{
    Permissions = TableData "Item Ledger Entry" = rd, TableData "Res. Ledger Entry" = rd, TableData "Value Entry" = rd;
    trigger OnRun()
    begin

        PTABusinessAreasMaster.modifyall(Processed, 0);
        PTABusinessAreasMaster.modifyall(ProcessedDateTime, 0DT);
        PTABusinessAreasMaster.ModifyAll(ErrorDateTime, 0DT);
        PTABusinessAreasMaster.ModifyAll(ErrorMessage, '');

        PTACurrenciesMaster.modifyall(Processed, 0);
        PTACurrenciesMaster.modifyall(ProcessedDateTime, 0DT);
        PTACurrenciesMaster.ModifyAll(ErrorDateTime, 0DT);
        PTACurrenciesMaster.ModifyAll(ErrorMessage, '');

        PTACurrencyExchRate.modifyall(Processed, 0);
        PTACurrencyExchRate.modifyall(ProcessedDateTime, 0DT);
        PTACurrencyExchRate.ModifyAll(ErrorDateTime, 0DT);
        PTACurrencyExchRate.ModifyAll(ErrorMessage, '');

        PTAUnitMaster.modifyall(Processed, 0);
        PTAUnitMaster.modifyall(ProcessedDateTime, 0DT);
        PTAUnitMaster.ModifyAll(ErrorDateTime, 0DT);
        PTAUnitMaster.ModifyAll(ErrorMessage, '');

        PTADeliveryTypeMaster.modifyall(Processed, 0);
        PTADeliveryTypeMaster.modifyall(ProcessedDateTime, 0DT);
        PTADeliveryTypeMaster.ModifyAll(ErrorDateTime, 0DT);
        PTADeliveryTypeMaster.ModifyAll(ErrorMessage, '');

        PTAProductMaster.modifyall(Processed, 0);
        PTAProductMaster.modifyall(ProcessedDateTime, 0DT);
        PTAProductMaster.ModifyAll(ErrorDateTime, 0DT);
        PTAProductMaster.ModifyAll(ErrorMessage, '');

        PTAProductTypeMaster.modifyall(Processed, 0);
        PTAProductTypeMaster.modifyall(ProcessedDateTime, 0DT);
        PTAProductTypeMaster.ModifyAll(ErrorDateTime, 0DT);
        PTAProductTypeMaster.ModifyAll(ErrorMessage, '');

        PTACountryMaster.modifyall(Processed, 0);
        PTACountryMaster.modifyall(ProcessedDateTime, 0DT);
        PTACountryMaster.ModifyAll(ErrorDateTime, 0DT);
        PTACountryMaster.ModifyAll(ErrorMessage, '');

        PTACityMaster.modifyall(Processed, 0);
        PTACityMaster.modifyall(ProcessedDateTime, 0DT);
        PTACityMaster.ModifyAll(ErrorDateTime, 0DT);
        PTACityMaster.ModifyAll(ErrorMessage, '');

        PTACompanyOfficesMaster.modifyall(Processed, 0);
        PTACompanyOfficesMaster.modifyall(ProcessedDateTime, 0DT);
        PTACompanyOfficesMaster.ModifyAll(ErrorDateTime, 0DT);
        PTACompanyOfficesMaster.ModifyAll(ErrorMessage, '');

        PTASupplyRegions.modifyall(Processed, 0);
        PTASupplyRegions.modifyall(ProcessedDateTime, 0DT);
        PTASupplyRegions.ModifyAll(ErrorDateTime, 0DT);
        PTASupplyRegions.ModifyAll(ErrorMessage, '');

        PTAPortMaster.modifyall(Processed, 0);
        PTAPortMaster.modifyall(ProcessedDateTime, 0DT);
        PTAPortMaster.ModifyAll(ErrorDateTime, 0DT);
        PTAPortMaster.ModifyAll(ErrorMessage, '');

        PTAAddCostDetailsMaster.modifyall(Processed, 0);
        PTAAddCostDetailsMaster.modifyall(ProcessedDateTime, 0DT);
        PTAAddCostDetailsMaster.ModifyAll(ErrorDateTime, 0DT);
        PTAAddCostDetailsMaster.ModifyAll(ErrorMessage, '');

        PTACostTypeMaster.modifyall(Processed, 0);
        PTACostTypeMaster.modifyall(ProcessedDateTime, 0DT);
        PTACostTypeMaster.ModifyAll(ErrorDateTime, 0DT);
        PTACostTypeMaster.ModifyAll(ErrorMessage, '');

        PTACounterpartiesMaster.modifyall(Processed, 0);
        PTACounterpartiesMaster.modifyall(ProcessedDateTime, 0DT);
        PTACounterpartiesMaster.ModifyAll(ErrorDateTime, 0DT);
        PTACounterpartiesMaster.ModifyAll(ErrorMessage, '');


        PTAUsersMaster.modifyall(Processed, 0);
        PTAUsersMaster.modifyall(ProcessedDateTime, 0DT);
        PTAUsersMaster.ModifyAll(ErrorDateTime, 0DT);
        PTAUsersMaster.ModifyAll(ErrorMessage, '');


        DimensionValues.DeleteAll();
        currency.DeleteAll();
        CurrencyExchangeRate.DeleteAll();
        UnitofMeasure.DeleteAll();
        ShipmentMethod.DeleteAll();
        Items.DeleteAll();
        ILE.DeleteAll();
        ve.DeleteALL();
        resources.DeleteAll();
        RLE.DeleteAll();
        itemCategory.DeleteAll();
        CountryRegion.DeleteAll();
        PostCode.DeleteAll();
        Locations.DeleteAll();
        contacts.DeleteAll();
        ContactBusinessRelation.DeleteAll();
        customers.DeleteAll();
        vendors.DeleteAll();


        MESSAGE('Reset Completed');
    end;

    var
        ILE: Record "Item Ledger Entry";
        RLE: Record "Res. Ledger Entry";
        VE: Record "Value Entry";
        contacts: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        Customers: Record Customer;
        Vendors: Record Vendor;
        PTAUsersMaster: Record PTAUsersMaster;
        PTACounterpartiesMaster: Record PTACounterpartiesMaster;
        PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster;
        PTACostTypeMaster: Record PTACostTypeMaster;

        PTABusinessAreasMaster: Record PTABusinessAreasMaster;
        PTACurrenciesMaster: Record PTACurrenciesMaster;
        PTACurrencyExchRate: Record PTACurrencyExchRate;
        PTAUnitMaster: Record PTAUnitMaster;
        PTADeliveryTypeMaster: Record PTADeliveryTypeMaster;
        PTAProductMaster: Record PTAProductMaster;
        PTAProductTypeMaster: Record PTAProductTypeMaster;
        PTACountryMaster: Record PTACountryMaster;
        PTACityMaster: Record PTACityMaster;
        PTACompanyOfficesMaster: Record PTACompanyOfficesMaster;
        PTASupplyRegions: Record PTASupplyRegions;
        PTAPortMaster: Record PTAPortMaster;

        DimensionValues: Record "Dimension Value";
        currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        UnitofMeasure: Record "Unit of Measure";
        ShipmentMethod: Record "Shipment Method";
        Items: Record Item;
        resources: Record Resource;
        itemCategory: Record "Item Category";
        CountryRegion: Record "Country/Region";
        PostCode: Record "Post Code";
        Locations: Record Location;


}