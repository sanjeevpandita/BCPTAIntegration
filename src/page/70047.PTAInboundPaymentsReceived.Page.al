page 70047 "PTA Inbound Payments Received"
{
    ApplicationArea = All;
    Caption = 'PTA Inbound Payments Received';
    PageType = List;
    SourceTable = PTAInboundPaymentsReceived;
    UsageCategory = Lists;
    CardPageId = PTAInboundPaymentsReceivedCard;
    SourceTableView = SORTING(EntryNo) ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(BuyingCompanyId; Rec.BCBuyingCompanyId)
                {
                }
                field(BankExistsInThisCompany; Rec.BankExistsInThisCompany)
                {
                    ToolTip = 'Specifies the value of the BankExistsInThisCompany field.';
                }
                field(PaymentDate; Rec.PaymentDate)
                {
                    ToolTip = 'Specifies the value of the PaymentDate field.';
                }
                field(Charges; Rec.Charges)
                {
                    ToolTip = 'Specifies the value of the Charges field.';
                }
                field(PaymentRef; Rec.PaymentRef)
                {
                    ToolTip = 'Specifies the value of the PaymentRef field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }

                field(AmountReceivedPrice; Rec.AmountReceivedPrice)
                {
                    ToolTip = 'Specifies the value of the AmountReceivedPrice field.';
                }
                field(AmountReceivedCurrencyId; Rec.AmountReceivedCurrencyId)
                {
                    ToolTip = 'Specifies the value of the AmountReceivedCurrencyId field.';
                }
                field(AllocatedAmountPrice; Rec.AllocatedAmountPrice)
                {
                    ToolTip = 'Specifies the value of the AllocatedAmountPrice field.';
                }
                field(AllocatedAmountCurrencyId; Rec.AllocatedAmountCurrencyId)
                {
                    ToolTip = 'Specifies the value of the AllocatedAmountCurrencyId field.';
                }
                field(CounterpartyId; Rec.CounterpartyId)
                {
                    ToolTip = 'Specifies the value of the CounterpartyId field.';
                }
                field(BankAccountId; Rec.BankAccountId)
                {
                    ToolTip = 'Specifies the value of the BankAccountId field.';
                }
                field(AmountInUSD; Rec.AmountInUSD)
                {
                    ToolTip = 'Specifies the value of the AmountInUSD field.';
                }
            }
        }
    }
}
