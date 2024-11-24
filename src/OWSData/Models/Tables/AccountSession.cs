using System;
using System.Collections.Generic;

namespace OWSData.Models.Tables
{
    public partial class AccountSession
    {
        public Guid CustomerGUID { get; set; }
        public Guid AccountSessionGUID { get; set; }
        public Guid AccountID { get; set; }
        public DateTime LoginDate { get; set; }
        public string SelectedCharacterName { get; set; }

        public Account Account { get; set; }
    }

}
