--[[
Made by SomeoneIdfk
--]]

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false

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

	VersionTabOptions:AddDropdown("Selector", {"Hexagon Modified", "Skin Changer"}, "Hexagon Modified", "VersionsTabOptionsSelector")
	VersionTabOptions:AddDropdown("Build", {"-"}, "-", "VersionTabOptionsBuild")
	VersionTabOptions:AddButton("Save", function()
		if library.pointers.VersionTabOptionsSelector.value == "Hexagon Modified" then
			if library.pointers.VersionTabOptionsBuild.value == "Stable" then
				writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModified.lua")
			elseif library.pointers.VersionTabOptionsBuild.value == "Alpha" then
				writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModifiedAlpha.lua")
			end
		elseif library.pointers.VersionTabOptionsSelector.value == "Skin Changer" then
			if library.pointers.VersionTabOptionsBuild.value == "-" then
				writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonSkinChanger.lua")
			end
		end
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end)

	game:GetService("RunService").Heartbeat:Connect(function()
		pcall(function()
			if library.pointers.VersionTabOptionsSelector.value == "Hexagon Modified" then
				library.pointers.VersionTabOptionsBuild.options = {"Stable", "Alpha"}
				library.pointers.VersionTabOptionsBuild:Set("Stable")
			elseif library.pointers.VersionTabOptionsSelector.value == "Skin Changer" then
				library.pointers.VersionTabOptionsBuild.options = {"-"}
				library.pointers.VersionTabOptionsBuild:Set("-")
			end
		end)
	end)
end