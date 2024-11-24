using System;
using System.Collections.Generic;
using System.Text;

namespace OWSData.SQL
{
    public static class MSSQLQueries
    {

	    #region To Refactor

        public static readonly string AddOrUpdateWorldServerSQL = @"MERGE WorldServers AS tbl
				USING (SELECT @CustomerGUID AS CustomerGUID, 
					@ServerIP AS ServerIP, 
					@MaxNumberOfInstances AS MaxNumberOfInstances,
					8081 as Port,
					0 as ServerStatus,
					@InternalServerIP as InternalServerIP,
					@StartingMapInstancePort as StartingMapInstancePort,
					@ZoneServerGUID as ZoneServerGUID) AS row
					ON tbl.CustomerGUID = Row.CustomerGUID AND tbl.ZoneServerGUID = row.ZoneServerGUID
				WHEN NOT MATCHED THEN
					INSERT(CustomerGUID, ServerIP, MaxNumberOfInstances, Port, ServerStatus, InternalServerIP, StartingMapInstancePort, ZoneServerGUID)
					VALUES(row.CustomerGUID, row.ServerIP, row.MaxNumberOfInstances, row.Port, row.ServerStatus, row.InternalServerIP, row.StartingMapInstancePort, row.ZoneServerGUID)
				WHEN MATCHED THEN
					UPDATE SET
					tbl.MaxNumberOfInstances = row.MaxNumberOfInstances,
					tbl.Port = row.Port,
					tbl.ServerStatus = row.ServerStatus,
					tbl.InternalServerIP = row.InternalServerIP,
					tbl.StartingMapInstancePort = row.StartingMapInstancePort,
					tbl.ZoneServerGUID = row.ZoneServerGUID;";

        public static readonly string GetAccountSessionSQL = @"
		SELECT 
		    US.CustomerGUID, 
		    US.AccountID, 
		    US.AccountSessionGUID, 
		    US.LoginDate, 
		    US.SelectedCharacterName,
		    A.Email, 
		    A.AccountName, 
		    A.CreateDate, 
		    A.LastOnlineDate, 
		    A.Role,
		    C.CharacterID, 
		    C.CharacterName, 
		    C.X, 
		    C.Y, 
		    C.Z, 
		    C.RX, 
		    C.RY, 
		    C.RZ, 
		    C.MapName as ZoneName
		FROM AccountSessions US
		INNER JOIN AccountData A
		    ON A.AccountID = US.AccountID
		LEFT JOIN CharacterData C
		    ON C.CustomerGUID = US.CustomerGUID
		    AND C.CharacterName = US.SelectedCharacterName
		WHERE US.CustomerGUID = @CustomerGUID
		  AND US.AccountSessionGUID = @AccountSessionGUID;";

        public static readonly string GetAccountSessionOnlySQL = @"
		SELECT 
		    US.CustomerGUID, 
		    US.AccountID, 
		    US.AccountSessionGUID, 
		    US.LoginDate, 
		    US.SelectedCharacterName
		FROM AccountSessions US
		WHERE US.CustomerGUID = @CustomerGUID
		  AND US.AccountSessionGUID = @AccountSessionGUID;";

        public static readonly string GetAccountSQL = @"
		SELECT 
		    A.Email, 
		    A.AccountName, 
		    A.CreateDate, 
		    A.LastOnlineDate, 
		    A.Role
		FROM AccountData A
		WHERE A.CustomerGUID = @CustomerGUID
		  AND A.AccountID = @AccountID;";

        public static readonly string GetAccountFromEmailSQL = @"
		SELECT 
		    A.Email, 
		    A.AccountName, 
		    A.CreateDate, 
		    A.LastOnlineDate, 
		    A.Role
		FROM AccountData A
		WHERE A.CustomerGUID = @CustomerGUID
		  AND A.Email = @Email;";

        public static readonly string GetCharacterByNameSQL = @"
		SELECT 
		    C.CharacterID, 
		    C.CharacterName AS CharName, 
		    C.X, 
		    C.Y, 
		    C.Z, 
		    C.RX, 
		    C.RY, 
		    C.RZ, 
		    C.MapName AS ZoneName
		FROM CharacterData C
		WHERE C.CustomerGUID = @CustomerGUID
		  AND C.CharacterName = @CharacterName;";

		public static readonly string GetWorldServerSQL = @"SELECT WorldServerID
				FROM WorldServers 
				WHERE CustomerGUID=@CustomerGUID 
				AND ZoneServerGUID=@ZoneServerGUID";

		public static readonly string UpdateNumberOfPlayersSQL = @"UPDATE MI
				SET NumberOfReportedPlayers=@NumberOfReportedPlayers,
				LastUpdateFromServer=GETDATE(),
				LastServerEmptyDate=(CASE WHEN @NumberOfReportedPlayers = 0 AND NumberOfReportedPlayers > 0 THEN GETDATE() ELSE (CASE WHEN NumberOfReportedPlayers = 0 AND @NumberOfReportedPlayers > 0 THEN NULL ELSE LastServerEmptyDate END) END),
				[Status]=2
				FROM MapInstances MI
				WHERE CustomerGUID=@CustomerGUID
					AND MapInstanceID=@ZoneInstanceID";

		public static readonly string UpdateWorldServerSQL = @"UPDATE WorldServers
				SET ActiveStartTime=GETDATE(),
				ServerStatus=1
				WHERE CustomerGUID=@CustomerGUID 
				AND WorldServerID=@WorldServerID";

		#endregion

		#region Character Queries

		public static readonly string AddAbilityToCharacter = @"
		INSERT INTO CharHasAbilities (CustomerGUID, CharacterID, AbilityID, AbilityLevel, CharHasAbilitiesCustomJSON)
		SELECT @CustomerGUID, 
		    (SELECT TOP 1 C.CharacterID 
		     FROM CharacterData C 
		     WHERE C.CharacterName = @CharacterName 
		     AND C.CustomerGUID = @CustomerGUID 
		     ORDER BY C.CharacterID),
		    (SELECT TOP 1 A.AbilityID 
		     FROM Abilities A 
		     WHERE A.AbilityName = @AbilityName 
		     AND A.CustomerGUID = @CustomerGUID 
		     ORDER BY A.AbilityID),
		    @AbilityLevel,
		    @CharHasAbilitiesCustomJSON";

		public static readonly string AddCharacterUsingDefaultCharacterValues = @"
		INSERT INTO CharacterData (
		    CustomerGUID, AccountID, CharacterName, MapName, X, Y, Z, RX, RY, RZ, Fishing, Mining, 
		    Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring, Hunting, Leatherworking, 
		    Farming, Herblore, Spirit, Magic, TeamNumber, Thirst, Hunger, Gold, Score, CharacterLevel, 
		    Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health, HealthRegenRate, MaxMana, Mana, 
		    ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, FatigueRegenRate, 
		    MaxStamina, Stamina, StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate, Strength, 
		    Dexterity, Constitution, Intellect, Wisdom, Charisma, Agility, Fortitude, Reflex, Willpower, 
		    BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed, CritChance, CritMultiplier, Haste, SpellPower, 
		    SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility, Multishot, Initiative, NaturalArmor, 
		    PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed, Range, Speed, Silver, 
		    Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, ServerIP, LastActivity, Description, 
		    DefaultPawnClassPath, IsInternalNetworkTestUser, ClassID, BaseMesh, IsAdmin, IsModerator, CreateDate
		)
		OUTPUT inserted.CharacterID
		SELECT 
		    @CustomerGUID, 
		    @UserGUID, 
		    @CharacterName, 
		    DCR.StartingMapName, 
		    DCR.X, 
		    DCR.Y, 
		    DCR.Z, 
		    DCR.RX, 
		    DCR.RY, 
		    DCR.RZ, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0
		FROM DefaultCharacterValues DCR
		WHERE DCR.CustomerGUID = @CustomerGUID 
		    AND DCR.DefaultSetName = @DefaultSetName;";

		public static readonly string RemoveAbilityFromCharacter = @"
		DELETE FROM CharHasAbilities
		WHERE CustomerGUID = @CustomerGUID
		  AND CharacterID = (SELECT C.CharacterID 
		                      FROM CharacterData C 
		                      WHERE C.CharacterName = @CharacterName 
		                        AND C.CustomerGUID = @CustomerGUID 
		                      LIMIT 1)
		  AND AbilityID = (SELECT A.AbilityID 
		                   FROM Abilities A 
		                   WHERE A.AbilityName = @AbilityName 
		                     AND A.CustomerGUID = @CustomerGUID 
		                   LIMIT 1)";

		public static readonly string RemoveCharactersFromAllInactiveInstances = @"
		DELETE FROM CharOnMapInstance
		WHERE CustomerGUID = @CustomerGUID
		  AND CharacterID IN (
		    SELECT C.CharacterID
		    FROM CharacterData C
		    INNER JOIN AccountData U ON U.CustomerGUID = C.CustomerGUID 
		                               AND U.AccountID = C.AccountID
		    WHERE U.LastAccess < CURRENT_TIMESTAMP - INTERVAL '@CharacterMinutes minute' 
		      AND C.CustomerGUID = @CustomerGUID
		  )";

		public static readonly string UpdateAbilityOnCharacter = @"
		UPDATE CharHasAbilities
		SET AbilityLevel = @AbilityLevel,
		    CharHasAbilitiesCustomJSON = @CharHasAbilitiesCustomJSON
		WHERE CustomerGUID = @CustomerGUID
		  AND CharacterID = (
		      SELECT C.CharacterID
		      FROM CharacterData C
		      WHERE C.CharacterName = @CharacterName 
		        AND C.CustomerGUID = @CustomerGUID
		      ORDER BY C.CharacterID
		      LIMIT 1
		  )
		  AND AbilityID = (
		      SELECT A.AbilityID
		      FROM Abilities A
		      WHERE A.AbilityName = @AbilityName 
		        AND A.CustomerGUID = @CustomerGUID
		      ORDER BY A.AbilityID
		      LIMIT 1
		  )";

		#endregion

		#region User Queries

		public static readonly string UpdateAccountLastOnlineDate = @"
		UPDATE AccountData
		SET LastOnlineDate = CURRENT_TIMESTAMP
		WHERE CustomerGUID = @CustomerGUID
		  AND UUID IN (
		      SELECT C.UUID
		      FROM CharacterData C
		      WHERE C.CustomerGUID = @CustomerGUID 
		        AND C.CharacterName = @CharName
		  )";

		#endregion

		#region Zone Queries

		public static readonly string AddMapInstance = @"INSERT INTO MapInstances (CustomerGUID, WorldServerID, MapID, Port, Status, PlayerGroupID, LastUpdateFromServer)
		OUTPUT inserted.MapInstanceID
		VALUES (@CustomerGUID, @WorldServerID, @MapID, @Port, 1, @PlayerGroupID, GETDATE())";

		public static readonly string GetAllInactiveMapInstances = @"SELECT MapInstanceID
                FROM MapInstances
                WHERE LastUpdateFromServer < DATEADD(minute, @MapMinutes, GETDATE()) AND CustomerGUID = @CustomerGUID";

		public static readonly string GetMapInstancesByWorldServerID = @"SELECT MI.*, M.SoftPlayerCap, M.HardPlayerCap, M.MapName, M.MapMode, M.MinutesToShutdownAfterEmpty, 
				DateDiff(minute, ISNULL(MI.LastServerEmptyDate, GETDATE()), GETDATE()) as MinutesServerHasBeenEmpty,
				DateDiff(minute, ISNULL(MI.LastUpdateFromServer, GETDATE()), GETDATE()) as MinutesSinceLastUpdate
				FROM Maps M
				INNER JOIN MapInstances MI ON MI.MapID = M.MapID
				WHERE M.CustomerGUID = @CustomerGUID
				AND MI.WorldServerID = @WorldServerID";

        public static readonly string GetZoneInstancesByZoneAndGroup = @"SELECT TOP 1
					  WS.ServerIP AS ServerIP
					, WS.InternalServerIP AS WorldServerIP
					, WS.Port AS WorldServerPort
					, MI.Port
     				, MI.MapInstanceID
     				, WS.WorldServerID
     				, MI.Status AS MapInstanceStatus
				FROM WorldServers WS
				LEFT JOIN MapInstances MI 
					ON MI.WorldServerID = WS.WorldServerID 
					AND MI.CustomerGUID = WS.CustomerGUID
				LEFT JOIN CharOnMapInstance CMI 
					ON CMI.MapInstanceID = MI.MapInstanceID 
					AND CMI.CustomerGUID = MI.CustomerGUID
				WHERE MI.MapID = @MapID
				AND WS.ActiveStartTime IS NOT NULL
				AND WS.CustomerGUID = @CustomerGUID
				AND MI.NumberOfReportedPlayers < @SoftPlayerCap 
				AND (MI.PlayerGroupID = @PlayerGroupID OR @PlayerGroupID = 0)
				AND MI.Status = 2
				GROUP BY MI.MapInstanceID, WS.ServerIP, MI.Port, WS.WorldServerID, WS.InternalServerIP, WS.Port, MI.Status
				ORDER BY COUNT(DISTINCT CMI.CharacterID)";

		#endregion

    }
}
