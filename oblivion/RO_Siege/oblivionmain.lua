--[[
    Made by:
    SomeoneIdfk
]]--

repeat wait() until game:IsLoaded()

-- Environment
local workspace = workspace or game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Main
if not isfolder("oblivion") then
    makefolder("oblivion")
end

if not isfolder("oblivion/RO_Siege") then
    makefolder("oblivion/RO_Siege")
end

local values = {aimbot = {keybind_toggled = false, last_target = nil, last_type = nil, last_host = nil, ticks = 0, offset = nil}, fov = Drawing.new("Circle")}

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local espLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/oblivion/RO_Siege/esp.lua"))()

local LocalPlayer = game:GetService('Players').LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Success, Mode = pcall(function() return ReplicatedStorage.Game.Timers.Mode end)
local Success, MapInfo = pcall(function() return workspace.SE_Workspace end)
values.fov.Thickness = 2
values.fov.Visible = false

local Window = OrionLib:MakeWindow({Name = "Oblivion", HidePremium = true, IntroEnabled = false, Icon = "rbxassetid://1521636846", SaveConfig = true, ConfigFolder = "oblivion/RO_Siege"})

-- Functions
local function GetTeam(plr)
	if tostring(plr.Team) ~= "Spec" then
		return tostring(plr.Team)
	end

	return "s"
end

local function IsAlive(plr)
	if plr and plr.Character and plr.Character.FindFirstChild(plr.Character, "Humanoid") and plr.Character.Humanoid.Health > 0 and GetTeam(plr) ~= "s" then
		return true
	end

	return false
end

local function DroneHealth(drone)
    if drone and drone.FindFirstChild(drone, "Humanoid") and drone.Humanoid.Health > 0 then
        return true
    end

    return false
end

local function GetCharacter(player)
    local character = player.Character
    return character, character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChild("Head")
end

local function GetDrone(drone)
    local hrp = drone:FindFirstChild("HumanoidRootPart")
    return hrp
end

local function VisibleCheck(target, position)
    local origin = workspace.CurrentCamera.CFrame.Position
    local part = workspace.FindPartOnRayWithIgnoreList(workspace, Ray.new(origin, position - origin), { GetCharacter(LocalPlayer), workspace.CurrentCamera, target }, false, true)
    return part == nil
end

local function getClosestTarget()
    local distance = math.huge
    local closestTarget = nil
    local targettype = nil
    local targethost = nil
    for i,v in pairs(game.Players:GetChildren()) do
        if v ~= LocalPlayer and IsAlive(v) and GetTeam(LocalPlayer) ~= GetTeam(v) then
			local character, hrp, head = GetCharacter(v)
			local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
			local FOVCheck = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
            if OrionLib.Flags["aimbot_fov_only"].Value == true and FOVCheck < OrionLib.Flags["aimbot_fov_radius"].Value or OrionLib.Flags["aimbot_fov_only"].Value == false then
				if OrionLib.Flags["aimbot_visible"].Value == false then
                    if FOVCheck < distance then
                        distance = FOVCheck
                        closestTarget = head
                        targettype = "player"
                        targethost = v
                    end
                elseif OrionLib.Flags["aimbot_visible"].Value == true then
                    if VisibleCheck(character, head.Position) then
                        if FOVCheck < distance then
                            distance = FOVCheck
                            closestTarget = head
                            targettype = "player"
                            targethost = v
                        end
                    elseif VisibleCheck(character, hrp.Position) then
                        if FOVCheck < distance then
                            distance = FOVCheck
                            closestTarget = hrp
                            targettype = "player"
                            targethost = v
                        end
                    end
				end
			end
        end
    end

    if not closestTarget and OrionLib.Flags["aimbot_drones"].Value == true and GetTeam(LocalPlayer) == "Defenders" and MapInfo and MapInfo.Drones then
        for i,v in pairs(MapInfo.Drones:GetChildren()) do
            local drone = GetDrone(v)
			local Vector, onScreen = workspace.CurrentCamera:WorldToScreenPoint(drone.Position)
			local FOVCheck = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).magnitude
            if OrionLib.Flags["aimbot_fov_only"].Value == true and FOVCheck < OrionLib.Flags["aimbot_fov_radius"].Value or OrionLib.Flags["aimbot_fov_only"].Value == false then
				if OrionLib.Flags["aimbot_visible"].Value == false then
                    if FOVCheck < distance then
                        distance = FOVCheck
                        closestTarget = drone
                        targettype = "drone"
                        targethost = v
                    end
                elseif OrionLib.Flags["aimbot_visible"].Value == true then
                    if VisibleCheck(v, drone.Position) then
                        if FOVCheck < distance then
                            distance = FOVCheck
                            closestTarget = drone
                            targettype = "drone"
                            targethost = v
                        end
                    end
				end
			end
        end
    end

	return closestTarget, targettype, targethost
end

-- Esp Functions
espLib.whitelist = {}
espLib.blacklist = {}
espLib.options = {
    enabled = false,
    scaleFactorX = 4, 
    scaleFactorY = 5, 
    font = 2, 
    fontSize = 13, 
    limitDistance = false, 
    maxDistance = 1000, 
    visibleOnly = false, 
    teamCheck = true, 
    teamColor = Color3.fromRGB(1, 1, 1),
    fillColor = Color3.fromRGB(1, 1, 1),
    whitelistColor = Color3.fromRGB(1, 0, 0), 
    outOfViewArrows = false, 
    outOfViewArrowsFilled = false, 
    outOfViewArrowsSize = 25, 
    outOfViewArrowsRadius = 100, 
    outOfViewArrowsColor = Color3.fromRGB(1, 1, 1), 
    outOfViewArrowsTransparency = 0.5, 
    outOfViewArrowsOutline = false, 
    outOfViewArrowsOutlineFilled = false, 
    outOfViewArrowsOutlineColor = Color3.fromRGB(1, 1, 1),
    outOfViewArrowsOutlineTransparency = 1, 
    names = false, 
    nameTransparency = 1, 
    nameColor = Color3.fromRGB(1, 1, 1), 
    boxes = false, 
    boxesTransparency = 1, 
    boxesColor = Color3.fromRGB(1, 1, 1), 
    boxFill = false, 
    boxFillTransparency = 0.5, 
    boxFillColor = Color3.fromRGB(1, 1, 1), 
    healthBars = false, 
    healthBarsSize = 1, 
    healthBarsTransparency = 1, 
    healthBarsColor = Color3.fromRGB(1, 1, 1), 
    healthText = false, 
    healthTextTransparency = 1, 
    healthTextSuffix = "%", 
    healthTextColor = Color3.fromRGB(1, 1, 1), 
    distance = false, 
    distanceTransparency = 1, 
    distanceSuffix = " Studs", 
    distanceColor = Color3.fromRGB(1, 1, 1), 
    tracers = false, 
    tracerTransparency = 1, 
    tracerColor = Color3.fromRGB(1, 1, 1), 
    tracerOrigin = "Bottom", 
    chams = false, 
    chamsColor = Color3.fromRGB(1, 1, 1), 
    chamsTransparency = 0
}

function espLib.GetCharacter(player)
    local character = player.Character
    if IsAlive(player) then
		return character, character and character.FindFirstChild(character, "HumanoidRootPart")
	end
    return character, nil
end

-- GUI
local AimTab = Window:MakeTab({Name = "Aimbot", Icon = "rbxassetid://4483345998"})
local EspTab = Window:MakeTab({Name = "ESP", Icon = "rbxassetid://4483362458"})

AimTab:AddToggle({Name = "Enable", Default = false, Flag = "aimbot_enable", Save = true})
AimTab:AddDropdown({Name = "Aim Type", Default = "Aimlock", Options = {"Aimlock", "Smooth"}, Flag = "aimbot_aim_type", Save = true})
AimTab:AddSlider({Name = "Smoothness", Min = 1, Max = 50, Default = 25, Color3.fromRGB(255, 255, 255), Increment = 1, Flag = "aimbot_aim_smoothness", Save = true})
AimTab:AddToggle({Name = "Visible", Default = false, Flag = "aimbot_visible", Save = true})
AimTab:AddToggle({Name = "Drones", Default = false, Flag = "aimbot_drones", Save = true})
AimTab:AddBind({Name = "Bind", Default = Enum.KeyCode.LeftAlt, Hold = false, Flag = "aimbot_keybind", Save = true, Callback = function() values.aimbot.keybind_toggled = values.aimbot.keybind_toggled == false and true or values.aimbot.keybind_toggled == true and false if OrionLib.Flags["aimbot_enable"].Value == true then local var = values.aimbot.keybind_toggled == true and "enabled" or values.aimbot.keybind_toggled == false and "disabled" OrionLib:MakeNotification({Name = "Oblivion", Content = "Aimbot is now "..var..".", Image = "rbxassetid://4483345998", Time = 3}) end end})
AimTab:AddToggle({Name = "FOV Check", Default = false, Flag = "aimbot_fov_only", Save = true})
AimTab:AddSlider({Name = "FOV Radius", Min = 5, Max = 360, Default = 120, Color3.fromRGB(255, 255, 255), Increment = 5, Flag = "aimbot_fov_radius", Save = true, Callback = function(val) values.fov.Radius = val end})

EspTab:AddToggle({Name = "Enable", Default = false, Flag = "esp_enable", Save = true, Callback = function(val) espLib.options.enabled = val end})
EspTab:AddToggle({Name = "Visible Only", Default = false, Flag = "esp_visible", Save = true, Callback = function(val) espLib.options.visibleOnly = val end})
EspTab:AddToggle({Name = "Name", Default = false, Flag = "esp_name", Save = true, Callback = function(val) espLib.options.names = val end})
EspTab:AddToggle({Name = "Health", Default = false, Flag = "esp_health", Save = true, Callback = function(val) espLib.options.healthText = val end})
EspTab:AddToggle({Name = "Health Bar", Default = false, Flag = "esp_health_bar", Save = true, Callback = function(val) espLib.options.healthBars = val end})
EspTab:AddToggle({Name = "Distance", Default = false, Flag = "esp_distance", Save = true, Callback = function(val) espLib.options.distance = val end})
EspTab:AddSlider({Name = "Misc Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(255, 255, 255), Increment = 10, Flag = "esp_misc_transparency", Save = true, Callback = function(val) espLib.options.nameTransparency = (val / 100) espLib.options.healthTextTransparency = (val / 100) espLib.options.healthBarsTransparency = (val / 100) espLib.options.distanceTransparency = (val / 100) end})
EspTab:AddToggle({Name = "Box", Default = false, Flag = "esp_box", Save = true, Callback = function(val) espLib.options.boxes = val end})
EspTab:AddSlider({Name = "Box Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_box_transparency", Save = true, Callback = function(val) espLib.options.boxesTransparency = (val / 100) end})
EspTab:AddToggle({Name = "Chams", Default = false, Flag = "esp_chams", Save = true, Callback = function(val) espLib.options.chams = val end})
EspTab:AddSlider({Name = "Chams Transparency", Min = 0, Max = 100, Default = 0, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_chams_transparency", Save = true, Callback = function(val) espLib.options.chamsTransparency = (val / 100) end})
EspTab:AddToggle({Name = "Tracers", Default = false, Flag = "esp_tracers", Save = true, Callback = function(val) espLib.options.tracers = val end})
EspTab:AddSlider({Name = "Tracer Transparency", Min = 0, Max = 100, Default = 100, Color3.fromRGB(0, 0, 0), Increment = 10, Flag = "esp_tracer_transparency", Save = true, Callback = function(val) espLib.options.tracerTransparency = (val / 100) end})
EspTab:AddDropdown({Name = "Tracer Origin", Default = "Bottom", Options = {"Bottom", "Top", "Mouse"}, Flag = "esp_tracerorigin", Save = true, Callback = function(val) espLib.options.tracerOrigin = val end})

-- Loops
RunService.RenderStepped:Connect(function(step)
    local lp = IsAlive(LocalPlayer)

    if OrionLib.Flags["aimbot_enable"].Value == true and lp and values.aimbot.keybind_toggled == true and (Mode.Value == "Op" or OrionLib.Flags["aimbot_drones"].Value == true and Mode.Value == "Set") then
        local target, type, host = getClosestTarget()
        if target then
            values.aimbot.last_target, values.aimbot.last_type, values.aimbot.last_host, values.aimbot.ticks = target, type, host, 0
            values.aimbot.offset = type == "player" and Vector3.new(((math.random(200) - 100) / 100), ((math.random(200) - 100) / 100), ((math.random(200) - 100) / 100)) and values.aimbot.last_target and type == "drone" and Vector3.new(((math.random(50) - 25) / 100), ((math.random(50) - 25) / 100), ((math.random(50) - 25) / 100)) or Vector3.new(0, 0, 0)
        else
            if values.aimbot.last_type == "player" and IsAlive(values.aimbot.last_host) == false then values.aimbot.last_target = nil elseif values.aimbot.last_type == "drone" and DroneHealth(values.aimbot.last_host) == false then values.aimbot.last_target = nil elseif values.aimbot.ticks == 500 then values.aimbot.last_target = nil end
            values.aimbot.ticks = values.aimbot.ticks ~= 500 and values.aimbot.ticks + 1 or values.aimbot.ticks
        end
        if values.aimbot.last_target then
            if OrionLib.Flags["aimbot_aim_type"].Value == "Smooth" then
                local Pos = workspace.CurrentCamera:WorldToScreenPoint((values.aimbot.last_target.Position + values.aimbot.offset))
				local Magnitude = Vector2.new(Pos.X - Mouse.X, Pos.Y - Mouse.Y)
				mousemoverel(Magnitude.x/OrionLib.Flags["aimbot_aim_smoothness"].Value, Magnitude.y/OrionLib.Flags["aimbot_aim_smoothness"].Value)
            elseif OrionLib.Flags["aimbot_aim_type"].Value == "Aimlock" then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, (values.aimbot.last_target.Position + values.aimbot.offset))
            end
        end
    end

    if OrionLib.Flags["aimbot_enable"].Value == true and OrionLib.Flags["aimbot_fov_only"].Value == true and lp and (Mode.Value == "Op" or OrionLib.Flags["aimbot_drones"].Value == true and Mode.Value == "Set") then
        values.fov.Visible = true
    else
        values.fov.Visible = false
    end
end)

Mouse.Move:Connect(function()
	if values.fov.Visible then
		values.fov.Position = game:GetService("UserInputService"):GetMouseLocation()
	end
end)

-- Init
OrionLib:Init()
espLib.Init()