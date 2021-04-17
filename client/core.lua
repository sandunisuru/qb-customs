--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

local uiOpen = false

customCamMain = nil
customCamSec = nil

customConfigPosIndex = nil
customVehicle = nil
customVehiclePrice = nil
customVehicleData = nil

local renderingScriptCam = false

isOpenByAdmin = false

CreateThread(function()
    for i = 1, #Config.Positions, 1 do
        local tempPos = Config.Positions[i]
        if (((tempPos.blip == nil or tempPos.blip.enable == nil) and Config.DefaultBlip.enable == true) or (tempPos.blip ~= nil and tempPos.blip.enable == true)) then
            addBlip(
                tempPos.pos,
                (tempPos.blip ~= nil and tempPos.blip.type ~= nil) and tempPos.blip.type or nil,
                (tempPos.blip ~= nil and tempPos.blip.color ~= nil) and tempPos.blip.color or nil,
                (tempPos.blip ~= nil and tempPos.blip.title ~= nil) and tempPos.blip.title or nil,
                (tempPos.blip ~= nil and tempPos.blip.scale ~= nil) and tempPos.blip.scale or nil
            )
        end
    end

    local waitTime

    local playerPed
    local playerPos
    local playerVeh

    while (true) do
        waitTime = 500

        playerPed = PlayerPedId()
        playerVeh = GetVehiclePedIsIn(playerPed, false)

        if (not uiOpen) then
            if ((playerVeh ~= 0) and (DoesEntityExist(playerVeh)) and (GetPedInVehicleSeat(playerVeh, -1) == playerPed)) then
                waitTime = 100
                
                playerPos = GetEntityCoords(playerVeh)

                for i = 1, #Config.Positions, 1 do
                    local tempPos = Config.Positions[i]
                    
                    if (not tempPos.whitelistJobName or jobName == tempPos.whitelistJobName) then
                        local tempDist = #(playerPos - vector3(tempPos.pos.x, tempPos.pos.y, tempPos.pos.z))
                        local tempActionDist = tempPos.actionDistance or Config.DefaultActionDistance
                        
                        if (tempDist <= tempActionDist) then
                            waitTime = 0
                            
                            if (not IsHudHidden()) then
                                DrawHelpText(Config.Keys.action.name .. ' to enter customization', true)
                            end

                            if (IsControlJustReleased(0, Config.Keys.action.key)) then
                                customConfigPosIndex = i
                                openUI()
                            end

                            break
                        end
                    end
                end
            end
        else
            if (customConfigPosIndex) then
                local tempPos = Config.Positions[customConfigPosIndex]

                updateCash()

                if (playerVeh == 0 or playerVeh ~= customVehicle) then
                    closeUI(1, 1)
                else
                    local playerPos = GetEntityCoords(customVehicle)
                    local tempActionDist = tempPos.actionDistance or Config.DefaultActionDistance

                    local tempDist = #(playerPos - vector3(tempPos.pos.x, tempPos.pos.y, tempPos.pos.z))
                    if (tempDist > tempActionDist) then
                        closeUI(1, 1)
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)

function updateCash()
    local whitelistJobName = nil
    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
        whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
    end

    SendNUIMessage({
        type = 'update',
        what = 'cash',
        cash = getPlayerCashMoney(),
        whitelistJobName = whitelistJobName
    })
end

function updateVehicleCard(vehicle)
    local vehicleModel = GetEntityModel(vehicle)

    local vehDisplayName = GetDisplayNameFromVehicleModel(vehicleModel)
    local vehicleLabelText = GetLabelText(vehDisplayName)
    local vehicleName = vehicleLabelText == 'NULL' and vehDisplayName or vehicleLabelText
    
    local acceleration = (GetVehicleModelAcceleration(vehicleModel) or 0.0) * 10
    local maxSpeed = (GetVehicleModelEstimatedMaxSpeed(vehicleModel) or 0.0) / 10
    local breaks = GetVehicleModelMaxBraking(vehicleModel) or 0.0
    local power = (acceleration + maxSpeed) / 2
    
    SendNUIMessage({
        type = 'update',
        what = 'card',
        vehicleName = vehicleName,
        power = power,
        acceleration = acceleration,
        maxSpeed = maxSpeed,
        breaks = breaks
    })
end

function getVehiclePrice(vehicle)
    if (Config.VehicleOverridePrice[GetEntityModel(vehicle)]) then
        return Config.VehicleOverridePrice[GetEntityModel(vehicle)].price
    elseif (Config.VehicleClassPrice[tostring(GetVehicleClass(vehicle))]) then
        return Config.VehicleClassPrice[tostring(GetVehicleClass(vehicle))]
    end

    return Config.VehicleDefaultPrice
end

function openUI()
    if (uiOpen) then return end

    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(playerPed, false)
    
    if (playerVeh ~= 0 and DoesEntityExist(playerVeh)) then
        customVehicle = playerVeh
        customVehicleData = GetVehicleData(customVehicle)
        FreezeEntityPosition(customVehicle, true)

        SetVehicleOnGroundProperly(playerVeh)

        DisplayHud(false)
        SetNuiFocus(true, false)
        SetNuiFocusKeepInput(true)
        
        customVehiclePrice = getVehiclePrice(customVehicle)

        updateCash()
        updateVehicleCard(customVehicle)
        
        updateMenu('main')
        SendNUIMessage({
            type = 'open',
            isOpenByAdmin = isOpenByAdmin,
            IsUpgradesOnlyForWhitelistJobPoints = Config.IsUpgradesOnlyForWhitelistJobPoints,
            priceMultiplierWithoutTheJob = Config.PriceMultiplierWithoutTheJob,
            detailCardMenuPosition = Config.detailCardMenuPosition,
            cashPosition = Config.cashPosition
        })
        
        local vehPos = GetEntityCoords(customVehicle)
        local camPos = GetOffsetFromEntityInWorldCoords(customVehicle, -2.0, 5.0, 3.0)
        local headingToObject = GetHeadingFromVector_2d(vehPos.x - camPos.x, vehPos.y - camPos.y)
        
        customCamMain = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z, -35.0, 0.0, headingToObject, GetGameplayCamFov(), false, 2)
        customCamSec = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', camPos.x, camPos.y, camPos.z, -35.0, 0.0, headingToObject, GetGameplayCamFov(), false, 2)

        SetCamActive(customCamMain, true)
        RenderScriptCams(true, true, 500, true, true)
        renderingScriptCam = true
        
        uiOpen = true

        CreateThread(function()
            while (uiOpen) do
                DisableAllControlActions(0)

                EnableControlAction(0, 1, true) -- mouse mv
                EnableControlAction(0, 2, true) -- mouse mv

                EnableControlAction(0, 86, true) -- horn
                EnableControlAction(0, 249, true) -- voice

                if (IsDisabledControlJustReleased(0, 26)) then
                    RenderScriptCams(not renderingScriptCam, true, 500, true, true)
                    renderingScriptCam = not renderingScriptCam
                end

                Wait(0)
            end
        end)
    end
end

function closeUI(sendToUI, resetVehToDefault)
    sendToUI = sendToUI or 0
    resetVehToDefault = resetVehToDefault or 0

    DisplayHud(true)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)

    if (sendToUI == 1) then
        SendNUIMessage({
            type = 'close'
        })
    end
        
    RenderScriptCams(false, true, 500, true, true)
    renderingScriptCam = false
    DestroyCam(customCamMain, true)
    DestroyCam(customCamSec, true)
    ClearFocus()
    
    if (resetVehToDefault == 1) then
        SetVehicleData(customVehicle, customVehicleData)
    end

    openDoors(customVehicle, {0,0,0,0,0,0,0})

    customVehiclePrice = nil

    FreezeEntityPosition(customVehicle, false)
    customVehicle = nil
    customVehicleData = nil
    customConfigPosIndex = nil

    if (isOpenByAdmin) then
        isOpenByAdmin = false
    end

    uiOpen = false
end

function updateMenu(menuId)
    if (menuId == nil or Config.Menus[menuId] == nil) then return end

    local menu = clearMenu(Config.Menus[menuId])
    
    local newOptions = optionsShouldShow(menu)

    local whitelistJobName = nil
    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
        whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
    end
    
    SendNUIMessage({
        type = 'update',
        what = 'menu',
        menuId = menuId,
        options = newOptions,
        menuTitle = menu.title,
        defaultOption = menu.defaultOption,
        whitelistJobName = whitelistJobName
    })
end

RegisterNUICallback('uiReady', function(data)
    updateUICurrentJob()
end)

RegisterNUICallback('handle', function(data)
    if (data.type == 'close') then
        closeUI(0, 1)
    elseif (data.type == 'update') then
        if (data.what == 'menu') then
            if (data.user == 'hover') then
                if (not data or not data.menuId or not data.menuIndex) then
                    return
                end
                
                local menu = Config.Menus[data.menuId]
                
                if (not menu) then
                    return
                end
                
                playSound('SELECT', 'HUD_FREEMODE_SOUNDSET')

                local newOptions = optionsShouldShow(menu)

                if (data.color ~= nil) then
                    local tempModType = string.sub(data.menuId, #'mod_' + 1)
                    SetVehicleModData(customVehicle, tempModType, data.color)

                    -- if (tempModType == 'tyreSmokeColor') then
                    --     -- burnout
                    -- end

                    return
                end

                local menuOption = newOptions[data.menuIndex + 1]
                if (menuOption.onHover ~= nil) then
                    menuOption.onHover()
                end
            elseif (data.user == 'enter') then
                if (not data.menuId or not data.menuIndex) then
                    return
                end
                
                local menu = Config.Menus[data.menuId]
                
                if (not menu) then
                    return
                end

                local newOptions = optionsShouldShow(menu)
                local menuOption = newOptions[data.menuIndex + 1]

                local canBuyMod = true

                if ((not isOpenByAdmin) and menuOption and menuOption.price) then
                    if (menuOption.price == -1) then
                        canBuyMod = false
                    elseif (menuOption.price > 0) then
                        canBuyMod = false

                        menuOption.priceMult = menuOption.priceMult or 1
                        local tempPrice = menuOption.price or math.floor(customVehiclePrice * menuOption.priceMult / 100)
                        
                        if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex] and jobName ~= Config.Positions[customConfigPosIndex].whitelistJobName) then
                            tempPrice = math.floor(tempPrice * Config.PriceMultiplierWithoutTheJob)
                        end

                        if (getPlayerCashMoney() >= tempPrice) then
                            canBuyMod = true
                            if (tempPrice > 0) then
                                TriggerServerEvent('qb-customs:removeCash', tempPrice)
                            end
                        end
                    end
                end

                if (canBuyMod == false) then
                    playSound('ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET')
                    return
                end

                playSound('Zoom_In', 'DLC_HEIST_PLANNING_BOARD_SOUNDS')

                if (data.color ~= nil) then
                    local tempModType = string.sub(data.menuId, #'mod_' + 1)
                    
                    local tempPrice = data.price or math.floor(customVehiclePrice * data.priceMult / 100)

                    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex] and jobName ~= Config.Positions[customConfigPosIndex].whitelistJobName) then
                        tempPrice = math.floor(tempPrice * Config.PriceMultiplierWithoutTheJob)
                    end

                    if (not isOpenByAdmin) then
                        if (getPlayerCashMoney() >= tempPrice) then
                            if (tempPrice > 0) then 
                                TriggerServerEvent('qb-customs:removeCash', tempPrice)
                            end
                        else
                            playSound('ATM_WINDOW', 'HUD_FRONTEND_DEFAULT_SOUNDSET')
                            return
                        end
                    end

                    customVehicleData = GetVehicleData(customVehicle)
                    playCustomSound('spray')
                    openColorPicker(data.colorTitle, tempModType, data.isCustom, data.priceMult)

                    saveVehicleData(customVehicle)
                    return
                end

                if (not menuOption) then
                    return
                end
                
                if (menuOption.onSelect ~= nil) then
                    menuOption.onSelect()
                end

                if (menuOption.openSubMenu ~= nil) then
                    updateMenu(menuOption.openSubMenu)
                end

                if (menuOption.modType ~= nil) then
                    createMenu(data.menuId, menuOption)
                    updateMenu('mod_' .. menuOption.modType)
                end
            elseif (data.user == 'backspace') then
                if (not data.menuId) then
                    return
                end

                local menu = Config.Menus[data.menuId]
                
                if (not menu) then
                    return
                end

                playSound('Zoom_In', 'DLC_HEIST_PLANNING_BOARD_SOUNDS')
                
                local newOptions = optionsShouldShow(menu)
                
                if (data.menuIndex) then
                    local menuOption = newOptions[data.menuIndex + 1]
                    if (menuOption) then
                        if (menuOption.onBack ~= nil) then
                            menuOption.onBack()
                        end
                    end
                end

                if (menu.onBack ~= nil) then
                    menu.onBack()
                end
                
                SetVehicleData(customVehicle, customVehicleData)
                openDoors(customVehicle, {0,0,0,0,0,0,0})
            end
        end
    end
end)

function optionsShouldShow(menu)
    local newOptions = {}

    for i = 1, #menu.options, 1 do
        local shouldShow = true

        if (menu.options[i].modType ~= nil) then
            if (GetNumVehicleModData(customVehicle, menu.options[i].modType) < 0) then
                shouldShow = false
            end
        end

        if (menu.options[i].modType == 'extras') then
            if (menu.options[i].price ~= nil) then
                menu.options[i].priceForSub = menu.options[i].price
                menu.options[i].price = nil
            end
        end
        
        if (shouldShow and menu.options[i].openSubMenu ~= nil) then
            local subMenu = Config.Menus[menu.options[i].openSubMenu]
            local tempShouldShow = false
            for i = 1, #subMenu.options, 1 do
                if (subMenu.options[i].modType ~= nil) then
                    if (GetNumVehicleModData(customVehicle, subMenu.options[i].modType) >= 0 or subMenu.options[i].openSubMenu ~= nil) then
                        tempShouldShow = true
                        break
                    end
                end
            end

            shouldShow = tempShouldShow
        end

        if (not isOpenByAdmin) then
            if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex] and (Config.IsUpgradesOnlyForWhitelistJobPoints == true and jobName ~= Config.Positions[customConfigPosIndex].whitelistJobName)) then
                if (menu.options[i].openSubMenu == 'upgrade') then
                    shouldShow = false
                end
            end
        end

        if (shouldShow == true) then
            table.insert(newOptions, menu.options[i])
        end
    end

    return newOptions
end

function createMenu(menuId, menuOption)
    local newMenuId = 'mod_' .. menuOption.modType
    
    local curOption = GetVehicleCurrentMod(customVehicle, menuOption.modType)
    local curOptionOptionIndex = curOption + 1
    if (menuOption.modType == 'windowTint') then
        curOptionOptionIndex = curOption
    end
    
    Config.Menus[newMenuId] = {
        title = menuOption.label,
        options = {},
        onBack = function()
            updateMenu(menuId)
            
            if (menuOption.onSubBack ~= nil) then 
                menuOption.onSubBack()
            end
        end,
        defaultOption = curOptionOptionIndex
    }
    
    if (menuOption.customType == 'color' or menuOption.customType == 'customColor') then
        Config.Menus[newMenuId].title = ''
        return
    end

    local startIndex = -1
    if (menuOption.modType == 'windowTint' or menuOption.modType == 'extras') then
        startIndex = 0
    end

    for i = startIndex, GetNumVehicleModData(customVehicle, menuOption.modType), 1 do
        local tempLabel = GetVehicleModIndexLabel(customVehicle, menuOption.modType, i)
        if (not tempLabel or tempLabel == 'NULL') then
            tempLabel = tostring(i) + 1
        end

        menuOption.priceMult = menuOption.priceMult or 1.0

        local tempPrice = 0
        if (curOption == i) then
            tempPrice = -1
        else
            if (type(menuOption.priceMult) == 'number') then
                tempPrice = menuOption.price or menuOption.priceForSub or math.floor(customVehiclePrice * menuOption.priceMult / 100)
            else
                tempPrice = menuOption.price or math.floor(customVehiclePrice * menuOption.priceMult[i + 2] / 100)
            end
        end
        
        table.insert(Config.Menus[newMenuId].options, {
            label = tempLabel,
            img = menuOption.img,
            price = tempPrice,
            priceMult = menuOption.priceMult,
            onHover = function()
                SetVehicleModData(customVehicle, menuOption.modType, i)
            end,
            onSelect = function()
                customVehicleData = GetVehicleData(customVehicle)
                createMenu(menuId, menuOption)
                updateMenu(newMenuId)

                playCustomSound('construction')
                saveVehicleData(customVehicle)
            end
        })

        if (menuOption.modType == 11 or menuOption.modType == 18) then
            local tempOption = Config.Menus[newMenuId].options[#Config.Menus[newMenuId].options]
            tempOption.onHover = function()
                SetVehicleModData(customVehicle, menuOption.modType, i)
                TaskVehicleTempAction(PlayerPedId(), customVehicle, 31, 2000)
            end
        elseif (menuOption.modType == 'extras') then
            local tempOption = Config.Menus[newMenuId].options[#Config.Menus[newMenuId].options]
            
            local isTempExtraOn = GetVehicleCurrentMod(customVehicle, 'extras', (i + 1))
            
            tempOption.price = nil
            tempOption.onHover = nil

            tempOption.onSelect = function()
                isTempExtraOn = GetVehicleCurrentMod(customVehicle, 'extras', (i + 1))

                Config.Menus['extras_on_off'] = {
                    title = 'EXTRA ' .. tostring(i + 1),
                    options = {
                        {
                            label = 'OFF',
                            img = 'img/icons/minus.png',
                            price = tempPrice,
                            onHover = function()
                                SetVehicleModData(customVehicle, menuOption.modType, {id = (i + 1), enable = 1})
                            end,
                            onSelect = function()
                                customVehicleData = GetVehicleData(customVehicle)

                                Config.Menus['extras_on_off'].options[1].price = -1
                                Config.Menus['extras_on_off'].options[2].price = tempPrice

                                updateMenu('extras_on_off')

                                playCustomSound('construction')
                                saveVehicleData(customVehicle)
                            end
                        },
                        {
                            label = 'ON',
                            img = 'img/icons/plus.png',
                            price = tempPrice,
                            onHover = function()
                                SetVehicleModData(customVehicle, menuOption.modType, {id = (i + 1), enable = 0})
                            end,
                            onSelect = function()
                                customVehicleData = GetVehicleData(customVehicle)

                                Config.Menus['extras_on_off'].options[1].price = tempPrice
                                Config.Menus['extras_on_off'].options[2].price = -1

                                updateMenu('extras_on_off')

                                playCustomSound('construction')
                                saveVehicleData(customVehicle)
                            end
                        },
                    },
                    onBack = function() updateMenu(newMenuId) end,
                    defaultOption = 0
                }
                
                if (isTempExtraOn == 0) then
                    Config.Menus['extras_on_off'].options[2].price = -1
                    Config.Menus['extras_on_off'].defaultOption = 1
                else
                    Config.Menus['extras_on_off'].options[1].price = -1
                end

                updateMenu('extras_on_off')
            end
        end
    end
end

function openColorPicker(title, modType, isCustom, priceMult)
    priceMult = priceMult or 1
    
    local defaultValue
    
    if (isCustom) then
        local r, g, b = GetVehicleCurrentMod(customVehicle, modType)
        defaultValue = {r, g, b}
    else
        defaultValue = GetVehicleCurrentMod(customVehicle, modType)
    end

    local whitelistJobName = nil
    if (customConfigPosIndex and customConfigPosIndex > 0 and customConfigPosIndex <= #Config.Positions and Config.Positions[customConfigPosIndex]) then
        whitelistJobName = Config.Positions[customConfigPosIndex].whitelistJobName
    end

    SendNUIMessage({
        type = 'open',
        what = 'colorPicker',
        isOpenByAdmin = isOpenByAdmin,
        IsUpgradesOnlyForWhitelistJobPoints = Config.IsUpgradesOnlyForWhitelistJobPoints,
        priceMultiplierWithoutTheJob = Config.PriceMultiplierWithoutTheJob,
        detailCardMenuPosition = Config.detailCardMenuPosition,
        cashPosition = Config.cashPosition,
        isCustom = isCustom,
        defaultValue = defaultValue,
        title = title,
        priceMult = priceMult,
        price = math.floor(customVehiclePrice * priceMult / 100),
        whitelistJobName = whitelistJobName
    })
end

function updateUICurrentJob()
    SendNUIMessage({
        type = 'update',
        what = 'job',
        jobName = jobName
    })
end

AddEventHandler('onResourceStop', function(resource)
    if (GetCurrentServerEndpoint() == nil) then
        return
    end

	if (resource == GetCurrentResourceName()) then
        if (uiOpen) then
            DisplayHud(true)
            SetNuiFocus(false, false)
            SetNuiFocusKeepInput(false)

            RenderScriptCams(false, true, 500, true, true)
            DestroyCam(customCamMain, true)
            DestroyCam(customCamSec, true)
            ClearFocus()

            SetVehicleData(customVehicle, customVehicleData)
            FreezeEntityPosition(customVehicle, false)
        end
    end
end)
