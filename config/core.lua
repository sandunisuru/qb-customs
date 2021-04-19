Config = Config or {}

-- the derailCard position on the top of the screen (0 = right, 1 = left)
Config.detailCardMenuPosition = 0

-- the cash amount position on the top of the screen (0 = right, 1 = left)
Config.cashPosition = 0

-- if this turned off every mechanic position will be able to to cosmetics and upgrades otherwise only whitelist job can do upgrades 
Config.IsUpgradesOnlyForWhitelistJobPoints = true

-- The key to access the mechanic menu, the key code and the name can be found here: https://docs.fivem.net/docs/game-references/controls/
Config.Keys = {
    action = {key = 38, label = 'E', name = '~INPUT_PICKUP~'}
}

-- The default values access disrance from position if "Config.Positions" misses the value actionDistance
Config.DefaultActionDistance = 8.0

-- The default values for the blip if "Config.Positions" misses the value "blip = {}"
Config.DefaultBlip = {
    enable = true,
    type = 72,
    color = 0,
    title = 'Mechanic',
    scale = 0.5
}

-- Add or remove position for mechanic access points
-- pisition without "whitelistJobName" will be open for anyone and the price will have the multiple of "Config.PriceMultiplierWithoutTheJob" in "config/prices.lua"
-- if any position miss the "blip = {}" will be the default as seen above "Config.DefaultBlip"
-- if any position miss the "actionDistance" will be the default as seen above "Config.DefaultActionDistance"
Config.Positions = {
    { -- bennys
        pos = {x = -338.93, y = -135.96, z = 38.33},
        whitelistJobName = 'mechanic',
        blip = {
            enable = true,
            type = 72,
            color = 0,
            title = 'Bennys',
            scale = 0.5
        },
        actionDistance = 7.0
    },
--[[     { -- ls customs
        pos = {x = -338.93, y = -135.96, z = 38.33}
    }, ]]
    { -- paleto
        pos = {x = 110.89, y = 6626.35, z = 31.10}
    },
    { -- root 68
        pos = {x = 1174.93, y = 2639.62, z = 37.07}
    }
}
