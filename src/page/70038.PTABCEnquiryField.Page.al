page 70038 "PTA BC Enquiry Field"
{
    ApplicationArea = All;
    Caption = 'BC Enquiry Field';
    PageType = List;
    SourceTable = "PTA BC Enquiry Field";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(TableID; Rec.TableID)
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        "Field": Record Field;
                        AllObj: Record AllObjWithCaption;
                        Objects: Page "All Objects with Caption";
                    begin
                        AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
                        AllObj.SetRange("Object ID", 70011, 70023);
                        Objects.SetTableView(AllObj);
                        Objects.LookupMode(true);
                        if not AllObj.IsEmpty() then
                            Objects.SetRecord(AllObj);
                        if Objects.RunModal() = Action::LookupOK then begin
                            Objects.GetRecord(AllObj);
                            Rec.Validate(TableID, AllObj."Object ID");
                            Rec.Validate("Table Name", AllObj."Object Name");
                        end;
                    end;
                }
                field("Table Name"; Rec."Table Name")
                {
                    Editable = false;
                }
                field(FieldID; Rec.FieldID)
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        FieldTable: Record Field;
                    begin
                        FieldTable.SetRange(TableNo, Rec.TableID);
                        if Page.RunModal(Page::"Fields Lookup", FieldTable) = Action::LookupOK then begin
                            Rec.Validate(FieldID, FieldTable."No.");
                            Rec.Validate("Field Name", FieldTable."Field Caption");
                        end;
                    end;
                }
                field("Field Name"; Rec."Field Name")
                {
                    Editable = false;
                }
            }
        }
    }
}
