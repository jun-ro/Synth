-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local EventHandler = {}

function EventHandler.new(config: {})
	local self = setmetatable({}, {__index = EventHandler})
	self.config = config
	return self
end

function EventHandler:GetConfig()
	print(self.config)
	return self.config
end

function EventHandler:CreateEvent(callback: string)
	local EndpointFolder = self.config.Parent:WaitForChild(self.config.Name)

	local function createUniqueEventId()
		local id
		repeat
			id = math.random(1, 10000)
		until not EndpointFolder:FindFirstChild(tostring(id))
		return tostring(id)
	end

	local eventId = createUniqueEventId()
	self.config.Proxy:FireServer(eventId, false, callback)
	
	return eventId
end

function EventHandler:EmitSignal(id: string, ...)
	local EndpointFolder = self.config.Parent:WaitForChild(self.config.Name)
	task.wait(0.1)
	local ActivatedEvent = EndpointFolder[tostring(id)]
	ActivatedEvent:FireServer(...)
	
end

function EventHandler:CloseConnection(id)
	self.config['Proxy']:FireServer(id, true)
end


return EventHandler
