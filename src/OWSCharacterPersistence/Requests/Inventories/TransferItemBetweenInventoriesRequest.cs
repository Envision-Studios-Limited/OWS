using System;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Repositories.Interfaces;
using OWSShared.Interfaces;

namespace OWSCharacterPersistence.Requests.Inventories;

/// <summary>
/// Transfer Item Between Inventories
/// </summary>
/// <remarks>
/// Transfer Item Between Inventories
/// </remarks>
public class TransferItemBetweenInventoriesRequest
{
    /// <summary>
    /// Source Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the source character inventory ID
    /// </remarks>
    public int SourceCharacterInventoryID { get; set; }
    
    /// <summary>
    /// Target Character Inventory ID
    /// </summary>
    /// <remarks>
    /// This is the target character inventory ID
    /// </remarks>
    public int TargetCharacterInventoryID { get; set; }
    
    /// <summary>
    /// Item Quantity
    /// </summary>
    /// <remarks>
    /// This is the number of item to transfer
    /// </remarks>
    public int ItemQuantity { get; set; }
    
    /// <summary>
    /// Source Slot Index
    /// </summary>
    /// <remarks>
    /// Source item index
    /// </remarks>
    public int SourceSlotIndex { get; set; }
    
    private TransferItemResult output;
    private Guid customerGUID;
    private ICharactersRepository charactersRepository;

    public void SetData(ICharactersRepository charactersRepository, IHeaderCustomerGUID customerGuid)
    {
        this.charactersRepository = charactersRepository;
        customerGUID = customerGuid.CustomerGUID;
    }

    public async Task<TransferItemResult> Handle()
    {
        output = new TransferItemResult();
        output = await charactersRepository.TransferItemBetweenInventories(customerGUID, SourceCharacterInventoryID, TargetCharacterInventoryID, ItemQuantity, SourceSlotIndex);
        
        return output;
    }
}