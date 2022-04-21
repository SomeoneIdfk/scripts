--[[
Made by Pawel12d#0272
Customized by SomeoneIdfk
--]]

local Hint = Instance.new("Hint", game.CoreGui)
Hint.Text = "Hexagon | Waiting for the game to load..."

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

Hint.Text = "Hexagon | Setting up environment..."

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Environment 
local getrawmetatable = getrawmetatable or false
local mousemove = mousemove or mousemoverel or mouse_move or false
local getsenv = getsenv or false
local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false
local hookfunc = hookfunc or hookfunction or replaceclosure or false
pausetps = false


Hint.Text = "Hexagon | Setting up configuration settings..."

if not isfolder("hexagon") then
	print("creating hexagon folder")
	makefolder("hexagon")
end

if not isfolder("hexagon/configs") then
	print("creating hexagon configs folder")
	makefolder("hexagon/configs")
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
		pausetps = true
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
		pausetps = false
	end
	end)
end

local function DefuseC4()
	pcall(function()
	if IsAlive(LocalPlayer) and workspace.Map.Gamemode.Value == "defusal" and not defusing and workspace:FindFirstChild("C4") then 
		pausetps = true
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
		pausetps = false
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

							if library.pointers.AimbotTabCategoryLegitbotSmoothnessToggle.value == true then
								local PositionX = (Mouse.X-Vector.X)/library.pointers.AimbotTabCategoryLegitbotSmoothness.value + 1
								local PositionY = (Mouse.Y-Vector.Y)/library.pointers.AimbotTabCategoryLegitbotSmoothness.value + 1
							elseif library.pointers.AimbotTabCategoryLegitbotSmoothnessToggle == false then
								local PositionX = Mouse.X-Vector.X
								local PositionY = Mouse.Y-Vector.Y
							end
							
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

AimbotTabCategoryLegitbot:AddToggle("Smoothness", false, "AimbotTabCategoryLegitbotSmoothnessToggle")

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
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsArmsTransparency")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Gloves")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsGloves")
VisualsTabCategoryViewmodelColors:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryViewmodelColorsGlovesColor")
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsGlovesTransparency")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Sleeves")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsSleeves")
VisualsTabCategoryViewmodelColors:AddColorPicker("Color", Color3.new(1,1,1), "VisualsTabCategoryViewmodelColorsSleevesColor")
VisualsTabCategoryViewmodelColors:AddSlider("Transparency", {0, 1, 0, 0.01, ""}, "VisualsTabCategoryViewmodelColorsSleevesTransparency")

VisualsTabCategoryViewmodelColors:AddLabel("")
VisualsTabCategoryViewmodelColors:AddLabel("Weapons")
VisualsTabCategoryViewmodelColors:AddToggle("Enabled", false, "VisualsTabCategoryViewmodelColorsWeapons")
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

--MiscellaneousTabCategoryMain:AddToggle("Unlock Reset Character", false, "MiscellaneousTabCategoryMainUnlockResetCharacter", function(val)
	--game:GetService("StarterGui"):SetCore("ResetButtonCallback", val)
--end)

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

SettingsTabCategoryConfigs:AddTextBox("Name", "", "SettingsTabCategoryConfigsName")

SettingsTabCategoryConfigs:AddDropdown("Config", {"-"}, "-", "SettingsTabCategoryConfigsConfig")

SettingsTabCategoryConfigs:AddButton("Create", function()
    writefile("hexagon/configs/"..library.pointers.SettingsTabCategoryConfigsName.value..".cfg", library:SaveConfiguration())
end)

SettingsTabCategoryConfigs:AddButton("Save", function()
    writefile("hexagon/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg", library:SaveConfiguration())
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

SettingsTabCategoryConfigs:AddDropdown("Branch", {"Hexagon Modified", "Skin Changer"}, "Hexagon Modified", "SettingsTabCategoryConfigsBranch")
SettingsTabCategoryConfigs:AddDropdown("Build", {"-"}, "-", "SettingsTabCategoryConfigsBuild")
SettingsTabCategoryConfigs:AddButton("Save", function()
	if library.pointers.SettingsTabCategoryConfigsBranch.value == "Hexagon Modified" then
        if library.pointers.SettingsTabCategoryConfigsBuild.value == "Stable" then
            writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonModified.lua")
        elseif library.pointers.SettingsTabCategoryConfigsBuild.value == "Alpha" then
            writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonModifiedAlpha.lua")
        end
    elseif library.pointers.SettingsTabCategoryConfigsBranch.value == "Skin Changer" then
        if library.pointers.SettingsTabCategoryConfigsBuild.value == "-" then
            writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/HexagonSkinChanger.lua")
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
	pcall(function()
		if library.pointers.SettingsTabCategoryConfigsBranch.value == "Hexagon Modified" then
			library.pointers.SettingsTabCategoryConfigsBuild.options = {"Alpha", "Stable"}
			if library.pointers.SettingsTabCategoryConfigsBuild.value == "-" then
				library.pointers.SettingsTabCategoryConfigsBuild:Set("Alpha")
			end
		elseif library.pointers.SettingsTabCategoryConfigsBranch.value == "Skin Changer" then
			library.pointers.SettingsTabCategoryConfigsBuild.options = {"-"}
			if library.pointers.SettingsTabCategoryConfigsBuild.value ~= "-" then
				library.pointers.SettingsTabCategoryConfigsBuild:Set("-")
			end
		end
	end)
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

ExperimentalTabCategoryOptions:AddDropdown("Kill All Method", {"Efficient", "Hexagon", "Stormy", "CFrame"}, "Efficient", "ExperimentalTabCategoryOptionsMethod")
ExperimentalTabCategoryOptions:AddDropdown("Kill Method", {"Once", "Loop"}, "Once", "ExperimentalTabCategoryOptionsKMethod")
ExperimentalTabCategoryOptions:AddToggle("After Prep", false, "ExperimentalTabCategoryOptionsAfterPrep")
ExperimentalTabCategoryOptions:AddToggle("Random Gun", false, "ExperimentalTabCategoryOptionsRandomGun")
ExperimentalTabCategoryOptions:AddSlider("Loop Rate", {1, 20, 5, 1, ""}, "ExperimentalTabCategoryOptionsLoopRate")

writefile("hexagon/killallguns.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/killallguns.cfg"))

local killallguns = loadstring("return "..readfile("hexagon/killallguns.cfg"))()

function killtarget(target)
    if library.pointers.ExperimentalTabCategoryOptionsRandomGun.value == false then
        if library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Efficient" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = target.Character.Head.Position,
                [3] = LocalPlayer.Character.EquippedTool.Value,
                [4] = 500,
                [5] = LocalPlayer.Character.Gun,
                [8] = 100, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 500,
                [13] = Vector3.new()
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Hexagon" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = target.Character.Head.Position,
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
                [2] = target.Character.Head.CFrame.p,
                [3] = cbClient.gun.name,
                [4] = 4096,
                [5] = LocalPlayer.Character.Gun,
                [8] = 100,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(0,0,0),
                [12] = 16868,
                [13] = Vector3.new(0, 0, 0)
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "CFrame" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = target.Character.Head.CFrame.p,
                [3] = LocalPlayer.Character.EquippedTool.Value,
                [4] = 500,
                [5] = LocalPlayer.Character.Gun,
                [8] = 100, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 500,
                [13] = Vector3.new()
                }
            return Arguments
        end
    elseif library.pointers.ExperimentalTabCategoryOptionsRandomGun.value == true then
        local rgun = killallguns[math.random(1,#killallguns)]
        if library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Efficient" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = target.Character.Head.Position,
                [3] = rgun,
                [4] = 500,
                [5] = game.ReplicatedStorage.Weapons[rgun].Model,
                [8] = 100, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 500,
                [13] = Vector3.new()
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "Hexagon" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = target.Character.Head.Position,
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
                [2] = target.Character.Head.CFrame.p,
                [3] = rgun,
                [4] = 4096,
                [5] = game.ReplicatedStorage.Weapons[rgun].Model,
                [8] = 100,
                [9] = false,
                [10] = false,
                [11] = Vector3.new(0,0,0),
                [12] = 16868,
                [13] = Vector3.new(0, 0, 0)
                }
            return Arguments
        elseif library.pointers.ExperimentalTabCategoryOptionsMethod.value == "CFrame" then
            local Arguments = {
                [1] = target.Character.Head,
                [2] = target.Character.Head.CFrame.p,
                [3] = rgun,
                [4] = 500,
                [5] = game.ReplicatedStorage.Weapons[rgun].Model,
                [8] = 100, 
                [9] = false,
                [10] = false,
                [11] = Vector3.new(),
                [12] = 500,
                [13] = Vector3.new()
                }
            return Arguments
        end
    end
end

ExperimentalTabCategoryOptions:AddToggle("Kill all", false, "ExperimentalTabCategoryOptionsKillall", function(val)
	if val == true then
		KillEnemiesLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if IsAlive(LocalPlayer) then
					for i,v in pairs(game.Players:GetChildren()) do
						if v ~= LocalPlayer and IsAlive(v) then
							if library.pointers.ExperimentalTabCategoryOptionsGamemode.value == "Teams" then
                                if GetTeam(v) ~= "TTT" and GetTeam(v) ~= GetTeam(LocalPlayer) then
                                    if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                    elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                        if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
											for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
												if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
													game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
												end
												wait()
											end
										end
                                    elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                        game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                    elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                        if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
											for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
												if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
													game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
												end
												wait()
											end
										end
                                    end
                                end
                            elseif library.pointers.ExperimentalTabCategoryOptionsGamemode.value == "FFA" then
                                if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                    game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                    if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
										for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
											if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
												game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
											end
											wait()
										end
									end
                                elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                                    game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(v)))
                                elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                                    if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
										for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
											if GetTeam(v) ~= "TTT" and v ~= LocalPlayer and IsAlive(v) and IsAlive(LocalPlayer) and GetTeam(v) ~= GetTeam(LocalPlayer) then
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

ExperimentalTabCategoryOptions:AddDropdown("Gamemode", {"Teams", "FFA"}, "Teams", "ExperimentalTabCategoryOptionsGamemode")

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
					player1f = false
					player2f = false
					player3f = false
					playerfollowf = false
					playertroll = false
					playerram = false
                    playergw = false
					for i,v in pairs(game.Players:GetChildren()) do
						if v ~= LocalPlayer then
							if IsAlive(v) then
								playerlistfollow[v] = v
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

							if library.pointers.ExperimentalTabCategoryOptionsGamemode.value == "Teams" then
								if GetTeam(v) ~= GetTeam(LocalPlayer) then
									playerlistkillall[v] = v
								end
							elseif library.pointers.ExperimentalTabCategoryOptionsGamemode.value == "FFA" then
								playerlistkillall[v] = v
							end
							
							playerlistram[v] = v
                            playerlistgw[v] = v
						end
					end

					if prev_players ~= playerlistfollow then
						local prev_players = playerlistfollow

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

ExperimentalTabCategoryOptions:AddToggle("Break Stormy Ragebot", false, "ExperimentalTabCategoryOptionsBreakStormyRagebot", function(val)
	if val == true then
		BreakStormyRagebotLoop = LocalPlayer.CharacterAdded:Connect(function()
			pcall(function()
				LocalPlayer.Character.UpperTorso.Waist:Destroy()
			end)
		end)
	elseif val == false and BreakStormyRagebotLoop then
		BreakStormyRagebotLoop:Disconnect()
	end
end)

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

ExperimentalTabCategoryTeleport:AddSlider("Teleport Offset", {0, 100, 5, 5, ""}, "ExperimentalTabCategoryTeleportOffset")

ExperimentalTabCategoryTeleport:AddToggle("Teleport Loop", false, "ExperimentalTabCategoryTeleportTeleport", function(val)
	if val == true then
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name == library.pointers.ExperimentalTabCategoryPlayer1Players.value then
				playertp1 = v
				playertp1m = tostring(v)
			elseif library.pointers.ExperimentalTabCategoryPlayer1Players.value == "-" then
				playertp1 = nil
				playertp1m = "-"
			end

			if v.Name == library.pointers.ExperimentalTabCategoryPlayer2Players.value then
				playertp2 = v
				playertp2m = tostring(v)
			elseif library.pointers.ExperimentalTabCategoryPlayer2Players.value == "-" then
				playertp2 = nil
				playertp2m = "-"
			end
			
			if v.Name == library.pointers.ExperimentalTabCategoryPlayer3Players.value then
				playertp3 = v
				playertp3m = tostring(v)
			elseif library.pointers.ExperimentalTabCategoryPlayer3Players.value == "-" then
				playertp3 = nil
				playertp3m = "-"
			end
		end
		teleported = false
		etctFDLoop = game:GetService("RunService").Stepped:Connect(function()
			pcall(function()
                local var = var or true
				if IsAlive(LocalPlayer) then
					if library.pointers.ExperimentalTabCategoryTeleportFollowPLR.value == true or library.pointers.ExperimentalTabCategoryTeleportTeleport.value == true then
						if teleported == false or teleported2 == false then
							local var = true
							local velocity = Vector3.new(0, 1, 0)
						
							LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
							LocalPlayer.Character.Humanoid.PlatformStand = true
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								if v:IsA("BasePart") and v.CanCollide == true then
									v.CanCollide = false
								end
							end
						else
							if var == true then
								local var = false
								LocalPlayer.Character.Humanoid.PlatformStand = false
							end
						end
					end
				end
			end)
		end)
		TeleportLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if library.pointers.ExperimentalTabCategoryTeleportConstantTP.value == true or KillEnemiesLoop and pausetps == false then
					playerlisttest = {}
					if library.pointers.ExperimentalTabCategoryOptionsGamemode.value == "Teams" then
						for i,v in pairs(game.Players:GetChildren()) do
							if v ~= LocalPlayer and GetTeam(v) ~= GetTeam(LocalPlayer) and IsAlive(v) and GetTeam(v) ~= "TTT" then
								table.insert(playerlisttest, v)
							end
						end
					end
					if (#playerlisttest ~= 0) or library.pointers.ExperimentalTabCategoryOptionsGamemode.value == "FFA" then
						if IsAlive(LocalPlayer) then
							teleported = false
							if library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Bomb Sites" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
							elseif library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Players" then
								for i,v in pairs(game.Players:GetChildren()) do
									if IsAlive(LocalPlayer) and v ~= LocalPlayer and IsAlive(v) and pausetps == false and GetTeam(v) ~= "TTT" then
										if library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Random" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value), 0, (math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value))
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Glue" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value, 0)
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Behind" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, library.pointers.ExperimentalTabCategoryTeleportOffset.value)
											wait()
										end
									end
								end
							end
						end
					else
						if teleported == false then
							pausetps = true
							teleported = true
							teleportTospawnpoint()
							pausetps = false
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								if v:IsA("BasePart") and v.CanCollide == false then
									v.CanCollide = true
								end
							end
						end
					end
				elseif string.match(playertp1m, library.pointers.ExperimentalTabCategoryPlayer1Players.value) and string.match(playertp2m, library.pointers.ExperimentalTabCategoryPlayer2Players.value) and string.match(playertp3m, library.pointers.ExperimentalTabCategoryPlayer3Players.value) and pausetps == false then
					if library.pointers.ExperimentalTabCategoryPlayer1Kill.value == true and IsAlive(playertp1) and library.pointers.ExperimentalTabCategoryPlayer1Players.value ~= "-" and pausetps == false then
						if IsAlive(LocalPlayer) then
							teleported = false
							if library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Bomb Sites" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
							elseif library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Players" then
								for i,v in pairs(game.Players:GetChildren()) do
									if IsAlive(LocalPlayer) and v ~= LocalPlayer and IsAlive(v) and pausetps == false and GetTeam(v) ~= "TTT" then
										if library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Random" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value), 0, (math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value))
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Glue" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value, 0)
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Behind" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, library.pointers.ExperimentalTabCategoryTeleportOffset.value)
											wait()
										end
									end
								end
							end
						end
					elseif library.pointers.ExperimentalTabCategoryPlayer2Kill.value == true and IsAlive(playertp2) and library.pointers.ExperimentalTabCategoryPlayer2Players.value ~= "-" and pausetps == false then
						if IsAlive(LocalPlayer) then
							teleported = false
							if library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Bomb Sites" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
							elseif library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Players" then
								for i,v in pairs(game.Players:GetChildren()) do
									if IsAlive(LocalPlayer) and v ~= LocalPlayer and IsAlive(v) and pausetps == false and GetTeam(v) ~= "TTT" then
										if library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Random" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value), 0, (math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value))
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Glue" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value, 0)
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Behind" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, library.pointers.ExperimentalTabCategoryTeleportOffset.value)
											wait()
										end
									end
								end
							end
						end
					elseif library.pointers.ExperimentalTabCategoryPlayer3Kill.value == true and IsAlive(playertp3) and library.pointers.ExperimentalTabCategoryPlayer3Players.value ~= "-" and pausetps == false then
						if IsAlive(LocalPlayer) then
							teleported = false
							if library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Bomb Sites" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant"].Position + Vector3.new(0, 3, 0))
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Map.SpawnPoints["C4Plant2"].Position + Vector3.new(0, 3, 0))
							elseif library.pointers.ExperimentalTabCategoryTeleportTeleportOptions.value == "Players" then
								for i,v in pairs(game.Players:GetChildren()) do
									if IsAlive(LocalPlayer) and v ~= LocalPlayer and IsAlive(v) and pausetps == false and GetTeam(v) ~= "TTT" then
										if library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Random" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2) - library.pointers.ExperimentalTabCategoryTeleportOffset.value), 0, (math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value))
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Glue" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value, 0)
											wait()
										elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Behind" then
											LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, library.pointers.ExperimentalTabCategoryTeleportOffset.value)
											wait()
										end
									end
								end
							end
						end
					else
						if teleported == false then
							pausetps = true
							teleported = true
							teleportTospawnpoint()
							pausetps = false
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								if v:IsA("BasePart") and v.CanCollide == false then
									v.CanCollide = true
								end
							end
						end
					end
				
				else
					print("Re-ordering teleport player list.")
					for i,v in pairs(game.Players:GetChildren()) do
						if v.Name == library.pointers.ExperimentalTabCategoryPlayer1Players.value then
							playertp1 = v
							playertp1m = tostring(v)
						elseif library.pointers.ExperimentalTabCategoryPlayer1Players.value == "-" then
							playertp1 = nil
							playertp1m = "-"
						end
		
						if v.Name == library.pointers.ExperimentalTabCategoryPlayer2Players.value then
							playertp2 = v
							playertp2m = tostring(v)
						elseif library.pointers.ExperimentalTabCategoryPlayer2Players.value == "-" then
							playertp2 = nil
							playertp2m = "-"
						end
					
						if v.Name == library.pointers.ExperimentalTabCategoryPlayer3Players.value then
							playertp3 = v
							playertp3m = tostring(v)
						elseif library.pointers.ExperimentalTabCategoryPlayer3Players.value == "-" then
							playertp3 = nil
							playertp3m = "-"
						end
					end
				end
			end)
		end)

	elseif val == false and TeleportLoop then
		TeleportLoop:Disconnect()
		LocalPlayer.Character.Humanoid.PlatformStand = false
		pausetps = true
		teleportTospawnpoint()
		pausetps = false
		if library.pointers.ExperimentalTabCategoryTeleportFollowPLR.value == false then
			etctFDLoop:Disconnect()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if v:IsA("BasePart") and v.CanCollide == false then
					v.CanCollide = true
				end
			end
		end
	end
end)

ExperimentalTabCategoryTeleport:AddToggle("Constant Teleport", false, "ExperimentalTabCategoryTeleportConstantTP")

ExperimentalTabCategoryTeleport:AddDropdown("Player Follower", {"-"}, "-", "ExperimentalTabCategoryTeleportPLRFollowList")

ExperimentalTabCategoryTeleport:AddToggle("Follow", false, "ExperimentalTabCategoryTeleportFollowPLR", function(val)
	if val == true then
		for i,v in pairs(game.Players:GetChildren()) do
			if library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value ~= "-" then
				if v.Name == library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value then
					followplayer = v
					break
				end
			end
		end
		etctFDLoop = game:GetService("RunService").Stepped:Connect(function()
			pcall(function()
                local var = var or true
				if IsAlive(LocalPlayer) then
					if library.pointers.ExperimentalTabCategoryTeleportFollowPLR.value == true or library.pointers.ExperimentalTabCategoryTeleportTeleport.value == true then
						if teleported == false or teleported2 == false then
							local var = true
							local velocity = Vector3.new(0, 1, 0)
						
							LocalPlayer.Character.HumanoidRootPart.Velocity = velocity
							LocalPlayer.Character.Humanoid.PlatformStand = true
							for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
								if v:IsA("BasePart") and v.CanCollide == true then
									v.CanCollide = false
								end
							end
						else
							if var == true then
								local var = false
								LocalPlayer.Character.Humanoid.PlatformStand = false
							end
						end
					end
				end
			end)
		end)
		PlayerFollowLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value == tostring(followplayer) then
					if pausetps == false then
						if IsAlive(LocalPlayer) and IsAlive(followplayer) and GetTeam(followplayer) ~= "TTT" then
							teleported2 = false
							if library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Random" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = followplayer.Character.HumanoidRootPart.CFrame * CFrame.new((math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value), 0, (math.random(0, (library.pointers.ExperimentalTabCategoryTeleportOffset.value * 2)) - library.pointers.ExperimentalTabCategoryTeleportOffset.value))
							elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Glue" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = followplayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, library.pointers.ExperimentalTabCategoryTeleportOffset.value, 0)
							elseif library.pointers.ExperimentalTabCategoryTeleportFollowMethod.value == "Behind" then
								LocalPlayer.Character.HumanoidRootPart.CFrame = followplayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, library.pointers.ExperimentalTabCategoryTeleportOffset.value)
							end
						elseif IsAlive(LocalPlayer) then
							if teleported2 == false then
								pausetps = true
								teleported2 = true
								teleportTospawnpoint()
								pausetps = false
								for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
									if v:IsA("BasePart") and v.CanCollide == false then
										v.CanCollide = true
									end
								end
							end
						end
					end
				else
					for i,v in pairs(game.Players:GetChildren()) do
						if library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value ~= "-" then
							if v.Name == library.pointers.ExperimentalTabCategoryTeleportPLRFollowList.value then
								followplayer = v
								break
							end
						end
					end
				end
			end)
		end)
	elseif val == false and PlayerFollowLoop then
		PlayerFollowLoop:Disconnect()
		LocalPlayer.Character.Humanoid.PlatformStand = false
		pausetps = true
		teleportTospawnpoint()
		pausetps = false
		if library.pointers.ExperimentalTabCategoryTeleportTeleport.value == false then
			etctFDLoop:Disconnect()
			for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
				if v:IsA("BasePart") and v.CanCollide == false then
					v.CanCollide = true
				end
			end
		end
	end
end)

function Serverhop()
    wait(1)
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

oof = {}; for i,v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do if v:FindFirstChild("Model") then table.insert(oof, v.Name) end end

ExperimentalTabCategoryPlayer1:AddToggle("Kill Specific", false, "ExperimentalTabCategoryPlayer1Kill", function(val)
	if val == true then
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name == library.pointers.ExperimentalTabCategoryPlayer1Players.value then
				player1 = v
				break
			elseif library.pointers.ExperimentalTabCategoryPlayer1Players.value == "-" then
				player1 = nil
				break
			end
		end
		KillSpecificLoop1 = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if string.match(tostring(player1), library.pointers.ExperimentalTabCategoryPlayer1Players.value) then
					if player1 ~= LocalPlayer and IsAlive(player1) and IsAlive(LocalPlayer) and GetTeam(player1) ~= GetTeam(LocalPlayer) then
						if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                            game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player1)))
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
							if GetTeam(player1) ~= "TTT" and player1 ~= LocalPlayer and IsAlive(player1) and IsAlive(LocalPlayer) and GetTeam(player1) ~= GetTeam(LocalPlayer) then
								for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
									if GetTeam(player1) ~= "TTT" and player1 ~= LocalPlayer and IsAlive(player1) and IsAlive(LocalPlayer) and GetTeam(player1) ~= GetTeam(LocalPlayer) then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player1)))
									end
									wait()
								end
							end
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                            game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player1)))
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
							if GetTeam(player1) ~= "TTT" and player1 ~= LocalPlayer and IsAlive(player1) and IsAlive(LocalPlayer) and GetTeam(player1) ~= GetTeam(LocalPlayer) then
								for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
									if GetTeam(player1) ~= "TTT" and player1 ~= LocalPlayer and IsAlive(player1) and IsAlive(LocalPlayer) and GetTeam(player1) ~= GetTeam(LocalPlayer) then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player1)))
									end
									wait()
								end
							end
                        end
					end
				else
					for i,v in pairs(game.Players:GetChildren()) do
						if v.Name == library.pointers.ExperimentalTabCategoryPlayer1Players.value then
							player1 = v
							break
						elseif library.pointers.ExperimentalTabCategoryPlayer1Players.value == "-" then
							player1 = nil
							break
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
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name == library.pointers.ExperimentalTabCategoryPlayer2Players.value then
				player2 = v
				break
			elseif library.pointers.ExperimentalTabCategoryPlayer2Players.value == "-" then
				player2 = nil
				break
			end
		end
		KillSpecificLoop2 = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if string.match(tostring(player2), library.pointers.ExperimentalTabCategoryPlayer2Players.value) then
					if player2 ~= LocalPlayer and IsAlive(player2) and IsAlive(LocalPlayer) and GetTeam(player2) ~= GetTeam(LocalPlayer) then
						if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                            game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player2)))
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                            if GetTeam(player2) ~= "TTT" and player2 ~= LocalPlayer and IsAlive(player2) and IsAlive(LocalPlayer) and GetTeam(player2) ~= GetTeam(LocalPlayer) then
								for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
									if GetTeam(player2) ~= "TTT" and player2 ~= LocalPlayer and IsAlive(player2) and IsAlive(LocalPlayer) and GetTeam(player2) ~= GetTeam(LocalPlayer) then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player2)))
									end
									wait()
								end
							end
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                            game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player2)))
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                            if GetTeam(player2) ~= "TTT" and player2 ~= LocalPlayer and IsAlive(player2) and IsAlive(LocalPlayer) and GetTeam(player2) ~= GetTeam(LocalPlayer) then
								for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
									if GetTeam(player2) ~= "TTT" and player2 ~= LocalPlayer and IsAlive(player2) and IsAlive(LocalPlayer) and GetTeam(player2) ~= GetTeam(LocalPlayer) then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player2)))
									end
									wait()
								end
							end
                        end
					end
				else
					for i,v in pairs(game.Players:GetChildren()) do
						if v.Name == library.pointers.ExperimentalTabCategoryPlayer2Players.value then
							player2 = v
							break
						elseif library.pointers.ExperimentalTabCategoryPlayer2Players.value == "-" then
							player2 = nil
							break
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
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name == library.pointers.ExperimentalTabCategoryPlayer3Players.value then
				player3 = v
				break
			elseif library.pointers.ExperimentalTabCategoryPlayer3Players.value == "-" then
				player3 = nil
				break
			end
		end
		KillSpecificLoop3 = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if string.match(tostring(player3), library.pointers.ExperimentalTabCategoryPlayer3Players.value) then
					if player3 ~= LocalPlayer and IsAlive(player3) and IsAlive(LocalPlayer) and GetTeam(player3) ~= GetTeam(LocalPlayer) then
						if library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                            game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player3)))
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == true and workspace.Status.Preparation.Value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
							if GetTeam(player3) ~= "TTT" and player3 ~= LocalPlayer and IsAlive(player3) and IsAlive(LocalPlayer) and GetTeam(player3) ~= GetTeam(LocalPlayer) then
								for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
									if GetTeam(player3) ~= "TTT" and player3 ~= LocalPlayer and IsAlive(player3) and IsAlive(LocalPlayer) and GetTeam(player3) ~= GetTeam(LocalPlayer) then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player3)))
									end
									wait()
								end
							end
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Once" then
                            game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player3)))
                        elseif library.pointers.ExperimentalTabCategoryOptionsAfterPrep.value == false and library.pointers.ExperimentalTabCategoryOptionsKMethod.value == "Loop" then
                            if GetTeam(player3) ~= "TTT" and player3 ~= LocalPlayer and IsAlive(player3) and IsAlive(LocalPlayer) and GetTeam(player3) ~= GetTeam(LocalPlayer) then
								for i = 1, library.pointers.ExperimentalTabCategoryOptionsLoopRate.value, 1 do
									if GetTeam(player3) ~= "TTT" and player3 ~= LocalPlayer and IsAlive(player3) and IsAlive(LocalPlayer) and GetTeam(player3) ~= GetTeam(LocalPlayer) then
										game.ReplicatedStorage.Events.HitPart:FireServer(unpack(killtarget(player3)))
									end
									wait()
								end
							end
                        end
					end
				else
					for i,v in pairs(game.Players:GetChildren()) do
						if v.Name == library.pointers.ExperimentalTabCategoryPlayer3Players.value then
							player3 = v
							break
						elseif library.pointers.ExperimentalTabCategoryPlayer3Players.value == "-" then
							player3 = nil
							break
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

local SkinsTabRifles = SkinsTab:AddCategory("Rifles", 1)

SkinsTabRifles:AddToggle("Enable", false, "SkinsTabRiflesEnabled", function(val)
	if val == true then
		SkinsTabRiflesLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Galil.Value ~= library.pointers.SkinsTabRiflesGalil.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Galil.Value = library.pointers.SkinsTabRiflesGalil.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.AK47.Value ~= library.pointers.SkinsTabRiflesAK47.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.AK47.Value = library.pointers.SkinsTabRiflesAK47.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Scout.Value ~= library.pointers.SkinsTabRiflesScout.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Scout.Value ~= library.pointers.SkinsTabRiflesScout.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Scout.Value = library.pointers.SkinsTabRiflesScout.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Scout.Value = library.pointers.SkinsTabRiflesScout.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.SG.Value ~= library.pointers.SkinsTabRiflesSG.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.SG.Value = library.pointers.SkinsTabRiflesSG.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.AWP.Value ~= library.pointers.SkinsTabRiflesAWP.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.AWP.Value ~= library.pointers.SkinsTabRiflesAWP.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.AWP.Value = library.pointers.SkinsTabRiflesAWP.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.AWP.Value = library.pointers.SkinsTabRiflesAWP.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.G3SG1.Value ~= library.pointers.SkinsTabRiflesG3SG1.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.G3SG1.Value ~= library.pointers.SkinsTabRiflesG3SG1.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.G3SG1.Value = library.pointers.SkinsTabRiflesG3SG1.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.G3SG1.Value = library.pointers.SkinsTabRiflesG3SG1.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M4A4.Value ~= library.pointers.SkinsTabRiflesM4A4.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M4A4.Value = library.pointers.SkinsTabRiflesM4A4.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.AUG.Value ~= library.pointers.SkinsTabRiflesAUG.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.AUG.Value = library.pointers.SkinsTabRiflesAUG.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Famas.Value ~= library.pointers.SkinsTabRiflesFamas.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Famas.Value = library.pointers.SkinsTabRiflesFamas.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M4A1.Value ~= library.pointers.SkinsTabRiflesM4A1.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M4A1.Value = library.pointers.SkinsTabRiflesM4A1.value
				end
				wait(1)
			end)
		end)
	elseif val == false and SkinsTabRiflesLoop then
		SkinsTabRiflesLoop:Disconnect()
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Galil.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.AK47.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Scout.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Scout.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.SG.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.AWP.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.AWP.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.G3SG1.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.G3SG1.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M4A4.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.AUG.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Famas.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M4A1.Value = "Stock"
	end
end)
SkinsTabRifles:AddDropdown("Galil", {"Stock"}, "Stock", "SkinsTabRiflesGalil")
SkinsTabRifles:AddDropdown("Ak-47", {"Stock"}, "Stock", "SkinsTabRiflesAK47")
SkinsTabRifles:AddDropdown("Scout", {"Stock"}, "Stock", "SkinsTabRiflesScout")
SkinsTabRifles:AddDropdown("SG 553", {"Stock"}, "Stock", "SkinsTabRiflesSG")
SkinsTabRifles:AddDropdown("AWP", {"Stock"}, "Stock", "SkinsTabRiflesAWP")
SkinsTabRifles:AddDropdown("G3SG1", {"Stock"}, "Stock", "SkinsTabRiflesG3SG1")
SkinsTabRifles:AddDropdown("M4A4", {"Stock"}, "Stock", "SkinsTabRiflesM4A4")
SkinsTabRifles:AddDropdown("AUG", {"Stock"}, "Stock", "SkinsTabRiflesAUG")
SkinsTabRifles:AddDropdown("Famas F1", {"Stock"}, "Stock", "SkinsTabRiflesFamas")
SkinsTabRifles:AddDropdown("M4A1", {"Stock"}, "Stock", "SkinsTabRiflesM4A1")

local SkinsTabHeavy = SkinsTab:AddCategory("Heavy", 1)

SkinsTabHeavy:AddToggle("Enable", false, "SkinsTabHeavyEnabled", function(val)
	if val == true then
		SkinsTabHeavyLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Nova.Value ~= library.pointers.SkinsTabHeavyNova.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Nova.Value ~= library.pointers.SkinsTabHeavyNova.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Nova.Value = library.pointers.SkinsTabHeavyNova.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Nova.Value = library.pointers.SkinsTabHeavyNova.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.XM.Value ~= library.pointers.SkinsTabHeavyXM.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.XM.Value ~= library.pointers.SkinsTabHeavyXM.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.XM.Value = library.pointers.SkinsTabHeavyXM.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.XM.Value = library.pointers.SkinsTabHeavyXM.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MAG7.Value ~= library.pointers.SkinsTabHeavyMAG7.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MAG7.Value = library.pointers.SkinsTabHeavyMAG7.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.SawedOff.Value ~= library.pointers.SkinsTabHeavySawedOff.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.SawedOff.Value = library.pointers.SkinsTabHeavySawedOff.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.M249.Value ~= library.pointers.SkinsTabHeavyM249.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M249.Value ~= library.pointers.SkinsTabHeavyM249.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.M249.Value = library.pointers.SkinsTabHeavyM249.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M249.Value = library.pointers.SkinsTabHeavyM249.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Negev.Value ~= library.pointers.SkinsTabHeavyNegev.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Negev.Value ~= library.pointers.SkinsTabHeavyNegev.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Negev.Value = library.pointers.SkinsTabHeavyNegev.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Negev.Value = library.pointers.SkinsTabHeavyNegev.value
				end
				wait(1)
			end)
		end)
	elseif val == false and SkinsTabHeavyLoop then
		SkinsTabHeavyLoop:Disconnect()
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Nova.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Nova.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.XM.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.XM.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MAG7.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.SawedOff.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.M249.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.M249.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Negev.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Negev.Value = "Stock"
	end
end)
SkinsTabHeavy:AddDropdown("Nova", {"Stock"}, "Stock", "SkinsTabHeavyNova")
SkinsTabHeavy:AddDropdown("XM1014", {"Stock"}, "Stock", "SkinsTabHeavyXM")
SkinsTabHeavy:AddDropdown("MAG-7", {"Stock"}, "Stock", "SkinsTabHeavyMAG7")
SkinsTabHeavy:AddDropdown("Sawed Off", {"Stock"}, "Stock", "SkinsTabHeavySawedOff")
SkinsTabHeavy:AddDropdown("M249", {"Stock"}, "Stock", "SkinsTabHeavyM249")
SkinsTabHeavy:AddDropdown("MG42", {"Stock"}, "Stock", "SkinsTabHeavyNegev")

local SkinsTabKnife = SkinsTab:AddCategory("Knife", 1)

local HexFolModels = Instance.new("Folder", HexagonFolder)
HexFolModels.Name = "Models"
for _, Model in pairs(game:GetService("ReplicatedStorage").Viewmodels:GetChildren()) do
	local Clone = Model:Clone()
	Clone.Parent = HexFolModels
end

local function modelChange(model, replace)
	print(model, replace)
	if game:GetService("ReplicatedStorage").Viewmodels:FindFirstChild(model) then
		print(model, replace)
		if HexFolModels:FindFirstChild(replace) then
			print(model, replace)
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

local SkinsTabSMGs = SkinsTab:AddCategory("SMGs", 2)

SkinsTabSMGs:AddToggle("Enable", false, "SkinsTabSMGsEnabled", function(val)
	if val == true then
		SkinsTabSMGsLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP9.Value ~= library.pointers.SkinsTabSMGsMP9.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP9.Value = library.pointers.SkinsTabSMGsMP9.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.MAC10.Value ~= library.pointers.SkinsTabSMGsMAC10.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.MAC10.Value = library.pointers.SkinsTabSMGsMAC10.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.MP7.Value ~= library.pointers.SkinsTabSMGsMP7.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP7.Value ~= library.pointers.SkinstabSMGsMP7.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.MP7.Value = library.pointers.SkinsTabSMGsMP7.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP7.Value = library.pointers.SkinsTabSMGsMP7.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.UMP.Value ~= library.pointers.SkinsTabSMGsUMP.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.UMP.Value ~= library.pointers.SkinsTabSMGsUMP.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.UMP.Value = library.pointers.SkinsTabSMGsUMP.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.UMP.Value = library.pointers.SkinsTabSMGsUMP.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.P90.Value ~= library.pointers.SkinsTabSMGsP90.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P90.Value ~= library.pointers.SkinsTabSMGsP90.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.P90.Value = library.pointers.SkinsTabSMGsP90.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P90.Value = library.pointers.SkinsTabSMGsP90.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Bizon.Value ~= library.pointers.SkinsTabSMGsBizon.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Bizon.Value ~= library.pointers.SkinsTabSMGsBizon.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Bizon.Value = library.pointers.SkinsTabSMGsBizon.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Bizon.Value = library.pointers.SkinsTabSMGsBizon.value
				end
				wait(1)
			end)
		end)
	elseif val == false and SkinsTabSMGsLoop then
		SkinsTabSMGsLoop:Disconnect()
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP9.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.MAC10.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.MP7.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP7.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.UMP.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.UMP.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.P90.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P90.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Bizon.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.Bizon.Value = "Stock"
	end
end)
SkinsTabSMGs:AddDropdown("MP9", {"Stock"}, "Stock", "SkinsTabSMGsMP9")
SkinsTabSMGs:AddDropdown("MAC-10", {"Stock"}, "Stock", "SkinsTabSMGsMAC10")
SkinsTabSMGs:AddDropdown("MP5", {"Stock"}, "Stock", "SkinsTabSMGsMP7")
SkinsTabSMGs:AddDropdown("UMP-45", {"Stock"}, "Stock", "SkinsTabSMGsUMP")
SkinsTabSMGs:AddDropdown("P90", {"Stock"}, "Stock", "SkinsTabSMGsP90")
SkinsTabSMGs:AddDropdown("Thompson", {"Stock"}, "Stock", "SkinsTabSMGsBizon")

local SkinsTabPistols = SkinsTab:AddCategory("Pistols", 2)

SkinsTabPistols:AddToggle("Enable", false, "SkinsTabPistolsEnabled", function(val)
	if val == true then
		SkinsTabPistolsLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Glock.Value ~= library.pointers.SkinsTabPistolsGlock.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Glock.Value = library.pointers.SkinsTabPistolsGlock.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.DualBerettas.Value ~= library.pointers.SkinsTabPistolsDualBerettas.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.DualBerettas.Value ~= library.pointers.SkinsTabPistolsDualBerettas.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.DualBerettas.Value = library.pointers.SkinsTabPistolsDualBerettas.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.DualBerettas.Value = library.pointers.SkinsTabPistolsDualBerettas.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.P250.Value ~= library.pointers.SkinsTabPistolsP250 or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P250.Value ~= library.pointers.SkinsTabPistolsP250 then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.P250.Value = library.pointers.SkinsTabPistolsP250.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P250.Value = library.pointers.SkinsTabPistolsP250.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Tec9.Value ~= library.pointers.SkinsTabPistolsTec9.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Tec9.Value = library.pointers.SkinsTabPistolsTec9.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.DesertEagle.Value ~= library.pointers.SkinsTabPistolsDesertEagle.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.DesertEagle.Value ~= library.pointers.SkinsTabPistolsDesertEagle.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.DesertEagle.Value = library.pointers.SkinsTabPistolsDesertEagle.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.DesertEagle.Value = library.pointers.SkinsTabPistolsDesertEagle.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P2000.Value ~= library.pointers.SkinsTabPistolsP2000.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P2000.Value = library.pointers.SkinsTabPistolsP2000.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.FiveSeven.Value ~= library.pointers.SkinsTabPistolsFiveSeven.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.FiveSeven.Value = library.pointers.SkinsTabPistolsFiveSeven.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.USP.Value ~= library.pointers.SkinsTabPistolsUSP.value then
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.USP.Value = library.pointers.SkinsTabPistolsUSP.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.CZ.Value ~= library.pointers.SkinsTabPistolsCZ.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.CZ.Value ~= library.pointers.SkinsTabPistolsCZ.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.CZ.Value = library.pointers.SkinsTabPistolsCZ.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.CZ.Value = library.pointers.SkinsTabPistolsCZ.value
				end
				if game:GetService('Players').LocalPlayer.SkinFolder.TFolder.R8.Value ~= library.pointers.SkinsTabPistolsR8.value or game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.R8.Value ~= library.pointers.SkinsTabPistolsR8.value then
					game:GetService('Players').LocalPlayer.SkinFolder.TFolder.R8.Value = library.pointers.SkinsTabPistolsR8.value
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.R8.Value = library.pointers.SkinsTabPistolsR8.value
				end
				wait(1)
			end)
		end)
	elseif val == false and SkinsTabPistolsLoop then
		SkinsTabPistolsLoop:Disconnect()
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Glock.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.DualBerettas.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.DualBerettas.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.P250.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P250.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.Tec9.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.DesertEagle.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.DesertEagle.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.P2000.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.FiveSeven.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.USP.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.CZ.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.CZ.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.TFolder.R8.Value = "Stock"
		game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.R8.Value = "Stock"
	end
end)
SkinsTabPistols:AddDropdown("Glock-18", {"Stock"}, "Stock", "SkinsTabPistolsGlock")
SkinsTabPistols:AddDropdown("Dual Berettas", {"Stock"}, "Stock", "SkinsTabPistolsDualBerettas")
SkinsTabPistols:AddDropdown("P250", {"Stock"}, "Stock", "SkinsTabPistolsP250")
SkinsTabPistols:AddDropdown("TEC-9", {"Stock"}, "Stock", "SkinsTabPistolsTec9")
SkinsTabPistols:AddDropdown("Deagle", {"Stock"}, "Stock", "SkinsTabPistolsDesertEagle")
SkinsTabPistols:AddDropdown("PX4", {"Stock"}, "Stock", "SkinsTabPistolsP2000")
SkinsTabPistols:AddDropdown("Five-seveN", {"Stock"}, "Stock", "SkinsTabPistolsFiveSeven")
SkinsTabPistols:AddDropdown("USP-S", {"Stock"}, "Stock", "SkinsTabPistolsUSP")
SkinsTabPistols:AddDropdown("CZ75-Auto", {"Stock"}, "Stock", "SkinsTabPistolsCZ")
SkinsTabPistols:AddDropdown("44 Magnum", {"Stock"}, "Stock", "SkinsTabPistolsR8")

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
							for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do
								if v.Name == "MagDrop" then
									v:Destroy()
								end
							end
						else
							ttmdmworker = ttmdmworker - 1
						end
					elseif library.pointers.TrollTabMapDropRate.value == "Laggy" then
						game:GetService("RunService").RenderStepped:Wait()
						game:GetService("RunService").RenderStepped:Wait()
						local mag = LocalPlayer.Character.Gun.Mag
						game:GetService("ReplicatedStorage").Events.DropMag:FireServer(mag)
						for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do
							if v.Name == "MagDrop" then
								v:Destroy()
							end
						end
					elseif library.pointers.TrollTabMapDropRate.value == "Server Death" then
						for i = 1,10,1 do
							local mag = LocalPlayer.Character.Gun.Mag
							game:GetService("ReplicatedStorage").Events.DropMag:FireServer(mag)
							for i,v in pairs(workspace["Ray_Ignore"]:GetChildren()) do
								if v.Name == "MagDrop" then
									v:Destroy()
								end
							end
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

TrollTabPlayer:AddToggle("Talk shit", false, "TrollTabPlayerTS", function(val)
	if val == true then
		TrollTabPlayerTSLoop = game.Players.LocalPlayer.Status.Kills:GetPropertyChangedSignal("Value"):Connect(function()
			pcall(function()
                if game.Players.LocalPlayer.Status.Kills.Value ~= 0 then
					if library.pointers.TrollTabPlayerDelay.value ~= 0 then
						wait(library.pointers.TrollTabPlayerDelay.value)
					end
					if library.pointers.TrollTabPlayerMessages.value == "Default" and IsAlive(LocalPlayer) then
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							shittalklibnc[math.random(0, #shittalklibnc)],
							false,
							"Innocent",
							false,
							true
						)
					elseif library.pointers.TrollTabPlayerMessages.value == "Custom" and IsAlive(LocalPlayer) then
						game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(
							shittalklibcu[math.random(0, #shittalklibcu)],
							false,
							"Innocent",
							false,
							true
						)
					end
                end
			end)
		end)
	elseif val == false and TrollTabPlayerTSLoop then
		TrollTabPlayerTSLoop:Disconnect()
	end
end)
TrollTabPlayer:AddDropdown("Messages", {"Default", "Custom"}, "Default", "TrollTabPlayerMessages")
TrollTabPlayer:AddTextBox("Custom Message", "Seperate,,them,,with,,double commas.", "TrollTabPlayerCM", function(val)
	shittalklibcu = {}
	for i,v in pairs(string.split(val, ",,")) do
		table.insert(shittalklibcu, v)
	end
end)
TrollTabPlayer:AddSlider("Delay", {0, 10, 0, 1, ""}, "TrollTabPlayerDelay")
TrollTabPlayer:AddToggle("Remove Head", false, "TrollTabPlayerRH", function(val)
	if val == true then
		TrollTabPlayerRHLoop = game:GetService("RunService").RenderStepped:Connect(function()
			pcall(function()
            	if WorkSpace:FindFirstChild(LocalPlayer.Name):FindFirstChild("FakeHead") then
					WorkSpace:FindFirstChild(LocalPlayer.Name):FindFirstChild("FakeHead"):Destroy()
				else
					wait(1)
				end
			end)
		end)
	elseif val == false and TrollTabPlayerRHLoop then
		TrollTabPlayerRHLoop:Disconnect()
	end
end)
TrollTabPlayer:AddToggle("Random Gun Kill", false, "TrollTabPlayerRGK")
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
			LGlove = game:GetService("ReplicatedStorage").Gloves.Models[library.pointers.SkinsTabGloveGlove.value].RGlove:Clone()       
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
						end
						if LeftArm ~= nil then
							LeftArm.Mesh.TextureId = ""
							LeftArm.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsArmsTransparency.value
							LeftArm.Color = library.pointers.VisualsTabCategoryViewmodelColorsArmsColor.value
						end
					end
					
					if library.pointers.VisualsTabCategoryViewmodelColorsGloves.value == true then
						if RightGlove ~= nil then
							RightGlove.Mesh.TextureId = ""
							RightGlove.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsGlovesTransparency.value
							RightGlove.Color = library.pointers.VisualsTabCategoryViewmodelColorsGlovesColor.value
						end
						if LeftGlove ~= nil then
							LeftGlove.Mesh.TextureId = ""
							LeftGlove.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsGlovesTransparency.value
							LeftGlove.Color = library.pointers.VisualsTabCategoryViewmodelColorsGlovesColor.value
						end
					end

					if library.pointers.VisualsTabCategoryViewmodelColorsSleeves.value == true then
						if RightSleeve ~= nil then
							RightSleeve.Mesh.TextureId = ""
							RightSleeve.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsSleevesTransparency.value
							RightSleeve.Color = library.pointers.VisualsTabCategoryViewmodelColorsSleevesColor.value
							RightSleeve.Material = "ForceField"
						end
						if LeftSleeve ~= nil then
							LeftSleeve.Mesh.TextureId = ""
							LeftSleeve.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsSleevesTransparency.value
							LeftSleeve.Color = library.pointers.VisualsTabCategoryViewmodelColorsSleevesColor.value
							LeftSleeve.Material = "ForceField"
						end
					end
				elseif library.pointers.VisualsTabCategoryViewmodelColorsWeapons.value == true and v:IsA("BasePart") and not table.find({"Right Arm", "Left Arm", "Flash"}, v.Name) and v.Transparency ~= 1 then
					if v:IsA("MeshPart") then v.TextureID = "" end
					if v:FindFirstChildOfClass("SpecialMesh") then v:FindFirstChildOfClass("SpecialMesh").TextureId = "" end

					v.Transparency = library.pointers.VisualsTabCategoryViewmodelColorsWeaponsTransparency.value
					v.Color = library.pointers.VisualsTabCategoryViewmodelColorsWeaponsColor.value
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

--print(library, LocalPlayer, IsAlive, SilentRagebot, SilentLegitbot, isBhopping, JumpBug, cbClient)

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
				if GetTeam(LocalPlayer) ~= "Spectator" then
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
					if GetTeam(LocalPlayer) ~= "Spectator" then
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
				if GetTeam(LocalPlayer) ~= "Spectator" and GetTeam(LocalPlayer) == GetTeam(plr) then
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
				if GetTeam(LocalPlayer) ~= "Spectator" and GetTeam(LocalPlayer) ~= GetTeam(plr) then
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
					if GetTeam(LocalPlayer) ~= "Spectator" then
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
					if GetTeam(LocalPlayer) ~= "Spectator" then
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
local AliveChatColor = Color3.fromRGB(0, 0, 0)
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
					local rgun = killallguns[math.random(1,#killallguns)]
					args[3] = rgun
					args[5] = game.ReplicatedStorage.Weapons[rgun].Model
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
			elseif self.Name == "Filter" and callingscript == LocalPlayer.PlayerGui.GUI.Main.Chats.DisplayChat then
				if args[2] == LocalPlayer then
					if library.pointers.MiscellaneousTabCategoryMainNoChatFilter.value == true then
                    	return args[1]
					end
                elseif args[2] ~= LocalPlayer then
					if library.pointers.TrollTabPlayerAC.value == true and game.Workspace.Status.RoundOver.Value == false then
						if IsAlive(LocalPlayer) then
							if not IsAlive(args[2]) then
								ChatScript.moveOldMessages()
                            	ChatScript.createNewMessage("<Alive Chat> "..args[2].Name, args[1], AliveChatColor, Color3.new(1,1,1), 0.01, nil)
							end
						end
					end
                    
					if library.pointers.TrollTabPlayerRAM.value == true then
						sayMessage(args[1], args[2])
					end

					if library.pointers.MiscellaneousTabCategoryMainNoChatFilter.value == true then
						if IsAlive(LocalPlayer) and IsAlive(args[2]) then
                    		return args[1]
						elseif not IsAlive(LocalPlayer) and IsAlive(args[2]) then
							return args[1]
						end
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
end))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                if game.Players.LocalPlayer.UserId == 1858923608 then game.Players.LocalPlayer:Kick("🤡") end -- anti skid security system :sunglasses:

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

writefile("hexagon/weapon_skins.cfg", game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/weapon_skins.cfg"))

local weapon_skins = loadstring("return "..readfile("hexagon/weapon_skins.cfg"))()

table.foreach(weapon_skins, function(i,v)
	if i == "guns" then
		table.foreach(v, function(i2,v2)
			local temp = {"Stock"}
			table.foreach(v2, function(i3,v3)
				table.insert(temp, v3)
			end)
		
			if i2 == "AK47" then
				library.pointers.SkinsTabRiflesAK47.options = temp
			elseif i2 == "AUG" then
				library.pointers.SkinsTabRiflesAUG.options = temp
			elseif i2 == "AWP" then
				library.pointers.SkinsTabRiflesAWP.options = temp
			elseif i2 == "Bizon" then
				library.pointers.SkinsTabSMGsBizon.options = temp
			elseif i2 == "CZ" then
				library.pointers.SkinsTabPistolsCZ.options = temp
			elseif i2 == "DesertEagle" then
				library.pointers.SkinsTabPistolsDesertEagle.options = temp
			elseif i2 == "DualBerettas" then
				library.pointers.SkinsTabPistolsDualBerettas.options = temp
			elseif i2 == "Famas" then
				library.pointers.SkinsTabRiflesFamas.options = temp
			elseif i2 == "FiveSeven" then
				library.pointers.SkinsTabPistolsFiveSeven.options = temp
			elseif i2 == "G3SG1" then
				library.pointers.SkinsTabRiflesG3SG1.options = temp
			elseif i2 == "Galil" then
				library.pointers.SkinsTabRiflesGalil.options = temp
			elseif i2 == "Glock" then
				library.pointers.SkinsTabPistolsGlock.options = temp
			elseif i2 == "M249" then
				library.pointers.SkinsTabHeavyM249.options = temp
			elseif i2 == "M4A1" then
				library.pointers.SkinsTabRiflesM4A1.options = temp
			elseif i2 == "M4A4" then
				library.pointers.SkinsTabRiflesM4A4.options = temp
			elseif i2 == "MAC10" then
				library.pointers.SkinsTabSMGsMAC10.options = temp
			elseif i2 == "MAG7" then
				library.pointers.SkinsTabHeavyMAG7.options = temp
			elseif i2 == "MP7" then
				library.pointers.SkinsTabSMGsMP7.options = temp
			elseif i2 == "MP9" then
				library.pointers.SkinsTabSMGsMP9.options = temp
			elseif i2 == "Negev" then
				library.pointers.SkinsTabHeavyNegev.options = temp
			elseif i2 == "Nova" then
				library.pointers.SkinsTabHeavyNova.options = temp
			elseif i2 == "P2000" then
				library.pointers.SkinsTabPistolsP2000.options = temp
			elseif i2 == "P250" then
				library.pointers.SkinsTabPistolsP250.options = temp
			elseif i2 == "P90" then
				library.pointers.SkinsTabSMGsP90.options = temp
			elseif i2 == "R8" then
				library.pointers.SkinsTabPistolsR8.options = temp
			elseif i2 == "SG" then
				library.pointers.SkinsTabRiflesSG.options = temp
			elseif i2 == "SawedOff" then
				library.pointers.SkinsTabHeavySawedOff.options = temp
			elseif i2 == "Scout" then
				library.pointers.SkinsTabRiflesScout.options = temp
			elseif i2 == "Tec9" then
				library.pointers.SkinsTabPistolsTec9.options = temp
			elseif i2 == "UMP" then
				library.pointers.SkinsTabSMGsUMP.options = temp
			elseif i2 == "USP" then
				library.pointers.SkinsTabPistolsUSP.options = temp
			elseif i2 == "XM" then
				library.pointers.SkinsTabHeavyXM.options = temp
			end
		end)
    elseif i == "knives" then
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
	end
end

print("Hexagon finished loading!")

Hint.Text = "Hexagon | Loading finished!"
wait(1.5)
Hint:Destroy()