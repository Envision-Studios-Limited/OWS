using System.Collections.Generic;

namespace OWSData.Models.Composites;

public class AddItemToInventoryResult
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public List<ItemResult> Items { get; set; } = new();

    public class ItemResult
    {
        public int ItemId { get; set; }
        public int RemainingQuantity { get; set; }
    }
}