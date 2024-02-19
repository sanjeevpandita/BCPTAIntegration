page 70017 "PTA Addresses"
{
    ApplicationArea = All;
    Caption = 'PTA Addresses';
    PageType = List;
    SourceTable = PTAAddressesMaster;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                    Visible = false;
                }
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                }
                field(AddressLine1; Rec.AddressLine1)
                {
                    ToolTip = 'Specifies the value of the AddressLine1 field.';
                }
                field(AddressLine2; Rec.AddressLine2)
                {
                    ToolTip = 'Specifies the value of the AddressLine2 field.';
                }
                field(AddressLine3; Rec.AddressLine3)
                {
                    ToolTip = 'Specifies the value of the AddressLine3 field.';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Country; Rec.Country)
                {
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(Phone1; Rec.Phone1)
                {
                    ToolTip = 'Specifies the value of the Phone1 field.';
                }
                field(Fax; Rec.Fax)
                {
                    ToolTip = 'Specifies the value of the Fax field.';
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                }

                field(PostalCode; Rec.PostalCode)
                {
                    ToolTip = 'Specifies the value of the PostalCode field.';
                }
                field(isDeleted; Rec.isDeleted)
                {
                    ToolTip = 'Specifies the value of the isDeleted field.';
                    Editable = false;
                }
            }
        }
    }
}
