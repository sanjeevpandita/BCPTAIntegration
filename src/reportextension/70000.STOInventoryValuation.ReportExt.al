reportextension 70000 "STO Inventory Valuation" extends "Inventory Valuation"
{
    rendering
    {
        layout(CostPerUnit)
        {
            Type = RDLC;
            LayoutFile = './src/Layouts/InventoryValuation.rdl';
            Caption = 'Cost Per Unit included';
            Summary = 'Cost Per Unit included';
        }
    }
}