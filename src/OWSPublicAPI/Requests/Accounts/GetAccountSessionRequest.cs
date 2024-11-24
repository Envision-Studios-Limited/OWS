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
    public class GetAccountSessionRequest : IRequestHandler<GetAccountSessionRequest, IActionResult>, IRequest
    {
        public Guid AccountSessionGUID { get; set; }

        private GetAccountSession output;
        private Guid customerGUID;
        private IAccountRepository _accountRepository;

        public void SetData(IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            customerGUID = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
        }

        public async Task<IActionResult> Handle()
        {
            output = await _accountRepository.GetAccountSession(customerGUID, AccountSessionGUID);

            return new OkObjectResult(output);
        }
    }

    /*public class GetUserSessionRequest : IRequestHandler<GetUserSessionRequest, IActionResult>, IRequest
    {
        public Guid UserSessionGUID { get; set; }

        private Models.StoredProcs.GetUserSession Output;
        private Guid CustomerGUID;
        private IUsersRepository usersRepository;

        public GetUserSessionRequest(IUsersRepository usersRepository, IHeaderCustomerGUID customerGuid)
        {
            CustomerGUID = customerGuid.CustomerGUID;
            this.usersRepository = usersRepository;
        }

        public async Task<IActionResult> Handle()
        {
            //Output = await usersRepository.GetUserSession(CustomerGUID, UserSessionGUID);
            Output = new Models.StoredProcs.GetUserSession();

            return new OkObjectResult(Output);
        }
    }*/


}
