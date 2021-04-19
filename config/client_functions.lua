function getPlayerCashMoney()
    return QBCore.Functions.GetPlayerData().money['cash']
end

function saveVehicleData(vehicle)
    TriggerServerEvent("qb-customs:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(vehicle))
end