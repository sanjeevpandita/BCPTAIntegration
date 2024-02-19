codeunit 70055 UpdateDImensionsFromUsers
{
    trigger OnRun()
    begin
        updatePurchaseOrders
        // PTASetup.get();
        // GLSetup.get();
        // ProcessUserRecords();
    end;


    local procedure ProcessUserRecords()
    var
        PTAUsersMaster: Record PTAUsersMaster;
        Salesperson: Record "Salesperson/Purchaser";
        PTAProcessUsers: Codeunit PTAProcessUsers;
    begin
        //PTA MAPPING CODE PTAUsersMaster To Salesperon/Purchaser from PTA Setup Dimension Value 
        OfficeDimensionCode := '';

        PTAUsersMaster.reset;
        if PTAUsersMaster.FindSet(true) then begin
            repeat
                Salesperson.Reset();
                Salesperson.SetRange("PTA Index Link", PTAUsersMaster.Id);
                if Salesperson.findfirst then begin
                    OfficeDimensionCode := PTABCMappingtoIndexID.GetOfficeDimensionByPTAIndexID(PTAUsersMaster.OfficeId);
                    SetDimensionCodes(PTASetup."Trader Dimension", Salesperson.Code, Salesperson);
                    SetDimensionCodes(PTASetup."Office Dimension Code", OfficeDimensionCode, Salesperson);
                    Salesperson.Modify();
                    InsertDefaultDimensionValues(Salesperson, Salesperson.code, OfficeDimensionCode);
                end else begin
                    if PTAProcessUsers.run(PTAUsersMaster) then;
                end;
            until PTAUsersMaster.Next() = 0;
        end;
    end;

    procedure updatePurchaseOrders()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        if PurchaseHeader.FindSet(true) then begin
            repeat
                if PurchaseLine.get(PurchaseHeader."Document Type", PurchaseHeader."No.", 10000) then begin
                    SalesLine.reset;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.setrange("PTA Line Entity Type", PurchaseLine."PTA Line Entity Type");
                    SalesLine.setrange("PTA Line Entity ID", PurchaseLine."PTA Line Entity ID");
                    if SalesLine.FindFirst() then begin
                        PurchaseHeader."PTA Purch. Currency ID" := SalesLine."PTA Purch. Currency ID";
                        PurchaseHeader.Modify();
                    end else begin
                        SalesInvoiceLine.reset;
                        SalesInvoiceLine.setrange("PTA Line Entity Type", PurchaseLine."PTA Line Entity Type");
                        SalesInvoiceLine.setrange("PTA Line Entity ID", PurchaseLine."PTA Line Entity ID");
                        if SalesInvoiceLine.FindFirst() then begin
                            PurchaseHeader."PTA Purch. Currency ID" := SalesInvoiceLine."PTA Purch. Currency ID";
                            PurchaseHeader.Modify();
                        end;
                    end;
                end;
            until PurchaseHeader.Next() = 0;
        end;

        Message('done');

    end;


    procedure SetDimensionCodes(DimensionCode: Code[20]; DimensionValueCode: Code[20]; var ModifySalesperson: Record "Salesperson/Purchaser")
    begin
        if DimensionValueCode = '' then exit;

        Case DimensionCode of
            GLSetup."Global Dimension 1 Code":
                ModifySalesperson.validate("Global Dimension 1 Code", DimensionValueCode);
            GLSetup."Global Dimension 2 Code":
                ModifySalesperson.validate("Global Dimension 2 Code", ModifySalesperson.Code);
        End;
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