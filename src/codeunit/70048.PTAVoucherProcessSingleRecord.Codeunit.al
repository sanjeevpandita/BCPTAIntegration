codeunit 70048 PTAVoucherProcessSingleRecord
{

    TableNo = PTAVouchers;

    trigger OnRun()
    var
        PTAVouchers: Record PTAVouchers;
    begin
        PTAVouchers := Rec;
        PTAVoucherValidation.Run(PTAVouchers);
        PTAVoucherProcessPost.run(PTAVouchers);
    end;

    var
        PTAVoucherValidation: Codeunit PTAVoucherValidation;

        PTAVoucherProcessPost: Codeunit PTAVoucherProcessPost;

}