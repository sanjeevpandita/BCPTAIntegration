page 70027 "STO Skip Comments"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    Caption = 'Skip Comments (upto 250 Characters)';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(SkipComments; SkipComments)
                {
                    ApplicationArea = All;
                    Caption = 'Skip Comments';
                    ShowCaption = false;
                    MultiLine = true;
                }
            }
        }
    }
    procedure GetSkipComnmets(): Text[250]
    begin
        exit(SkipComments);
    end;

    var
        SkipComments: Text[250];
}