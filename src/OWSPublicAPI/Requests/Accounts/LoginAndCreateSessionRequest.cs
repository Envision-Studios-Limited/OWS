using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using OWSData.Models.StoredProcs;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSPublicAPI.Requests.Account
{
    public class LoginAndCreateSessionRequest : IRequestHandler<LoginAndCreateSessionRequest, IActionResult>, IRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }

        private PlayerLoginAndCreateSession output;
        private Guid customerGUID;
        private IAccountRepository _accountRepository;

        public void SetData(IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            //CustomerGUID = new Guid("56FB0902-6FE7-4BFE-B680-E3C8E497F016");
            this.customerGUID = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
        }

        public async Task<IActionResult> Handle()
        {
            output = await _accountRepository.LoginAndCreateSession(customerGUID, Email, Password, false);

            if (!output.Authenticated || !output.AccountSessionGuid.HasValue || output.AccountSessionGuid == Guid.Empty)
            {
                output.ErrorMessage = "Username or Password is invalid!";
            }

            return new OkObjectResult(output);
        }
    }
}
