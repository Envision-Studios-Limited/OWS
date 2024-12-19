CREATE DATABASE openworldserver;

\connect openworldserver;

CREATE EXTENSION pgcrypto;

CREATE TABLE DebugLog
(
    DebugLogID   SERIAL
        CONSTRAINT PK_DebugLogK
            PRIMARY KEY,
    DebugDate    TIMESTAMP,
    DebugDesc    TEXT,
    CustomerGUID UUID
);

CREATE TABLE Customers
(
    CustomerGUID       UUID        DEFAULT gen_random_uuid() NOT NULL
        CONSTRAINT PK_Customers
            PRIMARY KEY,
    CustomerName       VARCHAR(50)                           NOT NULL,
    CustomerEmail      VARCHAR(255)                          NOT NULL,
    CustomerPhone      VARCHAR(20),
    CustomerNotes      TEXT,
    EnableDebugLogging BOOLEAN         DEFAULT FALSE            NOT NULL,
    EnableAutoLoopBack BOOLEAN         DEFAULT TRUE            NOT NULL,
    DeveloperPaid      BOOLEAN         DEFAULT FALSE            NOT NULL,
    PublisherPaidDate  TIMESTAMP,
    StripeCustomerID   VARCHAR(50) DEFAULT ''                NOT NULL,
    FreeTrialStarted   TIMESTAMP,
    SupportUnicode     BOOLEAN         DEFAULT FALSE            NOT NULL,
    CreateDate         TIMESTAMP   DEFAULT NOW()             NOT NULL,
    NoPortForwarding   BOOLEAN         DEFAULT FALSE            NOT NULL
);

CREATE TABLE AbilityTypes
(
    AbilityTypeID   SERIAL,
    AbilityTypeName VARCHAR(50) NOT NULL,
    CustomerGUID    UUID        NOT NULL,
    CONSTRAINT PK_AbilityTypes
        PRIMARY KEY (AbilityTypeID, CustomerGUID)
);

CREATE TABLE Abilities
(
    CustomerGUID             UUID                    NOT NULL,
    AbilityID                SERIAL,
    AbilityName              VARCHAR(50)             NOT NULL,
    AbilityTypeID            INT                     NOT NULL,
    TextureToUseForIcon      VARCHAR(200) DEFAULT '' NOT NULL,
    Class                    INT,
    Race                     INT,
    AbilityCustomJSON        TEXT,
    GameplayAbilityClassName VARCHAR(200) DEFAULT '' NOT NULL,
    CONSTRAINT PK_Abilities
        PRIMARY KEY (CustomerGUID, AbilityID),
    CONSTRAINT FK_Abilities_AbilityTypes
        FOREIGN KEY (CustomerGUID, AbilityTypeID) REFERENCES AbilityTypes (CustomerGUID, AbilityTypeID)
);

CREATE TABLE AreaOfInterestTypes
(
    AreaOfInterestTypeID   SERIAL
        CONSTRAINT PK_AreaOfInterestTypes
            PRIMARY KEY,
    AreaOfInterestTypeDesc VARCHAR(50) NOT NULL
);

CREATE TABLE AreasOfInterest
(
    CustomerGUID        UUID        NOT NULL,
    AreasOfInterestGUID UUID        NOT NULL,
    MapZoneID           INT         NOT NULL,
    AreaOfInterestName  VARCHAR(50) NOT NULL,
    Radius              FLOAT       NOT NULL,
    AreaOfInterestType  INT         NOT NULL,
    X                   FLOAT,
    Y                   FLOAT,
    Z                   FLOAT,
    RX                  FLOAT,
    RY                  FLOAT,
    RZ                  FLOAT,
    CustomData          TEXT,
    CONSTRAINT PK_AreasOfInterest
        PRIMARY KEY (CustomerGUID, AreasOfInterestGUID)
);

CREATE TABLE AccountData
(
    AccountID               UUID      DEFAULT gen_random_uuid() NOT NULL
        CONSTRAINT PK_AccountData
            PRIMARY KEY,
    CustomerGUID            UUID                                NOT NULL,
    UUID                    UUID      DEFAULT gen_random_uuid() NOT NULL,
    AccountName             VARCHAR(100)                        NOT NULL,
    PasswordHash            VARCHAR(128)                        NOT NULL,
    Email                   VARCHAR(255)                        NOT NULL,
    Discord                 VARCHAR(50),
    CreateDate              TIMESTAMP DEFAULT NOW()             NOT NULL,
    TosVersion              VARCHAR(50)                         NOT NULL,
    TosVersionAcceptDate    TIMESTAMP    DEFAULT NOW()          NOT NULL,
    LastOnlineDate          TIMESTAMP DEFAULT NOW()             NOT NULL,
    LastClientIP            INET,
    Role                    VARCHAR(10)                         NOT NULL,
    CONSTRAINT AK_AccountData
        UNIQUE (CustomerGUID, Email, Role)
);

CREATE TABLE CharacterData
(
    CustomerGUID              UUID                        NOT NULL,
    CharacterID               SERIAL                      NOT NULL,
    AccountID                 UUID                        NULL,
    CharacterName             VARCHAR(50)                 NOT NULL,
    MapName                   VARCHAR(50)                 NULL,
    X                         FLOAT                       NOT NULL,
    Y                         FLOAT                       NOT NULL,
    Z                         FLOAT                       NOT NULL,
    RX                        FLOAT        DEFAULT 0      NOT NULL,
    RY                        FLOAT        DEFAULT 0      NOT NULL,
    RZ                        FLOAT        DEFAULT 0      NOT NULL,
    Fishing                   FLOAT        DEFAULT 0      NOT NULL,
    Mining                    FLOAT        DEFAULT 0      NOT NULL,
    Woodcutting               FLOAT        DEFAULT 0      NOT NULL,
    Smelting                  FLOAT        DEFAULT 0      NOT NULL,
    Smithing                  FLOAT        DEFAULT 0      NOT NULL,
    Cooking                   FLOAT        DEFAULT 0      NOT NULL,
    Fletching                 FLOAT        DEFAULT 0      NOT NULL,
    Tailoring                 FLOAT        DEFAULT 0      NOT NULL,
    Hunting                   FLOAT        DEFAULT 0      NOT NULL,
    Leatherworking            FLOAT        DEFAULT 0      NOT NULL,
    Farming                   FLOAT        DEFAULT 0      NOT NULL,
    Herblore                  FLOAT        DEFAULT 0      NOT NULL,
    Spirit                    FLOAT        DEFAULT 0      NOT NULL,
    Magic                     FLOAT        DEFAULT 0      NOT NULL,
    TeamNumber                INT          DEFAULT 0      NOT NULL,
    Thirst                    FLOAT        DEFAULT 0      NOT NULL,
    Hunger                    FLOAT        DEFAULT 0      NOT NULL,
    Gold                      INT          DEFAULT 0      NOT NULL,
    Score                     INT          DEFAULT 0      NOT NULL,
    CharacterLevel            SMALLINT     DEFAULT 0      NOT NULL,
    Gender                    SMALLINT     DEFAULT 0      NOT NULL,
    XP                        INT          DEFAULT 0      NOT NULL,
    HitDie                    SMALLINT     DEFAULT 0      NOT NULL,
    Wounds                    FLOAT        DEFAULT 0      NOT NULL,
    Size                      SMALLINT     DEFAULT 0      NOT NULL,
    Weight                    FLOAT        DEFAULT 0      NOT NULL,
    MaxHealth                 FLOAT        DEFAULT 0      NOT NULL,
    Health                    FLOAT        DEFAULT 0      NOT NULL,
    HealthRegenRate           FLOAT        DEFAULT 0      NOT NULL,
    MaxMana                   FLOAT        DEFAULT 0      NOT NULL,
    Mana                      FLOAT        DEFAULT 0      NOT NULL,
    ManaRegenRate             FLOAT        DEFAULT 0      NOT NULL,
    MaxEnergy                 FLOAT        DEFAULT 0      NOT NULL,
    Energy                    FLOAT        DEFAULT 0      NOT NULL,
    EnergyRegenRate           FLOAT        DEFAULT 0      NOT NULL,
    MaxFatigue                FLOAT        DEFAULT 0      NOT NULL,
    Fatigue                   FLOAT        DEFAULT 0      NOT NULL,
    FatigueRegenRate          FLOAT        DEFAULT 0      NOT NULL,
    MaxStamina                FLOAT        DEFAULT 0      NOT NULL,
    Stamina                   FLOAT        DEFAULT 0      NOT NULL,
    StaminaRegenRate          FLOAT        DEFAULT 0      NOT NULL,
    MaxEndurance              FLOAT        DEFAULT 0      NOT NULL,
    Endurance                 FLOAT        DEFAULT 0      NOT NULL,
    EnduranceRegenRate        FLOAT        DEFAULT 0      NOT NULL,
    Strength                  FLOAT        DEFAULT 0      NOT NULL,
    Dexterity                 FLOAT        DEFAULT 0      NOT NULL,
    Constitution              FLOAT        DEFAULT 0      NOT NULL,
    Intellect                 FLOAT        DEFAULT 0      NOT NULL,
    Wisdom                    FLOAT        DEFAULT 0      NOT NULL,
    Charisma                  FLOAT        DEFAULT 0      NOT NULL,
    Agility                   FLOAT        DEFAULT 0      NOT NULL,
    Fortitude                 FLOAT        DEFAULT 0      NOT NULL,
    Reflex                    FLOAT        DEFAULT 0      NOT NULL,
    Willpower                 FLOAT        DEFAULT 0      NOT NULL,
    BaseAttack                FLOAT        DEFAULT 0      NOT NULL,
    BaseAttackBonus           FLOAT        DEFAULT 0      NOT NULL,
    AttackPower               FLOAT        DEFAULT 0      NOT NULL,
    AttackSpeed               FLOAT        DEFAULT 0      NOT NULL,
    CritChance                FLOAT        DEFAULT 0      NOT NULL,
    CritMultiplier            FLOAT        DEFAULT 0      NOT NULL,
    Haste                     FLOAT        DEFAULT 0      NOT NULL,
    SpellPower                FLOAT        DEFAULT 0      NOT NULL,
    SpellPenetration          FLOAT        DEFAULT 0      NOT NULL,
    Defense                   FLOAT        DEFAULT 0      NOT NULL,
    Dodge                     FLOAT        DEFAULT 0      NOT NULL,
    Parry                     FLOAT        DEFAULT 0      NOT NULL,
    Avoidance                 FLOAT        DEFAULT 0      NOT NULL,
    Versatility               FLOAT        DEFAULT 0      NOT NULL,
    Multishot                 FLOAT        DEFAULT 0      NOT NULL,
    Initiative                FLOAT        DEFAULT 0      NOT NULL,
    NaturalArmor              FLOAT        DEFAULT 0      NOT NULL,
    PhysicalArmor             FLOAT        DEFAULT 0      NOT NULL,
    BonusArmor                FLOAT        DEFAULT 0      NOT NULL,
    ForceArmor                FLOAT        DEFAULT 0      NOT NULL,
    MagicArmor                FLOAT        DEFAULT 0      NOT NULL,
    Resistance                FLOAT        DEFAULT 0      NOT NULL,
    ReloadSpeed               FLOAT        DEFAULT 0      NOT NULL,
    Range                     FLOAT        DEFAULT 0      NOT NULL,
    Speed                     FLOAT        DEFAULT 0      NOT NULL,
    Silver                    INT          DEFAULT 0      NOT NULL,
    Copper                    INT          DEFAULT 0      NOT NULL,
    FreeCurrency              INT          DEFAULT 0      NOT NULL,
    PremiumCurrency           INT          DEFAULT 0      NOT NULL,
    Fame                      FLOAT        DEFAULT 0      NOT NULL,
    Alignment                 FLOAT        DEFAULT 0      NOT NULL,
    ServerIP                  VARCHAR(50)                 NULL,
    LastActivity              TIMESTAMP    DEFAULT NOW()  NOT NULL,
    Description               TEXT                        NULL,
    DefaultPawnClassPath      VARCHAR(200) DEFAULT ''     NOT NULL,
    IsInternalNetworkTestUser BOOLEAN          DEFAULT FALSE NOT NULL,
    ClassID                   INT                         NOT NULL,
    BaseMesh                  VARCHAR(100)                NULL,
    IsAdmin                   BOOLEAN          DEFAULT FALSE NOT NULL,
    IsModerator               BOOLEAN          DEFAULT FALSE NOT NULL,
    CreateDate                TIMESTAMP    DEFAULT NOW()  NOT NULL,
    CONSTRAINT PK_Chars
        PRIMARY KEY (CustomerGUID, CharacterID),
    CONSTRAINT FK_Characters_AccountID
        FOREIGN KEY (AccountID) REFERENCES AccountData (AccountID)
);

CREATE TABLE CharHasAbilities
(
    CustomerGUID               UUID          NOT NULL,
    CharHasAbilitiesID         SERIAL        NOT NULL,
    CharacterID                INT           NOT NULL,
    AbilityID                  INT           NOT NULL,
    AbilityLevel               INT DEFAULT 1 NOT NULL,
    CharHasAbilitiesCustomJSON TEXT          NULL,
    CONSTRAINT PK_CharHasAbilities
        PRIMARY KEY (CustomerGUID, CharHasAbilitiesID),
    CONSTRAINT FK_CharHasAbilities_CharacterID
        FOREIGN KEY (CustomerGUID, CharacterID) REFERENCES CharacterData (CustomerGUID, CharacterID)
);

CREATE TABLE CharAbilityBars
(
    CustomerGUID              UUID                   NOT NULL,
    CharAbilityBarID          SERIAL                 NOT NULL,
    CharacterID               INT                    NOT NULL,
    AbilityBarName            VARCHAR(50) DEFAULT '' NOT NULL,
    CharAbilityBarsCustomJSON TEXT                   NULL,
    MaxNumberOfSlots          INT         DEFAULT 1  NOT NULL,
    NumberOfUnlockedSlots     INT         DEFAULT 1  NOT NULL,
    CONSTRAINT PK_CharAbilityBars
        PRIMARY KEY (CustomerGUID, CharAbilityBarID)
);

CREATE TABLE CharAbilityBarAbilities
(
    CustomerGUID                      UUID          NOT NULL,
    CharAbilityBarAbilityID           SERIAL        NOT NULL,
    CharAbilityBarID                  INT           NOT NULL,
    CharHasAbilitiesID                INT           NOT NULL,
    CharAbilityBarAbilitiesCustomJSON TEXT          NULL,
    InSlotNumber                      INT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_CharAbilityBarAbilities
        PRIMARY KEY (CustomerGUID, CharAbilityBarAbilityID),
    CONSTRAINT FK_CharAbilityBarAbilities_CharAbilityBarID
        FOREIGN KEY (CustomerGUID, CharAbilityBarID) REFERENCES CharAbilityBars (CustomerGUID, CharAbilityBarID),
    CONSTRAINT FK_CharAbilityBarAbilities_CharHasAbilities
        FOREIGN KEY (CustomerGUID, CharHasAbilitiesID) REFERENCES CharHasAbilities (CustomerGUID, CharHasAbilitiesID)
);

CREATE TABLE CharHasItems
(
    CustomerGUID  UUID               NOT NULL,
    CharacterID   INT                NOT NULL,
    CharHasItemID SERIAL             NOT NULL,
    ItemID        INT                NOT NULL,
    Quantity      INT DEFAULT 1      NOT NULL,
    Equipped      BOOLEAN DEFAULT FALSE NOT NULL,
    CONSTRAINT PK_CharHasItems
        PRIMARY KEY (CustomerGUID, CharacterID, CharHasItemID),
    CONSTRAINT FK_CharHasItems_CharacterID
        FOREIGN KEY (CustomerGUID, CharacterID) REFERENCES CharacterData (CustomerGUID, CharacterID)
);

CREATE TABLE CharInventory
(
    CustomerGUID    UUID          NOT NULL,
    CharacterID     INT           NOT NULL,
    CharInventoryID SERIAL        NOT NULL,
    InventoryName   VARCHAR(50)   NOT NULL,
    InventorySize   INT           NOT NULL,
    InventoryWidth  INT DEFAULT 1 NOT NULL,
    InventoryHeight INT DEFAULT 1 NOT NULL,
    CONSTRAINT PK_CharInventory
        PRIMARY KEY (CustomerGUID, CharacterID, CharInventoryID)
);

CREATE TABLE CharInventoryItems
(
    CustomerGUID          UUID                           NOT NULL,
    CharInventoryID       INT                            NOT NULL,
    CharInventoryItemID   SERIAL                         NOT NULL,
    ItemID                INT                            NOT NULL,
    InSlotNumber          INT                            NOT NULL,
    Quantity              INT                            NOT NULL,
    NumberOfUsesLeft      INT  DEFAULT 0                 NOT NULL,
    CharInventoryItemGUID UUID DEFAULT gen_random_uuid() NOT NULL,
    CustomData            TEXT                           NULL,
    CONSTRAINT PK_CharInventoryItems
        PRIMARY KEY (CustomerGUID, CharInventoryID, CharInventoryItemID)
);

CREATE TABLE CharOnMapInstance
(
    CustomerGUID  UUID NOT NULL,
    CharacterID   INT  NOT NULL,
    MapInstanceID INT  NOT NULL,
    CONSTRAINT PK_CharOnMapInstance
        PRIMARY KEY (CustomerGUID, CharacterID, MapInstanceID)
);

CREATE TABLE ChatGroups
(
    CustomerGUID  UUID        NOT NULL,
    ChatGroupID   SERIAL      NOT NULL,
    ChatGroupName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ChatGroups
        PRIMARY KEY (CustomerGUID, ChatGroupID)
);

CREATE TABLE ChatGroupAccountData
(
    CustomerGUID UUID NOT NULL,
    ChatGroupID  INT  NOT NULL,
    CharacterID  INT  NOT NULL,
    CONSTRAINT PK_ChatGroupAccountData
        PRIMARY KEY (CustomerGUID, ChatGroupID, CharacterID)
);

CREATE TABLE ChatMessages
(
    CustomerGUID  UUID                    NOT NULL,
    ChatMessageID SERIAL                  NOT NULL,
    SentByCharID  INT                     NOT NULL,
    SentToCharID  INT                     NULL,
    ChatGroupID   INT                     NULL,
    ChatMessage   TEXT                    NOT NULL,
    MessageDate   TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT PK_ChatMessages
        PRIMARY KEY (CustomerGUID, ChatMessageID)
);

CREATE TABLE Class
(
    CustomerGUID              UUID                        NOT NULL,
    ClassID                   SERIAL                      NOT NULL,
    ClassName                 VARCHAR(50) DEFAULT ''      NOT NULL,
    StartingMapName           VARCHAR(50)                 NOT NULL,
    X                         FLOAT                       NOT NULL,
    Y                         FLOAT                       NOT NULL,
    Z                         FLOAT                       NOT NULL,
    RX                        FLOAT        DEFAULT 0      NOT NULL,
    RY                        FLOAT        DEFAULT 0      NOT NULL,
    RZ                        FLOAT        DEFAULT 0      NOT NULL,
    Fishing                   FLOAT        DEFAULT 0      NOT NULL,
    Mining                    FLOAT        DEFAULT 0      NOT NULL,
    Woodcutting               FLOAT        DEFAULT 0      NOT NULL,
    Smelting                  FLOAT        DEFAULT 0      NOT NULL,
    Smithing                  FLOAT        DEFAULT 0      NOT NULL,
    Cooking                   FLOAT        DEFAULT 0      NOT NULL,
    Fletching                 FLOAT        DEFAULT 0      NOT NULL,
    Tailoring                 FLOAT        DEFAULT 0      NOT NULL,
    Hunting                   FLOAT        DEFAULT 0      NOT NULL,
    Leatherworking            FLOAT        DEFAULT 0      NOT NULL,
    Farming                   FLOAT        DEFAULT 0      NOT NULL,
    Herblore                  FLOAT        DEFAULT 0      NOT NULL,
    Spirit                    FLOAT        DEFAULT 0      NOT NULL,
    Magic                     FLOAT        DEFAULT 0      NOT NULL,
    TeamNumber                INT          DEFAULT 0      NOT NULL,
    Thirst                    FLOAT        DEFAULT 0      NOT NULL,
    Hunger                    FLOAT        DEFAULT 0      NOT NULL,
    Gold                      INT          DEFAULT 0      NOT NULL,
    Score                     INT          DEFAULT 0      NOT NULL,
    CharacterLevel            SMALLINT     DEFAULT 0      NOT NULL,
    Gender                    SMALLINT     DEFAULT 0      NOT NULL,
    XP                        INT          DEFAULT 0      NOT NULL,
    HitDie                    SMALLINT     DEFAULT 0      NOT NULL,
    Wounds                    FLOAT        DEFAULT 0      NOT NULL,
    Size                      SMALLINT     DEFAULT 0      NOT NULL,
    Weight                    FLOAT        DEFAULT 0      NOT NULL,
    MaxHealth                 FLOAT        DEFAULT 0      NOT NULL,
    Health                    FLOAT        DEFAULT 0      NOT NULL,
    HealthRegenRate           FLOAT        DEFAULT 0      NOT NULL,
    MaxMana                   FLOAT        DEFAULT 0      NOT NULL,
    Mana                      FLOAT        DEFAULT 0      NOT NULL,
    ManaRegenRate             FLOAT        DEFAULT 0      NOT NULL,
    MaxEnergy                 FLOAT        DEFAULT 0      NOT NULL,
    Energy                    FLOAT        DEFAULT 0      NOT NULL,
    EnergyRegenRate           FLOAT        DEFAULT 0      NOT NULL,
    MaxFatigue                FLOAT        DEFAULT 0      NOT NULL,
    Fatigue                   FLOAT        DEFAULT 0      NOT NULL,
    FatigueRegenRate          FLOAT        DEFAULT 0      NOT NULL,
    MaxStamina                FLOAT        DEFAULT 0      NOT NULL,
    Stamina                   FLOAT        DEFAULT 0      NOT NULL,
    StaminaRegenRate          FLOAT        DEFAULT 0      NOT NULL,
    MaxEndurance              FLOAT        DEFAULT 0      NOT NULL,
    Endurance                 FLOAT        DEFAULT 0      NOT NULL,
    EnduranceRegenRate        FLOAT        DEFAULT 0      NOT NULL,
    Strength                  FLOAT        DEFAULT 0      NOT NULL,
    Dexterity                 FLOAT        DEFAULT 0      NOT NULL,
    Constitution              FLOAT        DEFAULT 0      NOT NULL,
    Intellect                 FLOAT        DEFAULT 0      NOT NULL,
    Wisdom                    FLOAT        DEFAULT 0      NOT NULL,
    Charisma                  FLOAT        DEFAULT 0      NOT NULL,
    Agility                   FLOAT        DEFAULT 0      NOT NULL,
    Fortitude                 FLOAT        DEFAULT 0      NOT NULL,
    Reflex                    FLOAT        DEFAULT 0      NOT NULL,
    Willpower                 FLOAT        DEFAULT 0      NOT NULL,
    BaseAttack                FLOAT        DEFAULT 0      NOT NULL,
    BaseAttackBonus           FLOAT        DEFAULT 0      NOT NULL,
    AttackPower               FLOAT        DEFAULT 0      NOT NULL,
    AttackSpeed               FLOAT        DEFAULT 0      NOT NULL,
    CritChance                FLOAT        DEFAULT 0      NOT NULL,
    CritMultiplier            FLOAT        DEFAULT 0      NOT NULL,
    Haste                     FLOAT        DEFAULT 0      NOT NULL,
    SpellPower                FLOAT        DEFAULT 0      NOT NULL,
    SpellPenetration          FLOAT        DEFAULT 0      NOT NULL,
    Defense                   FLOAT        DEFAULT 0      NOT NULL,
    Dodge                     FLOAT        DEFAULT 0      NOT NULL,
    Parry                     FLOAT        DEFAULT 0      NOT NULL,
    Avoidance                 FLOAT        DEFAULT 0      NOT NULL,
    Versatility               FLOAT        DEFAULT 0      NOT NULL,
    Multishot                 FLOAT        DEFAULT 0      NOT NULL,
    Initiative                FLOAT        DEFAULT 0      NOT NULL,
    NaturalArmor              FLOAT        DEFAULT 0      NOT NULL,
    PhysicalArmor             FLOAT        DEFAULT 0      NOT NULL,
    BonusArmor                FLOAT        DEFAULT 0      NOT NULL,
    ForceArmor                FLOAT        DEFAULT 0      NOT NULL,
    MagicArmor                FLOAT        DEFAULT 0      NOT NULL,
    Resistance                FLOAT        DEFAULT 0      NOT NULL,
    ReloadSpeed               FLOAT        DEFAULT 0      NOT NULL,
    Range                     FLOAT        DEFAULT 0      NOT NULL,
    Speed                     FLOAT        DEFAULT 0      NOT NULL,
    Silver                    INT          DEFAULT 0      NOT NULL,
    Copper                    INT          DEFAULT 0      NOT NULL,
    FreeCurrency              INT          DEFAULT 0      NOT NULL,
    PremiumCurrency           INT          DEFAULT 0      NOT NULL,
    Fame                      FLOAT        DEFAULT 0      NOT NULL,
    Alignment                 FLOAT        DEFAULT 0      NOT NULL,
    Description               TEXT                        NULL,
    CONSTRAINT PK_Class
        PRIMARY KEY (CustomerGUID, ClassID)
);

CREATE TABLE ClassInventory
(
    ClassInventoryID SERIAL      NOT NULL,
    CustomerGUID     UUID        NOT NULL,
    ClassID          INT         NOT NULL,
    InventoryName    VARCHAR(50) NOT NULL,
    InventorySize    INT         NOT NULL,
    InventoryWidth   INT         NOT NULL,
    InventoryHeight  INT         NOT NULL,
    CONSTRAINT PK_ClassInventory
        PRIMARY KEY (ClassInventoryID)
);

CREATE TABLE CustomCharacterData
(
    CustomerGUID          UUID        NOT NULL,
    CustomCharacterDataID SERIAL      NOT NULL,
    CharacterID           INT         NOT NULL,
    CustomFieldName       VARCHAR(50) NOT NULL,
    FieldValue            TEXT        NOT NULL,
    CONSTRAINT PK_CustomCharacterData
        PRIMARY KEY (CustomerGUID, CustomCharacterDataID),
    CONSTRAINT FK_CustomCharacterData_CharID
        FOREIGN KEY (CustomerGUID, CharacterID) REFERENCES CharacterData (CustomerGUID, CharacterID)
);

CREATE TABLE DefaultCharacterValues
(
    CustomerGUID              UUID                       NOT NULL,
    DefaultCharacterValuesID  SERIAL                     NOT NULL,
    DefaultSetName            VARCHAR(50)                NOT NULL,
    StartingMapName           VARCHAR(50)                NOT NULL,
    X                         FLOAT                      NOT NULL,
    Y                         FLOAT                      NOT NULL,
    Z                         FLOAT                      NOT NULL,
    RX                        FLOAT        DEFAULT 0     NOT NULL,
    RY                        FLOAT        DEFAULT 0     NOT NULL,
    RZ                        FLOAT        DEFAULT 0     NOT NULL,
    CONSTRAINT PK_DefaultCharacterValues
        PRIMARY KEY (DefaultCharacterValuesID, CustomerGUID)
);


CREATE TABLE DefaultCustomCharacterData
(
    CustomerGUID                 UUID                       NOT NULL,
    DefaultCustomCharacterDataID SERIAL                     NOT NULL,
    DefaultCharacterValuesID     INT                        NOT NULL,
    CustomFieldName              VARCHAR(50)                NOT NULL,
    FieldValue                   TEXT                       NOT NULL,
    CONSTRAINT PK_DefaultCustomCharacterData
        PRIMARY KEY (DefaultCustomCharacterDataID, CustomerGUID),
    CONSTRAINT FK_DefaultCustomCharacterData_DefaultCharacterValueID
        FOREIGN KEY (DefaultCharacterValuesID, CustomerGUID) REFERENCES DefaultCharacterValues (DefaultCharacterValuesID, CustomerGUID)
);

CREATE TABLE GlobalData
(
    CustomerGUID    UUID        NOT NULL,
    GlobalDataKey   VARCHAR(50) NOT NULL,
    GlobalDataValue TEXT        NOT NULL,
    CONSTRAINT PK_GlobalData
        PRIMARY KEY (CustomerGUID, GlobalDataKey)
);

CREATE TABLE Items
(
    CustomerGUID            UUID                        NOT NULL,
    ItemID                  SERIAL                      NOT NULL,
    ItemName                VARCHAR(50)                 NOT NULL,
    DisplayName             VARCHAR(50)                 NOT NULL,
    DefaultVisualIdentity   VARCHAR(50)                 NOT NULL,
    ItemWeight              DECIMAL(18, 2)   DEFAULT 0   NOT NULL,
    ItemCanStack            BOOLEAN          DEFAULT FALSE NOT NULL,
    ItemStackSize           SMALLINT         DEFAULT 0   NOT NULL,
    Tradeable               BOOLEAN          DEFAULT TRUE  NOT NULL,
    Examine                 TEXT                        NOT NULL,
    Locked                  BOOLEAN          DEFAULT FALSE NOT NULL,
    DecayItem               VARCHAR(50)                 NOT NULL,
    BequethStats            BOOLEAN          DEFAULT FALSE NOT NULL,
    ItemValue               INT             DEFAULT 0     NOT NULL,
    ItemMesh                VARCHAR(200)   DEFAULT ''    NOT NULL,
    MeshToUseForPickup      VARCHAR(200)   DEFAULT ''    NOT NULL,
    TextureToUseForIcon     VARCHAR(200)   DEFAULT ''    NOT NULL,
    ExtraDecals             VARCHAR(2000)  DEFAULT ''    NOT NULL,
    PremiumCurrencyPrice    INT                         DEFAULT 0  NOT NULL,
    FreeCurrencyPrice       INT                         DEFAULT 0  NOT NULL,
    ItemTier                INT                         DEFAULT 0  NOT NULL,
    ItemCode                VARCHAR(50)    DEFAULT ''    NOT NULL,
    ItemDuration            INT                         DEFAULT 0  NOT NULL,
    WeaponActorClass        VARCHAR(200)   DEFAULT ''    NOT NULL,
    StaticMesh              VARCHAR(200)   DEFAULT ''    NOT NULL,
    SkeletalMesh            VARCHAR(200)   DEFAULT ''    NOT NULL,
    ItemQuality             SMALLINT        DEFAULT 0   NOT NULL,
    IconSlotWidth           INT                         DEFAULT 1  NOT NULL,
    IconSlotHeight          INT                         DEFAULT 1  NOT NULL,
    ItemMeshID              INT                         DEFAULT 0  NOT NULL,
    CustomData              VARCHAR(2000)  DEFAULT ''    NOT NULL,
    CONSTRAINT PK_Items
        PRIMARY KEY (CustomerGUID, ItemID)
);

CREATE TABLE ItemActions (
    CustomerGUID        UUID                NOT NULL,
    ItemActionID        SERIAL              NOT NULL,
    ActionName          VARCHAR(50)         NOT NULL,
    CONSTRAINT PK_ItemActions
        PRIMARY KEY (CustomerGUID, ItemActionID)
);

CREATE TABLE ItemActionMappings (
    CustomerGUID            UUID                NOT NULL,
    ItemID                  SERIAL              NOT NULL,
    ItemActionID            SERIAL              NOT NULL,
    PRIMARY KEY (CustomerGUID, ItemID, ItemActionID),
    FOREIGN KEY (CustomerGUID, ItemID) REFERENCES Items(CustomerGUID, ItemID),
    FOREIGN KEY (CustomerGUID, ItemActionID) REFERENCES ItemActions(CustomerGUID, ItemActionID)
);

CREATE TABLE ItemTags (
    CustomerGUID        UUID            NOT NULL,
    ItemTagID           SERIAL          NOT NULL,
    TagName             VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_ItemTags
        PRIMARY KEY (CustomerGUID, ItemTagID)
);

CREATE TABLE ItemTagMappings (
    CustomerGUID            UUID            NOT NULL,
    ItemID                  SERIAL          NOT NULL,
    ItemTagID               SERIAL          NOT NULL,
    PRIMARY KEY (CustomerGUID, ItemID, ItemTagID),
    FOREIGN KEY (CustomerGUID, ItemID) REFERENCES Items(CustomerGUID, ItemID),
    FOREIGN KEY (CustomerGUID, ItemTagID) REFERENCES ItemTags(CustomerGUID, ItemTagID)
);

CREATE TABLE ItemStats (
    CustomerGUID        UUID            NOT NULL,
    ItemStatID          SERIAL          NOT NULL,
    StatName            VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_ItemStats
      PRIMARY KEY (CustomerGUID, ItemStatID)
);

CREATE TABLE ItemStatMappings (
    CustomerGUID            UUID            NOT NULL,
    ItemID                  SERIAL          NOT NULL,
    ItemStatID              SERIAL          NOT NULL,
    StatValue               VARCHAR(50)     NOT NULL,
    PRIMARY KEY (CustomerGUID, ItemID, ItemStatID),
    FOREIGN KEY (CustomerGUID, ItemID) REFERENCES Items(CustomerGUID, ItemID),
    FOREIGN KEY (CustomerGUID, ItemStatID) REFERENCES ItemStats(CustomerGUID, ItemStatID)
);

CREATE TABLE MapInstances
(
    CustomerGUID            UUID                    NOT NULL,
    MapInstanceID           SERIAL                  NOT NULL,
    WorldServerID           INT                     NOT NULL,
    MapID                   INT                     NOT NULL,
    Port                    INT                     NOT NULL,
    Status                  INT       DEFAULT 0     NOT NULL,
    PlayerGroupID           INT                     NULL,
    NumberOfReportedPlayers INT       DEFAULT 0     NOT NULL,
    LastUpdateFromServer    TIMESTAMP               NULL,
    LastServerEmptyDate     TIMESTAMP               NULL,
    CreateDate              TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT PK_MapInstances
        PRIMARY KEY (CustomerGUID, MapInstanceID)
);

CREATE TABLE Maps
(
    CustomerGUID                UUID                    NOT NULL,
    MapID                       SERIAL                  NOT NULL,
    MapName                     VARCHAR(50)             NOT NULL,
    MapData                     BYTEA                   NULL,
    Width                       SMALLINT                NOT NULL,
    Height                      SMALLINT                NOT NULL,
    ZoneName                    VARCHAR(50)             NOT NULL,
    WorldCompContainsFilter     VARCHAR(100) DEFAULT '' NOT NULL,
    WorldCompListFilter         VARCHAR(200) DEFAULT '' NOT NULL,
    MapMode                     INT          DEFAULT 1  NOT NULL,
    SoftPlayerCap               INT          DEFAULT 60 NOT NULL,
    HardPlayerCap               INT          DEFAULT 80 NOT NULL,
    MinutesToShutdownAfterEmpty INT          DEFAULT 1  NOT NULL,
    CONSTRAINT PK_Maps
        PRIMARY KEY (CustomerGUID, MapID)
);

CREATE TABLE OWSVersion
(
    OWSDBVersion VARCHAR(10) NULL
);

CREATE TABLE PlayerGroupTypes
(
    PlayerGroupTypeID   INT         NOT NULL,
    PlayerGroupTypeDesc VARCHAR(50) NOT NULL,
    CONSTRAINT PK_PlayerGroupTypes
        PRIMARY KEY (PlayerGroupTypeID)
);

CREATE TABLE PlayerGroup
(
    PlayerGroupID     SERIAL        NOT NULL,
    CustomerGUID      UUID          NOT NULL,
    PlayerGroupName   VARCHAR(50)   NOT NULL,
    PlayerGroupTypeID INT           NOT NULL,
    ReadyState        INT DEFAULT 0 NOT NULL,
    CreateDate        TIMESTAMP     NULL,
    CONSTRAINT PK_PlayerGroup
        PRIMARY KEY (CustomerGUID, PlayerGroupID),
    CONSTRAINT FK_PlayerGroup_PlayerGroupType
        FOREIGN KEY (PlayerGroupTypeID) REFERENCES PlayerGroupTypes (PlayerGroupTypeID)
);

CREATE TABLE PlayerGroupCharacters
(
    PlayerGroupID INT                     NOT NULL,
    CustomerGUID  UUID                    NOT NULL,
    CharacterID   INT                     NOT NULL,
    DateAdded     TIMESTAMP DEFAULT NOW() NOT NULL,
    TeamNumber    INT       DEFAULT 0     NOT NULL,
    CONSTRAINT PK_PlayerGroupCharacters
        PRIMARY KEY (PlayerGroupID, CustomerGUID, CharacterID)
);

CREATE TABLE Races
(
    CustomerGUID UUID        NOT NULL,
    RaceID       SERIAL      NOT NULL,
    RaceName     VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Races
        PRIMARY KEY (CustomerGUID, RaceID)
);

CREATE TABLE AccountSessions
(
    CustomerGUID          UUID                           NOT NULL,
    AccountSessionGUID    UUID DEFAULT gen_random_uuid() NOT NULL,
    AccountID             UUID                           NOT NULL,
    LoginDate             TIMESTAMP                      NOT NULL,
    SelectedCharacterName VARCHAR(50)                    NULL,
    CONSTRAINT PK_AccountSessions
        PRIMARY KEY (CustomerGUID, AccountSessionGUID),
    CONSTRAINT FK_AccountSessions_AccountID
        FOREIGN KEY (AccountID) REFERENCES AccountData (AccountID)
);

CREATE TABLE AccountDataInQueue
(
    CustomerGUID     UUID          NOT NULL,
    AccountID        UUID          NOT NULL,
    QueueName        VARCHAR(20)   NOT NULL,
    JoinDT           TIMESTAMP     NOT NULL,
    MatchMakingScore INT DEFAULT 0 NOT NULL,
    CONSTRAINT PK_AccountDataInQueue
        PRIMARY KEY (CustomerGUID, AccountID, QueueName)
);

CREATE TABLE WorldServers
(
    CustomerGUID            UUID                     NOT NULL,
    WorldServerID           SERIAL                   NOT NULL,
    ServerIP                VARCHAR(50)              NOT NULL,
    MaxNumberOfInstances    INT                      NOT NULL,
    ActiveStartTime         TIMESTAMP                NULL,
    Port                    INT         DEFAULT 8181 NOT NULL,
    ServerStatus            SMALLINT    DEFAULT 0    NOT NULL,
    InternalServerIP        VARCHAR(50) DEFAULT ''   NOT NULL,
    StartingMapInstancePort INT         DEFAULT 7778 NOT NULL,
    CONSTRAINT PK_WorldServers
        PRIMARY KEY (CustomerGUID, WorldServerID)
);

CREATE TABLE WorldSettings
(
    CustomerGUID    UUID   NOT NULL,
    WorldSettingsID SERIAL NOT NULL,
    StartTime       BIGINT NOT NULL,
    CONSTRAINT PK_WorldSettings
        PRIMARY KEY (CustomerGUID, WorldSettingsID)
);

CREATE VIEW vRandNumber AS
SELECT RANDOM() AS RandNumber;

CREATE OR REPLACE FUNCTION AbilityMod(AbilityCore INT) RETURNS INT
    LANGUAGE SQL
    IMMUTABLE
AS
$$
SELECT FLOOR(($1 - 10) / 2)
$$;

CREATE OR REPLACE FUNCTION CalcXFromTile(Tile INT, MapWidth SMALLINT) RETURNS INT
    LANGUAGE SQL
    IMMUTABLE
AS
$$
SELECT $1 % $2
$$;

CREATE OR REPLACE FUNCTION CalcYFromTile(Tile INT, MapWidth SMALLINT) RETURNS INT
    LANGUAGE SQL
    IMMUTABLE
AS
$$
SELECT FLOOR($1 / $2)
$$;

CREATE OR REPLACE FUNCTION OffsetIntoMap(X INT, Y INT, MapWidth SMALLINT) RETURNS INT
    LANGUAGE SQL
    IMMUTABLE
AS
$$
SELECT ($2 - 1) * $3 + $1
$$;

CREATE OR REPLACE FUNCTION RollDice(NumberOfDice INT, MaxDiceValue INT) RETURNS INT
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _TotalValue      INT := 0;
    _CurrentDiceRoll INT := 0;
BEGIN
    WHILE (_CurrentDiceRoll < NumberOfDice)
        LOOP
            SELECT _TotalValue + CAST(FLOOR(($2) * RandNumber) AS INT) + 1 FROM vRandNumber INTO _TotalValue;
            _CurrentDiceRoll := _CurrentDiceRoll + 1;
        END LOOP;
    RETURN _TotalValue;
END;
$$;

CREATE OR REPLACE FUNCTION CalculateDistanceBetweenTwoTiles(Tile1 INT, Tile2 INT, MapWidth SMALLINT) RETURNS INT
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _Distance INT   := 0;
    _Tile1X   INT   := 0;
    _Tile1Y   INT   := 0;
    _Tile2X   INT   := 0;
    _Tile2Y   INT   := 0;
    _DiffX    FLOAT := 0.0;
    _DiffY    FLOAT := 0.0;
BEGIN
    SELECT CalcXFromTile($1, $3) INTO _Tile1X;
    SELECT CalcYFromTile($1, $3) INTO _Tile1Y;
    SELECT CalcXFromTile($2, $3) INTO _Tile2X;
    SELECT CalcYFromTile($2, $3) INTO _Tile2Y;

    IF (_Tile1X > _Tile2X) THEN
        IF (_Tile1Y > _Tile2Y) THEN
            _DiffX := _Tile1X - _Tile2X;
            _DiffY := _Tile1Y - _Tile2Y;
        ELSE
            _DiffX := _Tile1X - _Tile2X;
            _DiffY := _Tile2Y - _Tile1Y;
        END IF;
    ELSE
        IF (_Tile1Y > _Tile2Y) THEN
            _DiffX := _Tile2X - _Tile1X;
            _DiffY := _Tile1Y - _Tile2Y;
        ELSE
            _DiffX := _Tile2X - _Tile1X;
            _DiffY := _Tile2Y - _Tile1Y;
        END IF;
    END IF;

    IF (_DiffX > _DiffY) THEN
        _Distance := (FLOOR(_DiffY * 1.5) + (_DiffX - _DiffY));
    ELSE
        _Distance := (FLOOR(_DiffY * 1.5) + (_DiffY - _DiffX));
    END IF;

    RETURN _Distance * 5;
END
$$;

CREATE OR REPLACE FUNCTION fSplit(DelimitedString VARCHAR(8000), Delimiter VARCHAR(100))
    RETURNS TABLE
            (
                ElementID INT,
                Element   VARCHAR(1000)
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _Index   SMALLINT := 0;
    _Start   SMALLINT := 0;
    _DelSize SMALLINT := 0;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        ElementID SERIAL,
        ELEMENT   VARCHAR(1000)
    ) ON COMMIT DROP;

    _DelSize := LENGTH($2);
    WHILE LENGTH(DelimitedString) > 0
        LOOP
            _Index := POSITION(Delimiter IN DelimitedString);
            IF _Index = 0 THEN
                INSERT INTO temp_table (ELEMENT) VALUES (TRIM(BOTH FROM DelimitedString));
                EXIT;
            ELSE
                INSERT INTO temp_table (ELEMENT) VALUES (TRIM(BOTH FROM SUBSTRING(DelimitedString, 1, (_Index - 1))));
                _Start := _Index + _DelSize;
                DelimitedString = SUBSTRING(DelimitedString, _Start, (LENGTH(DelimitedString) - _Start + 1));
            END IF;
        END LOOP;
    RETURN QUERY SELECT * FROM temp_table;
END;
$$;

CREATE OR REPLACE FUNCTION GetPointsOnLine(Tile1 INT, Tile2 INT, MapWidth SMALLINT)
    RETURNS TABLE
            (
                MapOrder INT
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _Tile1X INT := 0;
    _Tile1Y INT := 0;
    _Tile2X INT := 0;
    _Tile2Y INT := 0;
    _SwapXY BIT := 0::BIT;
    _Temp   INT := 0;
    _DeltaX INT := 0;
    _DeltaY INT := 0;
    _Error  INT := 0;
    _Y      INT := 0;
    _YStep  INT := 0;
    _X      INT := 0;
    _Tile   INT := 0;
BEGIN

    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        MapOrder INT
    ) ON COMMIT DROP;

    SELECT CalcXFromTile($1 - 1, $3) INTO _Tile1X;
    SELECT CalcYFromTile($1 - 1, $3) + 1 INTO _Tile1Y;
    SELECT CalcXFromTile($2 - 1, $3) INTO _Tile2X;
    SELECT CalcYFromTile($2 - 1, $3) + 1 INTO _Tile2Y;

    IF (ABS(_Tile2Y - _Tile1Y) > ABS(_Tile2X - _Tile1X)) THEN
        _SwapXY := 1::BIT;
    END IF;

    IF (_SwapXY = 1::BIT) THEN
        -- swap x and y
        _Temp := _Tile1X;
        _Tile1X := _Tile1Y;
        _Tile1Y := _Temp; -- swap x0 and y0
        _Temp := _Tile2X;
        _Tile2X := _Tile2Y;
        _Tile2Y := _Temp; -- swap x1 and y1
    END IF;

    IF (_Tile1X > _Tile2X) THEN
        -- make sure x0 < x1
        _Temp := _Tile1X;
        _Tile1X := _Tile2X;
        _Tile2X := _Temp; -- swap x0 and x1
        _Temp := _Tile1Y;
        _Tile1Y := _Tile2Y;
        _Tile2Y := _Temp; -- swap y0 and y1
    END IF;

    _DeltaX := _Tile2X - _Tile1X;
    _DeltaY := FLOOR(ABS(_Tile2Y - _Tile1Y));
    _Error := FLOOR(_DeltaX / 2.0);
    _Y := _Tile1Y;

    IF (_Tile1Y < _Tile2Y) THEN
        _YStep := 1;
    ELSE
        _YStep := -1;
    END IF;

    IF (_SwapXY = 1::BIT) THEN
        -- Y / X
        _X := _Tile1X;
        WHILE _X < (_Tile2X + 1)
            LOOP
                _Tile := OffsetIntoMap(_Y + 1, _X, $3);
                _X := _X + 1;

                INSERT INTO temp_table (MapOrder) VALUES (_Tile);

                _Error := _Error - _DeltaY;
                IF _Error < 0 THEN
                    _Y := _Y + _YStep;
                    _Error := _Error + _DeltaX;
                END IF;
            END LOOP;
    ELSE
        -- X / Y
        _X := _Tile1X;
        WHILE _X < (_Tile2X + 1)
            LOOP
                _X := _X + 1;
                _Tile := OffsetIntoMap(_X, _Y, $3);
                INSERT INTO temp_table (MapOrder) VALUES (_Tile);

                _Error := _Error - _DeltaY;
                IF _Error < 0 THEN
                    _Y := _Y + _YStep;
                    _Error := _Error + _DeltaX;
                END IF;
            END LOOP;
    END IF;
    RETURN QUERY SELECT * FROM temp_table;
END
$$;

CREATE OR REPLACE FUNCTION GetPointsOnVisionLine(Tile1 INT, Tile2 INT, MapWidth SMALLINT)
    RETURNS TABLE
            (
                MapOrder INT,
                FromCode INT
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _Tile1X    INT := 0;
    _Tile1Y    INT := 0;
    _Tile2X    INT := 0;
    _Tile2Y    INT := 0;
    _Error     INT := 0;
    _Y         INT := 0;
    _YStep     INT := 0;
    _X         INT := 0;
    _Tile      INT := 0;
    _I         INT;
    _XStep     INT := 0;
    _ErrorPrev INT := 0;
    _DDY       INT := 0;
    _DDX       INT := 0;
    _DX        INT := 0;
    _DY        INT := 0;
BEGIN

    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        MapOrder INT,
        FromCode INT
    ) ON COMMIT DROP;

    SELECT CalcXFromTile($1, $3) INTO _Tile1X;
    SELECT CalcYFromTile($1 - 1, $3) + 1 INTO _Tile1Y;
    SELECT CalcXFromTile($2, $3) INTO _Tile2X;
    SELECT CalcYFromTile($2 - 1, $3) + 1 INTO _Tile2Y;

    _Y := _Tile1Y;
    _X := _Tile1X;
    _DX := _Tile2X - _Tile1X;
    _DY := _Tile2Y - _Tile1Y;

    --POINT (y1, x1);  // first point
    _Tile := OffsetIntoMap(_Tile1X, _Tile1Y, $3);
    INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 0);

    -- NB the last point can't be here, because of its previous point (which has to be verified)
    IF (_DY < 0) THEN
        _YStep := -1;
        _DY := -_DY;
    ELSE
        _YStep := 1;
    END IF;

    IF (_DX < 0) THEN
        _XStep := -1;
        _DX := -_DX;
    ELSE
        _XStep := 1;
    END IF;

    _DDY := 2 * _DY; --work with double values for full precision
    _DDX := 2 * _DX;

    IF (_DDX >= _DDY) THEN -- first octant (0 <= slope <= 1)
    -- compulsory initialization (even for errorprev, needed when dx==dy)
        _ErrorPrev := _DX;-- start in the middle of the square
        _Error := _DX;
        _I := 0;
        --for (i=0 ; i < dx ; i++){  -- do not use the first point (already done)
        WHILE _I < _DX
            LOOP
                _X := _X + _XStep;
                _Error := _Error + _DDY;

                IF _Error > _DDX THEN -- increment y if AFTER the middle ( > )
                    _Y := _Y + _YStep;
                    _Error := _Error - _DDX;
                    -- three cases (octant == right->right-top for directions below):
                    IF (_Error + _ErrorPrev) < _DDX THEN-- bottom square also
                        _Tile := OffsetIntoMap(_X, _Y, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 1);
                    ELSIF (_Error + _ErrorPrev) > _DDX THEN -- left square also
                    --POINT (y, x-xstep);
                        _Tile := OffsetIntoMap(_X - _XStep, _Y, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 2);
                    ELSE -- corner: bottom and left squares also
                    --POINT (y-ystep, x);
                        _Tile := OffsetIntoMap(_X, _Y - _YStep, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 3);

                        _Tile := OffsetIntoMap(_X - _XStep, _Y, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 4);
                    END IF;
                END IF;

                _Tile := OffsetIntoMap(_X, _Y, $3);
                INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 5);

                _ErrorPrev := _Error;
                _I := _I + 1;
            END LOOP; --WHILE (@i < @dx)
    ELSE --IF (@ddx >= @ddy)
    -- the same as above
        _ErrorPrev := _DY;
        _Error := _DY;

        --for (i=0 ; i < dy ; i++){
        WHILE _I < _DY
            LOOP
                _Y := _Y + _YStep;
                _Error := _Error + _DDX;

                IF _Error > _DDY THEN
                    _X := _X + _XStep;
                    _Error := _Error - _DDY;
                    IF (_Error + _ErrorPrev) < _DDY THEN
                        --POINT (y, x-xstep);
                        _Tile := OffsetIntoMap(_X - _XStep, _Y, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 6);
                    ELSIF (_Error + _ErrorPrev) > _DDY THEN
                        --POINT (y-ystep, x);
                        _Tile := OffsetIntoMap(_X, _Y - _YStep, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 7);
                    ELSE
                        --POINT (y, x-xstep); );
                        _Tile := OffsetIntoMap(_X - _XStep, _Y, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 8);
                        --POINT (y-ystep, x);
                        _Tile := OffsetIntoMap(_X, _Y - _YStep, $3);
                        INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 9);
                    END IF;
                END IF;

                _Tile := OffsetIntoMap(_X, _Y, $3);
                INSERT INTO temp_table (MapOrder, FromCode) VALUES (_Tile, 10);

                _ErrorPrev := _Error;
                _I := _I + 1;
            END LOOP; --WHILE (@i < @dy)
    END IF;--IF (@ddx >= @ddy)

    RETURN QUERY SELECT * FROM temp_table;
END
$$;

CREATE OR REPLACE FUNCTION AddCharacter(
    _CustomerGUID UUID,
    _AccountSessionGUID UUID,
    _CharacterName VARCHAR(50),
    _ClassName VARCHAR(50)
)
    RETURNS TABLE (
        CharacterName VARCHAR(50),
        ClassName VARCHAR(50),
        CharacterLevel SMALLINT,
        StartingMapName VARCHAR(50),
        X FLOAT,
        Y FLOAT,
        Z FLOAT,
        RX FLOAT,
        RY FLOAT,
        RZ FLOAT,
        TeamNumber INT,
        Gold INT,
        Silver INT,
        Copper INT,
        FreeCurrency INT,
        PremiumCurrency INT,
        Fame FLOAT,
        Alignment FLOAT,
        Score INT,
        Gender SMALLINT,
        XP INT,
        Size SMALLINT,
        Weight FLOAT,
        Fishing FLOAT,
        Mining FLOAT,
        Woodcutting FLOAT,
        Smelting FLOAT,
        Smithing FLOAT,
        Cooking FLOAT,
        Fletching FLOAT,
        Tailoring FLOAT,
        Hunting FLOAT,
        Leatherworking FLOAT,
        Farming FLOAT,
        Herblore FLOAT
    )
    LANGUAGE PLPGSQL
AS $$
DECLARE
_AccountID UUID;
    _ClassID INT;
    _CharacterID INT;
    _CharacterExists BOOLEAN;
    _InvalidCharacters INT;
BEGIN
    -- Validate Account Session
SELECT US.AccountID
FROM AccountSessions US
WHERE US.CustomerGUID = _CustomerGUID
  AND US.AccountSessionGUID = _AccountSessionGUID
    INTO _AccountID;

IF _AccountID IS NULL THEN
        RAISE EXCEPTION 'Invalid Account Session.';
END IF;

    -- Validate Class Name
SELECT C.ClassID
FROM Class C
WHERE C.CustomerGUID = _CustomerGUID
  AND C.ClassName = _ClassName
    INTO _ClassID;

IF _ClassID IS NULL THEN
        RAISE EXCEPTION 'Invalid Class Name.';
END IF;

    -- Validate Character Name
SELECT EXISTS (
    SELECT 1
    FROM CharacterData CD
    WHERE CD.CustomerGUID = _CustomerGUID
      AND CD.CharacterName = _CharacterName
) INTO _CharacterExists;

IF _CharacterExists THEN
        RAISE EXCEPTION 'Character Name Already Exists.';
END IF;

    -- Check for invalid characters in Character Name
    _CharacterName := TRIM(BOTH FROM _CharacterName); -- Trim spaces
    _CharacterName := REPLACE(REPLACE(REPLACE(_CharacterName, ' ', '<>'), '><', ''), '<>', ' '); -- Replace invalid spacing
    _InvalidCharacters := LENGTH(ARRAY_TO_STRING(REGEXP_MATCHES(_CharacterName, '[^a-zA-Z0-9 ]'), ''));

    IF _InvalidCharacters > 0 THEN
        RAISE EXCEPTION 'Character Name contains invalid characters. Only letters, numbers, and spaces are allowed.';
END IF;

    -- Insert Character
INSERT INTO CharacterData (
    CustomerGUID, AccountID, ClassID, CharacterName, MapName, X, Y, Z, RX, RY, RZ,
    Fishing, Mining, Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring,
    Hunting, Leatherworking, Farming, Herblore, Spirit, Magic, TeamNumber,
    Thirst, Hunger, Gold, Score, CharacterLevel, Gender, XP, HitDie, Wounds,
    Size, Weight, MaxHealth, Health, HealthRegenRate, MaxMana, Mana, ManaRegenRate,
    MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, FatigueRegenRate,
    MaxStamina, Stamina, StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate,
    Strength, Dexterity, Constitution, Intellect, Wisdom, Charisma, Agility,
    Fortitude, Reflex, Willpower, BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed,
    CritChance, CritMultiplier, Haste, SpellPower, SpellPenetration, Defense, Dodge,
    Parry, Avoidance, Versatility, Multishot, Initiative, NaturalArmor, PhysicalArmor,
    BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed, Range, Speed,
    Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, Description)
SELECT _CustomerGUID,
       _AccountID,
       _ClassID,
       _CharacterName,
       CL.StartingMapName,
       CL.X,
       CL.Y,
       CL.Z,
       CL.RX,
       CL.RY,
       CL.RZ,
       CL.Fishing,
       CL.Mining,
       CL.Woodcutting,
       CL.Smelting,
       CL.Smithing,
       CL.Cooking,
       CL.Fletching,
       CL.Tailoring,
       CL.Hunting,
       CL.Leatherworking,
       CL.Farming,
       CL.Herblore,
       CL.Spirit,
       CL.Magic,
       CL.TeamNumber,
       CL.Thirst,
       CL.Hunger,
       CL.Gold,
       CL.Score,
       CL.CharacterLevel,
       CL.Gender,
       CL.XP,
       CL.HitDie,
       CL.Wounds,
       CL.Size,
       CL.Weight,
       CL.MaxHealth,
       CL.Health,
       CL.HealthRegenRate,
       CL.MaxMana,
       CL.Mana,
       CL.ManaRegenRate,
       CL.MaxEnergy,
       CL.Energy,
       CL.EnergyRegenRate,
       CL.MaxFatigue,
       CL.Fatigue,
       CL.FatigueRegenRate,
       CL.MaxStamina,
       CL.Stamina,
       CL.StaminaRegenRate,
       CL.MaxEndurance,
       CL.Endurance,
       CL.EnduranceRegenRate,
       CL.Strength,
       CL.Dexterity,
       CL.Constitution,
       CL.Intellect,
       CL.Wisdom,
       CL.Charisma,
       CL.Agility,
       CL.Fortitude,
       CL.Reflex,
       CL.Willpower,
       CL.BaseAttack,
       CL.BaseAttackBonus,
       CL.AttackPower,
       CL.AttackSpeed,
       CL.CritChance,
       CL.CritMultiplier,
       CL.Haste,
       CL.SpellPower,
       CL.SpellPenetration,
       CL.Defense,
       CL.Dodge,
       CL.Parry,
       CL.Avoidance,
       CL.Versatility,
       CL.Multishot,
       CL.Initiative,
       CL.NaturalArmor,
       CL.PhysicalArmor,
       CL.BonusArmor,
       CL.ForceArmor,
       CL.MagicArmor,
       CL.Resistance,
       CL.ReloadSpeed,
       CL.Range,
       CL.Speed,
       CL.Silver,
       CL.Copper,
       CL.FreeCurrency,
       CL.PremiumCurrency,
       CL.Fame,
       CL.Alignment,
       CL.Description
FROM Class CL
WHERE CL.ClassID = _ClassID
  AND CL.CustomerGUID = _CustomerGUID;

-- Add default character's inventory
INSERT INTO CharInventory (CustomerGUID, CharacterID, InventoryName, InventorySize)
VALUES (_CustomerGUID, _CharacterID, 'Bag', 16);

-- Get CharacterID
_CharacterID := CURRVAL(PG_GET_SERIAL_SEQUENCE('characterdata', 'characterid'));

    -- Return Inserted Character
RETURN QUERY
SELECT CD.CharacterName, CL.ClassName, CD.CharacterLevel, CD.MapName, CD.X, CD.Y, CD.Z, CD.RX, CD.RY, CD.RZ,
       CD.TeamNumber, CD.Gold, CD.Silver, CD.Copper, CD.FreeCurrency, CD.PremiumCurrency, CD.Fame, CD.Alignment,
       CD.Score, CD.Gender, CD.XP, CD.Size, CD.Weight, CD.Fishing, CD.Mining, CD.Woodcutting, CD.Smelting,
       CD.Smithing, CD.Cooking, CD.Fletching, CD.Tailoring, CD.Hunting, CD.Leatherworking, CD.Farming,
       CD.Herblore
FROM CharacterData CD
         INNER JOIN Class CL ON CD.ClassID = CL.ClassID
WHERE CD.CharacterID = _CharacterID;
END
$$;

CREATE OR REPLACE FUNCTION ValidateItemExistence(_CustomerGUID UUID, _ItemID INT)
       RETURNS BOOLEAN AS $$
       DECLARE
       _Count INT;
       BEGIN SELECT COUNT(1) 
             INTO _Count
             FROM Items
             WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;
RETURN _Count > 0;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION ValidateInventoryCapacity(_CustomerGUID UUID, _CharInventoryID INT)
       RETURNS BOOLEAN AS $$
       DECLARE
       _InventorySize INT;
       _CurrentItemCount INT;
                          BEGIN SELECT InventorySize
                                INTO _InventorySize
                                FROM CharInventory
                                WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID;

SELECT COUNT(1)
INTO _CurrentItemCount
FROM CharInventoryItems
WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID;

RETURN _CurrentItemCount < _InventorySize;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION FindStackableSlot(_CustomerGUID UUID, _CharInventoryID INT, _ItemID INT)
       RETURNS INT AS $$
       DECLARE
       _SlotNumber INT;
       BEGIN SELECT InSlotNumber 
             INTO _SlotNumber
             FROM CharInventoryItems ci
                 JOIN Items i ON ci.CustomerGUID = i.CustomerGUID AND ci.ItemID = i.ItemID
             WHERE ci.CustomerGUID = _CustomerGUID
               AND ci.CharInventoryID = _CharInventoryID
               AND ci.ItemID = _ItemID
               AND i.ItemCanStack = TRUE
                 LIMIT 1;

RETURN COALESCE(_SlotNumber, -1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE AddOrUpdateCustomCharData(_CustomerGUID UUID,
                                                      _CharacterName VARCHAR(50),
                                                      _CustomFieldName VARCHAR(50),
                                                      _FieldValue TEXT)
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _CharacterID INT;
BEGIN

    SELECT CharacterID
    FROM CharacterData C
    WHERE C.CharacterName = _CharacterName
      AND C.CustomerGUID = _CustomerGUID
    INTO _CharacterID;

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'AddOrUpdateCustomCharData: ' || CONCAT(_CustomFieldName, 'Empty Field Name') || ': ' ||
                   CONCAT(_CharacterName, 'Empty CharName'), _CustomerGUID);

    IF _CharacterID > 0 THEN
        IF NOT EXISTS(SELECT
                      FROM CustomCharacterData
                      WHERE CustomerGUID = _CustomerGUID
                        AND CharacterID = _CharacterID
                        AND CustomFieldName = _CustomFieldName
                          FOR UPDATE) THEN
            INSERT INTO CustomCharacterData (CustomerGUID, CharacterID, CustomFieldName, FieldValue)
            VALUES (_CustomerGUID, _CharacterID, _CustomFieldName, _FieldValue);
        ELSE
            UPDATE CustomCharacterData
            SET FieldValue=_FieldValue
            WHERE CustomerGUID = _CustomerGUID
              AND CustomFieldName = _CustomFieldName
              AND CharacterID = _CharacterID;

            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(), 'AddOrUpdateCustomCharData: ' || CAST(LENGTH(_FieldValue) AS VARCHAR), _CustomerGUID);
        END IF;
    END IF;
END
$$;

CREATE OR REPLACE PROCEDURE AddOrUpdateMapZone(_CustomerGUID UUID,
                                               _MapID INT,
                                               _MapName VARCHAR(50),
                                               _MapData BYTEA,
                                               _ZoneName VARCHAR(50),
                                               _WorldCompContainsFilter VARCHAR(100),
                                               _WorldCompListFilter VARCHAR(200),
                                               _SoftPlayerCap INT,
                                               _HardPlayerCap INT,
                                               _MapMode INT
)
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF (_WorldCompContainsFilter IS NULL) THEN
        _WorldCompContainsFilter := '';
    END IF;
    IF (_WorldCompListFilter IS NULL) THEN
        _WorldCompListFilter := '';
    END IF;
    IF NOT EXISTS(SELECT
                  FROM Maps
                  WHERE CustomerGUID = _CustomerGUID
                    AND (MapID = _MapID OR ZoneName = _ZoneName) FOR UPDATE) THEN
        RAISE INFO 'Not exists';
        INSERT INTO Maps (CustomerGUID, MapName, MapData, Width, Height, ZoneName, WorldCompContainsFilter,
                          WorldCompListFilter, SoftPlayerCap, HardPlayerCap, MapMode)
        VALUES (_CustomerGUID, _MapName, _MapData, 0, 0, _ZoneName, _WorldCompContainsFilter, _WorldCompListFilter,
                _SoftPlayerCap, _HardPlayerCap, _MapMode);
    ELSE
        RAISE INFO 'exists';
        UPDATE Maps
        SET CustomerGUID=_CustomerGUID,
            MapName=_MapName,
            MapData=_MapData,
            ZoneName=_ZoneName,
            WorldCompContainsFilter=_WorldCompContainsFilter,
            WorldCompListFilter=_WorldCompListFilter,
            SoftPlayerCap = _SoftPlayerCap,
            HardPlayerCap = _HardPlayerCap,
            MapMode = _MapMode
        WHERE CustomerGUID = _CustomerGUID
          AND MapID = _MapID;
    END IF;
END
$$;

CREATE OR REPLACE FUNCTION AddAccount(
    _CustomerGUID UUID,
    _AccountName VARCHAR(100),
    _Email VARCHAR(256),
    _Password VARCHAR(256),
    _TosVersion VARCHAR(50),
    _Role VARCHAR(10),
    _Discord VARCHAR(50) DEFAULT NULL,
    _LastClientIP INET DEFAULT NULL
)
    RETURNS TABLE
            (
                AccountID UUID
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
_PasswordHash VARCHAR(128);
    _AccountID    UUID;
    _UUID         UUID;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        AccountID UUID
    ) ON COMMIT DROP;

    -- Hash the password
    _PasswordHash = crypt(_Password, gen_salt('md5'));
    -- Generate unique AccountID and UUID
    _AccountID := gen_random_uuid();
    _UUID := gen_random_uuid();
    -- Insert the AccountID into the temporary table
INSERT INTO temp_table (AccountID) VALUES (_AccountID);

-- Insert the new account into the AccountData table
INSERT INTO AccountData (
    AccountID,
    CustomerGUID,
    UUID,
    AccountName,
    PasswordHash,
    Email,
    Discord,
    CreateDate,
    TosVersion,
    TosVersionAcceptDate,
    LastOnlineDate,
    LastClientIP,
    Role
)
VALUES (
           _AccountID,
           _CustomerGUID,
           _UUID,
           _AccountName,
           _PasswordHash,
           _Email,
           _Discord,
           NOW(),
           _TosVersion,
           NOW(),
           NOW(),
           _LastClientIP,
           _Role
       );

-- Return the generated AccountID
RETURN QUERY SELECT * FROM temp_table;
END
$$;


CREATE OR REPLACE PROCEDURE AddNewCustomer(
    _CustomerName VARCHAR(50),
    _AccountName VARCHAR(100),
    _Email VARCHAR(256),
    _Password VARCHAR(256)
)
LANGUAGE PLPGSQL
AS
$$
DECLARE
_CustomerGUID UUID := gen_random_uuid();
    _AccountID UUID;
    _ClassID INT;
    _CharacterName VARCHAR(50) := 'Test';
    _CharacterID INT;
BEGIN
    -- Insert into Customers
INSERT INTO Customers (CustomerGUID, CustomerName, CustomerEmail, CustomerPhone, CustomerNotes, EnableDebugLogging)
VALUES (_CustomerGUID, _CustomerName, _Email, '', '', TRUE);

-- Insert into WorldSettings
INSERT INTO WorldSettings (CustomerGUID, StartTime)
VALUES (_CustomerGUID, CAST(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) AS BIGINT));

-- Add account and retrieve AccountID
SELECT AccountID
FROM AddAccount(
        _CustomerGUID,
        _AccountName,
        _Email,
        _Password,
        'DefaultTosVersion',
        'Developer'
     )
    INTO _AccountID;

-- Insert default maps
INSERT INTO Maps (CustomerGUID, MapName, ZoneName, MapData, Width, Height)
VALUES
    (_CustomerGUID, 'NewEuropa', 'NewEuropa', NULL, 1, 1),
    (_CustomerGUID, 'Map2', 'Map2', NULL, 1, 1),
    (_CustomerGUID, 'DungeonMap', 'DungeonMap', NULL, 1, 1),
    (_CustomerGUID, 'FourZoneMap', 'Zone1', NULL, 1, 1),
    (_CustomerGUID, 'FourZoneMap', 'Zone2', NULL, 1, 1);

-- Insert a default class
INSERT INTO Class (CustomerGUID, ClassName, StartingMapName, X, Y, Z, RX, RY, RZ, TeamNumber, Thirst, Hunger, Gold, Score,
                   CharacterLevel, Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health, HealthRegenRate, MaxMana, Mana,
                   ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, FatigueRegenRate, MaxStamina, Stamina,
                   StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate, Strength, Dexterity, Constitution, Intellect,
                   Wisdom, Charisma, Agility, Fortitude, Reflex, Willpower, BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed,
                   CritChance, CritMultiplier, Haste, SpellPower, SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility,
                   Multishot, Initiative, NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed,
                   Range, Speed, Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, Description)
VALUES
    (_CustomerGUID, 'Warrior', 'NewEuropa', 0, 0, 250, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 1, 0, 100, 50, 0, 100, 0,
     1, 100, 0, 5, 100, 0, 1, 0, 0, 10, 10, 10, 10, 10, 0, 1, 1, 1, 5, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '');


-- Retrieve ClassID for the inserted class
_ClassID := CURRVAL(PG_GET_SERIAL_SEQUENCE('class', 'classid'));

    -- Insert a character respecting CharacterData table structure
INSERT INTO CharacterData (
    CustomerGUID, ClassID, AccountID, CharacterName, MapName, X, Y, Z, RX, RY, RZ,
    Fishing, Mining, Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring, Hunting,
    Leatherworking, Farming, Herblore, Spirit, Magic, TeamNumber, Thirst, Hunger, Gold, Score,
    CharacterLevel, Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health, HealthRegenRate,
    MaxMana, Mana, ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, FatigueRegenRate,
    MaxStamina, Stamina, StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate, Strength,
    Dexterity, Constitution, Intellect, Wisdom, Charisma, Agility, Fortitude, Reflex, Willpower,
    BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed, CritChance, CritMultiplier, Haste,
    SpellPower, SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility, Multishot, Initiative,
    NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed, Range, Speed,
    Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, ServerIP, LastActivity, Description,
    DefaultPawnClassPath, IsInternalNetworkTestUser, BaseMesh, IsAdmin, IsModerator, CreateDate
)
SELECT
    _CustomerGUID, _ClassID, _AccountID, _CharacterName, StartingMapName, X, Y, Z, RX, RY, RZ,
    Fishing, Mining, Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring, Hunting,
    Leatherworking, Farming, Herblore, Spirit, Magic, TeamNumber, Thirst, Hunger, Gold, Score,
    CharacterLevel, Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health, HealthRegenRate,
    MaxMana, Mana, ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, FatigueRegenRate,
    MaxStamina, Stamina, StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate, Strength,
    Dexterity, Constitution, Intellect, Wisdom, Charisma, Agility, Fortitude, Reflex, Willpower,
    BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed, CritChance, CritMultiplier, Haste,
    SpellPower, SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility, Multishot, Initiative,
    NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed, Range, Speed,
    Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, '', NOW(), '', '', FALSE, '', FALSE, FALSE, NOW()
FROM Class
WHERE ClassID = _ClassID;

-- Retrieve CharacterID for the inserted character
_CharacterID := CURRVAL(PG_GET_SERIAL_SEQUENCE('characterdata', 'characterid'));

    -- Insert default inventory for the character
INSERT INTO CharInventory (CustomerGUID, CharacterID, InventoryName, InventorySize)
VALUES (_CustomerGUID, _CharacterID, 'Bag', 16);
END
$$;

CREATE OR REPLACE FUNCTION CheckMapInstanceStatus(_CustomerGUID UUID,
                                                  _MapInstanceID INT)
    RETURNS TABLE
            (
                MapInstanceStatus INT
            )
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        MapInstanceStatus INT
    );
    INSERT INTO DebugLog (CustomerGUID, DebugDate, DebugDesc)
    VALUES (_CustomerGUID, NOW(), 'CheckMapInstanceStatus');

    INSERT INTO temp_table
    SELECT Status
    FROM MapInstances MI
    WHERE MI.MapInstanceID = _MapInstanceID
      AND MI.CustomerGUID = _CustomerGUID;

    RETURN QUERY SELECT * FROM temp_table;
END
$$;

CREATE OR REPLACE PROCEDURE CleanUp(_CustomerGUID UUID)
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _CharacterID INT;
    _ZoneName    VARCHAR(50);
BEGIN

    DELETE
    FROM CharOnMapInstance
    WHERE CustomerGUID = _CustomerGUID
      AND CharacterID IN (SELECT C.CharacterID
                          FROM CharacterData C
                                   INNER JOIN AccountData U
                                              ON U.CustomerGUID = C.CustomerGUID
                                                  AND U.AccountID = C.AccountID
                          WHERE U.LastAccess < CURRENT_TIMESTAMP - (1 || ' minutes')::INTERVAL
                            AND C.CustomerGUID = _CustomerGUID);

    CREATE TEMP TABLE IF NOT EXISTS temp_CleanUp
    (
        MapInstanceID INT
    );

    INSERT INTO temp_CleanUp (MapInstanceID)
    SELECT MapInstanceID
    FROM MapInstances
    WHERE LastUpdateFromServer < CURRENT_TIMESTAMP - (2 || ' minutes')::INTERVAL
      AND CustomerGUID = _CustomerGUID;

    DELETE
    FROM CharOnMapInstance
    WHERE CustomerGUID = _CustomerGUID
      AND MapInstanceID IN (SELECT MapInstanceID FROM temp_CleanUp);

    DELETE
    FROM MapInstances
    WHERE CustomerGUID = _CustomerGUID
      AND MapInstanceID IN (SELECT MapInstanceID FROM temp_CleanUp);

END
$$;

CREATE OR REPLACE FUNCTION GetAbilityBars(_CustomerGUID UUID,
                                          _CharName VARCHAR(50))
    RETURNS TABLE
            (
                AbilityBarName            VARCHAR(50),
                CharAbilityBarID          INT,
                CharAbilityBarsCustomJSON TEXT,
                CharacterID               INT,
                CustomerGUID              UUID,
                MaxNumberOfSlots          INT,
                NumberOfUnlockedSlots     INT

            )
    LANGUAGE SQL
AS
$$
SELECT CAB.AbilityBarName,
       CAB.CharAbilityBarID,
       CONCAT(CAB.CharAbilityBarsCustomJSON, '') AS CharAbilityBarsCustomJSON,
       CAB.CharacterID,
       CAB.CustomerGUID,
       CAB.MaxNumberOfSlots,
       CAB.NumberOfUnlockedSlots
FROM CharAbilityBars CAB
         INNER JOIN CharacterData C
                    ON C.CharacterID = CAB.CharacterID
                        AND C.CustomerGUID = CAB.CustomerGUID
WHERE C.CustomerGUID = _CustomerGUID
  AND C.CharacterName = _CharName
$$;

CREATE OR REPLACE FUNCTION GetAbilityBarsAndAbilities(_CustomerGUID UUID,
                                                      _CharName VARCHAR(50))
    RETURNS TABLE
            (
                AbilityBarName             VARCHAR(50),
                CharAbilityBarID           INT,
                CharAbilityBarsCustomJSON  TEXT,
                CharacterID                INT,
                CustomerGUID               UUID,
                MaxNumberOfSlots           INT,
                NumberOfUnlockedSlots      INT,
                AbilityLevel               INT,
                CharHasAbilitiesCustomJSON TEXT,
                AbilityID                  INT,
                AbilityName                VARCHAR(50),
                AbilityTypeID              INT,
                Class                      INT,
                Race                       INT,
                TextureToUseForIcon        VARCHAR(200),
                GameplayAbilityClassName   VARCHAR(200),
                AbilityCustomJSON          TEXT,
                InSlotNumber               INT
            )
    LANGUAGE SQL
AS
$$
SELECT CAB.AbilityBarName,
       CAB.CharAbilityBarID,
       CONCAT(CAB.CharAbilityBarsCustomJSON, '')  AS CharAbilityBarsCustomJSON,
       CAB.CharacterID,
       CAB.CustomerGUID,
       CAB.MaxNumberOfSlots,
       CAB.NumberOfUnlockedSlots,
       CHA.AbilityLevel,
       CONCAT(CHA.CharHasAbilitiesCustomJSON, '') AS CharHasAbilitiesCustomJSON,
       AB.AbilityID,
       AB.AbilityName,
       AB.AbilityTypeID,
       AB.Class,
       AB.Race,
       AB.TextureToUseForIcon,
       AB.GameplayAbilityClassName,
       AB.AbilityCustomJSON,
       CABA.InSlotNumber
FROM CharAbilityBars CAB
         INNER JOIN CharAbilityBarAbilities CABA
                    ON CABA.CharAbilityBarID = CAB.CharAbilityBarID
                        AND CABA.CustomerGUID = CAB.CustomerGUID
         INNER JOIN CharHasAbilities CHA
                    ON CHA.CharHasAbilitiesID = CABA.CharHasAbilitiesID
                        AND CHA.CustomerGUID = CABA.CustomerGUID
         INNER JOIN Abilities AB
                    ON AB.AbilityID = CHA.AbilityID
                        AND AB.CustomerGUID = CHA.CustomerGUID
         INNER JOIN CharacterData C
                    ON C.CharacterID = CAB.CharacterID
                        AND C.CustomerGUID = CAB.CustomerGUID
WHERE C.CustomerGUID = _CustomerGUID
  AND C.CharacterName = _CharName
$$;

CREATE OR REPLACE FUNCTION GetAllCharacters(_CustomerGUID UUID,
                                            _AccountSessionGUID UUID)
    RETURNS TABLE
            (
                CustomerGUID              UUID,
                CharacterID               INT,
                AccountID                 UUID,
                CharacterName             VARCHAR(50),
                MapName                   VARCHAR(50),
                X                         FLOAT,
                Y                         FLOAT,
                Z                         FLOAT,
                RX                        FLOAT,
                RY                        FLOAT,
                RZ                        FLOAT,
                Fishing                   FLOAT,
                Mining                    FLOAT,
                Woodcutting               FLOAT,
                Smelting                  FLOAT,
                Smithing                  FLOAT,
                Cooking                   FLOAT,
                Fletching                 FLOAT,
                Tailoring                 FLOAT,
                Hunting                   FLOAT,
                Leatherworking            FLOAT,
                Farming                   FLOAT,
                Herblore                  FLOAT,
                Spirit                    FLOAT,
                Magic                     FLOAT,
                TeamNumber                INT,
                Thirst                    FLOAT,
                Hunger                    FLOAT,
                Gold                      INT,
                Score                     INT,
                CharacterLevel            SMALLINT,
                Gender                    SMALLINT,
                XP                        INT,
                HitDie                    SMALLINT,
                Wounds                    FLOAT,
                Size                      SMALLINT,
                Weight                    FLOAT,
                MaxHealth                 FLOAT,
                Health                    FLOAT,
                HealthRegenRate           FLOAT,
                MaxMana                   FLOAT,
                Mana                      FLOAT,
                ManaRegenRate             FLOAT,
                MaxEnergy                 FLOAT,
                Energy                    FLOAT,
                EnergyRegenRate           FLOAT,
                MaxFatigue                FLOAT,
                Fatigue                   FLOAT,
                FatigueRegenRate          FLOAT,
                MaxStamina                FLOAT,
                Stamina                   FLOAT,
                StaminaRegenRate          FLOAT,
                MaxEndurance              FLOAT,
                Endurance                 FLOAT,
                EnduranceRegenRate        FLOAT,
                Strength                  FLOAT,
                Dexterity                 FLOAT,
                Constitution              FLOAT,
                Intellect                 FLOAT,
                Wisdom                    FLOAT,
                Charisma                  FLOAT,
                Agility                   FLOAT,
                Fortitude                 FLOAT,
                Reflex                    FLOAT,
                Willpower                 FLOAT,
                BaseAttack                FLOAT,
                BaseAttackBonus           FLOAT,
                AttackPower               FLOAT,
                AttackSpeed               FLOAT,
                CritChance                FLOAT,
                CritMultiplier            FLOAT,
                Haste                     FLOAT,
                SpellPower                FLOAT,
                SpellPenetration          FLOAT,
                Defense                   FLOAT,
                Dodge                     FLOAT,
                Parry                     FLOAT,
                Avoidance                 FLOAT,
                Versatility               FLOAT,
                Multishot                 FLOAT,
                Initiative                FLOAT,
                NaturalArmor              FLOAT,
                PhysicalArmor             FLOAT,
                BonusArmor                FLOAT,
                ForceArmor                FLOAT,
                MagicArmor                FLOAT,
                Resistance                FLOAT,
                ReloadSpeed               FLOAT,
                Range                     FLOAT,
                Speed                     FLOAT,
                Silver                    INT,
                Copper                    INT,
                FreeCurrency              INT,
                PremiumCurrency           INT,
                Fame                      FLOAT,
                Alignment                 FLOAT,
                ServerIP                  VARCHAR(50),
                LastActivity              TIMESTAMP,
                Description               TEXT,
                DefaultPawnClassPath      VARCHAR(200),
                IsInternalNetworkTestUser BOOLEAN,
                ClassID                   INT,
                BaseMesh                  VARCHAR(100),
                IsAdmin                   BOOLEAN,
                IsModerator               BOOLEAN,
                CreateDate                TIMESTAMP,
                LastActivityString        VARCHAR(30),
                CreateDateString          VARCHAR(30),
                ClassName                 VARCHAR(50)
            )
    LANGUAGE SQL
AS
$$
SELECT C.*,
       TO_CHAR(C.LastActivity, 'mon dd yyyy hh:miAM') AS LastActivityString,
       TO_CHAR(C.CreateDate, 'mon dd yyyy hh:miAM')   AS CreateDateString,
       CL.ClassName
FROM CharacterData C
         INNER JOIN Class CL
                    ON CL.ClassID = C.ClassID
         INNER JOIN AccountData U
                    ON U.AccountID = C.AccountID
         INNER JOIN AccountSessions US
                    ON US.AccountID = U.AccountID
WHERE C.CustomerGUID = _CustomerGUID
  AND US.AccountSessionGUID = _AccountSessionGUID;
$$;

CREATE OR REPLACE FUNCTION GetCharacterAbilities(_CustomerGUID UUID,
                                                 _CharName VARCHAR(50))
    RETURNS TABLE
            (
                AbilityID                  INT,
                AbilityCustomJSON          TEXT,
                AbilityName                VARCHAR(50),
                AbilityTypeID              INT,
                Class                      INT,
                CustomerGUID               UUID,
                Race                       INT,
                TextureToUseForIcon        VARCHAR(200),
                GameplayAbilityClassName   VARCHAR(200),
                CharHasAbilitiesID         INT,
                AbilityLevel               INT,
                CharHasAbilitiesCustomJSON TEXT,
                CharacterID                INT,
                CharacterName              VARCHAR(50)
            )
    LANGUAGE SQL
AS
$$
SELECT A.AbilityID,
       A.AbilityCustomJSON,
       A.AbilityName,
       A.AbilityTypeID,
       A.Class,
       A.CustomerGUID,
       A.Race,
       A.TextureToUseForIcon,
       A.GameplayAbilityClassName,
       CHA.CharHasAbilitiesID,
       CHA.AbilityLevel,
       CHA.CharHasAbilitiesCustomJSON,
       C.CharacterID,
       C.CharacterName
FROM CharHasAbilities CHA
         INNER JOIN Abilities A
                    ON A.AbilityID = CHA.AbilityID
                        AND A.CustomerGUID = CHA.CustomerGUID
         INNER JOIN CharacterData C
                    ON C.CharacterID = CHA.CharacterID
                        AND C.CustomerGUID = CHA.CustomerGUID
WHERE C.CustomerGUID = _CustomerGUID
  AND C.CharacterName = _CharName
$$;

CREATE OR REPLACE FUNCTION GetCharByCharName(_CustomerGUID UUID,
                                             _CharName VARCHAR(50))
    RETURNS TABLE
            (
                CustomerGUID              UUID,
                CharacterID               INT,
                AccountID                 UUID,
                Email                     VARCHAR(256),
                CharacterName             VARCHAR(50),
                MapName                   VARCHAR(50),
                X                         FLOAT,
                Y                         FLOAT,
                Z                         FLOAT,
                Fishing                   FLOAT,
                Mining                    FLOAT,
                Woodcutting               FLOAT,
                Smelting                  FLOAT,
                Smithing                  FLOAT,
                Cooking                   FLOAT,
                Fletching                 FLOAT,
                Tailoring                 FLOAT,
                Hunting                   FLOAT,
                Leatherworking            FLOAT,
                Farming                   FLOAT,
                Herblore                  FLOAT,
                CharacterServerIP         VARCHAR(50),
                LastActivity              TIMESTAMP,
                RX                        FLOAT,
                RY                        FLOAT,
                RZ                        FLOAT,
                Spirit                    FLOAT,
                Magic                     FLOAT,
                TeamNumber                INT,
                Thirst                    FLOAT,
                Hunger                    FLOAT,
                Gold                      INT,
                Score                     INT,
                CharacterLevel            SMALLINT,
                Gender                    SMALLINT,
                XP                        INT,
                HitDie                    SMALLINT,
                Wounds                    FLOAT,
                Size                      SMALLINT,
                Weight                    FLOAT,
                MaxHealth                 FLOAT,
                Health                    FLOAT,
                HealthRegenRate           FLOAT,
                MaxMana                   FLOAT,
                Mana                      FLOAT,
                ManaRegenRate             FLOAT,
                MaxEnergy                 FLOAT,
                Energy                    FLOAT,
                EnergyRegenRate           FLOAT,
                MaxFatigue                FLOAT,
                Fatigue                   FLOAT,
                FatigueRegenRate          FLOAT,
                MaxStamina                FLOAT,
                Stamina                   FLOAT,
                StaminaRegenRate          FLOAT,
                MaxEndurance              FLOAT,
                Endurance                 FLOAT,
                EnduranceRegenRate        FLOAT,
                Strength                  FLOAT,
                Dexterity                 FLOAT,
                Constitution              FLOAT,
                Intellect                 FLOAT,
                Wisdom                    FLOAT,
                Charisma                  FLOAT,
                Agility                   FLOAT,
                Fortitude                 FLOAT,
                Reflex                    FLOAT,
                Willpower                 FLOAT,
                BaseAttack                FLOAT,
                BaseAttackBonus           FLOAT,
                AttackPower               FLOAT,
                AttackSpeed               FLOAT,
                CritChance                FLOAT,
                CritMultiplier            FLOAT,
                Haste                     FLOAT,
                SpellPower                FLOAT,
                SpellPenetration          FLOAT,
                Defense                   FLOAT,
                Dodge                     FLOAT,
                Parry                     FLOAT,
                Avoidance                 FLOAT,
                Versatility               FLOAT,
                Multishot                 FLOAT,
                Initiative                FLOAT,
                NaturalArmor              FLOAT,
                PhysicalArmor             FLOAT,
                BonusArmor                FLOAT,
                ForceArmor                FLOAT,
                MagicArmor                FLOAT,
                Resistance                FLOAT,
                ReloadSpeed               FLOAT,
                Range                     FLOAT,
                Speed                     FLOAT,
                Silver                    INT,
                Copper                    INT,
                FreeCurrency              INT,
                PremiumCurrency           INT,
                Fame                      FLOAT,
                Alignment                 FLOAT,
                Description               TEXT,
                DefaultPawnClassPath      VARCHAR(200),
                IsInternalNetworkTestUser BOOLEAN,
                ClassID                   INT,
                BaseMesh                  VARCHAR(100),
                IsAdmin                   BOOLEAN,
                IsModerator               BOOLEAN,
                CreateDate                TIMESTAMP,
                Port                      INT,
                ServerIP                  VARCHAR(50),
                MapInstanceID             INT,
                ClassName                 VARCHAR(50),
                EnableAutoLoopBack        BOOLEAN
            )
    LANGUAGE SQL
AS
$$
SELECT
    C.CustomerGUID,
    C.CharacterID,
    C.AccountID,
    A.Email,
    C.CharacterName AS CharName,
    C.MapName,
    C.X,
    C.Y,
    C.Z,
    C.Fishing,
    C.Mining,
    C.Woodcutting,
    C.Smelting,
    C.Smithing,
    C.Cooking,
    C.Fletching,
    C.Tailoring,
    C.Hunting,
    C.Leatherworking,
    C.Farming,
    C.Herblore,
    C.ServerIP AS CharacterServerIP,
    C.LastActivity,
    C.RX,
    C.RY,
    C.RZ,
    C.Spirit,
    C.Magic,
    C.TeamNumber,
    C.Thirst,
    C.Hunger,
    C.Gold,
    C.Score,
    C.CharacterLevel,
    C.Gender,
    C.XP,
    C.HitDie,
    C.Wounds,
    C.Size,
    C.Weight,
    C.MaxHealth,
    C.Health,
    C.HealthRegenRate,
    C.MaxMana,
    C.Mana,
    C.ManaRegenRate,
    C.MaxEnergy,
    C.Energy,
    C.EnergyRegenRate,
    C.MaxFatigue,
    C.Fatigue,
    C.FatigueRegenRate,
    C.MaxStamina,
    C.Stamina,
    C.StaminaRegenRate,
    C.MaxEndurance,
    C.Endurance,
    C.EnduranceRegenRate,
    C.Strength,
    C.Dexterity,
    C.Constitution,
    C.Intellect,
    C.Wisdom,
    C.Charisma,
    C.Agility,
    C.Fortitude,
    C.Reflex,
    C.Willpower,
    C.BaseAttack,
    C.BaseAttackBonus,
    C.AttackPower,
    C.AttackSpeed,
    C.CritChance,
    C.CritMultiplier,
    C.Haste,
    C.SpellPower,
    C.SpellPenetration,
    C.Defense,
    C.Dodge,
    C.Parry,
    C.Avoidance,
    C.Versatility,
    C.Multishot,
    C.Initiative,
    C.NaturalArmor,
    C.PhysicalArmor,
    C.BonusArmor,
    C.ForceArmor,
    C.MagicArmor,
    C.Resistance,
    C.ReloadSpeed,
    C.Range,
    C.Speed,
    C.Silver,
    C.Copper,
    C.FreeCurrency,
    C.PremiumCurrency,
    C.Fame,
    C.Alignment,
    C.Description,
    C.DefaultPawnClassPath,
    C.IsInternalNetworkTestUser,
    C.ClassID,
    C.BaseMesh,
    C.IsAdmin,
    C.IsModerator,
    C.CreateDate,
    MI.Port,
    WS.ServerIP,
    CMI.MapInstanceID,
    CL.ClassName,
    CU.EnableAutoLoopBack
FROM CharacterData C
         INNER JOIN Class CL ON CL.ClassID = C.ClassID
         INNER JOIN AccountData A ON A.AccountID = C.AccountID
         INNER JOIN Customers CU ON CU.CustomerGUID = C.CustomerGUID
         LEFT JOIN CharOnMapInstance CMI ON CMI.CharacterID = C.CharacterID
         LEFT JOIN MapInstances MI ON MI.MapInstanceID = CMI.MapInstanceID
         LEFT JOIN WorldServers WS ON WS.WorldServerID = MI.WorldServerID
WHERE C.CustomerGUID = _CustomerGUID
  AND C.CharacterName = _CharName
ORDER BY MI.MapInstanceID DESC
    LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION GetCustomCharData(_CustomerGUID UUID,
                                             _CharName VARCHAR(50))
    RETURNS TABLE
            (
                CustomerGUID          UUID,
                CustomCharacterDataID INT,
                CharacterID           INT,
                CustomFieldName       VARCHAR(50),
                FieldValue            TEXT
            )
    LANGUAGE SQL
AS
$$
SELECT CCD.*
FROM CharacterData C
         INNER JOIN CustomCharacterData CCD
                    ON CCD.CharacterID = C.CharacterID
                        AND CCD.CustomerGUID = C.CustomerGUID
WHERE C.CustomerGUID = _CustomerGUID
  AND C.CharacterName = _CharName
$$;

CREATE OR REPLACE FUNCTION GetMapInstancesForWorldServerID(_CustomerGUID UUID,
                                                           _WorldServerID INT
)
    RETURNS TABLE
            (
                CustomerGUID                UUID,
                MapInstanceID               INT,
                WorldServerID               INT,
                MapID                       INT,
                Port                        INT,
                Status                      INT,
                PlayerGroupID               INT,
                NumberOfReportedPlayers     INT,
                LastUpdateFromServer        TIMESTAMP,
                LastServerEmptyDate         TIMESTAMP,
                CreateDate                  TIMESTAMP,
                SoftPlayerCap               INT,
                HardPlayerCap               INT,
                MapName                     VARCHAR(50),
                MapMode                     INT,
                MinutesToShutdownAfterEmpty INT,
                MinutesServerHasBeenEmpty   INT,
                MinutesSinceLastUpdate      INT
            )
    LANGUAGE SQL
AS
$$
SELECT MI.*,
       M.SoftPlayerCap,
       M.HardPlayerCap,
       M.MapName,
       M.MapMode,
       M.MinutesToShutdownAfterEmpty,
       FLOOR(EXTRACT(EPOCH FROM NOW()::TIMESTAMP - MI.LastServerEmptyDate) / 60)  AS MinutesServerHasBeenEmpty,
       FLOOR(EXTRACT(EPOCH FROM NOW()::TIMESTAMP - MI.LastUpdateFromServer) / 60) AS MinutesSinceLastUpdate
FROM Maps M
         INNER JOIN MapInstances MI
                    ON MI.MapID = M.MapID
WHERE M.CustomerGUID = _CustomerGUID
  AND MI.WorldServerID = _WorldServerID
$$;

CREATE OR REPLACE FUNCTION GetPlayerGroupsCharacterIsIn(
    _CustomerGUID UUID,
    _CharName VARCHAR(50),
    _AccountSessionGUID UUID,
    _PlayerGroupTypeID INT DEFAULT 0
)
    RETURNS TABLE
            (
                PlayerGroupID     INT,
                CustomerGUID      UUID,
                PlayerGroupName   VARCHAR(50),
                PlayerGroupTypeID INT,
                ReadyState        INT,
                CreateDate        TIMESTAMP,
                DateAdded         TIMESTAMP,
                TeamNumber        INT
            )
    LANGUAGE SQL
AS
$$
SELECT PG.PlayerGroupID,
       PG.CustomerGUID,
       PG.PlayerGroupName,
       PG.PlayerGroupTypeID,
       PG.ReadyState,
       PG.CreateDate,
       PGC.DateAdded,
       PGC.TeamNumber
FROM PlayerGroupCharacters PGC
         INNER JOIN PlayerGroup PG
                    ON PG.PlayerGroupID = PGC.PlayerGroupID
                        AND PG.CustomerGUID = PGC.CustomerGUID
         INNER JOIN CharacterData C
                    ON C.CharacterID = PGC.CharacterID
         INNER JOIN AccountSessions US
                    ON US.AccountID = C.AccountID
                        AND US.CustomerGUID = C.CustomerGUID
WHERE PGC.CustomerGUID = _CustomerGUID
  AND (PG.PlayerGroupTypeID = _PlayerGroupTypeID OR _PlayerGroupTypeID = 0)
  AND C.CharacterName = _CharName
  AND C.CustomerGUID = _CustomerGUID
$$;

CREATE OR REPLACE FUNCTION GetServerInstanceFromIPandPort(_CustomerGUID UUID,
                                                          _ServerIP VARCHAR(50),
                                                          _Port INT)
    RETURNS TABLE
            (
                MapName                 VARCHAR(50),
                ZoneName                VARCHAR(50),
                WorldCompContainsFilter VARCHAR(100),
                WorldCompListFilter     VARCHAR(200),
                MapInstanceID           INT,
                Status                  INT,
                MaxNumberOfInstances    INT,
                ActiveStartTime         TIMESTAMP,
                ServerStatus            SMALLINT,
                InternalServerIP        VARCHAR(50)
            )
    LANGUAGE SQL
AS
$$
SELECT M.MapName,
       M.ZoneName,
       M.WorldCompContainsFilter,
       M.WorldCompListFilter,
       MI.MapInstanceID,
       MI.Status,
       WS.MaxNumberOfInstances,
       WS.ActiveStartTime,
       WS.ServerStatus,
       WS.InternalServerIP
FROM MapInstances MI
         INNER JOIN Maps M
                    ON M.MapID = MI.MapID
                        AND M.CustomerGUID = MI.CustomerGUID
         INNER JOIN WorldServers WS
                    ON WS.WorldServerID = MI.WorldServerID
                        AND WS.CustomerGUID = MI.CustomerGUID
WHERE WS.CustomerGUID = _CustomerGUID
  AND (WS.ServerIP = _ServerIP
    OR InternalServerIP = _ServerIP)
  AND MI.Port = _Port;
$$;

CREATE OR REPLACE FUNCTION GetAccount(_CustomerGUID UUID,
                                      _AccountID UUID)
    RETURNS SETOF AccountData
    LANGUAGE SQL
AS
$$
SELECT *
FROM AccountData A
WHERE A.CustomerGUID = _CustomerGUID
  AND A.AccountID = _AccountID;
$$;

CREATE OR REPLACE FUNCTION GetAccountSession(_CustomerGUID UUID,
                                             _AccountSessionGUID UUID)
    RETURNS TABLE
            (
                CustomerGUID          UUID,
                AccountID             UUID,
                AccountSessionGUID    UUID,
                LoginDate             TIMESTAMP,
                SelectedCharacterName VARCHAR(50),
                Email                 VARCHAR(255),
                AccountName           VARCHAR(100),
                CreateDate            TIMESTAMP,
                LastOnlineDate        TIMESTAMP,
                Role                  VARCHAR(10),
                CharacterID           INT,
                CharacterName         VARCHAR(50),
                X                     FLOAT,
                Y                     FLOAT,
                Z                     FLOAT,
                RX                    FLOAT,
                RY                    FLOAT,
                RZ                    FLOAT,
                ZoneName              VARCHAR(50)
            )
    LANGUAGE SQL
AS
$$
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
    C.CharacterName AS CharName,
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
                       AND LOWER(C.CharacterName) = LOWER(US.SelectedCharacterName)
                       AND C.AccountID = US.AccountID
WHERE US.CustomerGUID = _CustomerGUID
  AND US.AccountSessionGUID = _AccountSessionGUID;
$$;

CREATE OR REPLACE FUNCTION GetWorldStartTime(_CustomerGUID UUID)
    RETURNS TABLE
            (
                CurrentWorldTime BIGINT
            )
    LANGUAGE SQL
AS
$$
SELECT CAST(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) AS BIGINT) - WS.StartTime
           AS CurrentWorldTime
FROM WorldSettings WS
WHERE WS.CustomerGUID = _CustomerGUID;
$$;

CREATE OR REPLACE FUNCTION GetZoneInstancesOfZone(_CustomerGUID UUID,
                                                  _ZoneName VARCHAR(50))
    RETURNS TABLE
            (
                CustomerGUID                UUID,
                MapID                       INT,
                MapName                     VARCHAR(50),
                MapData                     BYTEA,
                Width                       SMALLINT,
                Height                      SMALLINT,
                ZoneName                    VARCHAR(50),
                WorldCompContainsFilter     VARCHAR(100),
                WorldCompListFilter         VARCHAR(200),
                MapMode                     INT,
                SoftPlayerCap               INT,
                HardPlayerCap               INT,
                MinutesToShutdownAfterEmpty INT,
                InstanceCustomerGUID        UUID,
                MapInstanceID               INT,
                WorldServerID               INT,
                InstanceMapID               INT,
                Port                        INT,
                Status                      INT,
                PlayerGroupID               INT,
                NumberOfReportedPlayers     INT,
                LastUpdateFromServer        TIMESTAMP,
                LastServerEmptyDate         TIMESTAMP,
                CreateDate                  TIMESTAMP
            )
    LANGUAGE SQL
AS
$$
SELECT *
FROM Maps M
         INNER JOIN MapInstances MI
                    ON MI.MapID = M.MapID
WHERE M.CustomerGUID = _CustomerGUID
  AND M.ZoneName = _ZoneName
$$;

CREATE OR REPLACE FUNCTION SpinUpMapInstance(_CustomerGUID UUID,
                                             _ZoneName VARCHAR(50),
                                             _PlayerGroupID INT)
    RETURNS TABLE
            (
                ServerIP        VARCHAR(50),
                WorldServerID   INT,
                WorldServerIP   VARCHAR(50),
                WorldServerPort INT,
                Port            INT,
                MapInstanceID   INT
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _ServerIP                VARCHAR(50);
    _WorldServerID           INT;
    _WorldServerIP           VARCHAR(50);
    _WorldServerPort         INT;
    _Port                    INT;
    _MapInstanceID           INT;
    _MapID                   INT;
    _MapMode                 INT;
    _MaxNumberOfInstances    INT;
    _StartingMapInstancePort INT;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_SpinUpMapInstance
    (
        ServerIP        VARCHAR(50),
        WorldServerID   INT,
        WorldServerIP   VARCHAR(50),
        WorldServerPort INT,
        Port            INT,
        MapInstanceID   INT
    ) ON COMMIT DROP;

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'Attempting to Spin Up Map Instance: ' || _ZoneName, _CustomerGUID);

    SELECT MapID, MapMode
    INTO _MapID, _MapMode
    FROM Maps M
    WHERE M.ZoneName = _ZoneName
      AND M.CustomerGUID = _CustomerGUID;

    SELECT WS.ServerIP,
           WS.WorldServerID,
           WS.InternalServerIP,
           WS.Port,
           WS.MaxNumberOfInstances,
           WS.StartingMapInstancePort
    INTO
        _ServerIP, _WorldServerID, _WorldServerIP, _WorldServerPort, _MaxNumberOfInstances, _StartingMapInstancePort
    FROM WorldServers WS
             LEFT JOIN MapInstances MI
                       ON MI.WorldServerID = WS.WorldServerID
                           AND MI.CustomerGUID = WS.CustomerGUID
    WHERE WS.CustomerGUID = _CustomerGUID
      AND WS.ServerStatus = 1 --Active
      AND WS.ActiveStartTime IS NOT NULL
    GROUP BY WS.WorldServerID, WS.ServerIP, WS.InternalServerIP, WS.Port, WS.MaxNumberOfInstances,
             WS.StartingMapInstancePort
    ORDER BY CONCAT(COUNT(MI.MapInstanceID), 0)
    LIMIT 1;

    IF (_WorldServerID IS NULL) THEN
        INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
        VALUES (NOW(), 'Cannot find World Server!', _CustomerGUID);

        _MapInstanceID := -1;
    ELSE
        WITH RECURSIVE Num(Pos) AS
                           (SELECT CAST(_StartingMapInstancePort AS INT)
                            UNION ALL
                            SELECT CAST(Pos + 1 AS INT)
                            FROM Num
                            WHERE Pos < _StartingMapInstancePort + CONCAT(_MaxNumberOfInstances, 10)::INT)
        SELECT MIN(OpenPort)
        INTO _Port
        FROM (SELECT tmpA.Pos AS OpenPort, MI.Port AS PortInUse
              FROM Num tmpA
                       LEFT JOIN MapInstances MI ON MI.WorldServerID = _WorldServerID
                  AND MI.CustomerGUID = _CustomerGUID
                  AND MI.Port = tmpA.Pos) tmpB
        WHERE tmpB.PortInUse IS NULL;

    END IF;

    IF (_PlayerGroupID > 0 AND _MapMode = 2) --_MapMode = 2 is a dungeon instance server
    THEN
        INSERT INTO MapInstances (CustomerGUID, WorldServerID, MapID, Port, Status, PlayerGroupID, LastUpdateFromServer)
        VALUES (_CustomerGUID, _WorldServerID, _MapID, _Port, 1, _PlayerGroupID, NOW()); --Status 1 = Loading;
    ELSE
        INSERT INTO MapInstances (CustomerGUID, WorldServerID, MapID, Port, Status, LastUpdateFromServer)
        VALUES (_CustomerGUID, _WorldServerID, _MapID, _Port, 1, NOW()); --Status 1 = Loading;
    END IF;

    _MapInstanceID := CURRVAL(PG_GET_SERIAL_SEQUENCE('mapinstances', 'mapinstanceid'));

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'Successfully Spun Up Map Instance: ' || _ZoneName || ' ServerIP: ' || _ServerIP || ' Port: ' ||
                   CAST(_Port AS VARCHAR) || ' MapInstanceID: ' || CAST(_MapInstanceID AS VARCHAR), _CustomerGUID);

    INSERT INTO temp_SpinUpMapInstance (ServerIP, WorldServerID, WorldServerIP, WorldServerPort, Port, MapInstanceID)
    VALUES (_ServerIP, _WorldServerID, _WorldServerIP, _WorldServerPort, _Port, _MapInstanceID);
    RETURN QUERY SELECT * FROM temp_SpinUpMapInstance;
END;
$$;

CREATE OR REPLACE FUNCTION JoinMapByCharName(_CustomerGUID UUID,
                                             _CharName VARCHAR(50),
                                             _ZoneName VARCHAR(50),
                                             _PlayerGroupType INT)
    RETURNS TABLE
            (
                ServerIP           VARCHAR(50),
                WorldServerID      INT,
                WorldServerIP      VARCHAR(50),
                WorldServerPort    INT,
                Port               INT,
                MapInstanceID      INT,
                MapNameToStart     VARCHAR(50),
                MapInstanceStatus  INT,
                NeedToStartUpMap   BOOLEAN,
                EnableAutoLoopBack BOOLEAN,
                NoPortForwarding   BOOLEAN
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _MapID                     INT;
    _MapNameToStart            VARCHAR(50);
    _CharacterID               INT;
    _Email                     VARCHAR(255);
    _SoftPlayerCap             INT;
    _PlayerGroupID             INT;
    _ServerIP                  VARCHAR(50);
    _WorldServerID             INT;
    _WorldServerIP             VARCHAR(50);
    _WorldServerPort           INT;
    _Port                      INT;
    _MapInstanceID             INT;
    _MapInstanceStatus         INT;
    _NeedToStartUpMap          BOOLEAN;
    _EnableAutoLoopBack        BOOLEAN;
    _NoPortForwarding          BOOLEAN;
    _IsInternalNetworkTestUser BOOLEAN := FALSE;
    _ErrorRaised               BOOLEAN := FALSE;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        ServerIP           VARCHAR(50),
        WorldServerID      INT,
        WorldServerIP      VARCHAR(50),
        WorldServerPort    INT,
        Port               INT,
        MapInstanceID      INT,
        MapNameToStart     VARCHAR(50),
        MapInstanceStatus  INT,
        NeedToStartUpMap   BOOLEAN,
        EnableAutoLoopBack BOOLEAN,
        NoPortForwarding   BOOLEAN
    ) ON COMMIT DROP;

    --Run Cleanup here for now.  Later this can get moved to a scheduler to run periodically.
    CALL CleanUp(_CustomerGUID);

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'JoinMapByCharName: ' || _ZoneName || ' - ' || _CharName, _CustomerGUID);

    SELECT M.MapID, M.MapName, M.SoftPlayerCap
    INTO _MapID, _MapNameToStart, _SoftPlayerCap
    FROM Maps M
    WHERE M.ZoneName = _ZoneName
      AND M.CustomerGUID = _CustomerGUID;

    SELECT C.CharacterID, C.IsInternalNetworkTestUser, C.Email
    INTO _CharacterID, _IsInternalNetworkTestUser, _Email
    FROM CharacterData C
    WHERE C.CharacterName = _CharName
      AND C.CustomerGUID = _CustomerGUID;

    IF (_CharacterID IS NULL) THEN
        INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
        VALUES (NOW(), 'JoinMapByCharName: CharacterID is NULL!', _CustomerGUID);

        _NeedToStartUpMap := 0;
        _ErrorRaised := TRUE;
    END IF;

    IF _ErrorRaised = FALSE THEN
        SELECT C.EnableAutoLoopBack, C.NoPortForwarding
        INTO _EnableAutoLoopBack, _NoPortForwarding
        FROM Customers C
        WHERE C.CustomerGUID = _CustomerGUID;
    END IF;

    IF _ErrorRaised = FALSE AND (_PlayerGroupType > 0) THEN
        SELECT COALESCE(PG.PlayerGroupID, 0)
        FROM PlayerGroupCharacters PGC
                 INNER JOIN PlayerGroup PG
                            ON PG.PlayerGroupID = PGC.PlayerGroupID
        WHERE PGC.CustomerGUID = _CustomerGUID
          AND PGC.CharacterID = _CharacterID
          AND PG.PlayerGroupTypeID = _PlayerGroupType
        INTO _PlayerGroupID;
    END IF;

    IF _ErrorRaised = FALSE THEN
        SELECT (CASE
                    WHEN _IsInternalNetworkTestUser = TRUE THEN WS.InternalServerIP
                    ELSE WS.ServerIP END) AS ServerIp,
               WS.InternalServerIP,
               WS.Port                    AS WSPort,
               MI.Port                    AS MIPort,
               MI.MapInstanceID,
               WS.WorldServerID,
               MI.Status
        INTO _ServerIP, _WorldServerIP, _WorldServerPort, _Port, _MapInstanceID, _WorldServerID, _MapInstanceStatus
        FROM WorldServers WS
                 LEFT JOIN MapInstances MI
                           ON MI.WorldServerID = WS.WorldServerID
                               AND MI.CustomerGUID = WS.CustomerGUID
                 LEFT JOIN CharOnMapInstance CMI
                           ON CMI.MapInstanceID = MI.MapInstanceID
                               AND CMI.CustomerGUID = MI.CustomerGUID
        WHERE MI.MapID = _MapID
          AND WS.ActiveStartTime IS NOT NULL
          AND WS.CustomerGUID = _CustomerGUID
          AND MI.NumberOfReportedPlayers < _SoftPlayerCap
          AND (MI.PlayerGroupID = _PlayerGroupID OR _PlayerGroupID = 0) --Only lookup map instances that match the player group fro this Player Group Type or lookup all if zero
          AND MI.Status = 2
        GROUP BY MI.MapInstanceID, WS.ServerIP, MI.Port, WS.WorldServerID, WS.InternalServerIP, WS.Port, MI.Status
        ORDER BY COUNT(DISTINCT CMI.CharacterID);


        --There is a map already running to connect to
        IF _MapInstanceID IS NOT NULL THEN
            /*IF (POSITION('\@localhost' IN _Email) > 0) THEN
                _ServerIP := '127.0.0.1';
            END IF;*/

            _NeedToStartUpMap := FALSE;

            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(), 'Joined Existing Map: ' || COALESCE(_ZoneName, '') || ' - ' || COALESCE(_CharName, '') ||
                           ' - ' || COALESCE(_ServerIP, ''),
                    _CustomerGUID);
        ELSE --Spin up a new map

            SELECT *
            FROM SpinUpMapInstance(_CustomerGUID, _ZoneName, _PlayerGroupID)
            INTO _ServerIP , _WorldServerID , _WorldServerIP , _WorldServerPort , _Port, _MapInstanceID;

            /*IF (POSITION('@localhost' IN _Email) > 0 OR _IsInternalNetworkTestUser = TRUE) THEN
                _ServerIP := '127.0.0.1';
            END IF;*/

            _NeedToStartUpMap := TRUE;

            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(),
                    'SpinUpMapInstance returned: ' || COALESCE(_ZoneName, '') || ' CharName: ' ||
                    COALESCE(_CharName, '') || ' ServerIP: ' ||
                    COALESCE(_ServerIP, '') ||
                    ' WorldServerPort: ' || CAST(COALESCE(_WorldServerPort, -1) AS VARCHAR), _CustomerGUID);


            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(),
                    'JoinMapByCharName returned: ' || COALESCE(_MapNameToStart, '[NoMapName]') || ' MapInstanceID: ' ||
                    CAST(COALESCE(_MapInstanceID, -1) AS VARCHAR) || ' MapInstanceStatus: ' ||
                    CAST(COALESCE(_MapInstanceStatus, -1) AS VARCHAR) || ' NeedToStartUpMap: ' ||
                    CAST(_NeedToStartUpMap AS VARCHAR) || ' EnableAutoLoopBack: ' ||
                    CAST(_EnableAutoLoopBack AS VARCHAR) ||
                    ' ServerIP: ' || COALESCE(_ServerIP, '') || ' WorldServerIP: ' || COALESCE(_WorldServerIP, ''),
                    _CustomerGUID);
        END IF;
    END IF;
    INSERT INTO temp_table(ServerIP, WorldServerID, WorldServerIP, WorldServerPort, Port, MapInstanceID, MapNameToStart,
                           MapInstanceStatus, NeedToStartUpMap, EnableAutoLoopBack, NoPortForwarding)
    VALUES (_ServerIP, _WorldServerID, _WorldServerIP, _WorldServerPort, _Port, _MapInstanceID, _MapNameToStart,
            _MapInstanceStatus, _NeedToStartUpMap, _EnableAutoLoopBack, _NoPortForwarding);
    RETURN QUERY SELECT * FROM temp_table;
END;
$$;

CREATE OR REPLACE FUNCTION PlayerLoginAndCreateSession(
    _CustomerGUID UUID,
    _Email VARCHAR(256),
    _Password VARCHAR(256),
    _DontCheckPassword BOOLEAN DEFAULT FALSE
)
    RETURNS TABLE
            (
                Authenticated BOOLEAN,
                AccountSessionGUID UUID
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
_Authenticated BOOLEAN = FALSE;
    _PasswordCheck BOOLEAN = FALSE;
    _HashInDB      VARCHAR(128);
    _HashToCheck   VARCHAR(128);
    _AccountID     UUID;
    _AccountSessionGUID UUID;
BEGIN

    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        Authenticated BOOLEAN,
        AccountSessionGUID UUID
    ) ON COMMIT DROP;

    -- Check if the password matches or bypass password check
SELECT (PasswordHash = crypt(_Password, PasswordHash)), AccountID
INTO _PasswordCheck, _AccountID
FROM AccountData
WHERE CustomerGUID = _CustomerGUID
  AND Email = _Email
  AND Role = 'Player';

IF (_PasswordCheck = TRUE OR _DontCheckPassword = TRUE) THEN
        _Authenticated := TRUE;

        -- Delete any existing sessions for the account
DELETE FROM AccountSessions WHERE AccountID = _AccountID;

-- Create a new session
_AccountSessionGUID := gen_random_uuid();
INSERT INTO AccountSessions (CustomerGUID, AccountSessionGUID, AccountID, LoginDate)
VALUES (_CustomerGUID, _AccountSessionGUID, _AccountID, NOW());
END IF;

    -- Insert into the temporary table for the return
INSERT INTO temp_table (Authenticated, AccountSessionGUID)
VALUES (_Authenticated, _AccountSessionGUID);

RETURN QUERY SELECT * FROM temp_table;

END
$$;

CREATE OR REPLACE PROCEDURE PlayerLogOut(_CustomerGUID UUID,
                                         _CharName VARCHAR(50)
)
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _CharacterID INT;
BEGIN

    SELECT CharacterID
    INTO _CharacterID
    FROM CharacterData WC
    WHERE WC.CharacterName = _CharName
      AND WC.CustomerGUID = _CustomerGUID;

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'PlayerLogOut: CharName: ' || _CharName, _CustomerGUID);

    DELETE FROM CharOnMapInstance WHERE CharacterID = _CharacterID;
    --DELETE FROM PlayerGroupCharacters WHERE CharacterID=_CharacterID

END
$$;

CREATE OR REPLACE PROCEDURE RemoveCharacter(
    _CustomerGUID UUID,
    _AccountSessionGUID UUID,
    _CharacterName VARCHAR(50)
)
    LANGUAGE PLPGSQL
AS
$$
DECLARE
_AccountID   UUID;
    _CharacterID INT;
BEGIN
    -- Retrieve AccountID from AccountSessions
SELECT US.AccountID
INTO _AccountID
FROM AccountSessions US
WHERE US.CustomerGUID = _CustomerGUID
  AND US.AccountSessionGUID = _AccountSessionGUID;

IF _AccountID IS NOT NULL THEN
        -- Retrieve CharacterID from CharacterData
SELECT CharacterID
INTO _CharacterID
FROM CharacterData C
WHERE C.CustomerGUID = _CustomerGUID
  AND C.AccountID = _AccountID
  AND C.CharacterName = _CharacterName;

-- Remove related data from other tables
DELETE
FROM CharAbilityBarAbilities
WHERE CustomerGUID = _CustomerGUID
  AND CharAbilityBarID
    IN (SELECT CharAbilityBarID
        FROM CharAbilityBars
        WHERE CustomerGUID = _CustomerGUID
          AND CharacterID = _CharacterID);

DELETE FROM CharAbilityBars WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

DELETE FROM CharHasAbilities WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

DELETE FROM CharHasItems WHERE CharacterID = _CharacterID;

DELETE
FROM CharInventoryItems
WHERE CustomerGUID = _CustomerGUID
  AND CharInventoryID
    IN (SELECT CharInventoryID
        FROM CharInventory
        WHERE CustomerGUID = _CustomerGUID
          AND CharacterID = _CharacterID);

DELETE FROM CharInventory WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

DELETE FROM CharOnMapInstance WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

DELETE FROM ChatGroupAccountData WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

DELETE FROM CustomCharacterData WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

DELETE FROM PlayerGroupCharacters WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;

-- Finally, remove the character from CharacterData
DELETE FROM CharacterData WHERE CustomerGUID = _CustomerGUID AND CharacterID = _CharacterID;
END IF;
END
$$;

CREATE OR REPLACE PROCEDURE SetMapInstanceStatus(_MapInstanceID INT,
                                                 _MapInstanceStatus INT
)
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _CustomerGUID UUID;
    _MapName      VARCHAR(50);
BEGIN

    SELECT MI.CustomerGUID,
           M.MapName
    INTO _CustomerGUID, _MapName
    FROM MapInstances MI
             INNER JOIN Maps M
                        ON M.MapID = MI.MapID
    WHERE MapInstanceID = _MapInstanceID;

    UPDATE MapInstances
    SET Status = _MapInstanceStatus
    WHERE MapInstanceID = _MapInstanceID;

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'SetMapInstanceStatus: ' || _MapName, _CustomerGUID);
END
$$;

CREATE OR REPLACE PROCEDURE ShutdownMapInstance(
    _CustomerGUID UUID,
    _MapInstanceID INT
)
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    DELETE
    FROM CharOnMapInstance
    WHERE MapInstanceID = _MapInstanceID
      AND CustomerGUID = _CustomerGUID;

    DELETE
    FROM MapInstances
    WHERE MapInstanceID = _MapInstanceID
      AND CustomerGUID = _CustomerGUID;
END
$$;

CREATE OR REPLACE PROCEDURE ShutdownWorldServer(_CustomerGUID UUID,
                                                _WorldServerID INT)
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    DELETE
    FROM CharOnMapInstance
    WHERE CustomerGUID = _CustomerGUID
      AND MapInstanceID IN (SELECT MapInstanceID FROM MapInstances MI WHERE MI.WorldServerID = _WorldServerID);

    DELETE FROM MapInstances WHERE WorldServerID = _WorldServerID;

    UPDATE WorldServers
    SET ActiveStartTime=NULL,
        ServerStatus=0
    WHERE CustomerGUID = _CustomerGUID
      AND WorldServerID = _WorldServerID;

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'ShutdownWorldServer: ' || CAST(_WorldServerID AS VARCHAR), _CustomerGUID);
END
$$;

CREATE OR REPLACE FUNCTION StartWorldServer(_CustomerGUID UUID,
                                            _ServerIP VARCHAR(50))
    RETURNS TABLE
            (
                WorldServerID INT
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _WorldServerID INT;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        WorldServerID INT
    ) ON COMMIT DROP;

    SELECT WS.WorldServerID
    INTO _WorldServerID
    FROM WorldServers WS
    WHERE WS.CustomerGUID = _CustomerGUID
      AND (WS.ServerIP = _ServerIP OR WS.InternalServerIP = _ServerIP);

    IF (_WorldServerID > 0) THEN
        UPDATE WorldServers WS
        SET ActiveStartTime=NOW(),
            ServerStatus=1
        WHERE CustomerGUID = _CustomerGUID
          AND WS.WorldServerID = _WorldServerID;

        INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
        VALUES (NOW(), 'StartWorldServer Success: ' || CAST(_WorldServerID AS VARCHAR), _CustomerGUID);
    ELSIF (_ServerIP = '::1') THEN
        SELECT WS.WorldServerID INTO _WorldServerID FROM WorldServers WS WHERE WS.CustomerGUID = _CustomerGUID LIMIT 1;

        UPDATE WorldServers WS
        SET ActiveStartTime=NOW(),
            ServerStatus=1
        WHERE CustomerGUID = _CustomerGUID
          AND WS.WorldServerID = _WorldServerID;
        --_WorldServerID := -1;

        INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
        VALUES (NOW(), 'StartWorldServer Success (Local): ' || CAST(_WorldServerID AS VARCHAR) || ' IncomingIP: ' ||
                       CAST(_ServerIP AS VARCHAR), _CustomerGUID);
    ELSE
        INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
        VALUES (NOW(), 'StartWorldServer Failed: ' || CAST(_WorldServerID AS VARCHAR) || ' IncomingIP: ' ||
                       CAST(_ServerIP AS VARCHAR), _CustomerGUID);
    END IF;

    INSERT INTO temp_table(WorldServerID) VALUES (_WorldServerID);
    RETURN QUERY SELECT * FROM temp_table;
END
$$;

CREATE OR REPLACE PROCEDURE UpdateCharacterStats(
    _CustomerGUID UUID,
    _CharName VARCHAR(50),
    _CharacterLevel SMALLINT,
    _Gender SMALLINT,
    _Weight FLOAT,
    _Size SMALLINT,
    _Fame FLOAT,
    _Alignment FLOAT,
    _Description TEXT,
    _XP INT,
    _X FLOAT,
    _Y FLOAT,
    _Z FLOAT,
    _RX FLOAT,
    _RY FLOAT,
    _RZ FLOAT,
    _Fishing FLOAT,
    _Mining FLOAT,
    _Woodcutting FLOAT,
    _Smelting FLOAT,
    _Smithing FLOAT,
    _Cooking FLOAT,
    _Fletching FLOAT,
    _Tailoring FLOAT,
    _Hunting FLOAT,
    _Leatherworking FLOAT,
    _Farming FLOAT,
    _Herblore FLOAT,
    _Spirit FLOAT,
    _Magic FLOAT,
    _TeamNumber INT,
    _Thirst FLOAT,
    _Hunger FLOAT,
    _Gold INT,
    _Score INT,
    _HitDie SMALLINT,
    _Wounds FLOAT,
    _MaxHealth FLOAT,
    _Health FLOAT,
    _HealthRegenRate FLOAT,
    _MaxMana FLOAT,
    _Mana FLOAT,
    _ManaRegenRate FLOAT,
    _MaxEnergy FLOAT,
    _Energy FLOAT,
    _EnergyRegenRate FLOAT,
    _MaxFatigue FLOAT,
    _Fatigue FLOAT,
    _FatigueRegenRate FLOAT,
    _MaxStamina FLOAT,
    _Stamina FLOAT,
    _StaminaRegenRate FLOAT,
    _MaxEndurance FLOAT,
    _Endurance FLOAT,
    _EnduranceRegenRate FLOAT,
    _Strength FLOAT,
    _Dexterity FLOAT,
    _Constitution FLOAT,
    _Intellect FLOAT,
    _Wisdom FLOAT,
    _Charisma FLOAT,
    _Agility FLOAT,
    _Fortitude FLOAT,
    _Reflex FLOAT,
    _Willpower FLOAT,
    _BaseAttack FLOAT,
    _BaseAttackBonus FLOAT,
    _AttackPower FLOAT,
    _AttackSpeed FLOAT,
    _CritChance FLOAT,
    _CritMultiplier FLOAT,
    _Haste FLOAT,
    _SpellPower FLOAT,
    _SpellPenetration FLOAT,
    _Defense FLOAT,
    _Dodge FLOAT,
    _Parry FLOAT,
    _Avoidance FLOAT,
    _Versatility FLOAT,
    _Multishot FLOAT,
    _Initiative FLOAT,
    _NaturalArmor FLOAT,
    _PhysicalArmor FLOAT,
    _BonusArmor FLOAT,
    _ForceArmor FLOAT,
    _MagicArmor FLOAT,
    _Resistance FLOAT,
    _ReloadSpeed FLOAT,
    _Range FLOAT,
    _Speed FLOAT,
    _Silver INT,
    _Copper INT,
    _FreeCurrency INT,
    _PremiumCurrency INT,
    _Perception FLOAT,
    _Acrobatics FLOAT,
    _Climb FLOAT,
    _Stealth FLOAT
)
LANGUAGE PLPGSQL
AS
$$
BEGIN
UPDATE CharacterData
SET
    X = _X,
    Y = _Y,
    Z = _Z,
    RX = _RX,
    RY = _RY,
    RZ = _RZ,
    Fishing = _Fishing,
    Mining = _Mining,
    Woodcutting = _Woodcutting,
    Smelting = _Smelting,
    Smithing = _Smithing,
    Cooking = _Cooking,
    Fletching = _Fletching,
    Tailoring = _Tailoring,
    Hunting = _Hunting,
    Leatherworking = _Leatherworking,
    Farming = _Farming,
    Herblore = _Herblore,
    Spirit = _Spirit,
    Magic = _Magic,
    TeamNumber = _TeamNumber,
    Thirst = _Thirst,
    Hunger = _Hunger,
    Gold = _Gold,
    Score = _Score,
    CharacterLevel = _CharacterLevel,
    Gender = _Gender,
    XP = _XP,
    HitDie = _HitDie,
    Wounds = _Wounds,
    Size = _Size,
    Weight = _Weight,
    MaxHealth = _MaxHealth,
    Health = _Health,
    HealthRegenRate = _HealthRegenRate,
    MaxMana = _MaxMana,
    Mana = _Mana,
    ManaRegenRate = _ManaRegenRate,
    MaxEnergy = _MaxEnergy,
    Energy = _Energy,
    EnergyRegenRate = _EnergyRegenRate,
    MaxFatigue = _MaxFatigue,
    Fatigue = _Fatigue,
    FatigueRegenRate = _FatigueRegenRate,
    MaxStamina = _MaxStamina,
    Stamina = _Stamina,
    StaminaRegenRate = _StaminaRegenRate,
    MaxEndurance = _MaxEndurance,
    Endurance = _Endurance,
    EnduranceRegenRate = _EnduranceRegenRate,
    Strength = _Strength,
    Dexterity = _Dexterity,
    Constitution = _Constitution,
    Intellect = _Intellect,
    Wisdom = _Wisdom,
    Charisma = _Charisma,
    Agility = _Agility,
    Fortitude = _Fortitude,
    Reflex = _Reflex,
    Willpower = _Willpower,
    BaseAttack = _BaseAttack,
    BaseAttackBonus = _BaseAttackBonus,
    AttackPower = _AttackPower,
    AttackSpeed = _AttackSpeed,
    CritChance = _CritChance,
    CritMultiplier = _CritMultiplier,
    Haste = _Haste,
    SpellPower = _SpellPower,
    SpellPenetration = _SpellPenetration,
    Defense = _Defense,
    Dodge = _Dodge,
    Parry = _Parry,
    Avoidance = _Avoidance,
    Versatility = _Versatility,
    Multishot = _Multishot,
    Initiative = _Initiative,
    NaturalArmor = _NaturalArmor,
    PhysicalArmor = _PhysicalArmor,
    BonusArmor = _BonusArmor,
    ForceArmor = _ForceArmor,
    MagicArmor = _MagicArmor,
    Resistance = _Resistance,
    ReloadSpeed = _ReloadSpeed,
    Range = _Range,
    Speed = _Speed,
    Silver = _Silver,
    Copper = _Copper,
    FreeCurrency = _FreeCurrency,
    PremiumCurrency = _PremiumCurrency,
    Perception = _Perception,
    Acrobatics = _Acrobatics,
    Climb = _Climb,
    Stealth = _Stealth,
    Fame = _Fame,
    Alignment = _Alignment,
    Description = _Description
WHERE CustomerGUID = _CustomerGUID
  AND CharacterName = _CharName;

INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
VALUES (NOW(), 'UpdateCharacterStats: ' || _CharName, _CustomerGUID);
END
$$;

CREATE OR REPLACE PROCEDURE UpdateNumberOfPlayers(_CustomerGUID UUID,
                                                  _IP VARCHAR(50),
                                                  _Port INT,
                                                  _NumberOfReportedPlayers INT
)
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _LastNumberOfReportedPlayers INT;
BEGIN

    SELECT MI.NumberOfReportedPlayers
    INTO _LastNumberOfReportedPlayers
    FROM MapInstances MI
             INNER JOIN WorldServers WS
                        ON WS.WorldServerID = MI.WorldServerID
    WHERE (WS.ServerIP = _IP OR WS.InternalServerIP = _IP)
      AND MI.Port = _Port;

    --INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    --VALUES (now(), 'UpdateNumberOfPlayers: ' || _IP || ':' || CONVERT(varchar, _Port) || ' #:' || CONVERT(varchar, _NumberOfReportedPlayers) || ' - ' || CONVERT(varchar, _LastNumberOfReportedPlayers), _CustomerGUID);

    IF (_LastNumberOfReportedPlayers > 0 AND _NumberOfReportedPlayers = 0) THEN
        UPDATE MapInstances MI
        SET NumberOfReportedPlayers=_NumberOfReportedPlayers,
            LastUpdateFromServer=NOW(),
            LastServerEmptyDate=NOW()
        FROM WorldServers WS
        WHERE WS.WorldServerID = MI.WorldServerID
          AND (WS.ServerIP = _IP OR WS.InternalServerIP = _IP)
          AND MI.Port = _Port;
    ELSIF (_LastNumberOfReportedPlayers = 0 AND _NumberOfReportedPlayers > 0) THEN
        UPDATE MapInstances MI
        SET NumberOfReportedPlayers=_NumberOfReportedPlayers,
            LastUpdateFromServer=NOW(),
            LastServerEmptyDate=NULL
        FROM WorldServers WS
        WHERE WS.WorldServerID = MI.WorldServerID
          AND (WS.ServerIP = _IP OR WS.InternalServerIP = _IP)
          AND MI.Port = _Port;
    ELSE
        UPDATE MapInstances MI
        SET NumberOfReportedPlayers=_NumberOfReportedPlayers,
            LastUpdateFromServer=NOW()
        FROM WorldServers WS
        WHERE WS.WorldServerID = MI.WorldServerID
          AND (WS.ServerIP = _IP OR WS.InternalServerIP = _IP)
          AND MI.Port = _Port;
    END IF;
END
$$;

CREATE OR REPLACE PROCEDURE UpdatePositionOfCharacterByName(
    _CustomerGUID UUID,
    _CharName VARCHAR(50),
    _MapName VARCHAR(50),
    _X FLOAT,
    _Y FLOAT,
    _Z FLOAT,
    _RX FLOAT,
    _RY FLOAT,
    _RZ FLOAT
)
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF (_MapName <> '') THEN
UPDATE CharacterData
SET
    MapName = _MapName,
    X = _X,
    Y = _Y,
    Z = _Z + 1,
    RX = _RX,
    RY = _RY,
    RZ = _RZ
WHERE CharacterName = _CharName
  AND CustomerGUID = _CustomerGUID;
ELSE
UPDATE CharacterData
SET
    X = _X,
    Y = _Y,
    Z = _Z + 1,
    RX = _RX,
    RY = _RY,
    RZ = _RZ
WHERE CharacterName = _CharName
  AND CustomerGUID = _CustomerGUID;
END IF;

    -- Update the LastOnlineDate in AccountData for the account linked to this character
UPDATE AccountData
SET LastOnlineDate = NOW()
    FROM CharacterData C
WHERE C.CharacterName = _CharName
  AND C.CustomerGUID = _CustomerGUID
  AND AccountData.AccountID = C.AccountID;

-- Optionally, log the operation for debugging
INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
VALUES (NOW(), 'UpdatePosition: ' || _CharName || ' - ' || COALESCE(_MapName, 'None'), _CustomerGUID);
END
$$;

CREATE OR REPLACE PROCEDURE AccountSessionSetSelectedCharacter(_CustomerGUID UUID,
                                                            _AccountSessionGUID UUID,
                                                            _SelectedCharacterName VARCHAR(50)
)
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    UPDATE AccountSessions
    SET SelectedCharacterName=_SelectedCharacterName
    WHERE CustomerGUID = _CustomerGUID
      AND AccountSessionGUID = _AccountSessionGUID;
END
$$;

ALTER TABLE WorldServers
ADD ZoneServerGUID UUID NULL;

ALTER TABLE WorldServers
ADD CONSTRAINT AK_ZoneServers UNIQUE (CustomerGUID, ZoneServerGUID);

CREATE OR REPLACE PROCEDURE AddItem(
    -- Item fields
    _CustomerGUID UUID,
    _ItemName VARCHAR(50),
    _DisplayName VARCHAR(50),
    _DefaultVisualIdentity VARCHAR(50),
    _ItemWeight DECIMAL(18, 2),
    _ItemCanStack BOOLEAN,
    _ItemStackSize SMALLINT,
    _Tradeable BOOLEAN,
    _Examine TEXT,
    _Locked BOOLEAN,
    _DecayItem VARCHAR(50),
    _BequethStats BOOLEAN,
    _ItemValue INT,
    _ItemMesh VARCHAR(200),
    _MeshToUseForPickup VARCHAR(200),
    _TextureToUseForIcon VARCHAR(200),
    _ExtraDecals VARCHAR(2000),
    _PremiumCurrencyPrice INT,
    _FreeCurrencyPrice INT,
    _ItemTier INT,
    _ItemCode VARCHAR(50),
    _ItemDuration INT,
    _WeaponActorClass VARCHAR(200),
    _StaticMesh VARCHAR(200),
    _SkeletalMesh VARCHAR(200),
    _ItemQuality SMALLINT,
    _IconSlotWidth INT,
    _IconSlotHeight INT,
    _ItemMeshID INT,
    _CustomData VARCHAR(2000),

    -- Mappings input arrays
    _ActionIDs INT[],
    _TagIDs INT[],
    _StatIDs INT[],
    _StatValues VARCHAR[]
)
LANGUAGE PLPGSQL
AS $$
DECLARE
_NewItemID INT;
    i INT;
BEGIN
    -- Check if item already exists
    IF EXISTS (
        SELECT 1 FROM Items
        WHERE CustomerGUID = _CustomerGUID AND ItemName = _ItemName
    ) THEN
        RAISE EXCEPTION 'Item with name % already exists for this CustomerGUID', _ItemName;
END IF;

    -- Insert new item
INSERT INTO Items (
    CustomerGUID, ItemName, DisplayName, DefaultVisualIdentity,
    ItemWeight, ItemCanStack, ItemStackSize, Tradeable, Examine, Locked,
    DecayItem, BequethStats, ItemValue, ItemMesh, MeshToUseForPickup,
    TextureToUseForIcon, ExtraDecals, PremiumCurrencyPrice, FreeCurrencyPrice,
    ItemTier, ItemCode, ItemDuration, WeaponActorClass, StaticMesh,
    SkeletalMesh, ItemQuality, IconSlotWidth, IconSlotHeight, ItemMeshID, CustomData
)
VALUES (
           _CustomerGUID, _ItemName, _DisplayName, _DefaultVisualIdentity,
           _ItemWeight, _ItemCanStack, _ItemStackSize, _Tradeable, _Examine, _Locked,
           _DecayItem, _BequethStats, _ItemValue, _ItemMesh, _MeshToUseForPickup,
           _TextureToUseForIcon, _ExtraDecals, _PremiumCurrencyPrice, _FreeCurrencyPrice,
           _ItemTier, _ItemCode, _ItemDuration, _WeaponActorClass, _StaticMesh,
           _SkeletalMesh, _ItemQuality, _IconSlotWidth, _IconSlotHeight, _ItemMeshID, _CustomData
       )
    RETURNING ItemID INTO _NewItemID;

-- Insert Action Mappings
IF _ActionIDs IS NOT NULL THEN
        FOREACH i IN ARRAY _ActionIDs
        LOOP
            INSERT INTO ItemActionMappings (CustomerGUID, ItemID, ItemActionID)
            VALUES (_CustomerGUID, _NewItemID, i);
END LOOP;
END IF;

    -- Insert Tag Mappings
    IF _TagIDs IS NOT NULL THEN
        FOREACH i IN ARRAY _TagIDs
        LOOP
            INSERT INTO ItemTagMappings (CustomerGUID, ItemID, ItemTagID)
            VALUES (_CustomerGUID, _NewItemID, i);
END LOOP;
END IF;

    -- Insert Stat Mappings
    IF _StatIDs IS NOT NULL AND _StatValues IS NOT NULL THEN
        FOR i IN 1..array_length(_StatIDs, 1)
        LOOP
            INSERT INTO ItemStatMappings (CustomerGUID, ItemID, ItemStatID, StatValue)
            VALUES (_CustomerGUID, _NewItemID, _StatIDs[i], _StatValues[i]);
END LOOP;
END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE UpdateItem(
    -- Item fields
    _CustomerGUID UUID,
    _ItemID INT,
    _ItemName VARCHAR(50),
    _DisplayName VARCHAR(50),
    _ItemWeight DECIMAL(18, 2),
    _ItemStackSize SMALLINT,
    -- Mappings input arrays
    _ActionIDs INT[],
    _TagIDs INT[],
    _StatIDs INT[],
    _StatValues VARCHAR[]
)
LANGUAGE PLPGSQL
AS $$
DECLARE
i INT;
BEGIN
    -- Check if item exists
    IF NOT EXISTS (
        SELECT 1 FROM Items WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID
    ) THEN
        RAISE EXCEPTION 'Item with ID % does not exist', _ItemID;
END IF;

    -- Update item fields
UPDATE Items
SET ItemName = _ItemName,
    DisplayName = _DisplayName,
    ItemWeight = _ItemWeight,
    ItemStackSize = _ItemStackSize
WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;

-- Clear existing mappings
DELETE FROM ItemActionMappings WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;
DELETE FROM ItemTagMappings WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;
DELETE FROM ItemStatMappings WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;

-- Insert new Action Mappings
IF _ActionIDs IS NOT NULL THEN
        FOREACH i IN ARRAY _ActionIDs
        LOOP
            INSERT INTO ItemActionMappings (CustomerGUID, ItemID, ItemActionID)
            VALUES (_CustomerGUID, _ItemID, i);
END LOOP;
END IF;

    -- Insert new Tag Mappings
    IF _TagIDs IS NOT NULL THEN
        FOREACH i IN ARRAY _TagIDs
        LOOP
            INSERT INTO ItemTagMappings (CustomerGUID, ItemID, ItemTagID)
            VALUES (_CustomerGUID, _ItemID, i);
END LOOP;
END IF;

    -- Insert new Stat Mappings
    IF _StatIDs IS NOT NULL AND _StatValues IS NOT NULL THEN
        FOR i IN 1..array_length(_StatIDs, 1)
        LOOP
            INSERT INTO ItemStatMappings (CustomerGUID, ItemID, ItemStatID, StatValue)
            VALUES (_CustomerGUID, _ItemID, _StatIDs[i], _StatValues[i]);
END LOOP;
END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE DeleteItem(
    _CustomerGUID UUID,
    _ItemID INT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- Check if item exists
    IF NOT EXISTS (
        SELECT 1 FROM Items WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID
    ) THEN
        RAISE EXCEPTION 'Item with ID % does not exist for CustomerGUID %', _ItemID, _CustomerGUID;
END IF;

    -- Delete related mappings
DELETE FROM ItemActionMappings WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;
DELETE FROM ItemTagMappings WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;
DELETE FROM ItemStatMappings WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;

-- Delete the item
DELETE FROM Items
WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;
END;
$$;

CREATE OR REPLACE PROCEDURE AddOrUpdateAbility(_CustomerGUID UUID,
                                               _AbilityID INT,
                                               _AbilityName VARCHAR(50),
                                               _AbilityTypeID INT,
                                               _TextureToUseForIcon VARCHAR(200),
                                               _Class INT,
                                               _Race INT,
                                               _GameplayAbilityClassName VARCHAR(200),
                                               _AbilityCustomJSON TEXT)
    LANGUAGE PLPGSQL
AS
$$
BEGIN

    IF
        NOT EXISTS(SELECT
                   FROM Abilities AB
                   WHERE AB.CustomerGUID = _CustomerGUID
                     AND (AB.AbilityID = _AbilityID
                       OR AB.AbilityName = _AbilityName)
                       FOR UPDATE) THEN
        INSERT INTO Abilities (CustomerGUID, AbilityName, AbilityTypeID, TextureToUseForIcon, Class, Race,
                               GameplayAbilityClassName, AbilityCustomJSON)
        VALUES (_CustomerGUID, _AbilityName, _AbilityTypeID, _TextureToUseForIcon, _Class, _Race,
                _GameplayAbilityClassName, _AbilityCustomJSON);
    ELSE
        UPDATE Abilities AB
        SET AbilityName              = _AbilityName,
            AbilityTypeID            = _AbilityTypeID,
            TextureToUseForIcon      = _TextureToUseForIcon,
            Class                    = _Class,
            Race                     = _Race,
            GameplayAbilityClassName = _GameplayAbilityClassName,
            AbilityCustomJSON        = _AbilityCustomJSON
        WHERE AB.CustomerGUID = _CustomerGUID
          AND AB.AbilityID = _AbilityID;
    END IF;
END
$$;


CREATE OR REPLACE PROCEDURE AddOrUpdateAbilityType(_CustomerGUID UUID,
                                                   _AbilityTypeID INT,
                                                   _AbilityTypeName VARCHAR(50))
    LANGUAGE PLPGSQL
AS
$$
BEGIN

    IF
        NOT EXISTS(SELECT
                   FROM AbilityTypes ABT
                   WHERE ABT.CustomerGUID = _CustomerGUID
                     AND (ABT.AbilityTypeID = _AbilityTypeID
                       OR ABT.AbilityTypeName = _AbilityTypeName)
                       FOR UPDATE) THEN
        INSERT INTO AbilityTypes (CustomerGUID, AbilityTypeName)
        VALUES (_CustomerGUID, _AbilityTypeName);
    ELSE
        UPDATE AbilityTypes ABT
        SET AbilityTypeName = _AbilityTypeName
        WHERE ABT.CustomerGUID = _CustomerGUID
          AND ABT.AbilityTypeID = _AbilityTypeID;
    END IF;
END
$$;


CREATE OR REPLACE FUNCTION GetAbilityTypes(_CustomerGUID UUID)
    RETURNS TABLE
            (
                AbilityTypeID     INT,
                AbilityTypeName   VARCHAR(50),
                CustomerGUID      UUID,
                NumberOfAbilities INT
            )
    LANGUAGE SQL
AS
$$
SELECT *
     , (SELECT COUNT(*) FROM Abilities AB WHERE AB.AbilityTypeID = ABT.AbilityTypeID) AS NumberOfAbilities
FROM AbilityTypes ABT
WHERE ABT.CustomerGUID = _CustomerGUID
ORDER BY AbilityTypeName;
$$;


CREATE OR REPLACE PROCEDURE AddAbilityToCharacter(_CustomerGUID UUID,
                                                  _AbilityName VARCHAR(50),
                                                  _CharacterName VARCHAR(50),
                                                  _AbilityLevel INT,
                                                  _CharHasAbilitiesCustomJSON TEXT)
    LANGUAGE PLPGSQL
AS
$$
BEGIN
    IF NOT EXISTS(SELECT
                  FROM CharHasAbilities CHA
                           INNER JOIN CharacterData C
                                      ON C.CharacterID = CHA.CharacterID
                                          AND C.CustomerGUID = CHA.CustomerGUID
                           INNER JOIN Abilities A
                                      ON A.AbilityID = CHA.AbilityID
                                          AND A.CustomerGUID = CHA.CustomerGUID
                  WHERE CHA.CustomerGUID = _CustomerGUID
                    AND C.CharacterName = _CharacterName
                    AND A.AbilityName = _AbilityName FOR UPDATE) THEN
        INSERT INTO CharHasAbilities (CustomerGUID, CharacterID, AbilityID, AbilityLevel, CharHasAbilitiesCustomJSON)
        SELECT _CustomerGUID AS CustomerGUID,
               (SELECT C.CharacterID
                FROM CharacterData C
                WHERE C.CharacterName = _CharacterName AND C.CustomerGUID = _CustomerGUID
                LIMIT 1),
               (SELECT A.AbilityID
                FROM Abilities A
                WHERE A.AbilityName = _AbilityName AND A.CustomerGUID = _CustomerGUID
                LIMIT 1),
               _AbilityLevel,
               _CharHasAbilitiesCustomJSON;
    END IF;
END
$$;


CREATE OR REPLACE PROCEDURE AddNewCustomer(
    _CustomerName VARCHAR(50),
    _AccountName VARCHAR(100),
    _Email VARCHAR(256),
    _Password VARCHAR(256),
   _CustomerGUID UUID
)
LANGUAGE PLPGSQL
AS
$$
DECLARE
_AccountID UUID;
    _ClassID INT;
    _CharacterName VARCHAR(50) := 'TestCharacter';
    _CharacterID INT;
BEGIN
    IF _CustomerGUID IS NULL THEN
            _CustomerGUID := gen_random_uuid();
    END IF;
    -- Ensure the CustomerGUID is unique
    IF NOT EXISTS (
        SELECT
        FROM Customers
        WHERE CustomerGUID = _CustomerGUID
    ) THEN
        -- Insert into Customers
        INSERT INTO Customers (CustomerGUID, CustomerName, CustomerEmail, CustomerPhone, CustomerNotes, EnableDebugLogging)
        VALUES (_CustomerGUID, _CustomerName, _Email, '', '', TRUE);

        -- Insert default WorldSettings
INSERT INTO WorldSettings (CustomerGUID, StartTime)
SELECT _CustomerGUID, CAST(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) AS BIGINT)
FROM Customers C
WHERE C.CustomerGUID = _CustomerGUID;

-- Add a new account using AddAccount and retrieve AccountID
SELECT AccountID
FROM AddAccount(
        _CustomerGUID,
        _AccountName,
        _Email,
        _Password,
        'DefaultTosVersion',
        'Developer'
     )
    INTO _AccountID;

-- Insert default item actions
    INSERT INTO ItemActions (CustomerGUID, ActionName)
    VALUES
        (_CustomerGUID, 'Drop'),
        (_CustomerGUID, 'Use'),
        (_CustomerGUID, 'Equip'),
        (_CustomerGUID, 'Delete'),
        (_CustomerGUID, 'Examine'),
        (_CustomerGUID, 'Click'),
        (_CustomerGUID, 'Craft'),
        (_CustomerGUID, 'Select'),
        (_CustomerGUID, 'Eat'),
        (_CustomerGUID, 'Take'),
        (_CustomerGUID, 'Add'),
        (_CustomerGUID, 'Nothing'),
        (_CustomerGUID, 'Place'),
        (_CustomerGUID, 'Remove Bait'),
        (_CustomerGUID, 'Offer Item'),
        (_CustomerGUID, 'Offer 5'),
        (_CustomerGUID, 'Offer 10'),
        (_CustomerGUID, 'Offer All'),
        (_CustomerGUID, 'Reclaim'),
        (_CustomerGUID, 'Return'),
        (_CustomerGUID, 'Unequip'),
        (_CustomerGUID, 'Drink');

-- Insert default item tags
    INSERT INTO ItemTags (CustomerGUID, TagName)
        VALUES
        (_CustomerGUID, 'RawShellfish'),
        (_CustomerGUID, 'RawFish'),
        (_CustomerGUID, 'FreshwaterFish'),
        (_CustomerGUID, 'SaltwaterFish'),
        (_CustomerGUID, 'BrackishwaterFish'),
        (_CustomerGUID, 'FishingTool'),
        (_CustomerGUID, 'FishingBait'),
        (_CustomerGUID, 'Net'),
        (_CustomerGUID, 'Log'),
        (_CustomerGUID, 'Softwood'),
        (_CustomerGUID, 'Ingredient'),
        (_CustomerGUID, 'Food'),
        (_CustomerGUID, 'Soup'),
        (_CustomerGUID, 'Pottage'),
        (_CustomerGUID, 'SoupBase'),
        (_CustomerGUID, 'Bowl'),
        (_CustomerGUID, 'CookedMeat'),
        (_CustomerGUID, 'RawMeat'),
        (_CustomerGUID, 'RawBeef'),
        (_CustomerGUID, 'RawPork'),
        (_CustomerGUID, 'RawLamb'),
        (_CustomerGUID, 'Vegetable'),
        (_CustomerGUID, 'RootVegetable'),
        (_CustomerGUID, 'Pork'),
        (_CustomerGUID, 'Beef'),
        (_CustomerGUID, 'Lamb'),
        (_CustomerGUID, 'AnimalFat'),
        (_CustomerGUID, 'Stew'),
        (_CustomerGUID, 'BeefFat'),
        (_CustomerGUID, 'Spice'),
        (_CustomerGUID, 'Herb'),
        (_CustomerGUID, 'CookingFuel'),
        (_CustomerGUID, 'Flour'),
        (_CustomerGUID, 'Bread'),
        (_CustomerGUID, 'Dairy'),
        (_CustomerGUID, 'None'),
        (_CustomerGUID, 'Currency'),
        (_CustomerGUID, 'HelmetSlot'),
        (_CustomerGUID, 'ChestSlot'),
        (_CustomerGUID, 'LegsSlot'),
        (_CustomerGUID, 'GlovesSlot'),
        (_CustomerGUID, 'BootsSlot'),
        (_CustomerGUID, 'WeaponSlot'),
        (_CustomerGUID, 'Ore'),
        (_CustomerGUID, 'Fruit'),
        (_CustomerGUID, 'Berry'),
        (_CustomerGUID, 'Milk'),
        (_CustomerGUID, 'Egg'),
        (_CustomerGUID, 'Pie'),
        (_CustomerGUID, 'GameMeat'),
        (_CustomerGUID, 'GameBird'),
        (_CustomerGUID, 'StoneFruit'),
        (_CustomerGUID, 'RawGameMeat'),
        (_CustomerGUID, 'RawGameBird'),
        (_CustomerGUID, 'CookedFish'),
        (_CustomerGUID, 'CookedShellFish');

-- Insert default item stats
    INSERT INTO ItemStats (CustomerGUID, StatName)
        VALUES
        (_CustomerGUID, 'PasteBait'),
        (_CustomerGUID, 'WormBait'),
        (_CustomerGUID, 'CrabBait'),
        (_CustomerGUID, 'ShrimpBait'),
        (_CustomerGUID, 'MinnowBait'),
        (_CustomerGUID, 'FlyBait'),
        (_CustomerGUID, 'Size'),
        (_CustomerGUID, 'Flavor'),
        (_CustomerGUID, 'Heal'),
        (_CustomerGUID, 'FoodPrefix'),
        (_CustomerGUID, 'EatTime'),
        (_CustomerGUID, 'DecalSorrelSalmon'),
        (_CustomerGUID, 'DecalSoupStewBread'),
        (_CustomerGUID, 'Purity');

-- Insert default maps
INSERT INTO Maps (CustomerGUID, MapName, ZoneName, MapData, Width, Height)
VALUES
    (_CustomerGUID, 'NewEuropa', 'NewEuropa', NULL, 1, 1),
    (_CustomerGUID, 'Map2', 'Map2', NULL, 1, 1),
    (_CustomerGUID, 'DungeonMap', 'DungeonMap', NULL, 1, 1),
    (_CustomerGUID, 'FourZoneMap', 'Zone1', NULL, 1, 1),
    (_CustomerGUID, 'FourZoneMap', 'Zone2', NULL, 1, 1);

-- Insert a default class
INSERT INTO Class (CustomerGUID, ClassName, StartingMapName, X, Y, Z, RX, RY, RZ, TeamNumber, Thirst, Hunger, Gold, Score,
                   CharacterLevel, Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health, HealthRegenRate, MaxMana, Mana,
                   ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate, MaxFatigue, Fatigue, FatigueRegenRate, MaxStamina, Stamina,
                   StaminaRegenRate, MaxEndurance, Endurance, EnduranceRegenRate, Strength, Dexterity, Constitution, Intellect,
                   Wisdom, Charisma, Agility, Fortitude, Reflex, Willpower, BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed,
                   CritChance, CritMultiplier, Haste, SpellPower, SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility,
                   Multishot, Initiative, NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed,
                   Range, Speed, Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, Description)
VALUES
    (_CustomerGUID, 'Warrior', 'NewEuropa', 0, 0, 250, 0, 0, 0, 0, 0, 0, 100, 0, 1, 0, 10, 0, 1, 0, 100, 50, 0, 100, 0,
     1, 100, 0, 5, 100, 0, 1, 0, 0, 10, 10, 10, 10, 10, 0, 1, 1, 1, 5, 0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10,
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '');

-- Retrieve ClassID
_ClassID := CURRVAL(PG_GET_SERIAL_SEQUENCE('class', 'classid'));

        -- Insert a character for the account
INSERT INTO CharacterData (CustomerGUID, ClassID, AccountID, CharacterName, MapName, X, Y, Z, RX, RY, RZ, Fishing,
                           Mining, Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring, Hunting,
                           Leatherworking, Farming, Herblore, Spirit, Magic, TeamNumber, Thirst, Hunger, Gold,
                           Score, CharacterLevel, Gender, XP, HitDie, Wounds, Size, Weight, MaxHealth, Health,
                           HealthRegenRate, MaxMana, Mana, ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate,
                           MaxFatigue, Fatigue, FatigueRegenRate, MaxStamina, Stamina, StaminaRegenRate,
                           MaxEndurance, Endurance, EnduranceRegenRate, Strength, Dexterity, Constitution,
                           Intellect, Wisdom, Charisma, Agility, Fortitude, Reflex, Willpower, BaseAttack,
                           BaseAttackBonus, AttackPower, AttackSpeed, CritChance, CritMultiplier, Haste, SpellPower,
                           SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility, Multishot, Initiative,
                           NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed,
                           Range, Speed, Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, Description)
SELECT _CustomerGUID, _ClassID, _AccountID, _CharacterName, StartingMapName, X, Y, Z, RX, RY, RZ, Fishing, Mining,
       Woodcutting, Smelting, Smithing, Cooking, Fletching, Tailoring, Hunting, Leatherworking, Farming, Herblore,
       Spirit, Magic, TeamNumber, Thirst, Hunger, Gold, Score, CharacterLevel, Gender, XP, HitDie, Wounds, Size,
    Weight, MaxHealth, Health, HealthRegenRate, MaxMana, Mana, ManaRegenRate, MaxEnergy, Energy, EnergyRegenRate,
    MaxFatigue, Fatigue, FatigueRegenRate, MaxStamina, Stamina, StaminaRegenRate, MaxEndurance, Endurance,
    EnduranceRegenRate, Strength, Dexterity, Constitution, Intellect, Wisdom, Charisma, Agility, Fortitude,
    Reflex, Willpower, BaseAttack, BaseAttackBonus, AttackPower, AttackSpeed, CritChance, CritMultiplier, Haste,
    SpellPower, SpellPenetration, Defense, Dodge, Parry, Avoidance, Versatility, Multishot, Initiative,
    NaturalArmor, PhysicalArmor, BonusArmor, ForceArmor, MagicArmor, Resistance, ReloadSpeed, Range, Speed,
    Silver, Copper, FreeCurrency, PremiumCurrency, Fame, Alignment, Description
FROM Class
WHERE ClassID = _ClassID;

-- Retrieve CharacterID
_CharacterID := CURRVAL(PG_GET_SERIAL_SEQUENCE('characterdata', 'characterid'));

        -- Insert default inventory for the character
INSERT INTO CharInventory (CustomerGUID, CharacterID, InventoryName, InventorySize)
VALUES (_CustomerGUID, _CharacterID, 'Bag', 16);
ELSE
        RAISE EXCEPTION 'Duplicate Customer GUID: %', _CustomerGUID;
END IF;
END
$$;


CREATE OR REPLACE FUNCTION JoinMapByCharName(_CustomerGUID UUID,
                                             _CharName VARCHAR(50),
                                             _ZoneName VARCHAR(50),
                                             _PlayerGroupType INT)
    RETURNS TABLE
            (
                ServerIP           VARCHAR(50),
                WorldServerID      INT,
                WorldServerIP      VARCHAR(50),
                WorldServerPort    INT,
                Port               INT,
                MapInstanceID      INT,
                MapNameToStart     VARCHAR(50),
                MapInstanceStatus  INT,
                NeedToStartUpMap   BOOLEAN,
                EnableAutoLoopBack BOOLEAN,
                NoPortForwarding   BOOLEAN
            )
    LANGUAGE PLPGSQL
AS
$$
DECLARE
    _MapID                     INT;
    _MapNameToStart            VARCHAR(50);
    _CharacterID               INT;
    _Email                     VARCHAR(255);
    _SoftPlayerCap             INT;
    _PlayerGroupID             INT;
    _ServerIP                  VARCHAR(50);
    _WorldServerID             INT;
    _WorldServerIP             VARCHAR(50);
    _WorldServerPort           INT;
    _Port                      INT;
    _MapInstanceID             INT;
    _MapInstanceStatus         INT;
    _NeedToStartUpMap          BOOLEAN;
    _EnableAutoLoopBack        BOOLEAN;
    _NoPortForwarding          BOOLEAN;
    _IsInternalNetworkTestUser BOOLEAN := FALSE;
    _ErrorRaised               BOOLEAN := FALSE;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS temp_table
    (
        ServerIP           VARCHAR(50),
        WorldServerID      INT,
        WorldServerIP      VARCHAR(50),
        WorldServerPort    INT,
        Port               INT,
        MapInstanceID      INT,
        MapNameToStart     VARCHAR(50),
        MapInstanceStatus  INT,
        NeedToStartUpMap   BOOLEAN,
        EnableAutoLoopBack BOOLEAN,
        NoPortForwarding   BOOLEAN
    ) ON COMMIT DROP;

    --Run Cleanup here for now.  Later this can get moved to a scheduler to run periodically.
    CALL CleanUp(_CustomerGUID);

    INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
    VALUES (NOW(), 'JoinMapByCharName: ' || _ZoneName || ' - ' || _CharName, _CustomerGUID);

    SELECT M.MapID, M.MapName, M.SoftPlayerCap
    INTO _MapID, _MapNameToStart, _SoftPlayerCap
    FROM Maps M
    WHERE M.ZoneName = _ZoneName
      AND M.CustomerGUID = _CustomerGUID;

    SELECT C.CharacterID, C.IsInternalNetworkTestUser, C.Email
    INTO _CharacterID, _IsInternalNetworkTestUser, _Email
    FROM CharacterData C
    WHERE C.CharacterName = _CharName
      AND C.CustomerGUID = _CustomerGUID;

    IF (_CharacterID IS NULL) THEN
        INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
        VALUES (NOW(), 'JoinMapByCharName: CharacterID is NULL!', _CustomerGUID);

        _NeedToStartUpMap := 0;
        _ErrorRaised := TRUE;
    END IF;

    IF _ErrorRaised = FALSE THEN
        SELECT C.EnableAutoLoopBack, C.NoPortForwarding
        INTO _EnableAutoLoopBack, _NoPortForwarding
        FROM Customers C
        WHERE C.CustomerGUID = _CustomerGUID;
    END IF;

    IF _ErrorRaised = FALSE AND (_PlayerGroupType > 0) THEN
        SELECT COALESCE(PG.PlayerGroupID, 0)
        FROM PlayerGroupCharacters PGC
                 INNER JOIN PlayerGroup PG
                            ON PG.PlayerGroupID = PGC.PlayerGroupID
        WHERE PGC.CustomerGUID = _CustomerGUID
          AND PGC.CharacterID = _CharacterID
          AND PG.PlayerGroupTypeID = _PlayerGroupType
        INTO _PlayerGroupID;
    END IF;

    IF _ErrorRaised = FALSE THEN
        SELECT (CASE
                    WHEN _IsInternalNetworkTestUser = TRUE THEN WS.InternalServerIP
                    ELSE WS.ServerIP END) AS ServerIp,
               WS.InternalServerIP,
               WS.Port                    AS WSPort,
               MI.Port                    AS MIPort,
               MI.MapInstanceID,
               WS.WorldServerID,
               MI.Status
        INTO _ServerIP, _WorldServerIP, _WorldServerPort, _Port, _MapInstanceID, _WorldServerID, _MapInstanceStatus
        FROM WorldServers WS
                 LEFT JOIN MapInstances MI
                           ON MI.WorldServerID = WS.WorldServerID
                               AND MI.CustomerGUID = WS.CustomerGUID
                 LEFT JOIN CharOnMapInstance CMI
                           ON CMI.MapInstanceID = MI.MapInstanceID
                               AND CMI.CustomerGUID = MI.CustomerGUID
        WHERE MI.MapID = _MapID
          AND WS.ActiveStartTime IS NOT NULL
          AND WS.CustomerGUID = _CustomerGUID
          AND MI.NumberOfReportedPlayers < _SoftPlayerCap
          AND (MI.PlayerGroupID = _PlayerGroupID OR COALESCE(_PlayerGroupID,0) = 0) --Only lookup map instances that match the player group fro this Player Group Type or lookup all if zero
          AND MI.Status = 2
        GROUP BY MI.MapInstanceID, WS.ServerIP, MI.Port, WS.WorldServerID, WS.InternalServerIP, WS.Port, MI.Status
        ORDER BY COUNT(DISTINCT CMI.CharacterID);


        --There is a map already running to connect to
        IF _MapInstanceID IS NOT NULL THEN
            /*IF (POSITION('\@localhost' IN _Email) > 0) THEN
                _ServerIP := '127.0.0.1';
            END IF;*/

            _NeedToStartUpMap := FALSE;

            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(), 'Joined Existing Map: ' || COALESCE(_ZoneName, '') || ' - ' || COALESCE(_CharName, '') ||
                           ' - ' || COALESCE(_ServerIP, ''),
                    _CustomerGUID);
        ELSE --Spin up a new map

            SELECT *
            FROM SpinUpMapInstance(_CustomerGUID, _ZoneName, _PlayerGroupID)
            INTO _ServerIP , _WorldServerID , _WorldServerIP , _WorldServerPort , _Port, _MapInstanceID;

            /*IF (POSITION('@localhost' IN _Email) > 0 OR _IsInternalNetworkTestUser = TRUE) THEN
                _ServerIP := '127.0.0.1';
            END IF;*/

            _NeedToStartUpMap := TRUE;

            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(),
                    'SpinUpMapInstance returned: ' || COALESCE(_ZoneName, '') || ' CharName: ' ||
                    COALESCE(_CharName, '') || ' ServerIP: ' ||
                    COALESCE(_ServerIP, '') ||
                    ' WorldServerPort: ' || CAST(COALESCE(_WorldServerPort, -1) AS VARCHAR), _CustomerGUID);


            INSERT INTO DebugLog (DebugDate, DebugDesc, CustomerGUID)
            VALUES (NOW(),
                    'JoinMapByCharName returned: ' || COALESCE(_MapNameToStart, '[NoMapName]') || ' MapInstanceID: ' ||
                    CAST(COALESCE(_MapInstanceID, -1) AS VARCHAR) || ' MapInstanceStatus: ' ||
                    CAST(COALESCE(_MapInstanceStatus, -1) AS VARCHAR) || ' NeedToStartUpMap: ' ||
                    CAST(_NeedToStartUpMap AS VARCHAR) || ' EnableAutoLoopBack: ' ||
                    CAST(_EnableAutoLoopBack AS VARCHAR) ||
                    ' ServerIP: ' || COALESCE(_ServerIP, '') || ' WorldServerIP: ' || COALESCE(_WorldServerIP, ''),
                    _CustomerGUID);
        END IF;
    END IF;
    INSERT INTO temp_table(ServerIP, WorldServerID, WorldServerIP, WorldServerPort, Port, MapInstanceID, MapNameToStart,
                           MapInstanceStatus, NeedToStartUpMap, EnableAutoLoopBack, NoPortForwarding)
    VALUES (_ServerIP, _WorldServerID, _WorldServerIP, _WorldServerPort, _Port, _MapInstanceID, _MapNameToStart,
            _MapInstanceStatus, _NeedToStartUpMap, _EnableAutoLoopBack, _NoPortForwarding);
    RETURN QUERY SELECT * FROM temp_table;
END;
$$;

CREATE OR REPLACE FUNCTION AddItemToInventory(
    _CustomerGUID UUID,
    _CharInventoryID INT,
    _ItemID INT,
    _Quantity INT
)
RETURNS TABLE(item_id INT, remaining_quantity INT)
LANGUAGE plpgsql
AS $$
DECLARE
_ItemExists BOOLEAN;
    _ItemCanStack BOOLEAN;
    _StackSize INT;
    _CurrentQuantity INT;
    _SlotToUse INT;
    _RemainingQuantity INT;
BEGIN
    -- 1. Validate if the item exists
    _ItemExists := ValidateItemExistence(_CustomerGUID, _ItemID);
    IF NOT _ItemExists THEN
        RAISE EXCEPTION 'Item does not exist for ItemID: %', _ItemID;
END IF;

    -- 2. Check if item is stackable
SELECT ItemCanStack, ItemStackSize INTO _ItemCanStack, _StackSize
FROM Items
WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;

-- Initialize remaining quantity
_RemainingQuantity := _Quantity;

    -- 3. Handle existing stacks
FOR _SlotToUse IN
SELECT InSlotNumber
FROM CharInventoryItems
WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID AND ItemID = _ItemID
ORDER BY InSlotNumber
    LOOP
SELECT Quantity INTO _CurrentQuantity
FROM CharInventoryItems
WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID AND InSlotNumber = _SlotToUse;

IF _CurrentQuantity < _StackSize THEN
            IF _CurrentQuantity + _RemainingQuantity <= _StackSize THEN
UPDATE CharInventoryItems
SET Quantity = Quantity + _RemainingQuantity
WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID AND InSlotNumber = _SlotToUse;
_RemainingQuantity := 0;
                EXIT;
ELSE
UPDATE CharInventoryItems
SET Quantity = _StackSize
WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID AND InSlotNumber = _SlotToUse;
_RemainingQuantity := _RemainingQuantity - (_StackSize - _CurrentQuantity);
END IF;
END IF;
END LOOP;

    -- 4. Handle empty slots
    WHILE _RemainingQuantity > 0 LOOP
SELECT COALESCE(MIN(InSlotNumber), -1) INTO _SlotToUse
FROM (
         SELECT generate_series(0, (SELECT InventorySize FROM CharInventory WHERE CharInventoryID = _CharInventoryID) - 1) AS InSlotNumber
     ) t
WHERE InSlotNumber NOT IN (
    SELECT InSlotNumber
    FROM CharInventoryItems
    WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID
);

IF _SlotToUse = -1 THEN
            -- No more empty slots available
            RETURN QUERY SELECT _ItemID, _RemainingQuantity;
EXIT;
END IF;

        IF _RemainingQuantity <= _StackSize THEN
            INSERT INTO CharInventoryItems (
                CustomerGUID, CharInventoryID, ItemID, InSlotNumber, Quantity
            ) VALUES (
                _CustomerGUID, _CharInventoryID, _ItemID, _SlotToUse, _RemainingQuantity
            );
            _RemainingQuantity := 0;
ELSE
            INSERT INTO CharInventoryItems (
                CustomerGUID, CharInventoryID, ItemID, InSlotNumber, Quantity
            ) VALUES (
                _CustomerGUID, _CharInventoryID, _ItemID, _SlotToUse, _StackSize
            );
            _RemainingQuantity := _RemainingQuantity - _StackSize;
END IF;
END LOOP;

    -- 5. Return rows only if remaining quantity is greater than 0
    IF _RemainingQuantity > 0 THEN
        RETURN QUERY SELECT _ItemID, _RemainingQuantity;
END IF;

    -- 6. Return no rows if remaining quantity is zero
    RETURN;
END;
$$;

CREATE OR REPLACE FUNCTION AddItemToInventoryByIndex(
    _CustomerGUID UUID,
    _CharInventoryID INT,
    _ItemID INT,
    _Quantity INT,
    _SlotIndex INT
)
RETURNS TABLE(item_id INT, remaining_quantity INT)
LANGUAGE plpgsql
AS $$
DECLARE
    _ItemExists BOOLEAN;
    _ItemCanStack BOOLEAN;
    _StackSize INT;
    _CurrentQuantity INT;
    _RemainingQuantity INT;
    _InventorySize INT;
    _SlotOccupied BOOLEAN;
    _ExistingItemID INT;
BEGIN
    -- 1. Validate if the item exists
    _ItemExists := ValidateItemExistence(_CustomerGUID, _ItemID);
    IF NOT _ItemExists THEN
        RAISE EXCEPTION 'Item does not exist for ItemID: %', _ItemID;
    END IF;

    -- 2. Check if the slot index is valid
    SELECT InventorySize INTO _InventorySize
    FROM CharInventory
    WHERE CharInventoryID = _CharInventoryID;

    IF _SlotIndex < 0 OR _SlotIndex >= _InventorySize THEN
            RAISE EXCEPTION 'Invalid slot index: %. Must be between 0 and %.', _SlotIndex, _InventorySize - 1;
    END IF;

    -- 3. Check if the slot is occupied and the item in the slot
    SELECT ItemID, Quantity INTO _ExistingItemID, _CurrentQuantity
    FROM CharInventoryItems
    WHERE CustomerGUID = _CustomerGUID
      AND CharInventoryID = _CharInventoryID
      AND InSlotNumber = _SlotIndex;

    IF FOUND THEN
        -- Slot is occupied; check if it's the same item
        IF _ExistingItemID = _ItemID THEN
            -- Stackable logic for the same item
            SELECT ItemCanStack, ItemStackSize INTO _ItemCanStack, _StackSize
            FROM Items
            WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;

        IF NOT _ItemCanStack THEN
                        RAISE EXCEPTION 'Slot % is occupied by a non-stackable item.', _SlotIndex;
        END IF;

        IF _CurrentQuantity < _StackSize THEN
            -- Calculate how much can be added
            IF _CurrentQuantity + _Quantity <= _StackSize THEN
                UPDATE CharInventoryItems
                SET Quantity = Quantity + _Quantity
                WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID AND InSlotNumber = _SlotIndex;

                _RemainingQuantity := 0;
            ELSE
                UPDATE CharInventoryItems
                SET Quantity = _StackSize
                WHERE CustomerGUID = _CustomerGUID AND CharInventoryID = _CharInventoryID AND InSlotNumber = _SlotIndex;

                _RemainingQuantity := _Quantity - (_StackSize - _CurrentQuantity);
            END IF;
                
                -- 5. Return rows only if remaining quantity is greater than 0
                IF _RemainingQuantity > 0 THEN
                    RETURN QUERY SELECT _ItemID, _RemainingQuantity;
                END IF;
                
                RETURN;
            ELSE
                -- Slot is already at max capacity
                RETURN QUERY SELECT _ItemID, _Quantity;
                RETURN;
        END IF;
    ELSE
            -- Slot is occupied by a different item
            RAISE EXCEPTION 'Slot % is occupied by a different item.', _SlotIndex;
END IF;
END IF;

    -- 4. Slot is empty, insert the item
SELECT ItemCanStack, ItemStackSize INTO _ItemCanStack, _StackSize
FROM Items
WHERE CustomerGUID = _CustomerGUID AND ItemID = _ItemID;

_RemainingQuantity := _Quantity;

    IF _ItemCanStack THEN
        IF _Quantity <= _StackSize THEN
            INSERT INTO CharInventoryItems (
                CustomerGUID, CharInventoryID, ItemID, InSlotNumber, Quantity
            ) VALUES (
                _CustomerGUID, _CharInventoryID, _ItemID, _SlotIndex, _Quantity
            );
            _RemainingQuantity := 0;
        ELSE
            INSERT INTO CharInventoryItems (
                CustomerGUID, CharInventoryID, ItemID, InSlotNumber, Quantity
            ) VALUES (
                _CustomerGUID, _CharInventoryID, _ItemID, _SlotIndex, _StackSize
            );
            _RemainingQuantity := _Quantity - _StackSize;
        END IF;
    ELSE
        -- Non-stackable item
        IF _Quantity = 1 THEN
            INSERT INTO CharInventoryItems (
                CustomerGUID, CharInventoryID, ItemID, InSlotNumber, Quantity
            ) VALUES (
                _CustomerGUID, _CharInventoryID, _ItemID, _SlotIndex, 1
            );
            _RemainingQuantity := 0;
        ELSE
            RAISE EXCEPTION 'Non-stackable items must have a quantity of 1. Provided: %.', _Quantity;
    END IF;
END IF;

    -- 5. Return remaining quantity (if any)
    IF _RemainingQuantity > 0 THEN
       RETURN QUERY SELECT _ItemID, _RemainingQuantity;
    END IF;
    
    RETURN;
END;
$$;




INSERT INTO OWSVersion (OWSDBVersion) VALUES('20230304');