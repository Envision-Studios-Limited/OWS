using System;
using System.Collections.Generic;
using System.Text;

namespace OWSData.Models.StoredProcs
{
    public class UpdateCharacterStats
    {
    public string CharName { get; set; } // CharacterName

    public int CharacterLevel { get; set; } // CharacterLevel
    public int Gender { get; set; } // Gender
    public float Weight { get; set; } // Weight
    public int Size { get; set; } // Size
    public float Fame { get; set; } // Fame
    public float Alignment { get; set; } // Alignment
    public string Description { get; set; } // Description
    public int XP { get; set; } // XP
    public float X { get; set; } // X
    public float Y { get; set; } // Y
    public float Z { get; set; } // Z
    public float RX { get; set; } // RX
    public float RY { get; set; } // RY
    public float RZ { get; set; } // RZ

    // Character skill-related fields
    public float Fishing { get; set; } // Fishing
    public float Mining { get; set; } // Mining
    public float Woodcutting { get; set; } // Woodcutting
    public float Smelting { get; set; } // Smelting
    public float Smithing { get; set; } // Smithing
    public float Cooking { get; set; } // Cooking
    public float Fletching { get; set; } // Fletching
    public float Tailoring { get; set; } // Tailoring
    public float Hunting { get; set; } // Hunting
    public float Leatherworking { get; set; } // Leatherworking
    public float Farming { get; set; } // Farming
    public float Herblore { get; set; } // Herblore

    // Character attributes and stats
    public float Spirit { get; set; } // Spirit
    public float Magic { get; set; } // Magic
    public int TeamNumber { get; set; } // TeamNumber
    public float Thirst { get; set; } // Thirst
    public float Hunger { get; set; } // Hunger

    // Health stats
    public float MaxHealth { get; set; } // MaxHealth
    public float Health { get; set; } // Health
    public float HealthRegenRate { get; set; } // HealthRegenRate

    // Mana stats
    public float MaxMana { get; set; } // MaxMana
    public float Mana { get; set; } // Mana
    public float ManaRegenRate { get; set; } // ManaRegenRate

    // Energy stats
    public float MaxEnergy { get; set; } // MaxEnergy
    public float Energy { get; set; } // Energy
    public float EnergyRegenRate { get; set; } // EnergyRegenRate

    // Fatigue stats
    public float MaxFatigue { get; set; } // MaxFatigue
    public float Fatigue { get; set; } // Fatigue
    public float FatigueRegenRate { get; set; } // FatigueRegenRate

    // Stamina stats
    public float MaxStamina { get; set; } // MaxStamina
    public float Stamina { get; set; } // Stamina
    public float StaminaRegenRate { get; set; } // StaminaRegenRate

    // Endurance stats
    public float MaxEndurance { get; set; } // MaxEndurance
    public float Endurance { get; set; } // Endurance
    public float EnduranceRegenRate { get; set; } // EnduranceRegenRate

    // Attributes
    public float Strength { get; set; } // Strength
    public float Dexterity { get; set; } // Dexterity
    public float Constitution { get; set; } // Constitution
    public float Intellect { get; set; } // Intellect
    public float Wisdom { get; set; } // Wisdom
    public float Charisma { get; set; } // Charisma
    public float Agility { get; set; } // Agility

    // Combat stats
    public float Fortitude { get; set; } // Fortitude
    public float Reflex { get; set; } // Reflex
    public float Willpower { get; set; } // Willpower
    public float BaseAttack { get; set; } // BaseAttack
    public float BaseAttackBonus { get; set; } // BaseAttackBonus
    public float AttackPower { get; set; } // AttackPower
    public float AttackSpeed { get; set; } // AttackSpeed
    public float CritChance { get; set; } // CritChance
    public float CritMultiplier { get; set; } // CritMultiplier
    public float Haste { get; set; } // Haste

    // Spell and defense stats
    public float SpellPower { get; set; } // SpellPower
    public float SpellPenetration { get; set; } // SpellPenetration
    public float Defense { get; set; } // Defense
    public float Dodge { get; set; } // Dodge
    public float Parry { get; set; } // Parry
    public float Avoidance { get; set; } // Avoidance
    public float Versatility { get; set; } // Versatility

    // Misc stats
    public float Multishot { get; set; } // Multishot
    public float Initiative { get; set; } // Initiative
    public float NaturalArmor { get; set; } // NaturalArmor
    public float PhysicalArmor { get; set; } // PhysicalArmor
    public float BonusArmor { get; set; } // BonusArmor
    public float ForceArmor { get; set; } // ForceArmor
    public float MagicArmor { get; set; } // MagicArmor
    public float Resistance { get; set; } // Resistance
    public float ReloadSpeed { get; set; } // ReloadSpeed
    public float Range { get; set; } // Range
    public float Speed { get; set; } // Speed

    // Currency stats
    public int Silver { get; set; } // Silver
    public int Copper { get; set; } // Copper
    public int FreeCurrency { get; set; } // FreeCurrency
    public int PremiumCurrency { get; set; } // PremiumCurrency

    // Character's combat and skill stats
    public float Perception { get; set; } // Perception
    public float Acrobatics { get; set; } // Acrobatics
    public float Climb { get; set; } // Climb
    public float Stealth { get; set; } // Stealth

    // Additional stats
    public int Score { get; set; } // Score

    public string CustomerGUID { get; set; } // CustomerGUID
    }

}
