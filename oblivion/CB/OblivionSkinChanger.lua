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

writefile("oblivion/skin_changer/weapon_data.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/configs/weapon_info.cfg"))

-- Main
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local versions = loadstring("return "..readfile("oblivion/versions.cfg"))()

local Settings = {CurrentSkins = {}, data = {}, saveerror = false, weapon_data = table.foreach(loadstring("return "..readfile("oblivion/skin_changer/weapon_data.cfg"))(), function(i,v) if i == "guns" then return v end end), knife_data = table.foreach(loadstring("return "..readfile("oblivion/skin_changer/weapon_data.cfg"))(), function(i,v) if i == "knives" then return v end end), glove_data = table.foreach(loadstring("return "..readfile("oblivion/skin_changer/weapon_data.cfg"))(), function(i,v) if i == "gloves" then return v end end), OldInventory = {}, loops = {antiafkloop = nil}}
Settings.CurrentSkins["-"] = "-"

for i,v in pairs(Settings.weapon_data) do
	Settings.CurrentSkins[i] = "Stock"
end

local LocalPlayer = game:GetService('Players').LocalPlayer
local Client = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
Settings.OldInventory = Client.CurrentInventory

local IgnoredFlags = {"settings_branch", "settings_build", "skins_weapon", "skins_weapon_skin"}

OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Oblivion is loading.", Image = "rbxassetid://4400702947", Time = 3})

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
        writefile("oblivion/skin_changer/data.cfg", SaveTable(tempmaster))
    end
end

local function dropdownRefresh(flag, value, list)
    OrionLib.Flags[flag]:Refresh(list, true)
    OrionLib.Flags[flag]:Set(value)
end

local function getGunNameFromCheck(gun)
	local gun = table.foreach(Settings.weapon_data, function(i,v)
		if v.name == gun then
			return i
		end
	end)
	return gun
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

-- GUI
local SkinsTab = Window:MakeTab({Name = "Skins", Icon = "rbxassetid://4335483762", PremiumOnly = false})
local ViewmodelsTab = Window:MakeTab({Name = "Viewmodels", Icon = "rbxassetid://4483363084", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4384401360"})
local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://3605022185", PremiumOnly = false})

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
					spawn(function()
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
					end)
				end
                if OrionLib.Flags["viewmodels_bullet_impact_enable"].Value == true then
					spawn(function()
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
					end)
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
        end
	end
	
	return oldNamecall(self, unpack(args))
end))

-- Init
for _, Model in pairs(game:GetService("ReplicatedStorage").Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = Models
end

dropdownRefresh("skins_weapon", "-", getAllNames(Settings.weapon_data))
dropdownRefresh("skins_knife", "-", getAllNames(Settings.knife_data))
dropdownRefresh("skins_glove", "-", getAllNames(Settings.glove_data))
dropdownRefresh("settings_branch", versions["tables"][1], versions["tables"])

if isfile("oblivion/skin_changer/data.cfg") then
	OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Trying to load save.", Image = "rbxassetid://4384402413", Time = 5})
	local output
	local a,b = pcall(function()
		output = loadstring("return"..readfile("oblivion/skin_changer/data.cfg"))()
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
            OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Some values might be corrupted in the save.", Image = "rbxassetid://4384402990", Time = 5})
        elseif Settings.saveerror == false then
            OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Succesfully loaded save.", Image = "rbxassetid://4384403532", Time = 5})
        end
	elseif a == false then
		OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Error loading save.", Image = "rbxassetid://4384402990", Time = 10})
	end
end

OblivionRan.Value = true
OrionLib:Init()
OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Succesfully loaded.", Image = "rbxassetid://4400702457", Time = 5})
OrionLib:MakeNotification({Name = "Oblivion Skin Changer", Content = "Welcome "..LocalPlayer.Name..".", Image = "rbxassetid://4431165334", Time = 10})