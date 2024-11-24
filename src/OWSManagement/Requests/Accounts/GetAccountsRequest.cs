using Microsoft.AspNetCore.Mvc;
using OWSData.Models.Tables;
using OWSData.Repositories.Interfaces;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace OWSManagement.Requests.Accounts
{
    public class GetAccountsRequest
    {
        private readonly Guid _customerGuid;
        private readonly IAccountRepository _accountRepository;

        public GetAccountsRequest(Guid customerGuid, IAccountRepository accountRepository)
        {
            _customerGuid = customerGuid;
            _accountRepository = accountRepository;
        }
        public async Task<IEnumerable<Account>> Handle()
        {
            return await _accountRepository.GetAccounts(_customerGuid); ;
        }
    }
}
