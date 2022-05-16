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

if not isfolder("oblivion/skin_changer") then
    makefolder("oblivion/skin_changer")
end

writefile("oblivion/skin_changer/weapon_data.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/weapon_skins_alpha.cfg"))

-- Main
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local versions = loadstring("return "..readfile("hexagon/versions.cfg"))()

local Settings = {CurrentSkins = {}, data = {}, weapon_data = table.foreach(loadstring("return "..readfile("oblivion/skin_changer/weapon_data.cfg"))(), function(i,v) if i == "guns" then return v end end), knife_data = table.foreach(loadstring("return "..readfile("oblivion/skin_changer/weapon_data.cfg"))(), function(i,v) if i == "knives" then return v end end), glove_data = table.foreach(loadstring("return "..readfile("oblivion/skin_changer/weapon_data.cfg"))(), function(i,v) if i == "gloves" then return v end end)}
Settings.CurrentSkins["-"] = "-"

for i,v in pairs(Settings.weapon_data) do
	Settings.CurrentSkins[i] = "Stock"
end

local LocalPlayer = game:GetService('Players').LocalPlayer
local Client = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))

local IgnoredFlags = {"branch", "build", "weapon", "weapon_skin"}

OrionLib:MakeNotification({Name = "Oblivion", Content = "Oblivion is loading.", Image = "rbxassetid://4400702947", Time = 3})

local Window = OrionLib:MakeWindow({Name = "Oblivion Skin Changer", HidePremium = true, SaveConfig = false, ConfigFolder = "oblivion/skin_changer"})

-- Workspace
local Oblivion = Instance.new("Folder", workspace)
Oblivion.Name = "Oblivion"

local Models = Instance.new("Folder", Oblivion)
Models.Name = "Models"

local OblivionRan = Instance.new("BoolValue", Oblivion)
OblivionRan.Name = "OblivionRan"
OblivionRan.Value = false

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
        local temp = {[1] = {["knife"] = {}}, [2] = {["knife_skin"] = {}}, [3] = {["glove"] = {}}, [4] = {["glove_skin"] = {}}}
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
        writefile("oblivion/skin_changer/data.cfg", SaveTable(tempmaster))
    end
end

local function dropdownRefresh(flag, value, list)
    OrionLib.Flags[flag]:Refresh(list, true)
    OrionLib.Flags[flag]:Set(value)
end

-- GUI
local SkinsTab = Window:MakeTab({Name = "Skins", Icon = "rbxassetid://4384393547", PremiumOnly = false})
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://3605022185", PremiumOnly = false})

SkinsTab:AddDropdown({Name = "Weapon", Default = "-", Options = {"-"}, Flag = "weapon", Callback = function(val)
    if val == "-" and OrionLib.Flags["weapon_skin"] then
        dropdownRefresh("weapon_skin", "-", {"-"})
    elseif val ~= "-" and OrionLib.Flags["weapon_skin"] then
        dropdownRefresh("weapon_skin", Settings.CurrentSkins[val], Settings.weapon_data[val]["list"])
    end
end})
SkinsTab:AddDropdown({Name = "Weapon Skin", Default = "-", Options = {"-"}, Flag = "weapon_skin", Callback = function(val)
	Settings.CurrentSkins[OrionLib.Flags["weapon"].Value] = val
    saveData()
	table.foreach(Settings.CurrentSkins, function(i,v)
		if i ~= "-" then
			table.foreach(Settings.weapon_data[i]["teams"], function(i2,v2)
				if v2 == "T" then
					LocalPlayer.SkinFolder.TFolder[Settings.weapon_data[i]["name"]].Value = v
				elseif v2 == "CT" then
					LocalPlayer.SkinFolder.CTFolder[Settings.weapon_data[i]["name"]].Value = v
				end
			end)
		end
	end)
end})
SkinsTab:AddDropdown({Name = "Knife", Default = "-", Options = {"-"}, Flag = "knife", Callback = function(val)
	if val == "-" and OrionLib.Flags["knife_skin"] then
		modelChange("v_T Knife", "v_T Knife")
		modelChange("v_CT Knife", "v_CT Knife")
        dropdownRefresh("knife_skin", "-", {"-"})
        saveData()
	elseif val ~= "-" and OrionLib.Flags["knife_skin"] then
		modelChange("v_T Knife", "v_"..val)
		modelChange("v_CT Knife", "v_"..val)
        dropdownRefresh("knife_skin", "Stock", skinsList(val, Settings.knife_data))
        saveData()
	end
end})
SkinsTab:AddDropdown({Name = "Knife Skin", Default = "-", Options = {"-"}, Flag = "knife_skin", Callback = function() saveData() end})
SkinsTab:AddDropdown({Name = "Glove", Default = "-", Options = {"-"}, Flag = "glove", Callback = function(val)
	if val == "-" and OrionLib.Flags["glove_skin"] then
        dropdownRefresh("glove_skin", "-", {"-"})
        saveData()
	elseif val ~= "-" and OrionLib.Flags["glove_skin"] then
        dropdownRefresh("glove_skin", "Stock", skinsList(val, Settings.glove_data))
        saveData()
	end
end})
SkinsTab:AddDropdown({Name = "Glove Skin", Default = "-", Options = {"-"}, Flag = "glove_skin", Callback = function() saveData() end})

SettingsTab:AddButton({Name = "Server Rejoin", Callback = function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end})
SettingsTab:AddButton({Name = "Server Hop", Callback = function() Serverhop() end})
SettingsTab:AddDropdown({Name = "Branch", Default = "-", Options = {"-"}, Flag = "branch", Callback = function(val)
	if OrionLib.Flags["build"] then
        dropdownRefresh("build", versions["data"][val]["tables"][1], getAllNames(versions["data"][val]["tables"], "empty"))
	end
end})
SettingsTab:AddDropdown({Name = "Build", Default = "-", Options = {"-"}, Flag = "build"})
SettingsTab:AddButton({Name = "Save", Callback = function()
	writefile("hexagon/load_version.txt", versions["data"][OrionLib.Flags["branch"].Value]["data"][OrionLib.Flags["build"].Value])
end})

-- Meta
workspace.CurrentCamera.ChildAdded:Connect(function(new)
	local Model
	for i,v in pairs(new:GetChildren()) do      
		if v:IsA("Model") and (v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm")) then      
			Model = v      
		end      
	end      
	if Model == nil then return end

	local weaponname = Client.gun ~= "none" and OrionLib.Flags["knife"].Value ~= "-" and Client.gun:FindFirstChild("Melee") and OrionLib.Flags["knife"].Value 
	if OrionLib.Flags["knife"].Value ~= "-" and weaponname ~= nil and game:GetService("ReplicatedStorage").Skins:FindFirstChild(weaponname) then      
		if OrionLib.Flags["knife_skin"].Value ~= "Stock" then      
			MapSkin(weaponname, OrionLib.Flags["knife_skin"].Value)
		end      
	end

	RArm = Model:FindFirstChild("Right Arm"); LArm = Model:FindFirstChild("Left Arm") 
	if RArm then
		RGlove = RArm:FindFirstChild("Glove") or RArm:FindFirstChild("RGlove")
		if OrionLib.Flags["glove"].Value ~= "-" and Client.gun ~= "none" and OrionLib.Flags["glove_skin"].Value ~= "Stock" then
			if RGlove then RGlove:Destroy() end      
			RGlove = game:GetService("ReplicatedStorage").Gloves.Models[OrionLib.Flags["glove"].Value].RGlove:Clone()      
			RGlove.Mesh.TextureId = game:GetService("ReplicatedStorage").Gloves[OrionLib.Flags["glove"].Value][OrionLib.Flags["glove_skin"].Value].Textures.TextureId      
			RGlove.Parent = RArm      
			RGlove.Transparency = 0      
			RGlove.Welded.Part0 = RArm      
		end
	end
	if LArm then
		LGlove = LArm:FindFirstChild("Glove") or LArm:FindFirstChild("LGlove")      
		if OrionLib.Flags["glove"].Value ~= "-" and Client.gun ~= "none" and OrionLib.Flags["glove_skin"].Value ~= "Stock" then      
			if LGlove then LGlove:Destroy() end      
			LGlove = game:GetService("ReplicatedStorage").Gloves.Models[OrionLib.Flags["glove"].Value].LGlove:Clone()       
			LGlove.Mesh.TextureId = game:GetService("ReplicatedStorage").Gloves[OrionLib.Flags["glove"].Value][OrionLib.Flags["glove_skin"].Value].Textures.TextureId      
			LGlove.Transparency = 0      
			LGlove.Parent = LArm      
			LGlove.Welded.Part0 = LArm      
		end   
	end
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
        end
	end
	
	return oldNamecall(self, unpack(args))
end))

-- Init
for _, Model in pairs(game:GetService("ReplicatedStorage").Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = Models
end

dropdownRefresh("weapon", "-", getAllNames(Settings.weapon_data))
dropdownRefresh("knife", "-", getAllNames(Settings.knife_data))
dropdownRefresh("glove", "-", getAllNames(Settings.glove_data))
dropdownRefresh("branch", versions["tables"][1], versions["tables"])

if isfile("oblivion/skin_changer/data.cfg") then
	OrionLib:MakeNotification({Name = "Oblivion", Content = "Trying to load save.", Image = "rbxassetid://4384402413", Time = 3})
	local output
	local a,b = pcall(function()
		output = loadstring("return"..readfile("oblivion/skin_changer/data.cfg"))()
	end)
	if a == true then
		for i,v in pairs(output["data"]) do
			for i2,v2 in pairs(v) do 
				if v2["Type"] == "Dropdown" then
					OrionLib.Flags[i2]:Set(v2["Value"])
				end
			end
		end
		Settings.CurrentSkins = output["skins"]
		table.foreach(Settings.CurrentSkins, function(i,v)
			if i ~= "-" then
				table.foreach(Settings.weapon_data[i]["teams"], function(i2,v2)
					if v2 == "T" then
						LocalPlayer.SkinFolder.TFolder[Settings.weapon_data[i]["name"]].Value = v
					elseif v2 == "CT" then
						LocalPlayer.SkinFolder.CTFolder[Settings.weapon_data[i]["name"]].Value = v
					end
				end)
			end
		end)
		OrionLib:MakeNotification({Name = "Oblivion", Content = "Succesfully loaded save.", Image = "rbxassetid://4384403532", Time = 3})
	elseif a == false then
		OrionLib:MakeNotification({Name = "Oblivion", Content = "Error loading save.", Image = "rbxassetid://4384402990", Time = 10})
	end
end

OblivionRan.Value = true
OrionLib:Init()
OrionLib:MakeNotification({Name = "Oblivion", Content = "Oblivion has succesfully loaded.", Image = "rbxassetid://4400702457", Time = 3})
OrionLib:MakeNotification({Name = "Oblivion", Content = "Welcome "..LocalPlayer.Name, Image = "rbxassetid://4431165334", Time = 5})