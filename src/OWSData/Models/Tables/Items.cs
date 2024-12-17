using System;
using System.Collections.Generic;

namespace OWSData.Models.Tables
{
    public partial class Items
    {
        public Guid CustomerGuid { get; set; }
        public int ItemId { get; set; }
        public string ItemName { get; set; }
        public string Displayname { get; set; }
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
        public int ItemMeshID { get; set; }
        public string StaticMesh { get; set; }
        public string SkeletalMesh { get; set; }
        public short ItemQuality { get; set; }
        public int IconSlotWidth { get; set; }
        public int IconSlotHeight { get; set; }
        public List<string> Tags { get; set; }
        public List<string> Actions { get; set; }
        public List<string> AddedStats { get; set; }
        public List<string> StatValues { get; set; }
        public string CustomData { get; set; }
    }
}
