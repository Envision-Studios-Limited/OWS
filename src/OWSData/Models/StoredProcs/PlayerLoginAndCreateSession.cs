using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OWSData.Models.StoredProcs
{
    public class PlayerLoginAndCreateSession
    {
        public bool Authenticated { get; set; }  // Whether the player was authenticated or not
        public Guid? AccountSessionGuid { get; set; }  // The AccountSessionGUID generated during login
        public string ErrorMessage { get; set; }  // The error message (if any)

        public PlayerLoginAndCreateSession()
        {
            ErrorMessage = "";  // Default to an empty error message
        }
    }

}
