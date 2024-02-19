codeunit 70008 PTAProcessCountries
{
    TableNo = PTACountryMaster;

    trigger OnRun()
    begin
        ProcessCountryRecords(rec);
    end;

    local procedure ProcessCountryRecords(PTACountryMaster: Record PTACountryMaster)
    var
        ModifyPTACountryMaster: Record PTACountryMaster;
        CountryRegion: Record "Country/Region";
        ModifyCountryRegion: Record "Country/Region";
    begin
        //PTA MAPPING CODE PTACountryMaster to "Country/Region"

        if PTACountryMaster.Abbreviation2 = '' then Error('Abbreviation2 is Mandatory');

        CountryRegion.Reset();
        CountryRegion.SetRange("PTA Index Link", PTACountryMaster.Id);
        if CountryRegion.FindSet(true) then begin
            ModifyCountryRegion := CountryRegion;

            if PTAHelperFunctions.Return15CharactersOfPK(CountryRegion.Code) <> Copystr(PTACountryMaster.Abbreviation2, 1, 15).ToUpper() then begin
                ModifyCountryRegion."PTA Index Link" := 0;
                ModifyCountryRegion."PTA Abbreviation 2" := '';
                ModifyCountryRegion."PTA Abbreviation 3" := '';
                ModifyCountryRegion."PTA IsDeleted" := true;
                ModifyCountryRegion.Modify();

                ModifyCountryRegion.Init();
                ModifyCountryRegion.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTACountryMaster.Abbreviation2, 1, 15), Database::"Country/Region");//Copystr(PTACountryMaster.Abbreviation2, 1, MaxStrLen(ModifyCountryRegion.Code));
                ModifyCountryRegion.Name := Copystr(PTACountryMaster.Name, 1, MaxStrLen(ModifyCountryRegion.Name));
                ModifyCountryRegion."PTA Index Link" := PTACountryMaster.Id;
                ModifyCountryRegion."PTA Abbreviation 2" := copystr(PTACountryMaster.Abbreviation2, 1, MaxStrLen(ModifyCountryRegion."PTA Abbreviation 2"));
                ModifyCountryRegion."PTA Abbreviation 3" := copystr(PTACountryMaster.Abbreviation3, 1, MaxStrLen(ModifyCountryRegion."PTA Abbreviation 3"));
                ModifyCountryRegion."PTA IsDeleted" := PTACountryMaster.isDeleted;
                ModifyCountryRegion.Insert();
            end else begin
                ModifyCountryRegion.Name := Copystr(PTACountryMaster.Name, 1, MaxStrLen(ModifyCountryRegion.Name));
                ModifyCountryRegion."PTA Index Link" := PTACountryMaster.Id;
                ModifyCountryRegion."PTA Abbreviation 2" := copystr(PTACountryMaster.Abbreviation2, 1, MaxStrLen(ModifyCountryRegion."PTA Abbreviation 2"));
                ModifyCountryRegion."PTA Abbreviation 3" := copystr(PTACountryMaster.Abbreviation3, 1, MaxStrLen(ModifyCountryRegion."PTA Abbreviation 3"));
                ModifyCountryRegion."PTA IsDeleted" := PTACountryMaster.isDeleted;
                ModifyCountryRegion.Modify();
            end;
        end else begin
            ModifyCountryRegion.Init();
            ModifyCountryRegion.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTACountryMaster.Abbreviation2, 1, 15), Database::"Country/Region");//Copystr(PTACountryMaster.Abbreviation2, 1, MaxStrLen(ModifyCountryRegion.Code));
            ModifyCountryRegion.Name := Copystr(PTACountryMaster.Name, 1, MaxStrLen(ModifyCountryRegion.Name));
            ModifyCountryRegion."PTA Index Link" := PTACountryMaster.Id;
            ModifyCountryRegion."PTA Abbreviation 2" := copystr(PTACountryMaster.Abbreviation2, 1, MaxStrLen(ModifyCountryRegion."PTA Abbreviation 2"));
            ModifyCountryRegion."PTA Abbreviation 3" := copystr(PTACountryMaster.Abbreviation3, 1, MaxStrLen(ModifyCountryRegion."PTA Abbreviation 3"));
            ModifyCountryRegion."PTA IsDeleted" := PTACountryMaster.isDeleted;
            ModifyCountryRegion.Insert();
        end;
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}