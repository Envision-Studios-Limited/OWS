using System;
using System.Collections.Generic;
using System.Text;
using System.Text.Json.Serialization;

namespace OWSData.Models.StoredProcs
{
    public class GetAllCharacters
    {
        public GetAllCharacters()
        {
        }

        public Guid CustomerGuid { get; set; }
        public Guid? AccountID { get; set; }
        public int CharacterId { get; set; }

        [JsonPropertyName("characterName")] public string CharName { get; set; }

        [JsonPropertyName("zoneName")] public string MapName { get; set; }
        public float X { get; set; }
        public float Y { get; set; }
        public float Z { get; set; }
        public float RX { get; set; }
        public float RY { get; set; }
        public float RZ { get; set; }
        public float Fishing { get; set; }
        public float Mining { get; set; }
        public float Woodcutting { get; set; }
        public float Smelting { get; set; }
        public float Smithing { get; set; }
        public float Cooking { get; set; }
        public float Fletching { get; set; }
        public float Tailoring { get; set; }
        public float Hunting { get; set; }
        public float Leatherworking { get; set; }
        public float Farming { get; set; }
        public float Herblore { get; set; }
        public float Spirit { get; set; }
        public float Magic { get; set; }
        public int TeamNumber { get; set; }
        public float Thirst { get; set; }
        public float Hunger { get; set; }
        public int Gold { get; set; }
        public int Score { get; set; }

        [JsonPropertyName("level")] public short CharacterLevel { get; set; }
        public short Gender { get; set; }
        public int XP { get; set; }
        public short HitDie { get; set; }
        public float Wounds { get; set; }
        public short Size { get; set; }
        public float Weight { get; set; }
        public float MaxHealth { get; set; }
        public float Health { get; set; }
        public float HealthRegenRate { get; set; }
        public float MaxMana { get; set; }
        public float Mana { get; set; }
        public float ManaRegenRate { get; set; }
        public float MaxEnergy { get; set; }
        public float Energy { get; set; }
        public float EnergyRegenRate { get; set; }
        public float MaxFatigue { get; set; }
        public float Fatigue { get; set; }
        public float FatigueRegenRate { get; set; }
        public float MaxStamina { get; set; }
        public float Stamina { get; set; }
        public float StaminaRegenRate { get; set; }
        public float MaxEndurance { get; set; }
        public float Endurance { get; set; }
        public float EnduranceRegenRate { get; set; }
        public float Strength { get; set; }
        public float Dexterity { get; set; }
        public float Constitution { get; set; }
        public float Intellect { get; set; }
        public float Wisdom { get; set; }
        public float Charisma { get; set; }
        public float Agility { get; set; }
        public float Fortitude { get; set; }
        public float Reflex { get; set; }
        public float Willpower { get; set; }
        public float BaseAttack { get; set; }
        public float BaseAttackBonus { get; set; }
        public float AttackPower { get; set; }
        public float AttackSpeed { get; set; }
        public float CritChance { get; set; }
        public float CritMultiplier { get; set; }
        public float Haste { get; set; }
        public float SpellPower { get; set; }
        public float SpellPenetration { get; set; }
        public float Defense { get; set; }
        public float Dodge { get; set; }
        public float Parry { get; set; }
        public float Avoidance { get; set; }
        public float Versatility { get; set; }
        public float Multishot { get; set; }
        public float Initiative { get; set; }
        public float NaturalArmor { get; set; }
        public float PhysicalArmor { get; set; }
        public float BonusArmor { get; set; }
        public float ForceArmor { get; set; }
        public float MagicArmor { get; set; }
        public float Resistance { get; set; }
        public float ReloadSpeed { get; set; }
        public float Range { get; set; }
        public float Speed { get; set; }
        public int Silver { get; set; }
        public int Copper { get; set; }
        public int FreeCurrency { get; set; }
        public int PremiumCurrency { get; set; }
        public float Fame { get; set; }
        public float Alignment { get; set; }
        public string ServerIP { get; set; }
        public DateTime LastActivity { get; set; }
        public string Description { get; set; }
        public string DefaultPawnClassPath { get; set; }
        public bool IsInternalNetworkTestUser { get; set; }
        public int ClassID { get; set; }
        public string BaseMesh { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsModerator { get; set; }

        [JsonPropertyName("createDate")] public DateTime CreateDate { get; set; }
    }
}