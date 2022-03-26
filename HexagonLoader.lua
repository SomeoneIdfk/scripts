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
	local VersionWindow = library:CreateWindow(Vector2.new(400, 400), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))

	local VersionTab = VersionWindow:CreateTab("Version")
	local VersionTabOptions = VersionTab:AddCategory("Options", 1)
	VersionTabOptions:AddDropdown("Branch", {"Hexagon Modified", "Skin Changer"}, "Hexagon Modified", "Branch")
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
	local VersionTabOptions2 = VersionTab:AddCategory("", 2)
	VersionTabOptions2:AddDropdown("Build", {"-"}, "-", "Build")

	game:GetService("RunService").Stepped:Connect(function()
		pcall(function()
			print(1)
			if library.pointers.Branch.value == "Hexagon Modified" then
				print(2)
				library.pointers.Build.options = {"Stable", "Alpha"}
				library.pointers.Build:Set("Stable")
			elseif library.pointers.Branch.value == "Skin Changer" then
				print(3)
				library.pointers.Build.options = {"-"}
				library.pointers.Build:Set("-")
			end
		end)
	end)
end