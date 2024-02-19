codeunit 70025 PTAEnquiryProcessSingleRecord
{

    TableNo = PTAEnquiry;

    trigger OnRun()
    var
        PTAEnquiry: Record PTAEnquiry;
    begin
        PTAEnquiry := Rec;
        case PTAEnquiry.StatusId of
            15, 16:
                begin
                    ValidateEnquiry.Run(PTAEnquiry);
                    PTAConvertEnquiryToDocuments.run(PTAEnquiry);
                end;
            8:
                begin
                    ValidateEnquiry.Run(PTAEnquiry);
                    PTAConvertEnquiryToDocuments.run(PTAEnquiry);
                    PTAShipEnquiry.Run(PTAEnquiry);
                end;
            7:
                CancelEnquiry.Run(PTAEnquiry);
        end;
    end;

    var
        ValidateEnquiry: Codeunit PTAEnquiryValidate;
        PTAShipEnquiry: Codeunit "PTAEnquiryShip";
        PTAConvertEnquiryToDocuments: Codeunit PTAEnquiryConvertToDocuments;
        CancelEnquiry: Codeunit PTAEnquiryCancel;
}