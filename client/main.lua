QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}

-- Functions
local function Setup()
	Wait(500)
	PlayerData = QBCore.Functions.GetPlayerData()
	local resources = lib.callback.await('ps-adminmenu:callback:GetResources', false)
	GetData()
	SendNUIMessage({
		action = "setupUI",
		data = {
			actions = Config.Actions,
			resources = resources,
			playerData = PlayerData,
		}
	})

end

-- Event Handlers
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
	Setup()
end)

AddEventHandler("onResourceStart", function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		Setup()
	end
end)

-- NUICallbacks
RegisterNUICallback("hideUI", function()
	ToggleUI(false)
end)

-- Recive data from ui and trigger the event and etc
RegisterNUICallback("clickButton", function(data)
	local selectedData = data.selectedData
	local data = data.data

	if not CheckPerms(data.perms) then return end

	if data.type == "client" then
		TriggerEvent(data.event, data, selectedData)
	elseif data.type == "server" then
		TriggerServerEvent(data.event, data, selectedData)
	elseif data.type == "command" then
		ExecuteCommand(data.event)
	end
end)

-- Commands
RegisterCommand("admin", function()
	ToggleUI(true)
end, false)

-- Close UI Event
RegisterNetEvent('ps-adminmenu:client:CloseUI', function()
    ToggleUI(false)
end)