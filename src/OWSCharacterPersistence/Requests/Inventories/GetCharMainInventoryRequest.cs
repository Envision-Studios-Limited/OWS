using System;
using System.Threading.Tasks;
using OWSData.Models.Tables;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Get Character Main Inventory Request
/// </summary>
/// <remarks>
/// Get Character Main Inventory Request
/// </remarks>
public class GetCharMainInventoryRequest
{
    /// <summary>
    /// Character ID
    /// </summary>
    /// <remarks>
    /// Character ID
    /// </remarks>
    public int CharacterID { get; set; }
    
    private CharInventory output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;
    
    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<CharInventory> Handle()
    {
        output = new CharInventory();
        output = await charactersRepository.GetCharMainInventory(customerGUID, CharacterID);
        
        return output;
    }
}