QBCore = nil

CreateThread(function()
    while (QBCore == nil) do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Wait(100)
    end
end)

RegisterServerEvent('qb-customs:removeCash')
AddEventHandler('qb-customs:removeCash', function(amount)
    local src = source
    removePlayerCashMoney(src, amount)
end)
