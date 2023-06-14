-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local EventHandling = {}

local eventsList = {}

function EventHandling.new(proxy, config)
	local self = setmetatable({}, { __index = EventHandling })
	self.proxy = proxy or nil
	self.config = config
	return self
end

function EventHandling:SetProxyEvent(proxy)
	self.proxy = proxy
end

function EventHandling:CreateEvent(name)
	local event = Instance.new('RemoteEvent')
	event.Name = name
	self.proxy:FireServer(event.Name, true)
	table.insert(eventsList, event.Name)
	return event.Name
end

function EventHandling:Emit(event, ...)
	
	local endPointName = self.config:WaitForChild('Endpoint').Value
	
	local endPointFolder = game.ReplicatedStorage:WaitForChild(endPointName)
	
	if endPointFolder then
		endPointFolder = game.ReplicatedStorage[endPointName]
	else
		print("Idk what happened, api folder not working 🤔")
	end
	
	endPointFolder:WaitForChild(event):FireServer(...)
	
end

function EventHandling:GetEvents()
	return eventsList
end

function EventHandling.CheckEvent(name)
	if game.ReplicatedStorage:WaitForChild('Endpoints'):FindFirstChild(name) then
		return true
	else
		return false
	end
end

function EventHandling:RemoveEvent(eventName)
	for i, name in ipairs(eventsList) do
		if name == eventName then
			table.remove(eventsList, i)
			self.proxy:FireServer(eventName, false)
			break
		end
	end
end

return EventHandling
