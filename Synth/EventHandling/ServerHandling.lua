-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local EventHandler = require(script.Parent.EventHandling)

local ServerHandler = {}

function ServerHandler.new(proxy, config)
	local self = setmetatable({}, {__index = ServerHandler})
	self.proxy = proxy or nil
	self.config = config
	return self
end

function ServerHandler:Init()
	local eventFolder = game:GetService("ReplicatedStorage"):FindFirstChild(self.config['Endpoint'].Value)
	if eventFolder then
		return
	else
		eventFolder = Instance.new('Folder', game:GetService("ReplicatedStorage"))
		eventFolder.Name = self.config['Endpoint'].Value
	end
end

function ServerHandler:Intercept()
	self.proxy.OnServerEvent:Connect(function(player, eventName, remove)
		local endPointsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Endpoints")
		if remove then
			if not endPointsFolder then
				endPointsFolder = Instance.new("Folder", game:GetService("ReplicatedStorage"))
				endPointsFolder.Name = "Endpoints"
			end

			local existingEvent = endPointsFolder:FindFirstChild(eventName)
			if existingEvent then
				error("Event name already used.")
			else
				local newEvent = Instance.new("RemoteEvent")
				newEvent.Name = eventName
				newEvent.Parent = endPointsFolder
			end
		else
			endPointsFolder:FindFirstChild(eventName):Destroy()
		end
	end)
end

function ServerHandler.GetEvents()
	local eventPass = EventHandler.new(game.ReplicatedStorage.Proxy.ProxyEvent)
	return eventPass:GetEvents()
end

function ServerHandler.InterceptAll(eventsList, functionsList)
	for i, v in ipairs(eventsList) do
		local eventName = v.Name
		local eventHandler = functionsList[eventName]

		if eventHandler then
			local eventConnection = v.OnServerEvent:Connect(eventHandler)

			v.AncestryChanged:Connect(function(child, parent)
				if parent == nil then
					eventConnection:Disconnect()
				end
			end)
		else
			error("No function defined for event: " .. eventName)
		end
	end
end

function ServerHandler:Route(eventName, func_)
	local APIFolder = game.ReplicatedStorage:WaitForChild(self.config:WaitForChild('Endpoint').Value)
	
	print(self.config:WaitForChild('Endpoint').Value)
	
	if APIFolder then
		APIFolder = game:GetService("ReplicatedStorage")[self.config['Endpoint'].Value]
	else
		print("Idk what happened, api folder not working 🤔")
	end
	
	local eventConnection = APIFolder:WaitForChild(eventName).OnServerEvent:Connect(func_)
	
	APIFolder:WaitForChild(eventName).AncestryChanged:Connect(function(child, parent)
		if parent == nil then
			eventConnection:Disconnect()
		end
	end)
end



return ServerHandler
