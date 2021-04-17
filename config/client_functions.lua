function getPlayerCashMoney()
    return QBCore.Functions.GetPlayerData().money['cash']
end

function saveVehicleData(vehicle)
    QBCore.Functions.ExecuteSql(false, "UPDATE `player_vehicles` SET `mods` = '"..json.encode(vehicle).."' WHERE `plate` = '"..vehicle.plate.."'")
end