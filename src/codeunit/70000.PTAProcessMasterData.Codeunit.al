codeunit 70000 "PTA Process Master Data"
{
    trigger OnRun()
    var
        PTAIntegrationLog: Record "PTA Integration Log";

    begin
        Commit();
        ProcessMasterData();
        Commit();
        ProcessCounterpartyData();
    End;

    procedure ProcessMasterData()
    begin
        DummyVariant := '';
        HeaderEntryNo := 0;

        CheckIfThisIsMasterCompany();

        ProcessCurrencyRecords(); //MAPPING:Currency <-> PTACurrenciesMaster
        ProcessCurrencyExchangeRate(); //MAPPING Currency Exchange Rate <-> PTACurrencyExchRate

        ProcessBusinessAreaRecords(); //MAPPING:Dimension Values <-> PTABusinessAreas

        ProcessSupplyRegionIsTheNewSupplyMarket(); //MAPPING:Dimension Values <-> PTABookdetails //DimensionMappingChanged
        //ProcessSupplyMarket(); //MAPPING:Dimension Values <-> PTASupplyRegions //DimensionMappingChanged

        ProcessCompanyOffices(); //MAPPING:Dimension Values <-> PTACompanyOfficesMaster

        ProcessUnits(); //MAPPING:Units of Measure <-> PTAUnitMaster
        ProcessDeliveryTypes(); //MAPPING:Shipment Method <-> PTADeliveryTypeMaster
        ProcessProductTypes(); //MAPPING:Item Category <-> PTAProductTypeMaster


        ProcessCountryRecords(); //MAPPING:Country/Region <-> PTACountryMaster
        ProcessCityRecords(); //MAPPING:Post Code <-> PTACityMaster
        ProcessPortRecords(); //MAPPING:Location <-> PTAPortMaster
        ProcessUserRecords();//MAPPING:Salesperson <-> PTAUserMaster


        ProcessProductsAndResources(); //MAPPING:Items / Resource <-> PTAProductsAndResourcesMaster
        ProcessPTAAddCostDetailsMaster(); //PTA MAPPING CODE No Mapping code for PTAAddCostDetailsMaster
        ProcessPTACostTypeMaster(); //PTA MAPPING CODE No Mapping code for PTAAddCostDetailsMaster

        //ProcessExpenseClaimStatus(); //PTA MAPPING CODE No Mapping code for PTAExpenseClaimStatusMaster
        //ProcessExpenseCategory(); //PTA MAPPING CODE No Mapping code for PTAExpenseCategoryMaster
        ProcessPTAAddressesMaster() //PTA MAPPING CODE No Mapping code for PTAAddressesMaster

    end;

    procedure InsertMasterDataHeaderRecord()
    begin
        HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
        CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::"Master Data", 'Master Data', HeaderEntryNo);
    end;

    procedure ProcessCounterpartyData()
    begin
        HeaderEntryNo := 0;
        HeaderEntryNo := CuPTAIntegrationLog.GetLastHeaderEntryNo();
        ProcessCounterpartyMaster(); //MAPPING:Contact <-> PTACounterpartyMaster
    end;

    local procedure ProcessBusinessAreaRecords()
    var
        PTABusinessAreasMaster: Record PTABusinessAreasMaster;
        ModifyPTABusinessAreasMaster: Record PTABusinessAreasMaster;

        PTAProcessBusinessAreaRecords: Codeunit PTAProcessBusinessAreas;
        hasError: Boolean;

    begin
        //PTA MAPPING CODE PTABusinessArea To "Business Area" from PTA Setup Dimension Value 
        hasError := false;
        PTASetup.TestField("Business Area Dimension");
        PTABusinessAreasMaster.Reset();
        PTABusinessAreasMaster.Setfilter(Processed, '%1|%2', 0, 2);
        if not PTABusinessAreasMaster.IsEmpty then begin
            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTABusinessAreasMaster.TableName, HeaderEntryNo);
        end;


        if PTABusinessAreasMaster.findset(true) then
            repeat
                ClearLastError();
                Commit();
                if Not PTAProcessBusinessAreaRecords.run(PTABusinessAreasMaster) then begin
                    ModifyPTABusinessAreasMaster := PTABusinessAreasMaster;
                    ModifyPTABusinessAreasMaster.Processed := 2;
                    ModifyPTABusinessAreasMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTABusinessAreasMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTABusinessAreasMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTABusinessAreasMaster.ErrorMessage));
                    ModifyPTABusinessAreasMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTABusinessAreasMaster, 1, DummyIntegrationStatus::Error, ModifyPTABusinessAreasMaster.BusinessAreaName, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTABusinessAreasMaster := PTABusinessAreasMaster;
                    ModifyPTABusinessAreasMaster.Processed := 1;
                    ModifyPTABusinessAreasMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTABusinessAreasMaster.ErrorDateTime := 0DT;
                    ModifyPTABusinessAreasMaster.ErrorMessage := '';
                    ModifyPTABusinessAreasMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTABusinessAreasMaster, 1, DummyIntegrationStatus::Success, ModifyPTABusinessAreasMaster.BusinessAreaName, HeaderEntryNo);
                end;
            until PTABusinessAreasMaster.Next() = 0;

        if hasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTABusinessAreasMaster.TableName, HeaderEntryNo);
    end;

    local procedure ProcessCurrencyRecords()
    var
        PTACurrenciesMaster: Record PTACurrenciesMaster;
        ModifyPTACurrenciesMaster: Record PTACurrenciesMaster;
        PTAProcessCurrencyRecords: Codeunit PTAProcessCurrencies;
        HasError: Boolean;
    begin
        //PTA MAPPING CODE PTACurrenciesMaster to Currency 
        HasError := false;

        PTACurrenciesMaster.Reset();
        PTACurrenciesMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTACurrenciesMaster.IsEmpty then begin
            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACurrenciesMaster.TableName, HeaderEntryNo);
        end;

        if PTACurrenciesMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessCurrencyRecords.run(PTACurrenciesMaster) then begin
                    ModifyPTACurrenciesMaster := PTACurrenciesMaster;
                    ModifyPTACurrenciesMaster.Processed := 2;
                    ModifyPTACurrenciesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACurrenciesMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACurrenciesMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACurrenciesMaster.ErrorMessage));
                    ModifyPTACurrenciesMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACurrenciesMaster, 1, DummyIntegrationStatus::Error, ModifyPTACurrenciesMaster.Abbreviation, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACurrenciesMaster := PTACurrenciesMaster;
                    ModifyPTACurrenciesMaster.Processed := 1;
                    ModifyPTACurrenciesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACurrenciesMaster.ErrorDateTime := 0DT;
                    ModifyPTACurrenciesMaster.ErrorMessage := '';
                    ModifyPTACurrenciesMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACurrenciesMaster, 1, DummyIntegrationStatus::Success, ModifyPTACurrenciesMaster.Abbreviation, HeaderEntryNo);

                end;
            until PTACurrenciesMaster.next = 0;

        if HasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTACurrenciesMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessCurrencyExchangeRate()
    var
        PTACurrencyExchRate: Record PTACurrencyExchRate;
        ModifyPTACurrencyExchRate: Record PTACurrencyExchRate;
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";

        PTAProcessCurrencyExchRates: Codeunit PTAProcessCurrencyExchRates;
        hasError: Boolean;

    begin
        //PTA MAPPING CODE PTACurrencyExchRate to Currency Exchange Rate
        hasError := false;

        PTACurrencyExchRate.Reset();
        PTACurrencyExchRate.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTACurrencyExchRate.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACurrencyExchRate.TableName, HeaderEntryNo);
        end;

        if PTACurrencyExchRate.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessCurrencyExchRates.run(PTACurrencyExchRate) then begin
                    ModifyPTACurrencyExchRate := PTACurrencyExchRate;
                    ModifyPTACurrencyExchRate.Processed := 2;
                    ModifyPTACurrencyExchRate.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACurrencyExchRate.ErrorDateTime := CurrentDateTime;
                    ModifyPTACurrencyExchRate.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACurrencyExchRate.ErrorMessage));
                    ModifyPTACurrencyExchRate.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACurrencyExchRate, 1, DummyIntegrationStatus::Error, StrSubstNo('%1 - %2', PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(ModifyPTACurrencyExchRate.CurrencyID), Format(ModifyPTACurrencyExchRate.RateDate)), HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACurrencyExchRate := PTACurrencyExchRate;
                    ModifyPTACurrencyExchRate.Processed := 1;
                    ModifyPTACurrencyExchRate.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACurrencyExchRate.ErrorDateTime := 0DT;
                    ModifyPTACurrencyExchRate.ErrorMessage := '';
                    ModifyPTACurrencyExchRate.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACurrencyExchRate, 1, DummyIntegrationStatus::Success, StrSubstNo('%1 - %2', PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(ModifyPTACurrencyExchRate.CurrencyID), Format(ModifyPTACurrencyExchRate.RateDate)), HeaderEntryNo);
                end;
            until PTACurrencyExchRate.next = 0;

        if hasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTACurrencyExchRate.TableName, HeaderEntryNo)
    end;

    local procedure ProcessUnits()
    var
        PTAUnitMaster: Record PTAUnitMaster;
        ModifyPTAUnitMaster: Record PTAUnitMaster;

        PTAProcessUnits: Codeunit PTAProcessUnits;
        hasError: Boolean;

    begin
        //PTA MAPPING CODE PTAUnitMaster to "Unit of Measure"
        hasError := false;

        PTAUnitMaster.Reset();
        PTAUnitMaster.Setfilter(Processed, '%1|%2', 0, 2);
        if not PTAUnitMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTAUnitMaster.TableName, HeaderEntryNo);
        end;

        if PTAUnitMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessUnits.run(PTAUnitMaster) then begin
                    ModifyPTAUnitMaster := PTAUnitMaster;
                    ModifyPTAUnitMaster.Processed := 2;
                    ModifyPTAUnitMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAUnitMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTAUnitMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTAUnitMaster.ErrorMessage));
                    ModifyPTAUnitMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAUnitMaster, 1, DummyIntegrationStatus::Error, ModifyPTAUnitMaster.Abbreviation, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTAUnitMaster := PTAUnitMaster;
                    ModifyPTAUnitMaster.Processed := 1;
                    ModifyPTAUnitMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAUnitMaster.ErrorDateTime := 0DT;
                    ModifyPTAUnitMaster.ErrorMessage := '';
                    ModifyPTAUnitMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAUnitMaster, 1, DummyIntegrationStatus::Success, ModifyPTAUnitMaster.Abbreviation, HeaderEntryNo);
                end;
            until PTAUnitMaster.next = 0;

        if hasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTAUnitMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessDeliveryTypes()
    var
        PTADeliveryTypeMaster: Record PTADeliveryTypeMaster;
        ModifyPTADeliveryTypeMaster: Record PTADeliveryTypeMaster;

        PTAProcessDeliveryType: Codeunit PTAProcessDeliveryTypes;

        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTADeliveryTypeMaster to Shipment Method 
        haserror := false;
        PTADeliveryTypeMaster.Reset();
        PTADeliveryTypeMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTADeliveryTypeMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTADeliveryTypeMaster.TableName, HeaderEntryNo);
        end;

        if PTADeliveryTypeMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessDeliveryType.run(PTADeliveryTypeMaster) then begin
                    ModifyPTADeliveryTypeMaster := PTADeliveryTypeMaster;
                    ModifyPTADeliveryTypeMaster.Processed := 2;
                    ModifyPTADeliveryTypeMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTADeliveryTypeMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTADeliveryTypeMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTADeliveryTypeMaster.ErrorMessage));
                    ModifyPTADeliveryTypeMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTADeliveryTypeMaster, 1, DummyIntegrationStatus::Error, ModifyPTADeliveryTypeMaster.Abbreviation, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTADeliveryTypeMaster := PTADeliveryTypeMaster;
                    ModifyPTADeliveryTypeMaster.Processed := 1;
                    ModifyPTADeliveryTypeMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTADeliveryTypeMaster.ErrorDateTime := 0DT;
                    ModifyPTADeliveryTypeMaster.ErrorMessage := '';
                    ModifyPTADeliveryTypeMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTADeliveryTypeMaster, 1, DummyIntegrationStatus::Success, ModifyPTADeliveryTypeMaster.Abbreviation, HeaderEntryNo);
                end;
            until PTADeliveryTypeMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTADeliveryTypeMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessProductTypes()
    var
        PTAProductTypeMaster: Record PTAProductTypeMaster;
        ModifyPTAProductTypeMaster: Record PTAProductTypeMaster;

        PTAProcessProductType: Codeunit PTAProcessProductTypes;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTAProductTypeMaster to "Item Category"
        haserror := false;
        PTAProductTypeMaster.Reset();
        PTAProductTypeMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTAProductTypeMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTAProductTypeMaster.TableName, HeaderEntryNo);
        end;

        if PTAProductTypeMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessProductType.run(PTAProductTypeMaster) then begin
                    ModifyPTAProductTypeMaster := PTAProductTypeMaster;
                    ModifyPTAProductTypeMaster.Processed := 2;
                    ModifyPTAProductTypeMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAProductTypeMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTAProductTypeMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTAProductTypeMaster.ErrorMessage));
                    ModifyPTAProductTypeMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAProductTypeMaster, 1, DummyIntegrationStatus::Error, ModifyPTAProductTypeMaster.ProductType, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTAProductTypeMaster := PTAProductTypeMaster;
                    ModifyPTAProductTypeMaster.Processed := 1;
                    ModifyPTAProductTypeMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAProductTypeMaster.ErrorDateTime := 0DT;
                    ModifyPTAProductTypeMaster.ErrorMessage := '';
                    ModifyPTAProductTypeMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAProductTypeMaster, 1, DummyIntegrationStatus::Success, ModifyPTAProductTypeMaster.ProductType, HeaderEntryNo);
                end;
            until PTAProductTypeMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTAProductTypeMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessCountryRecords()
    var
        PTACountryMaster: Record PTACountryMaster;
        ModifyPTACountryMaster: Record PTACountryMaster;
        PTAProcessCountries: Codeunit PTAProcessCountries;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTACountryMaster to "Country/Region"
        haserror := false;
        PTACountryMaster.Reset();
        PTACountryMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTACountryMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACountryMaster.TableName, HeaderEntryNo);
        end;

        if PTACountryMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessCountries.run(PTACountryMaster) then begin
                    ModifyPTACountryMaster := PTACountryMaster;
                    ModifyPTACountryMaster.Processed := 2;
                    ModifyPTACountryMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACountryMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACountryMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACountryMaster.ErrorMessage));
                    ModifyPTACountryMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACountryMaster, 1, DummyIntegrationStatus::Error, ModifyPTACountryMaster.Abbreviation2, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACountryMaster := PTACountryMaster;
                    ModifyPTACountryMaster.Processed := 1;
                    ModifyPTACountryMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACountryMaster.ErrorDateTime := 0DT;
                    ModifyPTACountryMaster.ErrorMessage := '';
                    ModifyPTACountryMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACountryMaster, 1, DummyIntegrationStatus::Success, ModifyPTACountryMaster.Abbreviation2, HeaderEntryNo);
                end;
            until PTACountryMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTACountryMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessCityRecords()
    var
        PTACityMaster: Record PTACityMaster;
        ModifyPTACityMaster: Record PTACityMaster;

        PTAProcessCities: Codeunit PTAProcessCities;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTACityMaster to "Post Code"
        haserror := false;
        PTACityMaster.Reset();
        PTACityMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTACityMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACityMaster.TableName, HeaderEntryNo);
        end;

        if PTACityMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessCities.run(PTACityMaster) then begin
                    ModifyPTACityMaster := PTACityMaster;
                    ModifyPTACityMaster.Processed := 2;
                    ModifyPTACityMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACityMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACityMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACityMaster.ErrorMessage));
                    ModifyPTACityMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACityMaster, 1, DummyIntegrationStatus::Error, ModifyPTACityMaster.Name, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACityMaster := PTACityMaster;
                    ModifyPTACityMaster.Processed := 1;
                    ModifyPTACityMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACityMaster.ErrorDateTime := 0DT;
                    ModifyPTACityMaster.ErrorMessage := '';
                    ModifyPTACityMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACityMaster, 1, DummyIntegrationStatus::Success, ModifyPTACityMaster.Name, HeaderEntryNo);
                end;
            until PTACityMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTACityMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessUserRecords()
    var
        PTAUserMaster: Record PTAUsersMaster;
        ModifyPTAUserMaster: Record PTAUsersMaster;

        PTAProcessUsers: Codeunit PTAProcessUsers;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTAUserMaster to Salesperson
        haserror := false;
        PTAUserMaster.Reset();
        PTAUserMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTAUserMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTAUserMaster.TableName, HeaderEntryNo);
        end;

        if PTAUserMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessUsers.run(PTAUserMaster) then begin
                    ModifyPTAUserMaster := PTAUserMaster;
                    ModifyPTAUserMaster.Processed := 2;
                    ModifyPTAUserMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAUserMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTAUserMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTAUserMaster.ErrorMessage));
                    ModifyPTAUserMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAUserMaster, 1, DummyIntegrationStatus::Error, ModifyPTAUserMaster.UserName, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTAUserMaster := PTAUserMaster;
                    ModifyPTAUserMaster.Processed := 1;
                    ModifyPTAUserMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAUserMaster.ErrorDateTime := 0DT;
                    ModifyPTAUserMaster.ErrorMessage := '';
                    ModifyPTAUserMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAUserMaster, 1, DummyIntegrationStatus::Success, ModifyPTAUserMaster.UserName, HeaderEntryNo);
                end;
            until PTAUserMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTAUserMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessPortRecords()
    var
        PTACityMaster: Record PTAPortMaster;
        ModifyPTACityMaster: Record PTAPortMaster;

        PTAProcessPorts: Codeunit PTAProcessPorts;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTAPortMaster to Location;
        haserror := false;
        PTACityMaster.Reset();
        PTACityMaster.Setfilter(Processed, '%1|%2', 0, 2);
        if not PTACityMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACityMaster.TableName, HeaderEntryNo);
        end;

        if PTACityMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessPorts.run(PTACityMaster) then begin
                    ModifyPTACityMaster := PTACityMaster;
                    ModifyPTACityMaster.Processed := 2;
                    ModifyPTACityMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACityMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACityMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACityMaster.ErrorMessage));
                    ModifyPTACityMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACityMaster, 1, DummyIntegrationStatus::Error, ModifyPTACityMaster.Abbreviation, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACityMaster := PTACityMaster;
                    ModifyPTACityMaster.Processed := 1;
                    ModifyPTACityMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACityMaster.ErrorDateTime := 0DT;
                    ModifyPTACityMaster.ErrorMessage := '';
                    ModifyPTACityMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACityMaster, 1, DummyIntegrationStatus::Success, ModifyPTACityMaster.Abbreviation, HeaderEntryNo);
                end;
            until PTACityMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTACityMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessCompanyOffices()
    var
        ProcessCompanyOffices: Record PTACompanyOfficesMaster;
        ModifyProcessCompanyOffices: Record PTACompanyOfficesMaster;

        PTAProcessCompanyOffices: Codeunit PTAProcessCompanyOffices;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTACompanyOfficesMaster to Dimensions;
        haserror := false;
        ProcessCompanyOffices.Reset();
        ProcessCompanyOffices.Setfilter(Processed, '%1|%2', 0, 2);
        if not ProcessCompanyOffices.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", ProcessCompanyOffices.TableName, HeaderEntryNo);
        end;

        if ProcessCompanyOffices.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessCompanyOffices.run(ProcessCompanyOffices) then begin
                    ModifyProcessCompanyOffices := ProcessCompanyOffices;
                    ModifyProcessCompanyOffices.Processed := 2;
                    ModifyProcessCompanyOffices.ProcessedDateTime := CurrentDateTime;
                    ModifyProcessCompanyOffices.ErrorDateTime := CurrentDateTime;
                    ModifyProcessCompanyOffices.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyProcessCompanyOffices.ErrorMessage));
                    ModifyProcessCompanyOffices.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyProcessCompanyOffices, 1, DummyIntegrationStatus::Error, ModifyProcessCompanyOffices.Name, HeaderEntryNo);
                    if not haserror then haserror := true;
                end else begin
                    ModifyProcessCompanyOffices := ProcessCompanyOffices;
                    ModifyProcessCompanyOffices.Processed := 1;
                    ModifyProcessCompanyOffices.ProcessedDateTime := CurrentDateTime;
                    ModifyProcessCompanyOffices.ErrorDateTime := 0DT;
                    ModifyProcessCompanyOffices.ErrorMessage := '';
                    ModifyProcessCompanyOffices.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyProcessCompanyOffices, 1, DummyIntegrationStatus::Success, ModifyProcessCompanyOffices.Name, HeaderEntryNo);
                end;
            until ProcessCompanyOffices.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(ProcessCompanyOffices.TableName, HeaderEntryNo)
    end;


    local procedure ProcessProductsAndResources()
    var
        PTAProductMaster: Record PTAProductMaster;
        ModifyPTAProductMaster: Record PTAProductMaster;

        PTAProcessPorts: Codeunit PTAProcessProductsAndResources;
        hasError: Boolean;
    begin
        //PTA MAPPING CODE PTACompanyOfficesMaster to Dimensions;
        hasError := false;
        PTAProductMaster.Reset();
        PTAProductMaster.Setfilter(Processed, '%1|%2', 0, 2);
        if not PTAProductMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTAProductMaster.TableName, HeaderEntryNo);
        end;

        if PTAProductMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessPorts.run(PTAProductMaster) then begin
                    ModifyPTAProductMaster := PTAProductMaster;
                    ModifyPTAProductMaster.Processed := 2;
                    ModifyPTAProductMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAProductMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTAProductMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTAProductMaster.ErrorMessage));
                    ModifyPTAProductMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAProductMaster, 1, DummyIntegrationStatus::Error, ModifyPTAProductMaster.ProductName, HeaderEntryNo);
                    if not haserror then haserror := true;
                end else begin
                    ModifyPTAProductMaster := PTAProductMaster;
                    ModifyPTAProductMaster.Processed := 1;
                    ModifyPTAProductMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAProductMaster.ErrorDateTime := 0DT;
                    ModifyPTAProductMaster.ErrorMessage := '';
                    ModifyPTAProductMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAProductMaster, 1, DummyIntegrationStatus::Success, ModifyPTAProductMaster.ProductName, HeaderEntryNo);
                end;
            until PTAProductMaster.next = 0;
        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTAProductMaster.TableName, HeaderEntryNo)

    end;

    local procedure ProcessSupplyRegionIsTheNewSupplyMarket() //DimensionMappingChanged
    var
        PTASupplyRegions: Record PTASupplyRegions;
        ModifyPTASupplyRegions: Record PTASupplyRegions;

        PTAProcessSupplyRegions: Codeunit PTAProcessSupplyRegions;
        hasError: Boolean;
    begin
        //PTA MAPPING CODE PTASupplyRegions To "Supply Region" from PTA Setup Dimension Value 
        hasError := false;
        //PTASetup.TestField("Supply Region Dimension"); //DimensionMappingChanged
        PTASetup.TestField("Supply Market Dimension");

        PTASupplyRegions.Reset();
        PTASupplyRegions.Setfilter(Processed, '%1|%2', 0, 2);
        if not PTASupplyRegions.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTASupplyRegions.TableName, HeaderEntryNo);
        end;

        if PTASupplyRegions.findset(true) then
            repeat
                ClearLastError();
                Commit();

                if Not PTAProcessSupplyRegions.run(PTASupplyRegions) then begin
                    ModifyPTASupplyRegions := PTASupplyRegions;
                    ModifyPTASupplyRegions.Processed := 2;
                    ModifyPTASupplyRegions.ProcessedDateTime := CurrentDateTime;
                    ModifyPTASupplyRegions.ErrorDateTime := CurrentDateTime;
                    ModifyPTASupplyRegions.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTASupplyRegions.ErrorMessage));
                    ModifyPTASupplyRegions.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTASupplyRegions, 1, DummyIntegrationStatus::Error, ModifyPTASupplyRegions.Name, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTASupplyRegions := PTASupplyRegions;
                    ModifyPTASupplyRegions.Processed := 1;
                    ModifyPTASupplyRegions.ProcessedDateTime := CurrentDateTime;
                    ModifyPTASupplyRegions.ErrorDateTime := 0DT;
                    ModifyPTASupplyRegions.ErrorMessage := '';
                    ModifyPTASupplyRegions.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTASupplyRegions, 1, DummyIntegrationStatus::Success, ModifyPTASupplyRegions.Name, HeaderEntryNo);
                end;
            until PTASupplyRegions.Next() = 0;

        if hasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTASupplyRegions.TableName, HeaderEntryNo)
    end;

    local procedure ProcessPTAAddressesMaster()
    var
        PTAAddressesMaster: Record PTAAddressesMaster;
        ModifyPTAAddressesMaster: Record PTAAddressesMaster;

        PTAProcessAddressMaster: Codeunit PTAProcessAddressMaster;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTAUserMaster to Salesperson
        haserror := false;
        PTAAddressesMaster.Reset();
        PTAAddressesMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTAAddressesMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTAAddressesMaster.TableName, HeaderEntryNo);
        end;

        if PTAAddressesMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessAddressMaster.run(PTAAddressesMaster) then begin
                    ModifyPTAAddressesMaster := PTAAddressesMaster;
                    ModifyPTAAddressesMaster.Processed := 2;
                    ModifyPTAAddressesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAAddressesMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTAAddressesMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTAAddressesMaster.ErrorMessage));
                    ModifyPTAAddressesMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAAddressesMaster, 1, DummyIntegrationStatus::Error, Format(ModifyPTAAddressesMaster.id), HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTAAddressesMaster := PTAAddressesMaster;
                    ModifyPTAAddressesMaster.Processed := 1;
                    ModifyPTAAddressesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAAddressesMaster.ErrorDateTime := 0DT;
                    ModifyPTAAddressesMaster.ErrorMessage := '';
                    ModifyPTAAddressesMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAAddressesMaster, 1, DummyIntegrationStatus::Success, Format(ModifyPTAAddressesMaster.id), HeaderEntryNo);
                end;
            until PTAAddressesMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTAAddressesMaster.TableName, HeaderEntryNo)
    end;

    //DimensionMappingChanged
    // local procedure ProcessSupplyMarket()
    // var
    //     PTABookDetails: Record PTABookDetails;
    //     ModifyPTABookDetails: Record PTABookDetails;

    //     PTAProcessSupplyMarkets: Codeunit PTAProcessSupplyMarkets;
    //     hasError: Boolean;
    // begin
    //     //PTA MAPPING CODE PTASupplyRegions To "Supply Region" from PTA Setup Dimension Value 
    //     hasError := false;
    //     PTASetup.TestField("Supply Market Dimension");

    //     PTABookDetails.Reset();
    //     PTABookDetails.Setfilter(Processed, '%1|%2', 0, 2);
    //     if not PTABookDetails.IsEmpty then begin

    //         if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
    //         CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTABookDetails.TableName, HeaderEntryNo);
    //     end;

    //     if PTABookDetails.findset(true) then
    //         repeat
    //             ClearLastError();
    //             Commit();

    //             if Not PTAProcessSupplyMarkets.run(PTABookDetails) then begin
    //                 ModifyPTABookDetails := PTABookDetails;
    //                 ModifyPTABookDetails.Processed := 2;
    //                 ModifyPTABookDetails.ProcessedDateTime := CurrentDateTime;
    //                 ModifyPTABookDetails.ErrorDateTime := CurrentDateTime;
    //                 ModifyPTABookDetails.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTABookDetails.ErrorMessage));
    //                 ModifyPTABookDetails.Modify();
    //                 CuPTAIntegrationLog.InsertLogEntry(ModifyPTABookDetails, 1, DummyIntegrationStatus::Error, ModifyPTABookDetails.Name, HeaderEntryNo);
    //                 if not hasError then hasError := true;
    //             end else begin
    //                 ModifyPTABookDetails := PTABookDetails;
    //                 ModifyPTABookDetails.Processed := 1;
    //                 ModifyPTABookDetails.ProcessedDateTime := CurrentDateTime;
    //                 ModifyPTABookDetails.ErrorDateTime := 0DT;
    //                 ModifyPTABookDetails.ErrorMessage := '';
    //                 ModifyPTABookDetails.Modify();
    //                 CuPTAIntegrationLog.InsertLogEntry(ModifyPTABookDetails, 1, DummyIntegrationStatus::Success, ModifyPTABookDetails.Name, HeaderEntryNo);
    //             end;
    //         until PTABookDetails.Next() = 0;

    //     if hasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTABookDetails.TableName, HeaderEntryNo)
    // end;

    local procedure ProcessCounterpartyMaster()
    var
        PTACounterpartiesMaster: Record PTACounterpartiesMaster;
        ModifyPTACounterpartiesMaster: Record PTACounterpartiesMaster;
        PTAProcessCounterparties: Codeunit PTAProcessCounterparties;
        hasError: Boolean;
    begin
        //PTA MAPPING CODE PTACounterpartiesMaster to Contact 
        hasError := false;
        PTACounterpartiesMaster.Reset();
        PTACounterpartiesMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTACounterpartiesMaster.IsEmpty then begin
            CuPTAIntegrationLog.InsertHeaderRecord(DummyIntegrationProcessType::"Master Data", 'Counterparties', HeaderEntryNo);
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACounterpartiesMaster.TableName, HeaderEntryNo);
        end;

        if PTACounterpartiesMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessCounterparties.run(PTACounterpartiesMaster) then begin
                    ModifyPTACounterpartiesMaster := PTACounterpartiesMaster;
                    ModifyPTACounterpartiesMaster.Processed := 2;
                    ModifyPTACounterpartiesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACounterpartiesMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACounterpartiesMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACounterpartiesMaster.ErrorMessage));
                    ModifyPTACounterpartiesMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACounterpartiesMaster, 1, DummyIntegrationStatus::Error, ModifyPTACounterpartiesMaster.Name, HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACounterpartiesMaster := PTACounterpartiesMaster;
                    ModifyPTACounterpartiesMaster.Processed := 1;
                    ModifyPTACounterpartiesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACounterpartiesMaster.ErrorDateTime := 0DT;
                    ModifyPTACounterpartiesMaster.ErrorMessage := '';
                    ModifyPTACounterpartiesMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACounterpartiesMaster, 1, DummyIntegrationStatus::Success, ModifyPTACounterpartiesMaster.Name, HeaderEntryNo);
                end;
            until PTACounterpartiesMaster.next = 0;

        if hasError then CuPTAIntegrationLog.SendPTAErrorEmail(PTACounterpartiesMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessPTAAddCostDetailsMaster()
    var
        PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster;
        ModifyPTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster;

        PTAProcessAdditionalCosts: Codeunit PTAProcessAdditionalCosts;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTAUserMaster to Salesperson
        haserror := false;
        PTAAddCostDetailsMaster.Reset();
        PTAAddCostDetailsMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTAAddCostDetailsMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTAAddCostDetailsMaster.TableName, HeaderEntryNo);
        end;

        if PTAAddCostDetailsMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessAdditionalCosts.run(PTAAddCostDetailsMaster) then begin
                    ModifyPTAAddCostDetailsMaster := PTAAddCostDetailsMaster;
                    ModifyPTAAddCostDetailsMaster.Processed := 2;
                    ModifyPTAAddCostDetailsMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAAddCostDetailsMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTAAddCostDetailsMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTAAddCostDetailsMaster.ErrorMessage));
                    ModifyPTAAddCostDetailsMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAAddCostDetailsMaster, 1, DummyIntegrationStatus::Error, Format(ModifyPTAAddCostDetailsMaster.AdditionalCostDetailID), HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTAAddCostDetailsMaster := PTAAddCostDetailsMaster;
                    ModifyPTAAddCostDetailsMaster.Processed := 1;
                    ModifyPTAAddCostDetailsMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTAAddCostDetailsMaster.ErrorDateTime := 0DT;
                    ModifyPTAAddCostDetailsMaster.ErrorMessage := '';
                    ModifyPTAAddCostDetailsMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTAAddCostDetailsMaster, 1, DummyIntegrationStatus::Success, Format(ModifyPTAAddCostDetailsMaster.AdditionalCostDetailID), HeaderEntryNo);
                end;
            until PTAAddCostDetailsMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTAAddCostDetailsMaster.TableName, HeaderEntryNo)
    end;

    local procedure ProcessPTACostTypeMaster()
    var
        PTACostTypeMaster: Record PTACostTypeMaster;
        ModifyPTACostTypeMaster: Record PTACostTypeMaster;

        PTAProcessCostType: Codeunit PTAProcessCostType;
        haserror: Boolean;
    begin
        //PTA MAPPING CODE PTAUserMaster to Salesperson
        haserror := false;
        PTACostTypeMaster.Reset();
        PTACostTypeMaster.Setfilter(Processed, '%1|%2', 0, 2);

        if not PTACostTypeMaster.IsEmpty then begin

            if HeaderEntryNo = 0 then InsertMasterDataHeaderRecord();
            CuPTAIntegrationLog.InsertLogEntry(DummyVariant, 0, DummyIntegrationStatus::" ", PTACostTypeMaster.TableName, HeaderEntryNo);
        end;

        if PTACostTypeMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();

                if not PTAProcessCostType.run(PTACostTypeMaster) then begin
                    ModifyPTACostTypeMaster := PTACostTypeMaster;
                    ModifyPTACostTypeMaster.Processed := 2;
                    ModifyPTACostTypeMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACostTypeMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACostTypeMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACostTypeMaster.ErrorMessage));
                    ModifyPTACostTypeMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACostTypeMaster, 1, DummyIntegrationStatus::Error, Format(ModifyPTACostTypeMaster.Name), HeaderEntryNo);
                    if not hasError then hasError := true;
                end else begin
                    ModifyPTACostTypeMaster := PTACostTypeMaster;
                    ModifyPTACostTypeMaster.Processed := 1;
                    ModifyPTACostTypeMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACostTypeMaster.ErrorDateTime := 0DT;
                    ModifyPTACostTypeMaster.ErrorMessage := '';
                    ModifyPTACostTypeMaster.Modify();
                    CuPTAIntegrationLog.InsertLogEntry(ModifyPTACostTypeMaster, 1, DummyIntegrationStatus::Success, Format(ModifyPTACostTypeMaster.Name), HeaderEntryNo);
                end;
            until PTACostTypeMaster.next = 0;

        if haserror then CuPTAIntegrationLog.SendPTAErrorEmail(PTACostTypeMaster.TableName, HeaderEntryNo)
    end;

    local procedure CheckIfThisIsMasterCompany()
    var
        MasterCompanyCheck: Label 'Master Data integration only scheduled in %1';
    begin
        PTASetup.Get();

        if PTASetup."Master Company Name" <> CompanyName then
            Error(StrSubstNo(MasterCompanyCheck, PTASetup."Master Company Name"));
    end;



    var
        PTASetup: Record "PTA Setup";
        HeaderEntryNo: Integer;
        TransactionEntryNo: Integer;
        CuPTAIntegrationLog: Codeunit "PTA Integration Log";
        DummyIntegrationProcessType: Enum "PTA Integration Process Type";
        DummyIntegrationStatus: Enum "PTA Integration Status";
        DummyVariant: Variant;
}