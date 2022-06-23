--[[
    Made by:
    SomeoneIdfk
]]--

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

-- Environment
local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false

-- Config
if not isfolder("oblivion") then
    makefolder("oblivion")
end

-- Main
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local versions = loadstring("return "..game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/universal_versions.cfg"))()

-- Functions
local function checkId()
	for i,v in pairs(versions) do
        print(type(v.gameid))
        if type(v.gameid) == "table" and table.find(v.gameid, game.PlaceId) then
            return v
        end
    end

	return false
end

local function checkFile(val)
    if isfile("oblivion/load_version.cfg") then
        
    end

    return false
end

local function getAllNames(datatable)
    local temp = {}
	table.foreach(datatable, function(i,v) table.insert(temp, v) end)
	return temp
end

-- GUI
if checkId() and checkFile() then
    OrionLib:MakeNotification({Name = "Oblivion", Content = "Loading "..checkFile("check")..".", Image = "rbxassetid://4483362458", Time = 5})
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/"..readfile("oblivion/load_version.cfg")))();
elseif checkId() and checkFile() == false then
    OrionLib:MakeNotification({Name = "Oblivion", Content = "Welcome to Oblivion - "..game.Players.LocalPlayer.Name, Image = "rbxassetid://4431165334", Time = 5})
    local Window = OrionLib:MakeWindow({Name = "Oblivion Loader", HidePremium = true, SaveConfig = false, ConfigFolder = "oblivion"})
    local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://3605022185", PremiumOnly = false})

    SettingsTab:AddDropdown({Name = "Branch", Default = "-", Options = {"-"}, Flag = "branch", Callback = function(val)
        if OrionLib.Flags["build"] then
            OrionLib.Flags["build"]:Refresh(getAllNames(versions["data"][val]["tables"]), true)
            OrionLib.Flags["build"]:Set(versions["data"][val]["tables"][1])
        end
    end})
    SettingsTab:AddDropdown({Name = "Build", Default = "-", Options = {"-"}, Flag = "build"})
    SettingsTab:AddButton({Name = "Set", Callback = function()
        writefile("oblivion/load_version.cfg", versions["data"][OrionLib.Flags["branch"].Value]["data"][OrionLib.Flags["build"].Value])
        OrionLib:MakeNotification({Name = "Oblivion", Content = "Loading "..checkFile("check")..".", Image = "rbxassetid://4483362458", Time = 5})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/"..readfile("oblivion/load_version.cfg")))();
        OrionLib:Destroy()
    end})

    OrionLib.Flags["branch"]:Refresh(versions["tables"], true)
    OrionLib.Flags["branch"]:Set(versions["tables"][1])
    OrionLib:Init()
elseif not checkId() then
	OrionLib:MakeNotification({Name = "Oblivion", Content = "Failed to load: Running on the wrong game!", Image = "rbxassetid://4384402990", Time = 5})
end