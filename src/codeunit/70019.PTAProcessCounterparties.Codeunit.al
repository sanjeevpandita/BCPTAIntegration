codeunit 70019 PTAProcessCounterparties
{
    TableNo = PTACounterpartiesMaster;

    trigger OnRun()
    begin
        MktgSetup.get();
        MktgSetup.TestField("Bus. Rel. Code for Customers");
        MktgSetup.TestField("Bus. Rel. Code for vendors");

        if Not PTASetupFound then begin
            PTASetup.get();
            PTASetupFound := true;
        end;

        PTASetup.testfield("Customer Template Code");
        PTASetup.testfield("Vendor Template Code");

        ProcessCounterpartyRecords(rec);
    end;

    local procedure ProcessCounterpartyRecords(PTACounterpartiesMaster: Record PTACounterpartiesMaster)
    var
        ModifyPTACounterpartiesMaster: Record PTACounterpartiesMaster;
        Contact: Record Contact;
        ModifyContact: Record Contact;

        PTABCMappingtoIndexID: Codeunit "PTA BC Mapping to IndexID";
        PTAAddressesMaster: Record PTAAddressesMaster;
    begin
        //PTA MAPPING CODE PTACurrenciesMaster to Currency 
        if PTACounterpartiesMaster.Name = '' then Error('Name is Mandatory');

        //if PTACounterpartiesMaster.AdminAddress = 0 then Error('AdminAddress is Mandatory');

        PTABCMappingtoIndexID.GetPTAAddressbyID(PTACounterpartiesMaster.AdminAddress, PTAAddressesMaster);

        //if (PTAAddressesMaster.Id = 0) then
        //    Error('Admin Address not found in Address Master');

        If Contact.get(Format(PTACounterpartiesMaster.Id)) then begin
            ModifyContact := Contact;

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
        end;


        if PTACounterpartiesMaster.isCustomer then
            ConvertContactToCustomer(ModifyContact)
        else
            if PTACounterpartiesMaster.isDeleted then
                IfCUstomerExiststhenBlock(ModifyContact);

        if PTACounterpartiesMaster.isVendor then
            ConvertContactToVendor(ModifyContact)
        else
            if PTACounterpartiesMaster.isDeleted then
                IfVendorExiststhenBlock(ModifyContact);

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

    local procedure IfCUstomerExiststhenBlock(ModifyContact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
    begin
        IF ContactBusinessRelation.GET(ModifyContact."No.", MktgSetup."Bus. Rel. Code for Customers") THEN
            if ContactBusinessRelation."Link to Table" = ContactBusinessRelation."Link to Table"::Customer then begin
                if Customer.get(ContactBusinessRelation."No.") then begin
                    Customer.Blocked := Customer.Blocked::All;
                    Customer."PTA IsDeleted" := true;
                    Customer.Modify(true)
                end;
            end;
    end;

    local procedure IfVendorExiststhenBlock(ModifyContact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        Vendor: Record Vendor;
    begin
        IF ContactBusinessRelation.GET(ModifyContact."No.", MktgSetup."Bus. Rel. Code for Vendors") THEN
            if ContactBusinessRelation."Link to Table" = ContactBusinessRelation."Link to Table"::Vendor then begin
                if Vendor.get(ContactBusinessRelation."No.") then begin
                    Vendor.Blocked := Vendor.Blocked::All;
                    Vendor."PTA IsDeleted" := true;
                    Vendor.Modify(true)
                end;
            end;
    end;

    var
        MktgSetup: Record "Marketing Setup";
        PTASetup: Record "PTA Setup";
        PTASetupFound: Boolean;
}