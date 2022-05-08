--[[
Made by SomeoneIdfk
--]]

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false
local isfile = isfile or false

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/lib/library_loader.lua"))()

if not isfolder("hexagon") then
	makefolder("hexagon")
end

writefile("hexagon/versions.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/versions.cfg"))

local versions = loadstring("return "..readfile("hexagon/versions.cfg"))()

local function checkId()
	if game.PlaceId == 301549746 then
		return true
	elseif game.PlaceId == 1480424328 then
		return true
	elseif game.PlaceId == 1869597719 then
		return true
	end

	return false
end

local function checkFile()
    if isfile("hexagon/load_version.txt") then
        local temp = readfile("hexagon/load_version.txt")
        local result = table.foreach(versions["data"], function(i, v)
            local result = table.foreach(v["data"], function(i2, v2)
                if v2 == temp then
                    return true
                end
            end)
            if result then
                return true
            end
        end)
    
        if result == true then
            return true
        elseif result == false then
            return false
        end
    elseif not isfile("hexagon/load_version.txt") then
        return false
    end
end

if checkId() then
	if checkFile() then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/"..readfile("hexagon/load_version.txt")))();
	elseif not checkFile() then
		local VersionWindow = library:CreateWindow(Vector2.new(350, 200), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))
	
		local VersionTab = VersionWindow:CreateTab("Version")
		local VersionTabOptions = VersionTab:AddCategory("Options", 1)
		VersionTabOptions:AddDropdown("Branch", {"-"}, "-", "Branch")
		VersionTabOptions:AddButton("Save", function()
            writefile("hexagon/load_version.txt", versions["data"][library.pointers.Branch.value]["data"][library.pointers.Build.value])
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
		end)
		local VersionTabOptions2 = VersionTab:AddCategory("", 2)
		VersionTabOptions2:AddDropdown("Build", {"-"}, "-", "Build")

        library.pointers.Branch.options = versions["tables"]
        library.pointers.Branch:Set(versions["tables"][1])

		game:GetService("RunService").Stepped:Connect(function()
            library.pointers.Build.options = versions["data"][library.pointers.Branch.value]["tables"]
            if not table.find(versions["data"][library.pointers.Branch.value]["tables"], library.pointers.Build.value) then
                library.pointers.Build:Set(versions["data"][library.pointers.Branch.value]["tables"][1])
            end
        end)
	end
elseif not checkId() then
	game.Players.LocalPlayer:Kick("Running on the wrong game!")
end