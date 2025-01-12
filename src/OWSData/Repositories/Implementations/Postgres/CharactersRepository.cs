using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Npgsql;
using System.Threading.Tasks;
using Dapper.Transaction;
using Microsoft.Extensions.Options;
using OWSData.Models;
using OWSData.Models.Composites;
using OWSData.Models.StoredProcs;
using OWSData.Repositories.Interfaces;
using OWSData.Models.Tables;
using OWSData.SQL;
using OWSShared.Options;
using DynamicParameters = Dapper.DynamicParameters;

namespace OWSData.Repositories.Implementations.Postgres
{
    public class CharactersRepository : ICharactersRepository
    {
        private readonly IOptions<StorageOptions> _storageOptions;

        public CharactersRepository(IOptions<StorageOptions> storageOptions)
        {
            _storageOptions = storageOptions;
        }

        private IDbConnection Connection => new NpgsqlConnection(_storageOptions.Value.OWSDBConnectionString);

        public async Task AddCharacterToMapInstanceByCharName(Guid customerGUID, string characterName, int mapInstanceID)
        {
            IDbConnection conn = Connection;
            conn.Open();
            using IDbTransaction transaction = conn.BeginTransaction();
            try
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);
                parameters.Add("@MapInstanceID", mapInstanceID);

                // Fetch the CharacterID based on the character name
                var outputCharacter = await Connection.QuerySingleOrDefaultAsync<int>(GenericQueries.GetCharacterIDByName,
                    parameters,
                    commandType: CommandType.Text);

                // Fetch the ZoneName based on the map instance ID
                var outputZone = await Connection.QuerySingleOrDefaultAsync<string>(GenericQueries.GetZoneName,
                    parameters,
                    commandType: CommandType.Text);

                // If the character exists (CharacterID is greater than 0)
                if (outputCharacter > 0)
                {
                    parameters.Add("@CharacterID", outputCharacter);
                    parameters.Add("@ZoneName", outputZone);

                    // Remove the character from all instances
                    await Connection.ExecuteAsync(GenericQueries.RemoveCharacterFromAllInstances,
                        parameters,
                        commandType: CommandType.Text);

                    // Add the character to the specified map instance
                    await Connection.ExecuteAsync(GenericQueries.AddCharacterToInstance,
                        parameters,
                        commandType: CommandType.Text);

                    // Update the character's map name (zone)
                    await Connection.ExecuteAsync(GenericQueries.UpdateCharacterZone,
                        parameters,
                        commandType: CommandType.Text);
                }

                // Commit the transaction after successful operations
                transaction.Commit();
            }
            catch (Exception ex)
            {
                // Rollback the transaction in case of an error
                transaction.Rollback();
                throw new Exception("Database Exception in AddCharacterToMapInstanceByCharName!", ex);
            }
        }

        public async Task AddOrUpdateCustomCharacterData(Guid customerGUID, AddOrUpdateCustomCharacterData addOrUpdateCustomCharacterData)
        {
            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", addOrUpdateCustomCharacterData.CharacterName);
                parameters.Add("@CustomFieldName", addOrUpdateCustomCharacterData.CustomFieldName);
                parameters.Add("@FieldValue", addOrUpdateCustomCharacterData.FieldValue);

                var outputCharacter = await Connection.QuerySingleOrDefaultAsync<Character>(GenericQueries.GetCharacterIDByName,
                    parameters,
                    commandType: CommandType.Text);

                if (outputCharacter.CharacterId > 0)
                {
                    parameters.Add("@CharacterID", outputCharacter.CharacterId);

                    var hasCustomCharacterData = await Connection.QuerySingleOrDefaultAsync<int>(GenericQueries.HasCustomCharacterDataForField,
                        parameters,
                        commandType: CommandType.Text);

                    if (hasCustomCharacterData > 0)
                    {
                        await Connection.ExecuteAsync(GenericQueries.UpdateCharacterCustomDataField,
                            parameters,
                            commandType: CommandType.Text);
                    }
                    else
                    {
                        await Connection.ExecuteAsync(GenericQueries.AddCharacterCustomDataField,
                            parameters,
                            commandType: CommandType.Text);
                    }
                }
            }
        }

        public async Task<MapInstances> CheckMapInstanceStatus(Guid customerGUID, int mapInstanceID)
        {
            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@MapInstanceID", mapInstanceID);

                var outputObject = await Connection.QuerySingleOrDefaultAsync<MapInstances>(GenericQueries.GetMapInstanceStatus,
                    parameters,
                    commandType: CommandType.Text);

                if (outputObject == null)
                {
                    return new MapInstances();
                }

                return outputObject;
            }
        }

        public async Task CleanUpInstances(Guid customerGUID)
        {
            IDbConnection conn = Connection;
            conn.Open();
            using IDbTransaction transaction = conn.BeginTransaction();
            try
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharacterMinutes", 1); // TODO Add Configuration Parameter
                parameters.Add("@MapMinutes", 2); // TODO Add Configuration Parameter

                await transaction.ExecuteAsync(PostgresQueries.RemoveCharactersFromAllInactiveInstances,
                    parameters,
                    commandType: CommandType.Text);

                var outputMapInstances = await transaction.QueryAsync<int>(PostgresQueries.GetAllInactiveMapInstances,
                    parameters,
                    commandType: CommandType.Text);

                if (outputMapInstances.Any())
                {
                    parameters.Add("@MapInstances", outputMapInstances);

                    await transaction.ExecuteAsync(PostgresQueries.RemoveCharacterFromInstances,
                        parameters,
                        commandType: CommandType.Text);

                    await transaction.ExecuteAsync(PostgresQueries.RemoveMapInstances,
                        parameters,
                        commandType: CommandType.Text);

                }
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
                throw new Exception("Database Exception in CleanUpInstances!");
            }
        }

        public async Task<GetCharByCharName> GetCharByCharName(Guid customerGUID, string characterName)
        {
            IEnumerable<GetCharByCharName> outputCharacter;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);

                outputCharacter = await Connection.QueryAsync<GetCharByCharName>(GenericQueries.GetCharByCharName,
                    parameters,
                    commandType: CommandType.Text);
            }

            return outputCharacter.FirstOrDefault();
        }

        public async Task<IEnumerable<CustomCharacterData>> GetCustomCharacterData(Guid customerGUID, string characterName)
        {
            IEnumerable<CustomCharacterData> outputCustomCharacterDataRows;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);

                outputCustomCharacterDataRows = await Connection.QueryAsync<CustomCharacterData>(GenericQueries.GetCharacterCustomDataByName,
                    parameters,
                    commandType: CommandType.Text);
            }

            return outputCustomCharacterDataRows;
        }

        public async Task<JoinMapByCharName> JoinMapByCharName(Guid customerGUID, string characterName, string zoneName, int playerGroupType)
        {
            // TODO: Run Cleanup here for now. Later this can get moved to a scheduler to run periodically.
            await CleanUpInstances(customerGUID);

            JoinMapByCharName outputObject = new JoinMapByCharName();

            string serverIp = "";
            int? worldServerId = 0;
            string worldServerIp = "";
            int worldServerPort = 0;
            int port = 0;
            int mapInstanceID = 0;
            string mapNameToStart = "";
            int? mapInstanceStatus = 0;
            bool needToStartupMap = false;
            bool enableAutoLoopback = false;
            bool noPortForwarding = false;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);
                parameters.Add("@ZoneName", zoneName);
                parameters.Add("@PlayerGroupType", playerGroupType);

                Maps outputMap = await Connection.QuerySingleOrDefaultAsync<Maps>(GenericQueries.GetMapByZoneName,
                    parameters,
                    commandType: CommandType.Text);

                Character outputCharacter = await Connection.QuerySingleOrDefaultAsync<Character>(GenericQueries.GetCharacterByName,
                    parameters,
                    commandType: CommandType.Text);

                Customers outputCustomer = await Connection.QuerySingleOrDefaultAsync<Customers>(GenericQueries.GetCustomer,
                    parameters,
                    commandType: CommandType.Text);

                if (outputCharacter == null)
                {
                    outputObject = new JoinMapByCharName() {
                        ServerIP = serverIp,
                        Port = port,
                        WorldServerID = -1,
                        WorldServerIP = worldServerIp,
                        WorldServerPort = worldServerPort,
                        MapInstanceID = mapInstanceID,
                        MapNameToStart = mapNameToStart,
                        MapInstanceStatus = -1,
                        NeedToStartupMap = false,
                        EnableAutoLoopback = enableAutoLoopback,
                        NoPortForwarding = noPortForwarding
                    };

                    return outputObject;
                }

                PlayerGroup outputPlayerGroup = new PlayerGroup();

                if (playerGroupType > 0)
                {
                    outputPlayerGroup = await Connection.QuerySingleOrDefaultAsync<PlayerGroup>(GenericQueries.GetPlayerGroupIDByType,
                        parameters,
                        commandType: CommandType.Text);
                }
                else
                {
                    outputPlayerGroup.PlayerGroupId = 0;
                }

                parameters.Add("@IsInternalNetworkTestUser", outputCharacter.IsInternalNetworkTestUser);
                parameters.Add("@SoftPlayerCap", outputMap.SoftPlayerCap);
                parameters.Add("@PlayerGroupID", outputPlayerGroup.PlayerGroupId);
                parameters.Add("@MapID", outputMap.MapId);

                JoinMapByCharName outputJoinMapByCharName = await Connection.QuerySingleOrDefaultAsync<JoinMapByCharName>(PostgresQueries.GetZoneInstancesByZoneAndGroup,
                    parameters,
                    commandType: CommandType.Text);

                if (outputJoinMapByCharName != null)
                {
                    outputObject.NeedToStartupMap = false;
                    outputObject.WorldServerID = outputJoinMapByCharName.WorldServerID;
                    outputObject.ServerIP = outputJoinMapByCharName.ServerIP;
                    if (outputCharacter.IsInternalNetworkTestUser)
                    {
                        outputObject.ServerIP = outputJoinMapByCharName.WorldServerIP;
                    }
                    outputObject.WorldServerIP = outputJoinMapByCharName.WorldServerIP;
                    outputObject.WorldServerPort = outputJoinMapByCharName.WorldServerPort;
                    outputObject.Port = outputJoinMapByCharName.Port;
                    outputObject.MapInstanceID = outputJoinMapByCharName.MapInstanceID;
                    outputObject.MapNameToStart = outputMap.MapName;
                }
                else
                {
                    MapInstances outputMapInstance = await SpinUpInstance(customerGUID, zoneName, outputPlayerGroup.PlayerGroupId);

                    parameters.Add("@WorldServerId", outputMapInstance.WorldServerId);

                    WorldServers outputWorldServers =  await Connection.QuerySingleOrDefaultAsync<WorldServers>(GenericQueries.GetWorldByID,
                        parameters,
                        commandType: CommandType.Text);

                    outputObject.NeedToStartupMap = true;
                    outputObject.WorldServerID = outputMapInstance.WorldServerId;
                    outputObject.ServerIP = outputWorldServers.ServerIp;
                    if (outputCharacter.IsInternalNetworkTestUser)
                    {
                        outputObject.ServerIP = outputWorldServers.InternalServerIp;
                    }
                    outputObject.WorldServerIP = outputWorldServers.InternalServerIp;
                    outputObject.WorldServerPort = outputWorldServers.Port;
                    outputObject.Port = outputMapInstance.Port;
                    outputObject.MapInstanceID = outputMapInstance.MapInstanceId;
                    outputObject.MapNameToStart = outputMap.MapName;
                }

                // if (outputCharacter.Email.Contains("@localhost") || outputCharacter.IsInternalNetworkTestUser)
                if (outputCharacter.IsInternalNetworkTestUser)
                {
                    outputObject.ServerIP = "127.0.0.1";
                }
            }

            return outputObject;
        }

        public async Task<MapInstances> SpinUpInstance(Guid customerGUID, string zoneName, int playerGroupId = 0)
        {
            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@ZoneName", zoneName);
                parameters.Add("@PlayerGroupId", playerGroupId);

                List<WorldServers> outputWorldServers = (List<WorldServers>)await Connection.QueryAsync<WorldServers>(GenericQueries.GetActiveWorldServersByLoad,
                    parameters,
                    commandType: CommandType.Text);

                if (outputWorldServers.Any())
                {
                    int? firstAvailable = null;
                    foreach (var worldServer in outputWorldServers)
                    {
                        var portsInUse = await Connection.QueryAsync<int>(GenericQueries.GetPortsInUseByWorldServer,
                            parameters,
                            commandType: CommandType.Text);

                        firstAvailable = Enumerable.Range(worldServer.StartingMapInstancePort, worldServer.StartingMapInstancePort + worldServer.MaxNumberOfInstances)
                            .Except(portsInUse)
                            .FirstOrDefault();

                        if (firstAvailable >= worldServer.StartingMapInstancePort)
                        {

                            Maps outputMaps = await Connection.QuerySingleOrDefaultAsync<Maps>(GenericQueries.GetMapByZoneName,
                                parameters,
                                commandType: CommandType.Text);

                            parameters.Add("@WorldServerID", worldServer.WorldServerId);
                            parameters.Add("@MapID", outputMaps.MapId);
                            parameters.Add("@Port", firstAvailable);

                            int outputMapInstanceID = await Connection.QuerySingleOrDefaultAsync<int>(PostgresQueries.AddMapInstance,
                                parameters,
                                commandType: CommandType.Text);

                            parameters.Add("@MapInstanceID", outputMapInstanceID);

                            MapInstances outputMapInstances = await Connection.QuerySingleOrDefaultAsync<MapInstances>(GenericQueries.GetMapInstance,
                                parameters,
                                commandType: CommandType.Text);

                            return outputMapInstances;
                        }
                    }
                }
            }

            return new MapInstances { MapInstanceId = -1 };
        }

        public async Task UpdateCharacterStats(UpdateCharacterStats updateCharacterStats)
        {
            using (Connection)
            {
                await Connection.ExecuteAsync(GenericQueries.UpdateCharacterStats.Replace("@CustomerGUID", "@CustomerGUID::uuid"), // NOTE Postgres text=>uuid
                    updateCharacterStats,
                    commandType: CommandType.Text);
            }
        }

        public async Task UpdatePosition(Guid customerGUID, string characterName, string mapName, float X, float Y, float Z, float RX, float RY, float RZ)
        {
            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGUID);
                p.Add("@CharName", characterName);
                p.Add("@MapName", mapName);
                p.Add("@X", X);
                p.Add("@Y", Y);
                p.Add("@Z", Z + 1);
                p.Add("@RX", RX);
                p.Add("@RY", RY);
                p.Add("@RZ", RZ);

                if (mapName != String.Empty)
                {
                    await Connection.ExecuteAsync(GenericQueries.UpdateCharacterPositionAndMap,
                        p,
                        commandType: CommandType.Text);
                }
                else
                {
                    await Connection.ExecuteAsync(GenericQueries.UpdateCharacterPosition,
                        p,
                        commandType: CommandType.Text);
                }

                await Connection.ExecuteAsync(PostgresQueries.UpdateAccountLastOnlineDate,
                    p,
                    commandType: CommandType.Text);
            }
        }

        public async Task PlayerLogout(Guid customerGUID, string characterName)
        {
            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);

                var outputCharacter = await Connection.QuerySingleOrDefaultAsync<Character>(GenericQueries.GetCharacterIDByName,
                    parameters,
                    commandType: CommandType.Text);

                if (outputCharacter.CharacterId > 0)
                {
                    parameters.Add("@CharacterID", outputCharacter.CharacterId);

                    await Connection.ExecuteAsync(GenericQueries.RemoveCharacterFromAllInstances,
                        parameters,
                        commandType: CommandType.Text);
                }
            }
        }

        public async Task AddAbilityToCharacter(Guid customerGUID, string abilityName, string characterName, int abilityLevel, string charHasAbilitiesCustomJSON)
        {
            using (Connection)
            {
                var parameters = new
                {
                    CustomerGUID = customerGUID,
                    AbilityName = abilityName,
                    CharacterName = characterName,
                    AbilityLevel = abilityLevel,
                    CharHasAbilitiesCustomJSON = charHasAbilitiesCustomJSON
                };

                var outputCharacterAbility = await Connection.QuerySingleOrDefaultAsync<GlobalData>(GenericQueries.GetCharacterAbilityByName,
                    parameters,
                    commandType: CommandType.Text);

                if (outputCharacterAbility == null)
                {
                    await Connection.ExecuteAsync(PostgresQueries.AddAbilityToCharacter,
                        parameters,
                        commandType: CommandType.Text);
                }
            }
        }

        public async Task<IEnumerable<Abilities>> GetAbilities(Guid customerGUID)
        {
            IEnumerable<Abilities> outputGetAbilities;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);

                outputGetAbilities = await Connection.QueryAsync<Abilities>(GenericQueries.GetAbilities,
                    parameters,
                    commandType: CommandType.Text);
            }

            return outputGetAbilities;
        }

        public async Task<IEnumerable<GetCharacterAbilities>> GetCharacterAbilities(Guid customerGUID, string characterName)
        {
            IEnumerable<GetCharacterAbilities> outputGetCharacterAbilities;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);

                outputGetCharacterAbilities = await Connection.QueryAsync<GetCharacterAbilities>(GenericQueries.GetCharacterAbilities,
                    parameters,
                    commandType: CommandType.Text);
            }

            return outputGetCharacterAbilities;
        }

        public async Task<IEnumerable<GetAbilityBars>> GetAbilityBars(Guid customerGUID, string characterName)
        {
            IEnumerable<GetAbilityBars> outputGetAbilityBars;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);

                outputGetAbilityBars = await Connection.QueryAsync<GetAbilityBars>(GenericQueries.GetCharacterAbilityBars,
                    parameters,
                    commandType: CommandType.Text);
            }

            return outputGetAbilityBars;
        }

        public async Task<IEnumerable<GetAbilityBarsAndAbilities>> GetAbilityBarsAndAbilities(Guid customerGUID, string characterName)
        {
            IEnumerable<GetAbilityBarsAndAbilities> outputGetAbilityBarsAndAbilities;

            using (Connection)
            {
                var parameters = new DynamicParameters();
                parameters.Add("@CustomerGUID", customerGUID);
                parameters.Add("@CharName", characterName);

                outputGetAbilityBarsAndAbilities = await Connection.QueryAsync<GetAbilityBarsAndAbilities>(GenericQueries.GetCharacterAbilityBarsAndAbilities,
                    parameters,
                    commandType: CommandType.Text);
            }

            return outputGetAbilityBarsAndAbilities;
        }

        public async Task RemoveAbilityFromCharacter(Guid customerGUID, string abilityName, string characterName)
        {
            using (Connection)
            {
                var parameters = new
                {
                    CustomerGUID = customerGUID,
                    AbilityName = abilityName,
                    CharacterName = characterName
                };

                await Connection.ExecuteAsync(PostgresQueries.RemoveAbilityFromCharacter, parameters);
            }
        }

        public async Task UpdateAbilityOnCharacter(Guid customerGUID, string abilityName, string characterName, int abilityLevel, string charHasAbilitiesCustomJSON)
        {
            using (Connection)
            {
                var parameters = new
                {
                    CustomerGUID = customerGUID,
                    AbilityName = abilityName,
                    CharacterName = characterName,
                    AbilityLevel = abilityLevel,
                    CharHasAbilitiesCustomJSON = charHasAbilitiesCustomJSON
                };

                await Connection.ExecuteAsync(PostgresQueries.UpdateAbilityOnCharacter, parameters);
            }
        }

        public async Task<AddItemInventoryResult> AddItemToInventory(Guid customerGUID, int characterInventoryID, int itemId, int itemQuantity, string customData)
        {
            var result = new AddItemInventoryResult();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    p.Add("@ItemID", itemId);
                    p.Add("@ItemQuantity", itemQuantity);
                    p.Add("@CustomData", customData);

                    // Call the PostgreSQL function
                    var queryResult = await Connection.QueryAsync<ItemResult>(
                        "SELECT * FROM AddItemToInventory(@CustomerGUID, @CharacterInventoryID, @ItemID, @ItemQuantity, @CustomData)",
                        p,
                        commandType: CommandType.Text);

                    result.RejectedItems = queryResult.ToList();
                    
                    // Check if the item was completely rejected
                    if (result.RejectedItems.Any() && result.RejectedItems.Sum(x => x.Quantity) >= itemQuantity)
                    {
                        result.Success = false;
                        result.ErrorMessage = "The item was completely rejected. No space available in the inventory.";
                    }
                    else
                    {
                        result.Success = true;
                        result.ErrorMessage = string.Empty;
                    }
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }

            return result;
        }

        public async Task<AddItemInventoryResult> AddItemToInventoryByIndex(Guid customerGUID, int characterInventoryID, int itemId, int itemQuantity, int slotIndex, string customData)
        {
            var result = new AddItemInventoryResult();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    p.Add("@ItemID", itemId);
                    p.Add("@ItemQuantity", itemQuantity);
                    p.Add("@SlotIndex", slotIndex);
                    p.Add("@CustomData", customData);

                    // Call the PostgreSQL function
                    var queryResult = await Connection.QueryAsync<ItemResult>(
                        "SELECT * FROM AddItemToInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @ItemID, @ItemQuantity, @SlotIndex, @CustomData)",
                        p,
                        commandType: CommandType.Text);

                    result.RejectedItems = queryResult.ToList();
                    
                    // Check if the item was completely rejected
                    if (result.RejectedItems.Any() && result.RejectedItems.Sum(x => x.Quantity) >= itemQuantity)
                    {
                        result.Success = false;
                        result.ErrorMessage = "The item was completely rejected. No space available in the inventory.";
                    }
                    else
                    {
                        result.Success = true;
                        result.ErrorMessage = string.Empty;
                    }
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }

            return result;
        }

        public async Task<RemoveItemInventoryResult> RemoveItemFromInventoryByIndex(Guid customerGUID, int characterInventoryID, int slotIndex, int itemQuantity)
        {
            var result = new RemoveItemInventoryResult();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    p.Add("@SlotIndex", slotIndex);
                    p.Add("@ItemQuantity", itemQuantity);

                    // Call the PostgreSQL function
                    var queryResult = await Connection.QueryAsync<ItemResult>(
                        "SELECT * FROM RemoveItemFromInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @SlotIndex, @ItemQuantity)",
                        p,
                        commandType: CommandType.Text);

                    result.RemovedItems = queryResult.ToList();
                    result.Success = true;
                    result.ErrorMessage = string.Empty;
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }

            return result;
        }

        public async Task<SuccessAndErrorMessage> MoveItemBetweenIndices(Guid customerGUID, int characterInventoryID, int fromIndex, int toIndex)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    p.Add("@FromIndex", fromIndex);
                    p.Add("@ToIndex", toIndex);
                    
                    var queryResult = await Connection.QueryAsync(
                        "SELECT * FROM MoveItemBetweenIndices(@CustomerGUID, @CharacterInventoryID, @FromIndex, @ToIndex)",
                        p,
                        commandType: CommandType.Text);
                }

                outputObject.Success = true;
                outputObject.ErrorMessage = "";

                return outputObject;
            }
            catch (Exception ex)
            {
                outputObject.Success = false;
                outputObject.ErrorMessage = ex.Message;

                return outputObject;
            }
        }

        public async Task<SuccessAndErrorMessage> SwapItemsInInventory(Guid customerGUID, int characterInventoryID, int firstIndex, int secondIndex)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    p.Add("@FirstIndex", firstIndex);
                    p.Add("@SecondIndex", secondIndex);
                    
                    var queryResult = await Connection.QueryAsync(
                        "SELECT * FROM SwapItemsInInventory(@CustomerGUID, @CharacterInventoryID, @FirstIndex, @SecondIndex)",
                        p,
                        commandType: CommandType.Text);
                }

                outputObject.Success = true;
                outputObject.ErrorMessage = "";

                return outputObject;
            }
            catch (Exception ex)
            {
                outputObject.Success = false;
                outputObject.ErrorMessage = ex.Message;

                return outputObject;
            }
        }

        public async Task<GetItemDataInInventory> GetItemDataInInventory(Guid customerGUID, int characterInventoryID, int slotIndex)
        {
            var result = new GetItemDataInInventory();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    p.Add("@SlotIndex", slotIndex);

                    // Call the PostgreSQL function
                    var queryResult = await Connection.QuerySingleOrDefaultAsync<GetItemDataInInventory>(
                        "SELECT * FROM GetItemDataByIndex(@CustomerGUID, @CharacterInventoryID, @SlotIndex)",
                        p,
                        commandType: CommandType.Text);

                    result = queryResult;
                    result.Success = true;
                    result.ErrorMessage = string.Empty;
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }

            return result;
        }

        public async Task<GetItemDetails> GetItemDetails(Guid customerGUID, int itemId)
        {
            using (Connection)
            {
                var result = new GetItemDetails();
                
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGUID);
                p.Add("@ItemID", itemId);

                // Dictionary to store the item and its collections
                var itemDictionary = new Dictionary<int, GetItemDetails>();

                // Execute the query and map the results
                var results = await Connection.QueryAsync<GetItemDetails, string, string, ItemStatMapping, GetItemDetails>(
                    GenericQueries.GetItemDetails,
                    (item, action, tag, stat) =>
                    {
                        // Check if the item is already in the dictionary
                        if (!itemDictionary.TryGetValue(item.ItemID, out var itemEntry))
                        {
                            itemEntry = item;
                            itemEntry.ItemActions = new List<string>();
                            itemEntry.ItemTags = new List<string>();
                            itemEntry.ItemStats = new List<ItemStatMapping>();
                            itemDictionary.Add(item.ItemID, itemEntry);
                        }

                        // Add actions, tags, and stats to their respective collections
                        if (!string.IsNullOrEmpty(action) && !itemEntry.ItemActions.Contains(action))
                        {
                            itemEntry.ItemActions.Add(action);
                        }
                        if (!string.IsNullOrEmpty(tag) && !itemEntry.ItemTags.Contains(tag))
                        {
                            itemEntry.ItemTags.Add(tag);
                        }
                        if (stat != null && !string.IsNullOrEmpty(stat.ItemStatName) && !itemEntry.ItemStats.Any(s => s.ItemStatName == stat.ItemStatName && s.ItemStatValue == stat.ItemStatValue))
                        {
                            itemEntry.ItemStats.Add(stat);
                        }

                        return itemEntry;
                    },
                    p,
                    splitOn: "ItemAction,ItemTag,ItemStatName" // Split the result into multiple objects
                );
                
                // Check if the item exists
                if (!itemDictionary.Any())
                {
                    result.Success = false;
                    result.ErrorMessage = "Item not found";
                    return result;
                }
                
                result = itemDictionary.Values.FirstOrDefault();
                result!.Success = true;
                result.ErrorMessage = string.Empty;
                // Return the first (and only) item in the dictionary
                return result;
            }
        }

        public async Task<TransferItemResult> TransferItemBetweenInventories(Guid customerGUID, int sourceCharacterInventoryID, int targetCharacterInventoryID, int itemQuantity, int sourceSlotIndex, int targetSlotIndex)
        {
            var result = new TransferItemResult();
            IDbConnection conn = Connection;
            conn.Open();
            using IDbTransaction transaction = conn.BeginTransaction();
            
            try
            {
                // Step 1: Remove item from source inventory
                var removeParameters = new DynamicParameters();
                removeParameters.Add("@CustomerGUID", customerGUID);
                removeParameters.Add("@CharacterInventoryID", sourceCharacterInventoryID);
                removeParameters.Add("@SlotIndex", sourceSlotIndex);
                removeParameters.Add("@ItemQuantity", itemQuantity);

                var removedItems = await Connection.QueryAsync<ItemResult>(
                    "SELECT * FROM RemoveItemFromInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @SlotIndex, @ItemQuantity)",
                    removeParameters,
                    transaction,
                    commandType: CommandType.Text);

                if (!removedItems.Any())
                {
                    throw new Exception("Failed to remove item from source inventory.");
                }

                ItemResult removedItem = removedItems.FirstOrDefault();

                // Step 2: Add item to target inventory
                var addParameters = new DynamicParameters();
                addParameters.Add("@CustomerGUID", customerGUID);
                addParameters.Add("@CharacterInventoryID", targetCharacterInventoryID);
                addParameters.Add("@ItemID", removedItem.ItemID);
                addParameters.Add("@ItemQuantity", removedItem.Quantity);
                addParameters.Add("@SlotIndex", targetSlotIndex);
                addParameters.Add("@CustomData", removedItem.CustomData);

                var rejectedItems = await Connection.QueryAsync<ItemResult>(
                    "SELECT * FROM AddItemToInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @ItemID, @ItemQuantity, @SlotIndex, @CustomData)",
                    addParameters,
                    transaction,
                    commandType: CommandType.Text);

                // Step 3: Handle rejected items
                if (rejectedItems.Any())
                {
                    // Add the rejected items back to the source inventory
                    foreach (var rejectedItem in rejectedItems)
                    {
                        var addBackParameters = new DynamicParameters();
                        addBackParameters.Add("@CustomerGUID", customerGUID);
                        addBackParameters.Add("@CharacterInventoryID", sourceCharacterInventoryID);
                        addBackParameters.Add("@ItemID", rejectedItem.ItemID);
                        addBackParameters.Add("@ItemQuantity", rejectedItem.Quantity);
                        addBackParameters.Add("@SlotIndex", sourceSlotIndex);
                        addBackParameters.Add("@CustomData", rejectedItem.CustomData);

                        await Connection.ExecuteAsync(
                            "SELECT * FROM AddItemToInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @ItemID, @ItemQuantity, @SlotIndex, @CustomData)",
                            addBackParameters,
                            transaction,
                            commandType: CommandType.Text);
                    }
                }

                // Commit the transaction
                transaction.Commit();

                // Set result
                result.Success = true;
                result.ErrorMessage = string.Empty;
                result.RemovedItems = removedItems.ToList();
                result.RejectedItems = rejectedItems.ToList();
            }
            catch (Exception ex)
            {
                // Rollback the transaction on error
                transaction.Rollback();

                // Set result
                result.Success = false;
                result.ErrorMessage = ex.Message;
                result.RemovedItems = new List<ItemResult>();
                result.RejectedItems = new List<ItemResult>();
            }

            return result;
        }

        public async Task<TransferItemResult> TransferItemBetweenInventories(Guid customerGUID, int sourceCharacterInventoryID, int targetCharacterInventoryID,
            int itemQuantity, int sourceSlotIndex)
        {
            var result = new TransferItemResult();
            IDbConnection conn = Connection;
            conn.Open();
            using IDbTransaction transaction = conn.BeginTransaction();
            
            try
            {
                // Step 1: Remove item from source inventory
                var removeParameters = new DynamicParameters();
                removeParameters.Add("@CustomerGUID", customerGUID);
                removeParameters.Add("@CharacterInventoryID", sourceCharacterInventoryID);
                removeParameters.Add("@SlotIndex", sourceSlotIndex);
                removeParameters.Add("@ItemQuantity", itemQuantity);

                var removedItems = await Connection.QueryAsync<ItemResult>(
                    "SELECT * FROM RemoveItemFromInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @SlotIndex, @ItemQuantity)",
                    removeParameters,
                    transaction,
                    commandType: CommandType.Text);

                if (!removedItems.Any())
                {
                    throw new Exception("Failed to remove item from source inventory.");
                }

                ItemResult removedItem = removedItems.FirstOrDefault();

                // Step 2: Add item to target inventory
                var addParameters = new DynamicParameters();
                addParameters.Add("@CustomerGUID", customerGUID);
                addParameters.Add("@CharacterInventoryID", targetCharacterInventoryID);
                addParameters.Add("@ItemID", removedItem.ItemID);
                addParameters.Add("@ItemQuantity", removedItem.Quantity);
                addParameters.Add("@CustomData", removedItem.CustomData);

                var rejectedItems = await Connection.QueryAsync<ItemResult>(
                    "SELECT * FROM AddItemToInventory(@CustomerGUID, @CharacterInventoryID, @ItemID, @ItemQuantity, @CustomData)",
                    addParameters,
                    transaction,
                    commandType: CommandType.Text);

                // Step 3: Handle rejected items
                if (rejectedItems.Any())
                {
                    // Add the rejected items back to the source inventory
                    foreach (var rejectedItem in rejectedItems)
                    {
                        var addBackParameters = new DynamicParameters();
                        addBackParameters.Add("@CustomerGUID", customerGUID);
                        addBackParameters.Add("@CharacterInventoryID", sourceCharacterInventoryID);
                        addBackParameters.Add("@ItemID", rejectedItem.ItemID);
                        addBackParameters.Add("@ItemQuantity", rejectedItem.Quantity);
                        addBackParameters.Add("@SlotIndex", sourceSlotIndex);
                        addBackParameters.Add("@CustomData", rejectedItem.CustomData);

                        await Connection.ExecuteAsync(
                            "SELECT * FROM AddItemToInventoryByIndex(@CustomerGUID, @CharacterInventoryID, @ItemID, @ItemQuantity, @SlotIndex, @CustomData)",
                            addBackParameters,
                            transaction,
                            commandType: CommandType.Text);
                    }
                }

                // Commit the transaction
                transaction.Commit();

                // Set result
                result.Success = true;
                result.ErrorMessage = string.Empty;
                result.RemovedItems = removedItems.ToList();
                result.RejectedItems = rejectedItems.ToList();
            }
            catch (Exception ex)
            {
                // Rollback the transaction on error
                transaction.Rollback();

                // Set result
                result.Success = false;
                result.ErrorMessage = ex.Message;
                result.RemovedItems = new List<ItemResult>();
                result.RejectedItems = new List<ItemResult>();
            }

            return result;
        }

        public async Task<GetAllItemsInInventory> GetAllItemsInInventory(Guid customerGUID, int characterInventoryID)
        {
            var result = new GetAllItemsInInventory();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@CharacterInventoryID", characterInventoryID);
                    
                    // Check if the CharacterInventoryID exists
                    var inventoryExists = await Connection.QueryFirstOrDefaultAsync<int>(
                        "SELECT 1 FROM CharInventory WHERE CustomerGUID = @CustomerGUID AND CharInventoryID = @CharacterInventoryID",
                        p,
                        commandType: CommandType.Text);
                    
                    if (inventoryExists == 0)
                    {
                        throw new Exception($"CharacterInventoryID {characterInventoryID} not found for CustomerGUID {customerGUID}.");
                    }

                    // Call the PostgreSQL function
                    var queryResult = await Connection.QueryAsync<CharInventoryItems>(
                        GenericQueries.GetAllItemsInInventory,
                        p,
                        commandType: CommandType.Text);

                    result.Items = queryResult.ToList();
                    result.Success = true;
                    result.ErrorMessage = string.Empty;
                }
            }
            catch (Exception ex)
            {
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }

            return result;
        }

        public async Task<SuccessAndErrorMessage> SetInventoryData(Guid customerGUID, SetInventoryData inventoryData)
        {
            var result = new SuccessAndErrorMessage();
            IDbConnection conn = Connection;
            conn.Open();
            using IDbTransaction transaction = conn.BeginTransaction();
            
            try
            {
                // Step 1: Remove item from source inventory
                var removeParameters = new DynamicParameters();
                removeParameters.Add("@CustomerGUID", customerGUID);
                removeParameters.Add("@CharacterInventoryID", inventoryData.CharacterInventoryID);

                await Connection.ExecuteAsync(
                    "DELETE FROM CharInventoryItems WHERE CustomerGUID = @CustomerGUID AND CharInventoryID = @CharacterInventoryID",
                    removeParameters,
                    transaction,
                    commandType: CommandType.Text);

                foreach (var item in inventoryData.Items)
                {
                    var insertParams = new DynamicParameters();
                    insertParams.Add("CustomerGUID", customerGUID);
                    insertParams.Add("CharacterInventoryID", inventoryData.CharacterInventoryID);
                    insertParams.Add("ItemID", item.ItemID);
                    insertParams.Add("InSlotNumber", item.InSlotNumber);
                    insertParams.Add("Quantity", item.Quantity);
                    insertParams.Add("CustomData", item.CustomData);

                    await Connection.ExecuteAsync(
                        "INSERT INTO CharInventoryItems (CustomerGUID, CharInventoryID, ItemID, InSlotNumber, Quantity, CustomData) " +
                        "VALUES (@CustomerGUID, @CharacterInventoryID, @ItemID, @InSlotNumber, @Quantity, @CustomData)",
                        insertParams,
                        transaction);
                }

                // Commit the transaction
                transaction.Commit();

                // Set result
                result.Success = true;
                result.ErrorMessage = string.Empty;
            }
            catch (Exception ex)
            {
                // Rollback the transaction on error
                transaction.Rollback();

                // Set result
                result.Success = false;
                result.ErrorMessage = ex.Message;
            }

            return result;
        }
    }
}
