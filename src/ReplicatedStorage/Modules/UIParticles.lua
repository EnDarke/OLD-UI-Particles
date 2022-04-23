-- !strict

--[[Description:
	- Creates and runs a 2D particle based off given input.
	- You can emit in preset directions OR you can input your own value (IN DEGREES!)
	- Emit multiple at once, OR Emit as many as you can over time!

	PRESET DIRECTIONS (In Strings):
		- Top
		- Bottom
		- Left
		- Right
		- TopLeft
		- TopRight
		- BottomLeft
		- BottomRight
		- Scatter (All directions)
]]
-- Author: Alex/EnDarke
-- Date: 04/22/22

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Constants
local Client = Players.LocalPlayer

local Seed = 1

local _pi = math.pi
local _cos = math.cos
local _sin = math.sin
local _rad = math.rad

local _Vector2 = Vector2.new
local _UDim2 = UDim2.fromScale
local _Color3 = Color3.fromRGB
local _Instance = Instance.new
local _Random = Random.new
local _TweenInfo = TweenInfo.new

-- Base Tween Information
local tweenInfo = _TweenInfo(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)

-- Local Utility Functions
local function createNewScreenGui() -- Creates a new screen gui under player gui.
	local _ui = _Instance("ScreenGui")
	_ui.Parent = Client.PlayerGui
	return _ui
end

local function hasProperty(obj: GuiObject, prop: string): boolean -- Checks to see if inputted object has the property inputted.
	local success, _ = pcall(function()
		obj[prop] = obj[prop]
	end)
	return success
end

local function setDirection(speed: number, emitDirection: string?, spread: table): UDim2
	speed *= 0.01 -- This is so you can input values of 1+ for easier to understand time.

	local function createScatterDirection(min: number, max: number) -- Calculates from min and max degree inputs and finds the vector on the unit circle multiplied by speed input.
		Seed += 1 -- Necessary for Random to have a new seed.

		local RandomDegree = _Random(Seed):NextInteger(min, max and max or min)
		local RandomSpread = _Random(Seed):NextInteger(spread.Min, spread.Max)
		
		return _UDim2(_cos(_rad(-RandomDegree + RandomSpread)) * speed, _sin(_rad(-RandomDegree + RandomSpread)) * speed)
	end

	return (type(emitDirection) == "number" and createScatterDirection(emitDirection)) -- Checks if you inputted a degree.
		or (emitDirection == "Top" and createScatterDirection(90)) -- Checks if you inputted Top.
		or (emitDirection == "Bottom" and createScatterDirection(270)) -- Checks if you inputted Bottom.
		or (emitDirection == "Left" and createScatterDirection(180)) -- Checks if you inputted Left.
		or (emitDirection == "Right" and createScatterDirection(0)) -- Checks if you inputted Right.
		or (emitDirection == "TopLeft" and createScatterDirection(135)) -- Checks if you inputted TopLeft.
		or (emitDirection == "TopRight" and createScatterDirection(45)) -- Checks if you inputted TopRight.
		or (emitDirection == "BottomLeft" and createScatterDirection(225)) -- Checks if you inputted BottomLeft.
		or (emitDirection == "BottomRight" and createScatterDirection(315)) -- Checks if you inputted BottomRight.
		or (emitDirection == "Scatter" and createScatterDirection(0, 360)) -- Checks if you inputted Scatter.
end

-- Module Code
local UIParticles = {}
UIParticles.__index = UIParticles

function UIParticles.new(particleInfo: table): table -- Creates a new set of particles with given particle information.
	assert(particleInfo, "No Particle Info")
	local self = setmetatable({}, UIParticles)

	-- Object Properties | Expanded out so it's not as cluttered to read :)
	self.AnchorPoint			= particleInfo.AnchorPoint and particleInfo.AnchorPoint or _Vector2(0, 0) -- Where do you want to anchor the particle?
	self.BackgroundTransparency = particleInfo.BackgroundTransparency and particleInfo.BackgroundTransparency or 0 -- How transparent are the particles?
	self.Position				= particleInfo.StartPosition and particleInfo.StartPosition or _UDim2(0, 0) -- Where do you want it to start?
	self.Rotation				= particleInfo.Rotation and particleInfo.Rotation or 0 -- What rotation do you want it to start in?
	self.Size					= particleInfo.Size and particleInfo.Size or _UDim2(0.1, 0.1) -- How big do you want it? (In UDim2.fromScale)
	self.ZIndex					= particleInfo.ZIndex and particleInfo.ZIndex or 1 -- At what depth do you want these to play?
	self.Image					= particleInfo.Image and particleInfo.Image or "rbxassetid://1" -- String ("rbxassetid://") Input.
	self.ImageColor3			= particleInfo.Color and particleInfo.Color or _Color3(255, 255, 255) -- Input what color you want in RGB.
	self.BackgroundColor3		= particleInfo.BackgroundColor3 and particleInfo.BackgroundColor3 or _Color3(255, 255, 255) -- Input what color you want in RGB.

	-- Physics Properties
	self.SpreadAngle			= particleInfo.SpreadAngle and particleInfo.SpreadAngle or {Min = 0, Max = 0} -- Input a table with min and max values (deg).
	self.Lifetime				= particleInfo.Lifetime and particleInfo.Lifetime or {Min = 1, Max = 1} -- Input a table with min and max values (s).
	self.Direction				= particleInfo.Direction and particleInfo.Direction or "Top" -- String or Number | See Description for more info.
	self.Speed					= particleInfo.Speed and particleInfo.Speed or 1 -- How fast do you want it to move over time?
	self.Acceleration			= particleInfo.Acceleration and particleInfo.Acceleration or _UDim2(0, 0) -- Takes in X and Y (Numbers should be SUPER low cause it works on scale).

	-- Tween Properties
	self.TweenStyle				= particleInfo.TweenStyle and particleInfo.TweenStyle or tweenInfo.EasingStyle -- If you want it tweened, how do you want the tween to play?
	self.TweenDirection			= particleInfo.TweenDirection and particleInfo.TweenDirection or tweenInfo.EasingDirection -- If you want it tweened, how do you want the tween direction to go?
	self.RepeatCount			= particleInfo.RepeatCount and particleInfo.RepeatCount or tweenInfo.RepeatCount -- If you want it tweened, do you want it to repeat?
	self.Reverses				= particleInfo.Reverses and particleInfo.Reverses or tweenInfo.Reverses -- If you want it tweened, do you want it to reverse?
	self.DelayTime				= particleInfo.DelayTime and particleInfo.DelayTime or tweenInfo.DelayTime -- If you want it tweened, do you want to delay it for a bit?
	self.ClearTweenProperties	= particleInfo.Image and {ImageTransparency = 1} or {BackgroundTransparency = 1} -- These are properties for transparency tweening.
	self.SizeTweenProperties	= particleInfo.SizeTweenProperties and particleInfo.SizeTweenProperties or {Size = _UDim2(0, 0)} -- These are properties for size tweening.
	-- Setting Parent
	self.Parent					= particleInfo.Parent and particleInfo.Parent or createNewScreenGui() -- Where do you want it to go?

	-- DON'T WORRY! I have PRESET values in place just so you don't have to input everything unnecessary!
	return self
end

function UIParticles:Emit(count: number, FadeOut: boolean, SizeChange: boolean) -- Emits particles based on preset amount and lets you fade out or change size!
	local HeartbeatInstances = {}

	-- Gather all of the UI objects
	for i = count, 1, -1 do
		-- Particle Setup
		local Lifetime = _Random(Seed):NextNumber(self.Lifetime.Min, self.Lifetime.Max)
		local Particle = _Instance(self.Image and "ImageLabel" or "Frame")

		-- Giving the particles preset properties
		for _type, _value in pairs(self) do
			if hasProperty(Particle, _type) then
				Particle[_type] = _value
			end
		end

		-- Speed and Direction setup
		local Velocity = self.Velocity
		Velocity = self.Direction and setDirection(self.Speed, self.Direction, self.SpreadAngle) -- Only emits towards a direction if direction is set.

		-- Play the animation!
		HeartbeatInstances[i] = RunService.Heartbeat:Connect(function(deltaTime)
			if Lifetime > 0 then
				Velocity += self.Acceleration
				Particle.Position += Velocity
				Lifetime -= deltaTime
			else
				HeartbeatInstances[i]:Disconnect()
			end
		end)

		-- Fade Out?
		if FadeOut then
			local tweenInfo = _TweenInfo(Lifetime, self.TweenStyle, self.TweenDirection, self.RepeatCount, self.Reverses, self.DelayTime)
			local Tween = TweenService:Create(Particle, tweenInfo, self.ClearTweenProperties)
			Tween:Play()
		end

		-- Grow?
		if SizeChange then
			local tweenInfo = _TweenInfo(Lifetime, self.TweenStyle, self.TweenDirection, self.RepeatCount, self.Reverses, self.DelayTime)
			local Tween = TweenService:Create(Particle, tweenInfo, self.SizeTweenProperties)
			Tween:Play()
		end
	end
end

return UIParticles