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
local hookfunc = hookfunc or hookfunction or replaceclosure or false
local workspace = workspace or game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Config
if not isfolder("oblivion") then
    makefolder("oblivion")
end

if isfile("oblivion/tagged.cfg") then
	TaggedSkids = loadstring("return "..readfile("oblivion/tagged.cfg"))()
else
	TaggedSkids = {}
end

writefile("oblivion/weapon_data.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/weapon_info.cfg"))
writefile("oblivion/weapon_types.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/weapons.cfg"))

-- Main
repeat wait() until workspace["Map"] and workspace.Map["Origin"]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local espLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Sirius/request/library/esp/esp.lua'),true))()
local versions = loadstring("return "..readfile("oblivion/versions.cfg"))()

local Settings = {CurrentSkins = {}, LastStep = nil, Ping = nil, dropdownfilter = false, CustomSkins = false, data = {}, tags = {countlabel = nil, onlinelabel = nil, cooldown = 0, cooldowntoggle = false}, aimbot = {enable = false, method = "distance", aim = false, target = nil, standing = false, distance = math.huge, targetresettime = 0}, playerlist = {}, lists = {refreshplayerlist = false}, saveerror = false, godmodeused = false, currentmap = workspace.Map.Origin.Value, weapon_data = table.foreach(loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), function(i,v) if i == "guns" then return v end end), knife_data = table.foreach(loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), function(i,v) if i == "knives" then return v end end), glove_data = table.foreach(loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), function(i,v) if i == "gloves" then return v end end), weapon_info = loadstring("return "..readfile("oblivion/weapon_data.cfg"))(), weapon_types = loadstring("return "..readfile("oblivion/weapon_types.cfg"))(), loops = {bloodremovalloop = nil, magremovalloop = nil}}
Settings.CurrentSkins["-"] = "-"

for i,v in pairs(Settings.weapon_data) do
	Settings.CurrentSkins[i] = "Stock"
end
for i,v in pairs(Settings.knife_data) do
	Settings.CurrentSkins[i] = "Stock"
end

local LocalPlayer = game:GetService('Players').LocalPlayer
local Client = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
local Mouse = LocalPlayer:GetMouse()
local FOV = Drawing.new("Circle")
FOV.Thickness = 2
local TriggerbotFOV = Drawing.new("Circle")
TriggerbotFOV.Thickness = 2

local IgnoredFlags = {"settings_branch", "settings_build", "skins_weapon", "skins_weapon_skin", "tags_select_player", "tags_select_tag", "skins_knife_skin", "rage_kill_player", "rage_kill_player_enable"}
local Hitboxes = {"Head", "LeftHand", "LeftUpperArm", "RightHand", "RightUpperArm", "LeftFoot", "LeftUpperLeg", "RightFoot", "RightUpperLeg", "UpperTorso", "LowerTorso"}

OrionLib:MakeNotification({Name = "Oblivion", Content = "Oblivion is loading.", Image = "rbxassetid://4400702947", Time = 3})

local Window = OrionLib:MakeWindow({Name = "Oblivion", HidePremium = true, SaveConfig = false, ConfigFolder = "oblivion"})

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
					--Key = ('["%s"]'):format(Key)
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
    local temp = OrionLib.Flags["skins_custom"].Value == false and {} or OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) == false and {} or OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) and state == "normal" and {[1] = "Show custom skins"} or OrionLib.Flags["skins_custom"].Value == true and hasCustom(type, gun) and state == "custom" and {[1] = "Show normal skins"}
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
        writefile("oblivion/data.cfg", SaveTable(tempmaster))
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
	local main = type == "guns" and "skins_weapon" or type == "knives" and "skins_knife"
	local sub = type == "guns" and "skins_weapon_skin" or type == "knives" and "skins_knife_skin"
	local var = skinsGunList(OrionLib.Flags[main].Value, state, type)
	OrionLib.Flags[sub]:Refresh(var, true)
	if table.find(var, Settings.CurrentSkins[OrionLib.Flags[main].Value]) then
		OrionLib.Flags[sub]:Set(Settings.CurrentSkins[OrionLib.Flags[main].Value])
	elseif not table.find(var, Settings.CurrentSkins[OrionLib.Flags[main].Value]) then
		Settings.dropdownfilter = true
		OrionLib.Flags[sub]:Set(var[1])
		Settings.dropdownfilter = false
	end
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
		if Client.gun ~= "none" and v.name == Client.gun.Name then
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

local function tagsListUsernames()
	local temp = {"-"}
	table.foreach(TaggedSkids, function(i, v)
		table.foreach(v, function(i2, v2)
			table.insert(temp, v2)
		end)
	end)

	return temp
end

local function tagsListUserIds()
	local temp = {}
	table.foreach(TaggedSkids, function(i, v)
		table.foreach(v, function(i2, v2)
			table.insert(temp, i2)
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
			Settings.tags.countlabel:Set("Tagged Players: "..(#tagsListUsernames() - 1))
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
		
		wait()
	end

	return response
end

local function tagsListOnlineSkids(player)
	if player then
		if tagsListIdFromUsername(player) then
			return tagsHttpGet(tagsListIdFromUsername(player))
		end
	else
		local temp = {"-"}
		for i,v in pairs(tagsListUserIds()) do
			local response = tagsHttpGet(v)
			if response["IsOnline"] and response.IsOnline == true then
				table.insert(temp, tagsListUsernameFromId(v))
			end
		end

		return temp
	end

	return false
end

local function checkTaggedSkidsInGame()
	local iteration = 0
	local string = ""

    while OblivionRan.Value == false do
        wait()
    end

	for i,v in pairs(game.Players:GetChildren()) do
		if tagsTableFind(v.UserId, "id") then
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
		Settings.tags.cooldown = 5000 + ((#tagsListUsernames() - 1) * 100)

        while OblivionRan.Value == false do
            wait()
        end

        OrionLib:MakeNotification({Name = "Oblivion", Content = "Checking for online tagged players.", Image = "rbxassetid://4384401919", Time = 10})
		local temp = tagsListOnlineSkids()
		table.remove(temp, 1)
		local string = ""

        writefile("oblivion/temp.cfg", SaveTable(temp))

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
		if OrionLib.Flags["rage_god_mode"].Value == "Hostage" then
			ReplicatedStorage.Events.ApplyGun:FireServer({
				Model = ReplicatedStorage.Hostage.Hostage,
				Name = "USP"
			}, LocalPlayer);
		elseif OrionLib.Flags["rage_god_mode"].Value == "Fall Damage" then
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
        OrionLib:MakeNotification({Name = "Oblivion", Content = "Custom Skins is still being worked on, but can already be used.", Image = "rbxassetid://4335483762", Time = 5})
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

local function killTarget(target)
	local prepcheck = OrionLib.Flags["rage_kill_prep_check"].Value == false and true or OrionLib.Flags["rage_kill_prep_check"].Value == true and workspace.Status.Preparation.Value == true and false or OrionLib.Flags["rage_kill_prep_check"].Value == true and workspace.Status.Preparation.Value == false and true
	if PlayerCheck(game.Players[OrionLib.Flags["rage_kill_player"].Value]) and prepcheck then
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
		for i = 1,OrionLib.Flags["rage_kill_loop_rate"].Value,1 do
			ReplicatedStorage.Events.HitPart:FireServer(unpack(Arguments))
		end
	end
end

-- Esp Setup
espLib.whitelist = {}
espLib.blacklist = {}
espLib.options = {enabled = nil, scaleFactorX = 4, scaleFactorY = 5, font = 2, fontSize = 13, limitDistance = false, maxDistance = 1000, visibleOnly = nil, teamCheck = nil, teamColor = nil, fillColor = nil, whitelistColor = Color3.new(1, 0, 0), outOfViewArrows = false, outOfViewArrowsFilled = false, outOfViewArrowsSize = 25, outOfViewArrowsRadius = 100, outOfViewArrowsColor = Color3.new(1, 1, 1), outOfViewArrowsTransparency = 0.5, outOfViewArrowsOutline = false, outOfViewArrowsOutlineFilled = false, outOfViewArrowsOutlineColor = Color3.new(1, 1, 1), outOfViewArrowsOutlineTransparency = 1, names = nil, nameTransparency = nil, nameColor = nil, boxes = true, boxesTransparency = nil, boxesColor = nil, boxFill = false, boxFillTransparency = 0.5, boxFillColor = Color3.new(1, 1, 1), healthBars = true, healthBarsSize = 1, healthBarsTransparency = nil, healthBarsColor = nil, healthText = true, healthTextTransparency = nil, healthTextSuffix = "%", healthTextColor = nil, distance = true, distanceTransparency = nil, distanceSuffix = " Studs", distanceColor = nil, tracers = nil, tracerTransparency = nil, tracerColor = nil, tracerOrigin = nil, chams = nil, chamsColor = nil, chamsTransparency = nil}

--[[for i,v in ipairs(workspace:GetChildren()) do
    for i2,v2 in pairs(game.Players:GetPlayers()) do
        if v2.Name == v.Name then
            Settings.playerlist[v.Name] = v
        end
    end
end]]--

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

RageTab:AddLabel("God Mode")
RageTab:AddDropdown({Name = "Type", Default = "-", Options = {"-", "Hostage", "Fall Damage", "Humanoid", "Invisibility"}, Flag = "rage_god_mode", Callback = function() saveData() end})
RageTab:AddToggle({Name = "Auto Set", Default = false, Flag = "rage_auto_set", Callback = function(val) saveData() if val == true then godMode() end end})
RageTab:AddButton({Name = "Set", Callback = function() godMode() end})
RageTab:AddLabel("Kill All")
RageTab:AddDropdown({Name = "Weapon", Default = "Held", Options = {"Held", "Random Gun", "Random Knife", "Both"}, Flag = "rage_kill_weapon", Callback = function() saveData() end})
RageTab:AddToggle({Name = "Insta Kill", Default = false, Flag = "rage_insta_kill", Callback = function() saveData() end})
RageTab:AddToggle({Name = "Velocity Prediction", Default = false, Flag = "rage_kill_velocity_prediction", Callback = function() saveData() end})
RageTab:AddToggle({Name = "Preparation Check", Default = false, Flag = "rage_kill_prep_check", Callback = function() saveData() end})
RageTab:AddSlider({Name = "Loop Rate", Min = 1, Max = 50, Default = 5, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "rage_kill_loop_rate", Callback = function() saveData() end})
RageTab:AddDropdown({Name = "Player", Default = "-", Options = {"-"}, Flag = "rage_kill_player"})
RageTab:AddToggle({Name = "Enable", Default = false, Flag = "rage_kill_player_enable"})

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
--[[EspTab:AddToggle({Name = "Chams", Default = false, Flag = "esp_chams", Callback = function(val) saveData() espLib.options.chams = val end})
EspTab:AddSlider({Name = "Chams Transparency", Min = 0, Max = 100, Default = 0, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_chams_transparency", Callback = function(val) saveData() espLib.options.chamsTransparency = (val / 100) end})
EspTab:AddColorpicker({Name = "Chams Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_chams_color", Callback = function(val) saveData() espLib.options.chamsColor = val end})]]--
EspTab:AddToggle({Name = "Tracers", Default = false, Flag = "esp_tracers", Callback = function(val) saveData() espLib.options.tracers = val end})
EspTab:AddSlider({Name = "Tracer Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_tracer_transparency", Callback = function(val) saveData() espLib.options.tracerTransparency = (val / 100) end})
EspTab:AddColorpicker({Name = "Tracer Color", Default = Color3.fromRGB(255, 255, 255), Flag = "esp_tracer_color", Callback = function(val) saveData() espLib.options.tracerColor = val end})
EspTab:AddDropdown({Name = "Tracer Origin", Default = "Bottom", Options = {"Bottom", "Top", "Mouse"}, Flag = "esp_tracerorigin", Callback = function(val) saveData() espLib.options.tracerOrigin = val end})

SkinsTab:AddToggle({Name = "Custom Skins", Default = false, Flag = "skins_custom", Callback = function(val) saveData()
	if val == true then
		loadCustomSkins()
		if OrionLib.Flags["skins_weapon"] and OrionLib.Flags["skins_weapon"].Value ~= "-" then
			dropdownCustom("normal", "guns")
		end
		if OrionLib.Flags["skins_knife"] and OrionLib.Flags["skins_knife"].Value ~= "-" then
			dropdownCustom("normal", "knives")
		end
	elseif val == false then
		if OrionLib.Flags["skins_weapon"] and OrionLib.Flags["skins_weapon"].Value ~= "-" then
			dropdownCustom("normal", "guns")
		end
		if OrionLib.Flags["skins_knife"] and OrionLib.Flags["skins_knife"].Value ~= "-" then
			dropdownCustom("normal", "knives")
		end
	end end})
SkinsTab:AddDropdown({Name = "Weapon", Default = "-", Options = {"-"}, Flag = "skins_weapon", Callback = function(val)
	if val == "-" and OrionLib.Flags["skins_weapon_skin"] then
		dropdownRefresh("skins_weapon_skin", "-", {"-"})
	elseif val ~= "-" and OrionLib.Flags["skins_weapon_skin"] then
		dropdownCustom("normal", "guns")
	end end})
SkinsTab:AddDropdown({Name = "Weapon Skin", Default = "-", Options = {"-"}, Flag = "skins_weapon_skin", Callback = function(val)
	if Settings.dropdownfilter == false and val == "Show custom skins" then
		dropdownCustom("custom", "guns")
	elseif Settings.dropdownfilter == false and val == "Show normal skins" then
		dropdownCustom("normal", "guns")
	elseif Settings.dropdownfilter == false and val ~= nil then
		Settings.CurrentSkins[OrionLib.Flags["skins_weapon"].Value] = val
		saveData()
	end
end})
SkinsTab:AddDropdown({Name = "Knife", Default = "-", Options = {"-"}, Flag = "skins_knife", Callback = function(val)
	if val == "-" and OrionLib.Flags["skins_knife_skin"] then
		modelChange("v_T Knife", "v_T Knife")
		modelChange("v_CT Knife", "v_CT Knife")
		dropdownRefresh("skins_knife_skin", "-", {"-"})
		saveData()
	elseif val ~= "-" and OrionLib.Flags["skins_knife_skin"] then
		modelChange("v_T Knife", "v_"..val)
		modelChange("v_CT Knife", "v_"..val)
		dropdownCustom("normal", "knives")
		saveData()
	end end})
SkinsTab:AddDropdown({Name = "Knife Skin", Default = "-", Options = {"-"}, Flag = "skins_knife_skin", Callback = function(val)
	if Settings.dropdownfilter == false and val == "Show custom skins" then
		dropdownCustom("custom", "knives")
	elseif Settings.dropdownfilter == false and val == "Show normal skins" then
		dropdownCustom("normal", "knives")
	elseif Settings.dropdownfilter == false and val ~= nil then
		Settings.CurrentSkins[OrionLib.Flags["skins_knife"].Value] = val
		saveData()
	end end})
SkinsTab:AddDropdown({Name = "Glove", Default = "-", Options = {"-"}, Flag = "skins_glove", Callback = function(val)
	if val == "-" and OrionLib.Flags["skins_glove_skin"] then
		dropdownRefresh("skins_glove_skin", "-", {"-"})
		saveData()
	elseif val ~= "-" and OrionLib.Flags["skins_glove_skin"] then
		dropdownRefresh("skins_glove_skin", "Stock", skinsList(val, Settings.glove_data))
		saveData()
	end end})
SkinsTab:AddDropdown({Name = "Glove Skin", Default = "-", Options = {"-"}, Flag = "skins_glove_skin", Callback = function() saveData() end})

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

TagTab:AddDropdown({Name = "Select Player", Default = "-", Options = {"-"}, Flag = "tags_select_player"})
TagTab:AddButton({Name = "Add Tag", Callback = function() if OrionLib.Flags["tags_select_player"].Value ~= "-" then if not tagsTableFind(game.Players[OrionLib.Flags["tags_select_player"].Value].UserId, "id") then table.insert(TaggedSkids, {[game.Players[OrionLib.Flags["tags_select_player"].Value].UserId] = OrionLib.Flags["tags_select_player"].Value}) writefile("oblivion/tagged.cfg", SaveTable(TaggedSkids)) TaggedSkids = loadstring("return "..readfile("oblivion/tagged.cfg"))() OrionLib:MakeNotification({Name = "Oblivion", Content = "Tagged player: "..OrionLib.Flags["tags_select_player"].Value..".", Image = "rbxassetid://4384401919", Time = 5}) OrionLib.Flags["tags_select_player"]:Set("-") dropdownRefresh("tags_select_tag", "-", tagsListUsernames()) tagsUpdateLabels("offline") checkTaggedSkidsInGame() tagsMessageOnlineSkids() elseif tagsTableFind(game.Players[OrionLib.Flags["tags_select_player"].Value].UserId, "id") then OrionLib:MakeNotification({Name = "Oblivion", Content = OrionLib.Flags["tags_select_player"].Value.." is already tagged.", Image = "rbxassetid://4384401919", Time = 5}) end end end})
TagTab:AddDropdown({Name = "Select Tag", Default = "-", Options = {"-"}, Flag = "tags_select_tag", Callback = function(val) if val ~= "-" and tagsTableFind(val, "name") then tagsUpdateLabels("live_reset") tagsUpdateLabels("live", tagsListOnlineSkids(val)) else tagsUpdateLabels("live_reset") end end})
TagTab:AddButton({Name = "Remove Tag", Callback = function() if OrionLib.Flags["tags_select_tag"].Value ~= "-" then if tagsTableFind(OrionLib.Flags["tags_select_tag"].Value, "name") then table.remove(TaggedSkids, tagsTableFind(OrionLib.Flags["tags_select_tag"].Value, "name")) writefile("oblivion/tagged.cfg", SaveTable(TaggedSkids)) TaggedSkids = loadstring("return "..readfile("oblivion/tagged.cfg"))() OrionLib:MakeNotification({Name = "Oblivion", Content = "Removed tag on: "..OrionLib.Flags["tags_select_tag"].Value..".", Image = "rbxassetid://4384401919", Time = 5}) dropdownRefresh("tags_select_tag", "-", tagsListUsernames()) tagsUpdateLabels("offline") checkTaggedSkidsInGame() tagsMessageOnlineSkids() end end end})
TagTab:AddButton({Name = "Copy Username", Callback = function() if OrionLib.Flags["tags_select_tag"].Value ~= "-" then setclipboard(OrionLib.Flags["tags_select_tag"].Value) end end})
TagTab:AddButton({Name = "Refresh List", Callback = function() TaggedSkids = loadstring("return "..readfile("oblivion/tagged.cfg"))() tagsUpdateLabels("offline") dropdownRefresh("tags_select_tag", "-", tagsListUsernames()) checkTaggedSkidsInGame() end})
Settings.tags.countlabel = TagTab:AddLabel("")
Settings.tags.onlinelabel = TagTab:AddLabel("Online:")
TagTab:AddToggle({Name = "Online Check", Default = false, Flag = "tags_online_check", Callback = function() saveData() end})

MiscTab:AddToggle({Name = "Anti-AFK", Default = false, Flag = "misc_anti_afk", Callback = function(val) saveData() if val == true then coroutine.wrap(function() while OrionLib.Flags["misc_anti_afk"].Value == true do for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do v:Disable() end wait(1) end end)() end end})
MiscTab:AddToggle({Name = "Blood Removal", Default = false, Flag = "misc_blood_removal", Callback = function(val) saveData() if val == true then Settings.loops.bloodremovalloop = RunService.Heartbeat:Connect(function() pcall(function() Client.splatterBlood = function() end wait(1) end) end) elseif val == false and Settings.loops.bloodremovalloop then Settings.loops.bloodremovalloop:Disconnect() end end})
MiscTab:AddToggle({Name = "Mag Removal", Default = false, Flag = "misc_mag_removal", Callback = function(val) saveData() if val == true then Settings.loops.magremovalloop = workspace.Ray_Ignore.ChildAdded:Connect(function(child) pcall(function() child:WaitForChild("Mesh") if child.Name == "MagDrop" then child:Destroy() end end) end) elseif val == false and Settings.loops.magremovalloop then Settings.loops.magremovalloop:Disconnect() end end})
MiscTab:AddToggle({Name = "Remove Textures", Default = false, Flag = "misc_texture_remove", Callback = function(val) saveData() if val == true then removeTextures() end end})
MiscTab:AddDropdown({Name = "Infinite Ammo", Default = "-", Options = {"-", "Mag", "Reserve"}, Flag = "misc_infinite_ammo", Callback = function() saveData() end})

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
			elseif self.Name == "ApplyGun" and args[1] == ReplicatedStorage.Weapons.Banana or args[1] == ReplicatedStorage.Weapons["Flip Knife"] then
				args[1] = ReplicatedStorage.Weapons.Karambit
			elseif self.Name == "test" then
				return wait(99e99)
			end
		elseif method == "InvokeServer" then
			if self.Name == "Moolah" then
				return wait(99e99)
			end
		elseif method == "FindPartOnRayWithIgnoreList" and args[2][1] == workspace.Debris then
			if OrionLib.Flags["aimbot_method"].Value == "Silent Aim" and Settings.aimbot.target ~= nil then
				args[1] = Ray.new(LocalPlayer.Character.Head.Position, (Settings.aimbot.target.Character.Head.Position - LocalPlayer.Character.Head.Position).unit * (ReplicatedStorage.Weapons[LocalPlayer.Character.EquippedTool.Value].Range.Value * 0.1))
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

RunService.RenderStepped:Connect(function(step)
	pcall(function()
		local isalivelp = IsAlive(LocalPlayer)
		local teamlp = GetTeam(LocalPlayer)
		local mainlp = mainPlayerCheck(LocalPlayer)
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
				if OrionLib.Flags["aimbot_method"].Value ~= "Silent Aim" then
					if OrionLib.Flags["aimbot_triggerbot_delay"].Value ~= 0 then
						wait((OrionLib.Flags["aimbot_triggerbot_delay"].Value / 1000))
					end
					triggerBot()
				end
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
			OblivionMapChange.Value = OblivionMapChange.Value + 1
		end

        coroutine.wrap(function()
            if Settings.lists.refreshplayerlist == false then
                Settings.lists.refreshplayerlist = true

                local temp = {all_players = {"-"}, alive_players = {"-"}, enemy_players = {"-"}, team_players = {"-"}}
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
					end
                end
    
				if not compareTables(temp.enemy_players, OrionLib.Flags["rage_kill_player"].Options) then
					OrionLib.Flags["rage_kill_player"]:Refresh(temp.enemy_players, true)
					if not table.find(temp.enemy_players, OrionLib.Flags["rage_kill_player"].Value) then
						OrionLib.Flags["rage_kill_player"]:Set("-")
					end
				end

                if not compareTables(temp.all_players, OrionLib.Flags["tags_select_player"].Options) then
                    OrionLib.Flags["tags_select_player"]:Refresh(temp.all_players, true)
                    if not table.find(temp.all_players, OrionLib.Flags["tags_select_player"].Value) then
                        OrionLib.Flags["tags_select_player"]:Set("-")
                    end
                end

                wait(1)
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
			if mainlp and OrionLib.Flags["rage_kill_player_enable"].Value == true and OrionLib.Flags["rage_kill_player"].Value ~= "-" and game.Players:FindFirstChild(OrionLib.Flags["rage_kill_player"].Value) then
				killTarget(game.Players[OrionLib.Flags["rage_kill_player"].Value])
			end
		end)()
	end)
end)

OblivionMapChange:GetPropertyChangedSignal("Value"):Connect(function()
	pcall(function()
		if OrionLib.Flags["misc_texture_remove"].Value == true then
			removeTextures()
		end

        if OrionLib.Flags["tags_online_check"].Value == true then
            tagsMessageOnlineSkids("forced")
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
			if Character ~= nil then
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
            checkTaggedSkidsInGame()
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

--[[workspace.ChildAdded:connect(function(v)
    local success = pcall(function()
        for i2,v2 in pairs(game.Players:GetPlayers()) do
            if v.Name == v2.Name and PlayerCheck(v) then
                return true
            end
        end
    end)
    if success then
        Settings.playerlist[v.Name] = v
    end
end)

workspace.ChildRemoved:connect(function(v)
    if Settings.playerlist[v.Name] then
        Settings.playerlist[v.Name] = nil
    end
end)]]--

-- Init
for _, Model in pairs(ReplicatedStorage.Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = Models
end

dropdownRefresh("skins_weapon", "-", getAllNames(Settings.weapon_data))
dropdownRefresh("skins_knife", "-", getAllNames(Settings.knife_data))
dropdownRefresh("skins_glove", "-", getAllNames(Settings.glove_data))
dropdownRefresh("settings_branch", versions["tables"][1], versions["tables"])
dropdownRefresh("tags_select_tag", "-", tagsListUsernames())
tagsUpdateLabels("offline")

if isfile("oblivion/data.cfg") then
	OrionLib:MakeNotification({Name = "Oblivion", Content = "Trying to load save.", Image = "rbxassetid://4384402413", Time = 5})
	local output
	local a,b = pcall(function()
		output = loadstring("return"..readfile("oblivion/data.cfg"))()
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