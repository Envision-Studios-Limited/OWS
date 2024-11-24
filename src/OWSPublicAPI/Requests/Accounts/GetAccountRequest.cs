using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSPublicAPI.Requests.Account
{
    public class GetAccountRequest : IRequestHandler<GetAccountRequest, IActionResult>, IRequest
    {
        private OWSData.Models.Tables.Account output;
        private Guid customerGuid;
        private Guid userGuid;
        private IAccountRepository _accountRepository;

        public void SetData(Guid id, IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            userGuid = id;
            this.customerGuid = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
        }

        public async Task<IActionResult> Handle()
        {
            output = await _accountRepository.GetAccount(customerGuid, userGuid);

            return new OkObjectResult(output);
        }
    }
}
