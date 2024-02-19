codeunit 70009 PTAProcessCities
{
    TableNo = PTACityMaster;

    trigger OnRun()
    begin
        ProcessCityRecords(rec);
    end;

    local procedure ProcessCityRecords(PTACityMaster: Record PTACityMaster)
    var
        PostCode: Record "Post Code";
        ModifyPostCode: Record "Post Code";

        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
    begin
        //PTA MAPPING CODE PTACityMaster to PostCode

        if PTACityMaster.Name = '' then
            Error('City Name is Mandatory');

        PostCode.Reset();
        PostCode.SetRange("PTA Index Link", PTACityMaster.Id);
        if PostCode.FindSet(true) then begin
            ModifyPostCode := PostCode;

            if PTABCMappingtoIndexID.GetCountryCodeByPTAIndexID(PTACityMaster.CountryId) = '' then
                Error('No Country found for ID %1', PTACityMaster.CountryId);

            if PTAHelperFunctions.Return15CharactersOfPK(PostCode.Code) <> Copystr(PTACityMaster.Name, 1, 15).ToUpper() then begin
                ModifyPostCode."PTA Index Link" := 0;
                ModifyPostCode."PTA Country ID" := 0;
                ModifyPostCode."Country/Region Code" := '';
                ModifyPostCode."PTA IsDeleted" := true;
                ModifyPostCode.Modify();

                ModifyPostCode.Init();
                ModifyPostCode.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTACityMaster.name, 1, 15), Database::"Post Code"); //Copystr(PTACityMaster.Name, 1, MaxStrLen(ModifyPostCode.Code));
                ModifyPostCode.city := Copystr(PTACityMaster.Name, 1, MaxStrLen(ModifyPostCode.city));
                ModifyPostCode."Country/Region Code" := PTABCMappingtoIndexID.GetCountryCodeByPTAIndexID(PTACityMaster.CountryId);
                ModifyPostCode."PTA IsDeleted" := PTACityMaster.isDeleted;
                ModifyPostCode."PTA Index Link" := PTACityMaster.Id;
                ModifyPostCode."PTA Country ID" := PTACityMaster.CountryId;
                ModifyPostCode.Insert();
            end else begin
                ModifyPostCode.City := Copystr(PTACityMaster.Name, 1, MaxStrLen(ModifyPostCode.city));
                ModifyPostCode."Country/Region Code" := PTABCMappingtoIndexID.GetCountryCodeByPTAIndexID(PTACityMaster.CountryId);
                ModifyPostCode."PTA Index Link" := PTACityMaster.Id;
                ModifyPostCode."PTA Country ID" := PTACityMaster.CountryId;
                ModifyPostCode."PTA IsDeleted" := PTACityMaster.isDeleted;
                ModifyPostCode.Modify();
            end;
        end else begin
            ModifyPostCode.Init();
            ModifyPostCode.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTACityMaster.name, 1, 15), Database::"Post Code");  //Copystr(PTACityMaster.Name, 1, MaxStrLen(ModifyPostCode.Code));
            ModifyPostCode.city := Copystr(PTACityMaster.Name, 1, MaxStrLen(ModifyPostCode.city));
            ModifyPostCode."Country/Region Code" := PTABCMappingtoIndexID.GetCountryCodeByPTAIndexID(PTACityMaster.CountryId);
            ModifyPostCode."PTA Index Link" := PTACityMaster.Id;
            ModifyPostCode."PTA Country ID" := PTACityMaster.CountryId;
            ModifyPostCode."PTA IsDeleted" := PTACityMaster.isDeleted;
            ModifyPostCode.Insert();
        end;
    end;


    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}
