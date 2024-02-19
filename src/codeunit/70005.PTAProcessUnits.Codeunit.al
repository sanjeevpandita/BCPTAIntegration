codeunit 70005 PTAProcessUnits
{
    TableNo = PTAUnitMaster;

    trigger OnRun()
    begin
        ProcessUnits(rec);
    end;

    local procedure ProcessUnits(PTAUnitMaster: Record PTAUnitMaster)
    var
        UnitOfMeasure: Record "Unit of Measure";
        ModifyUnitOfMeasure: Record "Unit of Measure";

    begin
        //PTA MAPPING CODE PTAUnitMaster to "Unit of Measure"

        if PTAUnitMaster.Abbreviation = '' then Error('Abbreviation is Mandatory', PTAUnitMaster.Name);

        UnitOfMeasure.Reset();
        UnitOfMeasure.SetRange("PTA Index Link", PTAUnitMaster.Id);
        if UnitOfMeasure.FindSet(true) then begin
            ModifyUnitOfMeasure := UnitOfMeasure;

            if PTAHelperFunctions.Return15CharactersOfPK(UnitOfMeasure.Code) <> Copystr(PTAUnitMaster.Abbreviation, 1, 15).ToUpper() then begin
                ModifyUnitOfMeasure."PTA Index Link" := 0;
                ModifyUnitOfMeasure."PTA ConversionFactor" := 0;
                ModifyUnitOfMeasure."PTA ConvertFactorForOtherUnit" := 0;
                ModifyUnitOfMeasure."PTA isBaseUnit" := false;
                ModifyUnitOfMeasure."PTA IsDefaultUnitForPurchase" := false;
                ModifyUnitOfMeasure."PTA IsGlobalBaseUnit" := false;
                ModifyUnitOfMeasure."PTA Abbreviation" := '';
                ModifyUnitOfMeasure."PTA IsDeleted" := true;
                ModifyUnitOfMeasure.Modify();
                InsertUnitOfMeasure(PTAUnitMaster, ModifyUnitOfMeasure);
            end else begin
                ModifyUnitOfMeasure.Description := Copystr(PTAUnitMaster.Name, 1, MaxStrLen(ModifyUnitOfMeasure.Description));
                ModifyUnitOfMeasure."PTA ConversionFactor" := PTAUnitMaster.ConversionFactor;
                ModifyUnitOfMeasure."PTA ConvertFactorForOtherUnit" := PTAUnitMaster.ConversionFactorForOtherUnit;
                ModifyUnitOfMeasure."PTA isBaseUnit" := PTAUnitMaster.isBaseUnit;
                ModifyUnitOfMeasure."PTA IsDefaultUnitForPurchase" := PTAUnitMaster.IsDefaultUnitForPurchase;
                ModifyUnitOfMeasure."PTA IsGlobalBaseUnit" := PTAUnitMaster.IsGlobalBaseUnit;
                ModifyUnitOfMeasure."PTA Abbreviation" := Copystr(PTAUnitMaster.Abbreviation, 1, MaxStrLen(ModifyUnitOfMeasure."PTA Abbreviation"));
                ModifyUnitOfMeasure."PTA IsDeleted" := PTAUnitMaster.isDeleted;

                ModifyUnitOfMeasure.Modify();
            end;
        end else
            InsertUnitOfMeasure(PTAUnitMaster, ModifyUnitOfMeasure);
    end;

    local procedure InsertUnitOfMeasure(var PTAUnitMaster: Record PTAUnitMaster; var ModifyUnitOfMeasure: Record "Unit of Measure")
    begin
        ModifyUnitOfMeasure.Init();
        ModifyUnitOfMeasure.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAUnitMaster.Abbreviation, 1, 15), Database::"Unit of Measure"); //Copystr(PTAUnitMaster.Abbreviation, 1, MaxStrLen(ModifyUnitOfMeasure.Code));
        ModifyUnitOfMeasure.Description := Copystr(PTAUnitMaster.Name, 1, MaxStrLen(ModifyUnitOfMeasure.Description));
        ModifyUnitOfMeasure."PTA Abbreviation" := Copystr(PTAUnitMaster.Abbreviation, 1, MaxStrLen(ModifyUnitOfMeasure."PTA Abbreviation"));
        ModifyUnitOfMeasure."PTA Index Link" := PTAUnitMaster.Id;
        ModifyUnitOfMeasure."PTA ConversionFactor" := PTAUnitMaster.ConversionFactor;
        ModifyUnitOfMeasure."PTA ConvertFactorForOtherUnit" := PTAUnitMaster.ConversionFactorForOtherUnit;
        ModifyUnitOfMeasure."PTA isBaseUnit" := PTAUnitMaster.isBaseUnit;
        ModifyUnitOfMeasure."PTA IsDefaultUnitForPurchase" := PTAUnitMaster.IsDefaultUnitForPurchase;
        ModifyUnitOfMeasure."PTA IsGlobalBaseUnit" := PTAUnitMaster.IsGlobalBaseUnit;
        ModifyUnitOfMeasure."PTA IsDeleted" := PTAUnitMaster.isDeleted;
        ModifyUnitOfMeasure.Insert(true);
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}