--[[
Made by SomeoneIdfk
--]]

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

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

print(1)
if isfile("hexagon/load_version.txt") then
    loadstring(game:HttpGet(readfile("hexagon/load_version.txt")))();
end

if not isfile("hexagon/load_version.txt") then
	local VersionWindow = library:CreateWindow(Vector2.new(100, 150), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))

	local VersionTab = VersionWindow:CreateTab("Version")
	local VersionTabOptions = VersionTab:AddCategory("Options", 1)

	VersionTabOptions:AddButton("Stable", function()
        writefile("load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModified.lua")
        --game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end)
	VersionTabOptions:AddButton("Alpha", function()
        writefile("load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModifiedAlpha.lua")
        --game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end)
end