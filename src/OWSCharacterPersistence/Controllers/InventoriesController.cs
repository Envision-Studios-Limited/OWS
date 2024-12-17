using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using OWSCharacterPersistence.Requests.Abilities;
using OWSCharacterPersistence.Requests.Inventories;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Controllers
{
    /// <summary>
    /// Inventory related API calls.
    /// </summary>
    /// <remarks>
    /// Contains inventory related API calls that are only accessible internally.
    [Route("api/[controller]")]
    [ApiController]
    public class InventoriesController : Controller
    {
        private readonly ICharactersRepository _charactersRepository;
        private readonly IHeaderCustomerGUID _customerGuid;
        
        /// <summary>
        /// Constructor for Inventory related API calls.
        /// </summary>
        /// <remarks>
        /// All dependencies are injected.
        /// </remarks>
        public InventoriesController(ICharactersRepository charactersRepository,
            IHeaderCustomerGUID customerGuid)
        {
            _charactersRepository = charactersRepository;
            _customerGuid = customerGuid;
        }
        
        /// <summary>
        /// OnActionExecuting override
        /// </summary>
        /// <remarks>
        /// Checks for an empty IHeaderCustomerGUID.
        /// </remarks>
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            if (_customerGuid.CustomerGUID == Guid.Empty)
            {
                context.Result = new UnauthorizedResult();
            }
        }
        
        /// <summary>
        /// Add Item to Inventory
        /// </summary>
        /// <remarks>
        /// Adds an Item to an Inventory
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// <b>ItemID</b> - This is the ID of item.<br/>
        /// <b>ItemQuantity</b> - This is the number of item to add.<br/>
        /// </param>
        [HttpPost]
        [Route("AddItemToInventory")]
        [Produces(typeof(AddItemToInventoryResult))]
        public async Task<AddItemToInventoryResult> AddItemToInventory([FromBody] AddItemToInventoryRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }

    }
}