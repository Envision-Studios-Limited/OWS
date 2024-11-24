using System;
using System.Collections.Generic;
using System.Text;

namespace OWSData.SQL
{
    public static class PostgresQueries
    {
	    #region To Refactor

	    public static readonly string AddOrUpdateWorldServerSQL = @"INSERT INTO WorldServers (CustomerGUID, ServerIP, MaxNumberOfInstances, Port, ServerStatus, InternalServerIP,
                          StartingMapInstancePort, ZoneServerGUID)
    (SELECT @CustomerGUID::UUID           AS CustomerGUID,
            @ServerIP                     AS ServerIP,
            @MaxNumberOfInstances         AS MaxNumberOfInstances,
            8081                          AS Port,
            0                             AS ServerStatus,
            @InternalServerIP             AS InternalServerIP,
            @StartingMapInstancePort      AS StartingMapInstancePort,
            @ZoneServerGUID::UUID         AS ZoneServerGUID)
ON CONFLICT ON CONSTRAINT ak_zoneservers
    DO UPDATE SET MaxNumberOfInstances    = @MaxNumberOfInstances,
                  Port                    = 8081,
                  ServerStatus            = 0,
                  InternalServerIP        = @InternalServerIP,
                  StartingMapInstancePort = @StartingMapInstancePort,
                  ZoneServerGUID          = @ZoneServerGUID::UUID;";

	    public static readonly string GetAbilities = @"SELECT AB.*, AT.AbilityTypeName
				FROM Abilities AB
				INNER JOIN AbilityTypes AT 
					ON AT.AbilityTypeID=AB.AbilityTypeID
				WHERE AB.CustomerGUID=@CustomerGUID
				ORDER BY AB.AbilityName";

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
		    C.MapName AS ZoneName
		FROM AccountSessions US
		INNER JOIN AccountData A
		    ON A.AccountID = US.AccountID
		LEFT JOIN CharacterData C
		    ON C.CustomerGUID = US.CustomerGUID
		    AND C.CharacterName = US.SelectedCharacterName
		WHERE US.CustomerGUID = @CustomerGUID::UUID
		  AND US.AccountSessionGUID = @AccountSessionGUID::UUID";


	    public static readonly string GetAccountSessionOnlySQL = @"
		SELECT 
		    US.CustomerGUID, 
		    US.AccountID, 
		    US.AccountSessionGUID, 
		    US.LoginDate, 
		    US.SelectedCharacterName
		FROM AccountSessions US
		WHERE US.CustomerGUID = @CustomerGUID::UUID
		  AND US.AccountSessionGUID = @AccountSessionGUID::UUID";

	    public static readonly string GetAccountSQL = @"
		SELECT 
		    A.Email, 
		    A.AccountName, 
		    A.CreateDate, 
		    A.LastOnlineDate AS LastAccess, 
		    A.Role
		FROM AccountData A
		WHERE A.CustomerGUID = @CustomerGUID::UUID
		  AND A.AccountID = @AccountID";

	    public static readonly string GetAccountFromEmailSQL = @"
		SELECT 
		    A.Email, 
		    A.AccountName, 
		    A.CreateDate, 
		    A.LastOnlineDate AS LastAccess, 
		    A.Role
		FROM AccountData A
		WHERE A.CustomerGUID = @CustomerGUID::UUID
		  AND A.Email = @Email";

	    public static readonly string GetCharacterByNameSQL = @"
		SELECT 
		    C.CharacterID, 
		    C.CharacterName, 
		    C.X, 
		    C.Y, 
		    C.Z, 
		    C.RX, 
		    C.RY, 
		    C.RZ, 
		    C.MapName AS ZoneName
		FROM CharacterData C
		WHERE C.CustomerGUID = @CustomerGUID::UUID
		  AND C.CharacterName = @CharacterName";

		public static readonly string GetWorldServerSQL = @"SELECT WorldServerID
				FROM WorldServers 
				WHERE CustomerGUID=@CustomerGUID::UUID 
				AND ZoneServerGUID=@ZoneServerGUID::UUID";

		public static readonly string UpdateNumberOfPlayersSQL = @"UPDATE MapInstances
				SET NumberOfReportedPlayers = @NumberOfReportedPlayers,
				LastUpdateFromServer=NOW(),
				LastServerEmptyDate=(CASE WHEN @NumberOfReportedPlayers = 0 AND NumberOfReportedPlayers > 0 THEN NOW() ELSE (CASE WHEN NumberOfReportedPlayers = 0 AND @NumberOfReportedPlayers > 0 THEN NULL ELSE LastServerEmptyDate END) END),
				Status=2
				WHERE CustomerGUID=@CustomerGUID
					AND MapInstanceID=@ZoneInstanceID";

		public static readonly string UpdateWorldServerSQL = @"UPDATE WorldServers
				SET ActiveStartTime=NOW(),
				ServerStatus=1
				WHERE CustomerGUID=@CustomerGUID::UUID 
				AND WorldServerID=@WorldServerID";

		#endregion

		#region Character Queries

		public static readonly string AddAbilityToCharacter = @"
		INSERT INTO CharHasAbilities (
		    CustomerGUID, 
		    CharacterID, 
		    AbilityID, 
		    AbilityLevel, 
		    CharHasAbilitiesCustomJSON
		)
		SELECT 
		    @CustomerGUID::UUID, 
		    (
		        SELECT C.CharacterID 
		        FROM CharacterData C 
		        WHERE C.CharacterName = @CharacterName 
		          AND C.CustomerGUID = @CustomerGUID::UUID 
		        ORDER BY C.CharacterID 
		        LIMIT 1
		    ),
		    (
		        SELECT A.AbilityID 
		        FROM Abilities A 
		        WHERE A.AbilityName = @AbilityName 
		          AND A.CustomerGUID = @CustomerGUID::UUID 
		        ORDER BY A.AbilityID 
		        LIMIT 1
		    ),
		    @AbilityLevel,
		    @CharHasAbilitiesCustomJSON";


		public static readonly string AddCharacterUsingDefaultCharacterValues = @"
		INSERT INTO CharacterData (
		    CustomerGUID,
		    AccountID,
		    CharacterName,
		    MapName,
		    X,
		    Y,
		    Z,
		    RX,
		    RY,
		    RZ,
		    Fishing,
		    Mining,
		    Woodcutting,
		    Smelting,
		    Smithing,
		    Cooking,
		    Fletching,
		    Tailoring,
		    Hunting,
		    Leatherworking,
		    Farming,
		    Herblore,
		    Spirit,
		    Magic,
		    TeamNumber,
		    Thirst,
		    Hunger,
		    Gold,
		    Score,
		    CharacterLevel,
		    Gender,
		    XP,
		    HitDie,
		    Wounds,
		    Size,
		    Weight,
		    MaxHealth,
		    Health,
		    HealthRegenRate,
		    MaxMana,
		    Mana,
		    ManaRegenRate,
		    MaxEnergy,
		    Energy,
		    EnergyRegenRate,
		    MaxFatigue,
		    Fatigue,
		    FatigueRegenRate,
		    MaxStamina,
		    Stamina,
		    StaminaRegenRate,
		    MaxEndurance,
		    Endurance,
		    EnduranceRegenRate,
		    Strength,
		    Dexterity,
		    Constitution,
		    Intellect,
		    Wisdom,
		    Charisma,
		    Agility,
		    Fortitude,
		    Reflex,
		    Willpower,
		    BaseAttack,
		    BaseAttackBonus,
		    AttackPower,
		    AttackSpeed,
		    CritChance,
		    CritMultiplier,
		    Haste,
		    SpellPower,
		    SpellPenetration,
		    Defense,
		    Dodge,
		    Parry,
		    Avoidance,
		    Versatility,
		    Multishot,
		    Initiative,
		    NaturalArmor,
		    PhysicalArmor,
		    BonusArmor,
		    ForceArmor,
		    MagicArmor,
		    Resistance,
		    ReloadSpeed,
		    Range,
		    Speed,
		    Silver,
		    Copper,
		    FreeCurrency,
		    PremiumCurrency,
		    Fame,
		    Alignment,
		    Description,
		    DefaultPawnClassPath,
		    IsInternalNetworkTestUser,
		    ClassID,
		    BaseMesh,
		    IsAdmin,
		    IsModerator,
		    CreateDate
		)
		SELECT 
		    @CustomerGUID::UUID,
		    @AccountID::UUID,
		    @CharacterName,
		    DCR.StartingMapName,
		    DCR.X,
		    DCR.Y,
		    DCR.Z,
		    DCR.RX,
		    DCR.RY,
		    DCR.RZ,
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
		    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		    0, 0, 0, 0, '', '', FALSE, @ClassID, '', FALSE, FALSE, NOW()
		FROM DefaultCharacterValues DCR
		WHERE DCR.CustomerGUID = @CustomerGUID::UUID
		  AND DCR.DefaultSetName = @DefaultSetName
		RETURNING CharacterID";

		public static readonly string RemoveAbilityFromCharacter = @"
		DELETE FROM CharHasAbilities
		WHERE CustomerGUID = @CustomerGUID::UUID
		  AND CharacterID = (
		      SELECT C.CharacterID 
		      FROM CharacterData C 
		      WHERE C.CharacterName = @CharacterName 
		        AND C.CustomerGUID = @CustomerGUID::UUID 
		      ORDER BY C.CharacterID 
		      LIMIT 1
		  )
		  AND AbilityID = (
		      SELECT A.AbilityID 
		      FROM Abilities A 
		      WHERE A.AbilityName = @AbilityName 
		        AND A.CustomerGUID = @CustomerGUID::UUID 
		      ORDER BY A.AbilityID 
		      LIMIT 1
		  )";

		public static readonly string RemoveCharactersFromAllInactiveInstances = @"
		DELETE FROM CharOnMapInstance
		WHERE CustomerGUID = @CustomerGUID::UUID
		  AND CharacterID IN (
		      SELECT C.CharacterID
		      FROM CharacterData C
		      INNER JOIN AccountData A 
		          ON A.CustomerGUID = C.CustomerGUID 
		          AND A.AccountID = C.AccountID
		      WHERE A.LastOnlineDate < CURRENT_TIMESTAMP - (@CharacterMinutes || ' minutes')::INTERVAL
		        AND C.CustomerGUID = CharOnMapInstance.CustomerGUID
		  )";

		public static readonly string RemoveCharacterFromInstances = @"DELETE FROM CharOnMapInstance WHERE CustomerGUID = @CustomerGUID AND MapInstanceID = ANY(@MapInstances)";

		public static readonly string UpdateAbilityOnCharacter = @"
		UPDATE CharHasAbilities
		SET AbilityLevel = @AbilityLevel,
		    CharHasAbilitiesCustomJSON = @CharHasAbilitiesCustomJSON
		WHERE CustomerGUID = @CustomerGUID::UUID
		  AND CharacterID = (
		      SELECT C.CharacterID
		      FROM CharacterData C
		      WHERE C.CharacterName = @CharacterName
		        AND C.CustomerGUID = @CustomerGUID::UUID
		      ORDER BY C.CharacterID
		      LIMIT 1
		  )
		  AND AbilityID = (
		      SELECT A.AbilityID
		      FROM Abilities A
		      WHERE A.AbilityName = @AbilityName
		        AND A.CustomerGUID = @CustomerGUID::UUID
		      ORDER BY A.AbilityID
		      LIMIT 1
		  )";

		#endregion

		#region User Queries

		public static readonly string UpdateAccountLastOnlineDate = @"
		UPDATE AccountData
		SET LastOnlineDate = NOW()
		WHERE CustomerGUID = @CustomerGUID::UUID
		  AND AccountID IN (
		      SELECT C.AccountID
		      FROM CharacterData C
		      WHERE C.CustomerGUID = @CustomerGUID::UUID
		        AND C.CharacterName = @CharName
		  )";
		#endregion

		#region Zone Queries

		public static readonly string AddMapInstance = @"INSERT INTO MapInstances (CustomerGUID, WorldServerID, MapID, Port, Status, PlayerGroupID, LastUpdateFromServer)
		VALUES (@CustomerGUID, @WorldServerID, @MapID, @Port, 1, @PlayerGroupID, NOW())
		RETURNING mapinstanceid";

		public static readonly string GetAllInactiveMapInstances = @"SELECT MapInstanceID
                FROM MapInstances
                WHERE LastUpdateFromServer < CURRENT_TIMESTAMP - (@MapMinutes || ' minutes')::INTERVAL AND CustomerGUID = @CustomerGUID";

		public static readonly string GetMapInstancesByWorldServerID = @"SELECT MI.*, M.SoftPlayerCap, M.HardPlayerCap, M.MapName, M.MapMode, M.MinutesToShutdownAfterEmpty, 
		       FLOOR(EXTRACT(EPOCH FROM NOW()::TIMESTAMP - MI.LastServerEmptyDate) / 60)  AS MinutesServerHasBeenEmpty,
		       FLOOR(EXTRACT(EPOCH FROM NOW()::TIMESTAMP - MI.LastUpdateFromServer) / 60) AS MinutesSinceLastUpdate
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

		public static readonly string RemoveMapInstances = @"DELETE FROM MapInstances WHERE CustomerGUID = @CustomerGUID AND MapInstanceID = ANY(@MapInstances)";

		#endregion
	}
}
