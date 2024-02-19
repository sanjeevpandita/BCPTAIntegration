codeunit 70030 PTAClearProductAndResources
{
    Permissions = TableData "Item Ledger Entry" = rd, TableData "Res. Ledger Entry" = rd, TableData "Value Entry" = rd;
    trigger OnRun()
    begin
        ProcessCounterpartyMaster();
        // Customer.ModifyAll("Gen. Bus. Posting Group", 'COUNTERPT');
        // Customer.ModifyAll("VAT Bus. Posting Group", 'ZERORATE');
        // Customer.ModifyAll("Customer Posting Group", 'COUNTERPT');

        // Vendor.ModifyAll("Gen. Bus. Posting Group", 'COUNTERPT');
        // Vendor.ModifyAll("VAT Bus. Posting Group", 'ZERORATE');
        // Vendor.ModifyAll("Vendor Posting Group", 'COUNTERPT');
        // item.reset;
        // item.deleteall(true);
        // ile.Reset();
        // ile.DeleteAll();

        // ve.Reset();
        // ve.DeleteAll();

        // PurchaseHeader.deleteall();
        // PurchaseLine.deleteall;
        // SalesHEader.deleteall();
        // SalesLine.deleteall();

        // RLE.Reset();
        // RLE.DeleteAll();
        // resource.reset;
        // resource.deleteall;

        // PTAProductMaster.modifyall(Processed, 0);
        // PTAProductMaster.modifyall(ProcessedDateTime, 0DT);
        // PTAProductMaster.ModifyAll(ErrorDateTime, 0DT);
        // PTAProductMaster.ModifyAll(ErrorMessage, '');

        // PTAAddCostDetailsMaster.modifyall(Processed, 0);
        // PTAAddCostDetailsMaster.modifyall(ProcessedDateTime, 0DT);
        // PTAAddCostDetailsMaster.ModifyAll(ErrorDateTime, 0DT);
        // PTAAddCostDetailsMaster.ModifyAll(ErrorMessage, '');

        // PTACostTypeMaster.modifyall(Processed, 0);
        // PTACostTypeMaster.modifyall(ProcessedDateTime, 0DT);
        // PTACostTypeMaster.ModifyAll(ErrorDateTime, 0DT);
        // PTACostTypeMaster.ModifyAll(ErrorMessage, '');
        Message('Done');
    end;

    local procedure ProcessCounterpartyMaster()
    var
        PTACounterpartiesMaster: Record PTACounterpartiesMaster;
        ModifyPTACounterpartiesMaster: Record PTACounterpartiesMaster;
        PTAProcessCounterparties: Codeunit PTAProcessCounterparties;
        hasError: Boolean;
    begin
        //PTA MAPPING CODE PTACounterpartiesMaster to Contact 
        hasError := false;
        PTACounterpartiesMaster.Reset();
        PTACounterpartiesMaster.SetRange(Processed, 1);
        if PTACounterpartiesMaster.FindSet(true) then
            repeat
                ClearLastError();
                Commit();
                if not PTAProcessCounterparties.run(PTACounterpartiesMaster) then begin
                    ModifyPTACounterpartiesMaster := PTACounterpartiesMaster;
                    ModifyPTACounterpartiesMaster.Processed := 2;
                    ModifyPTACounterpartiesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACounterpartiesMaster.ErrorDateTime := CurrentDateTime;
                    ModifyPTACounterpartiesMaster.ErrorMessage := CopyStr(GetLastErrorText(), 1, maxstrlen(ModifyPTACounterpartiesMaster.ErrorMessage));
                    ModifyPTACounterpartiesMaster.Modify();
                end else begin
                    ModifyPTACounterpartiesMaster := PTACounterpartiesMaster;
                    ModifyPTACounterpartiesMaster.Processed := 1;
                    ModifyPTACounterpartiesMaster.ProcessedDateTime := CurrentDateTime;
                    ModifyPTACounterpartiesMaster.ErrorDateTime := 0DT;
                    ModifyPTACounterpartiesMaster.ErrorMessage := '';
                    ModifyPTACounterpartiesMaster.Modify();
                end;
            until PTACounterpartiesMaster.next = 0;
    end;

    var
        item: Record item;
        Resource: Record Resource;
        PTAProductMaster: Record PTAProductMaster;
        PTAAddCostDetailsMaster: Record PTAAddCostDetailsMaster;
        PTACostTypeMaster: Record PTACostTypeMaster;
        ILE: Record "Item Ledger Entry";
        VE: Record "Value Entry";
        RLE: Record "Res. Ledger Entry";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        vendor: Record vendor;
}