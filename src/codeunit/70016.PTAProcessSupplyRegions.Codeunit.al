codeunit 70016 PTAProcessSupplyRegions
{
    TableNo = PTASupplyRegions;

    trigger OnRun()
    begin
        PTASetup.get();
        ProcessSupplyRegions(Rec);
    end;


    local procedure ProcessSupplyRegions(PTASupplyRegions: Record PTASupplyRegions)
    var
        ModifyPTASupplyRegions: Record PTASupplyRegions;

        DimensionValue: Record "Dimension Value";
        ModifyDimensionValue: Record "Dimension Value";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";

    begin
        //PTA MAPPING CODE PTASupplyRegions To "Supply Region" from PTA Setup Dimension Value 
        if PTASupplyRegions.Name = ' ' then
            Error('Supply Region Name is Mandatory');

        DimensionValue.reset;
        //DimensionValue.SetRange("Dimension Code", PTASetup."Supply Region Dimension");//DimensionMappingChanged
        DimensionValue.SetRange("Dimension Code", PTASetup."Supply Market Dimension");
        DimensionValue.SetRange("PTA Index Link", PTASupplyRegions.Id);
        if DimensionValue.FindSet(true) then begin
            ModifyDimensionValue := DimensionValue;

            //if DimensionValue.code <> Copystr(PTASupplyRegions.Name.Replace('&', ' '), 1, MaxStrLen(DimensionValue.Code)) then begin
            if PTAHelperFunctions.Return15CharactersOfPK(DimensionValue.Code) <> CopyStr(PTASupplyRegions.Name.Replace('&', ' '), 1, 15) then begin
                ModifyDimensionValue."PTA Index Link" := 0;
                ModifyDimensionValue."PTA IsDeleted" := true;
                ModifyDimensionValue.Modify();

                //PTAHelperFunctions.InsertDimensionValue(PTASetup."Supply Region Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTASupplyRegions.Name, 1, 15).Replace('&', ' '), Database::"Dimension Value"), //DimensionMappingChanged
                PTAHelperFunctions.InsertDimensionValue(PTASetup."Supply Market Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTASupplyRegions.Name, 1, 15).Replace('&', ' '), Database::"Dimension Value"),
                PTASupplyRegions.Name, PTASupplyRegions.Id, PTASupplyRegions.isDeleted);
            end else begin
                if DimensionValue.Name <> Copystr(PTASupplyRegions.Name, 1, MaxStrLen(DimensionValue.Name)) then begin
                    ModifyDimensionValue.Name := Copystr(PTASupplyRegions.Name, 1, MaxStrLen(DimensionValue.Name));
                    ModifyDimensionValue."PTA IsDeleted" := PTASupplyRegions.isDeleted;
                    ModifyDimensionValue.Modify();
                end;
            end;
        end else
            //DimensionMappingChanged
            // PTAHelperFunctions.InsertDimensionValue(PTASetup."Supply Region Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTASupplyRegions.Name, 1, 15).Replace('&', ' '), Database::"Dimension Value"),
            //     PTASupplyRegions.Name, PTASupplyRegions.Id, PTASupplyRegions.isDeleted);
            PTAHelperFunctions.InsertDimensionValue(PTASetup."Supply Market Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTASupplyRegions.Name, 1, 15).Replace('&', ' '), Database::"Dimension Value"),
            PTASupplyRegions.Name, PTASupplyRegions.Id, PTASupplyRegions.isDeleted);
    end;

    var
        PTASetup: Record "PTA Setup";
}