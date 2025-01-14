using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Models.StoredProcs;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Set Inventory Data
/// </summary>
/// <remarks>
/// Set Inventory Data
/// </remarks>
public class SetInventoryDataRequest
{
    /// <summary>
    /// Character Inventory ID
    /// </summary>
    /// <remarks>
    /// Character Inventory ID
    /// </remarks>
    public int CharacterInventoryID { get; set; }
    
    /// <summary>
    /// List of item
    /// </summary>
    /// <remarks>
    /// List of item
    /// </remarks>
    public List<NewItemRequest> Items { get; set; }
    
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
        output = await charactersRepository.SetInventoryData(customerGUID, CharacterInventoryID, Items);
        
        return output;
    }
}