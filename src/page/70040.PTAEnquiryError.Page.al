page 70040 PTAEnquiryError
{
    Caption = 'Enquiry Errorss';
    PageType = ListPart;
    SourceTable = PTAEnquiryError;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entity Type"; Rec.EntityType)
                {
                }
                field("Error Description"; Rec.ErrorDescription)
                {
                }
            }
        }
    }
}
