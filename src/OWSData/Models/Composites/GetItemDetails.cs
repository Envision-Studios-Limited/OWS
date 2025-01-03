using System;
using System.Collections.Generic;

namespace OWSData.Models.Composites;

using System;
using System.Collections.Generic;

public class GetItemDetails
{
    public bool Success { get; set; }
    public string ErrorMessage { get; set; }
    // Properties for Items table columns
    public Guid CustomerGUID { get; set; }
    public int ItemID { get; set; }
    public string ItemName { get; set; }
    public string DisplayName { get; set; }
    public string DefaultVisualIdentity { get; set; }
    public decimal ItemWeight { get; set; }
    public bool ItemCanStack { get; set; }
    public short ItemStackSize { get; set; }
    public bool Tradeable { get; set; }
    public string Examine { get; set; }
    public bool Locked { get; set; }
    public string DecayItem { get; set; }
    public bool BequethStats { get; set; }
    public int ItemValue { get; set; }
    public string ItemMesh { get; set; }
    public string MeshToUseForPickup { get; set; }
    public string TextureToUseForIcon { get; set; }
    public string ExtraDecals { get; set; }
    public int PremiumCurrencyPrice { get; set; }
    public int FreeCurrencyPrice { get; set; }
    public int ItemTier { get; set; }
    public string ItemCode { get; set; }
    public int ItemDuration { get; set; }
    public string WeaponActorClass { get; set; }
    public string StaticMesh { get; set; }
    public string SkeletalMesh { get; set; }
    public short ItemQuality { get; set; }
    public int IconSlotWidth { get; set; }
    public int IconSlotHeight { get; set; }
    public int ItemMeshID { get; set; }
    public string CustomData { get; set; }

    // Collections for multiple actions, tags, and stats (if needed)
    public List<string> ItemActions { get; set; } = new List<string>();
    public List<string> ItemTags { get; set; } = new List<string>();
    public List<ItemStatMapping> ItemStats { get; set; } = new List<ItemStatMapping>();
}

// Helper class for ItemStat mappings
public class ItemStatMapping
{
    public string ItemStatName { get; set; }
    public string ItemStatValue { get; set; }
}