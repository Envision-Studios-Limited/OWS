using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using OWSData.Models.Composites;
using OWSData.Models.StoredProcs;
using OWSData.Models.Tables;

namespace OWSData.Repositories.Interfaces
{
    public interface IAccountRepository
    {
        Task<CreateCharacter> CreateCharacter(Guid customerGUID, Guid accountSessionGUID, string characterName, string className);
        Task<SuccessAndErrorMessage> CreateCharacterUsingDefaultCharacterValues(Guid customerGUID, Guid accountID, string characterName, string defaultSetName);
        Task<IEnumerable<GetAllCharacters>> GetAllCharacters(Guid customerGUID, Guid accountSessionGUID);
        Task<IEnumerable<GetPlayerGroupsCharacterIsIn>> GetPlayerGroupsCharacterIsIn(Guid customerGUID, Guid accountSessionGUID, string characterName, int playerGroupTypeID = 0);
        Task<Account> GetAccount(Guid customerGuid, Guid accountId);
        Task<IEnumerable<Account>> GetAccounts(Guid customerGuid);
        Task<GetAccountSession> GetAccountSession(Guid customerGUID, Guid accountSessionGUID);
        Task<GetAccountSession> GetAccountSessionORM(Guid customerGUID, Guid accountSessionGUID);
        Task<GetAccountSessionComposite> GetAccountSessionParallel(Guid customerGUID, Guid accountSessionGUID);
        Task<PlayerLoginAndCreateSession> LoginAndCreateSession(Guid customerGUID, string email, string password, bool dontCheckPassword = false);
        Task<SuccessAndErrorMessage> Logout(Guid customerGuid, Guid accountSessionGuid);
        Task<SuccessAndErrorMessage> AccountSessionSetSelectedCharacter(Guid customerGUID, Guid accountSessionGUID, string selectedCharacterName);
        Task<SuccessAndErrorMessage> RegisterAccount(Guid customerGUID, string email, string password, string accountName, string discord);
        Task<GetAccountSession> GetAccountFromEmail(Guid customerGUID, string email);
        Task<SuccessAndErrorMessage> RemoveCharacter(Guid customerGUID, Guid accountSessionGUID, string characterName);
        Task<SuccessAndErrorMessage> UpdateAccount(Guid customerGuid, Guid accountId, string accountName, string email);
        
    }
}
