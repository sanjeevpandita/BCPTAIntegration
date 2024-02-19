codeunit 70056 SetVATToleranceOnSalesOrder
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::PTAEnquiryConvertToDocuments, 'OnBeforeSalesDocumentVATValidation', '', false, false)]
    local procedure PTAEnquiryConvertToDocuments_OnBeforeSalesDocumentVATValidation(var SkipVATToleranceCheck: Boolean)
    begin
        SkipVATToleranceCheck := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::PTAEnquiryConvertToDocuments, 'OnBeforePurchaseDocumentVATValidation', '', false, false)]
    local procedure PTAEnquiryConvertToDocuments_OnBeforePurchaseDocumentVATValidation(var SkipVATToleranceCheck: Boolean)
    begin
        SkipVATToleranceCheck := true;
    end;
}