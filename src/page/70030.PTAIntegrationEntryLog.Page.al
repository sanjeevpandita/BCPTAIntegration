page 70030 "PTA Integration Entry Log"
{
    ApplicationArea = All;
    Caption = 'PTA Integration Entry Log';
    PageType = ListPart;
    Editable = false;
    SourceTable = "PTA Integration Entry Log";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowAsTree = true;
                TreeInitialState = CollapseAll;
                IndentationColumn = Rec."Indendation Level";
                IndentationControls = Description;

                field("Entity Name"; Rec."Entity Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Integration Status"; Rec."Integration Status")
                {
                    StyleExpr = StyleText;
                }
                field(ErrorMessage; Rec.ErrorMessage)
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {

            action(ShowRecord)
            {
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Show Record';

                trigger OnAction()
                var
                begin
                    Rec.showRecord();
                end;
            }
            action(ShowBCRecord)
            {
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Show BC Record';

                trigger OnAction()
                var
                begin
                    Rec.ShowBCRecord();
                end;
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
