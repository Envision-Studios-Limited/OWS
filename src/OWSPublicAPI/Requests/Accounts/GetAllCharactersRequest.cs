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
    /// <summary>
    /// GetAllCharactersRequest
    /// </summary>
    /// <remarks>
    /// This request object handles requests for api/Account/GetAllCharacters
    /// </remarks>
    public class GetAllCharactersRequest
    {
        /// <summary>
        /// AccountSessionGUID
        /// </summary>
        /// <remarks>
        /// This is the Account Session GUID to determine the Account to get all Characters for.
        /// </remarks>
        public Guid AccountSessionGUID { get; set; }

        private IEnumerable<GetAllCharacters> output;
        private Guid customerGUID;
        private IAccountRepository _accountRepository;

        /// <summary>
        /// SetData
        /// </summary>
        /// <remarks>
        /// Used to pass dependencies to the Request object (for performance reasons).
        /// </remarks>
        public void SetData(IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            customerGUID = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
        }

        /// <summary>
        /// Handle
        /// </summary>
        /// <remarks>
        /// This handles the Request.
        /// </remarks>
        public async Task<IActionResult> Handle()
        {
            output = await _accountRepository.GetAllCharacters(customerGUID, AccountSessionGUID);

            return new OkObjectResult(output);
        }
    }
}
