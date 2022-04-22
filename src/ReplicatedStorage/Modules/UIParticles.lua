-- !strict

-- Description: Creates and runs a 2D particle based off given input.
-- Author: Alex/EnDarke
-- Date: 04/22/22

-- Services
local Players = game:GetService("Players")

-- Constants
local Client = Players.LocalPlayer

local _Vector2 = Vector2.new
local _UDim2	= UDim2.fromScale
local _Color3	= Color3.fromRGB
local _Instance = Instance.new

-- Local Utility Functions
local function createNewScreenGui()
	local _ui = _Instance("ScreenGui")
	_ui.Parent = Client.PlayerGui
	return _ui
end

local function hasProperty(obj: GuiObject, prop: string): boolean
	local success, _ = pcall(function()
		obj[prop] = obj[prop]
	end)
	return success
end

-- Module Code
local UIParticles = {}
UIParticles.__index = UIParticles

function UIParticles.new(particleInfo: table): table
	assert(particleInfo, "No Particle Info")
	local self = setmetatable({}, UIParticles)
	
	self.AnchorPoint			= particleInfo.AnchorPoint and particleInfo.AnchorPoint or _Vector2(0, 0)
	self.BackgroundTransparency = particleInfo.BackgroundTransparency and particleInfo.BackgroundTransparency or 0
	self.Position				= particleInfo.StartPosition and particleInfo.StartPosition or _UDim2(0, 0)
	self.Rotation				= particleInfo.Rotation and particleInfo.Rotation or 0
	self.Size					= particleInfo.Size and particleInfo.Size or _UDim2(0.1, 0.1)
	self.ZIndex					= particleInfo.ZIndex and particleInfo.ZIndex or 1
	self.Image					= particleInfo.Image and particleInfo.Image or nil
	self.Color					= particleInfo.Color and particleInfo.Color or nil
	self.BackgroundColor3		= particleInfo.BackgroundColor3 and particleInfo.BackgroundColor3 or _Color3(255, 255, 255)

	self.Direction				= particleInfo.Direction and particleInfo.Direction or "Top"
	self.Speed					= particleInfo.Speed and particleInfo.Speed or 0.01
	self.Acceleration			= particleInfo.Acceleration and particleInfo.Acceleration or {X = 0, Y = 0}

	self.Parent					= particleInfo.Parent and particleInfo.Parent or createNewScreenGui()

	return self
end

function UIParticles:Emit(count: number)
	for i = count, 1, -1 do
		local Particle = _Instance(self.Image and "ImageLabel" or "Frame")
		for _type, _value in pairs(self) do
			if hasProperty(Particle, _type) then
				Particle[_type] = _value
			end
		end
	end
end

return UIParticles