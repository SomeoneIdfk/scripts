--[[
    Made by:
    SomeoneIdfk
]]--

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

-- Environment 
local getrawmetatable = getrawmetatable or false
local getsenv = getsenv or false
local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false
local hookfunc = hookfunc or hookfunction or replaceclosure or false

-- Config
if not isfolder("oblivion") then
    makefolder("oblivion")
end

writefile("oblivion/weapon_data.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/weapon_info.cfg"))

-- Main
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local espLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Sirius/request/library/esp/esp.lua'),true))()
local versions = loadstring("return "..readfile("oblivion/versions.cfg"))()

local Settings = {CurrentSkins = {}, data = {}, squares = {}, aimbot = {enable = false, method = "distance", aim = false, target = nil, standing = false, distance = math.huge, targetresettime = 0}, playerlist = {}, saveerror = false, currentmap = workspace.Map.Origin.Value, weapon_data = table.foreach(loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), function(i,v) if i == "guns" then return v end end), knife_data = table.foreach(loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), function(i,v) if i == "knives" then return v end end), glove_data = table.foreach(loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), function(i,v) if i == "gloves" then return v end end), OldInventory = {}, loops = {bloodremovalloop = nil, magremovalloop = nil}}
Settings.CurrentSkins["-"] = "-"

for i,v in pairs(Settings.weapon_data) do
	Settings.CurrentSkins[i] = "Stock"
end

local LocalPlayer = game:GetService('Players').LocalPlayer
local Client = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
local Mouse = LocalPlayer:GetMouse()
local FOV = Drawing.new("Circle")
FOV.Thickness = 2
local TriggerbotFOV = Drawing.new("Circle")
TriggerbotFOV.Thickness = 2
Settings.OldInventory = Client.CurrentInventory

local IgnoredFlags = {"settings_branch", "settings_build", "skins_weapon", "skins_weapon_skin"}
local Hitboxes = {"Head", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "UpperTorso", "LowerTorso"}

OrionLib:MakeNotification({Name = "Oblivion", Content = "Oblivion is loading.", Image = "rbxassetid://4400702947", Time = 3})

local Window = OrionLib:MakeWindow({Name = "Oblivion", HidePremium = true, SaveConfig = false, ConfigFolder = "oblivion"})

-- Esp Setup
espLib.whitelist = {}
espLib.blacklist = {}
espLib.options = {enabled = nil, scaleFactorX = 4, scaleFactorY = 5, font = 2, fontSize = 13, limitDistance = false, maxDistance = 1000, visibleOnly = nil, teamCheck = nil, teamColor = nil, fillColor = nil, whitelistColor = Color3.new(1, 0, 0), outOfViewArrows = false, outOfViewArrowsFilled = false, outOfViewArrowsSize = 25, outOfViewArrowsRadius = 100, outOfViewArrowsColor = Color3.new(1, 1, 1), outOfViewArrowsTransparency = 0.5, outOfViewArrowsOutline = false, outOfViewArrowsOutlineFilled = false, outOfViewArrowsOutlineColor = Color3.new(1, 1, 1), outOfViewArrowsOutlineTransparency = 1, names = nil, nameTransparency = nil, nameColor = nil, boxes = true, boxesTransparency = nil, boxesColor = nil, boxFill = false, boxFillTransparency = 0.5, boxFillColor = Color3.new(1, 1, 1), healthBars = true, healthBarsSize = 1, healthBarsTransparency = nil, healthBarsColor = nil, healthText = true, healthTextTransparency = nil, healthTextSuffix = "%", healthTextColor = nil, distance = true, distanceTransparency = nil, distanceSuffix = " Studs", distanceColor = nil, tracers = nil, tracerTransparency = nil, tracerColor = nil, tracerOrigin = nil}

for i,v in ipairs(workspace:GetChildren()) do
    for i2,v2 in pairs(game.Players:GetPlayers()) do
        if v2.Name == v.Name then
            Settings.playerlist[v.Name] = v
        end
    end
end
workspace.ChildAdded:connect(function(v)
    local success = pcall(function()
        for i2,v2 in pairs(game.Players:GetPlayers()) do
            if v.Name == v2.Name then
                return true
            end
        end
    end)
    if success then
        Settings.playerlist[v.Name] = v
    end
end)
workspace.ChildRemoved:connect(function(v)
    local success = pcall(function()
        for i2,v2 in pairs(game.Players:GetPlayers()) do
            if v.Name == v2.Name then
                return true
            end
        end
    end)
    if success then
        Settings.playerlist[v.Name] = nil
    end
end)

function espLib.GetTeam(player)
    local team, teamColor
    if game.Players[player.Name]:FindFirstChild("Status") then
        team = game.Players[player.Name].Status.Team.Value
        if team == "T" then
            teamColor = Color3.fromRGB(255, 233, 0)
        elseif team == "CT" then
            teamColor = Color3.fromRGB(0, 150, 255)
        end
    end
    return team, teamColor
end

-- Workspace
local Oblivion = Instance.new("Folder", workspace)
Oblivion.Name = "Oblivion"

local Models = Instance.new("Folder", Oblivion)
Models.Name = "Models"

local OblivionRan = Instance.new("BoolValue", Oblivion)
OblivionRan.Name = "OblivionRan"
OblivionRan.Value = false

local OblivionASD = Instance.new("IntValue", Oblivion)
OblivionASD.Name = "OblivionAutoShootDelay"
OblivionASD.Value = 0

local OblivionMapChange = Instance.new("IntValue", Oblivion)
OblivionMapChange.Name = "OblivionMapChange"
OblivionMapChange.Value = 0

-- Functions
local function SaveTable(queuetable)
	local tbl = {}
	
	local SpecialCharacters = {
		['\a'] = '\\a',
		['\b'] = '\\b',
		['\f'] = '\\f',
		['\n'] = '\\n',
		['\r'] = '\\r',
		['\t'] = '\\t',
		['\v'] = '\\v',
		['\0'] = '\\0'
	}
	
	local function SerializeType(Value, Class, Comma)
		local NewValue = ''
	
		if Class == 'string' then
			NewValue = ('"%s"'):format(Value:gsub('[%c%z]', SpecialCharacters))
		elseif Class == 'Instance' then
			NewValue = Value:GetFullName()
		elseif Class == 'EnumItem' then
			NewValue = tostring(Value)
		elseif type(Value) ~= Class then -- CFrame, Vector3, UDim2, ...
			NewValue = Class .. '.new(' .. tostring(Value) .. ')'
		elseif Class == 'userdata' then
			NewValue = ('[Userdata, Metatable Field: %s]'):format(tostring(not not getmetatable(Value)))
		else -- thread, number, boolean, nil, ...
			NewValue = tostring(Value)
		end
	
		if Comma == true then
			NewValue = NewValue..","
		end

		return NewValue
	end
	
	local function TableToString(Table, IgnoredTables, Depth)
		IgnoredTables = IgnoredTables or {}
	
		--if IgnoredTables[Table] then
			--return IgnoredTables[Table] == Depth - 1 and '[Parent table]' or '[Cyclic Table]'
		--end
	
		Depth = Depth or 0
		Depth = Depth + 1
		IgnoredTables[Table] = Depth
	
		local Tab = ('    '):rep(Depth)
		local TrailingTab = ('    '):rep(Depth - 1)
		local Result = '{'
		local LineTab = '\n' .. Tab
	
		for Key, Value in pairs(Table) do
			local KeyClass, ValueClass = typeof(Key), typeof(Value)
			
			if KeyClass == 'string' then
				Key = Key:gsub('[%c%z]', SpecialCharacters)
				
				if Key:match'%s' then
					Key = ('["%s"]'):format(Key)
				end
				
				Key = '["'..Key..'"]'
			else
				Key = '[' .. (KeyClass == 'table' and TableToString(Key, IgnoredTables, Depth):gsub('^[\n\r%s]*(.-)[\n\r%s]*$', '%1') or SerializeType(Key, KeyClass, false)) .. ']'
			end
	
			Value = ValueClass == 'table' and TableToString(Value, IgnoredTables, Depth) or SerializeType(Value, ValueClass, true)
			Result = Result .. LineTab .. Key .. ' = ' .. Value
		end
	
		return Result .. '\n'  .. TrailingTab .. '}' .. ","
	end
	
    for i,v in pairs(queuetable) do
		tbl[i] = v
	end
	
    return TableToString(tbl):sub(0, -2)
end

local function getAllNames(datatable, val)
    local temp
    if val and val == "empty" then
	    temp = {}
    else
        temp = {"-"}
    end

	table.foreach(datatable, function(i,v) if val and val == "empty" then table.insert(temp, v) else table.insert(temp, i) end end)
	return temp
end

local function modelChange(model, replace)
	if game:GetService("ReplicatedStorage").Viewmodels:FindFirstChild(model) then
		if Models:FindFirstChild(replace) then
			game.ReplicatedStorage.Viewmodels[model]:Destroy()
			wait()
			local Model1 = Instance.new("Model", game.ReplicatedStorage.Viewmodels)
			local Clone = Models[replace]:Clone()
			Clone.Parent = Model1
			Model = game.ReplicatedStorage.Viewmodels.Model
			for _, Child in pairs(Model:GetChildren()) do
				Child.Parent = Model.Parent
			end
			Model:Destroy()
			game.ReplicatedStorage.Viewmodels[replace].Name = model

			return true
		else
			return false
		end
	else
		return false
	end
end

local function MapSkin(Gun, Skin)
	local SkinData = game:GetService("ReplicatedStorage").Skins:FindFirstChild(Gun):FindFirstChild(Skin)
	if not SkinData:FindFirstChild("Animated") then      
		for _,Data in pairs(SkinData:GetChildren()) do      
			local Obj = workspace.CurrentCamera.Arms:FindFirstChild(Data.Name)      
			if Obj ~= nil and Obj.Transparency ~= 1 then      
				if Obj:FindFirstChild("Mesh") then      
					Obj.Mesh.TextureId = Data.Value      
				elseif not Obj:FindFirstChild("Mesh") then      
					Obj.TextureID = Data.Value      
				end      
			end      
		end   
	end      
end

local function skinsList(knife, list)
	local temp = {}
	table.foreach(list, function(i, v)
		if i == knife then
			table.foreach(v, function(i2, v2)
				table.insert(temp, v2)
			end)
		end
	end)

	return temp
end

local function skinsGunList(gun)
    local temp = {}
    table.foreach(Settings.weapon_data, function(i, v)
        if i == gun then
            table.foreach(v.list, function(i2, v2)
                table.insert(temp, v2)
            end)
        end
    end)
    return temp
end

local function Serverhop()
	local x = {}
	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")).data) do
		if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId then
			x[#x + 1] = v.id
		end
	end
	if #x > 0 then
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
	else
		return "Protocol:cantfind"
	end
end

local function saveData()
    if OblivionRan.Value == true then
		local tempmaster = {skins = {}, data = {}}
        local temp = {[1] = {["skins_knife"] = {}}, [2] = {["skins_knife_skin"] = {}}, [3] = {["skins_glove"] = {}}, [4] = {["skins_glove_skin"] = {}}}
        for i,v in pairs(temp) do
            for i2,v2 in pairs(v) do
                temp[i] = {[i2] = {["Type"] = OrionLib.Flags[i2].Type, ["Value"] = OrionLib.Flags[i2].Value}}
            end
        end
		for i,v in pairs(OrionLib.Flags) do
			if not table.find(IgnoredFlags, i) then
				local output = table.foreach(temp, function(i2,v2)
					for i3,v3 in pairs(v2) do
						if i == i3 then
							return true
						end
					end
				end)
				if output == nil then
					table.insert(temp, {[i] = {["Type"] = OrionLib.Flags[i].Type, ["Value"] = OrionLib.Flags[i].Value}})
				end
			end
		end
        tempmaster.data = temp
		tempmaster.skins = Settings.CurrentSkins
        writefile("oblivion/data.cfg", SaveTable(tempmaster))
    end
end

local function dropdownRefresh(flag, value, list)
    OrionLib.Flags[flag]:Refresh(list, true)
    OrionLib.Flags[flag]:Set(value)
end

local function GetCharacter(player)
    local character = player.Character
    return character, character and game.FindFirstChild(character, "HumanoidRootPart")
end

local function VisibleCheck(character, position)
    local origin = workspace.CurrentCamera.CFrame.Position
    local part = workspace.FindPartOnRayWithIgnoreList(workspace, Ray.new(origin, position - origin), { GetCharacter(LocalPlayer), workspace.CurrentCamera, character }, false, true)
    return part == nil
end

local function GetTeam(plr)
	if plr:FindFirstChild("Status") and plr.Status:FindFirstChild("Team") and plr.Status.Team.Value ~= "Spectator" then
		return plr.Status.Team.Value
	end

	return "s"
end

local function checkGamemode(mode)
	if mode == "team" and game.PlaceId == 301549746 or mode == "team" and game.PlaceId == 1480424328 then
		return true
	elseif mode == "ffa" and game.PlaceId == 1869597719 then
		return true
	end

	return false
end

local function IsAlive(plr)
	if plr and plr.Character and plr.Character.FindFirstChild(plr.Character, "Humanoid") and plr.Character.Humanoid.Health > 0 and GetTeam(plr) ~= "s" then
		return true
	end

	return false
end

local function knifeOrGun()
	local success = table.foreach(Settings.weapon_data, function(i, v)
		if v.name == Client.gun.Name then
			return "gun"
		end
	end)

	if success == "gun" then
		return "gun"
	elseif Client.gun:FindFirstChild("Melee") then
		return "knife"
	end
end

local function getGunName()
	local gun = table.foreach(Settings.weapon_data, function(i,v)
		if v.name == LocalPlayer.Character.EquippedTool.Value then
			return i
		end
	end)
	return gun
end

local function getGunNameFromCheck(gun)
	local gun = table.foreach(Settings.weapon_data, function(i,v)
		if v.name == gun then
			return i
		end
	end)
	return gun
end

local function getClosestPlayer()
    Settings.aimbot.distance = math.huge
    local closestPlayer = nil
    for i,v in pairs(game.Players:GetChildren()) do
        if v ~= LocalPlayer and IsAlive(v) and GetTeam(v) ~= "s" and checkGamemode("ffa") or v ~= LocalPlayer and IsAlive(v) and GetTeam(v) ~= "s" and checkGamemode("team") and GetTeam(LocalPlayer) ~= GetTeam(v) then
			local character, torso = GetCharacter(v)
			local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(v.Character.Head.Position)
			local FOVCheck = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
			if OrionLib.Flags["aimbot_priority"].Value == "Distance" then
				if OrionLib.Flags["aimbot_fov_only"].Value == true and FOVCheck < OrionLib.Flags["aimbot_fov_radius"].Value or OrionLib.Flags["aimbot_fov_only"].Value == true and OrionLib.Flags["aimbot_fov_radius"].Value == 0 or OrionLib.Flags["aimbot_fov_only"].Value == false then
					if OrionLib.Flags["aimbot_visible"].Value == false or OrionLib.Flags["aimbot_visible"].Value == true and VisibleCheck(character, torso.Position) then
						local distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
						if distance < Settings.aimbot.distance then
							Settings.aimbot.distance = distance
							closestPlayer = v
						end
					end
				end
			elseif OrionLib.Flags["aimbot_priority"].Value == "Crosshair" then
				if OrionLib.Flags["aimbot_fov_only"].Value == true and FOVCheck < OrionLib.Flags["aimbot_fov_radius"].Value or OrionLib.Flags["aimbot_fov_only"].Value == true and OrionLib.Flags["aimbot_fov_radius"].Value == 0 or OrionLib.Flags["aimbot_fov_only"].Value == false then
					if OrionLib.Flags["aimbot_visible"].Value == false or OrionLib.Flags["aimbot_visible"].Value == true and VisibleCheck(character, torso.Position) then
						if FOVCheck < Settings.aimbot.distance then
							Settings.aimbot.distance = FOVCheck
							closestPlayer = v
						end
					end
				end
			end
        end
    end
	return closestPlayer
end

local function triggerBot()
	if OrionLib.Flags["aimbot_triggerbot_enable"].Value == true and workspace.Status.RoundOver.Value == false and workspace.Status.Preparation.Value == false then
		local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(Settings.aimbot.target.Character.Head.Position)
		local FOVCheck = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
		local distance = Settings.aimbot.distance >= 10 and 70 or Settings.aimbot.distance >= 20 and 50 or Settings.aimbot.distance >= 30 and 40 or Settings.aimbot.distance >= 40 and 30 or 20
		TriggerbotFOV.Radius = distance
		if OrionLib.Flags["aimbot_method"].Value == "Silent Aim" and OblivionASD.Value == 0 or OrionLib.Flags["aimbot_method"].Value ~= "Silent Aim" and FOVCheck < distance and OblivionASD.Value == 0 then
			if OrionLib.Flags["aimbot_stand_still"].Value == true and Settings.aimbot.standing == true or OrionLib.Flags["aimbot_stand_still"].Value == false then
				OblivionASD.Value = OrionLib.Flags["aimbot_shooting_delay"].Value == true and getGunName() and Settings.weapon_data[getGunName()].data.triggerbot_delay or OrionLib.Flags["aimbot_shooting_delay"].Value == true and 100 or OrionLib.Flags["aimbot_shooting_delay"].Value == false and 0
				Client.firebullet()
			end
		end
	end
end

local function mainPlayerCheck(player)
	if player ~= LocalPlayer and IsAlive(player) and GetTeam(player) ~= "s" then
		if checkGamemode("team") and GetTeam(LocalPlayer) ~= GetTeam(player) or checkGamemode("ffa") then
			local a, b = GetCharacter(player)
			if OrionLib.Flags["aimbot_visible"].Value == true and VisibleCheck(a, b.Position) or OrionLib.Flags["aimbot_visible"].Value == false then
				local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(player.Character.Head.Position)
				local FOVCheck = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
				if OrionLib.Flags["aimbot_fov_only"].Value == true and FOVCheck < (FOV.Radius * 2) or OrionLib.Flags["aimbot_fov_only"].Value == true and OrionLib.Flags["aimbot_fov_radius"].Value == 0 or OrionLib.Flags["aimbot_fov_only"].Value == false then
					return true
				end
			end
		end
	elseif player == LocalPlayer and IsAlive(LocalPlayer) and GetTeam(LocalPlayer) ~= "s" then
		return true
	end

	return false
end

-- GUI
local AimTab = Window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://4483345998"})
--local RageTab = Window:MakeTab({Name = "Rage"})
local EspTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483362458"})
local SkinsTab = Window:MakeTab({Name = "Skins", Icon = "rbxassetid://4335483762"})
local ViewmodelsTab = Window:MakeTab({Name = "Viewmodels", Icon = "rbxassetid://4483363084"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4384401360"})
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://3605022185"})

AimTab:AddToggle({Name = "Enable", Default = false, Flag = "aimbot_enable", Callback = function() saveData() end})
AimTab:AddToggle({Name = "Visible Only", Default = false, Flag = "aimbot_visible", Callback = function() saveData() end})
AimTab:AddToggle({Name = "Keybind Only", Default = false, Flag = "aimbot_keybind_only", Callback = function(val) saveData() if val == true then local setting = Settings.aimbot.aim == true and "enabled" or Settings.aimbot.aim == false and "disabled" OrionLib:MakeNotification({Name = "Oblivion", Content = "Aimbot is now "..setting, Image = "rbxassetid://4483345998", Time = 3}) end end})
AimTab:AddDropdown({Name = "Aim Priority", Default = "Distance", Options = {"Distance", "Crosshair"}, Flag = "aimbot_priority", Callback = function() saveData() end})
AimTab:AddDropdown({Name = "Aim Method", Default = "Smooth Aim", Options = {"Smooth Aim", "Lock Aim", "Silent Aim"}, Flag = "aimbot_method", Callback = function() saveData() end})
AimTab:AddSlider({Name = "Activation Delay", Min = 0, Max = 1000, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 100, ValueName = "ms", Flag = "aimbot_activation_delay", Callback = function() saveData() end})
AimTab:AddSlider({Name = "Smoothness", Min = 1, Max = 50, Default = 25, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "aimbot_smoothness", Callback = function() saveData() end})
AimTab:AddToggle({Name = "FOV Check", Default = false, Flag = "aimbot_fov_only", Callback = function(val) saveData() FOV.Visible = val end})
AimTab:AddSlider({Name = "FOV Reset", Min = 0, Max = 1000, Default = 300, Color3.fromRGB(255, 255, 255), Increment = 50, Flag = "aimbot_fov_reset", Callback = function() saveData() end})
AimTab:AddSlider({Name = "FOV Thickness", Min = 1, Max = 10, Default = 3, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "aimbot_fov_thickness", Callback = function(val) saveData() FOV.Thickness = val TriggerbotFOV.Thickness = val end})
AimTab:AddSlider({Name = "FOV Radius", Min = 0, Max = 360, Default = 120, Color3.fromRGB(255, 255, 255), Increment = 5, Flag = "aimbot_fov_radius", Callback = function(val) saveData() FOV.Radius = val end})
AimTab:AddSlider({Name = "FOV Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 10, Flag = "aimbot_fov_transparency", Callback = function(val) saveData() FOV.Transparency = (val / 100) TriggerbotFOV.Transparency = (val / 100) end})
AimTab:AddColorpicker({Name = "FOV Color", Default = Color3.fromRGB(255, 255, 255), Flag = "aimbot_fov_color", Callback = function(val) saveData() FOV.Color = val TriggerbotFOV.Color = val end})
AimTab:AddToggle({Name = "TriggerBot", Default = false, Flag = "aimbot_triggerbot_enable", Callback = function() saveData() end})
AimTab:AddToggle({Name = "Triggerbot FOV", Default = false, Flag = "aimbot_triggerbot_fov", Callback = function(val) saveData() TriggerbotFOV.Visible = val end})
AimTab:AddToggle({Name = "Stand Still", Default = false, Flag = "aimbot_stand_still", Callback = function() saveData() end})
AimTab:AddToggle({Name = "Shooting Delay", Default = true, Flag = "aimbot_shooting_delay", Callback = function() saveData() end})
AimTab:AddSlider({Name = "TriggerBot Delay", Min = 0, Max = 1000, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 100, ValueName = "ms", Flag = "aimbot_triggerbot_delay", Callback = function() saveData() end})
AimTab:AddBind({Name = "Bind", Default = Enum.KeyCode.E, Hold = false, Flag = "aimbot_keybind", Callback = function() saveData() Settings.aimbot.aim = Settings.aimbot.aim == true and false or Settings.aimbot.aim == false and true if OrionLib.Flags["aimbot_keybind_only"].Value == true then local setting = Settings.aimbot.aim == true and "enabled" or Settings.aimbot.aim == false and "disabled" OrionLib:MakeNotification({Name = "Oblivion", Content = "Aimbot is now "..setting, Image = "rbxassetid://4483345998", Time = 3}) end end})

--RageTab:AddToggle({Name = "Anti Aim", Default = false, Flag = "rage_anti_aim", Callback = function() saveData() end})

EspTab:AddToggle({Name = "Enable", Default = false, Flag = "esp_enable", Callback = function(val) saveData() espLib.options.enabled = val end})
EspTab:AddToggle({Name = "Visible Only", Default = false, Flag = "esp_visible", Callback = function(val) saveData() espLib.options.visibleOnly = val end})
EspTab:AddToggle({Name = "Team Check", Default = false, Flag = "esp_team_check", Callback = function(val) saveData() espLib.options.teamCheck = val end})
EspTab:AddToggle({Name = "Team Color", Default = false, Flag = "esp_team_color", Callback = function(val) saveData() espLib.options.teamColor = val end})
EspTab:AddToggle({Name = "Name", Default = false, Flag = "esp_name", Callback = function(val) saveData() espLib.options.names = val end})
EspTab:AddToggle({Name = "Health", Default = false, Flag = "esp_health", Callback = function(val) saveData() espLib.options.healthText = val end})
EspTab:AddToggle({Name = "Health Bar", Default = false, Flag = "esp_health_bar", Callback = function(val) saveData() espLib.options.healthBars = val end})
EspTab:AddToggle({Name = "Distance", Default = false, Flag = "esp_distance", Callback = function(val) saveData() espLib.options.distance = val end})
EspTab:AddColorpicker({Name = "Misc Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_misc_color", Callback = function(val) saveData() espLib.options.nameColor = val espLib.options.healthTextColor = val espLib.options.healthBarsColor = val espLib.options.distanceColor = val end})
EspTab:AddSlider({Name = "Misc Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 10, Flag = "esp_misc_transparency", Callback = function(val) saveData() espLib.options.nameTransparency = (val / 100) espLib.options.healthTextTransparency = (val / 100) espLib.options.healthBarsTransparency = (val / 100) espLib.options.distanceTransparency = (val / 100) end})
EspTab:AddSlider({Name = "Box Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_box_transparency", Callback = function(val) saveData() espLib.options.boxesTransparency = (val / 100) end})
EspTab:AddColorpicker({Name = "Box Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_box_color", Callback = function(val) saveData() espLib.options.boxesColor = val end})
EspTab:AddToggle({Name = "Tracers", Default = false, Flag = "esp_tracers", Callback = function(val) saveData() espLib.options.tracers = val end})
EspTab:AddSlider({Name = "Tracer Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_tracer_transparency", Callback = function(val) saveData() espLib.options.tracerTransparency = (val / 100) end})
EspTab:AddColorpicker({Name = "Tracer Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_tracer_color", Callback = function(val) saveData() espLib.options.tracerColor = val end})
EspTab:AddDropdown({Name = "Tracer Origin", Default = "Bottom", Options = {"Bottom", "Top", "Mouse"}, Flag = "esp_tracerorigin", Callback = function(val) saveData() espLib.options.tracerOrigin = val end})

SkinsTab:AddDropdown({Name = "Weapon", Default = "-", Options = {"-"}, Flag = "skins_weapon", Callback = function(val) if val == "-" and OrionLib.Flags["skins_weapon_skin"] then dropdownRefresh("skins_weapon_skin", "-", {"-"}) elseif val ~= "-" and OrionLib.Flags["skins_weapon_skin"] then dropdownRefresh("skins_weapon_skin", Settings.CurrentSkins[val], skinsGunList(val)) end end})
SkinsTab:AddDropdown({Name = "Weapon Skin", Default = "-", Options = {"-"}, Flag = "skins_weapon_skin", Callback = function(val) Settings.CurrentSkins[OrionLib.Flags["skins_weapon"].Value] = val saveData() end})
SkinsTab:AddDropdown({Name = "Knife", Default = "-", Options = {"-"}, Flag = "skins_knife", Callback = function(val) if val == "-" and OrionLib.Flags["skins_knife_skin"] then modelChange("v_T Knife", "v_T Knife") modelChange("v_CT Knife", "v_CT Knife") dropdownRefresh("skins_knife_skin", "-", {"-"}) saveData() elseif val ~= "-" and OrionLib.Flags["skins_knife_skin"] then modelChange("v_T Knife", "v_"..val) modelChange("v_CT Knife", "v_"..val) dropdownRefresh("skins_knife_skin", "Stock", skinsList(val, Settings.knife_data)) saveData() end end})
SkinsTab:AddDropdown({Name = "Knife Skin", Default = "-", Options = {"-"}, Flag = "skins_knife_skin", Callback = function() saveData() end})
SkinsTab:AddDropdown({Name = "Glove", Default = "-", Options = {"-"}, Flag = "skins_glove", Callback = function(val) if val == "-" and OrionLib.Flags["skins_glove_skin"] then dropdownRefresh("skins_glove_skin", "-", {"-"}) saveData() elseif val ~= "-" and OrionLib.Flags["skins_glove_skin"] then dropdownRefresh("skins_glove_skin", "Stock", skinsList(val, Settings.glove_data)) saveData() end end})
SkinsTab:AddDropdown({Name = "Glove Skin", Default = "-", Options = {"-"}, Flag = "skins_glove_skin", Callback = function() saveData() end})
SkinsTab:AddDropdown({Name = "Inventory Spoof", Default = "-", Options = {"-", "Stock Weapons"}, Flag = "skins_additionals", Callback = function(val) local InventoryLoadout, SkinsTable = LocalPlayer.PlayerGui.GUI["Inventory&Loadout"], {} if val == "-" then Client.CurrentInventory = Settings.OldInventory elseif val == "Stock Weapons" then for i,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do if v:IsA("Folder") and game.ReplicatedStorage.Weapons:FindFirstChild(v.Name) then table.insert(SkinsTable, {v.Name.."_Stock"}) end end Client.CurrentInventory = SkinsTable end if InventoryLoadout.Visible == true then InventoryLoadout.Visible = false InventoryLoadout.Visible = true end saveData() end})

ViewmodelsTab:AddToggle({Name = "Toggle Arms", Default = false, Flag = "viewmodels_arms_enable", Callback = function() saveData() end})
ViewmodelsTab:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_arms_color", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_arms_material", Callback = function() saveData() end})
ViewmodelsTab:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_arms_transparency", Callback = function() saveData() end})
ViewmodelsTab:AddToggle({Name = "Toggle Gloves", Default = false, Flag = "viewmodels_gloves_enable", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Show", Default = "Skin", Options = {"Skin", "Color"}, Flag = "viewmodels_gloves_show", Callback = function() saveData() end})
ViewmodelsTab:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_gloves_color", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_gloves_material", Callback = function() saveData() end})
ViewmodelsTab:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_gloves_transparency", Callback = function() saveData() end})
ViewmodelsTab:AddToggle({Name = "Toggle Sleeves", Default = false, Flag = "viewmodels_sleeves_enable", Callback = function() saveData() end})
ViewmodelsTab:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_sleeves_color", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_sleeves_material", Callback = function() saveData() end})
ViewmodelsTab:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_sleeves_transparency", Callback = function() saveData() end})
ViewmodelsTab:AddToggle({Name = "Toggle Weapon", Default = false, Flag = "viewmodels_weapon_enable", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Show", Default = "Skin", Options = {"Skin", "Color"}, Flag = "viewmodels_weapon_show", Callback = function() saveData() end})
ViewmodelsTab:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_weapon_color", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_weapon_material", Callback = function() saveData() end})
ViewmodelsTab:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_weapon_transparency", Callback = function() saveData() end})
ViewmodelsTab:AddToggle({Name = "Buller Tracers", Default = false, Flag = "viewmodels_bullet_tracer_enable", Callback = function() saveData() end})
ViewmodelsTab:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_bullet_tracer_color", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Material", Default = "ForceField", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_bullet_tracer_material", Callback = function() saveData() end})
ViewmodelsTab:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_bullet_tracer_transparency", Callback = function() saveData() end})
ViewmodelsTab:AddToggle({Name = "Bullet Impacts", Default = false, Flag = "viewmodels_bullet_impact_enable", Callback = function() saveData() end})
ViewmodelsTab:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_bullet_impact_color", Callback = function() saveData() end})
ViewmodelsTab:AddDropdown({Name = "Material", Default = "ForceField", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_bullet_impact_material", Callback = function() saveData() end})
ViewmodelsTab:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_bullet_impact_transparency", Callback = function() saveData() end})

MiscTab:AddToggle({Name = "Anti-AFK", Default = false, Flag = "misc_anti_afk", Callback = function(val) saveData() if val == true then coroutine.wrap(function() while OrionLib.Flags["misc_anti_afk"].Value == true do for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do v:Disable() end wait(1) end end)() end end})
MiscTab:AddToggle({Name = "Blood Removal", Default = false, Flag = "misc_blood_removal", Callback = function(val) saveData() if val == true then Settings.loops.bloodremovalloop = game:GetService("RunService").Heartbeat:Connect(function() pcall(function() getsenv(game.Players.LocalPlayer.PlayerGui.Client).splatterBlood = function() end wait(1) end) end) elseif val == false and Settings.loops.bloodremovalloop then Settings.loops.bloodremovalloop:Disconnect() end end})
MiscTab:AddToggle({Name = "Mag Removal", Default = false, Flag = "misc_mag_removal", Callback = function(val) saveData() if val == true then Settings.loops.magremovalloop = workspace.Ray_Ignore.ChildAdded:Connect(function(child) pcall(function() child:WaitForChild("Mesh") if child.Name == "MagDrop" then child:Destroy() end end) end) elseif val == false and Settings.loops.magremovalloop then Settings.loops.magremovalloop:Disconnect() end end})
MiscTab:AddToggle({Name = "Remove Textures", Default = false, Flag = "misc_texture_remove", Callback = function(val) saveData() if val == true then OblivionMapChange.Value = OblivionMapChange.Value + 1 end end})

SettingsTab:AddButton({Name = "Server Hop", Callback = function() Serverhop() end})
SettingsTab:AddButton({Name = "Server Rejoin", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end})
SettingsTab:AddDropdown({Name = "Branch", Default = "-", Options = {"-"}, Flag = "settings_branch", Callback = function(val) if OrionLib.Flags["settings_build"] then dropdownRefresh("settings_build", versions["data"][val]["tables"][1], getAllNames(versions["data"][val]["tables"], "empty")) end end})
SettingsTab:AddDropdown({Name = "Build", Default = "-", Options = {"-"}, Flag = "settings_build"})
SettingsTab:AddButton({Name = "Set", Callback = function() writefile("oblivion/load_version.txt", versions["data"][OrionLib.Flags["settings_branch"].Value]["data"][OrionLib.Flags["settings_build"].Value]) end})

-- Meta
workspace.CurrentCamera.ChildAdded:Connect(function(new)
	local Model
	for i,v in pairs(new:GetChildren()) do      
		if v:IsA("Model") and (v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm")) then      
			Model = v      
		end      
	end      
	if Model == nil then return end

	local weaponname = Client.gun ~= "none" and knifeOrGun() == "knife" and OrionLib.Flags["skins_knife"].Value ~= "-" and OrionLib.Flags["skins_knife"].Value or Client.gun ~= "none" and knifeOrGun() == "gun" and Client.gun.Name
	if weaponname ~= nil and game:GetService("ReplicatedStorage").Skins:FindFirstChild(weaponname) then  
		local var = knifeOrGun() == "knife" and OrionLib.Flags["skins_knife_skin"].Value ~= "Stock" and OrionLib.Flags["skins_knife_skin"].Value or knifeOrGun() == "gun" and Settings.CurrentSkins[getGunNameFromCheck(weaponname)]
		if var ~= nil then
			MapSkin(weaponname, var)
		end      
	end

	RArm = Model:FindFirstChild("Right Arm"); LArm = Model:FindFirstChild("Left Arm") 
	if RArm then
		RGlove = RArm:FindFirstChild("Glove") or RArm:FindFirstChild("RGlove")
		if OrionLib.Flags["skins_glove"].Value ~= "-" and Client.gun ~= "none" and OrionLib.Flags["skins_glove_skin"].Value ~= "Stock" then
			if RGlove then RGlove:Destroy() end      
			RGlove = game:GetService("ReplicatedStorage").Gloves.Models[OrionLib.Flags["skins_glove"].Value].RGlove:Clone()      
			RGlove.Mesh.TextureId = game:GetService("ReplicatedStorage").Gloves[OrionLib.Flags["skins_glove"].Value][OrionLib.Flags["skins_glove_skin"].Value].Textures.TextureId      
			RGlove.Parent = RArm      
			RGlove.Transparency = 0      
			RGlove.Welded.Part0 = RArm      
		end
	end
	if LArm then
		LGlove = LArm:FindFirstChild("Glove") or LArm:FindFirstChild("LGlove")      
		if OrionLib.Flags["skins_glove"].Value ~= "-" and Client.gun ~= "none" and OrionLib.Flags["skins_glove_skin"].Value ~= "Stock" then      
			if LGlove then LGlove:Destroy() end      
			LGlove = game:GetService("ReplicatedStorage").Gloves.Models[OrionLib.Flags["skins_glove"].Value].LGlove:Clone()       
			LGlove.Mesh.TextureId = game:GetService("ReplicatedStorage").Gloves[OrionLib.Flags["skins_glove"].Value][OrionLib.Flags["skins_glove_skin"].Value].Textures.TextureId      
			LGlove.Transparency = 0      
			LGlove.Parent = LArm      
			LGlove.Welded.Part0 = LArm      
		end   
	end

	coroutine.wrap(function()
		if new.Name == "Arms" and new:IsA("Model") then
			for i,v in pairs(new:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm") then
					local RightArm = v:FindFirstChild("Right Arm") or nil
					local LeftArm = v:FindFirstChild("Left Arm") or nil
					local RightGlove = (RightArm and (RightArm:FindFirstChild("Glove") or RightArm:FindFirstChild("RGlove"))) or nil
					local LeftGlove = (LeftArm and (LeftArm:FindFirstChild("Glove") or LeftArm:FindFirstChild("LGlove"))) or nil
					local RightSleeve = RightArm and RightArm:FindFirstChild("Sleeve") or nil
					local LeftSleeve = LeftArm and LeftArm:FindFirstChild("Sleeve") or nil
					if OrionLib.Flags["viewmodels_arms_enable"].Value == true then
						if RightArm ~= nil then
							RightArm.Mesh.TextureId = ""
							RightArm.Transparency = (OrionLib.Flags["viewmodels_arms_transparency"].Value / 100)
							RightArm.Color = OrionLib.Flags["viewmodels_arms_color"].Value
							RightArm.Material = OrionLib.Flags["viewmodels_arms_material"].Value
						end
						if LeftArm ~= nil then
							LeftArm.Mesh.TextureId = ""
							LeftArm.Transparency = (OrionLib.Flags["viewmodels_arms_transparency"].Value / 100)
							LeftArm.Color = OrionLib.Flags["viewmodels_arms_color"].Value
							LeftArm.Material = OrionLib.Flags["viewmodels_arms_material"].Value
						end
					end
					if OrionLib.Flags["viewmodels_gloves_enable"].Value == true then
						if RightGlove ~= nil then
							if OrionLib.Flags["viewmodels_gloves_show"].Value ~= "Skin" then
								RightGlove.Mesh.TextureId = ""
							end
							
							if OrionLib.Flags["viewmodels_gloves_show"].Value == "Color" then
								RightGlove.Color = OrionLib.Flags["viewmodels_gloves_color"].Value
							end

							RightGlove.Transparency = (OrionLib.Flags["viewmodels_gloves_transparency"].Value / 100)
							RightGlove.Material = OrionLib.Flags["viewmodels_gloves_material"].Value
						end
						if LeftGlove ~= nil then
							if OrionLib.Flags["viewmodels_gloves_show"].Value ~= "Skin" then
								LeftGlove.Mesh.TextureId = ""
							end
							
							if OrionLib.Flags["viewmodels_gloves_show"].Value == "Color" then
								LeftGlove.Color = OrionLib.Flags["viewmodels_gloves_color"].Value
							end

							LeftGlove.Transparency = (OrionLib.Flags["viewmodels_gloves_transparency"].Value / 100)
							LeftGlove.Material = OrionLib.Flags["viewmodels_gloves_material"].Value
						end
					end
					if OrionLib.Flags["viewmodels_sleeves_enable"].Value == true then
						if RightSleeve ~= nil then
							RightSleeve.Mesh.TextureId = ""
							RightSleeve.Color = OrionLib.Flags["viewmodels_sleeves_color"].Value
							RightSleeve.Transparency = (OrionLib.Flags["viewmodels_sleeves_transparency"].Value / 100)
							RightSleeve.Material = OrionLib.Flags["viewmodels_sleeves_material"].Value
						end
						if LeftSleeve ~= nil then
							LeftSleeve.Mesh.TextureId = ""
							LeftSleeve.Color = OrionLib.Flags["viewmodels_sleeves_color"].Value
							LeftSleeve.Transparency = (OrionLib.Flags["viewmodels_sleeves_transparency"].Value / 100)
							LeftSleeve.Material = OrionLib.Flags["viewmodels_sleeves_material"].Value
						end
					end
				elseif OrionLib.Flags["viewmodels_weapon_enable"].Value == true and v:IsA("BasePart") and not table.find({"Right Arm", "Left Arm", "Flash"}, v.Name) and v.Transparency ~= 1 then
					if OrionLib.Flags["viewmodels_weapon_show"].Value ~= "Skin" then
						if v:IsA("MeshPart") then v.TextureID = "" end
						if v:FindFirstChildOfClass("SpecialMesh") then v:FindFirstChildOfClass("SpecialMesh").TextureId = "" end
					end
	
					if OrionLib.Flags["viewmodels_weapon_show"].Value == "Color" then
						v.Color = OrionLib.Flags["viewmodels_weapon_color"].Value
					end
	
					v.Transparency = (OrionLib.Flags["viewmodels_weapon_transparency"].Value / 100)
					v.Material = OrionLib.Flags["viewmodels_weapon_material"].Value
				end
			end
		end
	end)()
end)

hookfunc(getrenv().xpcall, function() end)

local mt = getrawmetatable(game)

if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end

oldNamecall = hookfunc(mt.__namecall, newcclosure(function(self, ...)
    local method = getnamecallmethod()
	local callingscript = getcallingscript()
    local args = {...}
	
	if not checkcaller() then
		if method == "Kick" then
			return
		elseif method == "FireServer" then
			if string.len(self.Name) == 38 then
				return wait(99e99)
            elseif self.Name == "HitPart" then
                if OrionLib.Flags["viewmodels_bullet_tracer_enable"].Value == true then
					coroutine.wrap(function()
						local BulletTracers = Instance.new("Part")
						BulletTracers.Anchored = true
						BulletTracers.CanCollide = false
						BulletTracers.Material = OrionLib.Flags["viewmodels_bullet_tracer_material"].Value
						BulletTracers.Color = OrionLib.Flags["viewmodels_bullet_tracer_color"].Value
                        BulletTracers.Transparency = (OrionLib.Flags["viewmodels_bullet_tracer_transparency"].Value / 100)
						BulletTracers.Size = Vector3.new(0.1, 0.1, (LocalPlayer.Character.Head.CFrame.p - args[2]).magnitude)
						BulletTracers.CFrame = CFrame.new(LocalPlayer.Character.Head.CFrame.p, args[2]) * CFrame.new(0, 0, -BulletTracers.Size.Z / 2)
						BulletTracers.Name = "BulletTracers"
						BulletTracers.Parent = workspace.CurrentCamera
						wait(3)
						BulletTracers:Destroy()
					end)()
				end
                if OrionLib.Flags["viewmodels_bullet_impact_enable"].Value == true then
					coroutine.wrap(function()
						local BulletImpacts = Instance.new("Part")
						BulletImpacts.Anchored = true
						BulletImpacts.CanCollide = false
						BulletImpacts.Material = OrionLib.Flags["viewmodels_bullet_impact_material"].Value
						BulletImpacts.Color = OrionLib.Flags["viewmodels_bullet_impact_color"].Value
                        BulletImpacts.Transparency = (OrionLib.Flags["viewmodels_bullet_impact_transparency"].Value / 100)
						BulletImpacts.Size = Vector3.new(0.25, 0.25, 0.25)
						BulletImpacts.CFrame = CFrame.new(args[2])
						BulletImpacts.Name = "BulletImpacts"
						BulletImpacts.Parent = workspace.CurrentCamera
						wait(3)
						BulletImpacts:Destroy()
					end)()
				end
			elseif self.Name == "ApplyGun" and args[1] == game.ReplicatedStorage.Weapons.Banana or args[1] == game.ReplicatedStorage.Weapons["Flip Knife"] then
				args[1] = game.ReplicatedStorage.Weapons.Karambit
			elseif self.Name == "test" then
				return wait(99e99)
			elseif self.Name == "DataEvent" and args[1][1] == "EquipItem" then
				local Weapon,Skin = args[1][3], string.split(args[1][4][1], "_")[2]
				local EquipTeams = (args[1][2] == "Both" and {"T", "CT"}) or {args[1][2]}

				for i,v in pairs(EquipTeams) do
					LocalPlayer.SkinFolder[v.."Folder"][Weapon]:ClearAllChildren()
					LocalPlayer.SkinFolder[v.."Folder"][Weapon].Value = Skin
					
					if args[1][4][2] == "StatTrak" then
						local Marker = Instance.new("StringValue")
						Marker.Name = "StatTrak"
						Marker.Value = args[1][4][3]
						Marker.Parent = LocalPlayer.SkinFolder[v.."Folder"][Weapon]
						
						local Count = Instance.new("IntValue")
						Count.Name = "Count"
						Count.Value = args[1][4][4]
						Count.Parent = Marker
					end
				end
			end
		elseif method == "InvokeServer" then
			if self.Name == "Moolah" then
				return wait(99e99)
			elseif self.Name == "Hugh" then
				return wait(99e99)
			end
		elseif method == "FindPartOnRayWithIgnoreList" and args[2][1] == workspace.Debris then
			if OrionLib.Flags["aimbot_method"].Value == "Silent Aim" and Settings.aimbot.target ~= nil then
				args[1] = Ray.new(LocalPlayer.Character.Head.Position, (Settings.aimbot.target.Character.Head.Position - LocalPlayer.Character.Head.Position).unit * (game.ReplicatedStorage.Weapons[LocalPlayer.Character.EquippedTool.Value].Range.Value * 0.1))
			end
        end
	end
	
	return oldNamecall(self, unpack(args))
end))

Mouse.Move:Connect(function()
	if FOV.Visible then
		FOV.Position = game:GetService("UserInputService"):GetMouseLocation()
	end
	if TriggerbotFOV.Visible then
		TriggerbotFOV.Position = game:GetService("UserInputService"):GetMouseLocation()
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	pcall(function()
		if OblivionASD.Value ~= 0 then
			OblivionASD.Value = OblivionASD.Value - 1
		end

		coroutine.wrap(function()
			if OrionLib.Flags["aimbot_enable"].Value == true then
				local val = getClosestPlayer()
				if val then
					Settings.aimbot.targetresettime = OrionLib.Flags["aimbot_fov_reset"].Value
					Settings.aimbot.target = val
				elseif Settings.aimbot.target ~= nil then
					if Settings.aimbot.targetresettime == 0 or not mainPlayerCheck(Settings.aimbot.target) then
						Settings.aimbot.target = nil
					elseif Settings.aimbot.targetresettime ~= 0 then
						Settings.aimbot.targetresettime = Settings.aimbot.targetresettime - 1
					end
				end
			end
		end)()

		coroutine.wrap(function()
			if OrionLib.Flags["aimbot_triggerbot_enable"].Value == true and Settings.aimbot.target and mainPlayerCheck(LocalPlayer) then
				if OrionLib.Flags["aimbot_method"].Value ~= "Silent Aim" then
					if OrionLib.Flags["aimbot_triggerbot_delay"].Value ~= 0 then
						wait((OrionLib.Flags["aimbot_triggerbot_delay"].Value / 1000))
					end
					triggerBot()
				end
			end
		end)()

		coroutine.wrap(function()
			if OrionLib.Flags["aimbot_enable"].Value == true and mainPlayerCheck(LocalPlayer) then
				if Settings.aimbot.target and IsAlive(Settings.aimbot.target) then
					if OrionLib.Flags["aimbot_keybind_only"].Value == false or OrionLib.Flags["aimbot_keybind_only"].Value == true and Settings.aimbot.aim == true then
						coroutine.wrap(function()
							if OrionLib.Flags["aimbot_activation_delay"].Value ~= 0 then
								wait((OrionLib.Flags["aimbot_activation_delay"].Value / 1000))
							end
							if OrionLib.Flags["aimbot_method"].Value == "Lock Aim" and Settings.aimbot.target ~= nil then
								workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Settings.aimbot.target.Character.Head.Position)
							elseif OrionLib.Flags["aimbot_method"].Value == "Smooth Aim" and Settings.aimbot.target ~= nil then
								local Pos = workspace.CurrentCamera:WorldToScreenPoint(Settings.aimbot.target.Character.Head.Position)
								local Magnitude = Vector2.new(Pos.X - Mouse.X, Pos.Y - Mouse.Y)
								mousemoverel(Magnitude.x/OrionLib.Flags["aimbot_smoothness"].Value, Magnitude.y/OrionLib.Flags["aimbot_smoothness"].Value)
							end
						end)()
					end
				end
			end
		end)()

		if OrionLib.Flags["aimbot_stand_still"].Value == true and mainPlayerCheck(LocalPlayer) and LocalPlayer.Character.HumanoidRootPart.Velocity.Magnitude < 3 then
			Settings.aimbot.standing = true
		else
			Settings.aimbot.standing = false
		end

		if Settings.aimbot.target == nil then
			TriggerbotFOV.Radius = 1
		end

		if Settings.currentmap ~= workspace.Map.Origin.Value then
			Settings.currentmap = workspace.Map.Origin.Value
			OblivionMapChange.Value = OblivionMapChange.Value + 1
		end
	end)
end)

OblivionMapChange:GetPropertyChangedSignal("Value"):Connect(function()
	pcall(function()
		if OrionLib.Flags["misc_texture_remove"].Value == true then
			local decalsyeeted = false
			local g = game
			local w = g.Workspace
			local l = g.Lighting
			local t = w.Terrain
			sethiddenproperty(t,"Decoration",false)
			t.WaterWaveSize = 0
			t.WaterWaveSpeed = 0
			t.WaterReflectance = 0
			t.WaterTransparency = 0
			l.GlobalShadows = 0
			l.FogEnd = 9e9
			l.Brightness = 0
			for i, v in pairs(w:GetDescendants()) do
				if v:IsA("BasePart") and not v:IsA("MeshPart") then
					v.Material = "Plastic"
					v.Reflectance = 0
				elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
					v.Transparency = 1
				elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
					v.Lifetime = NumberRange.new(0)
				elseif v:IsA("Explosion") then
					v.BlastPressure = 1
					v.BlastRadius = 1
				elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
					v.Enabled = false
				elseif v:IsA("MeshPart") and decalsyeeted then
					v.Material = "Plastic"
					v.Reflectance = 0
					v.TextureID = 10385902758728957
				elseif v:IsA("SpecialMesh") and decalsyeeted  then
					v.TextureId=0
				elseif v:IsA("ShirtGraphic") and decalsyeeted then
					v.Graphic=0
				elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
					v[v.ClassName.."Template"]=0
				end
			end
			for i = 1,#l:GetChildren() do
				e=l:GetChildren()[i]
				if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
					e.Enabled = false
				end
			end
		end
	end)
end)

-- Init
for _, Model in pairs(game:GetService("ReplicatedStorage").Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = Models
end

dropdownRefresh("skins_weapon", "-", getAllNames(Settings.weapon_data))
dropdownRefresh("skins_knife", "-", getAllNames(Settings.knife_data))
dropdownRefresh("skins_glove", "-", getAllNames(Settings.glove_data))
dropdownRefresh("settings_branch", versions["tables"][1], versions["tables"])

if isfile("oblivion/data.cfg") then
	OrionLib:MakeNotification({Name = "Oblivion", Content = "Trying to load save.", Image = "rbxassetid://4384402413", Time = 5})
	local output
	local a,b = pcall(function()
		output = loadstring("return"..readfile("oblivion/data.cfg"))()
	end)
	if a == true then
		for i,v in pairs(output.data) do
			for i2,v2 in pairs(v) do
                if OrionLib.Flags[i2] then
				    OrionLib.Flags[i2]:Set(v2.Value)
                else
                    Settings.saveerror = true
                end
			end
		end
		Settings.CurrentSkins = output.skins
        if Settings.saveerror == true then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Some values might be corrupted in the save.", Image = "rbxassetid://4384402990", Time = 5})
        elseif Settings.saveerror == false then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Succesfully loaded save.", Image = "rbxassetid://4384403532", Time = 5})
        end
	elseif a == false then
		OrionLib:MakeNotification({Name = "Oblivion", Content = "Error loading save.", Image = "rbxassetid://4384402990", Time = 10})
	end
end

OblivionRan.Value = true
OrionLib:Init()
espLib.Init()
OrionLib:MakeNotification({Name = "Oblivion", Content = "Succesfully loaded.", Image = "rbxassetid://4400702457", Time = 5})
OrionLib:MakeNotification({Name = "Oblivion", Content = "Welcome "..LocalPlayer.Name..".", Image = "rbxassetid://4431165334", Time = 10})

--[[
	List:
		[High]

		[Mid]
		-Aimbot Distance/Crosshair prioritization, both if possible working together [Low] [Working]
		-Aimbot Silent Aim with triggerbot [Unknown]

		[Low]
		-Transfer all features from my modified hex to Oblivion. [Mid]
]]--