--[[
    Made by:
    SomeoneIdfk

	Please don't steal, it's already open source.
]]--

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

-- Environment 
local getrawmetatable = getrawmetatable or false
local getsenv = getsenv or false
local listfiles = listfiles or listdir or syn_io_listdir or false
local hookfunc = hookfunc or hookfunction or replaceclosure or false
local workspace = workspace or game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Config
if not isfolder("oblivion") then
    makefolder("oblivion")
end

if not isfolder("oblivion/CB") then
	makefolder("oblivion/CB")
end

if isfile("oblivion/CB/tagged.cfg") then
	TaggedSkids = loadstring("return "..readfile("oblivion/CB/tagged.cfg"))()
else
	TaggedSkids = {}
end

local file_versions, file_updated = loadstring("return "..game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/file_versions.cfg"))(), false

for i,v in pairs(file_versions) do
	if not isfile("oblivion/CB/"..i) then
		writefile("oblivion/CB/"..i, game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/"..i))
		file_updated = true
	elseif isfile("oblivion/CB/"..i) then
		local var = loadstring("return "..readfile("oblivion/CB/"..i))()
		if not var["data"] or not var.data["version"] then
			writefile("oblivion/CB/"..i, game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/"..i))
			file_updated = true
		elseif var.data.version ~= v then
			writefile("oblivion/CB/"..i, game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/"..i))
			file_updated = true
		end
	end
end

-- Main
repeat wait() until workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Origin")

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local espLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Sirius/request/library/esp/esp.lua')))()
local versions, versiontable = loadstring("return "..game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/versions.cfg"))(), {}

local Settings = {CurrentSkins = {}, LastStep = nil, Ping = nil, dropdownfilter = false, CustomSkins = false, data = {}, tags = {countlabel = nil, onlinelabel = nil, cooldown = 0, cooldowntoggle = false, page = 0}, aimbot = {enable = false, method = "distance", aim = false, target = nil, standing = false, distance = math.huge, targetresettime = 0, filter = false, visiblereset = {["rage_kill_player_1"] = {time = 0, value = false}, ["rage_kill_player_2"] = {time = 0, value = false}, ["rage_kill_player_3"] = {time = 0, value = false}}}, playerlist = {}, lists = {refreshplayerlist = false, alive_enemies = {}, alive_visible_enemies = {}, cooldownlist = {}}, saveerror = false, godmodeused = false, currentmap = nil, weapon_data = table.foreach(loadstring("return "..readfile("oblivion/CB/weapon_data.cfg"))(), function(i,v) if i == "guns" then return v end end), knife_data = table.foreach(loadstring("return "..readfile("oblivion/CB/weapon_data.cfg"))(), function(i,v) if i == "knives" then return v end end), glove_data = table.foreach(loadstring("return "..readfile("oblivion/CB/weapon_data.cfg"))(), function(i,v) if i == "gloves" then return v end end), weapon_info = loadstring("return "..readfile("oblivion/CB/weapon_data.cfg"))(), weapon_types = loadstring("return "..readfile("oblivion/CB/weapon_types.cfg"))(), loops = {bloodremovalloop = nil, magremovalloop = nil}, teleportreset = true, falldamagefilter = false, calctargets = false, calcstep = nil, loopresult = 0, TaggedColor = Color3.fromRGB(150, 0, 0), DeadColor = Color3.fromRGB(50, 50, 50), WarningColor = Color3.fromRGB(255, 255, 0), deadzones = false, troll = {sound = {running = false, sounds = {["TTT a"] = workspace.RoundEnd, ["TTT b"] = workspace.RoundStart, ["T Win"] = workspace.Sounds.T, ["CT Win"] = workspace.Sounds.CT, ["Planted"] = workspace.Sounds.Arm, ["Defused"] = workspace.Sounds.Defuse, ["Rescued"] = workspace.Sounds.Rescue, ["Explosion"] = workspace.Sounds.Explosion, ["Becky"] = workspace.Sounds.Becky, ["Beep"] = workspace.Sounds.Beep}}}, rage = {antiaim = {1, -1, -5/93 -13, 20, math.huge -5/0 -1, 23, -13, 12, -92, 15, math.huge, -13, 2.5}, spin = 0}, defaultGravity = workspace.Gravity}
Settings.CurrentSkins["-"] = "-"

for i,v in pairs(Settings.weapon_data) do
	Settings.CurrentSkins[i] = "Stock"
end
for i,v in pairs(Settings.knife_data) do
	Settings.CurrentSkins[i] = "Stock"
end

local LocalPlayer = game:GetService('Players').LocalPlayer
local Client = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
local DisplayChat = getsenv(LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat)
local createNewMessage = DisplayChat.createNewMessage
local Mouse = LocalPlayer:GetMouse()
local FOV = Drawing.new("Circle")
FOV.Thickness = 2
local TriggerbotFOV = Drawing.new("Circle")
TriggerbotFOV.Thickness = 2
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)

local IgnoredFlags = {"settings_branch", "settings_build", "skins_weapon", "skins_weapon_skin", "tags_select_player", "tags_select_tag", "skins_knife_skin", "rage_kill_player_1", "rage_kill_player_enable_1", "rage_kill_player_2", "rage_kill_player_enable_2", "rage_kill_player_3", "rage_kill_player_enable_3", "tags_merge_file", "troll_sound_spam"}
local Hitboxes = {"Head", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "UpperTorso", "LowerTorso"}

OrionLib:MakeNotification({Name = "Oblivion", Content = "Oblivion is loading.", Image = "rbxassetid://4400702947", Time = 3})

if file_updated == true then OrionLib:MakeNotification({Name = "Oblivion", Content = "Updated/Created necessary files.", Image = "rbxassetid://4400702947", Time = 5}) end

local Window = OrionLib:MakeWindow({Name = "Oblivion", HidePremium = true, IntroEnabled = false, Icon = "rbxassetid://1521636846"})

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
	
		--[[if IgnoredTables[Table] then
			return IgnoredTables[Table] == Depth - 1 and '[Parent table]' or '[Cyclic Table]'
		end]]--
	
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
				
				--[[if Key:match'%s' then
					Key = ('["%s"]'):format(Key)
				end]]--
				
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

local function checkId()
	for i,v in pairs(versions) do
        if type(v.gameid) == "table" and table.find(v.gameid, game.PlaceId) or type(v.gameid) == "number" and v.gameid == game.PlaceId then
            return v
        end
    end

	return false
end

local function checkFile()
    if isfile("oblivion/CB/settings.cfg") then
        local var = loadstring("return "..readfile("oblivion/CB/settings.cfg"))()
		return var
    end

    return false
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
	if ReplicatedStorage.Viewmodels:FindFirstChild(model) then
		if Models:FindFirstChild(replace) then
			ReplicatedStorage.Viewmodels[model]:Destroy()
			wait()
			local Model1 = Instance.new("Model", ReplicatedStorage.Viewmodels)
			local Clone = Models[replace]:Clone()
			Clone.Parent = Model1
			Model = ReplicatedStorage.Viewmodels.Model
			for _, Child in pairs(Model:GetChildren()) do
				Child.Parent = Model.Parent
			end
			Model:Destroy()
			ReplicatedStorage.Viewmodels[replace].Name = model

			return true
		else
			return false
		end
	else
		return false
	end
end

local function MapSkin(weapon, skin)
	local SkinData = ReplicatedStorage.Skins:FindFirstChild(weapon):FindFirstChild(skin)
	if SkinData and not SkinData:FindFirstChild("Animated") then
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

local function skinsList(value, list)
	local temp = {}
	table.foreach(list, function(i, v)
		if i == value then
			table.foreach(v.list, function(i2, v2)
				table.insert(temp, v2)
			end)
		end
	end)

	return temp
end

local function hasCustom(shelf, weapon)
	if Settings.weapon_info[shelf] and Settings.weapon_info[shelf][weapon] and Settings.weapon_info[shelf][weapon]["custom_list"] then
		return true
	end

	return false
end

local function skinsGunList(gun, state, type)
	local temp = {}
    --[[local temp = (
		OrionLib.Flags["skins_custom"].Value == false and {} or
		OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) == false and {} or
		OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) and state == "normal" and {[1] = "Show custom skins"} or
		OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) and state == "custom" and {[1] = "Show normal skins"}
	)]]
	if OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) then
		table.insert(temp, state == "normal" and "Show custom skins" or state == "custom" and "Show normal skins")
	end
	if state == "normal" then
		for i,v in pairs(Settings.weapon_info[type][gun].list) do
			table.insert(temp, v)
		end
	elseif state == "custom" then
		for i,v in pairs(Settings.weapon_info[type][gun].custom_list) do
			table.insert(temp, i)
		end
	end
    return temp
end

local function Serverhop()
	local x = {}
	for _, v in ipairs(HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")).data) do
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
        local temp = {[1] = {["skins_custom"] = {}} , [2] = {["skins_knife"] = {}}, [3] = {["skins_glove"] = {}}, [4] = {["skins_glove_skin"] = {}}}
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
        writefile("oblivion/CB/data.cfg", SaveTable(tempmaster))
    end
end

local function dropdownRefresh(flag, value, list)
	OrionLib.Flags[flag]:Refresh(list, true)
	if table.find(list, value) then
		OrionLib.Flags[flag]:Set(value)
	elseif not table.find(list, value) then
		OrionLib.Flags[flag]:Set(list[1])
	end
end

local function dropdownCustom(state, type)
	local var = skinsGunList(OrionLib.Flags[type == "guns" and "skins_weapon" or type == "knives" and "skins_knife"].Value, state, type)
	OrionLib.Flags[type == "guns" and "skins_weapon_skin" or type == "knives" and "skins_knife_skin"]:Refresh({"-"}, true)
	Settings.dropdownfilter = true
	OrionLib.Flags[type == "guns" and "skins_weapon_skin" or type == "knives" and "skins_knife_skin"]:Set("-")
	repeat wait() until Settings.dropdownfilter == false
	OrionLib.Flags[type == "guns" and "skins_weapon_skin" or type == "knives" and "skins_knife_skin"]:Refresh(var, true)
	if table.find(var, Settings.CurrentSkins[OrionLib.Flags[type == "guns" and "skins_weapon" or type == "knives" and "skins_knife"].Value]) then
        Settings.dropdownfilter = true
		OrionLib.Flags[type == "guns" and "skins_weapon_skin" or type == "knives" and "skins_knife_skin"]:Set(Settings.CurrentSkins[OrionLib.Flags[type == "guns" and "skins_weapon" or type == "knives" and "skins_knife"].Value])
    else
		Settings.dropdownfilter = true
		OrionLib.Flags[type == "guns" and "skins_weapon_skin" or type == "knives" and "skins_knife_skin"]:Set(var[1])
	end
end

local function GetCharacter(player)
    local character = player.Character
    return character, character and game.FindFirstChild(character, "HumanoidRootPart")
end

local function VisibleCheck(character, position)
    local origin = workspace.CurrentCamera.CFrame.Position
    local part = workspace.FindPartOnRayWithIgnoreList(workspace, Ray.new(origin, position - origin), {GetCharacter(LocalPlayer), workspace.CurrentCamera, character}, false, true)
    if part then
		return #workspace.CurrentCamera:GetPartsObscuringTarget({origin, position}, {GetCharacter(LocalPlayer), workspace.CurrentCamera, character}) == 0 and true or false
	end

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

local function checkGame()
	if game.PlaceId == 301549746 then
		return "casual"
	elseif game.PlaceId == 1480424328 then
		return "unranked"
	elseif game.PlaceId == 1869597719 then
		return "deathmatch"
	end
end

local function IsAlive(plr)
	if plr and plr.Character and plr.Character.FindFirstChild(plr.Character, "Humanoid") and plr.Character.Humanoid.Health > 0 and GetTeam(plr) ~= "s" then
		return true
	end

	return false
end

local function knifeOrGun()
	local a,b = pcall(function()
		local val = table.foreach(Settings.weapon_data, function(i, v)
			if Client.gun and Client.gun ~= "none" and v.name == Client.gun.Name then
				return "gun"
			end
		end)

		if val then
			return "gun"
		end
	end)

	local c,d = pcall(function()
		return Client.gun:FindFirstChild("Melee")
	end)

	if a and b == "gun" then
		return "gun"
	elseif c and d then
		return "knife"
	elseif not a or not c then
		return "unknown"
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
				Settings.aimbot.filter = true
				Client.firebullet()
				Settings.aimbot.filter = false
			end
		end
	end
end

local function PlayerCheck(player)
    if player ~= LocalPlayer and IsAlive(player) and GetTeam(player) ~= "s" then
		if checkGamemode("team") and GetTeam(LocalPlayer) ~= GetTeam(player) or checkGamemode("ffa") then
            return true
        end
    end

    return false
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

local function backendcompareTables(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = type(v) == "table" and backendcompareTables(v) or v
    end
     table.sort(copy, function(a, b)
        if type(a) ~= type(b) then return type(a) > type(b) end
        if type(a) == "table" then
            return HttpService:JSONEncode(a) > HttpService:JSONEncode(b)
        end
        return tostring(a) > tostring(b)
    end)
    return copy
end

local function compareTables(table1, table2)
    return HttpService:JSONEncode(backendcompareTables(table1)) == HttpService:JSONEncode(backendcompareTables(table2))
end

local function tagsTableFind(value, field)
	local success = table.foreach(TaggedSkids, function(i, v)
		local success = table.foreach(v, function(i2, v2)
			if field == "id" and i2 == value or field == "name" and v2 == value then
				return true
			end
		end)

		if success == true then
			return i
		end
	end)

	if success then
		return success
	else
		return false
	end
end

local function tagsListUsernames(type)
	local range, increment, temp = {min = Settings.tags.page * 100, max = ((Settings.tags.page + 1) * 100), pre = 0}, 0, {}
	if #TaggedSkids >= (Settings.tags.page * 100) then
		if type == "page" and Settings.tags.page ~= 0 then
			table.insert(temp, "Previous Page")
			range.pre = range.pre + 1
		end
		if type == "page" and #TaggedSkids > ((Settings.tags.page + 1) * 100) then
			table.insert(temp, "Next Page")
			range.pre = range.pre + 1
		end
		table.insert(temp, "-")
		range.pre = range.pre + 1
	end
	table.foreach(TaggedSkids, function(i, v)
		table.foreach(v, function(i2, v2)
			increment = increment + 1
			if type == "page" and increment > range.min and increment <= range.max or type == "all" then
				table.insert(temp, v2)
			end
		end)
	end)

	if #temp - range.pre == 0 and Settings.tags.page ~= 0 then
		Settings.tags.page = Settings.tags.page - 1
		temp = tagsListUsernames("page")
	end

	return temp
end

local function tagsListUserIds(page)
	local temp, range, increment = {}, {min = page * 100, max = ((page + 1) * 100)}, 0
	table.foreach(TaggedSkids, function(i, v)
		table.foreach(v, function(i2, v2)
			increment = increment + 1
			if increment > range.min and increment <= range.max then
				table.insert(temp, i2)
			end
		end)
	end)

	return temp
end

local function tagsUpdateLabels(method, table)
	if method == "live" and table then
		if Settings.tags.onlinelabel then
			Settings.tags.onlinelabel:Set("Online: "..tostring(table["IsOnline"]))
		end

		return true
	elseif method == "live_reset" then
		if Settings.tags.onlinelabel then
			Settings.tags.onlinelabel:Set("Online:")
		end

		return true
	elseif method == "offline" then
		if Settings.tags.countlabel then
			Settings.tags.countlabel:Set("Tagged Players: "..(#tagsListUsernames("all") - 1))
		end

		return true
	end
	
	return false
end

local function tagsListIdFromUsername(username)
	local success = table.foreach(TaggedSkids, function(i, v)
		local success = table.foreach(v, function(i2, v2)
			if v2 == username then
				return i2
			end
		end)

		if success then
			return success
		end
	end)

	if success then
		return success
	else 
		return false
	end
end

local function tagsListUsernameFromId(id)
	local succes = table.foreach(TaggedSkids, function(i, v)
		local succes = table.foreach(v, function(i2, v2)
			if i2 == id then
				return v2
			end
		end)

		if succes then
			return succes
		end
	end)

	if succes then
		return succes
	else 
		return false
	end
end

local function tagsHttpGet(id)
	local success, response
	while not success do
		success, response = pcall(function()
			return HttpService:JSONDecode(game:HttpGetAsync("https://api.roblox.com/users/"..id.."/onlinestatus/"))
		end)

		wait(1)
	end

	return response
end

local function tagsListOnlineSkids(player)
	if player then
		if tagsListIdFromUsername(player) then
			return tagsHttpGet(tagsListIdFromUsername(player))
		end
	else
		local pages = math.ceil(#TaggedSkids / 100)
		local temp = {}
		local speed = OrionLib.Flags["tags_check_speed"].Value == "Stable" and 5 or OrionLib.Flags["tags_check_speed"].Value == "Fast" and 3
		for i = 1,pages,1 do
			local tags = tagsListUserIds(i - 1)
			local till = {current = 0, queue = #tags < 100 and #tags or 100}
			for i2,v2 in pairs(tags) do
				coroutine.wrap(function()
					local response = tagsHttpGet(v2)
					if response["IsOnline"] and response.IsOnline == true then
						table.insert(temp, tagsListUsernameFromId(v2))
					end
					till.current = till.current + 1
				end)()
				for i3 = 1,speed,1 do
					RunService.RenderStepped:Wait()
				end
			end
			repeat wait(0.1) until till.current == till.queue
			wait(i == pages and 0.01 or 1)
		end

		return temp
	end

	return false
end

local function checkTaggedSkidsInGame(exclusion)
	local iteration = 0
	local string = ""

    while OblivionRan.Value == false do
        wait()
    end

	for i,v in pairs(game.Players:GetChildren()) do
		if tagsTableFind(v.UserId, "id") and v.UserId ~= exclusion then
			iteration = iteration + 1
			if string == "" then
				string = v.Name
			else
				string = string..", "..v.Name
			end
		end
	end

	if iteration == 0 then
        OrionLib:MakeNotification({Name = "Oblivion", Content = "No tagged players ingame.", Image = "rbxassetid://4384401919", Time = 10})
	elseif iteration == 1 then
        OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged player ingame: "..string..".", Image = "rbxassetid://4384401919", Time = 10})
	elseif iteration > 1 then
        OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged players ingame: "..string..".", Image = "rbxassetid://4384401919", Time = 10})
	end
end

local function tagsMessageOnlineSkids(method)
	if OrionLib.Flags["tags_online_check"].Value == true and Settings.tags.cooldown == 0 or OrionLib.Flags["tags_online_check"].Value == true and method == "forced" then
		Settings.tags.cooldowntoggle = false
		Settings.tags.cooldown = 5000 + ((#tagsListUsernames("all") - 1) * 100)

        repeat wait(1) until OblivionRan.Value == true

        OrionLib:MakeNotification({Name = "Oblivion", Content = "Checking for online tagged players.", Image = "rbxassetid://4384401919", Time = 10})
		local temp = tagsListOnlineSkids()
		table.remove(temp, 1)
		local string = ""

		if #temp == 0 then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "No tagged players online.", Image = "rbxassetid://4384401919", Time = 10})
		elseif #temp == 1 then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged player online: "..temp[1], Image = "rbxassetid://4384401919", Time = 10})
		elseif #temp > 1 then
			for i,v in pairs(temp) do
				if string == "" then
					string = v
				else
					string = string..", "..v
				end
			end
            OrionLib:MakeNotification({Name = "Oblivion", Content = "["..#temp.."] Tagged players online: "..string, Image = "rbxassetid://4384401919", Time = 30})
		end
	elseif Settings.tags.cooldowntoggle == false then
		Settings.tags.cooldowntoggle = true
        OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged players is on a cooldown.", Image = "rbxassetid://4384401919", Time = 5})
	end
end

local function removeTextures()
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

local function godMode()
	if OblivionRan.Value == true and Settings.godmodeused == false and IsAlive(LocalPlayer) and GetTeam(LocalPlayer) ~= "s" and OrionLib.Flags["rage_god_mode"].Value ~= "-" then
		Settings.godmodeused = true
		--[[if OrionLib.Flags["rage_god_mode"].Value == "Hostage" then
			ReplicatedStorage.Events.ApplyGun:FireServer({
				Model = ReplicatedStorage.Hostage.Hostage,
				Name = "USP"
			}, LocalPlayer);
		else]]if OrionLib.Flags["rage_god_mode"].Value == "Fall Damage" then
			repeat wait() until workspace.Status.Preparation.Value == false
			ReplicatedStorage.Events.FallDamage:FireServer(0/0)
			LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				LocalPlayer.Character.Humanoid.Health = 100
			end)
		elseif OrionLib.Flags["rage_god_mode"].Value == "Humanoid" then
			LocalPlayer.Character.Humanoid.Parent = nil
			Instance.new("Humanoid", LocalPlayer.Character)
		elseif OrionLib.Flags["rage_god_mode"].Value == "Invisibility" then
			local oldpos = LocalPlayer.Character.HumanoidRootPart.CFrame
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999,9999,9999)
			local NewRoot = LocalPlayer.Character.LowerTorso.Root:Clone()
			LocalPlayer.Character.LowerTorso.Root:Destroy()
			NewRoot.Parent = LocalPlayer.Character.LowerTorso
			wait()
			LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
		end
		OrionLib:MakeNotification({Name = "Oblivion", Content = "God Mode "..OrionLib.Flags["rage_god_mode"].Value.." activated.", Image = "rbxassetid://3944668821", Time = 3})
	elseif OblivionRan.Value == true and Settings.godmodeused == true and IsAlive(LocalPlayer) and GetTeam(LocalPlayer) ~= "s" then
		OrionLib:MakeNotification({Name = "Oblivion", Content = "You can not use multiple god mode's at the same time.", Image = "rbxassetid://3944668821", Time = 3})
	end
end

local function loadCustomSkins()
    if Settings.CustomSkins == false then
        Settings.CustomSkins = true
		for i,v in pairs(Settings.weapon_info) do
			if i ~= "gloves" then
				for i2,v2 in pairs(v) do
					local name = i == "knives" and i2 or i == "guns" and v2.name
					if ReplicatedStorage.Skins:FindFirstChild(name) then
						if v2["custom_list"] then
							for i3,v3 in pairs(v2.custom_list) do
								local var = Instance.new("Folder")
								var.Name = i3
								var.Parent = ReplicatedStorage.Skins[name]
								for i4,v4 in pairs(v3) do
									local var2 = Instance.new("StringValue")
									var2.Name = v2.custom_parts[i4]
									var2.Parent = var
									var2.Value = v4
								end
							end
						end
					end
				end
			end
        end
    end
end

local function targetAlive(flag)
	if game.Players:FindFirstChild(OrionLib.Flags[flag].Value) and PlayerCheck(game.Players[OrionLib.Flags[flag].Value]) then
		return true
	end

	return false
end

local function targetChecks(flag)
	if game.Players:FindFirstChild(OrionLib.Flags[flag].Value) and targetAlive(flag) then
		if OrionLib.Flags[flag.."_visible"].Value == true then
			if Settings.aimbot.visiblereset[flag].time == 0 then
				Settings.aimbot.visiblereset[flag].time = 30
				local character, torso = GetCharacter(game.Players[OrionLib.Flags[flag].Value])
				local returned = VisibleCheck(character, torso.Position)
				Settings.aimbot.visiblereset[flag].value = returned
				return returned
			else
				Settings.aimbot.visiblereset[flag].time = Settings.aimbot.visiblereset[flag].time - 1
				return Settings.aimbot.visiblereset[flag].value
			end
		elseif OrionLib.Flags[flag.."_visible"].Value == false then
			return true
		end
	end

	return false
end

local function killTarget(target, loop)
	local looped = loop == "kill_specific" and Settings.resultloop or loop == "kill_all" and 5 or 1
	local prepcheck = OrionLib.Flags["rage_kill_prep_check"].Value == false and true or OrionLib.Flags["rage_kill_prep_check"].Value == true and workspace.Status.Preparation.Value == true and false or OrionLib.Flags["rage_kill_prep_check"].Value == true and workspace.Status.Preparation.Value == false and true
	if PlayerCheck(target) and prepcheck then
		local type = OrionLib.Flags["rage_kill_weapon"].Value == "Held" and "current" or OrionLib.Flags["rage_kill_weapon"].Value == "Random Gun" and "Gun" or OrionLib.Flags["rage_kill_weapon"].Value == "Random Knife" and "Melee" or OrionLib.Flags["rage_kill_weapon"].Value == "Both" and "Both"
		local gunname = type == "current" and Client.gun.Name or Settings.weapon_types[type][math.random(1,#Settings.weapon_types[type])]
		local gunmodel = ReplicatedStorage.Weapons[gunname].Model

		local position
		if OrionLib.Flags["rage_kill_velocity_prediction"].Value == true then
			local p = target.Character.Head.CFrame.p
			local hrp = target.Character.HumanoidRootPart.Position
			local oldHrp = target.Character.HumanoidRootPart.OldPosition.Value
			local vel = (Vector3.new(hrp.X, 0, hrp.Z) - Vector3.new(oldHrp.X, 0, oldHrp.Z)) / Settings.LastStep
			local dir = Vector3.new(vel.X / vel.magnitude, 0, vel.Z / vel.magnitude)			  
			position = p + dir * (Settings.Ping / (math.pow(Settings.Ping, 1.5)) * (dir / (dir / 2)))
		else
			position = target.Character.Head.CFrame.p
		end

		local Arguments = {
			[1] = target.Character.Head,
			[2] = position,
			[3] = gunname,
			[4] = OrionLib.Flags["rage_insta_kill"].Value == false and 100 or OrionLib.Flags["rage_insta_kill"].Value == true and 500,
			[5] = gunmodel,
			[8] = OrionLib.Flags["rage_insta_kill"].Value == false and 1 or OrionLib.Flags["rage_insta_kill"].Value == true and 100,
			[9] = false,
			[10] = false,
			[11] = Vector3.new(),
			[12] = OrionLib.Flags["rage_insta_kill"].Value == false and 100 or OrionLib.Flags["rage_insta_kill"].Value == true and 500,
			[13] = Vector3.new()
			}
		for i = 1,looped,1 do
			ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments))
		end
	end
end

local function teleportToPlayer(plr, option)
	if option == "random_radius" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, 1000) - 500), 0, (math.random(0, 1000) - 500))
	elseif option == "after_prep" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0,1000) - 500), 0, (math.random(1000,5000) * 1000))
	end
end

local function teleportTospawnpoint()
	Settings.falldamagefilter = true
	RunService.RenderStepped:Wait()
	local lastspawnpoint
	local spawns = GetTeam(LocalPlayer) == "T" and workspace.Map.TSpawns or GetTeam(LocalPlayer) == "CT" and workspace.Map.CTSpawns or workspace.Map.AllSpawns
	for i,v in pairs(spawns:GetChildren()) do
		lastspawnpoint = v
		break
	end
	for i = 1,5,1 do
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastspawnpoint.Position + Vector3.new(0, 10, 0))
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, -10, 0)
	end
	for i = 1,50,1 do
		if Settings.falldamagefilter == false then
			Settings.falldamagefilter = true
		end
		RunService.RenderStepped:Wait()
	end
	Settings.falldamagefilter = false
end

local function warmupCheck()
	if game.PlaceId == 301549746 or game.PlaceId == 1480424328 then
		if workspace.Status.TWins.Value == 0 and workspace.Status.CTWins.Value == 0 and workspace.Status.Rounds.Value ~= 1 then
			return true
		end
	elseif game.PlaceId == 1869597719 then
		return true
	end

	return false
end

local function removeDeadZones()
	if Settings.deadzones == false then
		Settings.deadzones = true
		local Clips = workspace.Map.Clips; Clips.Name = "FAT"; Clips.Parent = nil
		local Killers = workspace.Map.Killers; Killers.Name = "FAT"; Killers.Parent = nil

		for i,v in pairs(Clips:GetChildren()) do
			if OrionLib.Flags["misc_dead_zones"].Value == true and v:IsA("BasePart") then
				v:Destroy()
			end
		end
		for i,v in pairs(Killers:GetChildren()) do
			if OrionLib.Flags["misc_dead_zones"].Value == true and OrionLib.Flags["misc_walk_on_water"].Value == true and v.Name ~= "WaterKiller" or OrionLib.Flags["misc_dead_zones"].Value == true and OrionLib.Flags["misc_walk_on_water"].Value == false then
				v:Destroy()
			elseif OrionLib.Flags["misc_walk_on_water"].Value == true and v.Name == "WaterKiller" then
				local ClonedWater = v:Clone()
				ClonedWater.Parent = Killers
				ClonedWater.Transparency = 1
				ClonedWater.CanCollide = true
				ClonedWater.Name = "WaterBox"
				v:Destroy()
			end
		end

		Killers.Name = "Killers"; Killers.Parent = workspace.Map
		Clips.Name = "Clips"; Clips.Parent = workspace.Map
		Settings.deadzones = false
	end
end

local function RotatePlayer(pos)
    local Gyro = Instance.new('BodyGyro')
    Gyro.D = 0
    Gyro.P = (100 * 100)
    Gyro.MaxTorque = Vector3.new(0, (100 * 100), 0)
    Gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso
    Gyro.CFrame = CFrame.new(Gyro.Parent.Position, pos.Position)
    wait()
    Gyro:Destroy()
end

local function YROTATION(cframe)
    local x, y, z = cframe:ToOrientation()
    return CFrame.new(cframe.Position) * CFrame.Angles(0,y,0)
end

-- Esp Setup
espLib.whitelist = {}
espLib.blacklist = {}
espLib.options = {enabled = nil, scaleFactorX = 4, scaleFactorY = 5, font = 2, fontSize = 13, limitDistance = false, maxDistance = 1000, visibleOnly = nil, teamCheck = nil, teamColor = nil, fillColor = nil, whitelistColor = Color3.new(1, 0, 0), outOfViewArrows = false, outOfViewArrowsFilled = false, outOfViewArrowsSize = 25, outOfViewArrowsRadius = 100, outOfViewArrowsColor = Color3.new(1, 1, 1), outOfViewArrowsTransparency = 0.5, outOfViewArrowsOutline = false, outOfViewArrowsOutlineFilled = false, outOfViewArrowsOutlineColor = Color3.new(1, 1, 1), outOfViewArrowsOutlineTransparency = 1, names = nil, nameTransparency = nil, nameColor = nil, boxes = true, boxesTransparency = nil, boxesColor = nil, boxFill = false, boxFillTransparency = 0.5, boxFillColor = Color3.new(1, 1, 1), healthBars = true, healthBarsSize = 1, healthBarsTransparency = nil, healthBarsColor = nil, healthText = true, healthTextTransparency = nil, healthTextSuffix = "%", healthTextColor = nil, distance = true, distanceTransparency = nil, distanceSuffix = " Studs", distanceColor = nil, tracers = nil, tracerTransparency = nil, tracerColor = nil, tracerOrigin = nil, chams = nil, chamsColor = nil, chamsTransparency = nil}

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

-- GUI
local AimTab = Window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://4483345998"})
local RageTab = Window:MakeTab({Name = "Rage", Icon = "rbxassetid://3944668821"})
local EspTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483362458"})
local SkinsTab = Window:MakeTab({Name = "Skins", Icon = "rbxassetid://4335483762"})
local ViewmodelsTab = Window:MakeTab({Name = "Viewmodels", Icon = "rbxassetid://4483363084"})
local TagTab = Window:MakeTab({Name = "Tags", Icon = "rbxassetid://4384401919"})
local TrollTab = Window:MakeTab({Name = "Troll", Icon = "rbxassetid://6960991786"})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4384401360"})
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://3605022185"})

local AT_MainSec = AimTab:AddSection({Name = "Main"})
local AT_AimSec = AimTab:AddSection({Name = "Aim"})
local AT_FOVSec = AimTab:AddSection({Name = "FOV"})
local AT_TriggerBotSec = AimTab:AddSection({Name = "TriggerBot"})
AT_MainSec:AddToggle({Name = "Enable", Default = false, Flag = "aimbot_enable", Callback = function() saveData() end})
AT_MainSec:AddToggle({Name = "Visible Only", Default = false, Flag = "aimbot_visible", Callback = function() saveData() end})
AT_MainSec:AddToggle({Name = "Keybind Only", Default = false, Flag = "aimbot_keybind_only", Callback = function(val) saveData() if val == true then local setting = Settings.aimbot.aim == true and "enabled" or Settings.aimbot.aim == false and "disabled" OrionLib:MakeNotification({Name = "Oblivion", Content = "Aimbot is now "..setting, Image = "rbxassetid://4483345998", Time = 3}) end end})
AT_MainSec:AddBind({Name = "Bind", Default = Enum.KeyCode.E, Hold = false, Flag = "aimbot_keybind", Callback = function() saveData() Settings.aimbot.aim = Settings.aimbot.aim == true and false or Settings.aimbot.aim == false and true if OrionLib.Flags["aimbot_keybind_only"].Value == true then local setting = Settings.aimbot.aim == true and "enabled" or Settings.aimbot.aim == false and "disabled" OrionLib:MakeNotification({Name = "Oblivion", Content = "Aimbot is now "..setting, Image = "rbxassetid://4483345998", Time = 3}) end end})
AT_AimSec:AddDropdown({Name = "Aim Priority", Default = "Distance", Options = {"Distance", "Crosshair"}, Flag = "aimbot_priority", Callback = function() saveData() end})
AT_AimSec:AddDropdown({Name = "Aim Method", Default = "Smooth Aim", Options = {"Smooth Aim", "Lock Aim", "Silent Aim"}, Flag = "aimbot_method", Callback = function() saveData() end})
AT_AimSec:AddSlider({Name = "Activation Delay", Min = 0, Max = 1000, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 100, ValueName = "ms", Flag = "aimbot_activation_delay", Callback = function() saveData() end})
AT_AimSec:AddSlider({Name = "Smoothness", Min = 1, Max = 50, Default = 25, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "aimbot_smoothness", Callback = function() saveData() end})
AT_FOVSec:AddToggle({Name = "FOV Check", Default = false, Flag = "aimbot_fov_only", Callback = function(val) saveData() FOV.Visible = val end})
AT_FOVSec:AddSlider({Name = "FOV Reset", Min = 0, Max = 1000, Default = 300, Color3.fromRGB(255, 255, 255), Increment = 50, Flag = "aimbot_fov_reset", Callback = function() saveData() end})
AT_FOVSec:AddSlider({Name = "FOV Thickness", Min = 1, Max = 10, Default = 3, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "aimbot_fov_thickness", Callback = function(val) saveData() FOV.Thickness = val TriggerbotFOV.Thickness = val end})
AT_FOVSec:AddSlider({Name = "FOV Radius", Min = 0, Max = 360, Default = 120, Color3.fromRGB(255, 255, 255), Increment = 5, Flag = "aimbot_fov_radius", Callback = function(val) saveData() FOV.Radius = val end})
AT_FOVSec:AddSlider({Name = "FOV Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 10, Flag = "aimbot_fov_transparency", Callback = function(val) saveData() FOV.Transparency = (val / 100) TriggerbotFOV.Transparency = (val / 100) end})
AT_FOVSec:AddColorpicker({Name = "FOV Color", Default = Color3.fromRGB(255, 255, 255), Flag = "aimbot_fov_color", Callback = function(val) saveData() FOV.Color = val TriggerbotFOV.Color = val end})
AT_TriggerBotSec:AddToggle({Name = "TriggerBot", Default = false, Flag = "aimbot_triggerbot_enable", Callback = function() saveData() end})
AT_TriggerBotSec:AddToggle({Name = "Triggerbot FOV", Default = false, Flag = "aimbot_triggerbot_fov", Callback = function(val) saveData() TriggerbotFOV.Visible = val end})
AT_TriggerBotSec:AddToggle({Name = "Stand Still", Default = false, Flag = "aimbot_stand_still", Callback = function() saveData() end})
AT_TriggerBotSec:AddToggle({Name = "Shooting Delay", Default = true, Flag = "aimbot_shooting_delay", Callback = function() saveData() end})
AT_TriggerBotSec:AddSlider({Name = "TriggerBot Delay", Min = 0, Max = 1000, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 100, ValueName = "ms", Flag = "aimbot_triggerbot_delay", Callback = function() saveData() end})

local RT_GodModeSec = RageTab:AddSection({Name = "God Mode"})
local RT_BHopSec = RageTab:AddSection({Name = "B-Hop"})
local RT_KillAllSec = RageTab:AddSection({Name = "Kill All"})
local RT_Kill1Sec = RageTab:AddSection({Name = "Kill Player"})
local RT_Kill2Sec = RageTab:AddSection({Name = "Kill Player"})
local RT_Kill3Sec = RageTab:AddSection({Name = "Kill Player"})
local RT_TeleportSec = RageTab:AddSection({Name = "Teleportation"})
local RT_AntiAimSec = RageTab:AddSection({Name = "Anti-Aim"})
local RT_AntiAntiAimSec = RageTab:AddSection({Name = "Anti Anti-Aim"})
RT_GodModeSec:AddDropdown({Name = "Type", Default = "-", Options = {"-", "Fall Damage", "Humanoid", "Invisibility"}, Flag = "rage_god_mode", Callback = function() saveData() end})
RT_GodModeSec:AddToggle({Name = "Auto Set", Default = false, Flag = "rage_auto_set", Callback = function(val) saveData() if val == true then godMode() end end})
RT_GodModeSec:AddButton({Name = "Set", Callback = function() godMode() end})
RT_BHopSec:AddToggle({Name = "Enable", Default = false, Flag = "rage_bhop_enable", Callback = function() saveData() end})
RT_BHopSec:AddDropdown({Name = "Type", Default = "Gyro", Options = {"Gyro", "CFrame", "Gyro Walk", "CFrame Walk"}, Flag = "rage_bhop_type", Callback = function() saveData() end})
RT_BHopSec:AddSlider({Name = "Speed", Min = 1, Max = 100, Default = 20, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "rage_bhop_speed", Callback = function() saveData() end})
RT_KillAllSec:AddDropdown({Name = "Weapon", Default = "Held", Options = {"Held", "Random Gun", "Random Knife", "Both"}, Flag = "rage_kill_weapon", Callback = function() saveData() end})
RT_KillAllSec:AddToggle({Name = "Insta Kill", Default = false, Flag = "rage_insta_kill", Callback = function() saveData() end})
RT_KillAllSec:AddToggle({Name = "Velocity Prediction", Default = false, Flag = "rage_kill_velocity_prediction", Callback = function() saveData() end})
RT_KillAllSec:AddToggle({Name = "Preparation Check", Default = false, Flag = "rage_kill_prep_check", Callback = function() saveData() end})
RT_KillAllSec:AddSlider({Name = "Loop Rate", Min = 1, Max = 30, Default = 5, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "rage_kill_loop_rate", Callback = function() saveData() end})
RT_KillAllSec:AddToggle({Name = "Visible", Default = false, Flag = "rage_kill_all_visible", Callback = function() saveData() end})
RT_KillAllSec:AddToggle({Name = "Kill All", Default = false, Flag = "rage_kill_all", Callback = function() saveData() end})
RT_Kill1Sec:AddDropdown({Name = "Player", Default = "-", Options = {"-"}, Flag = "rage_kill_player_1"})
RT_Kill1Sec:AddToggle({Name = "Visible", Default = false, Flag = "rage_kill_player_1_visible", Callback = function() saveData() end})
RT_Kill1Sec:AddToggle({Name = "Enable", Default = false, Flag = "rage_kill_player_enable_1"})
RT_Kill2Sec:AddDropdown({Name = "Player", Default = "-", Options = {"-"}, Flag = "rage_kill_player_2"})
RT_Kill2Sec:AddToggle({Name = "Visible", Default = false, Flag = "rage_kill_player_2_visible", Callback = function() saveData() end})
RT_Kill2Sec:AddToggle({Name = "Enable", Default = false, Flag = "rage_kill_player_enable_2"})
RT_Kill3Sec:AddDropdown({Name = "Player", Default = "-", Options = {"-"}, Flag = "rage_kill_player_3"})
RT_Kill3Sec:AddToggle({Name = "Visible", Default = false, Flag = "rage_kill_player_3_visible", Callback = function() saveData() end})
RT_Kill3Sec:AddToggle({Name = "Enable", Default = false, Flag = "rage_kill_player_enable_3"})
RT_TeleportSec:AddToggle({Name = "Target Dodge", Default = false, Flag = "rage_teleport_target_dodge", Callback = function() saveData() end})
RT_TeleportSec:AddToggle({Name = "Continuous Teleport", Default = false, Flag = "rage_teleport_continuous_teleport", Callback = function() saveData() end})
RT_AntiAimSec:AddToggle({Name = "Enable", Default = false, Flag = "rage_anti_aim_enable", Callback = function() saveData() end})
RT_AntiAntiAimSec:AddToggle({Name = "Pitch Manipulation", Default = false, Flag = "rage_anti_anti_aim_pitch", Callback = function() saveData() end})
RT_AntiAntiAimSec:AddToggle({Name = "Roll Manipulation", Default = false, Flag = "rage_anti_anti_aim_roll", Callback = function() saveData() end})
RT_AntiAntiAimSec:AddToggle({Name = "Animation Manipulation", Default = false, Flag = "rage_anti_anti_aim_animation", Callback = function() saveData() end})

local ET_MainSec = EspTab:AddSection({Name = "Main"})
local ET_AddSec = EspTab:AddSection({Name = "Additional"})
local ET_TracerSec = EspTab:AddSection({Name = "Tracers"})
ET_MainSec:AddToggle({Name = "Enable", Default = false, Flag = "esp_enable", Callback = function(val) saveData() espLib.options.enabled = val end})
ET_MainSec:AddToggle({Name = "Visible Only", Default = false, Flag = "esp_visible", Callback = function(val) saveData() espLib.options.visibleOnly = val end})
ET_MainSec:AddToggle({Name = "Team Check", Default = false, Flag = "esp_team_check", Callback = function(val) saveData() espLib.options.teamCheck = val end})
ET_MainSec:AddToggle({Name = "Team Color", Default = false, Flag = "esp_team_color", Callback = function(val) saveData() espLib.options.teamColor = val end})
ET_AddSec:AddToggle({Name = "Name", Default = false, Flag = "esp_name", Callback = function(val) saveData() espLib.options.names = val end})
ET_AddSec:AddToggle({Name = "Health", Default = false, Flag = "esp_health", Callback = function(val) saveData() espLib.options.healthText = val end})
ET_AddSec:AddToggle({Name = "Health Bar", Default = false, Flag = "esp_health_bar", Callback = function(val) saveData() espLib.options.healthBars = val end})
ET_AddSec:AddToggle({Name = "Distance", Default = false, Flag = "esp_distance", Callback = function(val) saveData() espLib.options.distance = val end})
ET_AddSec:AddColorpicker({Name = "Misc Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_misc_color", Callback = function(val) saveData() espLib.options.nameColor = val espLib.options.healthTextColor = val espLib.options.healthBarsColor = val espLib.options.distanceColor = val end})
ET_AddSec:AddSlider({Name = "Misc Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 10, Flag = "esp_misc_transparency", Callback = function(val) saveData() espLib.options.nameTransparency = (val / 100) espLib.options.healthTextTransparency = (val / 100) espLib.options.healthBarsTransparency = (val / 100) espLib.options.distanceTransparency = (val / 100) end})
ET_AddSec:AddSlider({Name = "Box Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_box_transparency", Callback = function(val) saveData() espLib.options.boxesTransparency = (val / 100) end})
ET_AddSec:AddColorpicker({Name = "Box Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_box_color", Callback = function(val) saveData() espLib.options.boxesColor = val end})
--[[EspTab:AddToggle({Name = "Chams", Default = false, Flag = "esp_chams", Callback = function(val) saveData() espLib.options.chams = val end})
EspTab:AddSlider({Name = "Chams Transparency", Min = 0, Max = 100, Default = 0, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_chams_transparency", Callback = function(val) saveData() espLib.options.chamsTransparency = (val / 100) end})
EspTab:AddColorpicker({Name = "Chams Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_chams_color", Callback = function(val) saveData() espLib.options.chamsColor = val end})]]--
ET_TracerSec:AddToggle({Name = "Tracers", Default = false, Flag = "esp_tracers", Callback = function(val) saveData() espLib.options.tracers = val end})
ET_TracerSec:AddSlider({Name = "Tracer Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_tracer_transparency", Callback = function(val) saveData() espLib.options.tracerTransparency = (val / 100) end})
ET_TracerSec:AddColorpicker({Name = "Tracer Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_tracer_color", Callback = function(val) saveData() espLib.options.tracerColor = val end})
ET_TracerSec:AddDropdown({Name = "Tracer Origin", Default = "Bottom", Options = {"Bottom", "Top", "Mouse"}, Flag = "esp_tracerorigin", Callback = function(val) saveData() espLib.options.tracerOrigin = val end})

local ST_AddSec = SkinsTab:AddSection({Name = "Additional"})
local ST_WeaponSec = SkinsTab:AddSection({Name = "Weapons"})
local ST_KnifeSec = SkinsTab:AddSection({Name = "Knives"})
local ST_GloveSec = SkinsTab:AddSection({Name = "Gloves"})
ST_AddSec:AddToggle({Name = "Custom Skins", Default = false, Flag = "skins_custom", Callback = function(val) saveData() if val == true then loadCustomSkins() if OrionLib.Flags["skins_weapon"] and OrionLib.Flags["skins_weapon"].Value ~= "-" then dropdownCustom("normal", "guns") end if OrionLib.Flags["skins_knife"] and OrionLib.Flags["skins_knife"].Value ~= "-" then dropdownCustom("normal", "knives") end elseif val == false then if OrionLib.Flags["skins_weapon"] and OrionLib.Flags["skins_weapon"].Value ~= "-" then dropdownCustom("normal", "guns") end if OrionLib.Flags["skins_knife"] and OrionLib.Flags["skins_knife"].Value ~= "-" then dropdownCustom("normal", "knives") end end end})
ST_WeaponSec:AddDropdown({Name = "Model", Default = "-", Options = {"-"}, Flag = "skins_weapon", Callback = function(val) if val == "-" and OrionLib.Flags["skins_weapon_skin"] then dropdownRefresh("skins_weapon_skin", "-", {"-"}) elseif val ~= "-" and OrionLib.Flags["skins_weapon_skin"] then dropdownCustom("normal", "guns") end end})
ST_WeaponSec:AddDropdown({Name = "Skin", Default = "-", Options = {"-"}, Flag = "skins_weapon_skin", Callback = function(val) if Settings.dropdownfilter == false and (val == "Show custom skins" or val == "Show normal skins") then dropdownCustom(val == "Show custom skins" and "custom" or val == "Show normal skins" and "normal", "guns") elseif Settings.dropdownfilter == false and val ~= "-" then Settings.CurrentSkins[OrionLib.Flags["skins_weapon"].Value] = val saveData() elseif Settings.dropdownfilter == true then Settings.dropdownfilter = false end end})
ST_KnifeSec:AddDropdown({Name = "Model", Default = "-", Options = {"-"}, Flag = "skins_knife", Callback = function(val) saveData() if val == "-" and OrionLib.Flags["skins_knife_skin"] then modelChange("v_T Knife", "v_T Knife") modelChange("v_CT Knife", "v_CT Knife") dropdownRefresh("skins_knife_skin", "-", {"-"}) elseif val ~= "-" and OrionLib.Flags["skins_knife_skin"] then modelChange("v_T Knife", "v_"..val) modelChange("v_CT Knife", "v_"..val) dropdownCustom("normal", "knives") end end})
ST_KnifeSec:AddDropdown({Name = "Skin", Default = "-", Options = {"-"}, Flag = "skins_knife_skin", Callback = function(val) if Settings.dropdownfilter == false and (val == "Show custom skins" or val == "Show normal skins") then dropdownCustom(val == "Show custom skins" and "custom" or val == "Show normal skins" and "normal", "knives") elseif Settings.dropdownfilter == false and val ~= "-" then Settings.CurrentSkins[OrionLib.Flags["skins_knife"].Value] = val saveData() elseif Settings.dropdownfilter == true then Settings.dropdownfilter = false end end})
ST_GloveSec:AddDropdown({Name = "Model", Default = "-", Options = {"-"}, Flag = "skins_glove", Callback = function(val) if val == "-" and OrionLib.Flags["skins_glove_skin"] then dropdownRefresh("skins_glove_skin", "-", {"-"}) saveData() elseif val ~= "-" and OrionLib.Flags["skins_glove_skin"] then dropdownRefresh("skins_glove_skin", "Stock", skinsList(val, Settings.glove_data)) saveData() end end})
ST_GloveSec:AddDropdown({Name = "Skin", Default = "-", Options = {"-"}, Flag = "skins_glove_skin", Callback = function() saveData() end})

local VT_ArmsSec = ViewmodelsTab:AddSection({Name = "Arms"})
local VT_GlovesSec = ViewmodelsTab:AddSection({Name = "Gloves"})
local VT_SleevesSec = ViewmodelsTab:AddSection({Name = "Sleeves"})
local VT_WeaponSec = ViewmodelsTab:AddSection({Name = "Weapon"})
local VT_BulletSec = ViewmodelsTab:AddSection({Name = "Bullet"})
VT_ArmsSec:AddToggle({Name = "Toggle", Default = false, Flag = "viewmodels_arms_enable", Callback = function() saveData() end})
VT_ArmsSec:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_arms_color", Callback = function() saveData() end})
VT_ArmsSec:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_arms_material", Callback = function() saveData() end})
VT_ArmsSec:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_arms_transparency", Callback = function() saveData() end})
VT_GlovesSec:AddToggle({Name = "Toggle", Default = false, Flag = "viewmodels_gloves_enable", Callback = function() saveData() end})
VT_GlovesSec:AddDropdown({Name = "Show", Default = "Skin", Options = {"Skin", "Color"}, Flag = "viewmodels_gloves_show", Callback = function() saveData() end})
VT_GlovesSec:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_gloves_color", Callback = function() saveData() end})
VT_GlovesSec:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_gloves_material", Callback = function() saveData() end})
VT_GlovesSec:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_gloves_transparency", Callback = function() saveData() end})
VT_SleevesSec:AddToggle({Name = "Toggle", Default = false, Flag = "viewmodels_sleeves_enable", Callback = function() saveData() end})
VT_SleevesSec:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_sleeves_color", Callback = function() saveData() end})
VT_SleevesSec:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_sleeves_material", Callback = function() saveData() end})
VT_SleevesSec:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_sleeves_transparency", Callback = function() saveData() end})
VT_WeaponSec:AddToggle({Name = "Toggle", Default = false, Flag = "viewmodels_weapon_enable", Callback = function() saveData() end})
VT_WeaponSec:AddDropdown({Name = "Show", Default = "Skin", Options = {"Skin", "Color"}, Flag = "viewmodels_weapon_show", Callback = function() saveData() end})
VT_WeaponSec:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_weapon_color", Callback = function() saveData() end})
VT_WeaponSec:AddDropdown({Name = "Material", Default = "SmoothPlastic", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_weapon_material", Callback = function() saveData() end})
VT_WeaponSec:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_weapon_transparency", Callback = function() saveData() end})
VT_BulletSec:AddToggle({Name = "Tracers", Default = false, Flag = "viewmodels_bullet_tracer_enable", Callback = function() saveData() end})
VT_BulletSec:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_bullet_tracer_color", Callback = function() saveData() end})
VT_BulletSec:AddDropdown({Name = "Material", Default = "ForceField", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_bullet_tracer_material", Callback = function() saveData() end})
VT_BulletSec:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_bullet_tracer_transparency", Callback = function() saveData() end})
VT_BulletSec:AddToggle({Name = "Impacts", Default = false, Flag = "viewmodels_bullet_impact_enable", Callback = function() saveData() end})
VT_BulletSec:AddColorpicker({Name = "Color", Default = Color3.fromRGB(0, 0, 0), Flag = "viewmodels_bullet_impact_color", Callback = function() saveData() end})
VT_BulletSec:AddDropdown({Name = "Material", Default = "ForceField", Options = {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, Flag = "viewmodels_bullet_impact_material", Callback = function() saveData() end})
VT_BulletSec:AddSlider({Name = "Transparency", Min = 0, Max = 100, Default = 50, Color3.fromRGB(0, 0, 0), Increment = 10, ValueName = "%", Flag = "viewmodels_bullet_impact_transparency", Callback = function() saveData() end})

local TaT_InSessionSec = TagTab:AddSection({Name = "In-Session"})
local TaT_TaggedSec = TagTab:AddSection({Name = "Tagged"})
local TaT_AddSec = TagTab:AddSection({Name = "Additional"})
local TaT_MergeSec = TagTab:AddSection({Name = "Merge"})
TaT_InSessionSec:AddDropdown({Name = "Select Player", Default = "-", Options = {"-"}, Flag = "tags_select_player"})
TaT_InSessionSec:AddButton({Name = "Add Tag", Callback = function() if OrionLib.Flags["tags_select_player"].Value ~= "-" then if not tagsTableFind(game.Players[OrionLib.Flags["tags_select_player"].Value].UserId, "id") then table.insert(TaggedSkids, {[game.Players[OrionLib.Flags["tags_select_player"].Value].UserId] = OrionLib.Flags["tags_select_player"].Value}) writefile("oblivion/CB/tagged.cfg", SaveTable(TaggedSkids)) TaggedSkids = loadstring("return "..readfile("oblivion/CB/tagged.cfg"))() OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged player: "..OrionLib.Flags["tags_select_player"].Value..".", Image = "rbxassetid://4384401919", Time = 5}) OrionLib.Flags["tags_select_player"]:Set("-") dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page")) tagsUpdateLabels("offline") checkTaggedSkidsInGame() tagsMessageOnlineSkids() elseif tagsTableFind(game.Players[OrionLib.Flags["tags_select_player"].Value].UserId, "id") then OrionLib:MakeNotification({Name = "Oblivion", Content = OrionLib.Flags["tags_select_player"].Value.." is already tagged.", Image = "rbxassetid://4384401919", Time = 5}) end end end})
TaT_TaggedSec:AddDropdown({Name = "Select Tag", Default = "-", Options = {"-"}, Flag = "tags_select_tag", Callback = function(val) tagsUpdateLabels("live_reset") if val ~= "-" then if val == "Next Page" then Settings.tags.page = Settings.tags.page + 1 dropdownRefresh("tags_select_tag", "-", {"-"}) dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page")) elseif val == "Previous Page" and Settings.tags.page ~= 0 then Settings.tags.page = Settings.tags.page - 1 dropdownRefresh("tags_select_tag", "-", {"-"}) dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page")) elseif tagsTableFind(val, "name") then tagsUpdateLabels("live", tagsListOnlineSkids(val)) end end end})
TaT_TaggedSec:AddButton({Name = "Remove Tag", Callback = function() if OrionLib.Flags["tags_select_tag"].Value ~= "-" then if tagsTableFind(OrionLib.Flags["tags_select_tag"].Value, "name") then table.remove(TaggedSkids, tagsTableFind(OrionLib.Flags["tags_select_tag"].Value, "name")) writefile("oblivion/CB/tagged.cfg", SaveTable(TaggedSkids)) TaggedSkids = loadstring("return "..readfile("oblivion/CB/tagged.cfg"))() OrionLib:MakeNotification({Name = "Oblivion", Content = "Removed tag on: "..OrionLib.Flags["tags_select_tag"].Value..".", Image = "rbxassetid://4384401919", Time = 5}) dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page")) tagsUpdateLabels("offline") checkTaggedSkidsInGame() tagsMessageOnlineSkids() end end end})
TaT_AddSec:AddButton({Name = "Copy Username", Callback = function() if OrionLib.Flags["tags_select_tag"].Value ~= "-" then setclipboard(OrionLib.Flags["tags_select_tag"].Value) end end})
TaT_AddSec:AddButton({Name = "Refresh List", Callback = function() TaggedSkids = loadstring("return "..readfile("oblivion/CB/tagged.cfg"))() tagsUpdateLabels("offline") dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page")) checkTaggedSkidsInGame() end})
Settings.tags.countlabel = TaT_AddSec:AddLabel("")
Settings.tags.onlinelabel = TaT_AddSec:AddLabel("Online:")
TaT_AddSec:AddToggle({Name = "Online Check", Default = false, Flag = "tags_online_check", Callback = function(val) saveData() if val == true and OblivionRan.Value == true then tagsMessageOnlineSkids() end end})
TaT_AddSec:AddDropdown({Name = "Check Speed", Default = "Stable", Options = {"Stable", "Fast"}, Flag = "tags_check_speed", Callback = function() saveData() end})
TaT_MergeSec:AddDropdown({Name = "File", Default = "-", Options = {"-"}, Flag = "tags_merge_file"})
TaT_MergeSec:AddButton({Name = "Refresh", Callback = function() local temp = {"-"} for i,v in pairs(listfiles("oblivion")) do table.insert(temp, v) end dropdownRefresh("tags_merge_file", "-", temp) end})
TaT_MergeSec:AddButton({Name = "Merge", Callback = function() if OrionLib.Flags["tags_merge_file"].Value ~= "-" and isfile(OrionLib.Flags["tags_merge_file"].Value) then local temp = TaggedSkids pcall(function() for i,v in pairs(loadstring("return "..readfile(OrionLib.Flags["tags_merge_file"].Value))()) do pcall(function() for i2,v2 in pairs(v) do if not tagsTableFind(i2, "id") then table.insert(temp, {[i2] = v2}) end end end) end end) writefile("oblivion/CB/tagged.cfg", SaveTable(temp)) TaggedSkids = loadstring("return "..readfile("oblivion/CB/tagged.cfg"))() dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page")) tagsUpdateLabels("offline") OrionLib:MakeNotification({Name = "Oblivion", Content = "Merged tags from: "..OrionLib.Flags["tags_merge_file"].Value..".", Image = "rbxassetid://4384401919", Time = 5}) end end})

local TrT_SoundSec = TrollTab:AddSection({Name = "Sound"})
TrT_SoundSec:AddDropdown({Name = "Sound Speed", Default = "Spam", Options = {"Full speed", "Spammy", "Spam", "Slow", "Confusion"}, Flag = "troll_sound_speed", Callback = function() saveData() end})
TrT_SoundSec:AddToggle({Name = "Sound Spam", Default = false, Flag = "troll_sound_spam", Callback = function() saveData() end})

local MT_QOLSec = MiscTab:AddSection({Name = "QOL"})
local MT_MiscSec = MiscTab:AddSection({Name = "Misc"})
MT_QOLSec:AddToggle({Name = "Anti-AFK", Default = false, Flag = "misc_anti_afk", Callback = function(val) saveData() if val == true then coroutine.wrap(function() while OrionLib.Flags["misc_anti_afk"].Value == true do for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do v:Disable() end wait(1) end end)() end end})
MT_QOLSec:AddToggle({Name = "Blood Removal", Default = false, Flag = "misc_blood_removal", Callback = function(val) saveData() if val == true then Settings.loops.bloodremovalloop = RunService.Heartbeat:Connect(function() pcall(function() Client.splatterBlood = function() end wait(1) end) end) elseif val == false and Settings.loops.bloodremovalloop then Settings.loops.bloodremovalloop:Disconnect() end end})
MT_QOLSec:AddToggle({Name = "Mag Removal", Default = false, Flag = "misc_mag_removal", Callback = function(val) saveData() if val == true then Settings.loops.magremovalloop = workspace.Ray_Ignore.ChildAdded:Connect(function(child) pcall(function() child:WaitForChild("Mesh") if child.Name == "MagDrop" then child:Destroy() end end) end) elseif val == false and Settings.loops.magremovalloop then Settings.loops.magremovalloop:Disconnect() end end})
MT_QOLSec:AddToggle({Name = "Remove Textures", Default = false, Flag = "misc_texture_remove", Callback = function(val) saveData() if val == true then removeTextures() end end})
MT_MiscSec:AddToggle({Name = "Remove Dead Zones", Default = false, Flag = "misc_dead_zones", Callback = function(val) saveData() if val == true and OblivionRan.Value == true then removeDeadZones() end end})
MT_MiscSec:AddToggle({Name = "Walk On Water", Default = false, Flag = "misc_walk_on_water", Callback = function(val) saveData() if val == true and OblivionRan.Value == true then removeDeadZones() end end})
MiscTab:AddDropdown({Name = "Infinite Ammo", Default = "-", Options = {"-", "Mag", "Reserve"}, Flag = "misc_infinite_ammo", Callback = function() saveData() end})
MiscTab:AddToggle({Name = "No Fall Damage", Default = false, Flag = "misc_no_fall_damage", Callback = function() saveData() end})
MiscTab:AddToggle({Name = "Filter Chat", Default = false, Flag = "misc_filter_chat", Callback = function() saveData() end})
MiscTab:AddToggle({Name = "Dead Chat", Default = false, Flag = "misc_dead_chat", Callback = function() saveData() end})
MiscTab:AddDropdown({Name = "Auto Join", Default = "None", Options = {"None", "Terrorists", "Counter-Terrorists"}, Flag = "misc_auto_join", Callback = function() saveData() end})
MiscTab:AddButton({Name = "Kill Server", Callback = function() if mainPlayerCheck(LocalPlayer) then if knifeOrGun() ~= "gun" then OrionLib:MakeNotification({Name = "Oblivion", Content = "Pull out your gun.", Image = "rbxassetid://4384401360", Time = 5}) repeat wait(0.5) until knifeOrGun() == "gun" or mainPlayerCheck(LocalPlayer) == false end if knifeOrGun() == "gun" and mainPlayerCheck(LocalPlayer) then for i = 1,50,1 do repeat wait() until LocalPlayer.Character:FindFirstChild("Gun") and LocalPlayer.Character.Gun:FindFirstChild("Mag") coroutine.wrap(function() for i2 = 1,50,1 do local mag = LocalPlayer.Character.Gun.Mag game:GetService("ReplicatedStorage").Events.DropMag:FireServer(mag) if i == 50 and i2 == 50 then OrionLib:MakeNotification({Name = "Oblivion", Content = "Server killed.", Image = "rbxassetid://4384401360", Time = 5}) end end end)() for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do if v.Name == "MagDrop" then v:Destroy() end end end elseif mainPlayerCheck(LocalPlayer) == false then OrionLib:MakeNotification({Name = "Oblivion", Content = "Cancelled.", Image = "rbxassetid://4384401360", Time = 5}) end elseif mainPlayerCheck(LocalPlayer) == false then OrionLib:MakeNotification({Name = "Oblivion", Content = "You need to be alive for this action.", Image = "rbxassetid://4384401360", Time = 5}) end end})
MiscTab:AddToggle({Name = "No Preparation", Default = false, Flag = "misc_no_preparation", Callback = function() saveData() end})
MiscTab:AddToggle({Name = "Anti Vote Kick", Default = false, Flag = "misc_anti_vote_kick", Callback = function() saveData() end})

local ST_MiscSec = SettingsTab:AddSection({Name = "Misc"})
local ST_VersionSec = SettingsTab:AddSection({Name = "Version"})
ST_MiscSec:AddButton({Name = "Server Hop", Callback = function() Serverhop() end})
ST_MiscSec:AddButton({Name = "Server Rejoin", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end})
ST_VersionSec:AddDropdown({Name = "Branch", Default = "-", Options = {"-"}, Flag = "settings_branch", Callback = function(val) if OrionLib.Flags["settings_build"] then dropdownRefresh("settings_build", versiontable["data"][val]["tables"][1], getAllNames(versiontable["data"][val]["tables"], "empty")) end end})
ST_VersionSec:AddDropdown({Name = "Build", Default = "-", Options = {"-"}, Flag = "settings_build"})
ST_VersionSec:AddButton({Name = "Set", Callback = function() local prefilecheckdata = checkFile() local temp = {} if prefilecheckdata then for i,v in pairs(prefilecheckdata) do if table.find(versiontable.tables, v.branch) and table.find(versiontable.data[v.branch].tables, v.build) and versiontable.data[v.branch].data[v.build] ~= v.url then table.insert(temp, v) elseif table.find(versiontable.tables, v.branch) == false then table.insert(temp, v) end end end table.insert(temp, {url = versiontable.data[OrionLib.Flags["settings_branch"].Value].data[OrionLib.Flags["settings_build"].Value], branch = OrionLib.Flags["settings_branch"].Value, build = OrionLib.Flags["settings_build"].Value, folder = versiontable.folder, gameid = versiontable.gameid}) writefile("oblivion/CB/settings.cfg", SaveTable(temp)) end})

-- Meta
workspace.CurrentCamera.ChildAdded:Connect(function(new)
	pcall(function()
		local Model
		for i,v in pairs(new:GetChildren()) do      
			if v:IsA("Model") and (v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm")) then      
				Model = v      
			end      
		end      
		if Model == nil then return end

		local weaponname = Client.gun ~= "none" and knifeOrGun() == "knife" and OrionLib.Flags["skins_knife"].Value ~= "-" and OrionLib.Flags["skins_knife"].Value or Client.gun ~= "none" and knifeOrGun() == "gun" and Client.gun.Name
		if weaponname ~= nil and ReplicatedStorage.Skins:FindFirstChild(weaponname) then  
			local var = knifeOrGun() == "knife" and Settings.CurrentSkins[OrionLib.Flags["skins_knife"].Value] ~= "Stock" and Settings.CurrentSkins[OrionLib.Flags["skins_knife"].Value] or knifeOrGun() == "gun" and Settings.CurrentSkins[getGunNameFromCheck(weaponname)]
			if var ~= nil then
				MapSkin(weaponname, var)
			end      
		end

		RArm = Model:FindFirstChild("Right Arm"); LArm = Model:FindFirstChild("Left Arm") 
		if RArm then
			RGlove = RArm:FindFirstChild("Glove") or RArm:FindFirstChild("RGlove")
			if OrionLib.Flags["skins_glove"].Value ~= "-" and Client.gun ~= "none" and OrionLib.Flags["skins_glove_skin"].Value ~= "Stock" then
				if RGlove then RGlove:Destroy() end      
				RGlove = ReplicatedStorage.Gloves.Models[OrionLib.Flags["skins_glove"].Value].RGlove:Clone()      
				RGlove.Mesh.TextureId = ReplicatedStorage.Gloves[OrionLib.Flags["skins_glove"].Value][OrionLib.Flags["skins_glove_skin"].Value].Textures.TextureId      
				RGlove.Parent = RArm      
				RGlove.Transparency = 0      
				RGlove.Welded.Part0 = RArm      
			end
		end
		if LArm then
			LGlove = LArm:FindFirstChild("Glove") or LArm:FindFirstChild("LGlove")      
			if OrionLib.Flags["skins_glove"].Value ~= "-" and Client.gun ~= "none" and OrionLib.Flags["skins_glove_skin"].Value ~= "Stock" then      
				if LGlove then LGlove:Destroy() end      
				LGlove = ReplicatedStorage.Gloves.Models[OrionLib.Flags["skins_glove"].Value].LGlove:Clone()       
				LGlove.Mesh.TextureId = ReplicatedStorage.Gloves[OrionLib.Flags["skins_glove"].Value][OrionLib.Flags["skins_glove_skin"].Value].Textures.TextureId      
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
end)

hookfunc(getrenv().xpcall, function() end)

local mt = getrawmetatable(game)

if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end

oldNamecall = hookfunc(mt.__namecall, newcclosure(function(self, ...)
    local method = getnamecallmethod()
	local callingscript = getcallingscript()
    local args = {...}
	
	if method == "Kick" then
		return
	elseif method == "FireServer" then
		if string.len(self.Name) == 38 then
			return wait(99e99)
        elseif self.Name == "HitPart" and not checkcaller() then
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
		elseif self.Name == "ApplyGun" and args[1] == ReplicatedStorage.Weapons.Banana or args[1] == ReplicatedStorage.Weapons["Flip Knife"] then
			args[1] = ReplicatedStorage.Weapons.Karambit
		elseif self.Name == "test" then
			return wait(99e99)
		elseif self.Name == "FallDamage" and OrionLib.Flags["misc_no_fall_damage"].Value == true or self.Name == "FallDamage" and Settings.falldamagefilter == true then
			return
		end
	elseif method == "InvokeServer" then
		if self.Name == "Moolah" then
			return wait(99e99)
		elseif self.Name == "Filter" and callingscript == LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat then
			--print(args[2].Name .. ": " .. args[1])
			if args[2] == LocalPlayer then
				if true == false then
					return args[1]
				end
			elseif args[2] ~= LocalPlayer then
				if OrionLib.Flags["misc_dead_chat"].Value == true and workspace.Status.RoundOver.Value == false and workspace.Status.Preparation.Value == false and warmupCheck() == false and mainPlayerCheck(LocalPlayer) and checkGame() == "casual" and IsAlive(args[2]) == false and GetTeam(args[2]) ~= "s" then
					coroutine.wrap(function()
						if tagsTableFind(args[2].UserId, "id") then
							DisplayChat.moveOldMessages()
							DisplayChat.createNewMessage("<Dead Chat> [Tagged] "..args[2].Name, args[1], Settings.TaggedColor, Color3.new(1,1,1), 0.01, nil)
						else
							DisplayChat.moveOldMessages()
							DisplayChat.createNewMessage("<Dead Chat> "..args[2].Name, args[1], Settings.DeadColor, Color3.new(1,1,1), 0.01, nil)
						end
					end)()
				end
			end
		end
	elseif method == "FindPartOnRayWithIgnoreList" and args[2][1] == workspace.Debris then
		if not checkcaller() or Settings.aimbot.filter then
			if OrionLib.Flags["aimbot_method"].Value == "Silent Aim" and Settings.aimbot.target ~= nil and (OrionLib.Flags["aimbot_keybind_only"].Value == false or OrionLib.Flags["aimbot_keybind_only"].Value == true and Settings.aimbot.aim == true) then
				args[1] = Ray.new(LocalPlayer.Character.Head.Position, (Settings.aimbot.target.Character.Head.Position - LocalPlayer.Character.Head.Position).unit * (ReplicatedStorage.Weapons[LocalPlayer.Character.EquippedTool.Value].Range.Value * 0.1))
			end
		end
    end

	return oldNamecall(self, unpack(args))
end))

DisplayChat.createNewMessage = function(plr, msg, teamcolor, msgcolor, offset, line)
	if OrionLib.Flags["misc_filter_chat"].Value == true then
		if plr == LocalPlayer.Name then
			return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
		elseif teamcolor == Settings.DeadColor then
			return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
		elseif teamcolor == Settings.TaggedColor then
			return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
		elseif game.Players:FindFirstChild(plr) and checkGame() == "casual" then
			local player = game.Players[plr]
			if PlayerCheck(player) then
				return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
			elseif IsAlive(player) == false and GetTeam(player) ~= "s" and warmupCheck() == false and workspace.Status.Preparation.Value == false and offset == 0.01 then
				return createNewMessage("<Dead Warning> "..plr, msg, Settings.WarningColor, msgcolor, offset, line)
			elseif warmupCheck() or workspace.Status.RoundOver.Value == true or workspace.Status.Preparation.Value == true then
				return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
			end
		elseif game.Players:FindFirstChild(plr) and checkGame() ~= "casual" then
			return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
		end
	end

	return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
end

Mouse.Move:Connect(function()
	if FOV.Visible then
		FOV.Position = game:GetService("UserInputService"):GetMouseLocation()
	end
	if TriggerbotFOV.Visible then
		TriggerbotFOV.Position = game:GetService("UserInputService"):GetMouseLocation()
	end
end)

RunService.RenderStepped:Connect(function(step)
	pcall(function()
		local isalivelp = IsAlive(LocalPlayer)
		local teamlp = GetTeam(LocalPlayer)
		local mainlp = mainPlayerCheck(LocalPlayer)
		local prepcheck = OrionLib.Flags["rage_kill_prep_check"].Value == false and true or OrionLib.Flags["rage_kill_prep_check"].Value == true and workspace.Status.Preparation.Value == true and false or OrionLib.Flags["rage_kill_prep_check"].Value == true and workspace.Status.Preparation.Value == false and true
		Settings.LastStep = step
		Settings.Ping = game.Stats.PerformanceStats.Ping:GetValue()

		if OblivionASD.Value ~= 0 then
			OblivionASD.Value = OblivionASD.Value - 1
		end

		coroutine.wrap(function()
			for _,Player in pairs(game.Players:GetPlayers()) do
				if Player.Character and Player ~= LocalPlayer and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart:FindFirstChild("OldPosition") then      
					coroutine.wrap(function()
						local Position = Player.Character.HumanoidRootPart.Position      
						RunService.RenderStepped:Wait()      
						if Player.Character and Player ~= LocalPlayer and Player.Character:FindFirstChild("HumanoidRootPart") then      
							if Player.Character.HumanoidRootPart:FindFirstChild("OldPosition") then      
								Player.Character.HumanoidRootPart.OldPosition.Value = Position      
							else
								local Value = Instance.new("Vector3Value")      
								Value.Name = "OldPosition"      
								Value.Value = Position      
								Value.Parent = Player.Character.HumanoidRootPart      
							end
						end
					end)()
				end
			end
		end)()

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
			if OrionLib.Flags["aimbot_triggerbot_enable"].Value == true and Settings.aimbot.target and mainlp then
				if OrionLib.Flags["aimbot_triggerbot_delay"].Value ~= 0 then
					wait((OrionLib.Flags["aimbot_triggerbot_delay"].Value / 1000))
				end
				triggerBot()
			end
		end)()

		coroutine.wrap(function()
			if OrionLib.Flags["aimbot_enable"].Value == true and mainlp then
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

		if OrionLib.Flags["aimbot_stand_still"].Value == true and mainlp and LocalPlayer.Character.HumanoidRootPart.Velocity.Magnitude < 3 then
			Settings.aimbot.standing = true
		else
			Settings.aimbot.standing = false
		end

		if Settings.aimbot.target == nil then
			TriggerbotFOV.Radius = 1
		end

		if workspace:FindFirstChild("Map"):FindFirstChild("Origin") and Settings.currentmap ~= workspace.Map.Origin.Value then
			Settings.currentmap = workspace.Map.Origin.Value
			repeat wait(1) until OblivionRan.Value == true
			OblivionMapChange.Value = OblivionMapChange.Value + 1
		end

        coroutine.wrap(function()
            if Settings.lists.refreshplayerlist == false then
                Settings.lists.refreshplayerlist = true

                local temp = {all_players = {"-"}, alive_players = {"-"}, enemy_players = {"-"}, team_players = {"-"}, alive_enemy_players = {"-"}, alive_visible_enemy_players = {}}
                for i,v in pairs(game.Players:GetChildren()) do
                    if v ~= LocalPlayer then
                        table.insert(temp.all_players, v.Name)
    
						if checkGamemode("team") and GetTeam(v) ~= GetTeam(LocalPlayer) or checkGamemode("ffa") then
							table.insert(temp.enemy_players, v.Name)
						end
		
						if checkGamemode("team") and GetTeam(v) == GetTeam(LocalPlayer) then
							table.insert(temp.team_players, v.Name)
						end
		
						if IsAlive(v) and GetTeam(v) ~= "s" then
							table.insert(temp.alive_players, v.Name)
						end

						if PlayerCheck(v) then
							table.insert(temp.alive_enemy_players, v.Name)
							local success, response = pcall(function() return Settings.lists.cooldownlist[v.Name] and true or false end)
							if success and response then
								if Settings.lists.cooldownlist[v.Name].time == 0 then
									Settings.lists.cooldownlist[v.Name].time = 10
									local character, torso = GetCharacter(v)
									local returned = VisibleCheck(character, torso.Position)
									Settings.lists.cooldownlist[v.Name].value = returned
									if returned then table.insert(temp.alive_visible_enemy_players, v.Name) end
								else
									Settings.lists.cooldownlist[v.Name].time = Settings.lists.cooldownlist[v.Name].time - 1
									if Settings.lists.cooldownlist[v.Name].value == true then table.insert(temp.alive_visible_enemy_players, v.Name) end
								end
							else
								Settings.lists.cooldownlist[v.Name] = {time = 0, value = false}
							end
						end
					end
                end
    
				if not compareTables(temp.enemy_players, OrionLib.Flags["rage_kill_player_1"].Options) then
					OrionLib.Flags["rage_kill_player_1"]:Refresh(temp.enemy_players, true)
					if not table.find(temp.enemy_players, OrionLib.Flags["rage_kill_player_1"].Value) then
						OrionLib.Flags["rage_kill_player_1"]:Set("-")
					end
				end

				if not compareTables(temp.enemy_players, OrionLib.Flags["rage_kill_player_2"].Options) then
					OrionLib.Flags["rage_kill_player_2"]:Refresh(temp.enemy_players, true)
					if not table.find(temp.enemy_players, OrionLib.Flags["rage_kill_player_2"].Value) then
						OrionLib.Flags["rage_kill_player_2"]:Set("-")
					end
				end

				if not compareTables(temp.enemy_players, OrionLib.Flags["rage_kill_player_3"].Options) then
					OrionLib.Flags["rage_kill_player_3"]:Refresh(temp.enemy_players, true)
					if not table.find(temp.enemy_players, OrionLib.Flags["rage_kill_player_3"].Value) then
						OrionLib.Flags["rage_kill_player_3"]:Set("-")
					end
				end

                if not compareTables(temp.all_players, OrionLib.Flags["tags_select_player"].Options) then
                    OrionLib.Flags["tags_select_player"]:Refresh(temp.all_players, true)
                    if not table.find(temp.all_players, OrionLib.Flags["tags_select_player"].Value) then
                        OrionLib.Flags["tags_select_player"]:Set("-")
                    end
                end

				Settings.lists.alive_enemies = temp.alive_enemy_players
				Settings.lists.alive_visible_enemies = temp.alive_visible_enemy_players

                RunService.RenderStepped:Wait()
                Settings.lists.refreshplayerlist = false
            end
        end)()

		coroutine.wrap(function()
			if OrionLib.Flags["misc_infinite_ammo"].Value ~= "-" and mainlp then
				local val = getGunName()
				if val and OrionLib.Flags["misc_infinite_ammo"].Value == "Mag" and Settings.weapon_info.guns[val].data.type == "primary" then
					Client.ammocount = Settings.weapon_info.guns[val].data.clip
				elseif val and OrionLib.Flags["misc_infinite_ammo"].Value == "Mag" and Settings.weapon_info.guns[val].data.type == "secondary" then
					Client.ammocount2 = Settings.weapon_info.guns[val].data.clip
				elseif val and OrionLib.Flags["misc_infinite_ammo"].Value == "Reserve" and Settings.weapon_info.guns[val].data.type == "primary" then
					Client.primarystored = Settings.weapon_info.guns[val].data.ammo
				elseif val and OrionLib.Flags["misc_infinite_ammo"].Value == "Reserve" and Settings.weapon_info.guns[val].data.type == "secondary" then
					Client.secondarystored = Settings.weapon_info.guns[val].data.ammo
				end
			end
		end)()

		coroutine.wrap(function()
			for _,Player in pairs(game.Players:GetChildren()) do
				coroutine.wrap(function()
					if IsAlive(Player) and GetTeam(Player) ~= "s" and Player ~= LocalPlayer then
						if OrionLib.Flags["rage_anti_anti_aim_pitch"].Value == true then
							Player.Character.UpperTorso.Waist.C0 = CFrame.Angles(0, 0, 0)      
							Player.Character.LowerTorso.Root.C0 = CFrame.Angles(0,0,0)
							Player.Character.Head.Neck.C0 = CFrame.new(0,1,0) * CFrame.Angles(0, 0, 0)
						end

						if OrionLib.Flags["rage_anti_anti_aim_roll"].Value == true then
							Player.Character.Humanoid.MaxSlopeAngle = 0
						end

						if OrionLib.Flags["rage_anti_anti_aim_animation"].Value == true then
							for i2,Animation in pairs(Player.Character.Humanoid:GetPlayingAnimationTracks()) do
								Animation:Stop()
							end
						end
					end
				end)()

				coroutine.wrap(function()
					local targetsalive = OrionLib.Flags["rage_teleport_continuous_teleport"].Value == true and true or OrionLib.Flags["rage_kill_player_enable_1"].Value == true and targetChecks("rage_kill_player_1") and true or OrionLib.Flags["rage_kill_player_enable_2"].Value == true and targetChecks("rage_kill_player_2") and true or OrionLib.Flags["rage_kill_player_enable_3"].Value == true and targetChecks("rage_kill_player_3") and true or OrionLib.Flags["rage_kill_all"].Value == true and (OrionLib.Flags["rage_kill_all_visible"].Value == false and #Settings.lists.alive_enemies ~= 1 or OrionLib.Flags["rage_kill_all_visible"].Value == true and #Settings.lists.alive_visible_enemies ~= 1) or false
					if mainlp and (OrionLib.Flags["rage_teleport_target_dodge"].Value == true or OrionLib.Flags["rage_teleport_continuous_teleport"].Value == true) and targetsalive and prepcheck and Player ~= LocalPlayer and PlayerCheck(Player) then
						teleportToPlayer(Player, "random_radius")
						Settings.teleportreset = false
					elseif mainlp and (OrionLib.Flags["rage_teleport_target_dodge"].Value == true or OrionLib.Flags["rage_teleport_continuous_teleport"].Value == true) and targetsalive and prepcheck == false then
						teleportToPlayer(LocalPlayer, "after_prep")
						Settings.teleportreset = false
					elseif mainlp and (OrionLib.Flags["rage_teleport_target_dodge"].Value == true or OrionLib.Flags["rage_teleport_continuous_teleport"].Value == true) and targetsalive == false and Settings.teleportreset == false then
						Settings.teleportreset = true
						teleportTospawnpoint()
					end
				end)()

				coroutine.wrap(function()
					if mainlp and OrionLib.Flags["rage_kill_all"].Value == true and prepcheck and Player ~= LocalPlayer and (OrionLib.Flags["rage_kill_all_visible"].Value == false or OrionLib.Flags["rage_kill_all_visible"].Value == true and table.find(Settings.lists.alive_visible_enemies, Player.Name)) then
						killTarget(Player, "kill_all")
					end
				end)()
			end
		end)()

		coroutine.wrap(function()
			if Settings.calctargets == false then
				Settings.calctargets = true
				Settings.calcstep = step
				for i = 1,10,1 do
					if i == 10 and Settings.calcstep == step then
						local targets = 0
						for i = 1,3,1 do
							if OrionLib.Flags["rage_kill_player_enable_"..i].Value == true and targetAlive("rage_kill_player_"..i) then
								targets = targets + 1
							end
						end
						local var = targets == 0 and 1 or math.floor(OrionLib.Flags["rage_kill_loop_rate"].Value / targets)
						Settings.resultloop = targets == 0 and 1 or var < 1 and 1 or var
						wait(1)
						Settings.calctargets = false
					end
				end
			end
		end)()

		coroutine.wrap(function()
			coroutine.wrap(function()
				if mainlp and OrionLib.Flags["rage_kill_player_enable_1"].Value == true and targetChecks("rage_kill_player_1") then
					killTarget(game.Players[OrionLib.Flags["rage_kill_player_1"].Value], "kill_specific")
				end
			end)()

			coroutine.wrap(function()
				if mainlp and OrionLib.Flags["rage_kill_player_enable_2"].Value == true and targetChecks("rage_kill_player_2") then
					killTarget(game.Players[OrionLib.Flags["rage_kill_player_2"].Value], "kill_specific")
				end
			end)()

			coroutine.wrap(function()
				if mainlp and OrionLib.Flags["rage_kill_player_enable_3"].Value == true and targetChecks("rage_kill_player_3") then
					killTarget(game.Players[OrionLib.Flags["rage_kill_player_3"].Value], "kill_specific")
				end
			end)()
		end)()

		if OrionLib.Flags["misc_no_preparation"].Value == true and workspace["Status"] and workspace.Status["Preparation"] then
			workspace.Status.Preparation.Value = false
		end

		coroutine.wrap(function()
			if OrionLib.Flags["troll_sound_spam"].Value == true and Settings.troll.sound.running == false then
				Settings.troll.sound.running = true
				for i,v in pairs(Settings.troll.sound.sounds) do
					if v:IsA("Sound") and OrionLib.Flags["troll_sound_spam"].Value == true then
						v:Play()
						if OrionLib.Flags["troll_sound_speed"].Value ~= "Full speed" then
							wait(OrionLib.Flags["troll_sound_speed"].Value == "Spammy" and 0.2 or OrionLib.Flags["troll_sound_speed"].Value == "Spam" and 1 or OrionLib.Flags["troll_sound_speed"].Value == "Slow" and 5 or OrionLib.Flags["troll_sound_speed"].Value == "Confusion" and 60)
						elseif OrionLib.Flags["troll_sound_speed"].Value == "Full speed" then
							RunService.RenderStepped:Wait()
						end
					end
				end
				Settings.troll.sound.running = false
			end
		end)()

        BodyVelocity:Destroy()
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge,0,math.huge)
		if OrionLib.Flags["rage_bhop_enable"].Value == true and mainlp and UserInputService:IsKeyDown("Space") then
			local add = 0
			if UserInputService:IsKeyDown("A") then add = 90 end
			if UserInputService:IsKeyDown("S") then add = 180 end
			if UserInputService:IsKeyDown("D") then add = 270 end
			if UserInputService:IsKeyDown("A") and UserInputService:IsKeyDown("W") then add = 45 end
			if UserInputService:IsKeyDown("D") and UserInputService:IsKeyDown("W") then add = 315 end
			if UserInputService:IsKeyDown("D") and UserInputService:IsKeyDown("S") then add = 225 end
			if UserInputService:IsKeyDown("A") and UserInputService:IsKeyDown("S") then add = 145 end
			local rot = YROTATION(workspace.CurrentCamera.CFrame) * CFrame.Angles(0,math.rad(add),0)
			BodyVelocity.Parent = LocalPlayer.Character.UpperTorso
			LocalPlayer.Character.Humanoid.Jump = true
			if OrionLib.Flags["rage_bhop_type"].Value == "Gyro Walk" then LocalPlayer.Character.Humanoid.JumpPower = 1 end
			workspace.Gravity = (OrionLib.Flags["rage_bhop_type"].Value == "CFrame" or OrionLib.Flags["rage_bhop_type"].Value == "Gyro") and Settings.defaultGravity or (OrionLib.Flags["rage_bhop_type"].Value == "CFrame Walk" or OrionLib.Flags["rage_bhop_type"].Value == "Gyro Walk") and 99999
			BodyVelocity.Velocity = Vector3.new(rot.LookVector.X,0,rot.LookVector.Z) * (OrionLib.Flags["rage_bhop_speed"].Value * 2)
			if add == 0 and not UserInputService:IsKeyDown("W") then
				BodyVelocity:Destroy()
			elseif OrionLib.Flags["rage_bhop_type"].Value == "CFrame" or OrionLib.Flags["rage_bhop_type"].Value == "CFrame Walk" then
				BodyVelocity:Destroy()
				LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(rot.LookVector.X,0,rot.LookVector.Z) * OrionLib.Flags["rage_bhop_speed"].Value/50
			end
		elseif OrionLib.Flags["rage_bhop_enable"].Value == false then
			if workspace.Gravity ~= Settings.defaultGravity then workspace.Gravity = Settings.defaultGravity end
		end

        if OrionLib.Flags["rage_anti_aim_enable"].Value == true and isalivelp then
			if LocalPlayer.Character.Humanoid.AutoRotate == true then LocalPlayer.Character.Humanoid.AutoRotate = false end
			--[[Settings.rage.spin = math.clamp(Settings.rage.spin + 1, 0, 360)
			if Settings.rage.spin == 360 then Settings.rage.spin = 0 end]]
			local Angle = -math.atan2(workspace.CurrentCamera.CFrame.LookVector.Z, workspace.CurrentCamera.CFrame.LookVector.X) + math.rad(-90)
			Angle = Angle + math.rad(math.random(0, 360))
			local CFramePos = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, Angle, 0)

            LocalPlayer.Character.HumanoidRootPart.CFrame = YROTATION(CFramePos)
			--[[if values.rage.angles["body roll"].Dropdown == "180" then
				Root.CFrame = Root.CFrame * CFrame.Angles(values.rage.angles["body roll"].Dropdown == "180" and math.rad(180) or 0, 1, 0)
				LocalPlayer.Character.Humanoid.HipHeight = 4
			else
				LocalPlayer.Character.Humanoid.HipHeight = 2
			end]]
			local rdnm = math.random(#Settings.rage.antiaim + 1)
			local Pitch = rdnm == (#Settings.rage.antiaim + 1) and math.random(-100, 100)/10 or Settings.rage.antiaim[rdnm]
			--[[if values.rage.angles["extend pitch"].Toggle and (values.rage.angles["pitch"].Dropdown == "up" or values.rage.angles["pitch"].Dropdown == "down") then
				Pitch = (Pitch*2)/1.6
			end]]
			ReplicatedStorage.Events.ControlTurn:FireServer(Pitch, LocalPlayer.Character:FindFirstChild("Climbing") and true or false)
		elseif OrionLib.Flags["rage_anti_aim_enable"].Value == false and isalivelp then
			if LocalPlayer.Character.Humanoid.AutoRotate == false then LocalPlayer.Character.Humanoid.AutoRotate = true end
			LocalPlayer.Character.Humanoid.HipHeight = 2
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, -math.atan2(workspace.CurrentCamera.CFrame.LookVector.Z, workspace.CurrentCamera.CFrame.LookVector.X) + math.rad(270), 0)
			ReplicatedStorage.Events.ControlTurn:FireServer(workspace.CurrentCamera.CFrame.LookVector.Y, LocalPlayer.Character:FindFirstChild("Climbing") and true or false)
		end
	end)
end)

OblivionMapChange:GetPropertyChangedSignal("Value"):Connect(function()
	pcall(function()
		coroutine.wrap(function()
			if OrionLib.Flags["misc_texture_remove"].Value == true then
				removeTextures()
			end
		end)()

		coroutine.wrap(function()
			if OrionLib.Flags["tags_online_check"].Value == true then
				tagsMessageOnlineSkids("forced")
			end
		end)()

		coroutine.wrap(function()
			if OrionLib.Flags["misc_dead_zones"].Value == true or OrionLib.Flags["misc_walk_on_water"].Value == true then
				removeDeadZones()
			end
		end)()

		coroutine.wrap(function()
			if OrionLib.Flags["misc_auto_join"].Value ~= "None" then
				local var = OrionLib.Flags["misc_auto_join"].Value == "Terrorists" and "T" or OrionLib.Flags["misc_auto_join"].Value == "Counter-Terrorists" and "CT"
				local rounds = workspace.Status.Rounds.Value
				repeat ReplicatedStorage.Events.JoinTeam:FireServer(var) wait(1) until GetTeam(LocalPlayer) == var and rounds == workspace.Status.Rounds.Value or rounds ~= workspace.Status.Rounds.Value
			end
		end)()

        if warmupCheck() and LocalPlayer.PlayerGui.GUI.MapVote.Visible == true or warmupCheck() and LocalPlayer.PlayerGui.GUI.Scoreboard.Visible == true then
            LocalPlayer.PlayerGui.GUI.MapVote.Visible = false
	        LocalPlayer.PlayerGui.GUI.Scoreboard.Visible = false
        end
	end)
end)

game.Players.PlayerAdded:Connect(function(player)
    pcall(function()
        if tagsTableFind(player.UserId, "id") then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged player joined the game: "..player.Name, Image = "rbxassetid://4384401919", Time = 5})
            checkTaggedSkidsInGame()
        end

		player.CharacterAdded:Connect(function(Character)
			wait(1)
			if Character ~= nil and Character:FindFirstChild("HumanoidRootPart") then
				local Value = Instance.new("Vector3Value")
				Value.Name = "OldPosition"
				Value.Value = Character.HumanoidRootPart.Position
				Value.Parent = Character.HumanoidRootPart
			end
		end)
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    pcall(function()
        if tagsTableFind(player.UserId, "id") then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged player left the game: "..player.Name, Image = "rbxassetid://4384401919", Time = 5})
            checkTaggedSkidsInGame(player.UserId)
        end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function()
	pcall(function()
		Settings.godmodeused = false
		coroutine.wrap(function()
			if OrionLib.Flags["rage_auto_set"].Value == true and GetTeam(LocalPlayer) ~= "s" then
				repeat wait() until IsAlive(LocalPlayer)
				godMode()
			end
		end)()
	end)
end)

ReplicatedStorage.Events.SendMsg.OnClientEvent:Connect(function(message)
	if OrionLib.Flags["misc_anti_vote_kick"].Value == true then
		local msg = string.split(message, " ")
		if game.Players:FindFirstChild(msg[1]) and msg[7] == "1" and msg[12] == game.Players.LocalPlayer.Name then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		elseif game.Players:FindFirstChild(msg[1]) and msg[7] == "2" and msg[12] == game.Players.LocalPlayer.Name then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		elseif game.Players:FindFirstChild(msg[1]) and msg[7] == "-1" and msg[12] == game.Players.LocalPlayer.Name then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end
	end
end)

for _,Player in pairs(game.Players:GetPlayers()) do
	Player.CharacterAdded:Connect(function()
		wait(1)
		if Player.Character ~= nil and Player.Character:FindFirstChild("HumanoidRootPart") then      
			local Value = Instance.new("Vector3Value")      
			Value.Value = Player.Character.HumanoidRootPart.Position      
			Value.Name = "OldPosition"      
			Value.Parent = Player.Character.HumanoidRootPart    
		end
	end)

	if Player.Character ~= nil and Player.Character:FindFirstChild("UpperTorso") then      
		local Value = Instance.new("Vector3Value")      
		Value.Name = "OldPosition"      
		Value.Value = Player.Character.HumanoidRootPart.Position
		Value.Parent = Player.Character.HumanoidRootPart
	end
end

-- Init
for _, Model in pairs(ReplicatedStorage.Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = Models
end

versiontable = checkId()

dropdownRefresh("skins_weapon", "-", getAllNames(Settings.weapon_data))
dropdownRefresh("skins_knife", "-", getAllNames(Settings.knife_data))
dropdownRefresh("skins_glove", "-", getAllNames(Settings.glove_data))
dropdownRefresh("settings_branch", versiontable["tables"][1], versiontable["tables"])
dropdownRefresh("tags_select_tag", "-", tagsListUsernames("page"))
tagsUpdateLabels("offline")

if isfile("oblivion/CB/data.cfg") then
	OrionLib:MakeNotification({Name = "Oblivion", Content = "Trying to load save.", Image = "rbxassetid://4384402413", Time = 5})
	local output
	local a,b = pcall(function()
		output = loadstring("return"..readfile("oblivion/CB/data.cfg"))()
	end)
	if a == true then
		Settings.CurrentSkins = output.skins
		for i,v in pairs(output.data) do
			for i2,v2 in pairs(v) do
                if OrionLib.Flags[i2] then
				    OrionLib.Flags[i2]:Set(v2.Value)
                else
                    Settings.saveerror = true
                end
			end
		end
        if Settings.saveerror == true then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Some values might be corrupted in the save.", Image = "rbxassetid://4384402990", Time = 5})
        elseif Settings.saveerror == false then
            OrionLib:MakeNotification({Name = "Oblivion", Content = "Succesfully loaded save.", Image = "rbxassetid://4384403532", Time = 5})
        end
	elseif a == false then
		OrionLib:MakeNotification({Name = "Oblivion", Content = "Error loading save.", Image = "rbxassetid://4384402990", Time = 10})
	end
end

OrionLib:Init()
espLib.Init()
OrionLib:MakeNotification({Name = "Oblivion", Content = "Succesfully loaded.", Image = "rbxassetid://4400702457", Time = 5})
OrionLib:MakeNotification({Name = "Oblivion", Content = "Welcome "..LocalPlayer.Name..".", Image = "rbxassetid://4431165334", Time = 10})
OblivionRan.Value = true

--[[
	List:
		[High]

		[Mid]
		-Aimbot Distance/Crosshair prioritization, both if possible working together [Low] [Working]
		-Aimbot Silent Aim with triggerbot [Unknown]

		[Low]
		-Transfer all features from my modified hex to Oblivion. [Mid] [Started/Working]
]]--