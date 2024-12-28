using System;
using System.Collections.Generic;

namespace OWSData.Models.Composites;

public class GetItemDataInInventory
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public int ItemID { get; set; }
    public int Quantity { get; set; }
    public int InSlotNumber { get; set; }
    public int NumberOfUsesLeft { get; set; }
    public Guid CharInventoryItemGUID { get; set; }
    public string CustomData { get; set; }
}