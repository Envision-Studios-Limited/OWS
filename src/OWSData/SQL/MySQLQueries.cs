using System;
using System.Collections.Generic;
using System.Text;

namespace OWSData.SQL
{
    public static class MySQLQueries
    {

	    #region To Refactor

	    public static readonly string AddOrUpdateWorldServerSQL = @"call AddOrUpdateWorldServer(
            @CustomerGUID,
            @ZoneServerGUID,
            @ServerIP,
            @MaxNumberOfInstances,
            @InternalServerIP,
            @StartingMapInstancePort)";

	    public static readonly string GetAbilities = @"SELECT AB.*, AT.AbilityTypeName
				FROM Abilities AB
				INNER JOIN AbilityTypes AT 
					ON AT.AbilityTypeID=AB.AbilityTypeID
				WHERE AB.CustomerGUID=@CustomerGUID
				ORDER BY AB.AbilityName";

	    public static readonly string GetAccountSessionSQL = @"
		SELECT ASes.CustomerGUID, ASes.AccountID, ASes.AccountSessionGUID, ASes.LoginDate, ASes.SelectedCharacterName,
		       A.Email, A.AccountName, A.CreateDate, A.LastOnlineDate, A.Role,
		       C.CharacterID, C.CharacterName AS CharName, C.X, C.Y, C.Z, C.RX, C.RY, C.RZ, C.MapName AS ZoneName
		FROM AccountSessions ASes
		INNER JOIN AccountData A
		    ON A.AccountID = ASes.AccountID
		LEFT JOIN CharacterData C
		    ON C.CustomerGUID = ASes.CustomerGUID
		    AND C.CharacterName = ASes.SelectedCharacterName
		WHERE ASes.CustomerGUID = @CustomerGUID
		  AND ASes.AccountSessionGUID = @AccountSessionGUID";

	    public static readonly string GetAccountSessionOnlySQL = @"
		SELECT ASes.CustomerGUID, ASes.AccountID, ASes.AccountSessionGUID, ASes.LoginDate, ASes.SelectedCharacterName
		FROM AccountSessions ASes
		WHERE ASes.CustomerGUID = @CustomerGUID
		  AND ASes.AccountSessionGUID = @AccountSessionGUID";

	    public static readonly string GetAccountSQL = @"
		SELECT A.Email, A.AccountName, A.CreateDate, A.LastOnlineDate, A.Role
		FROM AccountData A
		WHERE A.CustomerGUID = @CustomerGUID
		  AND A.AccountID = @AccountID";

	    public static readonly string GetAccountFromEmailSQL = @"
		SELECT A.Email, A.AccountName, A.CreateDate, A.LastOnlineDate, A.Role
		FROM AccountData A
		WHERE A.CustomerGUID = @CustomerGUID
		  AND A.Email = @Email";

	    public static readonly string GetCharacterByNameSQL = @"
		SELECT C.CharacterID, C.CharacterName, C.X, C.Y, C.Z, C.RX, C.RY, C.RZ, C.MapName AS ZoneName
		FROM CharacterData C
		WHERE C.CustomerGUID = @CustomerGUID
		  AND C.CharacterName = @CharacterName";

		public static readonly string GetWorldServerSQL = @"SELECT WorldServerID
				FROM WorldServers 
				WHERE CustomerGUID=@CustomerGUID
				AND ZoneServerGUID=@ZoneServerGUID";

		public static readonly string UpdateNumberOfPlayersSQL = @"UPDATE MapInstances
				SET NumberOfReportedPlayers=@NumberOfReportedPlayers,
				LastUpdateFromServer=NOW(),
				LastServerEmptyDate=(CASE WHEN @NumberOfReportedPlayers = 0 AND NumberOfReportedPlayers > 0 THEN NOW() ELSE (CASE WHEN NumberOfReportedPlayers = 0 AND @NumberOfReportedPlayers > 0 THEN NULL ELSE LastServerEmptyDate END) END),
				Status=2
				WHERE CustomerGUID=@CustomerGUID
					AND MapInstanceID=@ZoneInstanceID";

		public static readonly string UpdateWorldServerSQL = @"UPDATE WorldServers
				SET ActiveStartTime=NOW(),
				ServerStatus=1
				WHERE CustomerGUID=@CustomerGUID
				AND WorldServerID=@WorldServerID";

		#endregion

		#region Character Queries

		public static readonly string AddAbilityToCharacter = @"
		INSERT INTO CharHasAbilities (CustomerGUID, CharacterID, AbilityID, AbilityLevel, CharHasAbilitiesCustomJSON)
		SELECT 
		    @CustomerGUID, 
		    (SELECT C.CharacterID 
		     FROM CharacterData C 
		     WHERE C.CharacterName = @CharacterName 
		       AND C.CustomerGUID = @CustomerGUID 
		     ORDER BY C.CharacterID LIMIT 1),
		    (SELECT A.AbilityID 
		     FROM Abilities A 
		     WHERE A.AbilityName = @AbilityName 
		       AND A.CustomerGUID = @CustomerGUID 
		     ORDER BY A.AbilityID LIMIT 1),
		    @AbilityLevel,
		    @CharHasAbilitiesCustomJSON";


		public static readonly string AddCharacterUsingDefaultCharacterValues = @"
		INSERT INTO CharacterData (
		    CustomerGUID, AccountID, CharacterName, MapName, X, Y, Z, RX, RY, RZ, 
		    Fishing, Mining, Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring, Hunting, 
		    Leatherworking, Farming, Herblore, Spirit, Magic, TeamNumber, Thirst, Hunger, Gold, 
		    Score, CharacterLevel, Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health, 
		    HealthRegenRate, MaxMana, Mana, ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, 
		    FatigueRegenRate, MaxStamina, Stamina, StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate, 
		    Strength, Dexterity, Constitution, Intellect, Wisdom, Charisma, Agility, Fortitude, Reflex, 
		    Willpower, BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed, CritChance, CritMultiplier, Haste, 
		    SpellPower, SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility, Multishot, Initiative, 
		    NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed, Range, Speed, 
		    Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, Description, DefaultPawnClassPath, 
		    IsInternalNetworkTestUser, ClassID, BaseMesh, IsAdmin, IsModerator, CreateDate
		)
		SELECT 
		    @CustomerGUID, @AccountID, @CharacterName, DCR.StartingMapName, DCR.X, DCR.Y, DCR.Z, DCR.RX, DCR.RY, DCR.RZ, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 100, 100, 
		    1, 100, 100, 1, 100, 100, 1, 100, 100, 
		    1, 100, 100, 1, 100, 100, 
		    10, 10, 10, 10, 10, 10, 10, 10, 10, 
		    10, 1, 1, 1, 1, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, '', '', 
		    FALSE, DCR.ClassID, '', FALSE, FALSE, NOW()
		FROM DefaultCharacterValues DCR 
		WHERE DCR.CustomerGUID = @CustomerGUID 
		  AND DCR.DefaultSetName = @DefaultSetName;
		SELECT LAST_INSERT_ID();";

		public static readonly string RemoveAbilityFromCharacter = @"
		DELETE FROM CharHasAbilities
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
		  );";

		public static readonly string RemoveCharactersFromAllInactiveInstances = @"
		DELETE FROM CharOnMapInstance
		WHERE CustomerGUID = @CustomerGUID
		  AND CharacterID IN (
		      SELECT C.CharacterID
		      FROM CharacterData C
		      INNER JOIN AccountData A 
		        ON A.CustomerGUID = C.CustomerGUID 
		       AND A.AccountID = C.AccountID
		      WHERE A.LastOnlineDate < DATE_SUB(NOW(), INTERVAL @CharacterMinutes MINUTE)
		        AND C.CustomerGUID = @CustomerGUID
		  );";

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
		      ORDER BY C.CharacterID LIMIT 1
		  )
		  AND AbilityID = (
		      SELECT A.AbilityID
		      FROM Abilities A
		      WHERE A.AbilityName = @AbilityName 
		        AND A.CustomerGUID = @CustomerGUID
		      ORDER BY A.AbilityID LIMIT 1
		  );";

		#endregion

		#region User Queries

		public static readonly string UpdateAccountLastOnlineDate = @"
		UPDATE AccountData
		SET LastOnlineDate = NOW()
		WHERE CustomerGUID = @CustomerGUID
		  AND AccountID IN (
		      SELECT C.AccountID
		      FROM CharacterData C
		      WHERE C.CustomerGUID = @CustomerGUID 
		        AND C.CharacterName = @CharacterName
		  );";

		#endregion

		#region Zone Queries

		public static readonly string AddMapInstance = @"INSERT INTO MapInstances (CustomerGUID, WorldServerID, MapID, Port, Status, PlayerGroupID, LastUpdateFromServer)
		VALUES (@CustomerGUID, @WorldServerID, @MapID, @Port, 1, @PlayerGroupID, NOW());
		SELECT LAST_INSERT_ID();";

		public static readonly string GetAllInactiveMapInstances = @"SELECT MapInstanceID
                FROM MapInstances
                WHERE LastUpdateFromServer < DATE_SUB(NOW(), INTERVAL @MapMinutes MINUTE) AND CustomerGUID = @CustomerGUID";

		public static readonly string GetMapInstancesByWorldServerID = @"SELECT MI.*, M.SoftPlayerCap, M.HardPlayerCap, M.MapName, M.MapMode, M.MinutesToShutdownAfterEmpty, 
				FLOOR(TIMESTAMPDIFF(MINUTE, MI.LastServerEmptyDate, NOW()))  AS MinutesServerHasBeenEmpty,
           		FLOOR(TIMESTAMPDIFF(MINUTE, MI.LastUpdateFromServer, NOW())) AS MinutesSinceLastUpdate
				FROM Maps M
				INNER JOIN MapInstances MI ON MI.MapID = M.MapID
				WHERE M.CustomerGUID = @CustomerGUID
				AND MI.WorldServerID = @WorldServerID";

        public static readonly string GetZoneInstancesByZoneAndGroup = @"SELECT WS.ServerIP AS ServerIP
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
				ORDER BY COUNT(DISTINCT CMI.CharacterID)
				LIMIT 1";

		#endregion
    }
}
