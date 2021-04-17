--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

Config = Config or {}

Config.Menus = {
    ['empty'] = {
        title = '',
        options = {},
    },
    ['main'] = {
        title = '',
        options = {
            {label = 'Repair', img = 'img/icons/repair.png', price = Config.VehicleRepairPrice, onSelect = function() repairtVehicle(customVehicle) end},
            {label = 'Visual', img = 'img/icons/visual.png', openSubMenu = 'visual'},
            {label = 'Upgrade', img = 'img/icons/upgrade.png', openSubMenu = 'upgrade'}
        },
        onBack = function() closeUI(1) end,
        defaultOption = 1
    },
        ['upgrade'] = {
            title = 'UPGRADES',
            options = {
                {label = 'Engine', img = 'img/icons/engine.png', modType = 11, priceMult = Config.VehicleCustomisePriceMultiplier['engine']},
                {label = 'Brakes', img = 'img/icons/brakes.png', modType = 12, priceMult = Config.VehicleCustomisePriceMultiplier['brakes']},
                {label = 'Transmission', img = 'img/icons/transmission.png', modType = 13, priceMult = Config.VehicleCustomisePriceMultiplier['transmission']},
                {label = 'Suspension', img = 'img/icons/suspension.png', modType = 15, priceMult = Config.VehicleCustomisePriceMultiplier['suspension']},
                {label = 'Armor', img = 'img/icons/armor.png', modType = 16, priceMult = Config.VehicleCustomisePriceMultiplier['armor']},
                {label = 'Turbo', img = 'img/icons/engine.png', modType = 18, priceMult = Config.VehicleCustomisePriceMultiplier['turbo']},
            },
            onBack = function() updateMenu('main') end
        },
        ['visual'] = {
            title = 'VISUALS',
            options = {
                {label = 'Body Part', img = 'img/icons/body.png', openSubMenu = 'body_parts'},
                {label = 'Inside Part', img = 'img/icons/body.png', openSubMenu = 'inside_parts'},
                {label = 'Respray', img = 'img/icons/respray.png', openSubMenu = 'respray'},
                {label = 'Wheel', img = 'img/icons/wheel.png', openSubMenu = 'wheels', onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', {x = -1.8, y = 0.0, z = 0.0}, {x = 0.0, y = 0.0, z = -20.0})
                end},
                {label = 'Plate', img = 'img/icons/plate.png', openSubMenu = 'plate'},
                {label = 'Lights', img = 'img/icons/headlights.png', openSubMenu = 'lights'},
                {label = 'Sticker', img = 'img/icons/respray.png', openSubMenu = 'stickers'},
                {label = 'Extra', img = 'img/icons/plus.png', modType = 'extras', priceMult = Config.VehicleCustomisePriceMultiplier['extras']},
                {label = 'Window Tint', img = 'img/icons/door.png', modType = 'windowTint', priceMult = Config.VehicleCustomisePriceMultiplier['windowTint'], onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'window_lf', {x = -2.0, y = 0.0, z = 0.0}, {x = 0.0, y = 0.0, z = -10.0})
                end, onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end},
                {label = 'Horn', img = 'img/icons/horn.png', modType = 14, priceMult = Config.VehicleCustomisePriceMultiplier['horn']},
                {label = 'Speakers', img = 'img/icons/speaker.png', modType = 36, priceMult = Config.VehicleCustomisePriceMultiplier['speakers']},
                {label = 'Trunk', img = 'img/icons/trunk.png', modType = 37, priceMult = Config.VehicleCustomisePriceMultiplier['trunk'], onSelect = function() openDoors(customVehicle, {0,0,0,0,0,1,1}) end},
                {label = 'Hydrulics', img = 'img/icons/hydrulics.png', modType = 38, priceMult = Config.VehicleCustomisePriceMultiplier['hydrulics']},
                {label = 'Engine Block', img = 'img/icons/engine_block.png', modType = 39, priceMult = Config.VehicleCustomisePriceMultiplier['engine_block'], onSelect = function() openDoors(customVehicle, {0,0,0,0,1,0,0}) end},
                {label = 'Air Filter', img = 'img/icons/air_filter.png', modType = 40, priceMult = Config.VehicleCustomisePriceMultiplier['air_filter']},
                {label = 'Struts', img = 'img/icons/suspension.png', modType = 41, priceMult = Config.VehicleCustomisePriceMultiplier['struts']},
                {label = 'Tank', img = 'img/icons/gas_tank.png', modType = 45, priceMult = Config.VehicleCustomisePriceMultiplier['tank']},
            },
            onBack = function() updateMenu('main') end
        },
            ['body_parts'] = {
                title = 'BODY PARTS',
                options = {
                    {label = 'Spoilers', img = 'img/icons/spoiler.png', modType = 0, priceMult = Config.VehicleCustomisePriceMultiplier['spoilers']},
                    {label = 'Front Bumper', img = 'img/icons/bumper.png', modType = 1, priceMult = Config.VehicleCustomisePriceMultiplier['front_bumper']},
                    {label = 'Rear Bumper', img = 'img/icons/bumper.png', modType = 2, priceMult = Config.VehicleCustomisePriceMultiplier['rear_bumper'], onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r', {x = 0.0, y = -4.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Side Skirts', img = 'img/icons/bumper.png', modType = 3, priceMult = Config.VehicleCustomisePriceMultiplier['side_skirts'], onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', {x = -2.5, y = 0.0, z = 0.0}, {x = 0.0, y = 0.0, z = -20.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Exhaust', img = 'img/icons/exhaust.png', modType = 4, priceMult = Config.VehicleCustomisePriceMultiplier['exhaust'], onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r', {x = 0.0, y = -4.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Cage', img = 'img/icons/body.png', modType = 5, priceMult = Config.VehicleCustomisePriceMultiplier['cage'], onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'interiorlight', {x = 0.0, y = 1.0, z = -0.1}, {x = 0.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Grille', img = 'img/icons/grille.png', modType = 6, priceMult = Config.VehicleCustomisePriceMultiplier['grille']},
                    {label = 'Hood', img = 'img/icons/hood.png', modType = 7, priceMult = Config.VehicleCustomisePriceMultiplier['hood']},
                    {label = 'Left Fender', img = 'img/icons/bumper.png', modType = 8, priceMult = Config.VehicleCustomisePriceMultiplier['left_fender']},
                    {label = 'Right Fender', img = 'img/icons/bumper.png', modType = 9, priceMult = Config.VehicleCustomisePriceMultiplier['right_fender']},
                    {label = 'Roof', img = 'img/icons/roof.png', modType = 10, priceMult = Config.VehicleCustomisePriceMultiplier['roof']},
                    {label = 'Arch Cover', img = 'img/icons/bumper.png', modType = 42, priceMult = Config.VehicleCustomisePriceMultiplier['arch_cover']},
                    {label = 'Aerials', img = 'img/icons/aerials.png', modType = 43, priceMult = Config.VehicleCustomisePriceMultiplier['aerials']},
                    {label = 'Wings', img = 'img/icons/bumper.png', modType = 44, priceMult = Config.VehicleCustomisePriceMultiplier['wings']},
                    {label = 'Windows', img = 'img/icons/door.png', modType = 46, priceMult = Config.VehicleCustomisePriceMultiplier['windows']},
                },
                onBack = function() updateMenu('visual') end
            },
            ['inside_parts'] = {
                title = 'INSIDE PARTS',
                options = {
                    {label = 'Dashboard', img = 'img/icons/dashboard.png', modType = 29, priceMult = Config.VehicleCustomisePriceMultiplier['dashboard']},
                    {label = 'Dashboard Color', img = 'img/icons/dashboardColor.png', modType = 'dashboardColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['dashboard_color'], onSelect = function() openColorPicker('Dashboard Color', 'dashboardColor', false, Config.VehicleCustomisePriceMultiplier['dashboard_color']) end},
                    {label = 'Dial', img = 'img/icons/dashboard.png', modType = 30, priceMult = Config.VehicleCustomisePriceMultiplier['dial']},
                    {label = 'Door Speaker', img = 'img/icons/speaker.png', modType = 31, priceMult = Config.VehicleCustomisePriceMultiplier['door_speaker'], onSelect = function() openDoors(customVehicle, {1,1,1,1,0,0,0}) end},
                    {label = 'Seat', img = 'img/icons/seat.png', modType = 32, priceMult = Config.VehicleCustomisePriceMultiplier['seat']},
                    {label = 'Steering Wheel', img = 'img/icons/steering_wheel.png', modType = 33, priceMult = Config.VehicleCustomisePriceMultiplier['steering_wheel']},
                    {label = 'Shifter Leaver', img = 'img/icons/shifter_leaver.png', modType = 34, priceMult = Config.VehicleCustomisePriceMultiplier['shifter_leaver']},
                    {label = 'Ornaments', img = 'img/icons/ornaments.png', modType = 28, priceMult = Config.VehicleCustomisePriceMultiplier['ornaments']},
                    {label = 'Interior', img = 'img/icons/body.png', modType = 27, priceMult = Config.VehicleCustomisePriceMultiplier['interior']},
                    {label = 'Interior Color', img = 'img/icons/interiorColor.png', modType = 'interiorColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['interior_color'], onSelect = function() openColorPicker('Interior Color', 'interiorColor', false, Config.VehicleCustomisePriceMultiplier['interior_color']) end},
                },
                onBack = function() updateMenu('visual') end
            },
            ['respray'] = {
                title = 'RESPRAY',
                options = {
                    {label = 'Primary', img = 'img/icons/respray.png', modType = 'color1', customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['primary_paint'], onSelect = function() openColorPicker('Primary Color', 'color1', true, Config.VehicleCustomisePriceMultiplier['primary_paint']) end},
                    {label = 'Secondary', img = 'img/icons/respray.png', modType = 'color2', customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['secondary_paint'], onSelect = function() openColorPicker('Secondary Color', 'color2', true, Config.VehicleCustomisePriceMultiplier['secondary_paint']) end},
                    {label = 'Primary Paint Type', img = 'img/icons/respray.png', modType = 'paintType1', priceMult = Config.VehicleCustomisePriceMultiplier['primary_paint_type']},
                    {label = 'Secondary Paint Type', img = 'img/icons/respray.png', modType = 'paintType2', priceMult = Config.VehicleCustomisePriceMultiplier['secondary_paint_type']},
                    {label = 'Pearlescent', img = 'img/icons/respray.png', modType = 'pearlescentColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['pearlescent'], onSelect = function() openColorPicker('Pearlescent Color', 'pearlescentColor', false, Config.VehicleCustomisePriceMultiplier['pearlescent']) end},
                },
                onBack = function() updateMenu('visual') end
            },
            ['wheels'] = {
                title = 'WHEELS',
                options = {
                    {label = 'Wheels Type', img = 'img/icons/wheel.png', onSelect = function() updateMenu('wheels_type') end},
                    {label = 'Wheels Color', img = 'img/icons/respray.png', modType = 'wheelColor', customType = 'color', priceMult = Config.VehicleCustomisePriceMultiplier['wheels_color'], onSelect = function() openColorPicker('Wheels Color', 'wheelColor', false, Config.VehicleCustomisePriceMultiplier['wheels_color']) end},
                    {label = 'Smoke Color', img = 'img/icons/respray.png', modType = 'tyreSmokeColor', customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['smoke_color'], onSelect = function() openColorPicker('Tyre Smoke Color', 'tyreSmokeColor', true, Config.VehicleCustomisePriceMultiplier['smoke_color']) end},
                },
                onBack = function() updateMenu('visual') SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true) end
            },
                ['wheels_type'] = {
                    title = 'WHEELS TYPE',
                    options = {
                        {label = 'Sport', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['sport'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 0) end},
                        {label = 'Muscle', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['muscle'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 1) end},
                        {label = 'Lowrider', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['lowrider'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 2) end},
                        {label = 'SUV', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['suv'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 3) end},
                        {label = 'Offroad', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['offroad'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 4) end},
                        {label = 'Tuner', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['tuner'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 5) end},
                        {label = 'Bike Wheels', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['bike_wheels'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 6) end},
                        {label = 'High End', img = 'img/icons/wheel.png', modType = 23, priceMult = Config.VehicleCustomisePriceMultiplier['high_end'], onSelect = function() SetVehicleModData(customVehicle, 'wheels', 7) end},
                    },
                    onBack = function() updateMenu('wheels') end
                },
            ['plate'] = {
                title = 'PLATE',
                options = {
                    {label = 'Type', img = 'img/icons/plate.png', modType = 25, priceMult = Config.VehicleCustomisePriceMultiplier['plate_type']},
                    {label = 'Color', img = 'img/icons/respray.png', modType = 'plateIndex', priceMult = Config.VehicleCustomisePriceMultiplier['plate_color'], onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r', {x = -2.0, y = -2.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Holder', img = 'img/icons/bumper.png', modType = 26, priceMult = Config.VehicleCustomisePriceMultiplier['plate_holder']},
                },
                onBack = function() updateMenu('visual') end
            },
            ['lights'] = {
                title = 'LIGHTS',
                options = {
                    {label = 'Xenon', img = 'img/icons/headlights.png', modType = 'modXenon', priceMult = Config.VehicleCustomisePriceMultiplier['xenon'], onSelect = function() SetVehicleEngineOn(customVehicle, true, false, false) end},
                    {label = 'Neon', img = 'img/icons/headlights.png', modType = 'neonColor', customType = 'customColor', priceMult = Config.VehicleCustomisePriceMultiplier['neon'], onSelect = function() SetVehicleEngineOn(customVehicle, true, false, false); openColorPicker('Neon Color', 'neonColor', true, Config.VehicleCustomisePriceMultiplier['neon']) end},
                },
                onBack = function() updateMenu('visual') end
            },
            ['stickers'] = {
                title = 'STICKERS',
                options = {
                    {label = 'Stickers', img = 'img/icons/respray.png', modType = 48, priceMult = Config.VehicleCustomisePriceMultiplier['stickers']},
                    {label = 'Livery', img = 'img/icons/respray.png', modType = 'livery', priceMult = Config.VehicleCustomisePriceMultiplier['livery']},
                },
                onBack = function() updateMenu('visual') end
            },
}