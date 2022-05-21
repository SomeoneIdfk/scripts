--[[
Made by Pawel12d#0272
Customized by SomeoneIdfk
--]]

local Ping
local LastStep

local Hint = Instance.new("Hint", game.CoreGui)
Hint.Text = "Hexagon | Waiting for the game to load..."

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

Hint.Text = "Hexagon | Setting up environment..."

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Environment 
local getrawmetatable = getrawmetatable or false
local mousemove = mousemove or mousemoverel or mouse_move or false
local getsenv = getsenv or false
local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false
local hookfunc = hookfunc or hookfunction or replaceclosure or false


Hint.Text = "Hexagon | Setting up configuration settings..."

if not isfolder("hexagon") then
	print("creating hexagon folder")
	makefolder("hexagon")
end

writefile("hexagon/weapon_skins.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/weapon_skins_alpha.cfg"))

local weapon_skins = loadstring("return "..readfile("hexagon/weapon_skins.cfg"))()

if not isfolder("hexagon/configs") then
	print("creating hexagon configs folder")
	makefolder("hexagon/configs")
end

if not isfolder("hexagon/skinconfigs") then
	print("creating hexagon skinconfigs folder")
	makefolder("hexagon/skinconfigs")
end

if not isfile("hexagon/autoload.txt") then
	print("creating hexagon autoload file")
	writefile("hexagon/autoload.txt", "")
end

if not isfile("hexagon/custom_skins.txt") then
	print("downloading hexagon custom skins file")
	writefile("hexagon/custom_skins.txt", game:HttpGet("https://raw.githubusercontent.com/Pawel12d/hexagon/main/scripts/default_data/custom_skins.txt"))
end

if not isfile("hexagon/custom_models.txt") then
	print("downloading hexagon custom models file")
	writefile("hexagon/custom_models.txt", game:HttpGet("https://raw.githubusercontent.com/Pawel12d/hexagon/main/scripts/default_data/custom_models.txt"))
end

if not isfile("hexagon/inventories.txt") then
	print("downloading hexagon inventories file")
	writefile("hexagon/inventories.txt", game:HttpGet("https://raw.githubusercontent.com/Pawel12d/hexagon/main/scripts/default_data/inventories.txt"))
end

if not isfile("hexagon/skyboxes.txt") then
	print("downloading hexagon skyboxes file")
	writefile("hexagon/skyboxes.txt", game:HttpGet("https://raw.githubusercontent.com/Pawel12d/hexagon/main/scripts/default_data/skyboxes.txt"))
end

if isfile("hexagon/savedskins.cfg") then
	AllGunSkinsTable = loadstring("return "..readfile("hexagon/savedskins.cfg"))()
else
	AllGunSkinsTable = {}

	local temp = {}
	temp["-"] = "-"

	for i,v in pairs(weapon_skins["guns"]) do
		temp[i] = "Stock"
	end

	AllGunSkinsTable["-"] = temp
end

if isfile("hexagon/cheatingskids.cfg") then
	CheatingSkids = loadstring("return "..readfile("hexagon/cheatingskids.cfg"))()
else
	CheatingSkids = {}
end

Hint.Text = "Hexagon | Loading..."

-- Viewmodels fix
for i,v in pairs(game.ReplicatedStorage.Viewmodels:GetChildren()) do
    if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.Transparency ~= 1 then
        v.HumanoidRootPart.Transparency = 1
    end
end

game.ReplicatedStorage.Viewmodels["v_oldM4A1-S"].Silencer.Transparency = 1
local fix = game.ReplicatedStorage.Viewmodels["v_oldM4A1-S"].Silencer:Clone()
fix.Parent = game.ReplicatedStorage.Viewmodels["v_oldM4A1-S"]
fix.Name = "Silencer2"
fix.Transparency = 0

local Hitboxes = {
	["Head"] = {"Head"},
	["Chest"] = {"UpperTorso", "LowerTorso"},
	["Arms"] = {"LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand"},
	["Legs"] = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
}

local HexagonFolder = Instance.new("Folder", workspace)
HexagonFolder.Name = "HexagonFolder"

local oldOsPlatform = game.Players.LocalPlayer.OsPlatform
local oldMusicT = game.Players.LocalPlayer.PlayerGui.Music.ValveT:Clone()
local oldMusicCT = game.Players.LocalPlayer.PlayerGui.Music.ValveCT:Clone()

local Weapons = {}; for i,v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do if v:FindFirstChild("Model") then table.insert(Weapons, v.Name) end end

local Colliders = {
	"UpperTorso",
	"LowerTorso",
	"Head",
	"HumanoidRootPart"
}

local Sounds = {
	["TTT a"] = workspace.RoundEnd,
	["TTT b"] = workspace.RoundStart,
	["T Win"] = workspace.Sounds.T,
	["CT Win"] = workspace.Sounds.CT,
	["Planted"] = workspace.Sounds.Arm,
	["Defused"] = workspace.Sounds.Defuse,
	["Rescued"] = workspace.Sounds.Rescue,
	["Explosion"] = workspace.Sounds.Explosion,
	["Becky"] = workspace.Sounds.Becky,
	["Beep"] = workspace.Sounds.Beep
}
	
local FOVCircle = Drawing.new("Circle")
local Cases = {}; for i,v in pairs(game.ReplicatedStorage.Cases:GetChildren()) do table.insert(Cases, v.Name) end

local Configs = {}
local Inventories = loadstring("return "..readfile("hexagon/inventories.txt"))()
local Skyboxes = loadstring("return "..readfile("hexagon/skyboxes.txt"))()



-- Main
local SilentTable = {Teleporter1 = true, Teleporter2 = true, NoclipSwitch = true, Pause = false}
local SilentLegitbot = {target = nil}
local SilentRagebot = {target = nil, cooldown = false}
local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local cbClient = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
local oldInventory = cbClient.CurrentInventory
local nocw_s = {}
local nocw_m = {}
local curVel = 16
local isBhopping = false

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pawel12d/hexagon/main/scripts/ESP.lua"))()
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/lib/library_alpha.lua"))()

local Window = library:CreateWindow(Vector2.new(500, 500), Vector2.new((workspace.CurrentCamera.ViewportSize.X/2)-250, (workspace.CurrentCamera.ViewportSize.Y/2)-250))

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

local function checkId(mode)
	if mode == "team" and game.PlaceId == 301549746 or mode == "team" and game.PlaceId == 1480424328 then
		return true
	elseif mode == "ffa" and game.PlaceId == 1869597719 then
		return true
	end

	return false
end

local function checkGamemode()
	if game.PlaceId == 301549746 then
		return "casual"
	elseif game.PlaceId == 1480424328 then
		return "unranked"
	elseif game.PlaceId == 1869597719 then
		return "deathmatch"
	end

	return false
end

local function RandomString(length, strings)
	local strings = strings or {
		"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"0","1","2","3","4","5","6","7","8","9",
	}
	local output = ""
	for i = 1,length do
		output = tostring(output..""..strings[math.random(1,#strings)])
		if i == length then
			return output
		end
	end
end

local function IsAlive(plr)
	if plr and plr.Character and plr.Character.FindFirstChild(plr.Character, "Humanoid") and plr.Character.Humanoid.Health > 0 then
		return true
	end

	return false
end

local function IsVisible(pos, ignoreList)
	return #workspace.CurrentCamera:GetPartsObscuringTarget({LocalPlayer.Character.Head.Position, pos}, ignoreList) == 0 and true or false
end

local function GetTeam(plr)
	return game.Teams[plr.Team.Name]
end

local function GetTeamDif(plr)
	if plr:FindFirstChild("Status") and plr.Status:FindFirstChild("Team") then
		return plr.Status.Team.Value
	end

	return "Spectator"
end

local function GetSite()
	if (LocalPlayer.Character.HumanoidRootPart.Position - workspace.Map.SpawnPoints.C4Plant.Position).magnitude > (LocalPlayer.Character.HumanoidRootPart.Position - workspace.Map.SpawnPoints.C4Plant2.Position).magnitude then
		return "A"
	else
		return "B"
	end
end

local function CharacterAdded()
	wait(0.5)
	if IsAlive(LocalPlayer) then
		LocalPlayer.Character.Humanoid.StateChanged:Connect(function(state)
			if library.pointers.MiscellaneousTabCategoryBunnyHopEnabled.value == true then
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) == false then
					isBhopping = false
					curVel = library.pointers.MiscellaneousTabCategoryBunnyHopMinVelocity.value
				elseif state == Enum.HumanoidStateType.Landed and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				elseif state == Enum.HumanoidStateType.Jumping then
					isBhopping = true
					curVel = (curVel + library.pointers.MiscellaneousTabCategoryBunnyHopAcceleration.value) >= library.pointers.MiscellaneousTabCategoryBunnyHopMaxVelocity.value and library.pointers.MiscellaneousTabCategoryBunnyHopMaxVelocity.value or curVel + library.pointers.MiscellaneousTabCategoryBunnyHopAcceleration.value
				end
			end
		end)
	end
end

local function PlayerAdded()
	
end

local function PlantC4()
	pcall(function()
	if IsAlive(LocalPlayer) and workspace.Map.Gamemode.Value == "defusal" and workspace.Status.Preparation.Value == false and not planting then 
		SilentTable.Pause = true
		wait()
		planting = true
		local pos = LocalPlayer.Character.HumanoidRootPart.CFrame 
		workspace.CurrentCamera.CameraType = "Fixed"
		LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.SpawnPoints.C4Plant.CFrame
		wait(0.2)
		game.ReplicatedStorage.Events.PlantC4:FireServer((pos + Vector3.new(0, -2.75, 0)) * CFrame.Angles(math.rad(90), 0, math.rad(180)), GetSite())
		wait(0.2)
		LocalPlayer.Character.HumanoidRootPart.CFrame = pos
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		game.Workspace.CurrentCamera.CameraType = "Custom"
		planting = false
		SilentTable.Pause = false
	end
	end)
end

local function DefuseC4()
	pcall(function()
	if IsAlive(LocalPlayer) and workspace.Map.Gamemode.Value == "defusal" and not defusing and workspace:FindFirstChild("C4") then 
		SilentTable.Pause = true
		wait()
		defusing = true
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		local pos = LocalPlayer.Character.HumanoidRootPart.CFrame 
		workspace.CurrentCamera.CameraType = "Fixed"
		LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.C4.Handle.CFrame + Vector3.new(0, 2, 0)
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		wait(0.1)
		LocalPlayer.Backpack.PressDefuse:FireServer(workspace.C4)
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		wait(0.25)
		if IsAlive(LocalPlayer) and workspace:FindFirstChild("C4") and workspace.C4:FindFirstChild("Defusing") and workspace.C4.Defusing.Value == LocalPlayer then
			LocalPlayer.Backpack.Defuse:FireServer(workspace.C4)
		end
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		wait(0.2)
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		LocalPlayer.Character.HumanoidRootPart.CFrame = pos
		LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
		game.Workspace.CurrentCamera.CameraType = "Custom"
		defusing = false
		SilentTable.Pause = false
	end
	end)
end

function GetSpectators()
	local CurrentSpectators = {}
	
	for i,v in pairs(game:GetService("Players"):GetChildren()) do 
		if v ~= game:GetService("Players").LocalPlayer then
			if not v.Character and v:FindFirstChild("CameraCF") and (v.CameraCF.Value.Position - workspace.CurrentCamera.CFrame.p).Magnitude < 10 then 
				table.insert(CurrentSpectators, v)
			end
		end
	end
	
	return CurrentSpectators
end

local function GetLegitbotTarget()
	local target,oldval = nil,math.huge
	
	for i,v in pairs(game.Players:GetPlayers()) do
		if IsAlive(v) and v ~= LocalPlayer and not v.Character:FindFirstChild("ForceField") then
			if library.pointers.AimbotTabCategoryLegitbotTeamCheck.value == false or GetTeam(v) ~= GetTeam(LocalPlayer) then
				if library.pointers.AimbotTabCategoryLegitbotVisibilityCheck.value == false or IsVisible(v.Character.Head.Position, {v.Character, LocalPlayer.Character, HexagonFolder, workspace.CurrentCamera}) == true then
					local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
					local FOV = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
					
					if FOV < library.pointers.AimbotTabCategoryLegitbotFOV.value or library.pointers.AimbotTabCategoryLegitbotFOV.value == 0 then
						if math.floor((LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude) < library.pointers.AimbotTabCategoryLegitbotDistance.value or library.pointers.AimbotTabCategoryLegitbotDistance.value == 0 then
							if library.pointers.AimbotTabCategoryLegitbotTargetPriority.value == "FOV" then
								local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
								local FOV = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
									
								if FOV < oldval then
									target = v
									oldval = FOV
								end
							elseif library.pointers.AimbotTabCategoryLegitbotTargetPriority.value == "Distance" then
								local Distance = math.floor((v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude)
								
								if Distance < oldval then
									target = v
									oldval = Distance
								end
							end
						end
					end
				end
			end
		end
	end
	
	if target ~= nil then
		return target
	end
	
	return nil
end

local function GetLegitbotHitbox(plr)
	local target,oldval = nil,math.huge
	
	for i,v in pairs(library.pointers.AimbotTabCategoryLegitbotHitbox.value) do
		for i2,v2 in pairs(Hitboxes[v]) do
			targetpart = plr.Character:FindFirstChild(v2)
			
			if targetpart ~= nil then
				if library.pointers.AimbotTabCategoryLegitbotHitboxPriority.value == "FOV" then
					local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(targetpart.Position)
					local FOV = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
					
					if FOV < oldval then
						target = targetpart
						oldval = FOV
					end
				elseif library.pointers.AimbotTabCategoryLegitbotHitboxPriority.value == "Distance" then
					local Distance = math.floor((targetpart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude)
					
					if Distance < oldval then
						target = targetpart
						oldval = Distance
					end
				end
			end
		end
	end
	
	if target ~= nil then
		return target
	end
	
	return nil
end

local function GetHitbox(plr)
	if plr.Character:FindFirstChild("Head") then return plr.Character.Head elseif plr.Character:FindFirstChild("UpperTorso") then return plr.Character.UpperTorso end
end

local function TableToNames(tbl, alt)
	local otp = {}
	
	if alt then
		for i,v in pairs(tbl) do
			table.insert(otp, v.weaponname)
		end
	else
		for i,v in pairs(tbl) do
			table.insert(otp, i)
		end
	end
	
	return otp
end

local function AddCustomSkin(tbl) 
	if tbl and tbl.weaponname and tbl.skinname and tbl.model then
		local isGlove = false
		
		if table.find({"Strapped Glove", "Handwraps", "Sports Glove", "Fingerless Glove"}, tbl.weaponname) then
			isGlove = true
		end
		
		newfolder = Instance.new("Folder")
		newfolder.Name = tbl.skinname
		newfolder.Parent = (isGlove == true and game.ReplicatedStorage.Gloves) or (game.ReplicatedStorage.Skins[tbl.weaponname])
			
		if tbl.skinimage ~= nil then
			newvalue1 = Instance.new("StringValue")
			newvalue1.Name = tbl.skinname
			newvalue1.Value = tbl.skinimage
			newvalue1.Parent = LocalPlayer.PlayerGui.Client.Images[tbl.weaponname]
		end

		if tbl.skinrarity ~= nil then
			newvalue2 = Instance.new("StringValue")
			newvalue2.Name = "Quality"
			newvalue2.Value = tbl.skinrarity
			newvalue2.Parent = (isGlove == false and newvalue1) or nil
			
			newvalue3 = Instance.new("StringValue")
			newvalue3.Name = tostring(tbl.weaponname.."_"..tbl.skinname)
			newvalue3.Value = tbl.skinrarity
			newvalue3.Parent = LocalPlayer.PlayerGui.Client.Rarities
		end

		if isGlove == true then
			newtextures = Instance.new("SpecialMesh")
			newtextures.Name = "Textures"
			newtextures.MeshId = game.ReplicatedStorage.Gloves.Models[tbl.weaponname].RGlove.Mesh.MeshId
			newtextures.TextureId = tbl.model.Handle
			newtextures.Parent = newfolder
			
			newtype = Instance.new("StringValue")
			newtype.Name = "Type"
			newtype.Value = tbl.weaponname
			newtype.Parent = newfolder
		else
			for i,v in pairs(tbl.model) do
				if i == "Main" then
					for i2,v2 in pairs(game.ReplicatedStorage.Viewmodels["v_"..tbl.weaponname]:GetChildren()) do
						if v2:IsA("BasePart") and not table.find({"Right Arm", "Left Arm", "Flash"}, v2.Name) and v2.Transparency ~= 1 then
							newvalue = Instance.new("StringValue")
							newvalue.Name = v2.Name
							newvalue.Value = v
							newvalue.Parent = newfolder
						end
					end
				end
				
				newvalue = Instance.new("StringValue")
				newvalue.Name = i
				newvalue.Value = v
				newvalue.Parent = newfolder
			end
		end
		table.insert(nocw_s, {tostring(tbl.weaponname.."_"..tbl.skinname)})
			
		print("Custom skin: "..tostring(tbl.weaponname.."_"..tbl.skinname).." successfully injected!")
	end
end

local function AddCustomModel(tbl)
	if tbl and tbl.weaponname and tbl.modelname and tbl.model and game.ReplicatedStorage.Weapons:FindFirstChild(tbl.modelname) then
		if game.ReplicatedStorage.Viewmodels:FindFirstChild("v_"..tbl.modelname) then
			game.ReplicatedStorage.Viewmodels["v_"..tbl.modelname]:Destroy()
		end
		
		newmodel = tbl.model
		newmodel.Name = "v_"..tbl.modelname
		newmodel.Parent = game.ReplicatedStorage.Viewmodels
		
		table.insert(nocw_m, {tostring(tbl.modelname)})
	end
end

-- GUI
local AimbotTab = Window:CreateTab("Aimbot")

local AimbotTabCategoryLegitbot = AimbotTab:AddCategory("Legitbot", 1)

AimbotTabCategoryLegitbot:AddToggle("Enabled", false, "AimbotTabCategoryLegitbotEnabled", function(val)
	if val == true then
		LegitbotLoop = game:GetService("RunService").RenderStepped:Connect(function()
			if library.base.Window.Visible == false and IsAlive(LocalPlayer) then
				if library.pointers.AimbotTabCategoryLegitbotKeybind.value == nil or (library.pointers.AimbotTabCategoryLegitbotKeybind.value.EnumType == Enum.KeyCode and UserInputService:IsKeyDown(library.pointers.AimbotTabCategoryLegitbotKeybind.value)) or (library.pointers.AimbotTabCategoryLegitbotKeybind.value.EnumType == Enum.UserInputType and UserInputService:IsMouseButtonPressed(library.pointers.AimbotTabCategoryLegitbotKeybind.value)) then
					plr = GetLegitbotTarget()

					if plr ~= nil then
						hitboxpart = GetLegitbotHitbox(plr)
						
						if hitboxpart ~= nil then
							local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(hitboxpart.Position)

							local PositionX = Mouse.X-Vector.X
							local PositionY = Mouse.Y-Vector.Y
							
							if library.pointers.AimbotTabCategoryLegitbotSilent.value == true then
								SilentLegitbot.target = hitboxpart
								SilentLegitbot.aiming = true
							else
								mousemove(-PositionX, -PositionY)
								if SilentLegitbot.target ~= nil then SilentLegitbot.target = nil end
							end
						else
							if SilentLegitbot.target ~= nil then SilentLegitbot.target = nil end
						end
					else
						if SilentLegitbot.target ~= nil then SilentLegitbot.target = nil end
					end
				else
					if SilentLegitbot.target ~= nil then SilentLegitbot.target = nil end
				end
			else
				if SilentLegitbot.target ~= nil then SilentLegitbot.target = nil end
			end
		end)
	elseif val == false and LegitbotLoop then
		LegitbotLoop:Disconnect()
	end
end)

AimbotTabCategoryLegitbot:AddToggle("Silent", false, "AimbotTabCategoryLegitbotSilent")

AimbotTabCategoryLegitbot:AddToggle("Team Check", false, "AimbotTabCategoryLegitbotTeamCheck")

AimbotTabCategoryLegitbot:AddToggle("Visibility Check", false, "AimbotTabCategoryLegitbotVisibilityCheck")

AimbotTabCategoryLegitbot:AddKeybind("Keybind", nil, "AimbotTabCategoryLegitbotKeybind")

AimbotTabCategoryLegitbot:AddMultiDropdown("Hitbox", {"Head", "Chest", "Arms", "Legs"}, {"Head"}, "AimbotTabCategoryLegitbotHitbox")

AimbotTabCategoryLegitbot:AddDropdown("Hitbox Priority", {"FOV", "Distance"}, "FOV", "AimbotTabCategoryLegitbotHitboxPriority")

AimbotTabCategoryLegitbot:AddDropdown("Target Priority", {"FOV", "Distance"}, "FOV", "AimbotTabCategoryLegitbotTargetPriority")

AimbotTabCategoryLegitbot:AddSlider("Field of View", {0, 360, 0, 1, "°"}, "AimbotTabCategoryLegitbotFOV", function(val)
	FOVCircle.Radius = val
end)

AimbotTabCategoryLegitbot:AddSlider("Distance", {0, 2048, 0, 1, " studs"}, "AimbotTabCategoryLegitbotDistance")

AimbotTabCategoryLegitbot:AddSlider("Smoothness", {1, 30, 1, 1, ""}, "AimbotTabCategoryLegitbotSmoothness")

AimbotTabCategoryLegitbot:AddSlider("Hitchance", {0, 100, 100, 1, "%"}, "AimbotTabCategoryLegitbotHitchance")

local AimbotTabCategoryAntiAimbot = AimbotTab:AddCategory("Anti Aimbot", 2)

AimbotTabCategoryAntiAimbot:AddToggle("Enabled", false, "AimbotTabCategoryAntiAimbotEnabled", function(val)
	AntiAimbot = val
	
	while AntiAimbot do
		if IsAlive(LocalPlayer) and (library.pointers.AimbotTabCategoryAntiAimbotDisableWhileClimbing.value == false or cbClient.climbing == false) then
			function RotatePlayer(pos)
				local Gyro = Instance.new('BodyGyro')
				Gyro.D = 0
				Gyro.P = (library.pointers.AimbotTabCategoryAntiAimbotYawStrenght.value * 100)
				Gyro.MaxTorque = Vector3.new(0, (library.pointers.AimbotTabCategoryAntiAimbotYawStrenght.value * 100), 0)
				Gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso
				Gyro.CFrame = CFrame.new(Gyro.Parent.Position, pos.Position)
				wait()
				Gyro:Destroy()
			end
			
			if library.pointers.AimbotTabCategoryAntiAimbotRemoveHeadHitbox.value == true then
				if game.Players.LocalPlayer.Character:FindFirstChild("HeadHB") then
					game.Players.LocalPlayer.Character.HeadHB:Destroy()
				end
				if game.Players.LocalPlayer.Character:FindFirstChild("FakeHead") then
					game.Players.LocalPlayer.Character.FakeHead:Destroy()
				end
				if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character.Head.Transparency ~= 0 then
					game.Players.LocalPlayer.Character.Head.Transparency = 0
				end
			end
			
			if table.find({"Backward", "Left", "Right"}, library.pointers.AimbotTabCategoryAntiAimbotYaw.value) then
				game.Players.LocalPlayer.Character.Humanoid.AutoRotate = false
				local Angle = (
					library.pointers.AimbotTabCategoryAntiAimbotYaw.value == "Backward" and CFrame.new(-4, 0, 0) or
					library.pointers.AimbotTabCategoryAntiAimbotYaw.value == "Left" and CFrame.new(-180, 0, 0) or
					library.pointers.AimbotTabCategoryAntiAimbotYaw.value == "Right" and CFrame.new(180, 0, 0)
				)
				RotatePlayer(workspace.CurrentCamera.CFrame * Angle)
			elseif library.pointers.AimbotTabCategoryAntiAimbotYaw.value == "Spin" then
				game.Players.LocalPlayer.Character.Humanoid.AutoRotate = false
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(library.pointers.AimbotTabCategoryAntiAimbotYawStrenght.value), 0)
			elseif game.Players.LocalPlayer.Character.Humanoid.AutoRotate == false then
				game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
			end
		end

		wait(0.02)
	end
	
	if IsAlive(LocalPlayer) then
		game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
	end
end)

AimbotTabCategoryAntiAimbot:AddDropdown("Pitch", {"Default", "Up", "Down", "Boneless", "Random"}, "Default", "AimbotTabCategoryAntiAimbotPitch")

AimbotTabCategoryAntiAimbot:AddDropdown("Yaw", {"Default", "Forward", "Backward", "Left", "Right", "Spin"}, "Default", "AimbotTabCategoryAntiAimbotYaw")

AimbotTabCategoryAntiAimbot:AddSlider("Yaw Strenght", {0, 100, 50, 1, ""}, "AimbotTabCategoryAntiAimbotYawStrenght")

AimbotTabCategoryAntiAimbot:AddToggle("Remove Head Hitbox", false, "AimbotTabCategoryAntiAimbotRemoveHeadHitbox")

AimbotTabCategoryAntiAimbot:AddToggle("Disable While Climbing", false, "AimbotTabCategoryAntiAimbotDisableWhileClimbing")

AimbotTabCategoryAntiAimbot:AddKeybind("Manual Forward", nil, "AimbotTabCategoryAntiAimbotManualForward", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then library.pointers.AimbotTabCategoryAntiAimbotYaw:Set("Forward") end
end)

AimbotTabCategoryAntiAimbot:AddKeybind("Manual Left", nil, "AimbotTabCategoryAntiAimbotManualLeft", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then AimbotTabCategoryAntiAimbotYaw:Set("Left") end
end)

AimbotTabCategoryAntiAimbot:AddKeybind("Manual Right", nil, "AimbotTabCategoryAntiAimbotManualRight", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then library.pointers.AimbotTabCategoryAntiAimbotYaw:Set("Right") end
end)

AimbotTabCategoryAntiAimbot:AddKeybind("Manual Backward", nil, "AimbotTabCategoryAntiAimbotManualBackward", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then library.pointers.AimbotTabCategoryAntiAimbotYaw:Set("Backward") end
end)

AimbotTabCategoryAntiAimbot:AddKeybind("Manual Spin", nil, "AimbotTabCategoryAntiAimbotManualSpin", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then library.pointers.AimbotTabCategoryAntiAimbotYaw:Set("Spin") end
end)



local VisualsTab = Window:CreateTab("Visuals") 

local VisualsTabCategoryPlayers = VisualsTab:AddCategory("Players", 1)

VisualsTabCategoryPlayers:AddToggle("Enabled", false, "VisualsTabCategoryPlayersEnabled", function(val)
	ESP.Enabled = val
end)

VisualsTabCategoryPlayers:AddToggle("Info", false, "VisualsTabCategoryPlayersInfo", function(val)
	ESP.ShowInfo = val
end)

VisualsTabCategoryPlayers:AddToggle("Tracers", false, "VisualsTabCategoryPlayersTracers", function(val)
	ESP.Tracers = val
end)

VisualsTabCategoryPlayers:AddToggle("Boxes", false, "VisualsTabCategoryPlayersBoxes", function(val)
	ESP.Boxes = val
end)

VisualsTabCategoryPlayers:AddToggle("Show Team", false, "VisualsTabCategoryPlayersShowTeam", function(val)
	ESP.ShowTeam = val
end)

VisualsTabCategoryPlayers:AddToggle("Use Team Color", false, "VisualsTabCategoryPlayersUseTeamColor", function(val)
	ESP.UseTeamColor = val
end)

VisualsTabCategoryPlayers:AddMultiDropdown("Info Settings", {"Name", "Health", "Weapons", "Distance"}, {}, "VisualsTabCategoryPlayersInfoSettings", function(val)
	ESP.Info.Name = (table.find(val, "Name") and true) or false
	ESP.Info.Health = (table.find(val, "Health") and true) or false
	ESP.Info.Weapons = (table.find(val, "Weapons") and true) or false
	ESP.Info.Distance = (table.find(val, "Distance") and true) or false
end)

VisualsTabCategoryPlayers:AddColorPicker("Team Color", Color3.new(0,1,0), "VisualsTabCategoryPlayersTeamColor", function(val)
	ESP.TeamColor = val
end)

VisualsTabCategoryPlayers:AddColorPicker("Enemy Color", Color3.new(1,0,0), "VisualsTabCategoryPlayersEnemyColor", function(val)
	ESP.EnemyColor = val
end)

local VisualsTabCategoryDroppedESP = VisualsTab:AddCategory("Dropped ESP", 1)

VisualsTabCategoryDroppedESP:AddToggle("Enabled", false, "VisualsTabCategoryDroppedESPEnabled")

VisualsTabCategoryDroppedESP:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryDroppedESPColor")

VisualsTabCategoryDroppedESP:AddMultiDropdown("Info", {"Icon", "Text", "Ammo"}, {"Icon", "Text", "Ammo"}, "VisualsTabCategoryDroppedESPInfo")

local VisualsTabCategoryGrenadeESP = VisualsTab:AddCategory("Grenade ESP", 1)

VisualsTabCategoryGrenadeESP:AddToggle("Enabled", false, "VisualsTabCategoryGrenadeESPEnabled")

VisualsTabCategoryGrenadeESP:AddColorPicker("Color", Color3.new(1,0.5,0), "VisualsTabCategoryGrenadeESPColor")

VisualsTabCategoryGrenadeESP:AddMultiDropdown("Info", {"Icon", "Text"}, {"Icon", "Text"}, "VisualsTabCategoryGrenadeESPInfo")

local VisualsTabCategoryBombESP = VisualsTab:AddCategory("Bomb ESP", 1)

VisualsTabCategoryBombESP:AddToggle("Enabled", false, "VisualsTabCategoryBombESPEnabled")

VisualsTabCategoryBombESP:AddColorPicker("Color", Color3.new(1,0,0), "VisualsTabCategoryBombESPColor")

VisualsTabCategoryBombESP:AddMultiDropdown("Info", {"Icon", "Text", "Timer"}, {"Icon", "Text", "Timer"}, "VisualsTabCategoryBombESPInfo")

local VisualsTabCategoryOthers = VisualsTab:AddCategory("Others", 1)

VisualsTabCategoryOthers:AddMultiDropdown("Remove Effects", {"Scope", "Flash", "Smoke", "Bullet Holes", "Blood", "Ragdolls"}, {}, "VisualsTabCategoryOthersRemoveEffects", function(val)
	if table.find(val, "Scope") then
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.ImageTransparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Size = UDim2.new(2,0,2,0)
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Position = UDim2.new(-0.5,0,-0.5,0)
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.ImageTransparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.Blur.ImageTransparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame1.Transparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame2.Transparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame3.Transparency = 1
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame4.Transparency = 1
	else
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.ImageTransparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.ImageTransparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Size = UDim2.new(1,0,1,0)
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Position = UDim2.new(0,0,0,0)
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.ImageTransparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Scope.Blur.Blur.ImageTransparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame1.Transparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame2.Transparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame3.Transparency = 0
		LocalPlayer.PlayerGui.GUI.Crosshairs.Frame4.Transparency = 0
	end
	
	if table.find(val, "Flash") then
		LocalPlayer.PlayerGui.Blnd.Enabled = false
	else
		LocalPlayer.PlayerGui.Blnd.Enabled = true
	end
	
	if table.find(val, "Smoke") then
		for i,v in pairs(workspace.Ray_Ignore.Smokes:GetChildren()) do
			if v.Name == "Smoke" then
				v:Remove()
			end
		end
	end
	
	if table.find(val, "Bullet Holes") then
		for i,v in pairs(workspace.Debris:GetChildren()) do
			if v.Name == "Bullet" then
				v:Remove()
			end
		end
	end
	
	if table.find(val, "Blood") then
		for i,v in pairs(workspace.Debris:GetChildren()) do
			if v.Name == "SurfaceGui" then
				v:Remove()
			end
		end
	end
	
	if table.find(val, "Ragdolls") then
		-- Ragdolls are currently disabled in the game
	end
end)

VisualsTabCategoryOthers:AddColorPicker("Ambient", Color3.new(1,1,1), "VisualsTabCategoryOthersAmbient", function(val)
	workspace.CurrentCamera.ColorCorrection.TintColor = val
end)

VisualsTabCategoryOthers:AddDropdown("Skybox", TableToNames(Skyboxes), "Default", "VisualsTabCategoryOthersSkybox", function(val)
	if game.Lighting:FindFirstChild("HEXAGON_SKYBOX") then
		game.Lighting:FindFirstChild("HEXAGON_SKYBOX"):Destroy()
	end
	
	if val ~= "Default" and rawget(Skyboxes, val) then
		local NewSkybox = Instance.new("Sky", game.Lighting)
		NewSkybox.Name = "HEXAGON_SKYBOX"
		
		for i,v in pairs(rawget(Skyboxes, val)) do
			NewSkybox[i] = v
		end
	end
	
	pcall(function()
		library.pointers.VisualsTabCategoryOthersSkybox:Refresh(TableToNames(Skyboxes))
	end)
end)

VisualsTabCategoryOthers:AddToggle("Force Crosshair", false, "VisualsTabCategoryOthersForceCrosshair")

VisualsTabCategoryOthers:AddToggle("Old Music", false, "VisualsTabCategoryOthersOldMusic", function(val)
	if val == true then
		-- T
		LocalPlayer.PlayerGui.Music.ValveT.Lose.SoundId = "rbxassetid://168869486"
		LocalPlayer.PlayerGui.Music.ValveT.Win.SoundId = "rbxassetid://203383389"
		LocalPlayer.PlayerGui.Music.ValveT.StartRound["1"].SoundId = "rbxassetid://203383443"
		StartRound2 = LocalPlayer.PlayerGui.Music.ValveT.StartRound["1"]:Clone() StartRound2.Name = "2" StartRound2.SoundId = "rbxassetid://329924698" StartRound2.Parent = LocalPlayer.PlayerGui.Music.ValveT.StartRound
		StartRound3 = LocalPlayer.PlayerGui.Music.ValveT.StartRound["1"]:Clone() StartRound3.Name = "3" StartRound3.SoundId = "rbxassetid://329924746" StartRound3.Parent = LocalPlayer.PlayerGui.Music.ValveT.StartRound
		StartRound4 = LocalPlayer.PlayerGui.Music.ValveT.StartRound["1"]:Clone() StartRound4.Name = "4" StartRound4.SoundId = "rbxassetid://329924808" StartRound4.Parent = LocalPlayer.PlayerGui.Music.ValveT.StartRound
		LocalPlayer.PlayerGui.Music.ValveT.StartAction["1"].SoundId = "rbxassetid://203383519"
		StartAction2 = LocalPlayer.PlayerGui.Music.ValveT.StartAction["1"]:Clone() StartAction2.Name = "2" StartAction2.SoundId = "rbxassetid://329924647" StartAction2.Parent = LocalPlayer.PlayerGui.Music.ValveT.StartAction
		LocalPlayer.PlayerGui.Music.ValveT["10"].SoundId = "rbxassetid://340817948"
		LocalPlayer.PlayerGui.Music.ValveT["10"].Volume = 0.4
		LocalPlayer.PlayerGui.Music.ValveT.Bomb.SoundId = "rbxassetid://340817926"
		-- CT
		LocalPlayer.PlayerGui.Music.ValveCT.Lose.SoundId = "rbxassetid://168869486"
		LocalPlayer.PlayerGui.Music.ValveCT.Win.SoundId = "rbxassetid://203383389"
		LocalPlayer.PlayerGui.Music.ValveCT.StartRound["1"].SoundId = "rbxassetid://203383443"
		StartRound2 = LocalPlayer.PlayerGui.Music.ValveCT.StartRound["1"]:Clone() StartRound2.Name = "2" StartRound2.SoundId = "rbxassetid://329924698" StartRound2.Parent = LocalPlayer.PlayerGui.Music.ValveCT.StartRound
		StartRound3 = LocalPlayer.PlayerGui.Music.ValveCT.StartRound["1"]:Clone() StartRound3.Name = "3" StartRound3.SoundId = "rbxassetid://329924746" StartRound3.Parent = LocalPlayer.PlayerGui.Music.ValveCT.StartRound
		StartRound4 = LocalPlayer.PlayerGui.Music.ValveCT.StartRound["1"]:Clone() StartRound4.Name = "4" StartRound4.SoundId = "rbxassetid://329924808" StartRound4.Parent = LocalPlayer.PlayerGui.Music.ValveCT.StartRound
		LocalPlayer.PlayerGui.Music.ValveCT.StartAction["1"].SoundId = "rbxassetid://203383519"
		StartAction2 = LocalPlayer.PlayerGui.Music.ValveCT.StartAction["1"]:Clone() StartAction2.Name = "2" StartAction2.SoundId = "rbxassetid://329924647" StartAction2.Parent = LocalPlayer.PlayerGui.Music.ValveCT.StartAction
		LocalPlayer.PlayerGui.Music.ValveCT["10"].SoundId = "rbxassetid://340817891"
		LocalPlayer.PlayerGui.Music.ValveCT["10"].Volume = 0.4
		LocalPlayer.PlayerGui.Music.ValveCT.Bomb.SoundId = "rbxassetid://340817834"
	elseif val == false then
		LocalPlayer.PlayerGui.Music.ValveT:Destroy()
		LocalPlayer.PlayerGui.Music.ValveCT:Destroy()
		oldMusicT:Clone().Parent = LocalPlayer.PlayerGui.Music
		oldMusicCT:Clone().Parent = LocalPlayer.PlayerGui.Music
	end
end)

VisualsTabCategoryOthers:AddToggle("Bullet Tracers", false, "VisualsTabCategoryOthersBulletTracers")

VisualsTabCategoryOthers:AddColorPicker("Bullet Tracers Color", Color3.new(0,0.5,1), "VisualsTabCategoryOthersBulletTracersColor")

VisualsTabCategoryOthers:AddToggle("Bullet Impacts", false, "VisualsTabCategoryOthersBulletImpacts")

VisualsTabCategoryOthers:AddColorPicker("Bullet Impacts Color", Color3.new(1,0,0), "VisualsTabCategoryOthersBulletImpactsColor")

local VisualsTabCategoryViewmodelColors = VisualsTab:AddCategory("Viewmodel Colors", 2)

VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsEnabled")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Arms")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsArms")
VisualsTabCategoryViewmodelColors:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryViewmodelColorsArmsColor")
VisualsTabCategoryViewmodelColors:AddDropdown("Material", {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, "SmoothPlastic", "VisualsTabCategoryViewmodelColorsArmsMaterial")
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsArmsTransparency")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Gloves")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsGloves")
VisualsTabCategoryViewmodelColors:AddDropdown("Visible", {"Texture", "Color"}, "Texture", "VisualsTabCategoryViewmodelColorsGlovesVisible")
VisualsTabCategoryViewmodelColors:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryViewmodelColorsGlovesColor")
VisualsTabCategoryViewmodelColors:AddDropdown("Material", {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, "SmoothPlastic", "VisualsTabCategoryViewmodelColorsGlovesMaterial")
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsGlovesTransparency")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Sleeves")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsSleeves")
VisualsTabCategoryViewmodelColors:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryViewmodelColorsSleevesColor")
VisualsTabCategoryViewmodelColors:AddDropdown("Material", {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, "ForceField", "VisualsTabCategoryViewmodelColorsSleevesMaterial")
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsSleevesTransparency")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Weapons")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsWeapons")
VisualsTabCategoryViewmodelColors:AddDropdown("Visible", {"Texture", "Color"}, "Texture", "VisualsTabCategoryViewmodelColorsWeaponsVisible")
VisualsTabCategoryViewmodelColors:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryViewmodelColorsWeaponsColor")
VisualsTabCategoryViewmodelColors:AddDropdown("Material", {"SmoothPlastic", "Neon", "ForceField", "Wood", "Glass"}, "SmoothPlastic", "VisualsTabCategoryViewmodelColorsWeaponsMaterial")
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsWeaponsTransparency")

local VisualsTabCategoryFOVCircle = VisualsTab:AddCategory("FOV Circle", 2)

VisualsTabCategoryFOVCircle:AddToggle("Enabled", false, "VisualsTabCategoryFOVCircleEnabled", function(val)
	FOVCircle.Visible = val
end)

VisualsTabCategoryFOVCircle:AddToggle("Filled", false, "VisualsTabCategoryFOVCircleFilled", function(val)
	FOVCircle.Filled = val
end)

VisualsTabCategoryFOVCircle:AddSlider("Thickness", {1, 20, 1, 1, ""}, "VisualsTabCategoryFOVCircleThickness", function(val)
	FOVCircle.Thickness = val
end)

VisualsTabCategoryFOVCircle:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryFOVCircleTransparency", function(val)
	FOVCircle.Transparency = 1-val
end)

VisualsTabCategoryFOVCircle:AddSlider("NumSides", {0, 30, 0, 1, ""}, "VisualsTabCategoryFOVCircleNumSides", function(val)
	FOVCircle.NumSides = val >= 3 and val or 100
end)

VisualsTabCategoryFOVCircle:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryFOVCircleColor", function(val)
	FOVCircle.Color = val
end)

local VisualsTabCategoryViewmodel = VisualsTab:AddCategory("Viewmodel", 2)

VisualsTabCategoryViewmodel:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelEnabled", function(val)
	cbClient.fieldofview = (val == true and library.pointers.VisualsTabCategoryViewmodelFOV.value or 80)
	workspace.CurrentCamera.FieldOfView = (val == true and library.pointers.VisualsTabCategoryViewmodelFOV.value or 80)
end)

VisualsTabCategoryViewmodel:AddSlider("Field of View", {0, 120, 80, 1, "°"}, "VisualsTabCategoryViewmodelFOV", function(val)
	cbClient.fieldofview = (library.pointers.VisualsTabCategoryViewmodelEnabled.value == true and val or 80)
	workspace.CurrentCamera.FieldOfView = (library.pointers.VisualsTabCategoryViewmodelEnabled.value == true and val or 80)
end)

VisualsTabCategoryViewmodel:AddSlider("Viewmodel Offset X", {0, 360, 180, 1, "°"}, "VisualsTabCategoryViewmodelOffsetX")

VisualsTabCategoryViewmodel:AddSlider("Viewmodel Offset Y", {0, 360, 180, 1, "°"}, "VisualsTabCategoryViewmodelOffsetY")

VisualsTabCategoryViewmodel:AddSlider("Viewmodel Offset Z", {0, 360, 180, 1, "°"}, "VisualsTabCategoryViewmodelOffsetZ")

VisualsTabCategoryViewmodel:AddSlider("Viewmodel Offset Roll", {0, 360, 180, 1, "°"}, "VisualsTabCategoryViewmodelOffsetRoll")

VisualsTabCategoryViewmodel:AddButton("Reset", function()
    library.pointers.VisualsTabCategoryViewmodelEnabled:Set(false)
	library.pointers.VisualsTabCategoryViewmodelFOV:Set(80)
	library.pointers.VisualsTabCategoryViewmodelOffsetX:Set(180)
	library.pointers.VisualsTabCategoryViewmodelOffsetY:Set(180)
	library.pointers.VisualsTabCategoryViewmodelOffsetZ:Set(180)
	library.pointers.VisualsTabCategoryViewmodelOffsetRoll:Set(180)
end)

local VisualsTabCategoryThirdPerson = VisualsTab:AddCategory("Third Person", 2)

VisualsTabCategoryThirdPerson:AddToggle("Enabled", false, "VisualsTabCategoryThirdPersonEnabled", function(val)
	if val == true then
		game:GetService("RunService"):BindToRenderStep("ThirdPerson", 100, function()
			if LocalPlayer.CameraMinZoomDistance ~= library.pointers.VisualsTabCategoryThirdPersonDistance.value then
				LocalPlayer.CameraMinZoomDistance = library.pointers.VisualsTabCategoryThirdPersonDistance.value
				LocalPlayer.CameraMaxZoomDistance = library.pointers.VisualsTabCategoryThirdPersonDistance.value
				workspace.ThirdPerson.Value = true
			end
		end)
	else
		game:GetService("RunService"):UnbindFromRenderStep("ThirdPerson")
		if IsAlive(LocalPlayer) then
			wait()
			workspace.ThirdPerson.Value = false
			LocalPlayer.CameraMinZoomDistance = 0
			LocalPlayer.CameraMaxZoomDistance = 0
		end
	end
end)

VisualsTabCategoryThirdPerson:AddKeybind("Keybind", nil, "VisualsTabCategoryThirdPersonKeybind", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then
		library.pointers.VisualsTabCategoryThirdPersonEnabled:Set(not library.pointers.VisualsTabCategoryThirdPersonEnabled.value)
	end
end)

VisualsTabCategoryThirdPerson:AddSlider("Distance", {0, 50, 10, 1, ""}, "VisualsTabCategoryThirdPersonDistance")


local MiscellaneousTab = Window:CreateTab("Miscellaneous")

local MiscellaneousTabCategoryMain = MiscellaneousTab:AddCategory("Main", 1)

MiscellaneousTabCategoryMain:AddDropdown("Waypoints Teleport", {"Spawn T", "Spawn CT", "Bombsite A", "Bombsite B"}, "-", "MiscellaneousTabCategoryMainWaypointsTeleport", function(val)
	if val == "Spawn T" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["BuyArea"].Position + Vector3.new(0, 3, 0))
		library.pointers.MiscellaneousTabCategoryMainWaypointsTeleport:Set("-")
	elseif val == "Spawn CT" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["BuyArea2"].Position + Vector3.new(0, 3, 0))
		library.pointers.MiscellaneousTabCategoryMainWaypointsTeleport:Set("-")
	elseif val == "Bombsite A" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
		library.pointers.MiscellaneousTabCategoryMainWaypointsTeleport:Set("-")
	elseif val == "Bombsite B" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
		library.pointers.MiscellaneousTabCategoryMainWaypointsTeleport:Set("-")
	end
end)

MiscellaneousTabCategoryMain:AddDropdown("Places Teleport", {"Casual", "Competitive", "Deathmatch", "Trading"}, "-", "MiscellaneousTabCategoryMainPlacesTeleport", function(val)
	if val == "Casual" then
		game:GetService("TeleportService"):Teleport(301549746, LocalPlayer)
		library.pointers.MiscellaneousTabCategoryMainPlacesTeleport:Set("-")
	elseif val == "Competitive" then
		game:GetService("TeleportService"):Teleport(1480424328, LocalPlayer)
		library.pointers.MiscellaneousTabCategoryMainPlacesTeleport:Set("-")
	elseif val == "Deathmatch" then
		game:GetService("TeleportService"):Teleport(1869597719, LocalPlayer)
		library.pointers.MiscellaneousTabCategoryMainPlacesTeleport:Set("-")
	elseif val == "Trading" then
		game:GetService("TeleportService"):Teleport(5325113759, LocalPlayer)
		library.pointers.MiscellaneousTabCategoryMainPlacesTeleport:Set("-")
	end
end)

MiscellaneousTabCategoryMain:AddDropdown("Barriers", {"Normal", "Visible", "Remove"}, "-", "MiscellaneousTabCategoryMainBarriers", function(val)
	pcall(function()
	if val ~= "-" then
		local Clips = workspace.Map.Clips; Clips.Name = "FAT"; Clips.Parent = nil
		local Killers = workspace.Map.Killers; Killers.Name = "FAT"; Killers.Parent = nil

		if val == "Normal" then	
			for i,v in pairs(Clips:GetChildren()) do
				if v:IsA("BasePart") then
					v.Transparency = 1
					v.CanCollide = true
				end
			end
			for i,v in pairs(Killers:GetChildren()) do
				if v:IsA("BasePart") then
					v.Transparency = 1
					v.CanCollide = true
				end
			end
		elseif val == "Visible" then
			for i,v in pairs(Clips:GetChildren()) do
				if v:IsA("BasePart") then
					v.Transparency = 0.9
					v.Material = "Neon"
					v.Color = Color3.fromRGB(255, 0, 255)
				end
			end
			for i,v in pairs(Killers:GetChildren()) do
				if v:IsA("BasePart") then
					v.Transparency = 0.9
					v.Material = "Neon"
					v.Color = Color3.fromRGB(255, 0, 0)
				end
			end
		elseif val == "Remove" then
			for i,v in pairs(Clips:GetChildren()) do
				if v:IsA("BasePart") then
					v:Remove()
				end
			end
			for i,v in pairs(Killers:GetChildren()) do
				if v:IsA("BasePart") then
					v:Remove()
				end
			end
		end

		Killers.Name = "Killers"; Killers.Parent = workspace.Map
		Clips.Name = "Clips"; Clips.Parent = workspace.Map
		
		library.pointers.MiscellaneousTabCategoryMainBarriers:Set("-")
	end
	end)
end)

MiscellaneousTabCategoryMain:AddDropdown("Spawn Item", Weapons, "-", "MiscellaneousTabCategoryMainSpawnItem", function(val)
	if game.ReplicatedStorage.Weapons:FindFirstChild(val) then
		game.ReplicatedStorage.Events.Drop:FireServer(
			game.ReplicatedStorage.Weapons[val],
			LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4),
			game.ReplicatedStorage.Weapons[val].Ammo.Value,
			game.ReplicatedStorage.Weapons[val].StoredAmmo.Value,
			false,
			LocalPlayer,
			false,
			false
		)
		library.pointers.MiscellaneousTabCategoryMainSpawnItem:Set("-")
	end
end)

MiscellaneousTabCategoryMain:AddDropdown("Play Sound", TableToNames(Sounds), "-", "MiscellaneousTabCategoryMainPlaySound", function(val)
	if Sounds[val] ~= nil and Sounds[val]:IsA("Sound") then
		Sounds[val]:Play()
		library.pointers.MiscellaneousTabCategoryMainPlaySound:Set("-")
	end
end)

MiscellaneousTabCategoryMain:AddDropdown("Open Case", Cases, "-", "MiscellaneousTabCategoryMainOpenCase", function(val)
	if game.ReplicatedStorage.Cases:FindFirstChild(val) then
		for i=1,library.pointers.MiscellaneousTabCategoryMainOpenCaseAmount.value do
			game.ReplicatedStorage.Events.DataEvent:FireServer({"BuyCase", val})
		end
		library.pointers.MiscellaneousTabCategoryMainOpenCase:Set("-")
	end
end)

MiscellaneousTabCategoryMain:AddSlider("Open Case Amount", {1, 100, 1, 1, ""}, "MiscellaneousTabCategoryMainOpenCaseAmount")

local a,b = pcall(function()
	MiscellaneousTabCategoryMain:AddMultiDropdown("Custom Models", TableToNames(loadstring("return "..readfile("hexagon/custom_models.txt"))(), true), {}, "MiscellaneousTabCategoryMainCustomModels", function(val)
		if not ViewmodelsBackup then
			ViewmodelsBackup = game.ReplicatedStorage.Viewmodels:Clone()
		end
		
		game.ReplicatedStorage.Viewmodels:Destroy()
		
		ViewmodelsBackup:Clone().Parent = game.ReplicatedStorage
		
		for i,v in pairs(loadstring("return "..readfile("hexagon/custom_models.txt"))()) do
			if table.find(val, v.weaponname) then
				AddCustomModel(v)
			end
		end
	end)
end)

if not a then
	print(a, b)
	game.Players.LocalPlayer:Kick("Hexagon | Your custom models file is fucked up lol! "..b)
end

MiscellaneousTabCategoryMain:AddDropdown("Inventory Changer", TableToNames(Inventories), "-", "MiscellaneousTabCategoryMainInventoryChanger", function(val)
	local InventoryLoadout = LocalPlayer.PlayerGui.GUI["Inventory&Loadout"]
	local InventoriesData = loadstring("return "..readfile("hexagon/inventories.txt"))()
	
	if typeof(InventoriesData[val]) == "table" then
		cbClient.CurrentInventory = InventoriesData[val]
	elseif typeof(InventoriesData[val]) == "string" then
		if InventoriesData[val] == "table_def" then
			cbClient.CurrentInventory = oldInventory
		elseif InventoriesData[val] == "table_cus" then
			cbClient.CurrentInventory = nocw_s
		elseif InventoriesData[val] == "table_all" then
			AllSkinsTable = {}

			for i,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
				if v:IsA("Folder") and game.ReplicatedStorage.Weapons:FindFirstChild(v.Name) then
					table.insert(AllSkinsTable, {v.Name.."_Stock"})
					
					for i2,v2 in pairs(v:GetChildren()) do
						if v2.Name ~= "Stock" then
							table.insert(AllSkinsTable, {v.Name.."_"..v2.Name})
						end
					end
				end
			end
			
			for i,v in pairs(game.ReplicatedStorage.Gloves:GetChildren()) do
				if v:IsA("Folder") and v.Name ~= "Models" then
					for i2,v2 in pairs(v:GetChildren()) do
						table.insert(AllSkinsTable, {v.Name.."_"..v2.Name})
					end
				end
			end
			
			cbClient.CurrentInventory = AllSkinsTable
		end
	end
	
	if InventoryLoadout.Visible == true then
		InventoryLoadout.Visible = false
		InventoryLoadout.Visible = true
	end
	
	pcall(function()
		library.pointers.MiscellaneousTabCategoryMainInventoryChanger:Refresh(TableToNames(Inventories))
	end)
end)

MiscellaneousTabCategoryMain:AddButton("Inject Custom Skins", function()
	if #nocw_s == 0 then
		for i,v in pairs(loadstring("return "..readfile("hexagon/custom_skins.txt"))()) do
			AddCustomSkin(v)
			game:GetService("RunService").Stepped:Wait()
		end
	end
end)

MiscellaneousTabCategoryMain:AddButton("Crash Server", function()
	if LocalPlayer.Character then
		game:GetService("RunService").RenderStepped:Connect(function()
			game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(game:GetService("ReplicatedStorage").Weapons["Molotov"].Model, nil, 25, 35, Vector3.new(0,-100,0), nil, nil)
			game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(game:GetService("ReplicatedStorage").Weapons["HE Grenade"].Model, nil, 25, 35, Vector3.new(0,-100,0), nil, nil)
			game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(game:GetService("ReplicatedStorage").Weapons["Decoy Grenade"].Model, nil, 25, 35, Vector3.new(0,-100,0), nil, nil)
			game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(game:GetService("ReplicatedStorage").Weapons["Smoke Grenade"].Model, nil, 25, 35, Vector3.new(0,-100,0), nil, nil)
			game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(game:GetService("ReplicatedStorage").Weapons["Flashbang"].Model, nil, 25, 35, Vector3.new(0,-100,0), nil, nil)
		end)
	end
end)

MiscellaneousTabCategoryMain:AddButton("Inf HP", function() pcall(function()
	game.ReplicatedStorage.Events.FallDamage:FireServer(0/0)
	LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		LocalPlayer.Character.Humanoid.Health = 100
	end)
end) end)

MiscellaneousTabCategoryMain:AddButton("FE God", function() pcall(function()
	LocalPlayer.Character.Humanoid.Parent = nil
	Instance.new("Humanoid", LocalPlayer.Character)
end) end)

MiscellaneousTabCategoryMain:AddButton("Invisibility [dont defuse]", function() pcall(function()
	local oldpos = LocalPlayer.Character.HumanoidRootPart.CFrame
	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999,9999,9999)
	local NewRoot = LocalPlayer.Character.LowerTorso.Root:Clone()
	LocalPlayer.Character.LowerTorso.Root:Destroy()
	NewRoot.Parent = LocalPlayer.Character.LowerTorso
	wait()
	LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
end) end)

MiscellaneousTabCategoryMain:AddButton("Vote Kick Yourself", function()
	game.ReplicatedStorage.Events.Vote:FireServer(game.Players.LocalPlayer.Name)
end)

MiscellaneousTabCategoryMain:AddToggle("Anti Vote Kick", false, "MiscellaneousTabCategoryMainAntiVoteKick")

MiscellaneousTabCategoryMain:AddToggle("Anti Spectators", false, "MiscellaneousTabCategoryMainAntiSpectators")

MiscellaneousTabCategoryMain:AddToggle("Unlock Reset Character", false, "MiscellaneousTabCategoryMainUnlockResetCharacter", function(val)
	pcall(function()
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", val)
	end)
end)

MiscellaneousTabCategoryMain:AddToggle("Unlock Shop While Alive", false, "MiscellaneousTabCategoryMainUnlockShopWhileAlive")

MiscellaneousTabCategoryMain:AddToggle("Show Spectators", false, "MiscellaneousTabCategoryMainShowSpectators", function(val)
	ShowSpectators = val
	
	library.base.Spectators.Visible = val
	
	while ShowSpectators do
		for i,v in pairs(library.base.Spectators.SpectatorsFrame:GetChildren()) do
			if v:IsA("TextLabel") then
				v:Destroy()
			end
		end
		
		for i,v in pairs(GetSpectators()) do
			local SpectatorLabel = Instance.new("TextLabel")
			SpectatorLabel.BackgroundTransparency = 1
			SpectatorLabel.Size = UDim2.new(1, 0, 0, 18)
			SpectatorLabel.Text = v.Name
			SpectatorLabel.TextColor3 = Color3.new(1, 1, 1)
			SpectatorLabel.Parent = library.base.Spectators.SpectatorsFrame
		end
		
		wait(0.25)
	end
end)

MiscellaneousTabCategoryMain:AddToggle("Inf Jump", false, "MiscellaneousTabCategoryMainInfJump", function(val)
	if val == true then
		JumpHook = game:GetService("UserInputService").JumpRequest:connect(function()
			game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") 
		end)
	elseif val == false and JumpHook then
		JumpHook:Disconnect()
	end
end)

MiscellaneousTabCategoryMain:AddToggle("Inf Cash", false, "MiscellaneousTabCategoryMainInfCash", function(val)
	if val == true then
		LocalPlayer.Cash.Value = 16000
		CashHook = LocalPlayer.Cash:GetPropertyChangedSignal("Value"):connect(function()
			LocalPlayer.Cash.Value = 16000
		end)
	elseif val == false and CashHook then
		CashHook:Disconnect()
	end
end)

MiscellaneousTabCategoryMain:AddToggle("Inf Stamina", false, "MiscellaneousTabCategoryMainInfStamina", function(val)
	if val == true then
		game:GetService("RunService"):BindToRenderStep("Stamina", 100, function()
			if cbClient.crouchcooldown ~= 0 then
				cbClient.crouchcooldown = 0
			end
		end)
	elseif val == false then
		game:GetService("RunService"):UnbindFromRenderStep("Stamina")
	end
end)

MiscellaneousTabCategoryMain:AddToggle("NNS Dont Talk", false, "MiscellaneousTabCategoryMainNNSDontTalk")

MiscellaneousTabCategoryMain:AddToggle("No Chat Filter", false, "MiscellaneousTabCategoryMainNoChatFilter")

MiscellaneousTabCategoryMain:AddToggle("No Fall Damage", false, "MiscellaneousTabCategoryMainNoFallDamage")

MiscellaneousTabCategoryMain:AddToggle("No Fire Damage", false, "MiscellaneousTabCategoryMainNoFireDamage")

MiscellaneousTabCategoryMain:AddTextBox("Hit Sound", "", "MiscellaneousTabCategoryMainHitSound")

MiscellaneousTabCategoryMain:AddTextBox("Kill Sound", "", "MiscellaneousTabCategoryMainKillSound")

local MiscellaneousTabCategoryNoclip = MiscellaneousTab:AddCategory("Noclip", 1)

MiscellaneousTabCategoryNoclip:AddToggle("Enabled", false, "MiscellaneousTabCategoryNoclipEnabled", function(val)
	if val == true then
		FlyLoop = game:GetService("RunService").Stepped:Connect(function()
			if IsAlive(LocalPlayer) then
				spawn(function()
					pcall(function()
						local speed = library.pointers.MiscellaneousTabCategoryNoclipSpeed.value
						local velocity = Vector3.new(0, 1, 0)
						
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then
							velocity = velocity + (workspace.CurrentCamera.CoordinateFrame.lookVector * speed)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then
							velocity = velocity + (workspace.CurrentCamera.CoordinateFrame.rightVector * -speed)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then
							velocity = velocity + (workspace.CurrentCamera.CoordinateFrame.lookVector * -speed)
						end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then
							velocity = velocity + (workspace.CurrentCamera.CoordinateFrame.rightVector * speed)
						end
						
						LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
						LocalPlayer.Character.Humanoid.PlatformStand = true
					end)
				end)
			end
		end)
		
		NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if v:IsA("BasePart") and v.CanCollide == true then
					v.CanCollide = false
				end
			end
		end)
	elseif val == false and FlyLoop and NoclipLoop then
		pcall(function()
			FlyLoop:Disconnect()
			NoclipLoop:Disconnect()
			LocalPlayer.Character.Humanoid.PlatformStand = false
		end)
	end
end)

MiscellaneousTabCategoryNoclip:AddKeybind("Keybind", nil, "MiscellaneousTabCategoryNoclipKeybind", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then
		library.pointers.MiscellaneousTabCategoryNoclipEnabled:Set(not library.pointers.MiscellaneousTabCategoryNoclipEnabled.value)
	end
end)

MiscellaneousTabCategoryNoclip:AddSlider("Speed", {0, 1000, 16, 1, ""}, "MiscellaneousTabCategoryNoclipSpeed")

local MiscellaneousTabCategoryGunMods = MiscellaneousTab:AddCategory("Gun Mods", 2)

MiscellaneousTabCategoryGunMods:AddSlider("Damage Multiplier", {0, 100, 1, 0.01, "x"}, "MiscellaneousTabCategoryGunModsDamageMultiplier")

MiscellaneousTabCategoryGunMods:AddToggle("Wallbang", false, "MiscellaneousTabCategoryGunModsWallbang")

MiscellaneousTabCategoryGunMods:AddToggle("No Recoil", false, "MiscellaneousTabCategoryGunModsNoRecoil", function(val)
	if val == true then
		game:GetService("RunService"):BindToRenderStep("NoRecoil", 100, function()
			cbClient.resetaccuracy()
			cbClient.RecoilX = 0
			cbClient.RecoilY = 0
		end)
	elseif val == false then
		game:GetService("RunService"):UnbindFromRenderStep("NoRecoil")
	end
end)

MiscellaneousTabCategoryGunMods:AddToggle("No Spread", false, "MiscellaneousTabCategoryGunModsNoSpread")

MiscellaneousTabCategoryGunMods:AddToggle("Rapid Fire", false, "MiscellaneousTabCategoryGunModsRapidFire")

MiscellaneousTabCategoryGunMods:AddToggle("Full Auto", false, "MiscellaneousTabCategoryGunModsFullAuto")

MiscellaneousTabCategoryGunMods:AddToggle("Instant Reload", false, "MiscellaneousTabCategoryGunModsInstantReload")

MiscellaneousTabCategoryGunMods:AddToggle("Instant Equip", false, "MiscellaneousTabCategoryGunModsInstantEquip")

MiscellaneousTabCategoryGunMods:AddToggle("Infinite Ammo", false, "MiscellaneousTabCategoryGunModsInfiniteAmmo")

MiscellaneousTabCategoryGunMods:AddToggle("Infinite Range", false, "MiscellaneousTabCategoryGunModsInfiniteRange")

MiscellaneousTabCategoryGunMods:AddToggle("Infinite Penetration", false, "MiscellaneousTabCategoryGunModsInfinitePenetration")

-- MiscellaneousTabCategoryGunMods:AddSlider("Recoil", {0, 100, 100, 1, "%"}, "MiscellaneousTabCategoryGunModsRecoil")

MiscellaneousTabCategoryGunMods:AddDropdown("Plant", {"Normal", "Instant", "Anywhere"}, "Normal", "MiscellaneousTabCategoryGunModsPlant")

MiscellaneousTabCategoryGunMods:AddDropdown("Defuse", {"Normal", "Instant", "Anywhere"}, "Normal", "MiscellaneousTabCategoryGunModsDefuse")

MiscellaneousTabCategoryGunMods:AddButton("Plant C4", PlantC4)

MiscellaneousTabCategoryGunMods:AddButton("Defuse C4", DefuseC4)

local MiscellaneousTabCategoryBunnyHop = MiscellaneousTab:AddCategory("Bunny Hop", 2)

MiscellaneousTabCategoryBunnyHop:AddToggle("Enabled", false, "MiscellaneousTabCategoryBunnyHopEnabled")

MiscellaneousTabCategoryBunnyHop:AddSlider("Acceleration", {0, 100, 3, 1, ""}, "MiscellaneousTabCategoryBunnyHopAcceleration")

MiscellaneousTabCategoryBunnyHop:AddSlider("Minimum Velocity", {0, 100, 16, 1, ""}, "MiscellaneousTabCategoryBunnyHopMinVelocity")

MiscellaneousTabCategoryBunnyHop:AddSlider("Maximum Velocity", {0, 100, 40, 1, ""}, "MiscellaneousTabCategoryBunnyHopMaxVelocity")

local MiscellaneousTabCategoryBacktrack = MiscellaneousTab:AddCategory("Backtrack", 2)

MiscellaneousTabCategoryBacktrack:AddToggle("Enabled", false, "MiscellaneousTabCategoryBacktrackEnabled", function(val)
	if val == true then
		Backtracking = RunService.RenderStepped:Connect(function()
			if IsAlive(LocalPlayer) then
				for i,v in pairs(game.Players:GetPlayers()) do
					if IsAlive(v) and GetTeam(v) ~= GetTeam(LocalPlayer) and GetTeam(v) ~= "TTT" then
						local NewBacktrackPart = Instance.new("Part")
						NewBacktrackPart.Name = v.Name
						NewBacktrackPart.Anchored = true
						NewBacktrackPart.CanCollide = false
						NewBacktrackPart.Transparency = library.pointers.MiscellaneousTabCategoryBacktrackTransparency.value
						NewBacktrackPart.Color = library.pointers.MiscellaneousTabCategoryBacktrackColor.value
						NewBacktrackPart.Size = v.Character.Head.Size
						NewBacktrackPart.CFrame = v.Character.Head.CFrame
						NewBacktrackPart.Parent = HexagonFolder
						
						local BacktrackTag = Instance.new("ObjectValue")
						BacktrackTag.Parent = NewBacktrackPart
						BacktrackTag.Name = "PlayerName"
						BacktrackTag.Value = v
						
						spawn(function()
							wait(library.pointers.MiscellaneousTabCategoryBacktrackTime.value/1000)
							NewBacktrackPart:Destroy()
						end)
					end
				end
			end
		end)
	elseif val == false and Backtracking then
		Backtracking:Disconnect()
	end
end)

MiscellaneousTabCategoryBacktrack:AddSlider("Time", {0, 1000, 200, 1, "ms"}, "MiscellaneousTabCategoryBacktrackTime")

MiscellaneousTabCategoryBacktrack:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "MiscellaneousTabCategoryBacktrackTransparency")

MiscellaneousTabCategoryBacktrack:AddColorPicker("Color", Color3.new(1,1,1), "MiscellaneousTabCategoryBacktrackColor")

local MiscellaneousTabCategoryGrenade = MiscellaneousTab:AddCategory("Grenade", 2)

MiscellaneousTabCategoryGrenade:AddKeybind("Keybind", nil, "MiscellaneousTabCategoryGrenadeKeybind", function(val)
	if val == true and UserInputService:GetFocusedTextBox() == nil then
		game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(
			game.ReplicatedStorage.Weapons[library.pointers.MiscellaneousTabCategoryGrenadeType.value].Model,
			nil,
			25,
			35,
			workspace.CurrentCamera.CFrame.lookVector * (5 * library.pointers.MiscellaneousTabCategoryGrenadeVelocity.value),
			nil,
			nil
		)
	end
end)

MiscellaneousTabCategoryGrenade:AddSlider("Velocity", {0, 100, 10, 1, ""}, "MiscellaneousTabCategoryGrenadeVelocity")

MiscellaneousTabCategoryGrenade:AddDropdown("Type", {"Molotov","HE Grenade","Decoy Grenade","Smoke Grenade","Incendiary Grenade","Flashbang"}, "Molotov", "MiscellaneousTabCategoryGrenadeType")

local MiscellaneousTabCategoryChatSpam = MiscellaneousTab:AddCategory("Chat Spam", 2)

MiscellaneousTabCategoryChatSpam:AddToggle("Enabled", false, "MiscellaneousTabCategoryChatSpamEnabled", function(val)
	ChatSpam = val
	
	while ChatSpam do
		game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
			library.pointers.MiscellaneousTabCategoryChatSpamMessage.value,
			false,
			"Innocent",
			false,
			true
		)
		wait(3)
	end
end)

MiscellaneousTabCategoryChatSpam:AddTextBox("Message", "Hexagon is the best!", "MiscellaneousTabCategoryChatSpamMessage")

local MiscellaneousTabCategoryKeybinds = MiscellaneousTab:AddCategory("Keybinds", 2)

MiscellaneousTabCategoryKeybinds:AddKeybind("Airstuck", nil, "MiscellaneousTabCategoryKeybindsAirStuck", function(val)
	if IsAlive(LocalPlayer) and UserInputService:GetFocusedTextBox() == nil then
		for i,v in pairs(LocalPlayer.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.Anchored = val
			end
		end
	end
end)

MiscellaneousTabCategoryKeybinds:AddKeybind("Edge Jump", nil, "MiscellaneousTabCategoryKeybindsEdgeJump", function(val)
	if val == true then
		if IsAlive(LocalPlayer) and UserInputService:GetFocusedTextBox() == nil and game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Running then
			EdgeJump = true
			repeat
				wait()
				if game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
					game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
				end
			until not IsAlive(LocalPlayer) or EdgeJump == false or game.Players.LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall
			EdgeJump = false
		end
	elseif val == false and EdgeJump == true then
		EdgeJump = false
	end
end)

MiscellaneousTabCategoryKeybinds:AddKeybind("Jump Bug", nil, "MiscellaneousTabCategoryKeybindsJumpBug", function(val)
	JumpBug = val
end)

MiscellaneousTabCategoryKeybinds:AddKeybind("Teleport", nil, "MiscellaneousTabCategoryKeybindsTeleport", function(val)
	if val == true and IsAlive(LocalPlayer) and UserInputService:GetFocusedTextBox() == nil and Mouse.Target ~= nil then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 2.5, 0))
	end
end)



local SettingsTab = Window:CreateTab("Settings")

local SettingsTabCategoryMain = SettingsTab:AddCategory("Main", 1)

SettingsTabCategoryMain:AddKeybind("Toggle Keybind", Enum.KeyCode.RightShift, "SettingsTabCategoryUIToggleKeybind")

SettingsTabCategoryMain:AddButton("Server Hop", function()
	Serverhop()
end)

SettingsTabCategoryMain:AddButton("Server Rejoin", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

SettingsTabCategoryMain:AddButton("Copy Discord Invite", function()
	setclipboard("https://discord.gg/FdrQZ6sD5T")
end)

SettingsTabCategoryMain:AddButton("Copy Roblox Game Invite", function()
	setclipboard("Roblox.GameLauncher.joinGameInstance("..game.PlaceId..", '"..game.JobId.."')")
end)

SettingsTabCategoryMain:AddButton("Fix Vote Bug", function()
    LocalPlayer.PlayerGui.GUI.MapVote.Visible = false
	LocalPlayer.PlayerGui.GUI.Scoreboard.Visible = false
end)

SettingsTabCategoryMain:AddTextBox("Clantag", "", "SettingsTabCategoryMainClantag", function(val, focus)
	if val == "" then
		game.Players.LocalPlayer.OsPlatform = oldOsPlatform
	else
		while library.pointers.SettingsTabCategoryMainClantag.value == val do
			for i=1,#val do
				game.Players.LocalPlayer.OsPlatform = "|"..val:sub(1,i)
				wait(0.25)
			end
			wait(1)
			for i=1,4 do
				game.Players.LocalPlayer.OsPlatform = "|"..val
				wait(0.15)
				game.Players.LocalPlayer.OsPlatform = "|"..string.rep("*", #val)
				wait(0.15)
			end
			wait(0.5)
			game.Players.LocalPlayer.OsPlatform = "|"
			wait(0.5)
		end
	end
end)

local SettingsTabCategoryPlayers = SettingsTab:AddCategory("Players", 1)

SettingsTabCategoryPlayers:AddTextBox("Username", "", "SettingsTabCategoryPlayersUsername", function(val, focus)
	if game.Players:FindFirstChild(val) then
		local plr = game.Players:FindFirstChild(val)
		
		while game.Players:FindFirstChild(library.pointers.SettingsTabCategoryPlayersUsername.value) do
			wait(0.1)
			library.pointers.SettingsTabCategoryPlayersAge:Set("Age: "..plr.AccountAge.." days")
			library.pointers.SettingsTabCategoryPlayersAlive:Set("Alive: "..(IsAlive(plr) and "yes" or "no"))
			library.pointers.SettingsTabCategoryPlayersTeam:Set("Team: "..GetTeam(plr).Name)
		end
		
		library.pointers.SettingsTabCategoryPlayersAge:Set("Age: ")
		library.pointers.SettingsTabCategoryPlayersAlive:Set("Alive: ")
		library.pointers.SettingsTabCategoryPlayersTeam:Set("Team: ")
	end
end)

SettingsTabCategoryPlayers:AddLabel("Age: ", "SettingsTabCategoryPlayersAge")

SettingsTabCategoryPlayers:AddLabel("Alive: ", "SettingsTabCategoryPlayersAlive")

SettingsTabCategoryPlayers:AddLabel("Team: ", "SettingsTabCategoryPlayersTeam")

local SettingsTabCategoryConfigs = SettingsTab:AddCategory("Configs", 2)

CurrentGunSkinsTable = {}
CurrentGunSkinsTable["-"] = "-"

for i,v in pairs(weapon_skins["guns"]) do
	CurrentGunSkinsTable[i] = "Stock"
end

SettingsTabCategoryConfigs:AddTextBox("Name", "", "SettingsTabCategoryConfigsName")

SettingsTabCategoryConfigs:AddDropdown("Config", {"-"}, "-", "SettingsTabCategoryConfigsConfig")

SettingsTabCategoryConfigs:AddButton("Create", function()
    writefile("hexagon/configs/"..library.pointers.SettingsTabCategoryConfigsName.value..".cfg", library:SaveConfiguration())
	
	AllGunSkinsTable[library.pointers.SettingsTabCategoryConfigsName.value] = CurrentGunSkinsTable

	local temp = {}
	temp["-"] = "-"

	for i,v in pairs(weapon_skins["guns"]) do
		temp[i] = "Stock"
	end

	AllGunSkinsTable["-"] = temp

	writefile("hexagon/savedskins.cfg", SaveTable(AllGunSkinsTable))

	local temp = {}
	table.foreach(loadstring("return "..readfile("hexagon/savedskins.cfg"))(), function(i,v)
		table.insert(temp, i)
	end)
end)

SettingsTabCategoryConfigs:AddButton("Save", function()
    writefile("hexagon/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg", library:SaveConfiguration())

	AllGunSkinsTable[library.pointers.SettingsTabCategoryConfigsConfig.value] = CurrentGunSkinsTable

	local temp = {}
	temp["-"] = "-"

	for i,v in pairs(weapon_skins["guns"]) do
		temp[i] = "Stock"
	end

	AllGunSkinsTable["-"] = temp

	writefile("hexagon/savedskins.cfg", SaveTable(AllGunSkinsTable))

	local temp = {}
	table.foreach(loadstring("return "..readfile("hexagon/savedskins.cfg"))(), function(i,v)
		table.insert(temp, i)
	end)
end)

SettingsTabCategoryConfigs:AddButton("Load", function()
	local a,b = pcall(function()
		cfg = loadstring("return "..readfile("hexagon/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg"))()
	end)
	
	if a == false then
		warn("Config Loading Error", a, b)
	elseif a == true then
		library:LoadConfiguration(cfg)
	end

	if AllGunSkinsTable[library.pointers.SettingsTabCategoryConfigsConfig.value] then
		CurrentGunSkinsTable = AllGunSkinsTable[library.pointers.SettingsTabCategoryConfigsConfig.value]

		table.foreach(CurrentGunSkinsTable, function(i,v)
			if i ~= "-" then
				table.foreach(weapon_skins["guns"][i]["teams"], function(i2,v2)
					if v2 == "T" then
						game:GetService('Players').LocalPlayer.SkinFolder.TFolder[weapon_skins["guns"][i]["name"]].Value = v
					elseif v2 == "CT" then
						game:GetService('Players').LocalPlayer.SkinFolder.CTFolder[weapon_skins["guns"][i]["name"]].Value = v
					end
				end)
			end
		end)
	end
end)

SettingsTabCategoryConfigs:AddButton("Refresh", function()
	local cfgs = {}

	for i,v in pairs(listfiles("hexagon/configs")) do
		if v:sub(-4) == ".cfg" then
			table.insert(cfgs, v:sub(17, -5))
		end
	end
	
	library.pointers.SettingsTabCategoryConfigsConfig.options = cfgs
end)

SettingsTabCategoryConfigs:AddButton("Set as default", function()
	if isfile("hexagon/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg") then
		writefile("hexagon/autoload.txt", library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg")
	else
		writefile("hexagon/autoload.txt", "")
	end
end)

local versions = loadstring("return "..readfile("hexagon/versions.cfg"))()

SettingsTabCategoryConfigs:AddDropdown("Branch", {"-"}, "-", "SettingsTabCategoryConfigsBranch")
SettingsTabCategoryConfigs:AddDropdown("Build", {"-"}, "-", "SettingsTabCategoryConfigsBuild")
SettingsTabCategoryConfigs:AddButton("Save", function()
	writefile("hexagon/load_version.txt", versions["data"][library.pointers.SettingsTabCategoryConfigsBranch.value]["data"][library.pointers.SettingsTabCategoryConfigsBuild.value])
end)

library.pointers.SettingsTabCategoryConfigsBranch.options = versions["tables"]
library.pointers.SettingsTabCategoryConfigsBranch:Set(versions["tables"][1])

game:GetService("RunService").Stepped:Connect(function()
	library.pointers.SettingsTabCategoryConfigsBuild.options = versions["data"][library.pointers.SettingsTabCategoryConfigsBranch.value]["tables"]
	if not table.find(versions["data"][library.pointers.SettingsTabCategoryConfigsBranch.value]["tables"], library.pointers.SettingsTabCategoryConfigsBuild.value) then
		library.pointers.SettingsTabCategoryConfigsBuild:Set(versions["data"][library.pointers.SettingsTabCategoryConfigsBranch.value]["tables"][1])
	end
end)

local WorkSpace = game:GetService("Workspace")

local ExperimentalTab = Window:CreateTab("Experimental")

local ExperimentalLagg = ExperimentalTab:AddCategory("Lagg", 1)

ExperimentalLagg:AddToggle("Blood Removal", false, "ExperimentalLaggBloodRemoval", function(val)
    if val == true then
        BloodSplatterLoop = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                getsenv(game.Players.LocalPlayer.PlayerGui.Client).splatterBlood = function() end
                wait(1)
            end)
        end)
	elseif val == false and BloodSplatterLoop then
        BloodSplatterLoop:Disconnect()
	end
end)
ExperimentalLagg:AddToggle("Mag Removal", false, "ExperimentalLaggMagRemoval", function(val)
    if val == true then
        MagRemovalLoop = workspace.Ray_Ignore.ChildAdded:Connect(function(child)
            pcall(function()
				child:WaitForChild("Mesh")
                if child.Name == "MagDrop" then
                    child:Destroy()
                end
            end)
        end)
    elseif val == false and MagRemovalLoop then
        MagRemovalLoop:Disconnect()
    end
end)

local ExperimentalTabCategoryOptions = ExperimentalTab:AddCategory("Options", 1)

ExperimentalTabCategoryOptions:AddToggle("Anti-AFK", false, "ExperimentalTabCategoryOptionsAntiAFK", function(val)
    if val == true then
        Anti_AFKLoop = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
                    v:Disable()
                end
            end)
        end)
    elseif val == false and Anti_AFKLoop then
        Anti_AFKLoop:Disconnect()
    end
end)
ExperimentalTabCategoryOptions:AddDropdown("Texture Remove Method", {"Legacy", "New"}, "Legacy", "ExperimentalTabCategoryOptionsTRM")
ExperimentalTabCategoryOptions:AddToggle("Texture Remover", false ,"ExperimentalTabCategoryOptionsTR", function(val)
	if val == true then
		currentmap = nil
		trmethod = nil
		TextureRemoverLoop = game:GetService("RunService").Stepped:Connect(function()
			pcall(function()
				if trueorfalse10 == true then
					if currentmap ~= WorkSpace.Map.Origin.Value or trmethod ~= library.pointers.ExperimentalTabCategoryOptionsTRM.value then
						currentmap = WorkSpace.Map.Origin.Value
						trmethod = library.pointers.ExperimentalTabCategoryOptionsTRM.value
						wait(1)
						Hint.Text = "Removing textures..."

						if library.pointers.ExperimentalTabCategoryOptionsTRM.value == "Legacy" then
							local decalsyeeted = true
							local g = game
							local w = g.Workspace
							local l = g.Lighting
							local t = w.Terrain
							t.WaterWaveSize = 0
							t.WaterWaveSpeed = 0
							t.WaterReflectance = 0
							t.WaterTransparency = 0
							l.GlobalShadows = false
							l.FogEnd = 9e9
							l.Brightness = 0
							for i, v in pairs(g:GetDescendants()) do
								if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
									v.Material = "Plastic"
									v.Reflectance = 0
								elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
									v.Transparency = 1
								elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
									v.Lifetime = NumberRange.new(0)
								elseif v:IsA("Explosion") then
									v.BlastPressure = 1
									v.BlastRadius = 1
								elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
									v.Enabled = false
								elseif v:IsA("MeshPart") then
									v.Material = "Plastic"
									v.Reflectance = 0
									v.TextureID = 1521636846
								end
							end
							for i, e in pairs(l:GetChildren()) do
								if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
									e.Enabled = false
								end
							end
						elseif library.pointers.ExperimentalTabCategoryOptionsTRM.value == "New" then
							local decalsyeeted = true
							local g = game
							local w = g.Workspace
							local l = g.Lighting
							local t = w.Terrain
							sethiddenproperty(l,"Technology",2)
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
						
						Hint.Destroy()
					else
						wait(1)
					end
				else
					wait(3)
					trueorfalse10 = true
				end
			end)
		end)
	elseif val == false and TextureRemoverLoop then
		TextureRemoverLoop:Disconnect()
	end
end)

writefile("hexagon/killallguns.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/killallguns.cfg"))

local killallguns = loadstring("return "..readfile("hexagon/killallguns.cfg"))()

function killtarget(target)
	local position
	if library.pointers.ExperimentalTabCategoryOptionsVP.value == true then
		local p = library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Efficient" and target.Character.Head.Position or library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Hexagon" and target.Character.Head.Position or library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Stormy" and target.Character.Head.CFrame.p or library.pointers.ExperimentalTabCategoryOptionsMethod.value == "CFrame" and target.Character.Head.CFrame.p
		local hrp = target.Character.HumanoidRootPart.Position
		local oldHrp = target.Character.HumanoidRootPart.OldPosition.Value
		local vel = (Vector3.new(hrp.X, 0, hrp.Z) - Vector3.new(oldHrp.X, 0, oldHrp.Z)) / LastStep    
		local dir = Vector3.new(vel.X / vel.magnitude, 0, vel.Z / vel.magnitude)			  
		position = p + dir * (Ping / (math.pow(Ping, 1.5)) * (dir / (dir / 2)))
	else
		position = library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Efficient" and target.Character.Head.Position or library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Hexagon" and target.Character.Head.Position or library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Stormy" and target.Character.Head.CFrame.p or library.pointers.ExperimentalTabCategoryOptionsMethod.value == "CFrame" and target.Character.Head.CFrame.p
	end

    if library.pointers.ExperimentalTabCategoryOptionsRandomGun.value == false then
        if library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Efficient" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = LocalPlayer.Character.EquippedTool.Value,
                [4] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [5] = LocalPlayer.Character.Gun,
                [8] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 1 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 100, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [13] = Vector3.new()
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Hexagon" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = "Banana",
                [4] = 100,
                [5] = LocalPlayer.Character.Gun,
                [8] = 100,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 100,
                [13] = Vector3.new()
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Stormy" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = cbClient.gun.name,
                [4] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 4096,
                [5] = LocalPlayer.Character.Gun,
                [8] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 1 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 100,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(0,0,0),
                [12] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 16868,
                [13] = Vector3.new(0, 0, 0)
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "CFrame" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = LocalPlayer.Character.EquippedTool.Value,
                [4] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [5] = LocalPlayer.Character.Gun,
                [8] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 1 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 100, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [13] = Vector3.new()
                }
            return Arguments
        end
    elseif library.pointers.ExperimentalTabCategoryOptionsRandomGun.value == true then
        local rgun = killallguns[library.pointers.ExperimentalTabCategoryOptionsRandomWeaponType.value][math.random(1,#killallguns[library.pointers.ExperimentalTabCategoryOptionsRandomWeaponType.value])]
        if library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Efficient" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = rgun,
                [4] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [5] = game.ReplicatedStorage.Weapons[rgun].Model,
                [8] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 1 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [13] = Vector3.new()
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Hexagon" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = "Banana",
                [4] = 100,
                [5] = LocalPlayer.Character.Gun,
                [8] = 100,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 100,
                [13] = Vector3.new()
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Stormy" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = rgun,
                [4] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 4096,
                [5] = game.ReplicatedStorage.Weapons[rgun].Model,
                [8] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 1 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 100,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(0,0,0),
                [12] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 16868,
                [13] = Vector3.new(0, 0, 0)
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "CFrame" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = position,
                [3] = rgun,
                [4] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [5] = game.ReplicatedStorage.Weapons[rgun].Model,
                [8] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 1 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = library.pointers.ExperimentalTabCategoryOptionsND.value == true and 100 or library.pointers.ExperimentalTabCategoryOptionsND.value == false and 500,
                [13] = Vector3.new()
                }
            return Arguments
        end
    end
end

ExperimentalTabCategoryOptions:AddToggle("Auto Kill Visible", false, "ExperimentalTabCategoryOptionsAKV", function(val)
	if val == true then
		while library.pointers.ExperimentalTabCategoryOptionsAKV.value == true do
			if IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and workspace.Status.Preparation.Value == false then
				for i,plr in pairs(game.Players:GetPlayers()) do
					if plr ~= LocalPlayer and library.pointers.ExperimentalTabCategoryOptionsAKSO.value == false or plr ~= LocalPlayer and library.pointers.ExperimentalTabCategoryOptionsAKSO.value == true and plr.Name == library.pointers.ExperimentalTabCategoryOptionsAKS.value then
						if checkId("team") and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
							if IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and plr.Character["Head"] and IsVisible(plr.Character.Head.Position, {plr.Character, LocalPlayer.Character, HexagonFolder, workspace.CurrentCamera}) == true or IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and plr.Character["UpperTorso"] and IsVisible(plr.Character.UpperTorso.Position, {plr.Character, LocalPlayer.Character, HexagonFolder, workspace.CurrentCamera}) == true then
								spawn(function()
									if library.pointers["ExperimentalTabCategoryOptionsAKD"] then
										wait(library.pointers.ExperimentalTabCategoryOptionsAKD.value)
									end
	
									if IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
									end
								end)
							end
						elseif checkId("ffa") then
							if IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and plr.Character["Head"] and IsVisible(plr.Character.Head.Position, {plr.Character, LocalPlayer.Character, HexagonFolder, workspace.CurrentCamera}) == true or IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and plr.Character["UpperTorso"] and IsVisible(plr.Character.UpperTorso.Position, {plr.Character, LocalPlayer.Character, HexagonFolder, workspace.CurrentCamera}) == true then
								spawn(function()
									if library.pointers["ExperimentalTabCategoryOptionsAKD"] then
										wait(library.pointers.ExperimentalTabCategoryOptionsAKD.value)
									end
									
									if IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
									end
								end)
							end
						end
					end
				end
			end

			if library.pointers["ExperimentalTabCategoryOptionsAKLD"] and library.pointers.ExperimentalTabCategoryOptionsAKLD.value ~= 0 then
				wait(library.pointers.ExperimentalTabCategoryOptionsAKLD.value / 1000)
			end
		end
	end
end)
ExperimentalTabCategoryOptions:AddSlider("Auto Kill Loop Delay", {0, 3000, 100, 100, "Ms"}, "ExperimentalTabCategoryOptionsAKLD")
ExperimentalTabCategoryOptions:AddSlider("Auto Kill Delay", {0, 10, 0, 1, ""}, "ExperimentalTabCategoryOptionsAKD")
ExperimentalTabCategoryOptions:AddToggle("Auto Kill Specific Only", false, "ExperimentalTabCategoryOptionsAKSO")
ExperimentalTabCategoryOptions:AddDropdown("Auto Kill Specific", {"-"}, "-", "ExperimentalTabCategoryOptionsAKS")

ExperimentalTabCategoryOptions:AddDropdown("Kill All Method", {"Efficient", "Hexagon", "Stormy", "CFrame"}, "CFrame", "ExperimentalTabCategoryOptionsMethod")
ExperimentalTabCategoryOptions:AddToggle("Velocity Prediction", false, "ExperimentalTabCategoryOptionsVP")
ExperimentalTabCategoryOptions:AddToggle("Normal Damage", false, "ExperimentalTabCategoryOptionsND")
ExperimentalTabCategoryOptions:AddDropdown("Kill Method", {"Once", "Loop"}, "Once", "ExperimentalTabCategoryOptionsKMethod")
ExperimentalTabCategoryOptions:AddToggle("After Prep", false, "ExperimentalTabCategoryOptionsAfterPrep")
ExperimentalTabCategoryOptions:AddDropdown("Random Weapon Type", {"Both", "Gun", "Melee"}, "Both", "ExperimentalTabCategoryOptionsRandomWeaponType")
ExperimentalTabCategoryOptions:AddToggle("Random Weapon", false, "ExperimentalTabCategoryOptionsRandomGun")
ExperimentalTabCategoryOptions:AddSlider("Loop Rate", {1, 20, 5, 1, ""}, "ExperimentalTabCategoryOptionsLoopRate")

ExperimentalTabCategoryOptions:AddToggle("Kill all", false, "ExperimentalTabCategoryOptionsKillall", function(val)
	if val == true then
		KillEnemiesLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" then
					for i,v in pairs(game.Players:GetChildren()) do
						if v ~= LocalPlayer and IsAlive(v) then
							if checkId("team") then
                                if GetTeamDif(v) ~= "Spectator" and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
                                    if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                    elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                        if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
											for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
												if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
													game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
												end
												wait()
											end
										end
                                    elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                    elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                        if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
											for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
												if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
													game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
												end
												wait()
											end
										end
                                    end
                                end
                            elseif checkId("ffa") then
                                if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                    game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                    if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) then
										for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
											if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) then
												game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
											end
											wait()
										end
									end
                                elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                    game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                    if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
										for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
											if GetTeamDif(v) ~= "Spectator" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
												game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
											end
											wait()
										end
									end
                                end
                            end
						end
					end
				end
			end)
		end)
	elseif val == false and KillEnemiesLoop then
		KillEnemiesLoop:Disconnect()
	end
end)

ExperimentalTabCategoryOptions:AddToggle("Refresh player list", false, "ExperimentalTabCategoryOptionsRefresh", function(val)
	if val == true then
		trueorfalse3 = true
		RefreshLoop = game:GetService("RunService").Heartbeat:Connect(function()
			pcall(function()
				if trueorfalse3 == true then
					trueorfalse3 = false

					local playerlistkillall = {"-"}
					local playerlistfollow = {"-"}
					local playerlistram = {"-"}
                    local playerlistgw = {"-"}
					local playerlistss = {"-"}
					local playerlistrp = {"-"}
					playerak = false
					player1f = false
					player2f = false
					player3f = false
					playerfollowf = false
					playertroll = false
					playerram = false
					playerss = false
                    playergw = false
					for i,v in pairs(game.Players:GetChildren()) do
						if v ~= LocalPlayer then
							if IsAlive(v) then
								playerlistfollow[v] = v
							end

							if tostring(v) == library.pointers.ExperimentalTabCategoryOptionsAKS.value then
								playerak = true
							end

							if tostring(v) == library.pointers.ExperimentalTabCategoryPlayer1Players.value then
								player1f = true
							end

							if tostring(v) == library.pointers.ExperimentalTabCategoryPlayer2Players.value then
								player2f = true
							end

							if tostring(v) == library.pointers.ExperimentalTabCategoryPlayer3Players.value then
								player3f = true
							end

							if tostring(v) == library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value then
								playerfollowf = true
							end

							if tostring(v) == library.pointers.TrollTabGrenadeSP.value then
								playertroll = true
							end

							if tostring(v) == library.pointers.TrollTabPlayerRAMP.value then
								playerram = true
							end

                            if tostring(v) == library.pointers.TrollTabSoundGWT.value then
                                playergw = true
                            end

							if tostring(v) == library.pointers.TrollTabPlayerSS.value then
								playerss = true
							end

							if checkId("team") then
								if GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
									playerlistkillall[v] = v
								end
							elseif checkId("ffa") then
								playerlistkillall[v] = v
							end
							
							playerlistrp[v] = v
							playerlistram[v] = v
                            playerlistgw[v] = v
							playerlistss[v] = v
						end
					end

					if prev_players ~= playerlistfollow then
						local prev_players = playerlistfollow

						library.pointers.ReportPlayer.options = playerlistrp

						if playerss == true then
							library.pointers.TrollTabPlayerSS.options = playerlistss
						else
							library.pointers.TrollTabPlayerSS:Set("-")
                            library.pointers.TrollTabPlayerSS.options = playerlistss
						end

                        if playergw == true then
                            library.pointers.TrollTabSoundGWT.options = playerlistgw
                        else
                            library.pointers.TrollTabSoundGWT:Set("-")
                            library.pointers.TrollTabSoundGWT.options = playerlistgw
                        end

						if playerram == true then
							library.pointers.TrollTabPlayerRAMP.options = playerlistram
						else
							library.pointers.TrollTabPlayerRAMP:Set("-")
							library.pointers.TrollTabPlayerRAMP.options = playerlistram
						end

						if playertroll == true then
							library.pointers.TrollTabGrenadeSP.options = playerlistfollow
						else
							library.pointers.TrollTabGrenadeSP:Set("-")
							library.pointers.TrollTabGrenadeSP.options = playerlistfollow
						end

						if playerfollowf == true then
							library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.options = playerlistfollow
						else
							library.pointers.ExperimentalTabCategoryTeleportPLRFollowList:Set("-")
							library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.options = playerlistfollow
						end
					
						if playerak == true then
							library.pointers.ExperimentalTabCategoryOptionsAKS.options = playerlistkillall
						else
							library.pointers.ExperimentalTabCategoryOptionsAKS:Set("-")
							library.pointers.ExperimentalTabCategoryOptionsAKS.options = playerlistkillall
						end

						if player1f == true then
							library.pointers.ExperimentalTabCategoryPlayer1Players.options = playerlistkillall
						else
							library.pointers.ExperimentalTabCategoryPlayer1Players:Set("-")
							library.pointers.ExperimentalTabCategoryPlayer1Players.options = playerlistkillall
						end

						if player2f == true then
							library.pointers.ExperimentalTabCategoryPlayer2Players.options = playerlistkillall
						else
							library.pointers.ExperimentalTabCategoryPlayer2Players:Set("-")
							library.pointers.ExperimentalTabCategoryPlayer2Players.options = playerlistkillall
						end

						if player3f == true then
							library.pointers.ExperimentalTabCategoryPlayer3Players.options = playerlistkillall
						else
							library.pointers.ExperimentalTabCategoryPlayer3Players:Set("-")
							library.pointers.ExperimentalTabCategoryPlayer3Players.options = playerlistkillall
						end
					end

					trueorfalse3 = true
				end
			end)
		end)
	elseif val == false and RefreshLoop then
		RefreshLoop:Disconnect()
	end
end)

ExperimentalTabCategoryOptions:AddMultiDropdown("Anti-Aim Resolver", {"Pitch", "Roll", "Animation"}, {}, "ExperimentalTabCategoryOptionsAntiAimResolver")
ExperimentalTabCategoryOptions:AddToggle("Anti Anti-Aim", false, "ExperimentalTabCategoryOptionsAAM", function(val)
	if val == true then
		AAMLoop = game:GetService("RunService").Stepped:Connect(function()
			pcall(function()
				for i,v in pairs(game.Players:GetPlayers()) do
					spawn(function()
						if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Team ~= "TTT" and v ~= LocalPlayer then
							if table.find(library.pointers.ExperimentalTabCategoryOptionsAntiAimResolver.value, "Pitch") then
								v.Character.UpperTorso.Waist.C0 = CFrame.Angles(0, 0, 0)      
								v.Character.LowerTorso.Root.C0 = CFrame.Angles(0,0,0)
								v.Character.Head.Neck.C0 = CFrame.new(0,1,0) * CFrame.Angles(0, 0, 0) 
							end
							if table.find(library.pointers.ExperimentalTabCategoryOptionsAntiAimResolver.value, "Roll") then
								v.Character.Humanoid.MaxSlopeAngle = 0 
							end
							if table.find(library.pointers.ExperimentalTabCategoryOptionsAntiAimResolver.value, "Animation") then
								for i2,Animation in pairs(v.Character.Humanoid:GetPlayingAnimationTracks()) do
									Animation:Stop()
								end
							end
						end
					end)
				end
			end)
		end)
	elseif val == false and AAMLoop then
		AAMLoop:Disconnect()
	end
end)

--[[ExperimentalTabCategoryOptions:AddToggle("Break Stormy Ragebot", false, "ExperimentalTabCategoryOptionsBreakStormyRagebot", function(val)
	if val == true then
		BreakStormyRagebotLoop = LocalPlayer.CharacterAdded:Connect(function()
			pcall(function()
				LocalPlayer.Character.UpperTorso.Waist:Destroy()
			end)
		end)
	elseif val == false and BreakStormyRagebotLoop then
		BreakStormyRagebotLoop:Disconnect()
	end
end)]]--

function teleportTospawnpoint()
	wait()
	if IsAlive(LocalPlayer) and library.pointers.ExperimentalTabCategoryTeleportAfterTeleport.value == "Spawnpoint" then
		if game:GetService('Players').LocalPlayer.Status.Team.Value == "T" then
			for i,v in pairs(WorkSpace.Map.TSpawns:GetChildren()) do
				lastspawnpoint = v
				break
			end

			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastspawnpoint.Position + Vector3.new(0, 1, 0))
		elseif game:GetService('Players').LocalPlayer.Status.Team.Value == "CT" then
			for i,v in pairs(WorkSpace.Map.CTSpawns:GetChildren()) do
				lastspawnpoint = v
				break
			end

			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastspawnpoint.Position + Vector3.new(0, 1, 0))
		end
	end
end

local ExperimentalTabCategoryTeleport = ExperimentalTab:AddCategory("Teleport", 1)

ExperimentalTabCategoryTeleport:AddDropdown("After teleport", {"Spawnpoint", "Nothing"}, "Spawnpoint", "ExperimentalTabCategoryTeleportAfterTeleport")

ExperimentalTabCategoryTeleport:AddDropdown("Teleport Method", {"Players", "Bomb Sites"}, "Players", "ExperimentalTabCategoryTeleportTeleportOptions")

ExperimentalTabCategoryTeleport:AddDropdown("Follow Options", {"Random", "Glue", "Behind"}, "Random", "ExperimentalTabCategoryTeleportFollowMethod")

ExperimentalTabCategoryTeleport:AddSlider("Teleport Offset", {0, 500, 5, 5, ""}, "ExperimentalTabCategoryTeleportOffset")

function teleportToPlayer(plr, offset)
	if offset == "Random" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value), 0, (math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value))
	elseif offset == "Glue" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value, 0)
	elseif offset == "Behind" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, library.pointers.ExperimentalTabCategoryTeleportOffset.value)
	end
end

ExperimentalTabCategoryTeleport:AddToggle("Teleport Loop", false, "ExperimentalTabCategoryTeleportTeleport", function(val)
	if val == true then
		etctFDLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if IsAlive(LocalPlayer) then
					if library.pointers.ExperimentalTabCategoryTeleportFollowPLR.value == true or library.pointers.ExperimentalTabCategoryTeleportTeleport.value == true then
						if SilentTable.Teleporter1 == false or SilentTable.Teleporter2 == false then
							SilentTable.NoclipSwitch = true
							local velocity = Vector3.new(0, 1, 0)
						
							LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
							LocalPlayer.Character.Humanoid.PlatformStand = true
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								for i2,v2 in pairs(Colliders) do
									if v.CanCollide == true then
										if v.Name == v2 then
											v.CanCollide = false
										end
									end
								end
							end
						elseif SilentTable.NoclipSwitch == true then
							SilentTable.NoclipSwitch = false
							if LocalPlayer.Character.Humanoid.PlatformStand == true then
								LocalPlayer.Character.Humanoid.PlatformStand = false
							end
						end
					end
				end
			end)
		end)
		TeleportLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if IsAlive(LocalPlayer) then
					if library.pointers.ExperimentalTabCategoryTeleportConstantTP.value == true and SilentTable.Pause == false or library.pointers.ExperimentalTabCategoryOptionsKillall.value == true and SilentTable.Pause == false then
						local check = table.foreach(game.Players:GetPlayers(), function(i,v)
							if v ~= LocalPlayer and IsAlive(v) and GetTeamDif(v) ~= "Spectator" and checkId("team") and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) or v ~= LocalPlayer and IsAlive(v) and GetTeamDif(v) ~= "Spectator" and checkId("ffa") then
								return true
							end
						end)
						if check == true and library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false or check == true and library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false then
							SilentTable.Teleporter1 = false
							if library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Bomb Sites" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
							elseif library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Players" then
								for i,v in pairs(game.Players:GetChildren()) do
									if IsAlive(LocalPlayer) and v ~= LocalPlayer and IsAlive(v) and SilentTable.Pause == false and GetTeamDif(v) ~= "Spectator" then
										teleportToPlayer(v, library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value)
										wait()
									elseif SilentTable.Pause == true then
										break
									end
								end
							end
						elseif check == true and library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == true then
							SilentTable.Teleporter1 = false
							LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1000000)
						elseif check == nil then
							if SilentTable.Teleporter1 == false then
								SilentTable.Pause = true
								SilentTable.Teleporter1 = true
								for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
									for i2,v2 in pairs(Colliders) do
										if v.Name == v2 then
											v.CanCollide = true
										end
									end
								end
								teleportTospawnpoint()
								SilentTable.Pause = false
							end
						end
					elseif library.pointers.ExperimentalTabCategoryPlayer1Kill.value == true and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer1Players.value) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer1Players.value]) ~= "Spectator" and checkId("team") and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer1Players.value]) ~= GetTeamDif(LocalPlayer) and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryPlayer1Players.value]) or library.pointers.ExperimentalTabCategoryPlayer1Kill.value == true and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer1Players.value) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer1Players.value]) ~= "Spectator" and checkId("ffa") and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryPlayer1Players.value]) or library.pointers.ExperimentalTabCategoryPlayer2Kill.value == true and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer2Players.value) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer2Players.value]) ~= "Spectator" and checkId("team") and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer2Players.value]) ~= GetTeamDif(LocalPlayer) and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryPlayer2Players.value]) or library.pointers.ExperimentalTabCategoryPlayer2Kill.value == true and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer2Players.value) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer2Players.value]) ~= "Spectator" and checkId("ffa") and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryPlayer2Players.value]) or library.pointers.ExperimentalTabCategoryPlayer3Kill.value == true and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer3Players.value) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer3Players.value]) ~= "Spectator" and checkId("team") and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer3Players.value]) ~= GetTeamDif(LocalPlayer) and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryPlayer3Players.value]) or library.pointers.ExperimentalTabCategoryPlayer3Kill.value == true and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer3Players.value) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryPlayer3Players.value]) ~= "Spectator" and checkId("ffa") and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryPlayer3Players.value]) then
						SilentTable.Teleporter1 = false
						if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false then
							if library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Bomb Sites" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
							elseif library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Players" then
								for i,v in pairs(game.Players:GetChildren()) do
									if IsAlive(LocalPlayer) and v ~= LocalPlayer and IsAlive(v) and SilentTable.Pause == false and GetTeamDif(v) ~= "Spectator" then
										teleportToPlayer(v, library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value)
										wait()
									elseif SilentTable.Pause == true then
										break
									end
								end
							end
						elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == true then
							LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1000000)
						end
					else
						if SilentTable.Teleporter1 == false then
							SilentTable.Pause = true
							SilentTable.Teleporter1 = true
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								for i2,v2 in pairs(Colliders) do
									if v.Name == v2 then
										v.CanCollide = true
									end
								end
							end
							teleportTospawnpoint()
							SilentTable.Pause = false
						end
					end
				end
			end)
		end)
	elseif val == false and TeleportLoop then
		TeleportLoop:Disconnect()
		SilentTable.Teleporter1 = true
		if library.pointers.ExperimentalTabCategoryTeleportFollowPLR.value == false then
			etctFDLoop:Disconnect()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				for i2,v2 in pairs(Colliders) do
					if v.Name == v2 then
						v.CanCollide = true
					end
				end
			end

			teleportTospawnpoint()
		end
	end
end)

ExperimentalTabCategoryTeleport:AddToggle("Constant Teleport", false, "ExperimentalTabCategoryTeleportConstantTP")

ExperimentalTabCategoryTeleport:AddDropdown("Player Follower", {"-"}, "-", "ExperimentalTabCategoryTeleportPLRFollowList")

ExperimentalTabCategoryTeleport:AddToggle("Follow", false, "ExperimentalTabCategoryTeleportFollowPLR", function(val)
	if val == true then
		etctFDLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
                if IsAlive(LocalPlayer) then
					if library.pointers.ExperimentalTabCategoryTeleportFollowPLR.value == true or library.pointers.ExperimentalTabCategoryTeleportTeleport.value == true then
						if SilentTable.Teleporter1 == false or SilentTable.Teleporter2 == false then
							SilentTable.NoclipSwitch = true
							local velocity = Vector3.new(0, 1, 0)
						
							LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
							LocalPlayer.Character.Humanoid.PlatformStand = true
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								for i2,v2 in pairs(Colliders) do
									if v.CanCollide == true then
										if v.Name == v2 then
											v.CanCollide = false
										end
									end
								end
							end
						elseif SilentTable.NoclipSwitch == true then
							SilentTable.NoclipSwitch = false
							if LocalPlayer.Character.Humanoid.PlatformStand == true then
								LocalPlayer.Character.Humanoid.PlatformStand = false
							end
						end
					end
				end
			end)
		end)
		PlayerFollowLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if IsAlive(LocalPlayer) and SilentTable.Pause == false and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value) and IsAlive(game.Players[library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value]) and GetTeamDif(game.Players[library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value]) ~= "Spectator" then
					SilentTable.Teleporter2 = false
					if library.pointers.ExperimentalTabCategoryTeleportTeleport.value == true and SilentTable.Teleporter1 == true or library.pointers.ExperimentalTabCategoryTeleportTeleport.value == false then
						teleportToPlayer(game.Players[library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value], library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value)
					end
				elseif IsAlive(LocalPlayer) then
					if SilentTable.Teleporter2 == false then
						SilentTable.Pause = true
						SilentTable.Teleporter2 = true
						for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
							for i2,v2 in pairs(Colliders) do
								if v.Name == v2 then
									v.CanCollide = true
								end
							end
						end
						teleportTospawnpoint()
						SilentTable.Pause = false
					end
				end
			end)
		end)
	elseif val == false and PlayerFollowLoop then
		PlayerFollowLoop:Disconnect()
		SilentTable.Teleporter2 = true
		if library.pointers.ExperimentalTabCategoryTeleportTeleport.value == false then
			etctFDLoop:Disconnect()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				for i2,v2 in pairs(Colliders) do
					if v.Name == v2 then
						v.CanCollide = true
					end
				end
			end

			teleportTospawnpoint()
		end
	end
end)

function Serverhop()
	wait(0.1)
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

local ExperimentalTabCategoryCredits = ExperimentalTab:AddCategory("Credits", 1)

ExperimentalTabCategoryCredits:AddLabel("Experimental tab made by:")
ExperimentalTabCategoryCredits:AddLabel("SomeoneIdfk")
ExperimentalTabCategoryCredits:AddLabel("No discord for you.")
ExperimentalTabCategoryCredits:AddLabel("")
ExperimentalTabCategoryCredits:AddLabel("Special thanks to these beta testers!")
ExperimentalTabCategoryCredits:AddLabel("hxg.addictt#8871")
ExperimentalTabCategoryCredits:AddLabel("Sex Offender#2997")

local ExperimentalTabCategoryPlayer1 = ExperimentalTab:AddCategory("Player 1", 2)

ExperimentalTabCategoryPlayer1:AddDropdown("Players", {"-"}, "-", "ExperimentalTabCategoryPlayer1Players")

ExperimentalTabCategoryPlayer1:AddToggle("Kill Specific", false, "ExperimentalTabCategoryPlayer1Kill", function(val)
	if val == true then
		KillSpecificLoop1 = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if library.pointers.ExperimentalTabCategoryPlayer1Players.value ~= "-" and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer1Players.value) and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" then
					local plr = game.Players[library.pointers.ExperimentalTabCategoryPlayer1Players.value]
					if checkId("ffa") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" or checkId("team") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
						if library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
							for i = 1,library.pointers.ExperimentalTabCategoryOptionsLoopRate.value,1 do
								if checkId("ffa") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" or checkId("team") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
									if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
									end
								end
							end
						elseif library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
							if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false then
								game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
							end
						end
					end
				end
			end)
		end)
	elseif val == false and KillSpecificLoop1 then
		KillSpecificLoop1:Disconnect()
	end
end)

local ExperimentalTabCategoryPlayer2 = ExperimentalTab:AddCategory("Player 2", 2)

ExperimentalTabCategoryPlayer2:AddDropdown("Players", {"-"}, "-", "ExperimentalTabCategoryPlayer2Players")

ExperimentalTabCategoryPlayer2:AddToggle("Kill Specific", false, "ExperimentalTabCategoryPlayer2Kill", function(val)
	if val == true then
		KillSpecificLoop2 = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if library.pointers.ExperimentalTabCategoryPlayer2Players.value ~= "-" and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer2Players.value) and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" then
					local plr = game.Players[library.pointers.ExperimentalTabCategoryPlayer2Players.value]
					if checkId("ffa") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" or checkId("team") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
						if library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
							for i = 1,library.pointers.ExperimentalTabCategoryOptionsLoopRate.value,1 do
								if checkId("ffa") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" or checkId("team") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
									if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
									end
								end
							end
						elseif library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
							if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false then
								game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
							end
						end
					end
				end
			end)
		end)
	elseif val == false and KillSpecificLoop2 then
		KillSpecificLoop2:Disconnect()
	end
end)

local ExperimentalTabCategoryPlayer3 = ExperimentalTab:AddCategory("Player 3", 2)

ExperimentalTabCategoryPlayer3:AddDropdown("Players", {"-"}, "-", "ExperimentalTabCategoryPlayer3Players")

ExperimentalTabCategoryPlayer3:AddToggle("Kill Specific", false, "ExperimentalTabCategoryPlayer3Kill", function(val)
	if val == true then
		KillSpecificLoop3 = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if library.pointers.ExperimentalTabCategoryPlayer3Players.value ~= "-" and game.Players:FindFirstChild(library.pointers.ExperimentalTabCategoryPlayer3Players.value) and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" then
					local plr = game.Players[library.pointers.ExperimentalTabCategoryPlayer3Players.value]
					if checkId("ffa") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" or checkId("team") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
						if library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
							for i = 1,library.pointers.ExperimentalTabCategoryOptionsLoopRate.value,1 do
								if checkId("ffa") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" or checkId("team") and IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(plr) and GetTeamDif(plr) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
									if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
									end
								end
							end
						elseif library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
							if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false or library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false then
								game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(plr)))
							end
						end
					end
				end
			end)
		end)
	elseif val == false and KillSpecificLoop3 then
		KillSpecificLoop3:Disconnect()
	end
end)

local ExperimentalTabCategoryFarm = ExperimentalTab:AddCategory("Farm", 2)

ExperimentalTabCategoryFarm:AddToggle("Enable", false, "ExperimentalTabCategoryFarmEnable", function(val)
	if val == true then
		trueorfalse2 = true
		trueorfalse4 = true
		wvalue = 0
		data = WorkSpace.Status
		map = WorkSpace.Map.Origin.Value
		prevscore = library.pointers.ExperimentalTabCategoryFarmScore.value
		ticks = 0

		if data.TWins.Value < library.pointers.ExperimentalTabCategoryFarmScore.value and data.CTWins.Value < library.pointers.ExperimentalTabCategoryFarmScore.value and library.pointers.ExperimentalTabCategoryFarmServerHop.value == true then
			while true do
				Serverhop()
				wait(10)
			end
		end
        
        AVKLoop = game.ReplicatedStorage.Events.SendMsg.OnClientEvent:Connect(function(message)
            if library.pointers.ExperimentalTabCategoryFarmAVK.value == true then
                local msg = string.split(message, " ")
                
                if game.Players:FindFirstChild(msg[1]) and msg[7] == "1" and msg[12] == game.Players.LocalPlayer.Name then
                    if library.pointers.ExperimentalTabCategoryFarmAVKA.value == "Rejoin" then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    elseif library.pointers.ExperimentalTabCategoryFarmAVK.value == "Server Hop" then
                        Serverhop()
                    end
                elseif game.Players:FindFirstChild(msg[1]) and msg[7] == "2" and msg[12] == game.Players.LocalPlayer.Name then
                    if library.pointers.ExperimentalTabCategoryFarmAVKA.value == "Rejoin" then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    elseif library.pointers.ExperimentalTabCategoryFarmAVK.value == "Server Hop" then
                        Serverhop()
                    end
                elseif game.Players:FindFirstChild(msg[1]) and msg[7] == "-1" and msg[12] == game.Players.LocalPlayer.Name then
                    if library.pointers.ExperimentalTabCategoryFarmAVKA.value == "Rejoin" then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    elseif library.pointers.ExperimentalTabCategoryFarmAVK.value == "Server Hop" then
                        Serverhop()
                    end
                end
            else
                wait(1)
            end
        end)

		FarmLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if wvalue ~= 30 then
					wvalue = wvalue + 1
					if wvalue == 15 then
						if data.TWins.Value == 7 and data.CTWins.Value == 7 and library.pointers.ExperimentalTabCategoryFarmServerHop.value == true then
							while true do
								Serverhop()
								wait(10)
							end
						elseif data.TWins.value < library.pointers.ExperimentalTabCategoryFarmScore.value and data.CTWins.Value < library.pointers.ExperimentalTabCategoryFarmScore.value and library.pointers.ExperimentalTabCategoryFarmServerHop.value == true then
							while true do
								Serverhop()
								wait(10)
							end
					
						elseif data.TWins.Value ~= data.CTWins.Value then
							if data.TWins.Value > library.pointers.ExperimentalTabCategoryFarmScore.value and data.TWins.Value > data.CTWins.Value then
								if game:GetService('Players').LocalPlayer.Status.Team.Value ~= "T" then
									if data.NumT.Value <= data.NumCT.Value then
										game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('T')
									elseif (data.NumT.Value - data.NumCT.Value) == 1 then
										if game:GetService('Players').LocalPlayer.Status.Team.Value == "Spectator" then
											game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('CT')
											game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('T')
										end
									end
								end
					
							elseif data.CTWins.Value > library.pointers.ExperimentalTabCategoryFarmScore.value and data.CTWins.Value > data.TWins.Value then
								if game:GetService('Players').LocalPlayer.Status.Team.Value ~= "CT" then
									if data.NumCT.Value <= data.NumT.Value then
										game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('CT')
									elseif (data.NumCT.Value - data.NumT.Value) == 1 then
										if game:GetService('Players').LocalPlayer.Status.Team.Value == "Spectator" then
											game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('T')
											game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('CT')
										end
									end
								end
							end
						end
					elseif wvalue == 27 then
						if library.pointers.ExperimentalTabCategoryFarmBuyCases.value == true and library.pointers.ExperimentalTabCategoryFarmSelectedCase.value ~= "-" then
							if game:GetService('Players').LocalPlayer.SkinFolder.Funds.Value > 50 and trueorfalse4 == true then
								trueorfalse4 = false
								game.ReplicatedStorage.Events.DataEvent:FireServer({"BuyCase", library.pointers.ExperimentalTabCategoryFarmSelectedCase.value})
								wait(1)
								trueorfalse4 = true
							end
						end
					elseif wvalue == 28 then
						if prevscore ~= library.pointers.ExperimentalTabCategoryFarmScore.value and library.pointers.ExperimentalTabCategoryFarmServerHop.value == true then
							prevscore = library.pointers.ExperimentalTabCategoryFarmScore.value
							while true do
								Serverhop()
								wait(10)
							end
						end
					elseif wvalue == 29 then
						if WorkSpace.Map.Origin.Value ~= map and library.pointers.ExperimentalTabCategoryFarmServerHop.value == true then
							while true do
								Serverhop()
								wait(10)
							end
						end
					end
				elseif wvalue == 30 then
					wvalue = 0
					if ticks == 20 then
						trueorfalse2 = true
						ticks = 0
					end

					if library.pointers.ExperimentalTabCategoryFarmKillPlayer.value == true and game:GetService('Players').LocalPlayer.Character:FindFirstChild("Humanoid") then
						if game:GetService('Players').LocalPlayer.Character.Humanoid.Health ~= 0 and trueorfalse2 == true then
							trueorfalse2 = false
							if library.pointers.ExperimentalTabCategoryFarmGamemode.value == "Casual" then
								wait(6)
							elseif library.pointers.ExperimentalTabCategoryFarmGamemode.value == "Unranked" then
								wait(21)
							end

							if library.pointers.ExperimentalTabCategoryFarmKillMethod.value == "Set Health" then
								game:GetService('Players').LocalPlayer.Character.Humanoid.Health = 0
							elseif library.pointers.ExperimentalTabCategoryFarmKillMethod.value == "Team Switch" then
								if data.TWins.Value > library.pointers.ExperimentalTabCategoryFarmScore.value and data.TWins.Value > data.CTWins.Value then
									if data.NumT.Value <= data.NumCT.Value or data.NumT.Value - data.NumCT.Value == 1 or data.NumT.Value - data.NumCT.Value == 2 then
										game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('CT')
										game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('T')
									end
								elseif data.CTWins.Value > library.pointers.ExperimentalTabCategoryFarmScore.value and data.CTWins.Value > data.TWins.Value then
									if data.NumCT.Value <= data.NumT.Value or data.NumCT.Value - data.NumT.Value == 1 or data.NumCT.Value - data.NumT.Value == 2 then
										game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('T')
										game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer('CT')
									end
								end
							end
							wait(1)
							trueorfalse2 = true
						elseif trueorfalse2 == false then
							ticks = ticks + 1
						end
					end
				end
			end)
		end)
	elseif val == false and FarmLoop then
		FarmLoop:Disconnect()
        AVKLoop:Disconnect()
	end
end)

ExperimentalTabCategoryFarm:AddToggle("Buy cases", false, "ExperimentalTabCategoryFarmBuyCases")
ExperimentalTabCategoryFarm:AddDropdown("Selected case", {"-", "Militia Case", "Modern Case", "Hapax Case", "Karambit Case", "Remastered Case", "Vortax Case", "SCR Case", "Imagenim Case", "Kitter Case", "Hiato Case"}, "-", "ExperimentalTabCategoryFarmSelectedCase")
ExperimentalTabCategoryFarm:AddToggle("Anti Vote Kick", false, "ExperimentalTabCategoryFarmAVK")
ExperimentalTabCategoryFarm:AddDropdown("Anti Vote Kick Action", {"Rejoin", "Server Hop"}, "Rejoin", "ExperimentalTabCategoryFarmAVKA")
ExperimentalTabCategoryFarm:AddToggle("Server hop", false, "ExperimentalTabCategoryFarmServerHop")
ExperimentalTabCategoryFarm:AddToggle("Kill character", false, "ExperimentalTabCategoryFarmKillPlayer")
ExperimentalTabCategoryFarm:AddDropdown("Kill method", {"Set Health", "Team Switch"}, "Set Health", "ExperimentalTabCategoryFarmKillMethod")
ExperimentalTabCategoryFarm:AddDropdown("Gamemode", {"Casual", "Unranked"}, "Casual", "ExperimentalTabCategoryFarmGamemode")
ExperimentalTabCategoryFarm:AddSlider("Minimum score", {0, 15, 4, 1, ""}, "ExperimentalTabCategoryFarmScore")
ExperimentalTabCategoryFarm:AddToggle("Anti-Afk", false, "ExperimentalTabcategoryFarmAntiAFK", function(val)
	if val == true then
		AntiAFKLoop = game:GetService("RunService").Heartbeat:Connect(function()
			for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
				v:Disable()
			end
		end)
	elseif val == false and AntiAFKLoop then
		AntiAFKLoop:Disconnect()
	end
end)

local SkinsTab = Window:CreateTab("Skins")

local HexFolSkinsStart = Instance.new("BoolValue", HexagonFolder)
HexFolSkinsStart.Name = "SkinStart"
HexFolSkinsStart.Value = false

local SkinsTabMain = SkinsTab:AddCategory("Main", 1)

SkinsTabMain:AddDropdown("Weapon", {"-"}, "-", "SkinsTabMainWeapon", function(val)
	if val ~= "-" then
		spawn(function()
			if HexFolSkinsStart.Value == false then
				HexFolSkinsStart.Value = true
				wait(1)
			end
			
			library.pointers.SkinsTabMainSkin.options = weapon_skins["guns"][val]["list"]
			library.pointers.SkinsTabMainSkin:Set(CurrentGunSkinsTable[val])
		end)
	else
		spawn(function()
			if HexFolSkinsStart.Value == false then
				HexFolSkinsStart.Value = true
				wait(1)
			end

			library.pointers.SkinsTabMainSkin.options = {"-"}
			library.pointers.SkinsTabMainSkin:Set("-")
		end)
	end
end)

local temp = {"-"}
table.foreach(weapon_skins["guns"], function(i,v)
	table.insert(temp, i)
end)
library.pointers.SkinsTabMainWeapon.options = temp

SkinsTabMain:AddDropdown("Skin", {"-"}, "-", "SkinsTabMainSkin", function(val)
	CurrentGunSkinsTable[library.pointers.SkinsTabMainWeapon.value] = val

	table.foreach(CurrentGunSkinsTable, function(i,v)
		if i ~= "-" then
			table.foreach(weapon_skins["guns"][i]["teams"], function(i2,v2)
				if v2 == "T" then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder[weapon_skins["guns"][i]["name"]].Value = v
				elseif v2 == "CT" then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder[weapon_skins["guns"][i]["name"]].Value = v
				end
			end)
		end
	end)
end)

local SkinsTabKnife = SkinsTab:AddCategory("Knife", 1)

local HexFolModels = Instance.new("Folder", HexagonFolder)
HexFolModels.Name = "Models"
for _, Model in pairs(game:GetService("ReplicatedStorage").Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = HexFolModels
end

local function modelChange(model, replace)
	if game:GetService("ReplicatedStorage").Viewmodels:FindFirstChild(model) then
		if HexFolModels:FindFirstChild(replace) then
			game.ReplicatedStorage.Viewmodels[model]:Destroy()
			wait()
			local Model1 = Instance.new("Model", game.ReplicatedStorage.Viewmodels)
			local Clone = HexFolModels[replace]:Clone()
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

local HexFolKnifeModel = Instance.new("StringValue", HexagonFolder)
HexFolKnifeModel.Name = "KnifeModel"
local HexFolKnifeBool = Instance.new("BoolValue", HexagonFolder)
HexFolKnifeBool.Name = "KnifeStart"
HexFolKnifeBool.Value = true

SkinsTabKnife:AddToggle("Enable", false, "SkinsTabKnifeEnable", function(val)
	if val == true then
        if HexFolKnifeBool.Value == true then
            HexFolKnifeBool.Value = false
            wait(5)
        end

        if library.pointers.SkinsTabKnifeKnife.value == "Default" then
            modelChange("v_T Knife", "v_T Knife")
            modelChange("v_CT Knife", "v_CT Knife")
        else
            modelChange("v_T Knife", "v_"..library.pointers.SkinsTabKnifeKnife.value)
            modelChange("v_CT Knife", "v_"..library.pointers.SkinsTabKnifeKnife.value)
        end

        local knife_skins = table.foreach(loadstring("return "..readfile("hexagon/weapon_skins.cfg"))(), function(i,v)
            if i == "knives" then
                return v
            end
        end)

        if library.pointers.SkinsTabKnifeKnife.value == "Default" then
            library.pointers.SkinsTabKnifeSkin.options = {"Stock"}
            library.pointers.SkinsTabKnifeSkin:Set("Stock")
        else
            local skins = skinsList(library.pointers.SkinsTabKnifeKnife.value, knife_skins)
            library.pointers.SkinsTabKnifeSkin.options = skins
            if not table.find(library.pointers.SkinsTabKnifeSkin.options, library.pointers.SkinsTabKnifeSkin.value) then
                library.pointers.SkinsTabKnifeSkin:Set("Stock")
            end
        end
		SkinsTabKnifeLoop = HexFolKnifeModel:GetPropertyChangedSignal("Value"):Connect(function()
			pcall(function()
                if library.pointers.SkinsTabKnifeKnife.value == "Default" then
                    modelChange("v_T Knife", "v_T Knife")
                    modelChange("v_CT Knife", "v_CT Knife")
                else
                    modelChange("v_T Knife", "v_"..library.pointers.SkinsTabKnifeKnife.value)
                    modelChange("v_CT Knife", "v_"..library.pointers.SkinsTabKnifeKnife.value)
                end

                local knife_skins = table.foreach(loadstring("return "..readfile("hexagon/weapon_skins.cfg"))(), function(i,v)
                    if i == "knives" then
                        return v
                    end
                end)

                if library.pointers.SkinsTabKnifeKnife.value == "Default" then
                    library.pointers.SkinsTabKnifeSkin.options = {"Stock"}
                    library.pointers.SkinsTabKnifeSkin:Set("Stock")
                else
                    local skins = skinsList(library.pointers.SkinsTabKnifeKnife.value, knife_skins)
                    library.pointers.SkinsTabKnifeSkin.options = skins
                    if not table.find(library.pointers.SkinsTabKnifeSkin.options, library.pointers.SkinsTabKnifeSkin.value) then
                        library.pointers.SkinsTabKnifeSkin:Set("Stock")
                    end
                end
			end)
		end)
	elseif val == false and SkinsTabKnifeLoop then
		SkinsTabKnifeLoop:Disconnect()

		library.pointers.SkinsTabKnifeSkin.options = {"Stock"}
		library.pointers.SkinsTabKnifeSkin:Set("Stock")
		modelChange("v_T Knife", "v_T Knife")
		modelChange("v_CT Knife", "v_CT Knife")
	end
end)
SkinsTabKnife:AddDropdown("Knife", {"-"}, "-", "SkinsTabKnifeKnife", function(val)
    HexFolKnifeModel.Value = val
end)
SkinsTabKnife:AddDropdown("Skin", {"Stock"}, "Stock", "SkinsTabKnifeSkin")

local SkinsTabCategoryCredits = SkinsTab:AddCategory("Credits", 1)

SkinsTabCategoryCredits:AddLabel("Skins tab made by:")
SkinsTabCategoryCredits:AddLabel("SomeoneIdfk")
SkinsTabCategoryCredits:AddLabel("No discord for you.")
SkinsTabCategoryCredits:AddLabel("")
SkinsTabCategoryCredits:AddLabel("Special thanks to these beta testers!")
SkinsTabCategoryCredits:AddLabel("hxg.addictt#8871")
SkinsTabCategoryCredits:AddLabel("Sex Offender#2997")

local SkinsTabGlove = SkinsTab:AddCategory("Gloves", 2)

local HexFolGloveModel = Instance.new("StringValue", HexagonFolder)
HexFolGloveModel.Name = "GloveModel"

SkinsTabGlove:AddToggle("Enable", false, "SkinsTabGloveEnable", function(val)
	if val == true then
		SkinsTabGloveLoop = HexFolGloveModel:GetPropertyChangedSignal("Value"):Connect(function()
			pcall(function()
                local glove_skins = table.foreach(loadstring("return "..readfile("hexagon/weapon_skins.cfg"))(), function(i,v)
					if i == "gloves" then
						return v
					end
				end)

				if library.pointers.SkinsTabGloveGlove.value == "Stock" then
					library.pointers.SkinsTabGloveSkin.options = {"Stock"}
					library.pointers.SkinsTabGloveSkin:Set("Stock")
				else
					local skins = skinsList(library.pointers.SkinsTabGloveGlove.value, glove_skins)
					library.pointers.SkinsTabGloveSkin.options = skins
					if not table.find(library.pointers.SkinsTabGloveSkin.options, library.pointers.SkinsTabGloveSkin.value) then
						library.pointers.SkinsTabGloveSkin:Set("Stock")
					end
				end
			end)
		end)
	elseif val == false and SkinsTabGloveLoop then
		SkinsTabGloveLoop:Disconnect()
	end
end)
SkinsTabGlove:AddDropdown("Glove", {"Stock"}, "Stock", "SkinsTabGloveGlove", function(val)
    HexFolGloveModel.Value = val
end)
SkinsTabGlove:AddDropdown("Skin", {"Stock"}, "Stock", "SkinsTabGloveSkin")

local SkinsTabAdd = SkinsTab:AddCategory("Additional", 2)

waittrueorfalse = true
SkinsTabAdd:AddToggle("Enable", false, "SkinsTabAddEnabled", function(val)
	if val == true then
		prevadd = nil
        old_inventory = cbClient.CurrentInventory
        trueorfalse = true
		SkinsTabAddLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if prevadd ~= library.pointers.SkinsTabAddSelection.value or cbClient.CurrentInventory ~= AllSkinsTable then
                    if trueorfalse == true then
                        trueorfalse = false
                        prevadd = library.pointers.SkinsTabAddSelection.value
					    if waittrueorfalse == true then
						    waittrueorfalse = false
						    wait(3)
					    end
					    local InventoryLoadout = LocalPlayer.PlayerGui.GUI["Inventory&Loadout"]
					    AllSkinsTable = {}
					    if library.pointers.SkinsTabAddSelection.value == "Stock Weapons" then
						    for i,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
							    if v:IsA("Folder") and game.ReplicatedStorage.Weapons:FindFirstChild(v.Name) then
								    table.insert(AllSkinsTable, {v.Name.."_Stock"})
							    end
						    end
                        end
				
					    cbClient.CurrentInventory = AllSkinsTable
				
					    if InventoryLoadout.Visible == true then
						    InventoryLoadout.Visible = false
						    InventoryLoadout.Visible = true
					    end
                    end
				end
				wait(1)
                trueorfalse = true
			end)
		end)
	elseif val == false and SkinsTabAddLoop then
		SkinsTabAddLoop:Disconnect()
        cbClient.CurrentInventory = old_inventory
	end
end)
SkinsTabAdd:AddDropdown("Additional", {"Default", "Stock Weapons"}, "Default", "SkinsTabAddSelection")

local TrollTab = Window:CreateTab("Troll")

local TrollTabGrenade = TrollTab:AddCategory("Grenade")

TrollTabGrenade:AddDropdown("Player", {"-"}, "-", "TrollTabGrenadeSP")
TrollTabGrenade:AddDropdown("Grenade", {"Molotov", "HE Grenade", "Decoy Grenade", "Smoke Grenade", "Incendiary Grenade", "Flashbang"}, "Flashbang", "TrollTabGrenadeSG")
TrollTabGrenade:AddToggle("Enable", false, "TrollTabGrenadeToggle", function(val)
	if val == true then
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name == library.pointers.TrollTabGrenadeSP.value then
				player4 = v
				break
			elseif library.pointers.TrollTabGrenadeSP.value == "-" then
				player4 = nil
				break
			end
		end
		trueorfalse8 = true
		TrollTabGrenadeLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if trueorfalse8 == true and IsAlive(LocalPlayer) and IsAlive(player4) and library.pointers.TrollTabGrenadeSP.value == tostring(player4) then
					trueorfalse8 = false

					cframe = LocalPlayer.Character.HumanoidRootPart.CFrame

					LocalPlayer.Character.HumanoidRootPart.CFrame = player4.Character.HumanoidRootPart.CFrame * CFrame.new(0, 20, -10)
					wait(0.3)
					game:GetService("ReplicatedStorage").Events.ThrowGrenade:FireServer(game:GetService("ReplicatedStorage").Weapons[library.pointers.TrollTabGrenadeSG.value].Model, nil, 25, 35, Vector3.new(0,-100,3), nil, nil)
					wait(0.3)
					LocalPlayer.Character.HumanoidRootPart.CFrame = cframe * CFrame.new(0, 0, 0)

					wait(5)
					trueorfalse8 = true
				elseif library.pointers.TrollTabGrenadeSP.value ~= tostring(player4) then
					if library.pointers.TrollTabGrenadeSP.value == "-" then
						player4 = nil
					else
						for i,v in pairs(game.Players:GetChildren()) do
							if v.Name == library.pointers.TrollTabGrenadeSP.value then
								player4 = v
								break
							end
						end
					end
				end
			end)
		end)
	elseif val == false and TrollTabGrenadeLoop then
		TrollTabGrenadeLoop:Disconnect()
	end
end)

local TrollTabSound = TrollTab:AddCategory("Sound")

TrollTabSound:AddDropdown("Speed", {"Full speed", "Spammy", "Spam", "Slow", "Confusion"}, "Spam", "TrollTabSoundSpeed")
TrollTabSound:AddToggle("Sound Spam", false, "TrollTabSoundSpam", function(val)
	if val == true then
		trueorfalse5 = true
		trueorfalse6 = true
		TrollTabSoundLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if trueorfalse5 == true then
					trueorfalse5 = false
					for i,v in pairs(TableToNames(Sounds)) do
						local soundstring = tostring(v)
						if Sounds[soundstring] ~= nil and Sounds[soundstring]:IsA("Sound") and trueorfalse6 == true then
							Sounds[soundstring]:Play()
							if library.pointers.TrollTabSoundSpeed.value == "Spammy" then
								wait(0.2)
							elseif library.pointers.TrollTabSoundSpeed.value == "Spam" then
								wait(1)
							elseif library.pointers.TrollTabSoundSpeed.value == "Slow" then
								wait(5)
							elseif library.pointers.TrollTabSoundSpeed.value == "Confusion" then
								wait(60)
							end
						end
					end
					trueorfalse5 = true
				end
			end)
		end)
	elseif val == false and TrollTabSoundLoop then
		TrollTabSoundLoop:Disconnect()
		trueorfalse6 = false
	end
end)

local HexFolSoundGunWhizzBool = Instance.new("BoolValue", HexagonFolder)
HexFolSoundGunWhizzBool.Name = "GunWhizzSoundRunning"
HexFolSoundGunWhizzBool.Value = false

TrollTabSound:AddDropdown("Gun Whizz Options", {"Everyone", "Specific"}, "Everyone", "TrollTabSoundGWO")
TrollTabSound:AddDropdown("Gun Whizz Target", {"-"}, "-", "TrollTabSoundGWT")
TrollTabSound:AddToggle("Gun Whizz Skip Localplayer", false, "TrollTabSoundGWSL")
TrollTabSound:AddSlider("Gun Whizz Delay", {1, 30, 5, 1, ""}, "TrollTabSoundGWD")
TrollTabSound:AddToggle("Gun Whizz", false, "TrollTabSoundGW", function(val)
    if val == true then
        HexFolSoundGunWhizzBool.Value = false
        GunWhizzLoop = game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if HexFolSoundGunWhizzBool.Value == false then
                    HexFolSoundGunWhizzBool.Value = true

                    if IsAlive(LocalPlayer) and LocalPlayer.Character:FindFirstChild('Gun') then
                        for _,Player in pairs(game.Players:GetPlayers()) do
                            if library.pointers.TrollTabSoundGWO.value == "Specific" and Player.Name == library.pointers.TrollTabSoundGWT.value then
                                game:GetService('ReplicatedStorage').Events.Whizz:FireServer(Player)
                            elseif library.pointers.TrollTabSoundGWO.value == "Everyone" then
                                if library.pointers.TrollTabSoundGWSL.value and LocalPlayer ~= Player then
                                    game:GetService('ReplicatedStorage').Events.Whizz:FireServer(Player)
                                elseif not library.pointers.TrollTabSoundGWSL.value then
                                    game:GetService('ReplicatedStorage').Events.Whizz:FireServer(Player)
                                end
                            end
                        end
                    end

                    wait(library.pointers.TrollTabSoundGWD.value)

                    HexFolSoundGunWhizzBool.Value = false
                end
            end)
        end)
    elseif val == false and GunWhizzLoop then
        GunWhizzLoop:Disconnect()
    end
end)

local TrollTabSpawn = TrollTab:AddCategory("Spawn Item")

TrollTabSpawn:AddDropdown("Item", Weapons, "-", "TrollTabSpawnSelected")
TrollTabSpawn:AddToggle("Enable", false, "TrollTabSpawnEnable", function(val)
	if val == true then
		trueorfalse7 = true
		TrollTabSpawnLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if trueorfalse7 == true and IsAlive(LocalPlayer) and library.pointers.TrollTabSpawnSelected.value ~= "-" then
					trueorfalse7 = false
					if game.ReplicatedStorage.Weapons:FindFirstChild(library.pointers.TrollTabSpawnSelected.value) then
						game.ReplicatedStorage.Events.Drop:FireServer(
							game.ReplicatedStorage.Weapons[library.pointers.TrollTabSpawnSelected.value],
							LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4),
							game.ReplicatedStorage.Weapons[library.pointers.TrollTabSpawnSelected.value].Ammo.Value,
							game.ReplicatedStorage.Weapons[library.pointers.TrollTabSpawnSelected.value].StoredAmmo.Value,
							false,
							LocalPlayer,
							false,
							false
						)
					end
					wait(0.1)
					trueorfalse7 = true
				end
			end)
		end)
	elseif val == false and TrollTabSpawnLoop then
		TrollTabSpawnLoop:Disconnect()
	end
end)

local TrollTabMap = TrollTab:AddCategory("Map")

TrollTabMap:AddDropdown("Drop Rate", {"Slow", "Laggy", "Server Death"}, "Slow", "TrollTabMapDropRate")
TrollTabMap:AddToggle("Drop Mags", false,  "TrollTabMapDropMags", function(val)
    if val == true then
		ttmdmworker = 0
        TrollTabDropMagLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if IsAlive(LocalPlayer) then
					if library.pointers.TrollTabMapDropRate.value == "Slow" then
						if ttmdmworker == 0 then
							ttmdmworker = 1
							local mag = LocalPlayer.Character.Gun.Mag
							game:GetService("ReplicatedStorage").Events.DropMag:FireServer(mag)
						else
							ttmdmworker = ttmdmworker - 1
						end
					elseif library.pointers.TrollTabMapDropRate.value == "Laggy" then
						game:GetService("RunService").RenderStepped:Wait()
						local mag = LocalPlayer.Character.Gun.Mag
						game:GetService("ReplicatedStorage").Events.DropMag:FireServer(mag)
					elseif library.pointers.TrollTabMapDropRate.value == "Server Death" then
						for i = 1,10,1 do
							local mag = LocalPlayer.Character.Gun.Mag
							game:GetService("ReplicatedStorage").Events.DropMag:FireServer(mag)
						end
					end

					for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do
						if v.Name == "MagDrop" then
							v:Destroy()
						end
					end
				end
			end)
		end)
    elseif val == false and TrollTabDropMagLoop then
        TrollTabDropMagLoop:Disconnect()
    end
end)
TrollTabMap:AddToggle("Remove Preparation", false, "TrollTabMapRP", function(val)
	if val == true then
		if game:FindFirstChild("Workspace"):FindFirstChild("Status"):FindFirstChild("Preparation") then
			WorkSpace.Status.Preparation.Value = false
		end
		TrollTabMapRPLoop = WorkSpace:FindFirstChild("Status"):FindFirstChild("Preparation"):GetPropertyChangedSignal("Value"):Connect(function()
			pcall(function()
				if game:FindFirstChild("Workspace"):FindFirstChild("Status"):FindFirstChild("Preparation") then
					WorkSpace.Status.Preparation.Value = false
				end
			end)
		end)
	elseif val == false and TrollTabMapRPLoop then
		TrollTabMapRPLoop:Disconnect()
	end
end)
TrollTabMap:AddLabel("")
TrollTabMap:AddLabel("Seaside only!")
TrollTabMap:AddToggle("Walk on water", false, "TrollTabMapWOW", function(val)
	if val == true then
		currentmap2 = nil
		TrollTabMapWOWLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if currentmap2 ~= WorkSpace.Map.Origin.Value then
					currentmap2 = WorkSpace.Map.Origin.Value

					if currentmap2 == "de_seaside" then
						originalkillers = WorkSpace:FindFirstChild("Map"):FindFirstChild("Killers")
						clonedkillers = originalkillers:Clone()
						clonedkillers.RoofKiller:Destroy()

						clonedkillers.Parent = originalkillers.Parent
						clonedkillers.WaterKiller.Transparency = 1
						clonedkillers.WaterKiller.CanCollide = true
						clonedkillers.WaterKiller.Name = "WaterBox"

						originalkillers:Destroy()
					else
						WorkSpace:FindFirstChild("Map"):FindFirstChild("Killers"):Destroy()
					end
				else
					wait(1)
				end
			end)
		end)
	elseif val == false and TrollTabMapWOWLoop then
		TrollTabMapWOWLoop:Disconnect()
	end
end)

local TrollTabPlayer = TrollTab:AddCategory("Player", 2)

shittalklibha = {
	"Couldn't handle it?",
	"Oh you're already dead?",
	"Dead so soon?",
	"Oof, step up your game.",
	"Mans got bad cheats. LOL!",
	"When you die with cheats smh.",
	"Oops, sorry left my kill loop on."
}

shittalklibnc = {
	"Oops, sorry left my aimbot on.",
	"Bro how'd you die when I'm bad?",
	"Bruv can't hit his shots.",
    "I guess people just aren't good at this.",
    "People just don't get it.",
    "It's not like I'm a cheater.",
    "It's very simple.",
	"Sorry, my bad.",
	"Nice try.",
	"Better luck next round.",
	"I apologize for not being bad."
}

local shittalklibcuteware = {
	"who? who? who? who? who? who? who? who? who? who? who? who? who? who? who?",
	"cuteware! cuteware! cuteware! cuteware! cuteware! cuteware! cuteware! cuteware! cuteware! cuteware! cuteware!",
	"$$$",
	"cuteware.xyz",
	"1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn 1 sit nn"
}

local shittalklibowlhub = {
	"owlhub.xyz",
	"Owlhub is back!",
	"Owlhub v2 is the best!",
	"nn",
	"Owlhub v2 nn",
	"woohoo",
	"owl owl owl owl owl owl~",
	"Owlhub=#1! Owlhub=#1! Owlhub=#1! Owlhub=#1! Owlhub=#1! Owlhub=#1! Owlhub=#1! Owlhub=#1! Owlhub=#1!"
}

local function trolltabPlayerSay(message)
	game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
		message,
		false,
		"Innocent",
		false,
		true
	)
end

TrollTabPlayer:AddToggle("Talk shit", false, "TrollTabPlayerTS", function(val)
	if val == true then
		TrollTabPlayerTSLoop = game.Players.LocalPlayer.Status.Kills:GetPropertyChangedSignal("Value"):Connect(function()
			pcall(function()
				if game.Players.LocalPlayer.Status.Kills.Value ~= 0 then
					if library.pointers.TrollTabPlayerDelay.value ~= 0 then
						wait(library.pointers.TrollTabPlayerDelay.value)
					end

					if library.pointers.TrollTabPlayerMessages.value == "Default" and IsAlive(LocalPlayer) then
							trolltabPlayerSay(shittalklibnc[math.random(0, #shittalklibnc)])
					elseif library.pointers.TrollTabPlayerMessages.value == "Custom" and IsAlive(LocalPlayer) then
						trolltabPlayerSay(shittalklibcu[math.random(0, #shittalklibcu)])
					elseif library.pointers.TrollTabPlayerMessages.value == "cuteware" and IsAlive(LocalPlayer) then
						trolltabPlayerSay(shittalklibcuteware[math.random(0, #shittalklibcuteware)])
					elseif library.pointers.TrollTabPlayerMessages.value == "owlhub" then
						trolltabPlayerSay(shittalklibowlhub[math.random(0, #shittalklibowlhub)])
					end
				end
			end)
		end)
	elseif val == false and TrollTabPlayerTSLoop then
		TrollTabPlayerTSLoop:Disconnect()
	end
end)
TrollTabPlayer:AddToggle("Spam Chat", false, "TrollTabPlayerSC", function(val)
	if val == true then
		while library.pointers.TrollTabPlayerSC.value == true do
			if library.pointers.TrollTabPlayerMessages.value == "Default" then
				trolltabPlayerSay(shittalklibnc[math.random(0, #shittalklibnc)])
			elseif library.pointers.TrollTabPlayerMessages.value == "Custom" then
				trolltabPlayerSay(shittalklibcu[math.random(0, #shittalklibcu)])
			elseif library.pointers.TrollTabPlayerMessages.value == "cuteware" then
				trolltabPlayerSay(shittalklibcuteware[math.random(0, #shittalklibcuteware)])
			elseif library.pointers.TrollTabPlayerMessages.value == "owlhub" then
				trolltabPlayerSay(shittalklibowlhub[math.random(0, #shittalklibowlhub)])
			end

			wait(2)
		end
	end
end)
TrollTabPlayer:AddDropdown("Messages", {"Default", "Custom", "cuteware", "owlhub"}, "Default", "TrollTabPlayerMessages")
TrollTabPlayer:AddTextBox("Custom Message", "Seperate,,them,,with,,double commas.", "TrollTabPlayerCM", function(val)
	shittalklibcu = {}
	for i,v in pairs(string.split(val, ",,")) do
		table.insert(shittalklibcu, v)
	end
end)
TrollTabPlayer:AddSlider("Delay", {0, 10, 0, 1, ""}, "TrollTabPlayerDelay")
--[[TrollTabPlayer:AddToggle("Remove Head", false, "TrollTabPlayerRH", function(val)
	if val == true then
		TrollTabPlayerRHLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
            	if LocalPlayer.Character["FakeHead"] then
					LocalPlayer.Character["FakeHead"]:Destroy()
				elseif LocalPlayer.Character["HeadHB"] then
					LocalPlayer.Character["HeadHB"]:Destroy()
				elseif LocalPlayer.Character["Head"] then
					LocalPlayer.Character["Head"]:Destroy()
				else
					wait(1)
				end
			end)
		end)
	elseif val == false and TrollTabPlayerRHLoop then
		TrollTabPlayerRHLoop:Disconnect()
	end
end)}]]--

local HexFolSECooldown = Instance.new("NumberValue", HexagonFolder)
HexFolSECooldown.Name = "SlowEveryoneCooldown"
HexFolSECooldown.Value = 0

local function slowPlayer(player)
	if game.Players[player] and LocalPlayer ~= game.Players[player] and IsAlive(LocalPlayer) and IsAlive(game.Players[player]) then
		local Arguments = {
			[1] = game.Players[player].Character.Head,
			[2] = game.Players[player].Character.Head.Position,									
			[3] = "USP",
			[4] = 0,
			[5] = game.ReplicatedStorage.Weapons["USP"].Model,
			[8] = 0, 
			[9] = false,
			[10] = false,
			[11] = Vector3.new(),
			[12] = 0,
			[13] = Vector3.new()
			}

		return Arguments
	end
end

TrollTabPlayer:AddDropdown("Slow Everyone Target", {"All", "Team", "Enemy", "Specific"}, "All", "TrollTabPlayerSET")
TrollTabPlayer:AddDropdown("Slow Specific", {"-"}, "-", "TrollTabPlayerSS")
TrollTabPlayer:AddToggle("Slow Everyone", false, "TrollTabPlayerSE", function(val)
	if val == true then
		HexFolSECooldown.Value = 0

		TrollTabPlayerSELoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if HexFolSECooldown.Value == 0 and IsAlive(LocalPlayer) then
					HexFolSECooldown.Value = library.pointers.TrollTabPlayerSEDelay.value

					if library.pointers.TrollTabPlayerSET.value == "All" then
						for i,v in pairs(game.Players:GetPlayers()) do
							if v ~= LocalPlayer then
								game.ReplicatedStorage.Events.HitPart:FireServer(unpack(slowPlayer(v.Name)))
							end
						end
					elseif library.pointers.TrollTabPlayerSET.value == "Team" then
						for i,v in pairs(game.Players:GetPlayers()) do
							if v ~= LocalPlayer and GetTeamDif(v) == GetTeamDif(LocalPlayer) then
								game.ReplicatedStorage.Events.HitPart:FireServer(unpack(slowPlayer(v.Name)))
							end
						end
					elseif library.pointers.TrollTabPlayerSET.value == "Enemy" then
						for i,v in pairs(game.Players:GetPlayers()) do
							if v ~= LocalPlayer and GetTeamDif(v) ~= GetTeamDif(LocalPlayer) then
								game.ReplicatedStorage.Events.HitPart:FireServer(unpack(slowPlayer(v.Name)))
							end
						end
					elseif library.pointers.TrollTabPlayerSET.value == "Specific" then
						game.ReplicatedStorage.Events.HitPart:FireServer(unpack(slowPlayer(library.pointers.TrollTabPlayerSS.value)))
					end
				elseif IsAlive(LocalPlayer) then
					HexFolSECooldown.Value = HexFolSECooldown.Value - 1
				elseif not IsAlive(LocalPlayer) then
					HexFolSECooldown.Value = library.pointers.TrollTabPlayerSEDelay.value
				end
			end)
		end)
	elseif val == false and TrollTabPlayerSELoop then
		TrollTabPlayerSELoop:Disconnect()
	end
end)
TrollTabPlayer:AddSlider("Slow Everyone Delay", {0, 1000, 60, 5, ""}, "TrollTabPlayerSEDelay")

TrollTabPlayer:AddDropdown("Random Weapon Type", {"Both", "Gun", "Melee"}, "Both", "TrollTabPlayerRWT")
TrollTabPlayer:AddToggle("Random Weapon Kill", false, "TrollTabPlayerRGK")
TrollTabPlayer:AddToggle("Chat Alive", false, "TrollTabPlayerCA")
TrollTabPlayer:AddToggle("Alive Chat", false, "TrollTabPlayerAC")
TrollTabPlayer:AddDropdown("Godmode method", {"Bloxsense Godmode", "Inf HP", "FE God"}, "Bloxsense Godmode", "TrollTabPlayerGMM")
TrollTabPlayer:AddToggle("Godmode", false, "TrollTabPlayerGM", function(val)
    if val == true then
		if IsAlive(LocalPlayer) then
			if library.pointers.TrollTabPlayerGMM.value == "Bloxsense Godmode" then
        		local ReplicatedStorage = game:GetService("ReplicatedStorage");
        		local ApplyGun = ReplicatedStorage.Events.ApplyGun;
        		ApplyGun:FireServer({
            		Model = ReplicatedStorage.Hostage.Hostage,
            		Name = "USP"
        		}, game.Players.LocalPlayer);
			elseif library.pointers.TrollTabPlayerGMM.value == "Inf HP" then
				game.ReplicatedStorage.Events.FallDamage:FireServer(0/0)
				LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
					LocalPlayer.Character.Humanoid.Health = 100
				end)
			elseif library.pointers.TrollTabPlayerGMM.value == "FE God" then
				LocalPlayer.Character.Humanoid.Parent = nil
				Instance.new("Humanoid", LocalPlayer.Character)
			end
		end
        GMLoop = LocalPlayer.CharacterAdded:Connect(function()
            pcall(function()
				if library.pointers.TrollTabPlayerGMM.value == "Bloxsense Godmode" then
					local ReplicatedStorage = game:GetService("ReplicatedStorage");
					local ApplyGun = ReplicatedStorage.Events.ApplyGun;
					ApplyGun:FireServer({
						Model = ReplicatedStorage.Hostage.Hostage,
						Name = "USP"
					}, game.Players.LocalPlayer);
				elseif library.pointers.TrollTabPlayerGMM.value == "Inf HP" then
					wait(0.5)
					game.ReplicatedStorage.Events.FallDamage:FireServer(0/0)
					LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
						LocalPlayer.Character.Humanoid.Health = 100
					end)
				elseif library.pointers.TrollTabPlayerGMM.value == "FE God" then
					wait(0.5)
					LocalPlayer.Character.Humanoid.Parent = nil
					Instance.new("Humanoid", LocalPlayer.Character)
				end
            end)
        end)
    elseif val == false and GMLoop then
        GMLoop:Disconnect()
    end
end)
TrollTabPlayer:AddLabel("RAM Doesn't really work yet, W.I.P.")
TrollTabPlayer:AddToggle("Repeat After Me", false, "TrollTabPlayerRAM")
TrollTabPlayer:AddDropdown("RAM Options", {"Everyone", "Teammates", "Enemies", "Specific", "Alive", "Dead"}, "Everyone", "TrollTabPlayerRAMO")
TrollTabPlayer:AddDropdown("RAM Player", {"-"}, "-", "TrollTabPlayerRAMP")

writefile("hexagon/weapon_ammo.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/weapon_ammo.cfg"))

local weapon_ammo = loadstring("return "..readfile("hexagon/weapon_ammo.cfg"))()

TrollTabPlayer:AddToggle("Infinite Ammo", false, "TrollTabPlayerIA", function(val)
	if val == true then
		IALoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				table.foreach(weapon_ammo, function(i, v)
					if LocalPlayer.Character.EquippedTool.Value == i then
						if v["type"] == "primary" then
							if table.find(library.pointers.TrollTabPlayerAO.value, "Mag") then
								cbClient.ammocount = v["clip"]
							end
							if table.find(library.pointers.TrollTabPlayerAO.value, "Reserve") then
								cbClient.primarystored = v["ammo"]
							end
						elseif v["type"] == "secondary" then
							if table.find(library.pointers.TrollTabPlayerAO.value, "Mag") then
								cbClient.ammocount2 = v["clip"]
							end
							if table.find(library.pointers.TrollTabPlayerAO.value, "Reserve") then
								cbClient.secondarystored = v["ammo"]
							end
						end
					end
				end)
			end)
		end)
	elseif val == false and IALoop then
		IALoop:Disconnect()
	end
end)
TrollTabPlayer:AddMultiDropdown("Ammo Options", {"Mag", "Reserve"}, {""}, "TrollTabPlayerAO")

local TrollTabCategoryCredits = TrollTab:AddCategory("Credits", 2)

TrollTabCategoryCredits:AddLabel("The troll tab is unfinished.")
TrollTabCategoryCredits:AddLabel("")
TrollTabCategoryCredits:AddLabel("Troll tab made by:")
TrollTabCategoryCredits:AddLabel("SomeoneIdfk")
TrollTabCategoryCredits:AddLabel("No discord for you.")
TrollTabCategoryCredits:AddLabel("")
TrollTabCategoryCredits:AddLabel("Special thanks to these beta testers!")
TrollTabCategoryCredits:AddLabel("hxg.addictt#8871")
TrollTabCategoryCredits:AddLabel("Sex Offender#2997")

local SettingsTabCategoryCredits = SettingsTab:AddCategory("Credits", 2)

SettingsTabCategoryCredits:AddLabel("Script - Pawel12d#0272")
SettingsTabCategoryCredits:AddLabel("ESP - Modified Kiriot ESP")
SettingsTabCategoryCredits:AddLabel("UI Library - Modified Phantom Ware")
SettingsTabCategoryCredits:AddLabel("")
SettingsTabCategoryCredits:AddLabel("Special Thanks To:")
SettingsTabCategoryCredits:AddLabel("ny#2817")
SettingsTabCategoryCredits:AddLabel("neeX#3712")
SettingsTabCategoryCredits:AddLabel("MrPolaczekPL#1884")
SettingsTabCategoryCredits:AddLabel("")
SettingsTabCategoryCredits:AddLabel("Don't steal credits or burn in hell.")

local ReportTab = Window:CreateTab("Report")
local ReportCat = ReportTab:AddCategory("Report", 1)

local ChatScript = getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat)
local CheaterColor = Color3.fromRGB(150, 0, 0)
local WarningColor = Color3.fromRGB(255, 255, 0)

local HexFolrmosCooldown = Instance.new("NumberValue", HexagonFolder)
HexFolrmosCooldown.Name = "MessageOnlineSkidsCooldown"
HexFolrmosCooldown.Value = 0

local HexFolrmosSentCooldown = Instance.new("BoolValue", HexagonFolder)
HexFolrmosSentCooldown.Name = "MessageOnlineSkidsSentCooldown"
HexFolrmosSentCooldown.Value = false

local HexFolrmosGameOver = Instance.new("NumberValue", HexagonFolder)
HexFolrmosGameOver.Name = "MessageOnlineSkidsGameOver"
HexFolrmosGameOver.Value = 0

local function reportTableFind(reporttable, value, field)
	local succes = table.foreach(reporttable, function(i, v)
		local succes = table.foreach(v, function(i2, v2)
			if field == "id" and i2 == value or field == "name" and v2 == value then
				return true
			end
		end)

		if succes == true then
			return i
		end
	end)

	if succes then
		return succes
	else
		return false
	end
end

local function checkCheaterSkidsInGame()
	local iteration = 0
	local string = ""
	for i,v in pairs(game.Players:GetPlayers()) do
		if reportTableFind(CheatingSkids, v.UserId, "id") then
			iteration = iteration + 1
			if string == "" then
				string = v.Name
			else
				string = string..", "..v.Name
			end
		end
	end

	if iteration == 0 then
		ChatScript.moveOldMessages()
		ChatScript.createNewMessage("Cheater(s) In The Game", "None Found", CheaterColor, Color3.new(1,1,1), 0.01, nil)

		if library.pointers.ReportCatNEA.value == true then
			game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
				"Found [0] Cheaters In The Game",
				false,
				"Innocent",
				false,
				true
			)
		end
	elseif iteration == 1 then
		ChatScript.moveOldMessages()
		ChatScript.createNewMessage("Cheater In The Game", string, CheaterColor, Color3.new(1,1,1), 0.01, nil)

		if library.pointers.ReportCatNEA.value == true then
			game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
				"Found ["..iteration.."] Cheater In The Game: "..string,
				false,
				"Innocent",
				false,
				true
			)
		end
	elseif iteration > 1 then
		ChatScript.moveOldMessages()
		ChatScript.createNewMessage("["..iteration.."] Cheaters In The Game", string, CheaterColor, Color3.new(1,1,1), 0.01, nil)

		if library.pointers.ReportCatNEA.value == true then
			game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
				"Found ["..iteration.."] Cheater(s) In The Game: "..string,
				false,
				"Innocent",
				false,
				true
			)
		end
	end
end

local function reportListUsernames(reporttable)
	local temp = {"-"}
	table.foreach(reporttable, function(i, v)
		table.foreach(v, function(i2, v2)
			table.insert(temp, v2)
		end)
	end)

	return temp
end

local function reportListUserIds(reporttable)
	local temp = {}
	table.foreach(reporttable, function(i, v)
		table.foreach(v, function(i2, v2)
			table.insert(temp, i2)
		end)
	end)

	return temp
end

local function reportListIdFromUsername(reporttable, username)
	local succes = table.foreach(reporttable, function(i, v)
		local succes = table.foreach(v, function(i2, v2)
			if v2 == username then
				return i2
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

local function reportListUsernameFromId(reporttable, id)
	local succes = table.foreach(reporttable, function(i, v)
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

local function reportHttpGet(id)
	local success, response
	while not success do
		success, response = pcall(function()
			return HttpService:JSONDecode(game:HttpGetAsync("https://api.roblox.com/users/"..id.."/onlinestatus/"))
		end)
		
		wait()
	end

	return response
end

local function reportListOnlineSkids(player)
	if player then
		if reportListIdFromUsername(CheatingSkids, player) then
			return reportHttpGet(reportListIdFromUsername(CheatingSkids, player))
		end
	else
		local temp = {"-"}
		for i,v in pairs(reportListUserIds(CheatingSkids)) do
			local response

			response = reportHttpGet(v)

			if response["IsOnline"] and response.IsOnline == true then
				table.insert(temp, reportListUsernameFromId(CheatingSkids, v))
			end
		end

		return temp
	end

	return false
end

local function reportUpdateLabels(method, table)
	if method == "live" and table then
		if library.pointers["InfoCatOnlineStatus"] then
			library.pointers.InfoCatOnlineStatus:Set("Online: "..tostring(table["IsOnline"]))
		end

		if library.pointers["InfoCatPlayingStatus"] then
			library.pointers.InfoCatPlayingStatus:Set("Playing: "..tostring(table["LastLocation"]))
		end

		return true
	elseif method == "live_reset" then
		if library.pointers["InfoCatOnlineStatus"] then
			library.pointers.InfoCatOnlineStatus:Set("Online:")
		end

		if library.pointers["InfoCatPlayingStatus"] then
			library.pointers.InfoCatPlayingStatus:Set("Playing:")
		end

		return true
	elseif method == "offline" then
		if library.pointers["InfoCatCount"] then
			library.pointers.InfoCatCount:Set("Cheaters In The List: "..(#reportListUsernames(CheatingSkids) - 1))
		end

		return true
	end
	
	return false
end

local function reportMessageOnlineSkids(method)
	if HexFolrmosCooldown.Value == 0 or method == "forced" then
		HexFolrmosSentCooldown.Value = false
		HexFolrmosCooldown.Value = 5000 + ((#reportListUsernames(CheatingSkids) - 1) * 100)
		local temp = reportListOnlineSkids()
		table.remove(temp, 1)
		local iteration = 0
		local page = 1
		local string = ""
		local limit = 5

		if #temp == 0 then
			ChatScript.moveOldMessages()
			ChatScript.createNewMessage("Cheater(s) Online", "None Found", CheaterColor, Color3.new(1,1,1), 0.01, nil)
		elseif #temp == 1 then
			ChatScript.moveOldMessages()
			ChatScript.createNewMessage("Cheater Online", temp[1], CheaterColor, Color3.new(1,1,1), 0.01, nil)
		elseif #temp > 1 then
			for i,v in pairs(temp) do
				iteration = iteration + 1
				if string == "" then
					string = v
				else
					string = string..", "..v
				end

				if #temp > limit and iteration == (page * limit) or #temp > limit and iteration == #temp then
					ChatScript.moveOldMessages()
					ChatScript.createNewMessage("["..#temp.."] <"..page.."> Cheaters Online", string, CheaterColor, Color3.new(1,1,1), 0.01, nil)
					page = page + 1
					string = ""
				elseif #temp < (limit + 1) and iteration == #temp then
					ChatScript.moveOldMessages()
					ChatScript.createNewMessage("["..#temp.."] Cheaters Online", string, CheaterColor, Color3.new(1,1,1), 0.01, nil)
				end
			end
		end
	elseif HexFolrmosSentCooldown.Value == false then
		HexFolrmosSentCooldown.Value = true
		ChatScript.moveOldMessages()
		ChatScript.createNewMessage("Cheater(s) Online", "Is On A Cooldown.", CheaterColor, Color3.new(1,1,1), 0.01, nil)
	end
end

ReportCat:AddDropdown("Player", {"-"}, "-", "ReportPlayer")
ReportCat:AddDropdown("Report List", {"-"}, "-", "ReportList")
ReportCat:AddButton("Add Player", function()
	if library.pointers.ReportPlayer.value ~= "-" then
		if not reportTableFind(CheatingSkids, game.Players[library.pointers.ReportPlayer.value].UserId, "id") then
			table.insert(CheatingSkids, {[game.Players[library.pointers.ReportPlayer.value].UserId] = library.pointers.ReportPlayer.value})
			writefile("hexagon/cheatingskids.cfg", SaveTable(CheatingSkids))
			CheatingSkids = loadstring("return "..readfile("hexagon/cheatingskids.cfg"))()

			ChatScript.moveOldMessages()
			ChatScript.createNewMessage("Cheater Added", library.pointers.ReportPlayer.value, CheaterColor, Color3.new(1,1,1), 0.01, nil)

			library.pointers.ReportPlayer:Set("-")

			library.pointers.ReportList.options = reportListUsernames(CheatingSkids)
			library.pointers.InfoCatSelection.options = reportListUsernames(CheatingSkids)

			reportUpdateLabels("offline")

			checkCheaterSkidsInGame()

			if library.pointers["ReportCatCheckOnline"] and library.pointers.ReportCatCheckOnline.value == true then
				reportMessageOnlineSkids("forced")
			end
		end
	end
end)
ReportCat:AddButton("Remove Player", function()
	if library.pointers.ReportList.value ~= "-" then
		if reportTableFind(CheatingSkids, library.pointers.ReportList.value, "name") then
			table.remove(CheatingSkids, reportTableFind(CheatingSkids, library.pointers.ReportList.value, "name"))

			writefile("hexagon/cheatingskids.cfg", SaveTable(CheatingSkids))
			CheatingSkids = loadstring("return "..readfile("hexagon/cheatingskids.cfg"))()

			ChatScript.moveOldMessages()
			ChatScript.createNewMessage("Cheater Removed", library.pointers.ReportList.value, CheaterColor, Color3.new(1,1,1), 0.01, nil)

			library.pointers.ReportList:Set("-")

			library.pointers.ReportList.options = reportListUsernames(CheatingSkids)
			library.pointers.InfoCatSelection.options = reportListUsernames(CheatingSkids)

			reportUpdateLabels("offline")

			checkCheaterSkidsInGame()

			if library.pointers["ReportCatCheckOnline"] and library.pointers.ReportCatCheckOnline.value == true then
				reportMessageOnlineSkids()
			end
		end
	end
end)
ReportCat:AddButton("Copy Username", function()
	if library.pointers.ReportList.value ~= "-" then
		setclipboard(library.pointers.ReportList.value)
	end
end)
ReportCat:AddButton("Refresh List", function()
	CheatingSkids = loadstring("return "..readfile("hexagon/cheatingskids.cfg"))()

	reportUpdateLabels("offline")
end)
ReportCat:AddToggle("Notify Cheaters", false, "ReportNotify", function(val)
	if val == true then
		ReportNotifyJoinLoop = game.Players.PlayerAdded:Connect(function(plr)
			if reportTableFind(CheatingSkids, plr.UserId, "id") then
				ChatScript.moveOldMessages()
				ChatScript.createNewMessage("Cheater Joined The Game", plr.Name, CheaterColor, Color3.new(1,1,1), 0.01, nil)

				checkCheaterSkidsInGame()

				if library.pointers.ReportCatNE.value == true and library.pointers.ReportCatNEA.value == false then
					game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
						"<Cheater> "..plr.Name..": ".."Joined the game.",
						false,
						"Innocent",
						false,
						true
					)
				end
			end
		end)

		ReportNotifyLeaveLoop = game.Players.PlayerRemoving:Connect(function(plr)
			if reportTableFind(CheatingSkids, plr.UserId, "id") then
				ChatScript.moveOldMessages()
				ChatScript.createNewMessage("Cheater Left The Game", plr.Name, CheaterColor, Color3.new(1,1,1), 0.01, nil)

				checkCheaterSkidsInGame()

				if library.pointers.ReportCatNE.value == true and library.pointers.ReportCatNEA.value == false then
					game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
						"<Cheater> "..plr.Name..": ".."Left the game.",
						false,
						"Innocent",
						false,
						true
					)
				end
			end
		end)

        checkCheaterSkidsInGame()
	elseif val == false and ReportNotifyJoinLoop or val == false and ReportNotifyLeaveLoop then
		ReportNotifyJoinLoop:Disconnect()
		ReportNotifyLeaveLoop:Disconnect()
	end
end)
ReportCat:AddToggle("Notify Everyone", false, "ReportCatNE")
ReportCat:AddToggle("Notify Everyone All", false, "ReportCatNEA")
ReportCat:AddToggle("Check Online", false, "ReportCatCheckOnline", function(val)
	if val == true then
		ReportOnlineJoinLoop = game.Players.PlayerAdded:Connect(function(plr)
			if library.pointers.ReportCatCheckOnJL.value == "Cheaters J/L" and reportTableFind(CheatingSkids, plr.UserId, "id") or library.pointers.ReportCatCheckOnJL.value == "Everyone J/L" then
				reportMessageOnlineSkids()
			end
		end)

		ReportOnlineLeaveLoop = game.Players.PlayerRemoving:Connect(function(plr)
			if library.pointers.ReportCatCheckOnJL.value == "Cheaters" and reportTableFind(CheatingSkids, plr.UserId, "id") or library.pointers.ReportCatCheckOnJL.value == "Everyone" then
				reportMessageOnlineSkids()
			end
		end)

		ReportOnlineRoundLoop = workspace:FindFirstChild("Status").RoundOver:GetPropertyChangedSignal("Value"):Connect(function()
			if library.pointers.ReportCatCheckOnJL.value == "Round End" and workspace.Status.RoundOver.Value == true and checkGamemode() == "casual" or library.pointers.ReportCatCheckOnJL.value == "Round End" and workspace.Status.RoundOver.Value == true and checkGamemode() == "unranked" then
				reportMessageOnlineSkids()
			end
		end)

		ReportOnlineGameLoop = HexFolrmosGameOver:GetPropertyChangedSignal("Value"):Connect(function()
			if library.pointers.ReportCatCheckOnJL.value == "Game End" then
				reportMessageOnlineSkids("forced")
			end
		end)

		reportMessageOnlineSkids()
	elseif val == false and ReportOnlineJoinLoop or val == false and ReportOnlineLeaveLoop or val == false and ReportOnlineRoundLoop or val == false and ReportOnlineGameLoop then
		ReportOnlineJoinLoop:Disconnect()
		ReportOnlineLeaveLoop:Disconnect()
		ReportOnlineRoundLoop:Disconnect()
		ReportOnlineGameLoop:Disconnect()
	end
end)
ReportCat:AddDropdown("Check On", {"Cheaters J/L", "Everyone J/L", "Round End", "Game End"}, "Cheaters", "ReportCatCheckOnJL")

library.pointers.ReportList.options = reportListUsernames(CheatingSkids)

game:GetService("RunService").RenderStepped:Connect(function()
	pcall(function()
		if HexFolrmosCooldown.Value > 0 then
			HexFolrmosCooldown.Value = HexFolrmosCooldown.Value - 1
		end
	end)
end)

local InfoCat = ReportTab:AddCategory("Information", 2)

InfoCat:AddDropdown("Selection", {"-"}, "-", "InfoCatSelection", function(val)
	if val ~= "-" and reportTableFind(CheatingSkids, val, "name") then
		reportUpdateLabels("live_reset")

		local values = reportListOnlineSkids(val)
		
		reportUpdateLabels("live", values)
	else
		reportUpdateLabels("live_reset")
	end
end)
InfoCat:AddLabel("", "InfoCatCount")
InfoCat:AddLabel("Online:", "InfoCatOnlineStatus")
--InfoCat:AddLabel("Playing:", "InfoCatPlayingStatus")

library.pointers.InfoCatSelection.options = reportListUsernames(CheatingSkids)

reportUpdateLabels("offline")

local Collision = {workspace.CurrentCamera, workspace.Ray_Ignore, workspace.Debris} 

local function CollisionTBL(obj)      
	if obj:IsA("Accessory") then      
		table.insert(Collision, obj)      
	end      
	if obj:IsA("Part") then      
		if obj.Name == "HeadHB" or obj.Name == "FakeHead" then      
			table.insert(Collision, obj)      
		end      
	end      
end      

RunService.RenderStepped:Connect(function(step) 
	LastStep = step
	Ping = game.Stats.PerformanceStats.Ping:GetValue()

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
end)

game.Players.PlayerAdded:Connect(function(Player) 
	Player.CharacterAdded:Connect(function(Character)      
		Character.ChildAdded:Connect(function(obj)      
			wait(1)      
			CollisionTBL(obj)      
		end)  
		wait(1)      
		if Character ~= nil then      
			local Value = Instance.new("Vector3Value")      
			Value.Name = "OldPosition"      
			Value.Value = Character.HumanoidRootPart.Position      
			Value.Parent = Character.HumanoidRootPart  
		end
	end)
end)

for _,Player in pairs(game.Players:GetPlayers()) do  
	Player.CharacterAdded:Connect(function(Character)      
		Character.ChildAdded:Connect(function(obj)      
			wait(1)      
			CollisionTBL(obj)      
		end)      
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
		for _,obj in pairs(Player.Character:GetChildren()) do      
			CollisionTBL(obj)
		end     
	end
end

-- Other
game.Players.LocalPlayer.Additionals.TotalDamage.Changed:Connect(function(val)
	if library.pointers.MiscellaneousTabCategoryMainHitSound.value ~= "" and val ~= 0 then
		local marker = Instance.new("Sound")
		marker.Parent = game:GetService("SoundService")
		marker.SoundId = "rbxassetid://"..library.pointers.MiscellaneousTabCategoryMainHitSound.value
		marker.Volume = 3
		marker:Play()
	end
end)

game.Players.LocalPlayer.Status.Kills.Changed:Connect(function(val)
	if library.pointers.MiscellaneousTabCategoryMainKillSound.value ~= "" and val ~= 0 then
		local marker = Instance.new("Sound")
		marker.Parent = game:GetService("SoundService")
		marker.SoundId = "rbxassetid://"..library.pointers.MiscellaneousTabCategoryMainKillSound.value
		marker.Volume = 3
		marker:Play()
	end
end)

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

workspace.CurrentCamera.ChildAdded:Connect(function(new)
	if library.pointers.MiscellaneousTabCategoryGunModsInfiniteAmmo.value == true then
		cbClient.ammocount = 999999
		cbClient.primarystored = 999999
		cbClient.ammocount2 = 999999
		cbClient.secondarystored = 999999
	end

	local Model
	for i,v in pairs(new:GetChildren()) do      
		if v:IsA("Model") and (v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm")) then      
			Model = v      
		end      
	end      
	if Model == nil then return end

	local gunname = cbClient.gun ~= "none" and library.pointers.SkinsTabKnifeEnable.value and cbClient.gun:FindFirstChild("Melee") and library.pointers.SkinsTabKnifeKnife.value 
	if library.pointers.SkinsTabKnifeEnable.value and gunname ~= nil and game:GetService("ReplicatedStorage").Skins:FindFirstChild(gunname) then      
		if library.pointers.SkinsTabKnifeSkin.value ~= "Stock" then      
			MapSkin(gunname, library.pointers.SkinsTabKnifeSkin.value)
		end      
	end

	RArm = Model:FindFirstChild("Right Arm"); LArm = Model:FindFirstChild("Left Arm") 
	if RArm then
		RGlove = RArm:FindFirstChild("Glove") or RArm:FindFirstChild("RGlove")      
		if library.pointers.SkinsTabGloveEnable.value and cbClient.gun ~= "none" and library.pointers.SkinsTabGloveSkin.value ~= "Stock" then      
			if RGlove then RGlove:Destroy() end      
			RGlove = game:GetService("ReplicatedStorage").Gloves.Models[library.pointers.SkinsTabGloveGlove.value].RGlove:Clone()      
			RGlove.Mesh.TextureId = game:GetService("ReplicatedStorage").Gloves[library.pointers.SkinsTabGloveGlove.value][library.pointers.SkinsTabGloveSkin.value].Textures.TextureId      
			RGlove.Parent = RArm      
			RGlove.Transparency = 0      
			RGlove.Welded.Part0 = RArm      
		end
	end
	if LArm then
		LGlove = LArm:FindFirstChild("Glove") or LArm:FindFirstChild("LGlove")      
		if library.pointers.SkinsTabGloveEnable.value and cbClient.gun ~= "none" and library.pointers.SkinsTabGloveSkin.value ~= "Stock" then      
			if LGlove then LGlove:Destroy() end      
			LGlove = game:GetService("ReplicatedStorage").Gloves.Models[library.pointers.SkinsTabGloveGlove.value].LGlove:Clone()       
			LGlove.Mesh.TextureId = game:GetService("ReplicatedStorage").Gloves[library.pointers.SkinsTabGloveGlove.value][library.pointers.SkinsTabGloveSkin.value].Textures.TextureId      
			LGlove.Transparency = 0      
			LGlove.Parent = LArm      
			LGlove.Welded.Part0 = LArm      
		end   
	end

	spawn(function()
		if new.Name == "Arms" and new:IsA("Model") and library.pointers.VisualsTabCategoryViewmodelColorsEnabled.value == true then
			for i,v in pairs(new:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("Right Arm") or v:FindFirstChild("Left Arm") then
					local RightArm = v:FindFirstChild("Right Arm") or nil
					local LeftArm = v:FindFirstChild("Left Arm") or nil
						
					local RightGlove = (RightArm and (RightArm:FindFirstChild("Glove") or RightArm:FindFirstChild("RGlove"))) or nil
					local LeftGlove = (LeftArm and (LeftArm:FindFirstChild("Glove") or LeftArm:FindFirstChild("LGlove"))) or nil
						
					local RightSleeve = RightArm and RightArm:FindFirstChild("Sleeve") or nil
					local LeftSleeve = LeftArm and LeftArm:FindFirstChild("Sleeve") or nil
					
					if library.pointers.VisualsTabCategoryViewmodelColorsArms.value == true then
						if RightArm ~= nil then
							RightArm.Mesh.TextureId = ""
							RightArm.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsArmsTransparency.value
							RightArm.Color = library.pointers.VisualsTabCategoryViewmodelColorsArmsColor.value
							RightArm.Material = library.pointers.VisualsTabCategoryViewmodelColorsArmsMaterial.value
						end
						if LeftArm ~= nil then
							LeftArm.Mesh.TextureId = ""
							LeftArm.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsArmsTransparency.value
							LeftArm.Color = library.pointers.VisualsTabCategoryViewmodelColorsArmsColor.value
							LeftArm.Material = library.pointers.VisualsTabCategoryViewmodelColorsArmsMaterial.value
						end
					end
					
					if library.pointers.VisualsTabCategoryViewmodelColorsGloves.value == true then
						if RightGlove ~= nil then
							if library.pointers.VisualsTabCategoryViewmodelColorsGlovesVisible.value ~= "Texture" then
								RightGlove.Mesh.TextureId = ""
							end
							
							if library.pointers.VisualsTabCategoryViewmodelColorsGlovesVisible.value == "Color" then
								RightGlove.Color = library.pointers.VisualsTabCategoryViewmodelColorsGlovesColor.value
							end

							RightGlove.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsGlovesTransparency.value
							RightGlove.Material = library.pointers.VisualsTabCategoryViewmodelColorsGlovesMaterial.value
						end
						if LeftGlove ~= nil then
							if library.pointers.VisualsTabCategoryViewmodelColorsGlovesVisible.value ~= "Texture" then
								LeftGlove.Mesh.TextureId = ""
							end
							
							if library.pointers.VisualsTabCategoryViewmodelColorsGlovesVisible.value == "Color" then
								LeftGlove.Color = library.pointers.VisualsTabCategoryViewmodelColorsGlovesColor.value
							end

							LeftGlove.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsGlovesTransparency.value
							LeftGlove.Material = library.pointers.VisualsTabCategoryViewmodelColorsGlovesMaterial.value
						end
					end

					if library.pointers.VisualsTabCategoryViewmodelColorsSleeves.value == true then
						if RightSleeve ~= nil then
							RightSleeve.Mesh.TextureId = ""
							RightSleeve.Color = library.pointers.VisualsTabCategoryViewmodelColorsSleevesColor.value
							RightSleeve.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsSleevesTransparency.value
							RightSleeve.Material = library.pointers.VisualsTabCategoryViewmodelColorsSleevesMaterial.value
						end
						if LeftSleeve ~= nil then
							LeftSleeve.Mesh.TextureId = ""
							LeftSleeve.Color = library.pointers.VisualsTabCategoryViewmodelColorsSleevesColor.value
							LeftSleeve.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsSleevesTransparency.value
							LeftSleeve.Material = library.pointers.VisualsTabCategoryViewmodelColorsSleevesMaterial.value
						end
					end
				elseif library.pointers.VisualsTabCategoryViewmodelColorsWeapons.value == true and v:IsA("BasePart") and not table.find({"Right Arm", "Left Arm", "Flash"}, v.Name) and v.Transparency ~= 1 then
					if library.pointers.VisualsTabCategoryViewmodelColorsWeaponsVisible.value ~= "Texture" then
						if v:IsA("MeshPart") then v.TextureID = "" end
						if v:FindFirstChildOfClass("SpecialMesh") then v:FindFirstChildOfClass("SpecialMesh").TextureId = "" end
					end

					if library.pointers.VisualsTabCategoryViewmodelColorsWeaponsVisible.value == "Color" then
						v.Color = library.pointers.VisualsTabCategoryViewmodelColorsWeaponsColor.value
					end

					v.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsWeaponsTransparency.value
					v.Material = library.pointers.VisualsTabCategoryViewmodelColorsWeaponsMaterial.value
				end
			end
		end
	end)
end)

workspace.ChildAdded:Connect(function(new)
	if new.Name == "C4" and new:IsA("Model") and library.pointers.VisualsTabCategoryBombESPEnabled.value == true then
		local BombTimer = 40
		
		local BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Parent = new
		BillboardGui.Adornee = new
		BillboardGui.Active = true
		BillboardGui.AlwaysOnTop = true
		BillboardGui.LightInfluence = 1
		BillboardGui.Size = UDim2.new(0, 50, 0, 50)
		
		if table.find(library.pointers.VisualsTabCategoryBombESPInfo.value, "Text") then
			local TextLabelText = Instance.new("TextLabel")
			TextLabelText.Parent = BillboardGui
			TextLabelText.ZIndex = 2
			TextLabelText.BackgroundTransparency = 1
			TextLabelText.Size = UDim2.new(1, 0, 1, 0)
			TextLabelText.Font = Enum.Font.SourceSansBold
			TextLabelText.TextColor3 = library.pointers.VisualsTabCategoryBombESPColor.value
			TextLabelText.TextSize = 14
			TextLabelText.TextYAlignment = Enum.TextYAlignment.Top
			TextLabelText.Text = tostring(new.Name)
		end
		
		if table.find(library.pointers.VisualsTabCategoryBombESPInfo.value, "Icon") then
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Parent = BillboardGui
			ImageLabel.ZIndex = 1
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Size = UDim2.new(1, 0, 1, 0)
			ImageLabel.ImageColor3 = library.pointers.VisualsTabCategoryBombESPColor.value
			ImageLabel.Image = tostring(require(game.ReplicatedStorage.GetIcon).getWeaponOfKiller(new.Name))
			ImageLabel.ScaleType = Enum.ScaleType.Fit
		end
		
		if table.find(library.pointers.VisualsTabCategoryBombESPInfo.value, "Timer") then
			local TextLabelBombTimer = Instance.new("TextLabel")
			TextLabelBombTimer.Parent = BillboardGui
			TextLabelBombTimer.ZIndex = 2
			TextLabelBombTimer.BackgroundTransparency = 1
			TextLabelBombTimer.Size = UDim2.new(1, 0, 1, 0)
			TextLabelBombTimer.Font = Enum.Font.SourceSansBold
			TextLabelBombTimer.TextColor3 = library.pointers.VisualsTabCategoryBombESPColor.value
			TextLabelBombTimer.TextSize = 14
			TextLabelBombTimer.TextYAlignment = Enum.TextYAlignment.Bottom
			TextLabelBombTimer.Text = tostring(BombTimer.. "/40")
			
			spawn(function()
				repeat
					wait(1)
					BombTimer = BombTimer - 1
					TextLabelBombTimer.Text = tostring(BombTimer.. "/40")
				until BombTimer == 0 or workspace.Status.RoundOver.Value == true
			end)
		end
	end
end)

LocalPlayer.CharacterAdded:Connect(CharacterAdded)

workspace.Ray_Ignore.Smokes.ChildAdded:Connect(function(child)
	if child.Name == "Smoke" and table.find(library.pointers.VisualsTabCategoryOthersRemoveEffects.value, "Smoke") then
		wait()
		child:Remove()
	end
end)

workspace.Debris.ChildAdded:Connect(function(child)
	if child:IsA("BasePart") and game.ReplicatedStorage.Weapons:FindFirstChild(child.Name) and library.pointers.VisualsTabCategoryDroppedESPEnabled.value == true then
		wait()
		
		local BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Parent = child
		BillboardGui.Adornee = child
		BillboardGui.Active = true
		BillboardGui.AlwaysOnTop = true
		BillboardGui.LightInfluence = 1
		BillboardGui.Size = UDim2.new(0, 50, 0, 50)
		
		if table.find(library.pointers.VisualsTabCategoryDroppedESPInfo.value, "Icon") then
			local ImageLabel = Instance.new("ImageLabel")
			ImageLabel.Parent = BillboardGui
			ImageLabel.ZIndex = 1
			ImageLabel.BackgroundTransparency = 1
			ImageLabel.Size = UDim2.new(1, 0, 1, 0)
			ImageLabel.ImageColor3 = library.pointers.VisualsTabCategoryDroppedESPColor.value
			ImageLabel.Image = tostring(require(game.ReplicatedStorage.GetIcon).getWeaponOfKiller(child.Name))
			ImageLabel.ScaleType = Enum.ScaleType.Fit
		end
		
		if table.find(library.pointers.VisualsTabCategoryDroppedESPInfo.value, "Text") then
			local TextLabelText = Instance.new("TextLabel")
			TextLabelText.Parent = BillboardGui
			TextLabelText.ZIndex = 2
			TextLabelText.BackgroundTransparency = 1
			TextLabelText.Size = UDim2.new(1, 0, 1, 0)
			TextLabelText.Font = Enum.Font.SourceSansBold
			TextLabelText.TextColor3 = library.pointers.VisualsTabCategoryDroppedESPColor.value
			TextLabelText.TextSize = 14
			TextLabelText.TextYAlignment = Enum.TextYAlignment.Top
			TextLabelText.Text = tostring(child.Name)
		end
		
		if table.find(library.pointers.VisualsTabCategoryDroppedESPInfo.value, "Ammo") and game.ReplicatedStorage.Weapons[child.Name].StoredAmmo.Value ~= 0 then
			local TextLabelAmmo = Instance.new("TextLabel")
			TextLabelAmmo.Parent = BillboardGui
			TextLabelAmmo.ZIndex = 2
			TextLabelAmmo.BackgroundTransparency = 1
			TextLabelAmmo.Size = UDim2.new(1, 0, 1, 0)
			TextLabelAmmo.Font = Enum.Font.SourceSansBold
			TextLabelAmmo.TextColor3 = library.pointers.VisualsTabCategoryDroppedESPColor.value
			TextLabelAmmo.TextSize = 14
			TextLabelAmmo.TextYAlignment = Enum.TextYAlignment.Bottom
			TextLabelAmmo.Text = tostring(child:WaitForChild("Ammo").Value.. "/" ..child:WaitForChild("StoredAmmo").Value)
		end
	elseif child:IsA("MeshPart") and not game.ReplicatedStorage.Weapons:FindFirstChild(child.Name) and child:WaitForChild("Handle2") and library.pointers.VisualsTabCategoryGrenadeESPEnabled.value == true then
		wait()
		
		gtype = nil
		
		if child.Handle2.TextureID == game.ReplicatedStorage.Weapons["HE Grenade"].Model.Handle2.TextureID then
			gtype = "HE Grenade"
		elseif child.Handle2.TextureID == game.ReplicatedStorage.Weapons["Smoke Grenade"].Model.Handle2.TextureID then
			gtype = "Smoke Grenade"
		elseif child.Handle2.TextureID == game.ReplicatedStorage.Weapons["Incendiary Grenade"].Model.Handle2.TextureID then
			gtype = "Incendiary Grenade"
		elseif child.Handle2.TextureID == game.ReplicatedStorage.Weapons["Molotov"].Model.Handle2.TextureID then
			gtype = "Molotov"
		elseif child.Handle2.TextureID == game.ReplicatedStorage.Weapons["Flashbang"].Model.Handle2.TextureID then
			gtype = "Flashbang"
		elseif child.Handle2.TextureID == game.ReplicatedStorage.Weapons["Decoy Grenade"].Model.Handle2.TextureID then
			gtype = "Decoy Grenade"
		end
		
		if gtype ~= nil then
			local BillboardGui = Instance.new("BillboardGui")
			BillboardGui.Parent = child
			BillboardGui.Adornee = child
			BillboardGui.Active = true
			BillboardGui.AlwaysOnTop = true
			BillboardGui.LightInfluence = 1
			BillboardGui.Size = UDim2.new(0, 50, 0, 50)
			
			if table.find(library.pointers.VisualsTabCategoryGrenadeESPInfo.value, "Icon") then
				local ImageLabel = Instance.new("ImageLabel")
				ImageLabel.Parent = BillboardGui
				ImageLabel.ZIndex = 1
				ImageLabel.BackgroundTransparency = 1
				ImageLabel.Size = UDim2.new(1, 0, 1, 0)
				ImageLabel.ImageColor3 = library.pointers.VisualsTabCategoryGrenadeESPColor.value
				ImageLabel.Image = tostring(require(game.ReplicatedStorage.GetIcon).getWeaponOfKiller(gtype))
				ImageLabel.ScaleType = Enum.ScaleType.Fit
			end
			
			if table.find(library.pointers.VisualsTabCategoryGrenadeESPInfo.value, "Text") then
				local TextLabelText = Instance.new("TextLabel")
				TextLabelText.Parent = BillboardGui
				TextLabelText.ZIndex = 2
				TextLabelText.BackgroundTransparency = 1
				TextLabelText.Size = UDim2.new(1, 0, 1, 0)
				TextLabelText.Font = Enum.Font.SourceSansBold
				TextLabelText.TextColor3 = library.pointers.VisualsTabCategoryGrenadeESPColor.value
				TextLabelText.TextSize = 14
				TextLabelText.TextYAlignment = Enum.TextYAlignment.Top
				TextLabelText.Text = tostring(gtype)
			end
		end
	elseif child.Name == "Bullet" and table.find(library.pointers.VisualsTabCategoryOthersRemoveEffects.value, "Bullet Holes") then
		wait()
		child:Remove()
	elseif child.Name == "SurfaceGui" and table.find(library.pointers.VisualsTabCategoryOthersRemoveEffects.value, "Blood") then
		wait()
		child:Remove()
	end
end)

game.ReplicatedStorage.Events.SendMsg.OnClientEvent:Connect(function(message)
	if library.pointers.MiscellaneousTabCategoryMainAntiVoteKick.value == true then
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

LocalPlayer.PlayerGui.Menew.MainFrame.SkinShop.MouseButton1Click:Connect(function()
	if LocalPlayer.PlayerGui.Menew.MainFrame.SkinShop.Warn.Visible == true and library.pointers.MiscellaneousTabCategoryMainUnlockShopWhileAlive.value == true then
		LocalPlayer.PlayerGui.Menew.ShopFrame.Position = UDim2.new(1, 0, 0, 0)
		LocalPlayer.PlayerGui.Menew.ShopFrame.Visible = true
		LocalPlayer.PlayerGui.Menew.ShopFrame:TweenPosition(UDim2.new(0, 0, 0, 0))
		LocalPlayer.PlayerGui.Menew.MainFrame:TweenPosition(UDim2.new(-1, 0, 0, 0))
	end
end)

UserInputService.InputBegan:Connect(function(key, isFocused)
	if key.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:GetFocusedTextBox() == nil then
		if library.pointers.MiscellaneousTabCategoryGunModsPlant.value == "Instant" and IsAlive(LocalPlayer) and LocalPlayer.Character.EquippedTool.Value == "C4" then
			game.ReplicatedStorage.Events.PlantC4:FireServer((LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -2.75, 0)) * CFrame.Angles(math.rad(90), 0, math.rad(180)), GetSite())
		elseif library.pointers.MiscellaneousTabCategoryGunModsPlant.value == "Anywhere" and IsAlive(LocalPlayer) and LocalPlayer.Character.EquippedTool.Value == "C4" then
			PlantC4()
		end
	elseif key.KeyCode == Enum.KeyCode.E then
		if library.pointers.MiscellaneousTabCategoryGunModsDefuse.value == "Instant" and workspace:FindFirstChild("C4") then
			spawn(function()
				wait(0.25)
				if IsAlive(LocalPlayer) and workspace:FindFirstChild("C4") and workspace.C4:FindFirstChild("Defusing") and LocalPlayer.PlayerGui.GUI.Defusal.Visible == true and workspace.C4.Defusing.Value == LocalPlayer then
					LocalPlayer.Backpack.Defuse:FireServer(workspace.C4)
				end
			end)
		elseif library.pointers.MiscellaneousTabCategoryGunModsDefuse.value == "Anywhere" and IsAlive(LocalPlayer) then
			DefuseC4()
		end
	elseif key.KeyCode == library.pointers.SettingsTabCategoryUIToggleKeybind.value then
		library.base.Window.Visible = not library.base.Window.Visible
	end
end)

Mouse.Move:Connect(function()
	if FOVCircle.Visible then
		FOVCircle.Position = UserInputService:GetMouseLocation()
	end
end)

Hint.Text = "Hexagon | Setting up hooks..."

hookfunc(getrenv().xpcall, function() end)

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

local ignoreMessageList = {
	"Fall back!",
	"Cheer!",
	"Affirmative.",
	"Negative.",
	"Thanks.",
	"Enemy spotted!",
	"Need backup!",
	"You take the point.",
	"Sector clear.",
	"I'm in position.",
	"Go!",
	"Fall back!",
	"Stick together team.",
	"Hold this position.",
	"Follow me.",
	"Nice!"
}

function sayMessage(mess, plr)
	if plr.Name ~= LocalPlayer.Name then
		local var = table.foreach(ignoreMessageList, function(k, v)
			if mess == v then
				return false
			end
		end)
		if var ~= false then
			if library.pointers.TrollTabPlayerRAMO.value == "Everyone" then
				if GetTeamDif(LocalPlayer) ~= "Spectator" then
					if IsAlive(LocalPlayer) or library.pointers.TrollTabPlayerCA.value == true then
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							"<"..plr.Name.."> "..mess,
							false,
							"Innocent",
							false,
							true
						)
					else
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							"<"..plr.Name.."> "..mess,
							false,
							"Innocent",
							true,
							true
						)
					end
				end
			elseif library.pointers.TrollTabPlayerRAMO.value == "Specific" then
				if plr.Name == library.pointers.TrollTabPlayerRAMP.value then
					if GetTeamDif(LocalPlayer) ~= "Spectator" then
						if IsAlive(LocalPlayer) or library.pointers.TrollTabPlayerCA.value == true then
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
								"<"..plr.Name.."> "..mess,
								false,
								"Innocent",
								false,
								true
							)
						else
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
								"<"..plr.Name.."> "..mess,
								false,
								"Innocent",
								true,
								true
							)
						end
					end
				end
			elseif library.pointers.TrollTabPlayerRAMO.value == "Teammates" then
				if GetTeamDif(LocalPlayer) ~= "Spectator" and GetTeamDif(LocalPlayer) == GetTeamDif(plr) then
					if IsAlive(LocalPlayer) or library.pointers.TrollTabPlayerCA.value == true then
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							"<"..plr.Name.."> "..mess,
							false,
							"Innocent",
							false,
							true
						)
					else
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							"<"..plr.Name.."> "..mess,
							false,
							"Innocent",
							true,
							true
						)
					end
				end
			elseif library.pointers.TrollTabPlayerRAMO.value == "Enemies" then
				if GetTeamDif(LocalPlayer) ~= "Spectator" and GetTeamDif(LocalPlayer) ~= GetTeamDif(plr) then
					if IsAlive(LocalPlayer) or library.pointers.TrollTabPlayerCA.value == true then
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							"<"..plr.Name.."> "..mess,
							false,
							"Innocent",
							false,
							true
						)
					else
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							"<"..plr.Name.."> "..mess,
							false,
							"Innocent",
							true,
							true
						)
					end
				end
			elseif library.pointers.TrollTabPlayerRAMO.value == "Alive" then
				if IsAlive(plr) then
					if GetTeamDif(LocalPlayer) ~= "Spectator" then
						if IsAlive(LocalPlayer) or library.pointers.TrollTabPlayerCA.value == true then
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
								"<"..plr.Name.."> "..mess,
								false,
								"Innocent",
								false,
								true
							)
						else
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
								"<"..plr.Name.."> "..mess,
								false,
								"Innocent",
								true,
								true
							)
						end
					end
				end
			elseif library.pointers.TrollTabPlayerRAMO.value == "Dead" then
				if not IsAlive(plr) then
					if GetTeamDif(LocalPlayer) ~= "Spectator" then
						if IsAlive(LocalPlayer) or library.pointers.TrollTabPlayerCA.value == true then
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
								"<"..plr.Name.."> "..mess,
								false,
								"Innocent",
								false,
								true
							)
						else
							game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
								"<"..plr.Name.."> "..mess,
								false,
								"Innocent",
								true,
								true
							)
						end
					end
				end
			end
		end
	end
end

local mt = getrawmetatable(game)
local ChatScript = getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat)
local AliveChatColor = Color3.fromRGB(50, 50, 50)
local createNewMessage = getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat).createNewMessage

if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end

oldNamecall = hookfunc(mt.__namecall, newcclosure(function(self, ...)
    local method = getnamecallmethod()
	local callingscript = getcallingscript()
    local args = {...}
	
	if not checkcaller() then
		if method == "Kick" then
			return
		elseif method == "FireServer" then
			if self.Name == "ReplicateCamera" then
				if library.pointers.MiscellaneousTabCategoryMainAntiSpectators.value == true then
					args[1] = CFrame.new()
				elseif library.pointers.VisualsTabCategoryThirdPersonEnabled.value == true then
					args[1] = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -library.pointers.VisualsTabCategoryThirdPersonDistance.value)
				end
			elseif self.Name == "ControlTurn" and library.pointers.AimbotTabCategoryAntiAimbotEnabled.value == true and library.pointers.AimbotTabCategoryAntiAimbotPitch.value ~= "Default" then
				local angle = (
					library.pointers.AimbotTabCategoryAntiAimbotPitch.value == "Up" and 1 or
					library.pointers.AimbotTabCategoryAntiAimbotPitch.value == "Down" and -1 or
					library.pointers.AimbotTabCategoryAntiAimbotPitch.value == "Boneless" and -5 or
					library.pointers.AimbotTabCategoryAntiAimbotPitch.value == "Random" and (math.random(1,2) == 1 and 1 or -1)
				)
				if angle then
					args[1] = angle
				end
			elseif string.len(self.Name) == 38 then
				return wait(99e99)
			elseif self.Name == "ApplyGun" and args[1] == game.ReplicatedStorage.Weapons.Banana or args[1] == game.ReplicatedStorage.Weapons["Flip Knife"] then
				args[1] = game.ReplicatedStorage.Weapons.Karambit
			elseif self.Name == "HitPart" then
				args[8] = args[8] * library.pointers.MiscellaneousTabCategoryGunModsDamageMultiplier.value

				if library.pointers.TrollTabPlayerRGK.value == true then
					local rgun = killallguns[library.pointers.TrollTabPlayerRWT.value][math.random(1,#killallguns[library.pointers.TrollTabPlayerRWT.value])]
					args[3] = rgun
					args[4] = args[4]
					args[5] = game.ReplicatedStorage.Weapons[rgun].Model
					args[8] = args[8]
					args[12] = args[12]
				end

				if library.pointers.VisualsTabCategoryOthersBulletTracers.value == true then
					spawn(function()
						local BulletTracers = Instance.new("Part")
						BulletTracers.Anchored = true
						BulletTracers.CanCollide = false
						BulletTracers.Material = "ForceField"
						BulletTracers.Color = library.pointers.VisualsTabCategoryOthersBulletTracersColor.value
						BulletTracers.Size = Vector3.new(0.1, 0.1, (LocalPlayer.Character.Head.CFrame.p - args[2]).magnitude)
						BulletTracers.CFrame = CFrame.new(LocalPlayer.Character.Head.CFrame.p, args[2]) * CFrame.new(0, 0, -BulletTracers.Size.Z / 2)
						BulletTracers.Name = "BulletTracers"
						BulletTracers.Parent = workspace.CurrentCamera
						wait(3)
						BulletTracers:Destroy()
					end)
				end
				
				if library.pointers.VisualsTabCategoryOthersBulletImpacts.value == true then
					spawn(function()
						local BulletImpacts = Instance.new("Part")
						BulletImpacts.Anchored = true
						BulletImpacts.CanCollide = false
						BulletImpacts.Material = "ForceField"
						BulletImpacts.Color = library.pointers.VisualsTabCategoryOthersBulletImpactsColor.value
						BulletImpacts.Size = Vector3.new(0.25, 0.25, 0.25)
						BulletImpacts.CFrame = CFrame.new(args[2])
						BulletImpacts.Name = "BulletImpacts"
						BulletImpacts.Parent = workspace.CurrentCamera
						wait(3)
						BulletImpacts:Destroy()
					end)
				end
				
				if args[1].Parent == workspace.HexagonFolder then
					if args[1].PlayerName.Value.Character and args[1].PlayerName.Value.Character.Head ~= nil then
						args[1] = args[1].PlayerName.Value.Character.Head
					end
				end
			elseif self.Name == "test" then
				return wait(99e99)
			elseif self.Name == "FallDamage" and (library.pointers.MiscellaneousTabCategoryMainNoFallDamage.value == true or JumpBug == true) then
				return
			elseif self.Name == "BURNME" and library.pointers.MiscellaneousTabCategoryMainNoFireDamage.value == true then
				return
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
			elseif self.Name == "PlayerChatted" and library.pointers.TrollTabPlayerCA.value == true then
				args[2] = false
				args[3] = "Innocent"
				args[4] = false
				args[5] = false
			end
		elseif method == "InvokeServer" then
			if self.Name == "Moolah" then
				return wait(99e99)
			elseif self.Name == "Hugh" then
				return wait(99e99)
			elseif self.Name == "SheHeckMe" and library.pointers.ReportCatCheckOnJL.value == "Game End" then
				HexFolrmosGameOver.Value = HexFolrmosGameOver.Value + 1

				return oldNamecall(self, unpack(args))
			elseif self.Name == "Filter" and callingscript == LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat then
				if args[2] == LocalPlayer then
					if library.pointers.MiscellaneousTabCategoryMainNoChatFilter.value == true then
                    	return args[1]
					end
                elseif args[2] ~= LocalPlayer then
					if library.pointers.TrollTabPlayerAC.value == true and game.Workspace.Status.RoundOver.Value == false and warmupCheck() == false then
						if IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" then
							if not IsAlive(args[2]) then
								spawn(function()
									if reportTableFind(CheatingSkids, args[2].UserId, "id") then
										ChatScript.moveOldMessages()
										ChatScript.createNewMessage("<Alive Chat> <Cheater> "..args[2].Name, args[1], CheaterColor, Color3.new(1,1,1), 0.01, nil)
                                    else
										ChatScript.moveOldMessages()
										ChatScript.createNewMessage("<Alive Chat> "..args[2].Name, args[1], AliveChatColor, Color3.new(1,1,1), 0.01, nil)
									end
								end)
							end
						end
					end
                    
					if library.pointers.TrollTabPlayerRAM.value == true then
						sayMessage(args[1], args[2])
					end

					if library.pointers.MiscellaneousTabCategoryMainNoChatFilter.value == true then
                        return args[1]
					end
                end
			end
		elseif method == "FindPartOnRayWithIgnoreList" and args[2][1] == workspace.Debris then
			if library.pointers.MiscellaneousTabCategoryGunModsWallbang.value == true then
				table.insert(args[2], workspace.Map)
			end
			
			if IsAlive(LocalPlayer) and SilentRagebot.target ~= nil then
				args[1] = Ray.new(LocalPlayer.Character.Head.Position, (SilentRagebot.target.Position - LocalPlayer.Character.Head.Position).unit * (game.ReplicatedStorage.Weapons[game.Players.LocalPlayer.Character.EquippedTool.Value].Range.Value * 0.1))
			elseif IsAlive(LocalPlayer) and SilentLegitbot.target ~= nil then
				local hitchance = math.random(0, 100)
				
				if hitchance <= library.pointers.AimbotTabCategoryLegitbotHitchance.value then
					args[1] = Ray.new(LocalPlayer.Character.Head.Position, (SilentLegitbot.target.Position - LocalPlayer.Character.Head.Position).unit * (game.ReplicatedStorage.Weapons[game.Players.LocalPlayer.Character.EquippedTool.Value].Range.Value * 0.1))
				end
			end
		elseif method == "SetPrimaryPartCFrame" and self.Name == "Arms" and library.pointers.VisualsTabCategoryViewmodelEnabled.value == true then
			args[1] = args[1] * CFrame.new(Vector3.new(math.rad(library.pointers.VisualsTabCategoryViewmodelOffsetX.value-180),math.rad(library.pointers.VisualsTabCategoryViewmodelOffsetY.value-180),math.rad(library.pointers.VisualsTabCategoryViewmodelOffsetZ.value-180))) * CFrame.Angles(0, 0, math.rad(library.pointers.VisualsTabCategoryViewmodelOffsetRoll.value-180))
		end
	end
	
	return oldNamecall(self, unpack(args))
end))

oldNewIndex = hookfunc(getrawmetatable(game.Players.LocalPlayer.PlayerGui.Client).__newindex, newcclosure(function(self, idx, val)
	if not checkcaller() then
		if self.Name == "Humanoid" and idx == "WalkSpeed" and val ~= 0 and isBhopping == true then 
			val = curVel
		elseif self.Name == "Humanoid" and idx == "JumpPower" and val ~= 0 and JumpBug == true then
			spawn(function() cbClient.UnCrouch() end)
			val = val * 1.25
		elseif self.Name == "Crosshair" and idx == "Visible" and val == false and LocalPlayer.PlayerGui.GUI.Crosshairs.Scope.Visible == false and library.pointers.VisualsTabCategoryOthersForceCrosshair.value == true then
			val = true
		end
	end
	
    return oldNewIndex(self, idx, val)
end))

oldIndex = hookfunc(getrawmetatable(game.Players.LocalPlayer.PlayerGui.Client).__index, newcclosure(function(self, key)
	if key == "Value" then
		if self.Name == "Auto" and library.pointers.MiscellaneousTabCategoryGunModsFullAuto.value == true then
			return true
		elseif self.Name == "FireRate" and library.pointers.MiscellaneousTabCategoryGunModsRapidFire.value == true then
			return 0.001
		elseif self.Name == "ReloadTime" and library.pointers.MiscellaneousTabCategoryGunModsInstantReload.value == true then
			return 0.001
		elseif self.Name == "EquipTime" and library.pointers.MiscellaneousTabCategoryGunModsInstantEquip.value == true then
			return 0.001
		elseif self.Name == "Penetration" and library.pointers.MiscellaneousTabCategoryGunModsInfinitePenetration.value == true then
			return 200
		elseif self.Name == "Range" and library.pointers.MiscellaneousTabCategoryGunModsInfiniteRange.value == true then
			return 9999
		elseif self.Name == "RangeModifier" and library.pointers.MiscellaneousTabCategoryGunModsInfiniteRange.value == true then
			return 100
		elseif (self.Name == "Spread" or self.Parent.Name == "Spread") and library.pointers.MiscellaneousTabCategoryGunModsNoSpread.value == true then
			return 0
		elseif (self.Name == "AccuracyDivisor" or self.Name == "AccuracyOffset") and library.pointers.MiscellaneousTabCategoryGunModsNoSpread.value == true then
			return 0.001
		end
	end

    return oldIndex(self, key)
end))

getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat).createNewMessage = function(plr, msg, teamcolor, msgcolor, offset, line)
	if LocalPlayer.Name == plr then
		return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
	elseif teamcolor == WarningColor then
		return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
	elseif teamcolor == AliveChatColor then
		return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
	elseif teamcolor == CheaterColor then
		return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
	elseif game.Players:FindFirstChild(plr) then
        if reportTableFind(CheatingSkids, game.Players[plr].UserId, "id") then
			return createNewMessage("<Cheater> "..plr, msg, CheaterColor, msgcolor, offset, line)
        elseif IsAlive(LocalPlayer) and GetTeamDif(LocalPlayer) ~= "Spectator" and IsAlive(game.Players[plr]) == false and workspace.Status.RoundOver.Value == false and warmupCheck() == false and offset == 0.01 then
            return createNewMessage("<Warning> "..plr, msg, WarningColor, msgcolor, offset, line)
        elseif IsAlive(LocalPlayer) == false and IsAlive(game.Players[plr]) == false and workspace.Status.RoundOver.Value == false and warmupCheck() == false and offset == 0.01 then
            return createNewMessage("<Warning> "..plr, msg, WarningColor, msgcolor, offset, line)
        elseif IsAlive(LocalPlayer) == false and GetTeamDif(LocalPlayer) ~= "Spectator" or workspace.Status.RoundOver.Value == true or warmupCheck() == true or checkGamemode() == "deathmatch" or GetTeamDif(LocalPlayer) == "Spectator" or workspace.Status.Preparation.Value == true then
            return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
        else
            return createNewMessage("<Warning> "..plr, msg, WarningColor, msgcolor, offset, line)
        end
    end

	return createNewMessage(plr, msg, teamcolor, msgcolor, offset, line)
end

CharacterAdded()

table.foreach(game.Players:GetPlayers(), PlayerAdded)
game.Players.PlayerAdded:Connect(PlayerAdded)

for i,v in pairs({"CT", "T"}) do
	LocalPlayer.PlayerGui.GUI.Scoreboard[v].ChildAdded:Connect(function(child)
		wait(0.1)
		
		if child.Parent == LocalPlayer.PlayerGui.GUI.Scoreboard[v] and child:FindFirstChild("player") and child.player.Text ~= "PLAYER" and UserInputService:IsKeyDown(Enum.KeyCode.Tab) then
			if game.Players:FindFirstChild(child.player.Text) and game.Players[child.player.Text].OsPlatform:sub(1,1) == "|" then
				plr = game.Players[child.player.Text]
				child.player.Text = plr.OsPlatform:sub(2, 41).." "..plr.Name
				
				updater = plr:GetPropertyChangedSignal("OsPlatform"):Connect(function()
					if child and child.Parent and child:FindFirstChild("player") or UserInputService:IsKeyDown(Enum.KeyCode.Tab) and plr.OsPlatform:sub(1,1) == "|" then
						child.player.Text = plr.OsPlatform:sub(2, 41).." "..plr.Name
					else
						updater:Disconnect()
					end
				end)
			end
		end
	end)
end

table.foreach(weapon_skins, function(i,v)
	if i == "knives" then
        local temp = {"Default"}
        table.foreach(v, function(i2,v2)
            table.insert(temp, i2)
        end)

        library.pointers.SkinsTabKnifeKnife.options = temp
        library.pointers.SkinsTabKnifeKnife:Set("Default")
    elseif i == "gloves" then
        local temp = {"Stock"}
        table.foreach(v, function(i2,v2)
            table.insert(temp, i2)
        end)

        library.pointers.SkinsTabGloveGlove.options = temp
        library.pointers.SkinsTabGloveGlove:Set("Default")
	end
end)

if readfile("hexagon/autoload.txt") ~= "" and isfile("hexagon/configs/"..readfile("hexagon/autoload.txt")) then
	local a,b = pcall(function()
		cfg = loadstring("return "..readfile("hexagon/configs/"..readfile("hexagon/autoload.txt")))()
	end)
	
	if a == false then
		warn("Config Loading Error", a, b)
	elseif a == true then
		library:LoadConfiguration(cfg)


		if AllGunSkinsTable[string.sub(readfile("hexagon/autoload.txt"), 1, -5)] then
			CurrentGunSkinsTable = AllGunSkinsTable[string.sub(readfile("hexagon/autoload.txt"), 1, -5)]

			table.foreach(CurrentGunSkinsTable, function(i,v)
				if i ~= "-" then
					table.foreach(weapon_skins["guns"][i]["teams"], function(i2,v2)
						if v2 == "T" then
							game:GetService('Players').LocalPlayer.SkinFolder.TFolder[weapon_skins["guns"][i]["name"]].Value = v
						elseif v2 == "CT" then
							game:GetService('Players').LocalPlayer.SkinFolder.CTFolder[weapon_skins["guns"][i]["name"]].Value = v
						end
					end)
				end
			end)
		end
	end
end

print("Hexagon finished loading!")

Hint.Text = "Hexagon | Loading finished!"
wait(1.5)
Hint:Destroy()

--[[
	Priority list: []
	Difficulty list: <> (Estimation)

	[Done]
		-Slow enemies by hitting them with bullets that do 0 damage [Done]
		-Auto kill enemy when visible [Done]
		-Random gun dropdown between melee and ranged weapons [Done]
		-Have a table for saving the names of cheaters and upon them joining getting a message saying they are a cheater [Done]
		-Save/load skins differently (preferably from a table) [Done]
        -Anti AFK [Done]
		-Automatically check what gamemode youre in [Done]
		-Chat spam to be annoying [Done]
		-Auto kill delay stuff [Done]
		-Report messages should be limited [Done]
		-Complete new code for chat messages showing up (if not working as expected now) [Done?]

	[Highest]
		-Make code more efficient (wherever possible) <Mid> [Started/Working?]
		-Fix Repeat After Me <Mid>
		-Convert/CopyPaste code to the Orion Library <High>

	[Mid]
		-Sort all code/start from scratch <Mid>

	[Lowest]
		-Auto buy weapons (if possible) <Unsure>
		-Start code for chat drop downs when messages are supposed to show (if possible) <High>
		-Anti Chat Spam <High>
		-Auto Cheat Detection <High>
]]--