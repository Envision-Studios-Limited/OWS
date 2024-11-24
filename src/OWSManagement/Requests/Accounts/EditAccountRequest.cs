using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSManagement.DTOs;
using System.Threading.Tasks;
using System;

namespace OWSManagement.Requests.Accounts
{
    public class EditAccountRequest
    {
        private readonly Guid _customerGuid;
        private EditAccountDTO EditAccountDto { get; set; }
        private readonly IAccountRepository _accountRepository;

        public EditAccountRequest(Guid customerGuid, EditAccountDTO editAccountDto, IAccountRepository accountRepository)
        {
            _customerGuid = customerGuid;
            EditAccountDto = editAccountDto;
            _accountRepository = accountRepository;
        }

        public async Task<SuccessAndErrorMessage> Handle()
        {
            return await _accountRepository.UpdateAccount(_customerGuid, EditAccountDto.AccountID, EditAccountDto.AccountName, EditAccountDto.Email);
        }
    }
}
