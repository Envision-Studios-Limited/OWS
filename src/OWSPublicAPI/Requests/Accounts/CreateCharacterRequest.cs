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
    /// <summary>
    /// CreateCharacterRequest Handler
    /// </summary>
    /// <remarks>
    /// Handles api/Account/CreateCharacter requests.
    /// </remarks>
    public class CreateCharacterRequest : IRequestHandler<CreateCharacterRequest, IActionResult>, IRequest
    {
        /// <summary>
        /// AccountSessionGUID Request Paramater.
        /// </summary>
        /// <remarks>
        /// Contains the Account Session GUID from the request.  This identifies the Account we are modifying.
        /// </remarks>
        public Guid AccountSessionGUID { get; set; }
        /// <summary>
        /// CharacterName Request Paramater.
        /// </summary>
        /// <remarks>
        /// Contains the Character Name from the request.  This is the new Character Name to create.
        /// </remarks>
        public string CharacterName { get; set; }
        /// <summary>
        /// ClassName Request Paramater.
        /// </summary>
        /// <remarks>
        /// Contains the Class Name from the request.  This sets the default values for the new Character.
        /// </remarks>
        public string ClassName { get; set; }

        private CreateCharacter Output;
        private Guid CustomerGUID;
        private IAccountRepository _accountRepository;
        private IPublicAPIInputValidation publicAPIInputValidation;

        /// <summary>
        /// Set Dependencies for CreateCharacterRequest
        /// </summary>
        /// <remarks>
        /// Injects the dependencies for the CreateCharacterRequest.
        /// </remarks>
        public void SetData(IAccountRepository accountRepository, IPublicAPIInputValidation publicAPIInputValidation, IHeaderCustomerGUID customerGuid)
        {
            CustomerGUID = customerGuid.CustomerGUID;
            this._accountRepository = accountRepository;
            this.publicAPIInputValidation = publicAPIInputValidation;
        }

        /// <summary>
        /// Handles the CreateCharacterRequest
        /// </summary>
        /// <remarks>
        /// Overrides IRequestHandler Handle().
        /// </remarks>
        public async Task<IActionResult> Handle()
        {
            //Validate Character Name
            string errorMessage = publicAPIInputValidation.ValidateCharacterName(CharacterName);

            if (!String.IsNullOrEmpty(errorMessage))
            {
                CreateCharacter createCharacterErrorMessage = new CreateCharacter();
                createCharacterErrorMessage.ErrorMessage = errorMessage;
                return new OkObjectResult(createCharacterErrorMessage);
            }

            Output = await _accountRepository.CreateCharacter(CustomerGUID, AccountSessionGUID, CharacterName, ClassName);

            return new OkObjectResult(Output);
        }
    }
}
