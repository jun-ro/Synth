-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local ValueHandler = {}

function ValueHandler.new(valueList)
	local self = setmetatable({}, { __index = ValueHandler })
	self.valueList = valueList or {}
	return self
end

function ValueHandler:SetValueList(list)
	self.valueList = list
end

function ValueHandler:Watch(value)
	local valueChanged = Instance.new("BindableEvent")

	local function changeValue(newValue)
		valueChanged:Fire(newValue)
	end

	local function propertyChanged()
		changeValue(self.valueList[value].Value)
	end

	local function connectWatcher()
		if self.valueList[value] then
			self.valueList[value].Changed:Connect(propertyChanged)
			changeValue(self.valueList[value].Value) -- Fire the initial value
		end
	end

	-- Delay the connection to allow other scripts to initialize
	task.defer(connectWatcher)

	return valueChanged.Event
end


function ValueHandler:GetValue(value)
	return self.valueList[value]
end

return ValueHandler
