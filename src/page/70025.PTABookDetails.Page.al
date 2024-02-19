page 70025 "PTA Book Details"
{
    ApplicationArea = All;
    Caption = 'PTA Book Details';
    PageType = List;
    SourceTable = PTABookDetails;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.';
                }
                field(Id; Rec.Id)
                {
                    ToolTip = 'Specifies the value of the Id field.';
                    StyleExpr = StyleText;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    StyleExpr = StyleText;
                }
                field(ManagerId; Rec.ManagerId)
                {
                    ToolTip = 'Specifies the value of the ManagerId field.';
                }
                field(BookType; Rec.BookType)
                {
                    ToolTip = 'Specifies the value of the BookType field.';
                }
                field(isDeleted; Rec.isDeleted)
                {
                    ToolTip = 'Specifies the value of the isDeleted field.';
                }
                field(GroupName; Rec.GroupName)
                {
                    ToolTip = 'Specifies the value of the GroupName field.';
                }
                field(BookParentGroupId; Rec.BookParentGroupId)
                {
                    ToolTip = 'Specifies the value of the GroupName field.';
                }
                field(Processed; Rec.Processed)
                {
                    ToolTip = 'Specifies the value of the Processed field.';
                }
                field(ProcessedDateTime; Rec.ProcessedDateTime)
                {
                    ToolTip = 'Specifies the value of the ProcessedDateTime field.';
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                    ToolTip = 'Specifies the value of the ErrorMessage field.';
                }
                field(ErrorDateTime; Rec.ErrorDateTime)
                {
                    ToolTip = 'Specifies the value of the ErrorDateTime field.';
                }
                field(ExternalId; Rec.ExternalId)
                {
                    ToolTip = 'Specifies the value of the ExternalId field.';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleText := Rec.SetStyle();
    end;

    var
        StyleText: Text[30];
}
