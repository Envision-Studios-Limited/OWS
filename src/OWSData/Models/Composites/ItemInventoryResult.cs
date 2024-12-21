using System.Collections.Generic;

namespace OWSData.Models.Composites;

public class ItemResult
{
    public int ItemID { get; set; }
    public int Quantity { get; set; }
    public string CustomData { get; set; }
}

public class AddItemInventoryResult
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public List<ItemResult> RejectedItems { get; set; } = new();
}

public class RemoveItemInventoryResult
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    public List<ItemResult> RemovedItems { get; set; } = new();
}