using OWSData.Models.Composites;
using OWSData.Repositories.Implementations.MSSQL;
using OWSData.Repositories.Interfaces;
using OWSPublicAPI.DTOs;
using OWSShared.Interfaces;
using System;
using System.Threading.Tasks;

namespace OWSPublicAPI.Requests.Account
{
    public class LogoutRequest
    {
        private readonly LogoutDTO _logoutDTO;
        private readonly IHeaderCustomerGUID _customerGuid;
        private readonly IAccountRepository _accountRepository;

        public LogoutRequest(LogoutDTO logoutDTO, IAccountRepository accountRepository, IHeaderCustomerGUID customerGuid)
        {
            _logoutDTO = logoutDTO;
            _customerGuid = customerGuid;
            _accountRepository = accountRepository;
        }

        public async Task<SuccessAndErrorMessage> Handle()
        {
            return await _accountRepository.Logout(_customerGuid.CustomerGUID, _logoutDTO.UserSessionGUID);
        }
    }
}
