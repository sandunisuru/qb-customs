QBCore = nil
PlayerData = {}

jobName = nil

CreateThread(function()
    while (QBCore == nil) do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Wait(100)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
    PlayerData = xPlayer
    updateUICurrentJob()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    jobName = getJobName()
    updateUICurrentJob()
end)

function getJobName()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
	end
	return nil
end