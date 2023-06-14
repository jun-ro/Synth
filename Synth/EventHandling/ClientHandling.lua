-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local ClientEventHandler = {}
local eventsList = {}


function ClientEventHandler.new()
	local self = setmetatable({}, {__index = ClientEventHandler})
	return self
end

function ClientEventHandler:CreateEvent(eventName)

	--repeat task.wait(0.1) until self.config //K but like why doesn't this work???

	local clientFolder = game:GetService('ReplicatedStorage'):FindFirstChild("Clients")

	if clientFolder then
		local event = Instance.new("RemoteEvent", clientFolder)
		event.Name = eventName
		eventsList[eventName] = event
		return event.Name
	else
		clientFolder = Instance.new('Folder', game:GetService("ReplicatedStorage"))
		clientFolder.Name = "Clients"
		local event = Instance.new("RemoteEvent", clientFolder)
		event.Name = eventName
		eventsList[eventName] = event
		return event.Name
	end
end

function ClientEventHandler:Emit(player, eventName, ...)
	local eventFound = eventsList[eventName]
	if eventFound then
		eventFound:FireClient(player, ...)
	end
end

function ClientEventHandler:EmitAll(eventName, ...)
	local eventFound = eventsList[eventName]
	if eventFound then
		eventFound:FireAllClients(...)
	end
end



function ClientEventHandler:HandleEvent(eventName, func_)
	local event = game:GetService("ReplicatedStorage"):FindFirstChild("Clients"):WaitForChild(eventName)

	if event then
		local connection = event.OnClientEvent:Connect(func_)
		event.AncestryChanged:Connect(function(client, parent)
			if parent == nil then
				connection:Disconnect()
			end
		end)
	else
		print("Client Event not found.")
	end

end


return ClientEventHandler
