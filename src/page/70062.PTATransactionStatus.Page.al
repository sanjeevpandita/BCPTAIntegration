page 70062 "PTA Transaction Status"
{
    ApplicationArea = All;
    Caption = 'PTA Transaction Status';
    PageType = List;
    SourceTable = "PTA Transaction Status";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    StyleExpr = StyleText;

                }
                field("Transaction Document No."; Rec."Transaction Document No.")
                {
                    StyleExpr = StyleText;
                }
                field("Company Name"; Rec."Company Name")
                {
                    StyleExpr = StyleText;
                }
                field("Last Status"; Rec."Last Status")
                {
                }
                field("Manuall Processed"; Rec."Manually Processed")
                {
                    ToolTip = 'Specifies the value of the Manually Processed field.';
                }
                field("Last Update Date/Time"; Rec."Last Update Date/Time")
                {
                    ToolTip = 'Specifies the value of the Last Update Date/Time field.';
                }
                field("Error Message"; Rec."Error Message")
                {
                }
                field(Comments; Rec.Comments)
                {
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field("Comment Details"; Rec."Comment Details")
                {
                    ToolTip = 'Specifies the value of the Comment Details field.';
                }
            }
        }

    }
    actions
    {
        area(Promoted)
        {
            actionref(PromotedShowRecord; ShowRecord) { }
            actionref(PromotedShowBcRecord; ShowBCRecord) { }

            actionref(PromotedSetProcessed; SetProcessed) { }
        }
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
                    Rec.showBCRecord();
                end;
            }


            action(SetProcessed)
            {
                ApplicationArea = All;
                Image = SetPriorities;
                Caption = 'Reset Processed Flag';

                trigger OnAction()
                var
                    PTAHelperFunctions: Codeunit "PTA Helper Functions";

                    PTATransactionStatus: Record "PTA Transaction Status";
                begin
                    CurrPage.SetSelectionFilter(PTATransactionStatus);
                    PTAHelperFunctions.SetRecordToNotProcessed(PTATransactionStatus);
                    CurrPage.Update();
                end;
            }

            action(ReprocessVAT)
            {
                ApplicationArea = All;
                Image = SetPriorities;
                Caption = 'Reprocess VAT issue';

                trigger OnAction()
                var
                    PTAHelperFunctions: Codeunit "PTA Helper Functions";
                begin
                    PTAHelperFunctions.ForceEnquiryCreationWithoutValidation(Rec);
                    CurrPage.Update();
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
