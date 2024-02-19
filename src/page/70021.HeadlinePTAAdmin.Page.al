page 70021 "Headline PTA Admin"
{
    Caption = 'Headline';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            // group(Control1)
            // {
            //     ShowCaption = false;
            //     field(GreetingText; RCHeadlinesPageCommon.GetGreetingText())
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = 'Greeting headline';
            //         Editable = false;
            //     }
            // }
            group(Control1)
            {
                ShowCaption = false;
                field(GreetingText; GetLastIntgrationText())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Integration Text';
                    Editable = false;
                }
            }
            group(Control2)
            {
                ShowCaption = false;
                field(DocumentationText; PTARoleCentreText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documentation headline';
                    DrillDown = true;
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Team Member");
        PTARoleCentreText := 'This is PTA Admin Role Centre';
    end;

    local procedure GetLastIntgrationText(): Text
    var
        PTAIntegrationLog: Record "PTA Integration Log";
    begin
        PTAIntegrationLog.reset;
        PTAIntegrationLog.SetCurrentKey("Integration Date/Time");
        if PTAIntegrationLog.FindLast() then
            Exit(StrSubstNo('Last Integration %1 ran at %2', PTAIntegrationLog."Entity Name", PTAIntegrationLog."Integration Date/Time"))
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
        PTARoleCentreText: Text;
}

