codeunit 70033 PTAProcessSupplyMarkets
{
    TableNo = PTABookDetails;

    trigger OnRun()
    begin
        PTASetup.get();
        ProcessSupplyMarkets(Rec);

    end;


    local procedure ProcessSupplyMarkets(PTABookDetails: Record PTABookDetails)
    var
        ModifyPTAPTABookDetails: Record PTABookDetails;

        DimensionValue: Record "Dimension Value";
        ModifyDimensionValue: Record "Dimension Value";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";

    begin
        //PTA MAPPING CODE PTABookDetails To "Supply Market" from PTA Setup Dimension Value 
        if PTABookDetails.Name = ' ' then
            Error('Supply Market Name is Mandatory');

        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", PTASetup."Supply Market Dimension");
        DimensionValue.SetRange("PTA Index Link", PTABookDetails.Id);
        if DimensionValue.FindSet(true) then begin
            ModifyDimensionValue := DimensionValue;

            if PTAHelperFunctions.Return15CharactersOfPK(DimensionValue.Code) <> CopyStr(PTABookDetails.Name.Replace('&', ' '), 1, 15) then begin
                ModifyDimensionValue."PTA Index Link" := 0;
                ModifyDimensionValue."PTA IsDeleted" := true;
                ModifyDimensionValue.Modify();
                PTAHelperFunctions.InsertDimensionValue(PTASetup."Supply market Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTABookDetails.Name, 1, 15).Replace('&', ' '), Database::"Dimension Value"),
                PTABookDetails.Name, PTABookDetails.Id, PTABookDetails.isDeleted);
            end else begin
                if DimensionValue.Name <> Copystr(PTABookDetails.Name, 1, MaxStrLen(DimensionValue.Name)) then begin
                    ModifyDimensionValue.Name := Copystr(PTABookDetails.Name, 1, MaxStrLen(DimensionValue.Name));
                    ModifyDimensionValue."PTA IsDeleted" := PTABookDetails.isDeleted;
                    ModifyDimensionValue.Modify();
                end;
            end;
        end else
            PTAHelperFunctions.InsertDimensionValue(PTASetup."Supply market Dimension", PTAHelperFunctions.GetNewNextCode(Copystr(PTABookDetails.Name, 1, 15).Replace('&', ' '), Database::"Dimension Value"),
                PTABookDetails.Name, PTABookDetails.Id, PTABookDetails.isDeleted);
    end;

    var
        PTASetup: Record "PTA Setup";
}