using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Move item's index in inventory
/// </summary>
/// <remarks>
/// Move item's index in inventory
/// </remarks>
public class MoveInventoryItemRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the ID of character's inventory to be inserted an item
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    /// <summary>
    /// From Slot Index
    /// </summary>
    /// <remarks>
    /// This is the source index
    /// </remarks>
    public int FromIndex { get; set; }
    
    /// <summary>
    /// To Slot Index
    /// </summary>
    /// <remarks>
    /// This is index destination
    /// </remarks>
    public int ToIndex { get; set; }
    
    private SuccessAndErrorMessage output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;

    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<SuccessAndErrorMessage> Handle()
    {
        output = new SuccessAndErrorMessage();
        output = await charactersRepository.MoveItemBetweenIndices(customerGUID, CharacterInventoryID, FromIndex, ToIndex);
        
        return output;
    }
}