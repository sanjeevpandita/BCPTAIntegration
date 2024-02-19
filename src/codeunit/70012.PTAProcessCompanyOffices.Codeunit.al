codeunit 70012 PTAProcessCompanyOffices
{
    TableNo = PTACompanyOfficesMaster;

    trigger OnRun()
    begin
        PTASetup.Get();
        PTASetup.TestField("Office Dimension Code");
        PTAProcessCompanyOffices(Rec);
    end;


    local procedure PTAProcessCompanyOffices(PTACompanyOfficesMaster: Record PTACompanyOfficesMaster)
    var
        DimensionValue: Record "Dimension Value";
        ModifyDimensionValue: Record "Dimension Value";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";

    begin
        //PTA MAPPING CODE PTACompanyOfficesMaster To "Office Dimension" from PTA Setup Dimension Value 
        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", PTASetup."Office Dimension Code");
        DimensionValue.SetRange("PTA Index Link", PTACompanyOfficesMaster.Id);
        if DimensionValue.findset(true) then begin
            ModifyDimensionValue := DimensionValue;
            //if DimensionValue.code <> Copystr(PTACompanyOfficesMaster.Name, 1, MaxStrLen(DimensionValue.Code)).ToUpper() then begin
            if PTAHelperFunctions.Return15CharactersOfPK(DimensionValue.code) <> Copystr(PTACompanyOfficesMaster.Name, 1, 17).ToUpper() then begin
                ModifyDimensionValue."PTA Index Link" := 0;
                ModifyDimensionValue.Modify();
                //PTAHelperFunctions.InsertDimensionValue(PTASetup."Office Dimension Code", Copystr(PTACompanyOfficesMaster.Name, 1, MaxStrLen(DimensionValue.Code)),
                PTAHelperFunctions.InsertDimensionValue(PTASetup."Office Dimension Code", PTAHelperFunctions.GetNewNextCode(Copystr(PTACompanyOfficesMaster.Name, 1, 15), Database::"Dimension Value"),
                   PTACompanyOfficesMaster.Name, PTACompanyOfficesMaster.Id, PTACompanyOfficesMaster.isDeleted);
            end else begin
                if DimensionValue.Name <> Copystr(PTACompanyOfficesMaster.Name, 1, MaxStrLen(DimensionValue.Name)) then begin
                    ModifyDimensionValue.Name := Copystr(PTACompanyOfficesMaster.Name, 1, MaxStrLen(DimensionValue.Name));
                    ModifyDimensionValue.Modify();
                end;
            end;
        end else
            //PTAHelperFunctions.InsertDimensionValue(PTASetup."Office Dimension Code", Copystr(PTACompanyOfficesMaster.Name, 1, MaxStrLen(DimensionValue.Code)),
            PTAHelperFunctions.InsertDimensionValue(PTASetup."Office Dimension Code", PTAHelperFunctions.GetNewNextCode(Copystr(PTACompanyOfficesMaster.Name, 1, 15), Database::"Dimension Value"),
                PTACompanyOfficesMaster.Name, PTACompanyOfficesMaster.Id, PTACompanyOfficesMaster.isDeleted);
    end;

    var
        PTASetup: Record "PTA Setup";
}