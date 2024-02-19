codeunit 70010 PTAProcessPorts
{

    TableNo = PTAPortMaster;

    trigger OnRun()
    begin
        ProcessPortRecords(Rec);
    end;

    local procedure ProcessPortRecords(PTAPortMaster: Record PTAPortMaster)
    var
        ModifyPTAPortMaster: Record PTAPortMaster;
        Location: Record Location;
        ModifyLocation: Record Location;

    begin
        //PTA MAPPING CODE PTAPortMaster to Location
        if PTAPortMaster.Abbreviation = '' then
            error('Abbreviation is Mandatory');

        Location.Reset();
        Location.SetRange("PTA Index Link", PTAPortMaster.Id);
        if Location.FindSet(true) then begin
            ModifyLocation := Location;

            if PTAHelperFunctions.Return15CharactersOfPK(Location.Code) <> Copystr(PTAPortMaster.Abbreviation, 1, 6).ToUpper() then begin
                ModifyLocation."PTA Index Link" := 0;
                ModifyLocation."PTA Port Abbreviation" := '';
                ModifyLocation."PTA Port Grouping" := '';
                ModifyLocation."PTA Supply Region ID" := 0;
                ModifyLocation."PTA IsDeleted" := true;
                ModifyLocation.Modify();

                ModifyLocation.Init();
                ModifyLocation.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAPortMaster.Abbreviation, 1, 6), Database::Location); //Copystr(PTAPortMaster.Abbreviation, 1, MaxStrLen(ModifyLocation.Code));
                ModifyLocation.Name := Copystr(PTAPortMaster.Name, 1, MaxStrLen(ModifyLocation.Name));
                ModifyLocation."PTA Index Link" := PTAPortMaster.Id;
                ModifyLocation."PTA Port Abbreviation" := PTAPortMaster.Abbreviation;
                ModifyLocation."PTA Supply Region ID" := PTAPortMaster.SupplyRegionId;
                ModifyLocation."PTA IsDeleted" := PTAPortMaster.isDeleted;
                ModifyLocation.Insert();
            end else begin
                ModifyLocation.City := Copystr(PTAPortMaster.Abbreviation, 1, MaxStrLen(ModifyLocation.city));
                ModifyLocation.Name := Copystr(PTAPortMaster.Name, 1, MaxStrLen(ModifyLocation.Name));
                ModifyLocation."PTA Index Link" := PTAPortMaster.Id;
                ModifyLocation."PTA Port Abbreviation" := PTAPortMaster.Abbreviation;
                ModifyLocation."PTA Supply Region ID" := PTAPortMaster.SupplyRegionId;
                ModifyLocation."PTA IsDeleted" := PTAPortMaster.isDeleted;
                ModifyLocation.Modify();
            end;
        end else begin
            ModifyLocation.Init();
            ModifyLocation.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAPortMaster.Abbreviation, 1, 6), Database::Location); //Copystr(PTAPortMaster.Abbreviation, 1, MaxStrLen(ModifyLocation.Code));
            ModifyLocation.Name := Copystr(PTAPortMaster.Name, 1, MaxStrLen(ModifyLocation.Name));
            ModifyLocation."PTA Index Link" := PTAPortMaster.Id;
            ModifyLocation."PTA Port Abbreviation" := PTAPortMaster.Abbreviation;
            ModifyLocation."PTA Supply Region ID" := PTAPortMaster.SupplyRegionId;
            ModifyLocation."PTA IsDeleted" := PTAPortMaster.isDeleted;
            ModifyLocation.Insert();

        end;
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}