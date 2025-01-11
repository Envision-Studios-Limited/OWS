using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Get Character Inventory Items Request
/// </summary>
/// <remarks>
/// Get Character Inventory Items Request
/// </remarks>
public class GetAllItemsInInventoryRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the ID of character's inventory to be inserted an item
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    private GetAllItemsInInventory output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;

    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<GetAllItemsInInventory> Handle()
    {
        output = new GetAllItemsInInventory();
        output = await charactersRepository.GetAllItemsInInventory(customerGUID, CharacterInventoryID);
        
        return output;
    }
}