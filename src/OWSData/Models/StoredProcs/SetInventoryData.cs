using System.Collections.Generic;

namespace OWSData.Models.StoredProcs;

public class SetInventoryData
{
    public int CharacterInventoryID { get; set; }
    public List<NewItemRequest> Items { get; set; }
}

public class NewItemRequest
{
    public int ItemID { get; set; }
    public int Quantity { get; set; }
    public string CustomData { get; set; }
    public int InSlotNumber { get; set; }
}