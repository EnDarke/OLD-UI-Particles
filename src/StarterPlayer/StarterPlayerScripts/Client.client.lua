-- CLIENT TEST

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local replicatedModules = ReplicatedStorage.Modules
local UIParticles       = require(replicatedModules.UIParticles)

local Client            = Players.LocalPlayer
local ClientUI          = Client.PlayerGui

local _UDim2            = UDim2.fromScale
local _UDim2_Offset     = UDim2.fromOffset
local _Vector2          = Vector2.new
local _Color3           = Color3.fromRGB

local CustomParticlePreset = {
    AnchorPoint = _Vector2(0.5, 0.5),
    BackgroundTransparency = 1,
    StartPosition = _UDim2(0.5, 0.5),
    Rotation = {-15, 15},
    Size = _UDim2_Offset(20, 20),
    ZIndex = 1,
    Image = "rbxassetid://9441091612",
    ImageColor3 = _Color3(255, 0, 0),
    BackgroundColor3 = _Color3(255, 255, 255),

    Lifetime = {0, 1},
    SpreadAngle = {-15, 15},
    Direction = "Top",
    Speed = {1, 2},
    RotationSpeed = {1, 2},
    Acceleration = _UDim2(0, -0.00125),

    DelayTime = 0.25,
    SizeTweenProperties = {Size = _UDim2_Offset(50, 50)},

    Parent = ClientUI:WaitForChild("Test"),
}

local Particle = UIParticles.new(CustomParticlePreset)
task.wait(3)
Particle:Emit(20, true, true, true, 5)