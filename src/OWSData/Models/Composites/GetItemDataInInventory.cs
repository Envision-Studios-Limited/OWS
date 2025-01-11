using System;
using System.Collections.Generic;
using OWSData.Models.Tables;

namespace OWSData.Models.Composites;

public class GetItemDataInInventory
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public CharInventoryItems Item { get; set; }
}