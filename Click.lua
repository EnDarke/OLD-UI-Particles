-- !strict
-- NOTE: This module can work with any form of UI allocated, as well as can ignore clicks over specific UI Class types as well.

-- Description: Handles UI clicks universally (No buttons necessary)
-- Author: Alex/EnDarke

--[[
Functionality:
	- Add name of button to the "whitelistedElements" array.
	- Give same or new uiType Id (e.g. 0-n).
	- Add the uiType == x to the initClick conditionals.
	- Add whatever functions you'd like for the click to perform.
	- [MUST]: Have the same layout for all of the openable UI. In this case here, it uses ScreenGui.MainFrame as the constant.
]]

local Parent                = script.Parent

-- Services
local Players               = game:GetService("Players")
local ReplicatedStorage     = game:GetService("ReplicatedStorage")
local UserInputService      = game:GetService("UserInputService")

-- Modules
local AnimatorClient		= require(Parent.Parent.Animator)
local SoundsClient			= require(Parent.Parent.Sounds)

-- Variables
local Client                = Players.LocalPlayer
local ClientUI              = Client.PlayerGui
local Mouse                 = Client:GetMouse()

-- Yielding for UI to Load
local UILoaded              = Client:GetAttribute("UILoaded") == true or Client:GetAttributeChangedSignal("UILoaded"):Wait()

local replicatedRemotes     = ReplicatedStorage.Remotes
local ClientScreenClick     = replicatedRemotes.ClientScreenClick

local DepthLimit            = 10
local debounce              = false

-- Tables
local whitelistedElements   = {
	-- 0 = Main Menu Buttons, 1 = Click, 2 = SET ID HERE, etc.
	-- LAYOUT: NAME(string) = ID(number), NAME(string) = ID(number), etc.
	MenuButton = 0,
}

-- Module Code
local ClickUI = {}

local function playOpenClose(ui, status) -- This is a simple tween for test purposes only, open and close can be changed and or made more complex.
	ui.Visible = status
	ui:TweenPosition(UDim2.fromScale(0.5, 0.55), "Out", "Sine", 0.1)
	task.wait(0.1)
	ui:TweenPosition(UDim2.fromScale(0.5, 0.5), "Out", "Sine", 0.1)
	task.wait(0.1)
end

local function OpenClose(ui) -- Handles the open and closing of other frames within visible sight.
	local mainFrame = ui and ClientUI[ui.Name].MainFrame
	if mainFrame then
		if not mainFrame.Visible then
			for _, obj in pairs(ClientUI:GetChildren()) do -- Makes sure all of the other Main UI aren't visible when opening
				if whitelistedElements[obj.Name] and obj ~= mainFrame.Parent then
					obj.MainFrame.Visible = false
				end
			end
			playOpenClose(mainFrame, true) -- Plays open/close tween for turn-on
			return true
		else
			playOpenClose(mainFrame, false) -- Plays open/close tween for turn-off
			return false
		end
	end
end

local function SearchUI(uiObjects) -- Searches through all current UI Objects at the position of the mouse click.
	local counter = 1
    local uiObj
	local uiType
	
	for _, ui in ipairs(uiObjects) do
		if whitelistedElements[ui.Name] then
			uiObj = ui
			uiType = whitelistedElements[ui.Name]
			break
		else
			counter += 1
			if counter >= DepthLimit then
				break
			end
		end
	end
	if uiObj and uiType then
		return uiObj, uiType
	else
		return false
	end
end

local function clickScreen()
    local clickSpeed = Client:GetAttribute("System_ClickSpeed")
    if not debounce then
        debounce = true
        ClientScreenClick:FireServer()
        task.wait(clickSpeed)
        debounce = false
    end
end

local function initClick(keyboard, position) -- Starts all click functions
	local uiObjects
	if keyboard then
		uiObjects = ClientUI:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
	else
		uiObjects = ClientUI:GetGuiObjectsAtPosition(position.Position.X, position.Position.Y)
	end
	
	local uiObj, uiType = SearchUI(uiObjects)
	if uiType == 0 then
    OpenClose(uiObj)
  	elseif (uiType == 1 or uiType == nil) then
    clickScreen()
	end
end

local function init() -- Initiates the player's click/tap events.
	if UserInputService.TouchEnabled then
		UserInputService.TouchTap:Connect(function(touchPositions)
			initClick(false, touchPositions)
		end)
	else
		UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				initClick(true)
			end
		end)
	end
	
	return true
end

init()
return ClickUI
