codeunit 70006 PTAProcessDeliveryTypes
{

    TableNo = PTADeliveryTypeMaster;
    trigger OnRun()
    begin
        ProcessDeliveryTypes(Rec);
    end;

    local procedure ProcessDeliveryTypes(PTADeliveryTypeMaster: Record PTADeliveryTypeMaster)
    var
        ModifyPTADeliveryTypeMaster: Record PTADeliveryTypeMaster;
        ShipmentMethod: Record "Shipment Method";
        ModifyShipmentMethod: Record "Shipment Method";
        ModifyRecord: Boolean;
    begin
        //PTA MAPPING CODE PTADeliveryTypeMaster to Shipment Method 

        if PTADeliveryTypeMaster.Abbreviation = '' then
            error('Abbreviation is Mandatory', PTADeliveryTypeMaster.Name);

        ModifyRecord := false;
        ShipmentMethod.Reset();
        ShipmentMethod.SetRange("PTA Index Link", PTADeliveryTypeMaster.Id);
        if ShipmentMethod.FindSet(true) then begin
            ModifyShipmentMethod := ShipmentMethod;

            if PTAHelperFunctions.Return15CharactersOfPK(ShipmentMethod.Code) <> Copystr(PTADeliveryTypeMaster.Abbreviation, 1, 15).ToUpper() then begin
                ModifyShipmentMethod."PTA Index Link" := 0;
                ModifyShipmentMethod."PTA Abbreviation" := '';
                ModifyShipmentMethod."PTA IsDeleted" := true;
                ModifyShipmentMethod.Modify();

                ModifyShipmentMethod.Init();
                //ModifyShipmentMethod.Code := Copystr(PTADeliveryTypeMaster.Abbreviation, 1, MaxStrLen(ModifyShipmentMethod.Code));
                ModifyShipmentMethod.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTADeliveryTypeMaster.Abbreviation, 1, 15), Database::"Shipment Method");
                ModifyShipmentMethod.Description := Copystr(PTADeliveryTypeMaster.Name, 1, MaxStrLen(ModifyShipmentMethod.Description));
                ModifyShipmentMethod."PTA Abbreviation" := Copystr(PTADeliveryTypeMaster.Abbreviation, 1, MaxStrLen(ModifyShipmentMethod."PTA Abbreviation"));
                ModifyShipmentMethod."PTA Index Link" := PTADeliveryTypeMaster.Id;
                ModifyShipmentMethod."PTA IsDeleted" := PTADeliveryTypeMaster.isDeleted;
                ModifyShipmentMethod.Insert(true);
            end else begin
                if ShipmentMethod.Description <> Copystr(PTADeliveryTypeMaster.Name, 1, MaxStrLen(ShipmentMethod.Description)) then begin
                    ModifyShipmentMethod.Description := Copystr(PTADeliveryTypeMaster.Name, 1, MaxStrLen(ShipmentMethod.Description));
                    ModifyRecord := true;
                end;
                if ShipmentMethod."PTA Abbreviation" <> Copystr(ShipmentMethod."PTA Abbreviation", 1, MaxStrLen(ShipmentMethod."PTA Abbreviation")) then begin
                    ModifyShipmentMethod."PTA Abbreviation" := Copystr(PTADeliveryTypeMaster.Abbreviation, 1, MaxStrLen(ShipmentMethod."PTA Abbreviation"));
                    ModifyRecord := true;
                end;
                if ShipmentMethod."PTA IsDeleted" <> PTADeliveryTypeMaster.isDeleted then begin
                    ModifyShipmentMethod."PTA IsDeleted" := PTADeliveryTypeMaster.isDeleted;
                    ModifyRecord := true;
                end;
                if ModifyRecord then
                    ModifyShipmentMethod.Modify();
            end;
        end else begin
            ModifyShipmentMethod.Init();
            ModifyShipmentMethod.Code := PTAHelperFunctions.GetNewNextCode(Copystr(PTADeliveryTypeMaster.Abbreviation, 1, 15), Database::"Shipment Method"); //Copystr(PTADeliveryTypeMaster.Abbreviation, 1, MaxStrLen(ModifyShipmentMethod.Code));
            ModifyShipmentMethod.Description := Copystr(PTADeliveryTypeMaster.Name, 1, MaxStrLen(ModifyShipmentMethod.Description));
            ModifyShipmentMethod."PTA Abbreviation" := Copystr(PTADeliveryTypeMaster.Abbreviation, 1, MaxStrLen(ModifyShipmentMethod."PTA Abbreviation"));
            ModifyShipmentMethod."PTA Index Link" := PTADeliveryTypeMaster.Id;
            ModifyShipmentMethod."PTA IsDeleted" := PTADeliveryTypeMaster.isDeleted;
            ModifyShipmentMethod.Insert(true);
        end;
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
}