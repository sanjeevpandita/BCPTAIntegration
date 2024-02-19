codeunit 70057 PTAProcessAddressMaster
{

    TableNo = PTAAddressesMaster;

    trigger OnRun()
    begin
        PTaSetup.get();
        ProcessAddressesMaster(Rec);
    end;

    local procedure ProcessAddressesMaster(PTAAddressesMaster: Record PTAAddressesMaster)
    var
        PTACounterpartiesMaster: Record PTACounterpartiesMaster;
        Contact: Record Contact;
        ModifyContact: Record Contact;

    begin
        //PTA MAPPING CODE PTAAddCostDetailsMaster To "Resources"
        PTACounterpartiesMaster.Reset();
        PTACounterpartiesMaster.SetCurrentKey(AdminAddress);
        PTACounterpartiesMaster.SetRange(AdminAddress, PTAAddressesMaster.Id);
        if PTACounterpartiesMaster.FindLast() then begin
            if ModifyContact.get(Format(PTACounterpartiesMaster.id)) then begin
                ModifyContact.Name := Copystr(PTACounterpartiesMaster.Name, 1, MaxStrLen(ModifyContact.Name));
                ModifyContact.Address := Copystr(PTAAddressesMaster.AddressLine1, 1, MaxStrLen(ModifyContact.Address));
                ModifyContact."Address 2" := Copystr(PTAAddressesMaster.AddressLine2, 1, MaxStrLen(ModifyContact."Address 2"));
                ModifyContact."E-Mail" := Copystr(PTAAddressesMaster.Email, 1, MaxStrLen(ModifyContact."E-Mail"));
                ModifyContact."Fax No." := PTAAddressesMaster.Fax;
                ModifyContact.City := PTABCMappingtoIndexID.GetCityCodeByPTAIndexID(PTAAddressesMaster.City);
                ModifyContact."Post Code" := PTAAddressesMaster.PostalCode;
                ModifyContact."Country/Region Code" := PTABCMappingtoIndexID.GetCountryCodeByPTAIndexID(PTAAddressesMaster.Country);

                if (ModifyContact."Country/Region Code" = '') then
                    if PTASetup."Dummy Country Code" <> '' then
                        ModifyContact."Country/Region Code" := PTASetup."Dummy Country Code";

                ModifyContact."Phone No." := Copystr(PTAAddressesMaster.Phone1, 1, 30);
                ModifyContact."Mobile Phone No." := Copystr(PTACounterpartiesMaster.Phone2, 31, 60);
                ModifyContact."PTA IsDeleted" := PTACounterpartiesMaster.IsDeleted;
                ModifyContact.Modify(true);
            end else begin

                ModifyContact.init();
                ModifyContact."No." := Format(PTACounterpartiesMaster.Id);
                ModifyContact.Name := Copystr(PTACounterpartiesMaster.Name, 1, MaxStrLen(ModifyContact.Name));
                ModifyContact.Address := Copystr(PTAAddressesMaster.AddressLine1, 1, MaxStrLen(ModifyContact.Address));
                ModifyContact."Address 2" := Copystr(PTAAddressesMaster.AddressLine2, 1, MaxStrLen(ModifyContact."Address 2"));
                ModifyContact."E-Mail" := Copystr(PTAAddressesMaster.Email, 1, MaxStrLen(ModifyContact."E-Mail"));
                ModifyContact."Fax No." := PTAAddressesMaster.Fax;
                ModifyContact.City := PTABCMappingtoIndexID.GetCityCodeByPTAIndexID(PTAAddressesMaster.City);
                ModifyContact."Post Code" := PTAAddressesMaster.PostalCode;
                ModifyContact."Country/Region Code" := PTABCMappingtoIndexID.GetCountryCodeByPTAIndexID(PTAAddressesMaster.Country);

                if (ModifyContact."Country/Region Code" = '') then
                    if PTASetup."Dummy Country Code" <> '' then
                        ModifyContact."Country/Region Code" := PTASetup."Dummy Country Code";

                ModifyContact."Phone No." := Copystr(PTAAddressesMaster.Phone1, 1, 30);
                ModifyContact."Mobile Phone No." := Copystr(PTACounterpartiesMaster.Phone2, 31, 60);
                ModifyContact."PTA IsDeleted" := PTACounterpartiesMaster.IsDeleted;
                ModifyContact."PTA Index Link" := PTACounterpartiesMaster.Id;
                ModifyContact.Insert(true);

                if PTACounterpartiesMaster.isCustomer then
                    ConvertContactToCustomer(ModifyContact);
                if PTACounterpartiesMaster.isVendor then
                    ConvertContactToVendor(ModifyContact);
            end;
        end;
    end;

    procedure ConvertContactToCustomer(Var ModifyContact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        if Not PTASetupFound then begin
            PTASetup.get();
            MktgSetup.get();
            PTASetupFound := true;
        end;

        IF NOT ContactBusinessRelation.GET(ModifyContact."No.", MktgSetup."Bus. Rel. Code for Customers") THEN begin
            ModifyContact.SetRecFilter();
            ModifyContact.SetHideValidationDialog(true);
            ModifyContact.CreateCustomerFromTemplate(PTASetup."Customer Template Code")
        end;
    end;

    procedure ConvertContactToVendor(Var ModifyContact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        if Not PTASetupFound then begin
            PTASetup.get();
            MktgSetup.get();
            PTASetupFound := true;
        end;

        IF NOT ContactBusinessRelation.GET(ModifyContact."No.", MktgSetup."Bus. Rel. Code for Vendors") THEN begin
            ModifyContact.SetRecFilter();
            ModifyContact.SetHideValidationDialog(true);
            ModifyContact.CreateVendorFromTemplate(PTASetup."Vendor Template Code")
        end;
    end;

    var
        PTAHelperFunctions: Codeunit "PTA Helper Functions";
        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        MktgSetup: Record "Marketing Setup";
        PTASetup: Record "PTA Setup";
        PTASetupFound: Boolean;
}