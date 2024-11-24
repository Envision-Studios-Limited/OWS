﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OWSData.Models.Composites
{
    public class CreateCharacter
    {
        public bool Success { get; set; }
        public string ErrorMessage { get; set; }

        public string CharacterName { get; set; }
        public string ClassName { get; set; }
        public int CharacterLevel { get; set; }
        public string StartingMapName { get; set; }
        public float X { get; set; }
        public float Y { get; set; }
        public float Z { get; set; }
        public float RX { get; set; }
        public float RY { get; set; }
        public float RZ { get; set; }
        public int TeamNumber { get; set; }
        public int Gold { get; set; }
        public int Silver { get; set; }
        public int Copper { get; set; }
        public int FreeCurrency { get; set; }
        public int PremiumCurrency { get; set; }
        public float Fame { get; set; }
        public float Alignment { get; set; }
        public int Score { get; set; }
        public int Gender { get; set; }
        public int XP { get; set; }
        public int Size { get; set; }
        public float Weight { get; set; }

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
    }
}
