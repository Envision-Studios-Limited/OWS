using System;
using System.Collections.Generic;
using OWSData.Models.Tables;

namespace OWSData.Models.Composites;

public class GetAllItemsInInventory
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public List<CharInventoryItems> Items { get; set; } = new List<CharInventoryItems>();
}