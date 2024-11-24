using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;
using OWSData.Models.StoredProcs;

namespace OWSPublicAPI.Requests.Account
{
    public class SetSelectedCharacterAndGetAccountSessionRequest : IRequestHandler<SetSelectedCharacterAndGetAccountSessionRequest, IActionResult>, IRequest
    {   
        public Guid AccountSessionGUID { get; set; }
        public string SelectedCharacterName { get; set; }

        private GetAccountSession output;
        private SuccessAndErrorMessage successOrError;
        private Guid customerGUID;
        private IAccountRepository _accountRepository;

        public void SetData(IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            customerGUID = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
        }

        public async Task<IActionResult> Handle()
        {
            successOrError = await _accountRepository.AccountSessionSetSelectedCharacter(customerGUID, AccountSessionGUID, SelectedCharacterName);
            output = await _accountRepository.GetAccountSession(customerGUID, AccountSessionGUID);

            return new OkObjectResult(output);
        }
    }
}
