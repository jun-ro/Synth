-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

-- Dependencies
local EventHandling = require(script.EventHandling.EventHandling)
local ClientHandling = require(script.EventHandling.ClientHandling)
local ServerHandling = require(script.EventHandling.ServerHandling)
local PlayerHandler = require(script.Runtime.PlayerHandler)
local ValueHandler = require(script.Runtime.ValueHandler)
local Animations = require(script.Animations)
local Parallel = require(script.Parallel)

-- Create Synthwave class
local Synthwave = {}
local plugins = {}

-- Constructor
function Synthwave.new(valuelist, pluginFolder)
    local self = setmetatable({}, { __index = Synthwave })

    -- Initialize components
    self.EventHandler = EventHandling.new(game.ReplicatedStorage.Proxy, game.ReplicatedStorage.Config)
    self.ClientHandler = ClientHandling.new()
    self.ServerHandler = ServerHandling.new(game.ReplicatedStorage.Proxy, game.ReplicatedStorage.Config)
    self.PlayerHandler = PlayerHandler.init()
    self.ValueHandler = ValueHandler.new(valuelist)
    self.Animations = Animations.new()
    self.Parallel = Parallel.new()

    self.plugins = pluginFolder or nil

    return self
end

-- Set the plugins folder
function Synthwave:SetPlugins(folder)
    if folder and folder:IsA("Folder") then
        self.plugins = folder
    else
        warn("Invalid plugins folder provided.")
    end
end

-- Load plugins from the plugins folder
function Synthwave:LoadPlugins()
    for i, v in ipairs(self.plugins:GetChildren()) do
        plugins[v.Name] = require(self.plugins:FindFirstChild(v.Name))
    end
end

-- Get a specific plugin by name
