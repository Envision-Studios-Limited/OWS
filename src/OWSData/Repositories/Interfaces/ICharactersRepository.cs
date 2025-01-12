using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Models.StoredProcs;
using OWSData.Models.Tables;

namespace OWSData.Repositories.Interfaces
{
    public interface ICharactersRepository
    {
        Task AddCharacterToMapInstanceByCharName(Guid customerGUID, string characterName, int mapInstanceID);
        Task AddOrUpdateCustomCharacterData(Guid customerGUID, AddOrUpdateCustomCharacterData addOrUpdateCustomCharacterData);
        Task<MapInstances> CheckMapInstanceStatus(Guid customerGUID, int mapInstanceID);
        Task CleanUpInstances(Guid customerGUID);
        Task<GetCharByCharName> GetCharByCharName(Guid customerGUID, string characterName);
        Task<IEnumerable<CustomCharacterData>> GetCustomCharacterData(Guid customerGUID, string characterName);
        Task<JoinMapByCharName> JoinMapByCharName(Guid customerGUID, string characterName, string zoneName, int playerGroupType);
        Task UpdateCharacterStats(UpdateCharacterStats updateCharacterStats);
        Task UpdatePosition(Guid customerGUID, string characterName, string mapName, float X, float Y, float Z, float RX, float RY, float RZ);
        Task PlayerLogout(Guid customerGUID, string characterName);
        Task AddAbilityToCharacter(Guid customerGUID, string abilityName, string characterName, int abilityLevel, string charHasAbilitiesCustomJSON);
        Task<IEnumerable<Abilities>> GetAbilities(Guid customerGUID);
        Task<IEnumerable<GetCharacterAbilities>> GetCharacterAbilities(Guid customerGUID, string characterName);
        Task<IEnumerable<GetAbilityBars>> GetAbilityBars(Guid customerGUID, string characterName);
        Task<IEnumerable<GetAbilityBarsAndAbilities>> GetAbilityBarsAndAbilities(Guid customerGUID, string characterName);
        Task<MapInstances> SpinUpInstance(Guid customerGUID, string zoneName, int playerGroupId = 0);
        Task RemoveAbilityFromCharacter(Guid customerGUID, string abilityName, string characterName);
        Task UpdateAbilityOnCharacter(Guid customerGUID, string abilityName, string characterName, int abilityLevel, string charHasAbilitiesCustomJSON);
        Task<AddItemInventoryResult> AddItemToInventory(Guid customerGUID, int characterInventoryID, int itemId, int itemQuantity, string customData);
        Task<AddItemInventoryResult> AddItemToInventoryByIndex(Guid customerGUID, int characterInventoryID, int itemId, int itemQuantity, int slotIndex, string customData);
        Task<RemoveItemInventoryResult> RemoveItemFromInventoryByIndex(Guid customerGUID, int characterInventoryID, int slotIndex, int itemQuantity);
        Task<SuccessAndErrorMessage> MoveItemBetweenIndices(Guid customerGUID, int characterInventoryID, int fromIndex, int toIndex);
        Task<SuccessAndErrorMessage> SwapItemsInInventory(Guid customerGUID, int characterInventoryID, int firstIndex, int secondIndex);
        Task<GetItemDataInInventory> GetItemDataInInventory(Guid customerGUID, int characterInventoryID, int slotIndex);
        Task<GetItemDetails> GetItemDetails(Guid customerGUID, int itemId);
        Task<TransferItemResult> TransferItemBetweenInventories(Guid customerGUID, int sourceCharacterInventoryID, int targetCharacterInventoryID, int itemQuantity, int sourceSlotIndex, int targetSlotIndex);
        Task<TransferItemResult> TransferItemBetweenInventories(Guid customerGUID, int sourceCharacterInventoryID, int targetCharacterInventoryID, int itemQuantity, int sourceSlotIndex);
        Task<GetAllItemsInInventory> GetAllItemsInInventory(Guid customerGUID, int characterInventoryID);
        Task<SuccessAndErrorMessage> SetInventoryData(Guid customerGUID, SetInventoryData inventoryData);
    }
}
