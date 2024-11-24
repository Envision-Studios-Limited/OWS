using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Npgsql;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;
using OWSData.Models;
using OWSData.Models.Composites;
using OWSData.Models.StoredProcs;
using OWSData.Models.Tables;
using OWSData.Repositories.Interfaces;
using OWSData.SQL;
using OWSShared.Options;

namespace OWSData.Repositories.Implementations.MSSQL
{
    public class AccountRepository : IAccountRepository
    {
        private readonly IOptions<StorageOptions> _storageOptions;

        public AccountRepository(IOptions<StorageOptions> storageOptions)
        {
            _storageOptions = storageOptions;
        }

        public IDbConnection Connection
        {
            get
            {
                return new SqlConnection(_storageOptions.Value.OWSDBConnectionString);
            }
        }

        public async Task<IEnumerable<GetAllCharacters>> GetAllCharacters(Guid customerGUID, Guid accountSessionGUID)
        {
            IEnumerable<GetAllCharacters> outputObject;

            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGUID);
                p.Add("@AccountSessionGUID", accountSessionGUID); // Updated parameter name

                outputObject = await Connection.QueryAsync<GetAllCharacters>(GenericQueries.GetAllCharacters,
                    p,
                    commandType: CommandType.Text);
            }

            return outputObject;
        }

        public async Task<CreateCharacter> CreateCharacter(Guid customerGUID, Guid accountSessionGUID, string characterName, string className)
        {
            CreateCharacter outputObject = new CreateCharacter();
    
            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@AccountSessionGUID", accountSessionGUID); // Corrected to match the updated table structure
                    p.Add("@CharacterName", characterName);
                    p.Add("@ClassName", className);

                    // Call the PostgreSQL function AddCharacter
                    outputObject = await Connection.QuerySingleAsync<CreateCharacter>(
                        "select * from AddCharacter(@CustomerGUID, @AccountSessionGUID, @CharacterName, @ClassName)",
                        p,
                        commandType: CommandType.Text);
                }

                outputObject.Success = String.IsNullOrEmpty(outputObject.ErrorMessage);

                return outputObject;
            }
            catch (Exception ex)
            {
                outputObject.Success = false;
                outputObject.ErrorMessage = ex.Message;

                return outputObject;
            }
        }

        public async Task<SuccessAndErrorMessage> CreateCharacterUsingDefaultCharacterValues(Guid customerGUID, Guid userGUID, string characterName, string defaultSetName)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            IDbConnection conn = Connection;
            conn.Open();
            using IDbTransaction transaction = conn.BeginTransaction();
            try
            {
                var parameters = new DynamicParameters();
                parameters.Add("CustomerGUID", customerGUID);
                parameters.Add("UserGUID", userGUID); // Keep using UserGUID as per MSSQLQueries
                parameters.Add("CharacterName", characterName);
                parameters.Add("DefaultSetName", defaultSetName);

                // Execute the MSSQL query to add character using default values
                int outputCharacterId = await Connection.QuerySingleOrDefaultAsync<int>(MSSQLQueries.AddCharacterUsingDefaultCharacterValues,
                    parameters,
                    commandType: CommandType.Text);

                // Add default custom character data (if needed, based on the use case)
                parameters.Add("CharacterID", outputCharacterId);
                await Connection.ExecuteAsync(GenericQueries.AddDefaultCustomCharacterData,
                    parameters,
                    commandType: CommandType.Text);

                // Commit the transaction
                transaction.Commit();
            }
            catch (Exception ex)
            {
                // Rollback the transaction in case of an error
                transaction.Rollback();
                outputObject = new SuccessAndErrorMessage()
                {
                    Success = false,
                    ErrorMessage = ex.Message
                };

                return outputObject;
            }

            // Success response
            outputObject = new SuccessAndErrorMessage()
            {
                Success = true,
                ErrorMessage = ""
            };

            return outputObject;
        }

        //_PlayerGroupTypeID 0 returns all group types
        public async Task<IEnumerable<GetPlayerGroupsCharacterIsIn>> GetPlayerGroupsCharacterIsIn(Guid customerGUID, Guid accountSessionGUID, string characterName, int playerGroupTypeID = 0)
        {
            IEnumerable<GetPlayerGroupsCharacterIsIn> OutputObject;

            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGUID);
                p.Add("@CharName", characterName);
                p.Add("@AccountSessionGUID", accountSessionGUID); // changed from UserSessionGUID to AccountSessionGUID
                p.Add("@PlayerGroupTypeID", playerGroupTypeID);

                OutputObject = await Connection.QueryAsync<GetPlayerGroupsCharacterIsIn>("select * from GetPlayerGroupsCharacterIsIn(@CustomerGUID,@CharName,@AccountSessionGUID,@PlayerGroupTypeID)",
                    p,
                    commandType: CommandType.Text);
            }

            return OutputObject;
        }

        public async Task<Account> GetAccount(Guid customerGuid, Guid accountId)
        {
            Account outputObject;

            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGuid);
                p.Add("@AccountID", accountId);

                outputObject = await Connection.QuerySingleOrDefaultAsync<Account>(
                    "select * from GetAccount(@CustomerGUID, @AccountID)",
                    p,
                    commandType: CommandType.Text);
            }

            return outputObject;
        }

        public async Task<IEnumerable<Account>> GetAccounts(Guid customerGuid)
        {
            IEnumerable<Account> outputObject = null;

            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGuid);

                outputObject = await Connection.QueryAsync<Account>(GenericQueries.GetAccounts, p);
            }

            return outputObject;
        }

        public async Task<GetAccountSession> GetAccountSession(Guid customerGUID, Guid accountSessionGUID)
        {
            GetAccountSession outputObject;

            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGUID);
                p.Add("@AccountSessionGUID", accountSessionGUID);

                outputObject = await Connection.QuerySingleOrDefaultAsync<GetAccountSession>("GetUserSession",
                    p,
                    commandType: CommandType.StoredProcedure);
            }

            return outputObject;
        }

        public async Task<GetAccountSession> GetAccountSessionORM(Guid customerGUID, Guid accountSessionGUID)
        {
            GetAccountSession outputObject;

            using (Connection)
            {
                outputObject = await Connection.QueryFirstOrDefaultAsync<GetAccountSession>(
                    MSSQLQueries.GetAccountSessionSQL,
                    new { CustomerGUID = customerGUID, UserSessionGUID = accountSessionGUID });
            }

            return outputObject;
        }

        public async Task<GetAccountSessionComposite> GetAccountSessionParallel(Guid customerGUID,
            Guid accountSessionGUID) //id = AccountSessionGUID
        {
            GetAccountSessionComposite outputObject = new GetAccountSessionComposite();
            AccountSession accountSession;
            Account account;
            Character character;

            using (Connection)
            {
                // Get the AccountSession data
                accountSession = await Connection.QueryFirstOrDefaultAsync<AccountSession>(
                    MSSQLQueries.GetAccountSessionOnlySQL,
                    new { CustomerGUID = customerGUID, AccountSessionGUID = accountSessionGUID });

                // Get the Account and Character data in parallel
                var accountTask = Connection.QueryFirstOrDefaultAsync<Account>(MSSQLQueries.GetAccountSQL,
                    new { CustomerGUID = customerGUID, AccountID = accountSession.AccountID });

                var characterTask = Connection.QueryFirstOrDefaultAsync<Character>(MSSQLQueries.GetCharacterByNameSQL,
                    new { CustomerGUID = customerGUID, CharacterName = accountSession.SelectedCharacterName });

                // Await the completion of both tasks
                account = await accountTask;
                character = await characterTask;
            }

            // Combine the data into the output object
            outputObject.AccountSession = accountSession;
            outputObject.Account = account;
            outputObject.Character = character;

            return outputObject;
        }

        public async Task<PlayerLoginAndCreateSession> LoginAndCreateSession(Guid customerGUID, string email, string password, bool dontCheckPassword = false)
        {
            PlayerLoginAndCreateSession outputObject;

            using (Connection)
            {
                var p = new DynamicParameters();
                p.Add("@CustomerGUID", customerGUID);
                p.Add("@Email", email);
                p.Add("@Password", password);
                p.Add("@DontCheckPassword", dontCheckPassword);

                outputObject = await Connection.QuerySingleOrDefaultAsync<PlayerLoginAndCreateSession>("PlayerLoginAndCreateSession",
                    p,
                    commandType: CommandType.StoredProcedure);
            }

            return outputObject;
        }

        public async Task<SuccessAndErrorMessage> Logout(Guid customerGuid, Guid accountSessionGuid)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGuid);
                    p.Add("@AccountSessionGUID", accountSessionGuid);  // Updated to match the query parameter name

                    // Executing the logout query to delete the session
                    await Connection.ExecuteAsync(GenericQueries.Logout, p, commandType: CommandType.Text);
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

        public async Task<SuccessAndErrorMessage> AccountSessionSetSelectedCharacter(Guid customerGUID, Guid accountSessionGUID, string selectedCharacterName)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@AccountSessionGUID", accountSessionGUID);  // Updated to match the procedure parameter name
                    p.Add("@SelectedCharacterName", selectedCharacterName);

                    // Calling the procedure with the updated name and parameters
                    await Connection.ExecuteAsync("call AccountSessionSetSelectedCharacter(@CustomerGUID, @AccountSessionGUID, @SelectedCharacterName)",
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

        public async Task<SuccessAndErrorMessage> RegisterAccount(Guid customerGUID, string email, string password, string accountName, string discord)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@Email", email);
                    p.Add("@Password", password);
                    p.Add("@AccountName", accountName); // Account name instead of first/last name
                    p.Add("@Role", "Player"); // Default role as "Player"
                    p.Add("@TosVersion", "1.0"); // Default ToS version, can be dynamic based on your logic
                    p.Add("@Discord", discord); // Discord as a parameter
                    p.Add("@LastClientIP", null); // Optional IP, can be passed if needed

                    // Calling the AddAccount function
                    await Connection.ExecuteAsync("select * from AddAccount(@CustomerGUID, @AccountName, @Email, @Password, @TosVersion, @Role, @Discord, @LastClientIP)",
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

        public async Task<GetAccountSession> GetAccountFromEmail(Guid customerGUID, string email)
        {
            GetAccountSession outputObject;

            using (Connection)
            {
                outputObject = await Connection.QueryFirstOrDefaultAsync<GetAccountSession>(
                    MSSQLQueries.GetAccountFromEmailSQL, 
                    new { @CustomerGUID = customerGUID, @Email = email });
            }

            return outputObject;
        }

        public async Task<SuccessAndErrorMessage> RemoveCharacter(Guid customerGUID, Guid accountSessionGUID, string characterName)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGUID);
                    p.Add("@AccountSessionGUID", accountSessionGUID); // Changed from UserSessionGUID to AccountSessionGUID to match the procedure
                    p.Add("@CharacterName", characterName);

                    // Calling the RemoveCharacter procedure
                    await Connection.ExecuteAsync("call RemoveCharacter(@CustomerGUID, @AccountSessionGUID, @CharacterName)",
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

        public async Task<SuccessAndErrorMessage> UpdateAccount(Guid customerGuid, Guid accountId, string accountName, string email)
        {
            SuccessAndErrorMessage outputObject = new SuccessAndErrorMessage();

            try
            {
                using (Connection)
                {
                    var p = new DynamicParameters();
                    p.Add("@CustomerGUID", customerGuid);
                    p.Add("@AccountID", accountId); // Changed from UserGUID to AccountID to align with the query
                    p.Add("@AccountName", accountName); // Changed from FirstName/LastName to AccountName
                    p.Add("@Email", email);

                    await Connection.ExecuteAsync(GenericQueries.UpdateAccount, 
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
    }
}
