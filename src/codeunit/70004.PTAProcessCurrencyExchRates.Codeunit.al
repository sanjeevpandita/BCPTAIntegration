codeunit 70004 PTAProcessCurrencyExchRates
{

    TableNo = PTACurrencyExchRate;

    trigger OnRun()
    begin
        ProcessCurrencyExchangeRates(rec);
    end;

    procedure ProcessCurrencyExchangeRates(PTACurrencyExchRate: Record PTACurrencyExchRate)
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";

    begin
        if PTACurrencyExchRate.ConversionRate = 0 then exit;

        if PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTACurrencyExchRate.CurrencyID) = '' then
            Error('Currency Not found for ID %1', PTACurrencyExchRate.CurrencyID);

        if PTACurrencyExchRate.RateDate = 0D then
            Error('No Rate Date');

        if not CurrencyExchangeRate.get(PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTACurrencyExchRate.CurrencyID), PTACurrencyExchRate.RateDate) then begin
            CurrencyExchangeRate.Init();
            CurrencyExchangeRate."Currency Code" := PTABCMappingtoIndexID.GetCurrencyCodeByPTAIndexID(PTACurrencyExchRate.CurrencyID);
            CurrencyExchangeRate."Starting Date" := PTACurrencyExchRate.RateDate;
            CurrencyExchangeRate."Exchange Rate Amount" := 1;
            CurrencyExchangeRate."Adjustment Exch. Rate Amount" := 1;
            CurrencyExchangeRate."Relational Adjmt Exch Rate Amt" := PTACurrencyExchRate.ConversionRate;
            CurrencyExchangeRate."Relational Exch. Rate Amount" := PTACurrencyExchRate.ConversionRate;
            CurrencyExchangeRate.Insert();
        end else begin
            CurrencyExchangeRate."Exchange Rate Amount" := 1;
            CurrencyExchangeRate."Adjustment Exch. Rate Amount" := 1;
            CurrencyExchangeRate."Relational Adjmt Exch Rate Amt" := PTACurrencyExchRate.ConversionRate;
            CurrencyExchangeRate."Relational Exch. Rate Amount" := PTACurrencyExchRate.ConversionRate;
            CurrencyExchangeRate.Modify();
        end;
    end;
}