table 70044 "PTA Cue"
{
    Caption = 'Team Member Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        Field(2; "Currencies"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACurrenciesMaster);
            Caption = 'Currencies';
        }
        Field(3; "Currencies in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACurrenciesMaster where(Processed = filter(2)));
            Caption = 'Currencies in Error';
        }
        Field(4; "Units"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAUnitMaster);
            Caption = 'Units';
        }
        Field(5; "Units in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAUnitMaster where(Processed = filter(2)));
            Caption = 'Units in Error';
        }
        Field(6; "Delivery Types"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTADeliveryTypeMaster);
            Caption = 'Delivery Types';
        }
        Field(7; "Delivery Types in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTADeliveryTypeMaster where(Processed = filter(2)));
            Caption = 'Delivery Types in Error';
        }
        Field(8; "Business Areas"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTABusinessAreasMaster);
            Caption = 'Business Areas';
        }
        Field(9; "Business Areas in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTABusinessAreasMaster where(Processed = filter(2)));
            Caption = 'Business Areas in Error';
        }

        Field(10; "Countries"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACountryMaster);
            Caption = 'Countries';
        }
        Field(11; "Countries in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACountryMaster where(Processed = filter(2)));
            Caption = 'Countries in Error';
        }
        Field(12; "Cities"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACityMaster);
            Caption = 'Cities';
        }
        Field(13; "City in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACityMaster where(Processed = filter(2)));
            Caption = 'City in Error';
        }
        Field(14; "Product Types"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAProductTypeMaster);
            Caption = 'Product Types';
        }
        Field(15; "Product Types in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAProductTypeMaster where(Processed = filter(2)));
            Caption = 'Product Types in Error';
        }
        Field(16; "Ports"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAPortMaster);
            Caption = 'Ports';
        }
        Field(17; "Ports in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAPortMaster where(Processed = filter(2)));
            Caption = 'Ports in Error';
        }
        Field(18; "Users"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAPortMaster);
            Caption = 'Users';
        }
        Field(20; "Company Offices"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACompanyOfficesMaster);
            Caption = 'Company Offices';
        }
        Field(21; "Company Offices in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACompanyOfficesMaster where(Processed = filter(2)));
            Caption = 'Company Offices in Error';
        }
        Field(22; "Products"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAProductMaster);
            Caption = 'Products';
        }
        Field(23; "Products in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAProductMaster where(Processed = filter(2)));
            Caption = 'Products in Error';
        }
        Field(24; "Currency Exchange"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACurrencyExchRate);
            Caption = 'Currency Exchange';
        }
        Field(25; "Currency Exch. in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACurrencyExchRate where(Processed = filter(2)));
            Caption = 'Currency Exch. in Error';
        }
        Field(26; "Enquiries"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAEnquiry);
            Caption = 'Enquiries';
        }
        Field(27; "Enquiries in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAEnquiry where(Processed = filter(2)));
            Caption = 'Enquiries in Error';
        }
        Field(28; "Customer Invoices"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACustomerInvoices);
            Caption = 'Customer Invoices';
        }
        Field(29; "Customer Invoices in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACustomerInvoices where(Processed = filter(2)));
            Caption = 'Customer Invoices in Error';
        }
        Field(30; "Vouchers"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAVouchers);
            Caption = 'Vouchers';
        }
        Field(31; "Vouchers in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAVouchers where(Processed = filter(2)));
            Caption = 'Vouchers in Error';
        }
        Field(32; "Counterparites in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACounterpartiesMaster where(Processed = filter(2)));
            Caption = 'Counterparites in Error';
        }
        Field(33; "Users in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAUnitMaster where(Processed = filter(2)));
            Caption = 'Users in Error';
        }
        Field(50; "Currencies Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACurrenciesMaster where(Processed = filter(99)));
            Caption = 'Currencies Skipped';
        }

        Field(51; "Units Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAUnitMaster where(Processed = filter(99)));
            Caption = 'Units Skipped';
        }
        Field(52; "Delivery Types Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTADeliveryTypeMaster where(Processed = filter(99)));
            Caption = 'Delivery Types Skipped';
        }
        Field(53; "Business Areas Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTABusinessAreasMaster where(Processed = filter(99)));
            Caption = 'Business Areas Skipped';
        }
        Field(54; "Countries Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACountryMaster where(Processed = filter(99)));
            Caption = 'Countries Skipped';
        }
        Field(55; "City Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACityMaster where(Processed = filter(99)));
            Caption = 'City Skipped';
        }
        Field(56; "Product Types Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAProductTypeMaster where(Processed = filter(99)));
            Caption = 'Product Types Skipped';
        }
        Field(57; "Ports Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAPortMaster where(Processed = filter(99)));
            Caption = 'Ports Skipped';
        }
        Field(58; "Company Offices Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACompanyOfficesMaster where(Processed = filter(99)));
            Caption = 'Company Offices Skipped';
        }
        Field(59; "Products Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAProductMaster where(Processed = filter(99)));
            Caption = 'Products Skipped';
        }
        Field(60; "Currency Exch. Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACurrencyExchRate where(Processed = filter(99)));
            Caption = 'Currency Exch. Skipped';
        }
        Field(61; "Enquiries Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAEnquiry where(Processed = filter(99)));
            Caption = 'Enquiries Skipped';
        }
        Field(62; "Customer Invoices Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACustomerInvoices where(Processed = filter(99)));
            Caption = 'Customer Invoices Skipped';
        }
        Field(63; "Vouchers Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAVouchers where(Processed = filter(99)));
            Caption = 'Vouchers Skipped';
        }
        Field(64; "Counterparites Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTACounterpartiesMaster where(Processed = filter(99)));
            Caption = 'Counterparites Skipped';
        }
        Field(65; "Users Skipped"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAUsersMaster where(Processed = filter(99)));
            Caption = 'Users Skipped';
        }
        Field(66; "Supply Regions in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTASupplyRegions where(Processed = filter(2)));
            Caption = 'Supply Regions in Error';
        }
        Field(67; "Inbound Payments in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAInboundPaymentsReceived where(Processed = filter(2)));
            Caption = 'Inbound Payments in Error';
        }
        Field(68; "Outbound Payments in Error"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(PTAOutgoingPayments where(Processed = filter(2)));
            Caption = 'Outbound Payments in Error';
        }
        Field(100; "Parked Invoices"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Sales header" where("Document Type" = filter(Order), "PTA Parked" = filter(true), "Posting No." = filter(<> '')));
            Caption = 'Parked Invoices';
        }
    }
}
