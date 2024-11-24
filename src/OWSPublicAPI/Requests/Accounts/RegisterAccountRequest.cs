using Microsoft.AspNetCore.Mvc;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;
using OWSExternalLoginProviders.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using OWSData.Models.StoredProcs;
using OWSPublicAPI.DTOs;

namespace OWSPublicAPI.Requests.Account
{
    /// <summary>
    /// Register a User
    /// </summary>
    /// <remarks>
    /// Register a user with the system.  You can control validation with a custom IIPublicAPIInputValidation implementation.  See DefaultPublicAPIInputValidation for an example.
    /// </remarks>
    public class RegisterAccountRequest
    {
        private readonly RegisterAccountDTO _registerAccountDto;
        private readonly Guid _customerGUID;
        private readonly IAccountRepository _accountRepository;
        private readonly IExternalLoginProviderFactory _externalLoginProviderFactory;

        /// <summary>
        /// RegisterUserRequest Constructor
        /// </summary>
        /// <remarks>
        /// Initialize the RegisterUserRequest object with dependencies
        /// </remarks>
        public RegisterAccountRequest(RegisterAccountDTO registerAccountDto, IAccountRepository accountRepository, IExternalLoginProviderFactory externalLoginProviderFactory, IHeaderCustomerGUID customerGuid)
        {
            _registerAccountDto = registerAccountDto;
            _customerGUID = customerGuid.CustomerGUID;
            _accountRepository = accountRepository;
            _externalLoginProviderFactory = externalLoginProviderFactory;
        }

        /// <summary>
        /// RegisterUserRequest Request Handler
        /// </summary>
        /// <remarks>
        /// Handle the RegisterUserRequest request
        /// </remarks>
        public async Task<PlayerLoginAndCreateSession> Handle()
        {
            //Check for duplicate account before creating a new one:
            var foundUser = await _accountRepository.GetAccountFromEmail(_customerGUID, _registerAccountDto.Email);

            //This user already exists
            if (foundUser != null)
            {
                PlayerLoginAndCreateSession errorOutput = new PlayerLoginAndCreateSession()
                {
                    ErrorMessage = "Duplicate Account!"
                };

                return errorOutput;
            }

            //Register the new account
            SuccessAndErrorMessage registerOutput = await _accountRepository.RegisterAccount(_customerGUID, _registerAccountDto.Email, _registerAccountDto.Password, _registerAccountDto.AccountName, _registerAccountDto.Discord);

            //There was an error registering the new account
            if (!registerOutput.Success)
            {
                PlayerLoginAndCreateSession errorOutput = new PlayerLoginAndCreateSession()
                {
                    ErrorMessage = registerOutput.ErrorMessage
                };

                return errorOutput;
            }

            //Login to the new account to get a UserSession
            PlayerLoginAndCreateSession playerLoginAndCreateSession = await _accountRepository.LoginAndCreateSession(_customerGUID, _registerAccountDto.Email, _registerAccountDto.Password);

            /*
            if (externalLoginProviderFactory != null)
            {
                //This method will do nothing if AutoRegister isn't set to true
                //await externalLoginProvider.RegisterAsync(Email, Password, Email);
            }
            */

            return playerLoginAndCreateSession;
        }
    }
}
