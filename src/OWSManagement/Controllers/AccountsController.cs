using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using OWSData.Models.Composites;
using OWSData.Models.Tables;
using OWSData.Repositories.Interfaces;
using OWSManagement.DTOs;
using OWSManagement.Requests.Accounts;
using OWSShared.Interfaces;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace OWSManagement.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AccountsController : Controller
    {
        private readonly IHeaderCustomerGUID _customerGuid;
        private readonly IAccountRepository _accountRepository;

        public AccountsController(IHeaderCustomerGUID customerGuid, IAccountRepository accountRepository)
        {
            _customerGuid = customerGuid;
            _accountRepository = accountRepository;
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            if (_customerGuid.CustomerGUID == Guid.Empty)
            {
                context.Result = new UnauthorizedResult();
            }
        }


        /// <summary>
        /// Get all Accounts
        /// </summary>
        /// <remarks>
        /// Gets a list of all accounts for this CustomerGUID
        /// </remarks>
        [HttpGet]
        [Route("")]
        [Produces(typeof(IEnumerable<Account>))]
        public async Task<IEnumerable<Account>> Get()
        {
            GetAccountsRequest getAccountsRequest = new GetAccountsRequest(_customerGuid.CustomerGUID, _accountRepository);

            return await getAccountsRequest.Handle();
        }

        /// <summary>
        /// Add an Account
        /// </summary>
        /// <remarks>
        /// Adds a new account
        /// </remarks>
        [HttpPost]
        [Route("")]
        [Produces(typeof(SuccessAndErrorMessage))]
        public async Task<SuccessAndErrorMessage> Post([FromBody] AddAccountDTO addAccountDto)
        {
            AddAccountRequest addAccountRequest = new AddAccountRequest(_customerGuid.CustomerGUID, addAccountDto, _accountRepository);

            return await addAccountRequest.Handle();
        }

        /// <summary>
        /// Edit an Account
        /// </summary>
        /// <remarks>
        /// Edit an existing account.  Don't allow editing of the password.
        /// </remarks>
        [HttpPut]
        [Route("")]
        [Produces(typeof(SuccessAndErrorMessage))]
        public async Task<SuccessAndErrorMessage> Put([FromBody] EditAccountDTO editAccountDto)
        {
            EditAccountRequest editAccountRequest = new EditAccountRequest(_customerGuid.CustomerGUID, editAccountDto, _accountRepository);

            return await editAccountRequest.Handle();
        }
    }
}
