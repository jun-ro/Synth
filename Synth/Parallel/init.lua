-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

local Parallel = {}

function Parallel.new()
	local self = setmetatable({}, {__index = Parallel})
	self.threads = {}
	return self
end

function Parallel:RunParallel(id, func_)
	if not self.threads[tostring(id)] then
		local Cotask = coroutine.create(func_)
		local success, result = coroutine.resume(Cotask)
		self.threads[tostring(id)] = func_
	else
		error("ID: "..id.." Already exists! Please make a new id.")
	end
end

function Parallel:GetThreads()
	return self.threads
end

function Parallel:GetThread(id)
	return self.threads[id]
end

return Parallel
