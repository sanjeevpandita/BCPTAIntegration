page 70032 PTACounterpartyRoleMapping
{
    ApplicationArea = All;
    Caption = 'PTACounterparty Role Mapping';
    PageType = List;
    SourceTable = PTACounterpartyRoleMapping;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(CounterpartyId; Rec.CounterpartyId)
                {
                }
                field(CounterpartyRoleId; Rec.CounterpartyRoleId)
                {
                }
                field(SystemId; Rec.SystemId)
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                }
            }
        }
    }
}
