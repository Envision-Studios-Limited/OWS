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
        /// Add Item to Inventory By index
        /// </summary>
        /// <remarks>
        /// Adds an Item to an Inventory by index
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// <b>ItemID</b> - This is the ID of item.<br/>
        /// <b>ItemQuantity</b> - This is the number of item to add.<br/>
        /// <b>SlotIndex</b> - This is the slot index number of inventory.<br/>
        /// </param>
        [HttpPost]
        [Route("AddItemToInventoryByIndex")]
        [Produces(typeof(AddItemInventoryResult))]
        public async Task<AddItemInventoryResult> AddItemToInventoryByIndex([FromBody] AddItemToInventoryByIndexRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
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
        [Produces(typeof(AddItemInventoryResult))]
        public async Task<AddItemInventoryResult> AddItemToInventory([FromBody] AddItemToInventoryRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Remove Item from Inventory By Index
        /// </summary>
        /// <remarks>
        /// Remove item from inventory by index
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// <b>SlotIndex</b> - This is the slot index number of inventory.<br/>
        /// <b>ItemQuantity</b> - This is the number of item to add.<br/>
        /// </param>
        [HttpPost]
        [Route("RemoveItemFromInventoryByIndex")]
        [Produces(typeof(RemoveItemInventoryResult))]
        public async Task<RemoveItemInventoryResult> RemoveItemFromInventoryByIndex([FromBody] RemoveItemFromInventoryByIndexRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }

        /// <summary>
        /// Move item from index a to b 
        /// </summary>
        /// <remarks>
        /// Move item from index a to b
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// <b>FromIndex</b> - This is the source slot index number of inventory.<br/>
        /// <b>ToIndex</b> - This is the destination slot index number of inventory.<br/>
        /// </param>
        [HttpPost]
        [Route("MoveItemBetweenIndices")]
        [Produces(typeof(SuccessAndErrorMessage))]
        public async Task<SuccessAndErrorMessage> MoveItemBetweenIndices([FromBody] MoveInventoryItemRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Swap items in inventory 
        /// </summary>
        /// <remarks>
        /// Swap items in inventory
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// <b>FirstIndex</b> - First item index to swap.<br/>
        /// <b>SecondIndex</b> - Second item index to swap.<br/>
        /// </param>
        [HttpPost]
        [Route("SwapItemsInInventory")]
        [Produces(typeof(SuccessAndErrorMessage))]
        public async Task<SuccessAndErrorMessage> SwapItemsInInventory([FromBody] SwapItemsInInventoryRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Get Item Data In Inventory
        /// </summary>
        /// <remarks>
        /// Get Item Data In Inventory
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// <b>SlotIndex</b> - Item slot index.<br/>
        /// </param>
        [HttpPost]
        [Route("GetItemDataInInventory")]
        [Produces(typeof(GetItemDataInInventory))]
        public async Task<GetItemDataInInventory> GetItemDataInInventory([FromBody] GetItemDataInInventoryRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Get Item Details
        /// </summary>
        /// <remarks>
        /// Get Item Details
        /// </remarks>
        /// <param name="request">
        /// <b>ItemID</b> - Item ID.<br/>
        /// </param>
        [HttpPost]
        [Route("GetItemDetails")]
        [Produces(typeof(GetItemDetails))]
        public async Task<GetItemDetails> GetItemDetails([FromBody] GetItemDetailsRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }

        /// <summary>
        /// Transfer Item Between Inventories To Specific Index
        /// </summary>
        /// <remarks>
        /// Transfer Item Between Inventories To Specific Index
        /// </remarks>
        /// <param name="request">
        /// <b>SourceCharacterInventoryID</b> - The source character inventory ID.<br/>
        /// <b>TargetCharacterInventoryID</b> - The target character inventory ID.<br/>
        /// <b>ItemQuantity</b> - The number of item to transfer.<br/>
        /// <b>SourceSlotIndex</b> - Source item index.<br/>
        /// <b>TargetSlotIndex</b> - Source item index.<br/>
        /// </param>
        [HttpPost]
        [Route("TransferItemBetweenInventoriesByIndex")]
        [Produces(typeof(TransferItemResult))]
        public async Task<TransferItemResult> TransferItemBetweenInventoriesByIndex(
            [FromBody] TransferItemBetweenInventoriesByIndexRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Transfer Item Between Inventories
        /// </summary>
        /// <remarks>
        /// Transfer Item Between Inventories
        /// </remarks>
        /// <param name="request">
        /// <b>SourceCharacterInventoryID</b> - The source character inventory ID.<br/>
        /// <b>TargetCharacterInventoryID</b> - The target character inventory ID.<br/>
        /// <b>ItemQuantity</b> - The number of item to transfer.<br/>
        /// <b>SourceSlotIndex</b> - Source item index.<br/>
        /// </param>
        [HttpPost]
        [Route("TransferItemBetweenInventories")]
        [Produces(typeof(TransferItemResult))]
        public async Task<TransferItemResult> TransferItemBetweenInventories(
            [FromBody] TransferItemBetweenInventoriesRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Get All Items in Inventory
        /// </summary>
        /// <remarks>
        /// Get All Items in Inventory
        /// </remarks>
        /// <param name="request">
        /// <b>CharacterInventoryID</b> - This is the ID of character's inventory to be inserted an item.<br/>
        /// </param>
        [HttpPost]
        [Route("GetAllItemsInInventory")]
        [Produces(typeof(GetAllItemsInInventory))]
        public async Task<GetAllItemsInInventory> GetAllItemsInInventory([FromBody] GetAllItemsInInventoryRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
        
        /// <summary>
        /// Set Inventory Data
        /// </summary>
        /// <remarks>
        /// Set Inventory Data
        /// </remarks>
        /// <param name="request">
        /// <b>SetInventoryData</b> - Character's Inventory ID & list of items.<br/>
        /// </param>
        [HttpPost]
        [Route("SetInventoryData")]
        [Produces(typeof(SuccessAndErrorMessage))]
        public async Task<SuccessAndErrorMessage> SetInventoryData([FromBody] SetInventoryDataRequest request)
        {
            request.SetData(_charactersRepository, _customerGuid);
            return await request.Handle();
        }
    }
}