codeunit 70014 PTAProcessProductsAndResources
{
    TableNo = PTAProductMaster;

    trigger OnRun()
    var
    begin
        PTaSetup.get();
        PTaSetup.testfield("item Template code");
        PTaSetup.testfield("Resource Template code");
        PTaSetup.testfield("Resource Product Type");

        if Rec.ProductType = 0 then Error('Product Type missing for the item %1', Rec.ProductName);

        if PTaSetup."Resource Product Type" = '' then
            Error('Product Type missing in PTA Product Master');

        if PTABCMappingtoIndexID.GetItemCategoryByPTAIndex(rec.ProductType) = '' then
            Error(StrSubstNo('Product Type %1 mapping to Standard BC missing'), rec.ProductType);

        if isResource(Format(Rec.ProductType), PTaSetup."Resource Product Type") then
            ProcessResources(Rec)
        else
            ProcessProducts(Rec)
    end;

    procedure isResource(ProductType: code[10]; ResourceProductTypeFromSetup: text[30]): Boolean
    var
        SplitSting: List of [Text];
        ProductTypeWordCount: Integer;
    begin
        SplitSting := ResourceProductTypeFromSetup.Split(',');
        for ProductTypeWordCount := 1 to SplitSting.Count do begin
            if ProductType = SplitSting.Get(ProductTypeWordCount) then
                exit(true);
        end;
        exit(false);
    end;

    local procedure ProcessProducts(PTAProductMaster: Record PTAProductMaster)
    var
        Item: Record Item;
        ModifyItem: Record Item;

    begin
        //PTA MAPPING CODE PTAProductMaster To "Items" 

        Item.Reset();
        Item.SetRange("PTA Index Link", PTAProductMaster.Id);
        if Item.FindSet(true) then begin
            ModifyItem := Item;

            if Copystr(Item."No.", 1, 15) <> Copystr(PTAProductMaster.ProductName, 1, 15) then begin
                ModifyItem."PTA Index Link" := 0;
                ModifyItem."PTA Density" := 0;
                ModifyItem."PTA IsClaimSettlement" := false;
                ModifyItem."PTA IsFuel" := false;
                ModifyItem."PTA isPhysicalSupplyProduct" := false;
                ModifyItem."PTA IsAgency" := False;
                ModifyItem."PTA IsDeleted" := true;
                ModifyItem.Modify();

                CreateItemFromTemplate(ModifyItem, PTAProductMaster);
            end else begin
                ModifyItem.Description := Copystr(PtaproductMaster.ProductName, 1, MaxStrLen(Item.Description));
                ModifyItem."PTA Density" := PtaproductMaster.Density;
                ModifyItem."PTA IsClaimSettlement" := PtaproductMaster.IsClaimSettlement;
                ModifyItem."PTA IsFuel" := PtaproductMaster.IsFuel;
                ModifyItem."PTA isPhysicalSupplyProduct" := PtaproductMaster.isPhysicalSupplyProduct;
                ModifyItem."PTA IsAgency" := PtaproductMaster.IsAgency;
                ModifyItem."PTA IsDeleted" := PtaproductMaster.isDeleted;
                ModifyItem.Modify();
            end;
        end else
            CreateItemFromTemplate(ModifyItem, PTAProductMaster);
    end;

    local Procedure CreateItemFromTemplate(var Item: Record Item; PtaproductMaster: Record PTAProductMaster)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ItemRecRef: RecordRef;

        NewItemNo: COde[20];
        i: Integer;
    begin
        ConfigTemplateHeader.GET(PTaSetup."Item Template Code");

        NewItemNo := PTAHelperFunctions.GetNewNextCode(Copystr(PtaproductMaster.ProductName, 1, 15), Database::Item);

        Item.INIT;
        Item."No." := NewItemNo;
        Item.Description := Copystr(PtaproductMaster.ProductName, 1, MaxStrLen(Item.Description));
        Item."PTA Index Link" := PtaproductMaster.Id;
        Item.INSERT(TRUE);
        ItemRecRef.GETTABLE(Item);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ItemRecRef);
        ItemRecRef.Modify();

        if Item.get(NewItemNo) then begin
            Item."PTA Density" := PtaproductMaster.Density;
            item."PTA IsClaimSettlement" := PtaproductMaster.IsClaimSettlement;
            item."PTA IsFuel" := PtaproductMaster.IsFuel;
            item."PTA isPhysicalSupplyProduct" := PtaproductMaster.isPhysicalSupplyProduct;
            item."PTA IsAgency" := PtaproductMaster.IsAgency;
            item."PTA IsDeleted" := PtaproductMaster.isDeleted;
            item.Modify();
        end
    end;

    local procedure ProcessResources(PTAProductMaster: Record PTAProductMaster)
    var
        Resource: Record Resource;
        ModifyReource: Record Resource;

    begin
        //PTA MAPPING CODE PTAProductMaster To "Items" 
        Resource.Reset();
        Resource.SetRange("PTA Index Link", PTAProductMaster.Id);
        Resource.SetRange("PTA Resource Type", Resource."PTA Resource Type"::"Additional Service");
        if Resource.FindSet(true) then begin
            ModifyReource := Resource;

            if copystr(Resource."No.", 1, 15) <> Copystr(PTAProductMaster.ProductName, 1, 15) then begin
                ModifyReource."PTA Index Link" := 0;
                ModifyReource."PTA IsDeleted" := true;
                ModifyReource.Modify();

                CreateResourceFromTemplate(ModifyReource, PTAProductMaster);
                ModifyReource.Modify();
            end else begin
                ModifyReource.Name := Copystr(PtaproductMaster.ProductName, 1, MaxStrLen(Resource.Name));
                ModifyReource."PTA IsDeleted" := PtaproductMaster.isDeleted;
                ModifyReource.Modify();
            end;
        end else
            CreateResourceFromTemplate(ModifyReource, PTAProductMaster);
    end;

    local Procedure CreateResourceFromTemplate(var Resource: Record Resource; PtaproductMaster: Record PTAProductMaster)
    var
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateManagement: Codeunit "Config. Template Management";
        ResourceRecRef: RecordRef;
    begin
        ConfigTemplateHeader.GET(PTaSetup."Resource Template Code");

        Resource.INIT;
        Resource."No." := PTAHelperFunctions.GetNewNextCode(Copystr(PtaproductMaster.ProductName, 1, 15), Database::Resource);
        Resource.Name := Copystr(PtaproductMaster.ProductName, 1, MaxStrLen(Resource.name));
        Resource."PTA Index Link" := PtaproductMaster.Id;
        Resource."PTA IsDeleted" := PtaproductMaster.isDeleted;
        Resource."PTA Resource Type" := Resource."PTA Resource Type"::"Additional Service";
        Resource.INSERT(TRUE);
        ResourceRecRef.GETTABLE(Resource);
        ConfigTemplateManagement.UpdateRecord(ConfigTemplateHeader, ResourceRecRef);
        ResourceRecRef.Modify();
    end;

    var
        PTaSetup: Record "PTA Setup";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}
