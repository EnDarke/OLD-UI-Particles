-- CLIENT TEST

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local replicatedModules = ReplicatedStorage.Modules
local UIParticles       = require(replicatedModules.UIParticles)

local Client            = Players.LocalPlayer
local ClientUI          = Client.PlayerGui

local _UDim2            = UDim2.fromScale
local _Vector2          = Vector2.new
local _Color3           = Color3.fromRGB

local CustomParticlePreset = {
    AnchorPoint = _Vector2(0.5, 0.5),
    BackgroundTransparency = 0,
    StartPosition = _UDim2(0.5, 0.5),
    Rotation = 0,
    Size = _UDim2(0.01, 0.01),
    ZIndex = 1,
    --Image = "rbxassetid://textures/particles/sparkles_main.dds",
    ImageColor3 = _Color3(255, 255, 255),
    BackgroundColor3 = _Color3(255, 255, 255),

    SpreadAngle = {Min = -15, Max = 15},
    Lifetime = {Min = 0, Max = 1},
    Direction = "Top",
    Speed = 1,
    Acceleration = _UDim2(0, 0.00125),

    SizeTweenProperties = {Size = _UDim2(0.05, 0.05)},

    Parent = ClientUI:WaitForChild("Test"),
}

local Particle = UIParticles.new(CustomParticlePreset)
Particle:Emit(20, true, true)