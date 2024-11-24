using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;
using OWSPublicAPI.DTOs;

namespace OWSPublicAPI.Requests.Account
{
    /// <summary>
    /// CreateCharacterRequest Handler
    /// </summary>
    /// <remarks>
    /// Handles api/Account/CreateCharacter requests.
    /// </remarks>
    public class CreateCharacterUsingDefaultCharacterValuesRequest
    {
        private readonly CreateCharacterUsingDefaultCharacterValuesDTO _createCharacterUsingDefaultCharacterValuesDTO;

        private readonly Guid _customerGUID;
        private readonly IAccountRepository _accountRepository;
        private readonly ICharactersRepository _charactersRepository;
        private readonly IPublicAPIInputValidation _publicAPIInputValidation;

        /// <summary>
        /// Constrcutor for CreateCharacterUsingDefaultCharacterValuesRequest
        /// </summary>
        /// <remarks>
        /// Injects the dependencies for the CreateCharacterUsingDefaultCharacterValuesRequest.
        /// </remarks>
        public CreateCharacterUsingDefaultCharacterValuesRequest(CreateCharacterUsingDefaultCharacterValuesDTO createCharacterUsingDefaultCharacterValuesDTO, 
            IAccountRepository accountRepository, ICharactersRepository charactersRepository,
            IPublicAPIInputValidation publicAPIInputValidation, IHeaderCustomerGUID customerGuid)
        {
            _createCharacterUsingDefaultCharacterValuesDTO = createCharacterUsingDefaultCharacterValuesDTO;
            _customerGUID = customerGuid.CustomerGUID;
            _accountRepository = accountRepository;
            _charactersRepository = charactersRepository;
            _publicAPIInputValidation = publicAPIInputValidation;
        }

        /// <summary>
        /// Handles the CreateCharacterRequest
        /// </summary>
        /// <remarks>
        /// Overrides IRequestHandler Handle().
        /// </remarks>
        public async Task<SuccessAndErrorMessage> Handle()
        {
            //Validate Character Name
            string errorMessage = _publicAPIInputValidation.ValidateCharacterName(_createCharacterUsingDefaultCharacterValuesDTO.CharacterName);

            if (!String.IsNullOrEmpty(errorMessage))
            {
                SuccessAndErrorMessage successAndErrorMessage = new SuccessAndErrorMessage();
                successAndErrorMessage.Success = false;
                successAndErrorMessage.ErrorMessage = errorMessage;
                return successAndErrorMessage;
            }

            //Make sure Character Name is Unique
            var characterToLookup = await _charactersRepository.GetCharByCharName(_customerGUID, _createCharacterUsingDefaultCharacterValuesDTO.CharacterName);

            if (characterToLookup != null && characterToLookup.AccountID != Guid.Empty)
            {
                SuccessAndErrorMessage successAndErrorMessage = new SuccessAndErrorMessage();
                successAndErrorMessage.Success = false;
                successAndErrorMessage.ErrorMessage = "Character name already exists!";
                return successAndErrorMessage;
            }

            //Get Account Session
            var accountSession = await _accountRepository.GetAccountSession(_customerGUID, _createCharacterUsingDefaultCharacterValuesDTO.AccountSessionID);

            if (accountSession == null || !accountSession.AccountID.HasValue)
            {
                SuccessAndErrorMessage successAndErrorMessage = new SuccessAndErrorMessage();
                successAndErrorMessage.Success = false;
                successAndErrorMessage.ErrorMessage = "Invalid Account Session";
                return successAndErrorMessage;
            }

            await _accountRepository.CreateCharacterUsingDefaultCharacterValues(_customerGUID, accountSession.AccountID.Value, _createCharacterUsingDefaultCharacterValuesDTO.CharacterName,
                _createCharacterUsingDefaultCharacterValuesDTO.DefaultSetName);

            return new SuccessAndErrorMessage() { Success = true, ErrorMessage = "" };
        }
    }
}
