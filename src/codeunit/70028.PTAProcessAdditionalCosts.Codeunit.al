codeunit 70028 PTAProcessAdditionalCosts
{
    TableNo = PTAAddCostDetailsMaster;

    trigger OnRun()
    begin
        PTaSetup.Get();
        ProcessPTAAddCostDetailsMaster(Rec);
    end;

    local procedure ProcessPTAAddCostDetailsMaster(PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster)
    begin
        if PTAAddCostDetailsMaster.AdditionalCostDetailID = 0 then Error('AdditionalCostDetailID is zero');

        if PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostID) = 0 then
            Error(StrSubstNo('AddCostDetailsMaster not found for AdditionalCostDetail ID %1', PTAAddCostDetailsMaster.AdditionalCostDetailID));

        if PTAAdditionalCostTypeName(PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostID)) = '' then
            Error(StrSubstNo('Cost Type not found for Additional Cost ID %1', PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostDetailID)));

        ProcessResources(PTAAddCostDetailsMaster);
    end;

    local procedure PTAAdditionalCostsMasterID(AdditionalCostID: Integer): Integer
    var
        PTAAdditionalCostsMaster: Record PTAAdditionalCostsMaster;
    begin
        PTAAdditionalCostsMaster.reset;
        PTAAdditionalCostsMaster.SetCurrentKey(ID);
        PTAAdditionalCostsMaster.SetRange(ID, AdditionalCostID);
        if PTAAdditionalCostsMaster.FindFirst() then
            exit(PTAAdditionalCostsMaster.CostTypeId)
        else
            exit(0)
    end;

    local procedure PTAAdditionalCostTypeName(PTAAdditionalCostsMasterID: Integer): text
    var
        PTACostTypeMaster: Record PTACostTypeMaster;
    begin
        PTACostTypeMaster.reset;
        PTACostTypeMaster.SetCurrentKey(ID);
        PTACostTypeMaster.SetRange(ID, PTAAdditionalCostsMasterID);
        PTACostTypeMaster.SetRange(isDeleted, false);
        if PTACostTypeMaster.FindFirst() then
            exit(PTACostTypeMaster.Name)
        else
            exit('')
    end;

    local procedure ProcessResources(PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster)
    var
        Resource: Record Resource;
        ModifyReource: Record Resource;

    begin
        //PTA MAPPING CODE PTAAddCostDetailsMaster To "Resources"
        Resource.Reset();
        Resource.SetRange("PTA Index Link", PTAAddCostDetailsMaster.AdditionalCostDetailID);
        Resource.SetRange("PTA Resource Type", Resource."PTA Resource Type"::"Additional Cost");
        if Resource.FindSet(true) then begin
            ModifyReource := Resource;

            if copystr(Resource."No.", 1, 15) <> Copystr(PTAAdditionalCostTypeName(PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostID)), 1, 15) then begin
                ModifyReource."PTA Index Link" := 0;
                ModifyReource."PTA IsDeleted" := true;
                ModifyReource.Modify();

                CreateResourceFromTemplate(ModifyReource, PTAAddCostDetailsMaster);
                ModifyReource.Modify();
            end else begin
                ModifyReource.Name := Copystr(PTAAdditionalCostTypeName(PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostID)), 1, MaxStrLen(Resource.Name));
                ModifyReource."PTA IsDeleted" := PTAAddCostDetailsMaster.isDeleted;
                ModifyReource.Modify();
            end;
        end else
            CreateResourceFromTemplate(ModifyReource, PTAAddCostDetailsMaster);
    end;

    local Procedure CreateResourceFromTemplate(var Resource: Record Resource; PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ResourceRecRef: RecordRef;
    begin
        ConfigTemplateHeader.GET(PTaSetup."Resource Template Code");

        Resource.INIT;
        Resource."No." := PTAHelperFunctions.GetNewNextCode(PTAAdditionalCostTypeName(PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostID)), Database::Resource);
        Resource.Name := Copystr(PTAAdditionalCostTypeName(PTAAdditionalCostsMasterID(PTAAddCostDetailsMaster.AdditionalCostID)), 1, MaxStrLen(Resource.Name));
        Resource."PTA Index Link" := PTAAddCostDetailsMaster.AdditionalCostDetailID;
        Resource."PTA Resource Type" := Resource."PTA Resource Type"::"Additional Cost";
        Resource."PTA IsDeleted" := PTAAddCostDetailsMaster.isDeleted;
        Resource.INSERT(TRUE);
        ResourceRecRef.GETTABLE(Resource);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ResourceRecRef);
        ResourceRecRef.Modify();
    end;

    var
        PTaSetup: Record "PTA Setup";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";

}