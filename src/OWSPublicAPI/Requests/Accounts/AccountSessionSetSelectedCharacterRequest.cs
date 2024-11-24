using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSPublicAPI.Requests.Account
{
    public class AccountSessionSetSelectedCharacterRequest : IRequestHandler<AccountSessionSetSelectedCharacterRequest, IActionResult>, IRequest
    {
        public Guid AccountSessionGUID { get; set; }
        public string SelectedCharacterName { get; set; }

        private SuccessAndErrorMessage output;
        private Guid customerGUID;
        private IAccountRepository _accountRepository;

        public void SetData(IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            customerGUID = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
        }

        public async Task<IActionResult> Handle()
        {
            output = await _accountRepository.AccountSessionSetSelectedCharacter(customerGUID, AccountSessionGUID, SelectedCharacterName);
            return new OkObjectResult(output);
        }
    }
}
