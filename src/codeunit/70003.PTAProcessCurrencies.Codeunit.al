codeunit 70003 PTAProcessCurrencies
{
    tableno = PTACurrenciesMaster;

    trigger OnRun()
    begin
        ProcessCurrencyRecords(rec);
    end;

    local procedure ProcessCurrencyRecords(PTACurrenciesMaster: Record PTACurrenciesMaster)
    var
        ModifyPTACurrenciesMaster: Record PTACurrenciesMaster;
        Currency: Record Currency;
        ModifyCurrency: Record Currency;

        ModifyRecord: Boolean;
    begin
        //PTA MAPPING CODE PTACurrenciesMaster to Currency 
        if PTACurrenciesMaster.Abbreviation = '' then Error('Currency Abbreviation is Mandatory');

        ModifyRecord := false;
        Currency.Reset();
        Currency.SetRange("PTA Index Link", PTACurrenciesMaster.Id);
        if Currency.FindSet(true) then begin
            ModifyCurrency := Currency;

            //if Currency.Code <> Copystr(PTACurrenciesMaster.Abbreviation, 1, MaxStrLen(Currency.Code)).ToUpper() then begin
            if PTAHelperFunctions.Return15CharactersOfPK(Currency.Code) <> Copystr(PTACurrenciesMaster.Abbreviation, 1, 15).ToUpper() then begin
                ModifyCurrency."PTA Index Link" := 0;
                ModifyCurrency."PTA Abbreviation" := '';
                ModifyCurrency."PTA IsDeleted" := TRUE;
                ModifyCurrency.Modify();

                ModifyCurrency.Init();
                ModifyCurrency.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTACurrenciesMaster.Abbreviation, 1, 15), Database::Currency);//Copystr(PTACurrenciesMaster.Abbreviation, 1, MaxStrLen(ModifyCurrency.Code));
                ModifyCurrency.Description := Copystr(PTACurrenciesMaster.Name, 1, MaxStrLen(ModifyCurrency.Description));
                ModifyCurrency."PTA Abbreviation" := Copystr(PTACurrenciesMaster.Abbreviation, 1, MaxStrLen(ModifyCurrency."PTA Abbreviation"));
                ModifyCurrency."PTA Index Link" := PTACurrenciesMaster.Id;
                ModifyCurrency."PTA IsDeleted" := PTACurrenciesMaster.isDeleted;
                ModifyCurrency.Insert(true);
            end else begin
                if Currency.Description <> Copystr(PTACurrenciesMaster.Name, 1, MaxStrLen(Currency.Description)) then begin
                    ModifyCurrency.Description := Copystr(PTACurrenciesMaster.Name, 1, MaxStrLen(Currency.Description));
                    ModifyRecord := true;
                end;
                if Currency."PTA Abbreviation" <> Copystr(Currency."PTA Abbreviation", 1, MaxStrLen(Currency."PTA Abbreviation")) then begin
                    ModifyCurrency."PTA Abbreviation" := Copystr(PTACurrenciesMaster.Abbreviation, 1, MaxStrLen(Currency."PTA Abbreviation"));
                    ModifyRecord := true;
                end;
                if Currency."PTA IsDeleted" <> PTACurrenciesMaster.isDeleted then begin
                    ModifyCurrency."PTA IsDeleted" := PTACurrenciesMaster.isDeleted;
                    ModifyRecord := true;
                end;
                if ModifyRecord then
                    ModifyCurrency.Modify();
            end;
        end else begin
            ModifyCurrency.Init();
            ModifyCurrency.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTACurrenciesMaster.Abbreviation, 1, 15), Database::Currency);//Copystr(PTACurrenciesMaster.Abbreviation, 1, MaxStrLen(ModifyCurrency.Code));
            ModifyCurrency.Description := Copystr(PTACurrenciesMaster.Name, 1, MaxStrLen(ModifyCurrency.Description));
            ModifyCurrency."PTA Abbreviation" := Copystr(PTACurrenciesMaster.Abbreviation, 1, MaxStrLen(ModifyCurrency."PTA Abbreviation"));
            ModifyCurrency."PTA Index Link" := PTACurrenciesMaster.Id;
            ModifyCurrency."PTA IsDeleted" := PTACurrenciesMaster.isDeleted;
            ModifyCurrency.Insert(true);
        end;
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}