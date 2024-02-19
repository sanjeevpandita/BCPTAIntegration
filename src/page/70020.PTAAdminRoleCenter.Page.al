page 70020 "PTA Admin Role Center"
{
    Caption = 'PTA Administrator';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control11; "Headline PTA Admin")
            {
                ApplicationArea = Suite;
            }
            part(Control4; "PTA Admin Trans. Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control3; "PTA Admin Master Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(EmbedPTASetup)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'PTA Setup';
                Image = Setup;
                RunObject = Page "PTA Setup";
            }
            action(PTALogEntry)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'PTA Integration Log';
                Image = Setup;
                RunObject = Page "PTA Integration";
            }
            action(EmbedPTACurrency)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Currency';
                Image = Currencies;
                RunObject = Page "PTA Currency Master";
            }
            action(EmbedPTAUnits)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Units';
                Image = UnitOfMeasure;
                RunObject = Page "PTA Units";
            }
            action(EmbedExpenseClaimStatus)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Expense Claim Status';
                Image = ExpandDepositLine;
                RunObject = Page "PTA Expense Claim Status";
            }
            action(EmbedPTADeliveryTypes)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delivery Types';
                Image = DepositLines;
                RunObject = Page "PTA Delivery Types";
            }
            action(EmbedPTABusinessArea)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Business Area';
                Image = BusinessRelation;
                RunObject = Page "PTA Business Areas";
            }
            action(EmbedPTASupplyRegions)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Supply Regions';
                Image = Addresses;
                RunObject = Page "PTA Supply Regions";
            }
            action(EmbedPTACostTypes)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cost Types';
                Image = Cost;
                RunObject = Page "PTA Cost Types";
            }
        }
        area(sections)
        {
            group(PTAMaster)
            {
                Caption = 'PTA Staging Master';
                Image = Statistics;
                action(PTABusinessArea)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Area';
                    Image = BusinessRelation;
                    RunObject = Page "PTA Business Areas";
                }
                action(PTADeliveryTypes)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Delivery Types';
                    Image = DepositLines;
                    RunObject = Page "PTA Delivery Types";
                }
                action(PTAAddCostDet)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Additional Cost Details';
                    Image = AddAction;
                    RunObject = Page "PTA Additional Cost Details";
                }
                action(PTAAddCosts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Additional Costs';
                    Image = CostAccounting;
                    RunObject = Page "PTA Additional Costs";
                }
                action(PTACostTypes)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cost Types';
                    Image = Cost;
                    RunObject = Page "PTA Cost Types";
                }
                action(PTACurrency)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Currency';
                    Image = Currencies;
                    RunObject = Page "PTA Currency Master";
                }
                action(PTACurrencyExchangeRate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Currency Exchange Rate';
                    Image = Currencies;
                    RunObject = Page "PTA Currency Master";
                }
                action(PTACountries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Countries';
                    Image = CountryRegion;
                    RunObject = Page "PTA Countries";
                }
                action(PTACities)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cities';
                    Image = CountryRegion;
                    RunObject = Page "PTA Cities";
                }
                action(PTAPortMaster)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ports';
                    Image = ProductDesign;
                    RunObject = Page "PTA Ports";
                }
                action(PTAProductTypes)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Product Types';
                    Image = ProductDesign;
                    RunObject = Page "PTA Product Types";
                }
                action(PTAUnits)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Units';
                    Image = UnitOfMeasure;
                    RunObject = Page "PTA Units";
                }
                action(PTAProducts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Products';
                    Image = Item;
                    RunObject = Page "PTA Products";
                }
                action(PTACOunterparties)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Counterparties';
                    Image = ContactPerson;
                    RunObject = Page "PTA CounterpartiesMaster";
                }
                action(ExpenseClaimStatus)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expense Claim Status';
                    Image = ExpandDepositLine;
                    RunObject = Page "PTA Expense Claim Status";
                }
                action(PTAExpenseClaimCategory)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expense Category';
                    Image = ProjectExpense;
                    RunObject = Page "PTA Expense Category";
                }
                action(PTAUsers)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Users';
                    Image = User;
                    RunObject = Page "PTA Users";
                }
                action(PTACompanies)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Companies';
                    Image = Company;
                    RunObject = Page "PTA Companies";
                }
                action(PTACompanyOffice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Company Offices';
                    Image = CompanyInformation;
                    RunObject = Page "PTA Company Office";
                }
                action(PTAAddress)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Addresses';
                    Image = Addresses;
                    RunObject = Page "PTA Addresses";
                }
                action(PTASupplyRegions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Supply Regions';
                    Image = Addresses;
                    RunObject = Page "PTA Supply Regions";
                }
                action(PTABooks)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Book Details';
                    Image = Addresses;
                    RunObject = Page "PTA Book Details";
                }
                action(AspectBookMapper)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Aspect Book Mapper';
                    Image = Addresses;
                    RunObject = Page "PTA Aspect Book Mapper";
                }
            }
            group(PTATransactions)
            {
                Caption = 'PTA Transactions';
                Image = Sales;
                action(Enquiries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Enquiries';
                    RunObject = Page PTAEnquiryList;
                }
                action(Expenses)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Expenses';
                    RunObject = Page PTAExpenseList;
                }
                action(CustomerInvoices)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Invoices';
                    RunObject = page "PTACustomerInvoicesList";
                }
                action(InboundPayments)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer/Inbound Payments';
                    RunObject = page "PTA Inbound Payments Received";
                }
                action(Vouchers)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vouchers';
                    RunObject = page "PTAVoucherList";
                }
                action(VoucherPayments)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Supplier/Voucher Payments';
                    RunObject = page "PTAOutgoingPayments";
                }
            }
            group(StandardBC)
            {
                Caption = 'Standard Business Central';
                Image = Statistics;
                action(Dimensions)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Business Area / Office';
                    Image = Dimensions;
                    RunObject = Page "Dimensions";
                }
                action(ShipmentMethod)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Shipment Method / Del. Type';
                    Image = DepositLines;
                    RunObject = Page "Shipment Methods";
                }
                action(Currencies)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Currency / Exchange Rates';
                    Image = Currencies;
                    RunObject = Page "Currencies";
                }
                action(Countries)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Countries';
                    Image = CountryRegion;
                    RunObject = Page "Countries/Regions";
                }
                action(PostCodes)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Code / Cities';
                    Image = CountryRegion;
                    RunObject = Page "PTA Cities";
                }
                action(Locations)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Location / Ports';
                    Image = ProductDesign;
                    RunObject = Page "Location List";
                }
                action(ItemCategories)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Category / Product Types';
                    Image = ProductDesign;
                    RunObject = Page "Item Categories";
                }
                action(Units)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Units';
                    Image = UnitOfMeasure;
                    RunObject = Page "Units of Measure";
                }
                action(Products)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Products';
                    Image = Item;
                    RunObject = Page "Item List";
                    RunPageView = Where("PTA Index Link" = Filter(<> 0));
                }

                action(Resources)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Resources';
                    Image = ExpandDepositLine;
                    RunObject = Page "Resource List";
                    RunPageView = Where("PTA Index Link" = Filter(<> 0));

                }

                action(Salespersons)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Users / Salespersons';
                    Image = User;
                    RunObject = Page "Salespersons/Purchasers";
                    RunPageView = Where("PTA Index Link" = Filter(<> 0));
                }
                action(Contacts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Counterparty / Contacts';
                    Image = User;
                    RunObject = Page "Contact List";
                    RunPageView = Where("PTA Index Link" = Filter(<> 0));
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                ToolTip = 'Make quotes, orders, and credit memos. See customers and transaction history.';
                action(Sales_CustomerList)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                    RunPageView = where("PTA Index Link" = filter(<> 0));
                    ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
                }

                action("Sales Orders")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Orders';

                    RunObject = Page "Sales Order List";
                    ToolTip = 'Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.';
                }

                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Customer Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Ledger Entries';
                    RunObject = Page "Customer Ledger Entries";
                }
            }
            group(Purchasing)
            {
                Caption = 'Purchasing';
                Image = AdministrationSalesPurchases;
                ToolTip = 'Manage purchase invoices and credit memos. Maintain vendors and their history.';
                action(Purchase_VendorList)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                    RunPageView = where("PTA Index Link" = filter(<> 0));

                    ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                }
                action("<Page Purchase Orders>")
                {
                    ApplicationArea = Suite;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
                }
                action("<Page Posted Purchase Receipts>")
                {
                    ApplicationArea = Suite;
                    Caption = 'Posted Purchase Receipts';
                    RunObject = Page "Posted Purchase Receipts";
                    ToolTip = 'Open the list of posted purchase receipts.';
                }
                action("<Page Posted Purchase Invoices>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.';
                }
                action("<Page Posted Purchase Credit Memos>")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                }
                action("Vendor Ledger Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor Ledger Entries';
                    RunObject = Page "Vendor Ledger Entries";
                }

                action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Ctrl+Alt+Q';
                    ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                }
            }
        }
    }
}

