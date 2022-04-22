-- CLIENT TEST

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local replicatedModules = ReplicatedStorage.Modules
local UIParticles       = require(replicatedModules.UIParticles)

local Particle = UIParticles.new({AnchorPoint = Vector2.new(0.5, 0.5), StartPosition = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.1, 0.1)})
Particle:Emit(5)