using System;
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
    /// Inventory Data
    /// </summary>
    /// <remarks>
    /// Inventory Data
    /// </remarks>
    public SetInventoryData InventoryData { get; set; }
    
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
        output = await charactersRepository.SetInventoryData(customerGUID, InventoryData);
        
        return output;
    }
}