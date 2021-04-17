--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

-- MENU
function clearMenu(menu)
	local tempMenu = deepcopy(menu)

	for i = 1, #tempMenu.options, 1 do
		tempMenu.options[i].onHover = nil
		tempMenu.options[i].onSelect = nil
		tempMenu.options[i].onBack = nil
		tempMenu.options[i].onSubBack = nil
	end

	return tempMenu
end

-- Math

function Round(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

-- VEHICLE
function GetVehicleData(vehicle)
	local color1, color2 = GetVehicleColours(vehicle)
	
	local color1Custom = {}
	color1Custom[1], color1Custom[2], color1Custom[3] = GetVehicleCustomPrimaryColour(vehicle)
	
	local color2Custom = {}
	color2Custom[1], color2Custom[2], color2Custom[3] = GetVehicleCustomSecondaryColour(vehicle)
	
	local color1Type = GetVehicleModColor_1(vehicle)
	local color2Type = GetVehicleModColor_2(vehicle)

	local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
	
	local extras = {}
	for id = 0, 25 do
		if (DoesExtraExist(vehicle, id)) then
			extras[tostring(id)] = IsVehicleExtraTurnedOn(vehicle, id)
		end
	end

	local neonColor = {}
	neonColor[1], neonColor[2], neonColor[3] = GetVehicleNeonLightsColour(vehicle)

	local tyreSmokeColor = {}
	tyreSmokeColor[1], tyreSmokeColor[2], tyreSmokeColor[3] = GetVehicleTyreSmokeColor(vehicle)
	
	local tempData = {
		model             = GetEntityModel(vehicle),

		plate             = Trim(GetVehicleNumberPlateText(vehicle)),
		plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

		bodyHealth        = Round(GetVehicleBodyHealth(vehicle), 1),
		engineHealth      = Round(GetVehicleEngineHealth(vehicle), 1),

		fuelLevel         = Round(GetVehicleFuelLevel(vehicle), 1),
		dirtLevel         = Round(GetVehicleDirtLevel(vehicle), 1),

		color1            = color1,
		color1Custom      = color1Custom,
		
		color2            = color2,
		color2Custom      = color2Custom,

		pearlescentColor  = pearlescentColor,

		color1Type 		  = GetVehicleModColor_1(vehicle),
		color2Type 		  = GetVehicleModColor_2(vehicle),

		wheelColor        = wheelColor,
		wheels            = GetVehicleWheelType(vehicle),
		windowTint        = GetVehicleWindowTint(vehicle),

		extras            = extras,

		neonEnabled       = {
			IsVehicleNeonLightEnabled(vehicle, 0),
			IsVehicleNeonLightEnabled(vehicle, 1),
			IsVehicleNeonLightEnabled(vehicle, 2),
			IsVehicleNeonLightEnabled(vehicle, 3)
		},
		
		neonColor         = neonColor,
		tyreSmokeColor    = tyreSmokeColor,

		dashboardColor    = GetVehicleDashboardColour(vehicle),
		interiorColor     = GetVehicleInteriorColour(vehicle),

		modSpoilers       = GetVehicleMod(vehicle, 0),
		modFrontBumper    = GetVehicleMod(vehicle, 1),
		modRearBumper     = GetVehicleMod(vehicle, 2),
		modSideSkirt      = GetVehicleMod(vehicle, 3),
		modExhaust        = GetVehicleMod(vehicle, 4),
		modFrame          = GetVehicleMod(vehicle, 5),
		modGrille         = GetVehicleMod(vehicle, 6),
		modHood           = GetVehicleMod(vehicle, 7),
		modFender         = GetVehicleMod(vehicle, 8),
		modRightFender    = GetVehicleMod(vehicle, 9),
		modRoof           = GetVehicleMod(vehicle, 10),

		modEngine         = GetVehicleMod(vehicle, 11),
		modBrakes         = GetVehicleMod(vehicle, 12),
		modTransmission   = GetVehicleMod(vehicle, 13),
		modHorns          = GetVehicleMod(vehicle, 14),
		modSuspension     = GetVehicleMod(vehicle, 15),
		modArmor          = GetVehicleMod(vehicle, 16),

		modTurbo          = IsToggleModOn(vehicle, 18),
		modSmokeEnabled   = IsToggleModOn(vehicle, 20),
		modXenon          = GetVehicleXenonLightsColour(vehicle),

		modFrontWheels    = GetVehicleMod(vehicle, 23),
		modBackWheels     = GetVehicleMod(vehicle, 24),

		modPlateHolder    = GetVehicleMod(vehicle, 25),
		modVanityPlate    = GetVehicleMod(vehicle, 26),
		modTrimA          = GetVehicleMod(vehicle, 27),
		modOrnaments      = GetVehicleMod(vehicle, 28),
		modDashboard      = GetVehicleMod(vehicle, 29),
		modDial           = GetVehicleMod(vehicle, 30),
		modDoorSpeaker    = GetVehicleMod(vehicle, 31),
		modSeats          = GetVehicleMod(vehicle, 32),
		modSteeringWheel  = GetVehicleMod(vehicle, 33),
		modShifterLeavers = GetVehicleMod(vehicle, 34),
		modAPlate         = GetVehicleMod(vehicle, 35),
		modSpeakers       = GetVehicleMod(vehicle, 36),
		modTrunk          = GetVehicleMod(vehicle, 37),
		modHydrolic       = GetVehicleMod(vehicle, 38),
		modEngineBlock    = GetVehicleMod(vehicle, 39),
		modAirFilter      = GetVehicleMod(vehicle, 40),
		modStruts         = GetVehicleMod(vehicle, 41),
		modArchCover      = GetVehicleMod(vehicle, 42),
		modAerials        = GetVehicleMod(vehicle, 43),
		modTrimB          = GetVehicleMod(vehicle, 44),
		modTank           = GetVehicleMod(vehicle, 45),
		modWindows        = GetVehicleMod(vehicle, 46),
		modLivery         = GetVehicleMod(vehicle, 48),
		livery            = GetVehicleLivery(vehicle)
	}

	tempData.modTurbo = tempData.modTurbo or 0
	
	return tempData
end

function SetVehicleData(vehicle, data)
	if (data == nil) then return end

	SetVehicleModKit(vehicle, 0)
	SetVehicleAutoRepairDisabled(vehicle, false)

	if (data.plate) then
		SetVehicleNumberPlateText(vehicle, data.plate)
	end

	if (data.plateIndex) then
		SetVehicleNumberPlateTextIndex(vehicle, data.plateIndex)
	end

	if (data.bodyHealth) then
		SetVehicleBodyHealth(vehicle, data.bodyHealth + 0.0)
	end

	if (data.engineHealth) then
		SetVehicleEngineHealth(vehicle, data.engineHealth + 0.0)
	end

	if (data.fuelLevel) then
		SetVehicleFuelLevel(vehicle, data.fuelLevel + 0.0)
	end

	if (data.dirtLevel) then
		SetVehicleDirtLevel(vehicle, data.dirtLevel + 0.0)
	end

	if (data.color1) then
		ClearVehicleCustomPrimaryColour(vehicle)

		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, data.color1, color2)
	end

	if (data.color1Custom) then
		SetVehicleCustomPrimaryColour(vehicle, data.color1Custom[1], data.color1Custom[2], data.color1Custom[3])
	end

	if (data.color2) then
		ClearVehicleCustomSecondaryColour(vehicle)

		local color1, color2 = GetVehicleColours(vehicle)
		SetVehicleColours(vehicle, color1, data.color2)
	end

	if (data.color2Custom) then
		SetVehicleCustomSecondaryColour(vehicle, data.color2Custom[1], data.color2Custom[2], data.color2Custom[3])
	end

	if (data.color1Type) then
		SetVehicleModColor_1(vehicle, data.color1Type)
	end

	if (data.color2Type) then
		SetVehicleModColor_2(vehicle, data.color2Type)
	end

	if (data.pearlescentColor) then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, data.pearlescentColor, wheelColor)
	end

	if (data.wheelColor) then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, data.wheelColor)
	end

	if (data.wheels) then
		SetVehicleWheelType(vehicle, data.wheels)
	end

	if (data.windowTint) then
		SetVehicleWindowTint(vehicle, data.windowTint)
	end

	if (data.extras) then
		for id = 0, 25 do
			if (DoesExtraExist(vehicle, id)) then
				SetVehicleExtra(vehicle, id, data.extras[tostring(id)] and 0 or 1)
			end
		end
	end

	if (data.neonEnabled) then
		SetVehicleNeonLightEnabled(vehicle, 0, data.neonEnabled[1] == true or data.neonEnabled[1] == 1)
		SetVehicleNeonLightEnabled(vehicle, 1, data.neonEnabled[2] == true or data.neonEnabled[2] == 1)
		SetVehicleNeonLightEnabled(vehicle, 2, data.neonEnabled[3] == true or data.neonEnabled[3] == 1)
		SetVehicleNeonLightEnabled(vehicle, 3, data.neonEnabled[4] == true or data.neonEnabled[4] == 1)
	end

	if (data.neonColor) then
		SetVehicleNeonLightsColour(vehicle, data.neonColor[1], data.neonColor[2], data.neonColor[3])
	end

	if (data.modSmokeEnabled) then
		ToggleVehicleMod(vehicle, 20, true)
	end

	if (data.tyreSmokeColor) then
		SetVehicleTyreSmokeColor(vehicle, data.tyreSmokeColor[1], data.tyreSmokeColor[2], data.tyreSmokeColor[3])
	end

	if (data.dashboardColor) then
		SetVehicleDashboardColour(vehicle, data.dashboardColor)
	end

	if (data.interiorColor) then
		SetVehicleInteriorColour(vehicle, data.interiorColor)
	end

	if (data.modSpoilers) then
		SetVehicleMod(vehicle, 0, data.modSpoilers, false)
	end

	if (data.modFrontBumper) then
		SetVehicleMod(vehicle, 1, data.modFrontBumper, false)
	end

	if (data.modRearBumper) then
		SetVehicleMod(vehicle, 2, data.modRearBumper, false)
	end

	if (data.modSideSkirt) then
		SetVehicleMod(vehicle, 3, data.modSideSkirt, false)
	end

	if (data.modExhaust) then
		SetVehicleMod(vehicle, 4, data.modExhaust, false)
	end

	if (data.modFrame) then
		SetVehicleMod(vehicle, 5, data.modFrame, false)
	end

	if (data.modGrille) then
		SetVehicleMod(vehicle, 6, data.modGrille, false)
	end

	if (data.modHood) then
		SetVehicleMod(vehicle, 7, data.modHood, false)
	end

	if (data.modFender) then
		SetVehicleMod(vehicle, 8, data.modFender, false)
	end

	if (data.modRightFender) then
		SetVehicleMod(vehicle, 9, data.modRightFender, false)
	end

	if (data.modRoof) then
		SetVehicleMod(vehicle, 10, data.modRoof, false)
	end

	if (data.modEngine) then
		SetVehicleMod(vehicle, 11, data.modEngine, false)
	end

	if (data.modBrakes) then
		SetVehicleMod(vehicle, 12, data.modBrakes, false)
	end

	if (data.modTransmission) then
		SetVehicleMod(vehicle, 13, data.modTransmission, false)
	end

	if (data.modHorns) then
		SetVehicleMod(vehicle, 14, data.modHorns, false)
	end

	if (data.modSuspension) then
		SetVehicleMod(vehicle, 15, data.modSuspension, false)
	end

	if (data.modArmor) then
		SetVehicleMod(vehicle, 16, data.modArmor, false)
	end

	if (data.modTurbo) then
		ToggleVehicleMod(vehicle,  18, data.modTurbo)
	end

	if (data.modXenon) then
        ToggleVehicleMod(vehicle, 22, true)
        SetVehicleXenonLightsColour(vehicle, data.modXenon)
	end

	if (data.modFrontWheels) then
		SetVehicleMod(vehicle, 23, data.modFrontWheels, false)
	end

	if (data.modBackWheels) then
		SetVehicleMod(vehicle, 24, data.modBackWheels, false)
	end

	if (data.modPlateHolder) then
		SetVehicleMod(vehicle, 25, data.modPlateHolder, false)
	end

	if (data.modVanityPlate) then
		SetVehicleMod(vehicle, 26, data.modVanityPlate, false)
	end

	if (data.modTrimA) then
		SetVehicleMod(vehicle, 27, data.modTrimA, false)
	end

	if (data.modOrnaments) then
		SetVehicleMod(vehicle, 28, data.modOrnaments, false)
	end

	if (data.modDashboard) then
		SetVehicleMod(vehicle, 29, data.modDashboard, false)
	end

	if (data.modDial) then
		SetVehicleMod(vehicle, 30, data.modDial, false)
	end

	if (data.modDoorSpeaker) then
		SetVehicleMod(vehicle, 31, data.modDoorSpeaker, false)
	end

	if (data.modSeats) then
		SetVehicleMod(vehicle, 32, data.modSeats, false)
	end

	if (data.modSteeringWheel) then
		SetVehicleMod(vehicle, 33, data.modSteeringWheel, false)
	end

	if (data.modShifterLeavers) then
		SetVehicleMod(vehicle, 34, data.modShifterLeavers, false)
	end

	if (data.modAPlate) then
		SetVehicleMod(vehicle, 35, data.modAPlate, false)
	end

	if (data.modSpeakers) then
		SetVehicleMod(vehicle, 36, data.modSpeakers, false)
	end

	if (data.modTrunk) then
		SetVehicleMod(vehicle, 37, data.modTrunk, false)
	end

	if (data.modHydrolic) then
		SetVehicleMod(vehicle, 38, data.modHydrolic, false)
	end

	if (data.modEngineBlock) then
		SetVehicleMod(vehicle, 39, data.modEngineBlock, false)
	end

	if (data.modAirFilter) then
		SetVehicleMod(vehicle, 40, data.modAirFilter, false)
	end

	if (data.modStruts) then
		SetVehicleMod(vehicle, 41, data.modStruts, false)
	end

	if (data.modArchCover) then
		SetVehicleMod(vehicle, 42, data.modArchCover, false)
	end

	if (data.modAerials) then
		SetVehicleMod(vehicle, 43, data.modAerials, false)
	end

	if (data.modTrimB) then
		SetVehicleMod(vehicle, 44, data.modTrimB, false)
	end

	if (data.modTank) then
		SetVehicleMod(vehicle, 45, data.modTank, false)
	end

	if (data.modWindows) then
		SetVehicleMod(vehicle, 46, data.modWindows, false)
	end

	if (data.modLivery) then
		SetVehicleMod(vehicle, 48, data.modLivery, false)
	end

	if (data.livery) then
		SetVehicleLivery(vehicle, data.livery)
	end
end

function SetVehicleModData(vehicle, modType, data)
	SetVehicleModKit(vehicle, 0)
	SetVehicleAutoRepairDisabled(vehicle, false)

	if (modType == 'plateIndex') then
		SetVehicleNumberPlateTextIndex(vehicle, data)
	elseif (modType == 'color1') then
		SetVehicleCustomPrimaryColour(vehicle, tonumber(data[1]), tonumber(data[2]), tonumber(data[3]))
	elseif (modType == 'color2') then
		SetVehicleCustomSecondaryColour(vehicle, tonumber(data[1]), tonumber(data[2]), tonumber(data[3]))
	elseif (modType == 'paintType1') then
		SetVehicleModColor_1(vehicle, data)
	elseif (modType == 'paintType2') then
		SetVehicleModColor_2(vehicle, data)
	elseif (modType == 'pearlescentColor') then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, tonumber(data), wheelColor)
	elseif (modType == 'wheelColor') then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleExtraColours(vehicle, pearlescentColor, tonumber(data))
	elseif (modType == 'wheels') then
		SetVehicleMod(vehicle, 23, -1, false)
		SetVehicleWheelType(vehicle, tonumber(data))
	elseif (modType == 'windowTint') then
		SetVehicleWindowTint(vehicle, tonumber(data))
	elseif (modType == 'extras') then
		local tempList = {}
		for id = 0, 25, 1 do
			if (DoesExtraExist(vehicle, id)) then
				table.insert(tempList, id)
			end
		end
		
		if (DoesExtraExist(vehicle, tempList[data.id])) then
			SetVehicleExtra(vehicle, tempList[data.id], data.enable)
		end
	elseif (modType == 'neonColor') then
		SetVehicleNeonLightEnabled(vehicle, 0, true)
		SetVehicleNeonLightEnabled(vehicle, 1, true)
		SetVehicleNeonLightEnabled(vehicle, 2, true)
		SetVehicleNeonLightEnabled(vehicle, 3, true)
		
		SetVehicleNeonLightsColour(vehicle, tonumber(data[1]), tonumber(data[2]), tonumber(data[3]))
	elseif (modType == 'tyreSmokeColor') then
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, tonumber(data[1]), tonumber(data[2]), tonumber(data[3]))
	elseif (modType == 'modXenon') then
		ToggleVehicleMod(vehicle, 22, true)

		if (true) then
			SetVehicleXenonLightsColour(vehicle, tonumber(data))
		end
	elseif (modType == 'livery') then
		SetVehicleLivery(vehicle, data)
	elseif (modType == 'dashboardColor') then
		SetVehicleDashboardColour(vehicle, tonumber(data))
	elseif (modType == 'interiorColor') then
		SetVehicleInteriorColour(vehicle,  tonumber(data))
	elseif (type(modType) == 'number' and (modType == 23 or modType == 24)) then
		SetVehicleMod(vehicle, 23, data, false)

		if (IsThisModelABike(GetEntityModel(vehicle))) then
			SetVehicleMod(vehicle, 24, data, false)
		end
	elseif (type(modType) == 'number' and modType >= 17 and modType <= 22) then -- TOGGLE
		ToggleVehicleMod(vehicle, modType, data + 1)
	elseif (type(modType) == 'number') then -- MOD
		SetVehicleMod(vehicle, modType, data, false)
	end
end

function GetVehicleCurrentMod(vehicle, modType, data)
	SetVehicleModKit(vehicle, 0)
	SetVehicleAutoRepairDisabled(vehicle, false)

	if (modType == 'plateIndex') then
		return GetVehicleNumberPlateTextIndex(vehicle)
	elseif (modType == 'color1') then
		return GetVehicleCustomPrimaryColour(vehicle)
	elseif (modType == 'color2') then
		return GetVehicleCustomSecondaryColour(vehicle)
	elseif (modType == 'wheelColor') then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		return wheelColor
	elseif (modType == 'pearlescentColor') then
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		return pearlescentColor
	elseif (modType == 'tyreSmokeColor') then
		return GetVehicleTyreSmokeColor(vehicle)
	elseif (modType == 'modXenon') then
		local tempColor = GetVehicleXenonLightsColour(vehicle)
		return tempColor ~= 255 and tempColor or -1
	elseif (modType == 'neonColor') then
		return GetVehicleNeonLightsColour(vehicle)
	elseif (modType == 'paintType1') then
		return GetVehicleModColor_1(vehicle)
	elseif (modType == 'paintType2') then
		return GetVehicleModColor_2(vehicle)
	elseif (modType == 'windowTint') then
		return GetVehicleWindowTint(vehicle)
	elseif (modType == 'livery') then
		return GetVehicleLivery(vehicle)
	elseif (modType == 'dashboardColor') then
		return GetVehicleDashboardColour(vehicle)
	elseif (modType == 'interiorColor') then
		return GetVehicleInteriorColour(vehicle)
	elseif (modType == 'extras') then
		local tempList = {}
		for id = 0, 25, 1 do
			if (DoesExtraExist(vehicle, id)) then
				table.insert(tempList, id)
			end
		end
		
		if (tempList[data] ~= nil and IsVehicleExtraTurnedOn(vehicle, tempList[data])) then
			return 0
		end
	elseif (type(modType) == 'number' and modType >= 17 and modType <= 22) then
		if (IsToggleModOn(vehicle, modType)) then
			return 0
		end
	elseif (type(modType) == 'number') then
		return GetVehicleMod(vehicle, modType)
	end

	return -1
end

function GetNumVehicleModData(vehicle, modType)
	SetVehicleModKit(vehicle, 0)

	if (modType == 'plateIndex') then
		return 5
	elseif (modType == 'color1') then
		return 0
	elseif (modType == 'color2') then
		return 0
	elseif (modType == 'wheelColor') then
		return 0
	elseif (modType == 'pearlescentColor') then
		return 0
	elseif (modType == 'tyreSmokeColor') then
		return 0
	elseif (modType == 'neonColor') then
		return 0
	elseif (modType == 'dashboardColor') then
		return 0
	elseif (modType == 'interiorColor') then
		return 0
	elseif (modType == 'paintType1' or modType == 'paintType2') then
		return 5
	elseif (modType == 'windowTint') then
		return GetNumVehicleWindowTints(vehicle) - 1
	elseif (modType == 'modXenon') then
		return 12
	elseif (modType == 'livery') then
		return GetVehicleLiveryCount(vehicle) - 1
	elseif (modType == 'extras') then
		local tempCount = -1
		for id = 0, 25, 1 do
			if (DoesExtraExist(vehicle, id)) then
				tempCount = tempCount + 1
			end
		end
		return tempCount
	elseif (type(modType) == 'number' and modType >= 17 and modType <= 22) then
		return 0
	elseif (type(modType) == 'number') then
		return GetNumVehicleMods(vehicle, modType) - 1
	end

	return -1
end

function GetVehicleModIndexLabel(vehicle, modType, data)
	SetVehicleModKit(vehicle, 0)

	if (data == -1) then
		if (not (type(modType) == 'number' and modType >= 17 and modType <= 22)) then
			return 'Default'
		end
	end

	if (modType == 'plateIndex') then
		return plateIndexLabel[data + 1] or nil
	elseif (modType == 'paintType1' or modType == 'paintType2') then
		return paintTypeLabel[data + 1] or nil
	elseif (modType == 'windowTint') then
		return windowTintLabel[data + 1] or nil
	elseif (modType == 'livery') then
		return GetLabelText(GetLiveryName(vehicle, data)) or nil
	elseif (type(modType) == 'number' and modType >= 11 and modType <= 16 and modType ~= 14) then
		return 'Level ' .. (data + 1)
	elseif (modType == 'extras') then
		return 'Extra ' .. (data + 1)
	elseif (modType == 'modXenon') then
		return modXenonLabel[data + 1] or nil
	elseif (type(modType) == 'number' and modType >= 17 and modType <= 22) then
		local tempLabel = {'OFF', 'ON'}
		return tempLabel[data + 2]
	elseif (type(modType) == 'number') then
		return GetLabelText(GetModTextLabel(vehicle, modType, data)) or nil
	end

	return nil
end

function openDoors(vehicle, data)
	for i = 0, 6, 1 do
		if (data[i + 1] == 1) then
			SetVehicleDoorOpen(vehicle, i, false, false)
		else
			SetVehicleDoorShut(vehicle, i, false)
		end
	end
end

function repairtVehicle(vehicle)
	local fuel = GetVehicleFuelLevel(vehicle)

	SetVehicleFixed(vehicle)
	SetVehicleDirtLevel(vehicle, 0.0)
	SetVehicleFuelLevel(vehicle, fuel)

	playCustomSound('construction')
	updateMenu('main')
end

-- SOUNDS
function playCustomSound(soundName)
	SendNUIMessage({
		type = 'playSound',
		soundName = soundName,
		volume = (GetProfileSetting(300) / 10)
	})
end

function playSound(soundName, audioName, soundId)
	soundId = soundId or -1
    PlaySoundFrontend(soundId, soundName, audioName, false)
end

-- CAMERA
function moveCameraToBoneWithOffset(camera, vehicle, boneName, posOffset, rotOffset)
	posOffset = posOffset or {x = 0.0, y = 0.0, z = 0.0}
	rotOffset = rotOffset or {x = 0.0, y = 0.0, z = 0.0}

	local boneIndexName = GetEntityBoneIndexByName(vehicle, boneName)

	if (boneIndexName == -1) then return false end

	local vehPos = GetEntityCoords(vehicle, false)
	local wheelPos = GetWorldPositionOfEntityBone(vehicle, boneIndexName)
	local leftOffSet = vehPos - GetOffsetFromEntityInWorldCoords(vehicle, posOffset.x, posOffset.y, posOffset.z)
	local camPos = {x = wheelPos.x - leftOffSet.x, y = wheelPos.y - leftOffSet.y, z = wheelPos.z - leftOffSet.z}

	local headingToObject = GetHeadingFromVector_2d(wheelPos.x - camPos.x, wheelPos.y - camPos.y)

	SetCamCoord(camera, camPos.x, camPos.y, camPos.z)
	SetCamRot(camera, 0.0 + rotOffset.x, 0.0 + rotOffset.y, headingToObject + rotOffset.z, 2)

	return true
end

function moveToCameraToBoneSmoth(fromCamera, toCamera, vehicle, boneName, posOffset, rotOffset)
	local hasBone = moveCameraToBoneWithOffset(toCamera, vehicle, boneName, posOffset, rotOffset)

	if (hasBone) then
		SetCamActiveWithInterp(toCamera, fromCamera, 500, true, true)
	end
end

-- MORE
function addBlip(position, spriteId, color, title, scale)
	spriteId = spriteId or Config.DefaultBlip.type
	color = color or Config.DefaultBlip.color
	title = title or Config.DefaultBlip.title
	scale = scale or Config.DefaultBlip.scale

	local tempBlip = AddBlipForCoord(position.x, position.y, position.z)
	
    SetBlipSprite(tempBlip, spriteId)
    SetBlipDisplay(tempBlip, 4)
    SetBlipScale(tempBlip, scale)
    SetBlipColour(tempBlip, color)
    SetBlipAsShortRange(tempBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(title)
	EndTextCommandSetBlipName(tempBlip)
	
	return tempBlip
end

function DrawHelpText(text, beep)
	if (beep and IsHelpMessageBeingDisplayed()) then
		beep = false
	end

	BeginTextCommandDisplayHelp('main')
    AddTextEntry('main', text)
    EndTextCommandDisplayHelp(0, false, beep, 1)
end

function numberWithCommas(integer)
    for i = 1, math.floor((string.len(integer)-1) / 3) do
        integer = string.sub(integer, 1, -3*i-i) .. ',' .. string.sub(integer, -3*i-i+1)
    end
    return integer
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
