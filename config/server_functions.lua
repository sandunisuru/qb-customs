function removePlayerCashMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount or amount <= 0) then return end

    if (not QBCore) then return end
    
    local QBCorePlayer = QBCore.Functions.GetPlayer(playerId)
    if (QBCorePlayer) then
        QBCorePlayer.Functions.RemoveMoney('cash', amount)
    end
end
