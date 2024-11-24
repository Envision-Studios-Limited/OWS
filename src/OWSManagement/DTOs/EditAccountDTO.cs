using System;

namespace OWSManagement.DTOs
{
    public class EditAccountDTO
    {
        public Guid AccountID { get; set; }
        public string AccountName { get; set; }
        public string Email { get; set; }
    }
}
