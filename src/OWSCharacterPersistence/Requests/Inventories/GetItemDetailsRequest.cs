using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Get item details
/// </summary>
/// <remarks>
/// Get item details
/// </remarks>
public class GetItemDetailsRequest
{
    
    /// <summary>
    /// Item ID
    /// </summary>
    /// <remarks>
    /// Item ID
    /// </remarks>
    public int ItemID { get; set; }
    
    private GetItemDetails output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;

    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<GetItemDetails> Handle()
    {
        output = new GetItemDetails();
        output = await charactersRepository.GetItemDetails(customerGUID, ItemID);
        
        return output;
    }
}