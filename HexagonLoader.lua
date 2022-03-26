--[[
Made by SomeoneIdfk
--]]

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/lib/library.lua"))()

if not isfolder("hexagon") then
	makefolder("hexagon")
end

if isfile("hexagon/load_version.txt") then
	if readfile("hexagon/load_version.txt") == "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonModified.lua" then
    	loadstring(game:HttpGet(readfile("hexagon/load_version.txt")))();
	elseif readfile("hexagon/load_version.txt") == "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonModifiedAlpha.lua" then
		loadstring(game:HttpGet(readfile("hexagon/load_version.txt")))();
	elseif readfile("hexagon/load_version.txt") == "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonSkinChanger.lua" then
		loadstring(game:HttpGet(readfile("hexagon/load_version.txt")))();
	end
end

if not isfile("hexagon/load_version.txt") then
	local VersionWindow = library:CreateWindow(Vector2.new(300, 200), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))

	local VersionTab = VersionWindow:CreateTab("Version")
	local VersionTabOptions = VersionTab:AddCategory("Options", 1)
	VersionTabOptions:AddDropdown("Branch", {"Hexagon Modified", "Skin Changer"}, "Hexagon Modified", "Branch")
	VersionTabOptions:AddButton("Save", function()
		if library.pointers.Branch.value == "Hexagon Modified" then
			if library.pointers.Build.value == "Stable" then
				writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonModified.lua")
			elseif library.pointers.Build.value == "Alpha" then
				writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonModifiedAlpha.lua")
			end
		elseif library.pointers.Branch.value == "Skin Changer" then
			if library.pointers.Build.value == "-" then
				writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonSkinChanger.lua")
			end
		end
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end)
	local VersionTabOptions2 = VersionTab:AddCategory("", 2)
	VersionTabOptions2:AddDropdown("Build", {"-"}, "-", "Build")

	game:GetService("RunService").Stepped:Connect(function()
		pcall(function()
			if library.pointers.Branch.value == "Hexagon Modified" then
				library.pointers.Build.options = {"Stable", "Alpha"}
				if library.pointers.Build.value == "-" then
					library.pointers.Build:Set("Stable")
				end
			elseif library.pointers.Branch.value == "Skin Changer" then
				library.pointers.Build.options = {"-"}
				if library.pointers.Build.value ~= "-" then
					library.pointers.Build:Set("-")
				end
			end
		end)
	end)
end