using System;
using OWSData.Models.Tables;

namespace OWSData.Models.StoredProcs
{
    public class GetAccountSessionComposite
    {
        public AccountSession AccountSession { get; set; }
        public Account Account { get; set; }
        public Character Character { get; set; }

    }
    public class GetAccountSession
    {
        public Guid CustomerGUID { get; set; }
        public Guid? AccountID { get; set; }
        public Guid AccountSessionGUID { get; set; }
        public DateTime LoginDate { get; set; }
        public string SelectedCharacterName { get; set; }
        public string Email { get; set; }
        public string AccountName { get; set; }
        public DateTime CreateDate { get; set; }
        public DateTime LastOnlineDate { get; set; }
        public string Role { get; set; }

        public int CharacterID { get; set; }
        public string CharacterName { get; set; }
        public double X { get; set; }
        public double Y { get; set; }
        public double Z { get; set; }
        public double RX { get; set; }
        public double RY { get; set; }
        public double RZ { get; set; }
        public string ZoneName { get; set; }
    }

}
