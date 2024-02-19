page 70028 "PTA Integration"
{
    PageType = ListPlus;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = False;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            Group(Mygrid)
            {
                ShowCaption = false;
                part(Log; "PTA Integration Log")
                {
                    ApplicationArea = all;
                }

                part(Entries; "PTA Integration Entry Log")
                {
                    ApplicationArea = all;
                    Provider = Log;
                    SubPageLink = HeaderEntryNo = field("Entry No.");
                }
            }
        }

    }
    actions
    {

        area(Promoted)
        {
            group(SyncData)
            {
                ShowAs = SplitButton;
                actionref(PromotedSyncMasterData; SyncMasterData)
                { }
                actionref(PromotedSyncTransactionData; SyncTransactionalData)
                { }
                actionref(PromotedSyncCustomerInvoices; SyncCustomerInvoices)
                { }
                actionref(PromotedSyncCustomerPayments; SyncCustomerPayments)
                { }
                actionref(PromotedVoucher; SyncVouchers)
                { }
                actionref(PromotedVoucherPayment; SyncVoucherPayments)
                { }
            }
        }
        area(Processing)
        {
            action(SyncMasterData)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Sync Master Data';

                trigger OnAction()
                var
                    STOPTAProcessMasterData: Codeunit "PTA Process Master Data";
                begin
                    Clear(STOPTAProcessMasterData);
                    STOPTAProcessMasterData.Run();
                    CurrPage.Update(false);
                end;
            }
            action(SyncTransactionalData)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Sync Enquiries';

                trigger OnAction()
                var
                    PTAProcessTransactionData: Codeunit PTAProcessTransactionData;
                begin
                    Clear(PTAProcessTransactionData);
                    PTAProcessTransactionData.Run();
                    CurrPage.Update(false);
                end;
            }
            action(SyncCustomerInvoices)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Sync Customer Invoices';

                trigger OnAction()
                var
                    PTACustomerInvoiceProcess: Codeunit PTACustomerInvoiceProcess;
                    PTAProcessTransactionData: Codeunit PTAProcessTransactionData;
                begin
                    Clear(PTAProcessTransactionData);
                    Clear(PTACustomerInvoiceProcess);
                    PTAProcessTransactionData.Run();
                    PTACustomerInvoiceProcess.Run();

                    CurrPage.Update(false);
                end;
            }
            action(SyncCustomerPayments)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Sync Customer Payments';

                trigger OnAction()
                var
                    PTAInboundPymtReceivedProcess: Codeunit PTAInboundPymtReceivedProcess;
                begin
                    Clear(PTAInboundPymtReceivedProcess);
                    PTAInboundPymtReceivedProcess.Run();
                    CurrPage.Update(false);
                end;
            }
            action(SyncVouchers)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Sync Vouchers';

                trigger OnAction()
                var
                    PTAVoucherProcess: Codeunit PTAVoucherProcess;
                begin
                    Clear(PTAVoucherProcess);
                    PTAVoucherProcess.Run();

                    CurrPage.Update(false);
                end;
            }
            action(SyncVoucherPayments)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Sync Voucher Payments';

                trigger OnAction()
                var
                    PTAOutboundPymtReceivedProcess: Codeunit PTAOutboundPymtReceivedProcess;
                begin
                    Clear(PTAOutboundPymtReceivedProcess);
                    PTAOutboundPymtReceivedProcess.Run();
                    CurrPage.Update(false);
                end;
            }
            // action(UpdateDImensionsFromUsers)
            // {
            //     ApplicationArea = All;
            //     Image = Start;
            //     Caption = 'Sync Dimension';

            //     trigger OnAction()
            //     var
            //         UpdateDImensionsFromUsers: Codeunit UpdateDImensionsFromUsers;
            //     begin
            //         Clear(UpdateDImensionsFromUsers);
            //         UpdateDImensionsFromUsers.Run();
            //         CurrPage.Update(false);
            //     end;
            // }

            group(ResetDateGrp)
            {
                // Caption = 'Reset Data';
                // action(ResetData)
                // {
                //     ApplicationArea = All;
                //     Image = DeleteAllBreakpoints;
                //     Caption = 'Reset Data PTA and BC Data';

                //     trigger OnAction()
                //     var
                //         STOResetData: Codeunit "STO Reset Data";
                //     begin
                //         STOResetData.run();
                //     end;
                // }

                action(ReprocessCounterparties)
                {
                    ApplicationArea = All;
                    Image = DeleteAllBreakpoints;
                    Caption = 'Reprocess Counterparties';

                    trigger OnAction()
                    var
                        PTAClearProductAndResources: Codeunit PTAClearProductAndResources;
                    begin
                        PTAClearProductAndResources.run();
                    end;
                }

                action(ClearIntegrationLog)
                {
                    ApplicationArea = All;
                    Image = DeleteAllBreakpoints;
                    Caption = 'Clear Integration Log';

                    trigger OnAction()
                    var
                        PTAIntegrationLog: Record "PTA Integration Log";
                        PTAIntegrationEntryLog: Record "PTA Integration Entry Log";
                    begin
                        PTAIntegrationLog.LockTable();
                        PTAIntegrationLog.DeleteAll();

                        PTAIntegrationEntryLog.LockTable();
                        PTAIntegrationEntryLog.DeleteAll();
                        CurrPage.Update();
                    end;
                }
            }
        }
    }
}
