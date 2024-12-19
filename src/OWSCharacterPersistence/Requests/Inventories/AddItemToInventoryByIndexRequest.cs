using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Add Item To Inventory
/// </summary>
/// <remarks>
/// Adds an item to Character's inventory
/// </remarks>
public class AddItemToInventoryByIndexRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the ID of character's inventory to be inserted an item
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    /// <summary>
    /// Item ID
    /// </summary>
    /// <remarks>
    /// This is the ID of item
    /// </remarks>
    public int ItemID { get; set; }
    
    /// <summary>
    /// Item Quantity
    /// </summary>
    /// <remarks>
    /// This is the number of item to add
    /// </remarks>
    public int ItemQuantity { get; set; }
    
    /// <summary>
    /// Slot Index
    /// </summary>
    /// <remarks>
    /// This is the slot index number of inventory
    /// </remarks>
    public int SlotIndex { get; set; }
    
    private AddItemToInventoryResult output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;

    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<AddItemToInventoryResult> Handle()
    {
        output = new AddItemToInventoryResult();
        output = await charactersRepository.AddItemToInventoryByIndex(customerGUID, CharacterInventoryID, ItemID, ItemQuantity, SlotIndex);
        
        return output;
    }
}