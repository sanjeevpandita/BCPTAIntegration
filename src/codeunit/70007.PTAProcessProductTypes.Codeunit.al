codeunit 70007 PTAProcessProductTypes
{
    TableNo = PTAProductTypeMaster;

    trigger OnRun()
    begin
        ProcessProductTypes(Rec);
    end;


    local procedure ProcessProductTypes(PTAProductTypeMaster: Record PTAProductTypeMaster)
    var
        ModifyPTAProductTypeMaster: Record PTAProductTypeMaster;
        ItemCategory: Record "Item Category";
        ModifyItemCategory: Record "Item category";

        ModifyRecord: Boolean;
    begin
        //PTA MAPPING CODE PTAProductTypeMaster to "Item Category"
        if PTAProductTypeMaster.ProductType = '' then
            error('Product Type is Mandatory');

        ModifyRecord := false;
        ItemCategory.Reset();
        ItemCategory.SetRange("PTA Index Link", PTAProductTypeMaster.Id);
        if ItemCategory.FindSet(true) then begin
            ModifyItemCategory := ItemCategory;

            if PTAHelperFunctions.Return15CharactersOfPK(ItemCategory.Code) <> Copystr(PTAProductTypeMaster.ProductType, 1, 15).ToUpper() then begin
                ModifyItemCategory."PTA Index Link" := 0;
                ModifyItemCategory."PTA IsDeleted" := true;
                ModifyItemCategory.Modify();

                ModifyItemCategory.Init();
                ModifyItemCategory.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAProductTypeMaster.ProductType, 1, 15), Database::"Item Category");//Copystr(PTAProductTypeMaster.ProductType, 1, MaxStrLen(ModifyItemCategory.Code));
                ModifyItemCategory.Description := Copystr(PTAProductTypeMaster.ProductType, 1, MaxStrLen(ModifyItemCategory.Description));
                ModifyItemCategory."PTA Index Link" := PTAProductTypeMaster.Id;
                ModifyItemCategory."PTA IsDeleted" := PTAProductTypeMaster.isDeleted;
                ModifyItemCategory.Insert(true);
            end else begin
                if ItemCategory.Description <> Copystr(PTAProductTypeMaster.ProductType, 1, MaxStrLen(ItemCategory.Description)) then begin
                    ModifyItemCategory.Description := Copystr(PTAProductTypeMaster.ProductType, 1, MaxStrLen(ItemCategory.Description));
                    ModifyRecord := true;
                end;
                if ItemCategory."PTA IsDeleted" <> PTAProductTypeMaster.isDeleted then begin
                    ModifyItemCategory."PTA IsDeleted" := PTAProductTypeMaster.isDeleted;
                    ModifyRecord := true;
                end;
                if ModifyRecord then
                    ModifyItemCategory.Modify();
            end;
        end else begin
            ModifyItemCategory.Init();
            ModifyItemCategory.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTAProductTypeMaster.ProductType, 1, 15), Database::"Item Category"); //Copystr(PTAProductTypeMaster.ProductType, 1, MaxStrLen(ModifyItemCategory.Code));
            ModifyItemCategory.Description := Copystr(PTAProductTypeMaster.ProductType, 1, MaxStrLen(ModifyItemCategory.Description));
            ModifyItemCategory."PTA Index Link" := PTAProductTypeMaster.Id;
            ModifyItemCategory."PTA IsDeleted" := PTAProductTypeMaster.isDeleted;
            ModifyItemCategory.Insert(true);
        end;
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}