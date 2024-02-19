page 70029 "PTA Integration Log"
{
    ApplicationArea = All;
    Caption = 'PTA Integration Log';
    PageType = ListPart;
    SourceTable = "PTA Integration Log";
    SourceTableView = SORTING("Entry No.") ORDER(Descending);
    UsageCategory = None;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Visible = false;
                }
                field("Integration Date/Time"; Rec."Integration Date/Time")
                {
                    ToolTip = 'Specifies the value of the Integration Date/Time field.';
                }
                field("Process Type"; Rec."Process Type")
                {
                    ToolTip = 'Specifies the value of the Process Type field.';
                    StyleExpr = StyleText;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    StyleExpr = StyleText;
                }
                field("Has Error"; Rec."Has Error")
                {
                    StyleExpr = StyleText;
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