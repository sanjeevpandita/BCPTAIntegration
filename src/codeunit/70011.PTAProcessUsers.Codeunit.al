codeunit 70011 "PTAProcessUsers"
{
    TableNo = PTAUsersMaster;

    trigger OnRun()
    begin
        PTASetup.get();
        GLSetup.get();
        PTASetup.TestField("Trader Dimension");
        ProcessUserRecords(Rec);
    end;


    local procedure ProcessUserRecords(var PTAUsersMaster: Record PTAUsersMaster)
    var
        ModifyPTAPortMaster: Record PTAUsersMaster;
        Salesperson: Record "Salesperson/Purchaser";
        ModifySalesperson: Record "Salesperson/Purchaser";
    begin
        //PTA MAPPING CODE PTAUsersMaster To Salesperon/Purchaser from PTA Setup Dimension Value 
        OfficeDimensionCode := '';
        if PTAUsersMaster.UserName = '' then
            error('User Name is Mandatory');

        Salesperson.Reset();
        Salesperson.SetRange("PTA Index Link", PTAUsersMaster.Id);
        if Salesperson.FindSet(true) then begin
            ModifySalesperson := Salesperson;

            if Salesperson.Code <> Copystr(PTAUsersMaster.UserName, 1, 15).ToUpper() then begin
                ModifySalesperson."PTA Index Link" := 0;
                ModifySalesperson."PTA Ignore Expense Claims" := false;
                ModifySalesperson."PTA User Short Name" := '';
                ModifySalesperson."E-Mail" := '';
                ModifySalesperson.validate("Global Dimension 2 Code", '');
                ModifySalesperson."PTA IsDeleted" := true;
                ModifySalesperson.Modify();

                ModifySalesperson.Init();
                ModifySalesperson.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAUsersMaster.UserName, 1, 15), Database::"Salesperson/Purchaser");
                ModifySalesperson.Name := Copystr(PTAUsersMaster.FullName, 1, MaxStrLen(ModifySalesperson.Name));
                ModifySalesperson."PTA Index Link" := PTAUsersMaster.Id;
                ModifySalesperson."PTA User Short Name" := PTAUsersMaster.UserName;
                ModifySalesperson."E-Mail" := PTAUsersMaster.Email;
                ModifySalesperson."PTA IsDeleted" := PTAUsersMaster.isDeleted;
                ModifySalesperson.Insert();
                ProcessUserRecordsForDimensions(PTAUsersMaster, ModifySalesperson.Code);
            end else begin
                ModifySalesperson.Name := Copystr(PTAUsersMaster.FullName, 1, MaxStrLen(ModifySalesperson.Name));
                ModifySalesperson."E-Mail" := PTAUsersMaster.Email;
                ModifySalesperson."PTA User Short Name" := PTAUsersMaster.UserName;
                ModifySalesperson."PTA IsDeleted" := PTAUsersMaster.isDeleted;
                ModifySalesperson.Modify();
            end;
        end else begin
            ModifySalesperson.Init();
            ModifySalesperson.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAUsersMaster.UserName, 1, 15), Database::"Salesperson/Purchaser");
            ModifySalesperson.Name := Copystr(PTAUsersMaster.FullName, 1, MaxStrLen(ModifySalesperson.Name));
            ModifySalesperson."E-Mail" := PTAUsersMaster.Email;
            ModifySalesperson."PTA Index Link" := PTAUsersMaster.Id;
            ModifySalesperson."PTA User Short Name" := PTAUsersMaster.UserName;
            ModifySalesperson."PTA IsDeleted" := PTAUsersMaster.isDeleted;
            ModifySalesperson.Insert();
            ProcessUserRecordsForDimensions(PTAUsersMaster, ModifySalesperson.Code);
        end;
        OfficeDimensionCode := PTABCMappingtoIndexID.GetOfficeDimensionByPTAIndexID(PTAUsersMaster.OfficeId);
        SetDimensionCodes(PTASetup."Trader Dimension", ModifySalesperson.Code, ModifySalesperson);
        SetDimensionCodes(PTASetup."Office Dimension Code", OfficeDimensionCode, ModifySalesperson);
        ModifySalesperson.Modify();

        InsertDefaultDimensionValues(ModifySalesperson, ModifySalesperson.code, OfficeDimensionCode);
    end;

    procedure SetDimensionCodes(DimensionCode: Code[20]; DimensionValueCode: Code[20]; ModifySalesperson: Record "Salesperson/Purchaser")
    begin
        if DimensionValueCode = '' then exit;

        Case DimensionCode of
            GLSetup."Global Dimension 1 Code":
                ModifySalesperson.validate("Global Dimension 1 Code", DimensionValueCode);
            GLSetup."Global Dimension 2 Code":
                ModifySalesperson.validate("Global Dimension 2 Code", ModifySalesperson.Code);
        End;
    end;


    local procedure ProcessUserRecordsForDimensions(var PTAUsersMaster: Record PTAUsersMaster; DimensionCodeValue: Code[20])
    var
        DimensionValue: Record "Dimension Value";
        ModifyDimensionValue: Record "Dimension Value";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
    begin
        //PTA MAPPING CODE PTAUsersMaster To "SalesPerson Dimension" from PTA Setup Dimension Value 
        DimensionValue.reset;
        DimensionValue.SetRange("Dimension Code", PTASetup."Trader Dimension");
        DimensionValue.SetRange("PTA Index Link", PTAUsersMaster.Id);
        if DimensionValue.findset(true) then begin
            ModifyDimensionValue := DimensionValue;
            if (DimensionValue.code <> DimensionCodeValue) then begin
                ModifyDimensionValue."PTA Index Link" := 0;
                ModifyDimensionValue.Modify();
                PTAHelperFunctions.InsertDimensionValue(PTASetup."Trader Dimension", DimensionCodeValue, PTAUsersMaster.username, PTAUsersMaster.Id, PTAUsersMaster.isDeleted);
            end else begin
                if DimensionValue.Name <> Copystr(PTAUsersMaster.username, 1, MaxStrLen(DimensionValue.Name)) then begin
                    ModifyDimensionValue.Name := Copystr(PTAUsersMaster.username, 1, MaxStrLen(DimensionValue.Name));
                    ModifyDimensionValue.Modify();
                end;
            end;
        end else
            PTAHelperFunctions.InsertDimensionValue(PTASetup."Trader Dimension", DimensionCodeValue, PTAUsersMaster.username, PTAUsersMaster.Id, PTAUsersMaster.isDeleted);
    end;

    local procedure InsertDefaultDimensionValues(ModifySalesperson: Record "Salesperson/Purchaser"; SalesPersonCode: Code[20]; OfficeDimensionCode: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin
        if not DefaultDimension.get(Database::"Salesperson/Purchaser", SalesPersonCode, PTASetup."Trader Dimension") then begin
            DefaultDimension.init();
            DefaultDimension."Table ID" := Database::"Salesperson/Purchaser";
            DefaultDimension."No." := SalesPersonCode;
            DefaultDimension."Dimension Code" := PTASetup."Trader Dimension";
            DefaultDimension."Dimension Value Code" := SalesPersonCode;
            DefaultDimension.Insert();
        end;

        if not DefaultDimension.get(Database::"Salesperson/Purchaser", SalesPersonCode, PTASetup."Office Dimension Code") then begin
            DefaultDimension.init();
            DefaultDimension."Table ID" := Database::"Salesperson/Purchaser";
            DefaultDimension."No." := SalesPersonCode;
            DefaultDimension."Dimension Code" := PTASetup."Office Dimension Code";
            DefaultDimension."Dimension Value Code" := OfficeDimensionCode;
            DefaultDimension.Insert();
        end else begin
            DefaultDimension."Dimension Value Code" := OfficeDimensionCode;
            DefaultDimension.Modify();
        end;



    end;

    var
        PTASetup: Record "PTA Setup";
        GLSetup: Record "General Ledger Setup";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        OfficeDimensionCode: Code[20];
}