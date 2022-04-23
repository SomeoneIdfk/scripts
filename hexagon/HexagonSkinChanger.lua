--[[
Made by Pawel12d#0272
Redone by SomeoneIdfk
--]]

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("GUI")

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Environment 
local getrawmetatable = getrawmetatable or false
local getsenv = getsenv or false
local listfiles = listfiles or listdir or syn_io_listdir or false
local isfolder = isfolder or false
local hookfunc = hookfunc or hookfunction or replaceclosure or false

if not isfolder("hexagon") then
	makefolder("hexagon")
end

if not isfolder("hexagon/skin_changer") then
    makefolder("hexagon/skin_changer")
end

if not isfolder("hexagon/skin_changer/configs") then
	makefolder("hexagon/skin_changer/configs")
end

if not isfile("hexagon/skin_changer/autoload.txt") then
	writefile("hexagon/skin_changer/autoload.txt", "")
end

-- Viewmodels fix
for i,v in pairs(game.ReplicatedStorage.Viewmodels:GetChildren()) do
    if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.Transparency ~= 1 then
        v.HumanoidRootPart.Transparency = 1
    end
end

local HexagonFolder = Instance.new("Folder", workspace)
HexagonFolder.Name = "HexagonFolder"

local Configs = {}

-- Main
local LocalPlayer = game.Players.LocalPlayer
local cbClient = getsenv(LocalPlayer.PlayerGui:WaitForChild("Client"))
local oldInventory = cbClient.CurrentInventory

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/hexagon/lib/library_skinchanger.lua"))()

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

--GUI

game:GetService("RunService").Heartbeat:Connect(function()
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
	end)
end)

local SkinsTab = Window:CreateTab("Skins")

local SkinsTabRifles = SkinsTab:AddCategory("Rifles", 1)

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

SkinsTabSMGs:AddDropdown("MP9", {"Stock"}, "Stock", "SkinsTabSMGsMP9")
SkinsTabSMGs:AddDropdown("MAC-10", {"Stock"}, "Stock", "SkinsTabSMGsMAC10")
SkinsTabSMGs:AddDropdown("MP5", {"Stock"}, "Stock", "SkinsTabSMGsMP7")
SkinsTabSMGs:AddDropdown("UMP-45", {"Stock"}, "Stock", "SkinsTabSMGsUMP")
SkinsTabSMGs:AddDropdown("P90", {"Stock"}, "Stock", "SkinsTabSMGsP90")
SkinsTabSMGs:AddDropdown("Thompson", {"Stock"}, "Stock", "SkinsTabSMGsBizon")

local SkinsTabPistols = SkinsTab:AddCategory("Pistols", 2)

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

local SettingsTab = Window:CreateTab("Settings")

local SettingsTabCategoryMain = SettingsTab:AddCategory("Main", 1)

SettingsTabCategoryMain:AddKeybind("Toggle Keybind", Enum.KeyCode.RightShift, "SettingsTabCategoryUIToggleKeybind")

SettingsTabCategoryMain:AddButton("Server Rejoin", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

local SettingsTabCategoryConfigs = SettingsTab:AddCategory("Configs", 2)

SettingsTabCategoryConfigs:AddTextBox("Name", "", "SettingsTabCategoryConfigsName")

SettingsTabCategoryConfigs:AddDropdown("Config", {"-"}, "-", "SettingsTabCategoryConfigsConfig")

SettingsTabCategoryConfigs:AddButton("Create", function()
    writefile("hexagon/skin_changer/configs/"..library.pointers.SettingsTabCategoryConfigsName.value..".cfg", library:SaveConfiguration())
end)

SettingsTabCategoryConfigs:AddButton("Save", function()
    writefile("hexagon/skin_changer/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg", library:SaveConfiguration())
end)

SettingsTabCategoryConfigs:AddButton("Load", function()
	local a,b = pcall(function()
		cfg = loadstring("return "..readfile("hexagon/skin_changer/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg"))()
	end)
	
	if a == false then
		warn("Config Loading Error", a, b)
	elseif a == true then
		library:LoadConfiguration(cfg)
	end
end)

SettingsTabCategoryConfigs:AddButton("Refresh", function()
	local cfgs = {}

	for i,v in pairs(listfiles("hexagon/skin_changer/configs")) do
		if v:sub(-4) == ".cfg" then
			table.insert(cfgs, v:sub(30, -5))
		end
	end
	
	library.pointers.SettingsTabCategoryConfigsConfig.options = cfgs
end)

SettingsTabCategoryConfigs:AddButton("Set as default", function()
	if isfile("hexagon/skin_changer/configs/"..library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg") then
		writefile("hexagon/skin_changer/autoload.txt", library.pointers.SettingsTabCategoryConfigsConfig.value..".cfg")
	else
		writefile("hexagon/skin_changer/autoload.txt", "")
	end
end)

local versions = loadstring("return "..readfile("hexagon/versions.cfg"))()

SettingsTabCategoryConfigs:AddDropdown("Branch", {"-"}, "-", "SettingsTabCategoryConfigsBranch")
SettingsTabCategoryConfigs:AddDropdown("Build", {"-"}, "-", "SettingsTabCategoryConfigsBuild")
SettingsTabCategoryConfigs:AddButton("Save", function()
	writefile("hexagon/load_version.txt", versions["data"][library.pointers.Branch.value]["data"][library.pointers.Build.value])
end)

library.pointers.SettingsTabCategoryConfigsBranch.options = versions["tables"]
library.pointers.SettingsTabCategoryConfigsBranch:Set(versions["tables"][1])

game:GetService("RunService").Stepped:Connect(function()
	library.pointers.SettingsTabCategoryConfigsBuild.options = versions["data"][library.pointers.Branch.value]["tables"]
	if not table.find(versions["data"][library.pointers.Branch.value]["tables"], library.pointers.Build.value) then
		library.pointers.SettingsTabCategoryConfigsBuild:Set(versions["data"][library.pointers.Branch.value]["tables"][1])
	end
	wait()
end)

local SettingsTabCategoryCredits = SettingsTab:AddCategory("Credits", 2)

SettingsTabCategoryCredits:AddLabel("UI Library - Modified Phantom Ware")

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
end)

UserInputService.InputBegan:Connect(function(key, isFocused)
	if key.KeyCode == library.pointers.SettingsTabCategoryUIToggleKeybind.value then
		library.base.Window.Visible = not library.base.Window.Visible
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

if readfile("hexagon/skin_changer/autoload.txt") ~= "" and isfile("hexagon/skin_changer/configs/"..readfile("hexagon/skin_changer/autoload.txt")) then
	local a,b = pcall(function()
		cfg = loadstring("return "..readfile("hexagon/skin_changer/configs/"..readfile("hexagon/skin_changer/autoload.txt")))()
	end)
	
	if a == false then
		warn("Config Loading Error", a, b)
	elseif a == true then
		library:LoadConfiguration(cfg)
	end
end