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
	makefolder("hexagon")
end

if isfile("hexagon/load_version.txt") then
    loadstring(game:HttpGet(readfile("hexagon/load_version.txt")))();
end

if not isfile("hexagon/load_version.txt") then
	local VersionWindow = library:CreateWindow(Vector2.new(235, 200), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))

	local VersionTab = VersionWindow:CreateTab("Version")
	local VersionTabOptions = VersionTab:AddCategory("Options", 1)

	VersionTabOptions:AddDropdown("Selector", {"Stable", "Alpha"}, "Stable", "VersionTabOptionsSelected")
	VersionTabOptions:AddButton("Save", function()
		if library.pointers.VersionTabOptionsSelected.value == "Stable" then
			writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModified.lua")
		elseif library.pointers.VersionTabOptionsSelected.value == "Alpha" then
			writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModifiedAlpha.lua")
		end
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end)
end