CALL AddItem(
    '00000001-0001-0001-0001-000000000001'::UUID, -- _CustomerGUID
    'Sword of Light'::VARCHAR,                   -- _ItemName
    'Radiant Sword'::VARCHAR,                   -- _DisplayName
    'VisualIdentity1'::VARCHAR,                 -- _DefaultVisualIdentity
    2.5::DECIMAL,                               -- _ItemWeight
    TRUE::BOOLEAN,                              -- _ItemCanStack
    10::SMALLINT,                               -- _ItemStackSize
    TRUE::BOOLEAN,                              -- _Tradeable
    'A powerful glowing sword'::TEXT,           -- _Examine
    FALSE::BOOLEAN,                             -- _Locked
    'DecayType1'::VARCHAR,                      -- _DecayItem
    FALSE::BOOLEAN,                             -- _BequethStats
    100::INT,                                   -- _ItemValue
    'ItemMesh1'::VARCHAR,                       -- _ItemMesh
    'PickupMesh1'::VARCHAR,                     -- _MeshToUseForPickup
    'IconTexture1'::VARCHAR,                    -- _TextureToUseForIcon
    'DecalsData'::VARCHAR,                      -- _ExtraDecals
    1000::INT,                                  -- _PremiumCurrencyPrice
    500::INT,                                   -- _FreeCurrencyPrice
    3::INT,                                     -- _ItemTier
    'ITEM123'::VARCHAR,                         -- _ItemCode
    86400::INT,                                 -- _ItemDuration
    'WeaponClass1'::VARCHAR,                    -- _WeaponActorClass
    'StaticMesh1'::VARCHAR,                     -- _StaticMesh
    'SkeletalMesh1'::VARCHAR,                   -- _SkeletalMesh
    5::SMALLINT,                                -- _ItemQuality
    2::INT,                                     -- _IconSlotWidth
    2::INT,                                     -- _IconSlotHeight
    123::INT,                                   -- _ItemMeshID
    'CustomData1'::VARCHAR,                     -- _CustomData
    '{1,2,3}'::INT[],                           -- _ActionIDs
    '{4,5,6}'::INT[],                           -- _TagIDs
    '{7,8,9}'::INT[],                           -- _StatIDs
    '{10,20,30}'::VARCHAR[]                     -- _StatValues
);
