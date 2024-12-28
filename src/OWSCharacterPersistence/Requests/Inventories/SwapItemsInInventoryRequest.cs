using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Swap items index in inventory
/// </summary>
/// <remarks>
/// Swap items index in inventory
/// </remarks>
public class SwapItemsInInventoryRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the ID of character's inventory to be inserted an item
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    /// <summary>
    /// First Slot Index
    /// </summary>
    /// <remarks>
    /// First item index
    /// </remarks>
    public int FirstIndex { get; set; }
    
    /// <summary>
    /// Second Slot Index
    /// </summary>
    /// <remarks>
    /// Second item index
    /// </remarks>
    public int SecondIndex { get; set; }
    
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
        output = await charactersRepository.MoveItemBetweenIndices(customerGUID, CharacterInventoryID, FirstIndex, SecondIndex);
        
        return output;
    }
}