using System;
using System.Collections.Generic;

namespace OWSData.Models.Tables
{
    public partial class Account
    {
        public Account()
        {
            AccountSessions = new HashSet<AccountSession>();
        }

        public Guid AccountID { get; set; }
        public Guid CustomerGUID { get; set; }
        public Guid UUID { get; set; }
        public string AccountName { get; set; }
        public string PasswordHash { get; set; }
        public string Email { get; set; }
        public string Discord { get; set; }
        public DateTime CreateDate { get; set; }
        public string TosVersion { get; set; }
        public DateTime TosVersionAcceptDate { get; set; }
        public DateTime LastOnlineDate { get; set; }
        public string LastClientIP { get; set; }
        public string Role { get; set; }

        public ICollection<AccountSession> AccountSessions { get; set; }
    }

}
