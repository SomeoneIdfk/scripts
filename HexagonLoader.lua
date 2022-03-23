--[[
Customized by SomeoneIdfk
--]]

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")
getsenv(game.Players.LocalPlayer.PlayerGui.Client).splatterBlood = function() end

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Environment 
local getrawmetatable = getrawmetatable or false
local mousemove = mousemove or mousemoverel or mouse_move or false
local getsenv = getsenv or false
local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false
local hookfunc = hookfunc or hookfunction or replaceclosure or false

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/library.lua"))()

if not isfolder("hexagon") then
	print("creating hexagon folder")
	makefolder("hexagon")
end

if not isfile("hexagon/release.txt") then
	local VersionWindow = library:CreateWindow(Vector2.new(100, 100), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))

	local VersionTab = VersionWindow:CreateTab("Version")
	local VersionTabOptions = VersionTab:AddCategory("Options", 1)

	VersionTabOptions:AddButton("Stable", function()
        VersionWindow:closeWindow()
	end)
	VersionTabOptions:AddButton("Alpha", function()
	
	end)
end