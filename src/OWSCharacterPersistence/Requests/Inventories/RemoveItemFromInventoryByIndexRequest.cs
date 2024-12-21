using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Remove item from inventory by index
/// </summary>
/// <remarks>
/// Remove item from inventory by index
/// </remarks>
public class RemoveItemFromInventoryByIndexRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the ID of character's inventory to be inserted an item
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    /// <summary>
    /// Slot Index
    /// </summary>
    /// <remarks>
    /// This is the slot index number of inventory
    /// </remarks>
    public int SlotIndex { get; set; }
    
    /// <summary>
    /// Item Quantity
    /// </summary>
    /// <remarks>
    /// This is the number of item to add
    /// </remarks>
    public int ItemQuantity { get; set; }
    
    private RemoveItemInventoryResult output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;
    
    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }
    
    public async Task<RemoveItemInventoryResult> Handle()
    {
        output = new RemoveItemInventoryResult();
        output = await charactersRepository.RemoveItemFromInventoryByIndex(customerGUID, CharacterInventoryID, SlotIndex, ItemQuantity);
        
        return output;
    }
}