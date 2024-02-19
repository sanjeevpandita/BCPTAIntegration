page 70015 "PTA Companies"
{
    ApplicationArea = All;
    Caption = 'PTA Companies';
    PageType = List;
    SourceTable = PTACompaniesMaster;
    UsageCategory = Lists;
    //Editable = false;

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
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(CompanyId; Rec.CompanyId)
                {
                    ToolTip = 'Specifies the value of the CompanyId field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(BCCompanyName; Rec.BCCompanyName)
                {
                    ToolTip = 'Specifies the value of the BCCompanyName field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }
                field(isDeleted; Rec.isDeleted)
                {

                }
            }
            part("PTA Company Office"; "PTA Company Office")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = CompanyID = FIELD(Id);
                UpdatePropagation = Both;
            }
        }
    }
}
