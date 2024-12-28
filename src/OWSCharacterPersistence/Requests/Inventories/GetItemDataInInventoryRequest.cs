using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Get item data in inventory
/// </summary>
/// <remarks>
/// Get item data in inventory
/// </remarks>
public class GetItemDataInInventoryRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the ID of character's inventory to be inserted an item
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    /// <summary>
    /// Item Slot Index
    /// </summary>
    /// <remarks>
    /// Item item index
    /// </remarks>
    public int SlotIndex { get; set; }
    
    private GetItemDataInInventory output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;

    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<GetItemDataInInventory> Handle()
    {
        output = new GetItemDataInInventory();
        output = await charactersRepository.GetItemDataInInventory(customerGUID, CharacterInventoryID, SlotIndex);
        
        return output;
    }
}