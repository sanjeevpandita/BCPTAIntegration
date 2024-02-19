codeunit 70013 PTAProcessBusinessAreas
{
    TableNo = PTABusinessAreasMaster;

    trigger OnRun()
    begin
        PTASetup.get();
        ProcessBusinessAreaRecords(Rec);
    end;


    local procedure ProcessBusinessAreaRecords(PTABusinessAreasMaster: Record PTABusinessAreasMaster)
    var
        DimensionValue: Record "Dimension Value";
        ModifyDimensionValue: Record "Dimension Value";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
    begin
        //PTA MAPPING CODE PTABusinessArea To "Business Area" from PTA Setup Dimension Value 
        if PTABusinessAreasMaster.BusinessAreaName = '' then
            Error('Business Area Name is Mandatory');

        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", PTASetup."Business Area Dimension");
        DimensionValue.SetRange("PTA Index Link", PTABusinessAreasMaster.Id);
        if DimensionValue.FindSet(true) then begin
            ModifyDimensionValue := DimensionValue;
            //if DimensionValue.code <> Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, MaxStrLen(DimensionValue.Code)).ToUpper() then begin
            if PTAHelperFunctions.Return15CharactersOfPK(DimensionValue.code) <> Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, 15).ToUpper() then begin
                ModifyDimensionValue."PTA Index Link" := 0;
                ModifyDimensionValue."PTA IsDeleted" := true;
                ModifyDimensionValue.Modify();
                //PTAHelperFunctions.InsertDimensionValue(PTASetup."Business Area Dimension", Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, MaxStrLen(DimensionValue.Code)),
                PTAHelperFunctions.InsertDimensionValue(PTASetup."Business Area Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, 15), Database::"Dimension Value"),
                  PTABusinessAreasMaster.BusinessAreaName, PTABusinessAreasMaster.Id, PTABusinessAreasMaster.isDeleted);
            end else begin
                if DimensionValue.Name <> Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, MaxStrLen(DimensionValue.Name)) then begin
                    ModifyDimensionValue.Name := Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, MaxStrLen(DimensionValue.Name));
                    ModifyDimensionValue."PTA IsDeleted" := PTABusinessAreasMaster.isDeleted;
                    ModifyDimensionValue.Modify();
                end;
            end;
        end else
            //PTAHelperFunctions.InsertDimensionValue(PTASetup."Business Area Dimension", Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, MaxStrLen(DimensionValue.Code)),
            PTAHelperFunctions.InsertDimensionValue(PTASetup."Business Area Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTABusinessAreasMaster.BusinessAreaName, 1, 15), Database::"Dimension Value"),
                    PTABusinessAreasMaster.BusinessAreaName, PTABusinessAreasMaster.Id, PTABusinessAreasMaster.isDeleted);
    end;


    var
        PTASetup: Record "PTA Setup";
}