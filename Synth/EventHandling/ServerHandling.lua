-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT


local ServerHandler = {}

function ServerHandler.new(config: {})
	local self = setmetatable({}, {__index = ServerHandler})
	self.config = config
	return self
end

function ServerHandler:SetEvent(Event)
	self.config.Proxy = Event
end

function ServerHandler:Setup()
	local EndpointFolder = self.config.Parent:FindFirstChild(self.config.Name)

	if not EndpointFolder then
		EndpointFolder = Instance.new('Folder', self.config.Parent)
		EndpointFolder.Name = self.config.Name
	end	
end

function ServerHandler:Hook()	
	self.config.Proxy.OnServerEvent:Connect(function(player: Player, id: string, remove: boolean, functionName: string)
		local EndpointFolder = self.config.Parent:FindFirstChild(self.config.Name)
		if not remove then
			local UniqueEvent = Instance.new('RemoteEvent')
			UniqueEvent.Parent = EndpointFolder
			UniqueEvent.Name = id
			local funcPassed = self.config.EventsList[functionName]
			UniqueEvent.OnServerEvent:Connect(funcPassed)
		else
			EndpointFolder:FindFirstChild(tostring(id)):Destroy()
		end
	end)
end


return ServerHandler
