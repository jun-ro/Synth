--Animation class handler. Used primarily for handling loading and playing with Animations.

-- Synthwave Library
-- Author: Junnie#0072
-- License: MIT

--[[
Documentation:

    =======================
    Animation.new(animations)

    You'd usually use this with a preset animations folder located somewhere.
    This just sets the class's animations folder.

    =======================
    Animation:Preload()

    This preloads all the animations in the animations folder
    so that it'll be well... Preloaded before actually using it.
    
    =======================
    Animations:Load(Humanoid)

    This first checks if the humanoid specified contains the Animator instance.
    If the animator instance is used then the script will use that,
    otherwise the script will create it's own Animator and parent it to the Humanoid.
    
    Then the script will do "LoadAnimation" on all of your animations,
    allowing you to easily manage the animations, as a result this gets rid of the 

    ```
        local animation = location.Animation
        local playableAnimation = Humanoid:LoadAnimation(animation)
        playableAnimation:Play()
    ```
    Rather, you'd do
    
    ```
        AnimationClass:Load(Humanoid)
        Animation:Play(name)
    ```

    =======================
    Animations:Play(name)

    Since, all the loadedAnimations are stored in a table inside the class
    you can just reference the animationName inside the animation table, and play it from there.

]]--



local ContentProvider = game:GetService("ContentProvider")
local Animation = {}

function Animation.new(animations)
    local self = setmetatable({}, {__index = Animation})
    self.animations = animations or {}
    return self
end

function Animation:SetAnimationFolder(folder)
	self.animations = folder
end

function Animation:Preload()
	local children = self.animations:GetChildren()
	local assets = {}

	for _, child in ipairs(children) do
		table.insert(assets, child)
	end
	
	print(assets)
	
	local success, error = pcall(function()
		ContentProvider:PreloadAsync(assets)
	end)

	if success then
		print("Successfully preloaded all animations.")
	else
		warn(error)
	end
end


function Animation:Load(Humanoid)
    local loadedAnimations = {}
    local animator 
    
    --Initialize the Animator 
    if Humanoid:FindFirstChild("Animator") then
        animator = Humanoid['Animator']
    else
        animator = Instance.new('Animator', Humanoid)
    end

    --Load all animations
    for i,v in ipairs(self.animations:GetChildren()) do
        local loadedAnimation = animator:LoadAnimation(v)
        loadedAnimations[v.Name] = loadedAnimation
    end

    self.animations = loadedAnimations

end

function Animation:Play(Name)
    self.animations[Name]:Play()
end

function Animation:Loop(Name)
    self.animations[Name].Looped = true
end

return Animation
