codeunit 70029 PTAProcessCostType
{

    TableNo = PTACostTypeMaster;

    trigger OnRun()
    begin
        PTaSetup.get();
        ProcessCostTypes(Rec);
    end;

    local procedure ProcessCostTypes(PTACostTypeMaster: Record PTACostTypeMaster)
    var
        Resource: Record Resource;
        ModifyReource: Record Resource;

    begin
        //PTA MAPPING CODE PTAAddCostDetailsMaster To "Resources"
        Resource.Reset();
        Resource.SetRange("PTA Index Link", PTACostTypeMaster.id);
        Resource.SetRange("PTA Resource Type", Resource."PTA Resource Type"::"Cost Type");
        if Resource.FindSet(true) then begin
            ModifyReource := Resource;

            if copystr(Resource."No.", 1, 15) <> Copystr(PTACostTypeMaster.Name, 1, 15) then begin
                ModifyReource."PTA Index Link" := 0;
                ModifyReource."PTA IsDeleted" := true;
                ModifyReource.Modify();

                CreateResourceFromTemplate(ModifyReource, PTACostTypeMaster);
                ModifyReource.Modify();
            end else begin
                ModifyReource.Name := Copystr(PTACostTypeMaster.Name, 1, MaxStrLen(Resource.Name));
                ModifyReource."PTA IsDeleted" := false;
                ModifyReource.Modify();
            end;
        end else
            CreateResourceFromTemplate(ModifyReource, PTACostTypeMaster);
    end;

    local Procedure CreateResourceFromTemplate(var Resource: Record Resource; PTACostTypeMaster: Record PTACostTypeMaster)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ResourceRecRef: RecordRef;
    begin
        ConfigTemplateHeader.GET(PTaSetup."Resource Template Code");

        Resource.INIT;
        Resource."No." := PTAHelperFunctions.GetNewNextCode(PTACostTypeMaster.Name, Database::Resource);
        Resource.Name := Copystr(PTACostTypeMaster.Name, 1, MaxStrLen(Resource.Name));
        Resource."PTA Index Link" := PTACostTypeMaster.ID;
        Resource."PTA Resource Type" := Resource."PTA Resource Type"::"Cost Type";
        Resource."PTA IsDeleted" := false;
        Resource.INSERT(TRUE);
        ResourceRecRef.GETTABLE(Resource);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ResourceRecRef);
        ResourceRecRef.Modify();
    end;

    var
        PTaSetup: Record "PTA Setup";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}