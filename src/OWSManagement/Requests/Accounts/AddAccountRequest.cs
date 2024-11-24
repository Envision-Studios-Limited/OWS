using OWSData.Models.Composites;
using OWSData.Models.Tables;
using OWSData.Repositories.Interfaces;
using OWSManagement.DTOs;
using System;
using System.Reflection.Metadata;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;

namespace OWSManagement.Requests.Accounts
{
    public class AddAccountRequest
    {
        private readonly Guid _customerGuid;
        private AddAccountDTO AddAccountDto { get; set; }
        private readonly IAccountRepository _accountRepository;        

        public AddAccountRequest(Guid customerGuid, AddAccountDTO addAccountDto, IAccountRepository accountRepository)
        {
            _customerGuid = customerGuid;
            AddAccountDto = addAccountDto;
            _accountRepository = accountRepository;
        }

        public async Task<SuccessAndErrorMessage> Handle()
        {
            return await _accountRepository.RegisterAccount(_customerGuid, AddAccountDto.Email, AddAccountDto.Password, AddAccountDto.AccountName, AddAccountDto.Discord);
        }
    }
}
