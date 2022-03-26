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

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/library.lua"))()

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
SkinsTabRifles:AddDropdown("Galil", {"Stock", "Hardware", "Hardware 2", "Toxicity", "Frosted", "Worn"}, "Stock", "SkinsTabRiflesGalil")
SkinsTabRifles:AddDropdown("Ak-47", {"Stock", "Hallows", "Ace", "Code Orange", "Clown", "Variant Camo", "Eve", "VAV", "Quantum", "Hypersonic", "Mean Green", "Bloodboom", "Scapter", "Skin Committee", "Patch", "Outlaws", "Gifted", "Ugly Sweater", "Secret Santa", "Precision", "Outrunner", "Godess", "Maker", "Ghost", "Glo", "Survivor", "Shooting Star", "Halo", "Inversion", "Plated", "Quicktime", "Yltude", "Jester", "Scythe", "Neonline", "Galaxy Corpse"}, "Stock", "SkinsTabRiflesAK47")
SkinsTabRifles:AddDropdown("Scout", {"Stock", "Xmas", "Coffin Biter", "Railgun", "Hellborn", "Hot Cocoa", "Theory", "Pulse", "Monstruo", "Flowing Mists", "Neon Regulation", "Posh", "Darkness"}, "Stock", "SkinsTabRiflesScout")
SkinsTabRifles:AddDropdown("SG 553", {"Stock", "Yltude", "Knighthood", "Variant Camo", "Magma", "DropX", "Dummy", "Kitty Cat", "Drop-Out", "Control"}, "Stock", "SkinsTabRiflesSG")
SkinsTabRifles:AddDropdown("AWP", {"Stock", "Grepkin", "Instinct", "Nerf", "JTF2", "Difference", "Weeb", "Pink Vision", "Desert Camo", "Bloodborne", "Lunar", "Scapter", "Coffin Biter", "Pear Tree", "Northern Lights", "Racer", "Forever", "Blastech", "Abaddon", "Retroactive", "Pinkie", "Autumness", "Venomus", "Hika", "Silence", "Kumanjayi", "Dragon", "Illusion", "Regina", "Quicktime", "Toxic Nitro", "Darkness", "Oriental", "Grim"}, "Stock", "SkinsTabRiflesAWP")
SkinsTabRifles:AddDropdown("G3SG1", {"Stock", "Foliage", "Hex", "Amethyst", "Autumn", "Mahogany", "Holly Bound"}, "Stock", "SkinsTabRiflesG3SG1")
SkinsTabRifles:AddDropdown("M4A4", {"Stock", "Devil", "Pinkvision", "Desert Camo", "BOT[S]", "Precision", "Candyskull", "Scapter", "Toy Soldier", "Endline", "Pondside", "Ice Cap", "Pinkie", "Racer", "Stardust", "King", "Flashy Ride", "RayTrack", "Mistletoe", "Delinquent", "Quicktime", "Jester", "Darkness"}, "Stock", "SkinsTabRiflesM4A4")
SkinsTabRifles:AddDropdown("AUG", {"Stock", "Phoenix", "Dream Hound", "Enlisted", "Homestead", "Sunsthetic", "NightHawk", "Maker", "Graffiti", "Chilly Night", "Mystique", "Soldier"}, "Stock", "SkinsTabRiflesAUG")
SkinsTabRifles:AddDropdown("Famas F1", {"Stock", "Abstract", "Haunted Forest", "Goliath", "Redux", "Toxic Rain", "Centipede", "Medic", "Cogged", "KugaX", "Shocker", "MK11", "Imprisioned"}, "Stock", "SkinsTabRiflesFamas")
SkinsTabRifles:AddDropdown("M4A1", {"Stock", "Toucan", "Animatic", "Desert Camo", "Wastelander", "Heavens Gate", "Tecnician", "Impulse", "Burning", "Lunar", "Necropolis", "Jester", "Nightmare"}, "Stock", "SkinsTabRiflesM4A1")

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
SkinsTabHeavy:AddDropdown("Nova", {"Stock", "Terraformer", "Tiger", "Black Ice", "Sharkesh", "Paradise", "Starry Night", "Cookie", "Tricked", "Defective", "Oath"}, "Stock", "SkinsTabHeavyNova")
SkinsTabHeavy:AddDropdown("XM1014", {"Stock", "Red", "Spectrum", "Artic", "Atomic", "Campfire", "Predator", "MK11", "Endless Night"}, "Stock", "SkinsTabHeavyXM")
SkinsTabHeavy:AddDropdown("MAG-7", {"Stock", "Molten", "Striped", "Frosty", "Outbreak", "Bombshell", "C4UTION"}, "Stock", "SkinsTabHeavyMAG7")
SkinsTabHeavy:AddDropdown("Sawed Off", {"Stock", "Spooky", "Colorbloom", "Casino", "Opal", "Executioner", "Sullys Blacklight"}, "Stock", "SkinsTabHeavySawedOff")
SkinsTabHeavy:AddDropdown("M249", {"Stock", "Aggressor", "Wolf", "P2020", "Spooky", "Lantern", "Halloween Treats"}, "Stock", "SkinsTabHeavyM249")
SkinsTabHeavy:AddDropdown("MG42", {"Stock", "Winterfell", "Default", "Quazar", "Midnightbones", "Wetland", "Striped"}, "Stock", "SkinsTabHeavyNegev")

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
					game:GetService('Players').LocalPlayer.SkinFolder.CTFolder.MP7.Value = library.pointers.SkinstabSMGsMP7.value
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
SkinsTabSMGs:AddDropdown("MP9", {"Stock", "Velvita", "Blueroyal", "Decked Halls", "Cookie Man", "Wilderness", "Vaporwave", "Cob Web", "SnowTime", "Control"}, "Stock", "SkinsTabSMGsMP9")
SkinsTabSMGs:AddDropdown("MAC-10", {"Stock", "Pimpin", "Wetland", "Turbo", "Golden Rings", "Skeleboney", "Artists Intent", "Toxic", "Blaze", "Scythe", "Devil"}, "Stock", "SkinsTabSMGsMAC10")
SkinsTabSMGs:AddDropdown("MP5", {"Stock", "Sunshot", "Calaxian", "Goo", "Holiday", "Silent Ops", "Industrial", "Reindeer", "Cogged", "Trauma"}, "Stock", "SkinsTabSMGsMP7")
SkinsTabSMGs:AddDropdown("UMP-45", {"Stock", "Militia Camo", "Magma", "Redline", "Death Grip", "Molten", "Gum Drop", "Orbit"}, "Stock", "SkinsTabSMGsUMP")
SkinsTabSMGs:AddDropdown("P90", {"Stock", "Skulls", "Redcopy", "Demon Within", "P-Chan", "Krampus", "Pine", "Elegant", "Northern Lights", "Argus", "Curse"}, "Stock", "SkinsTabSMGsP90")
SkinsTabSMGs:AddDropdown("Thompson", {"Stock", "Festive", "Shattered", "Oblivion", "Sergeant", "Saint Nick", "Autumic"}, "Stock", "SkinsTabSMGsBizon")

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
SkinsTabPistols:AddDropdown("Glock-18", {"Stock", "Desert Camo", "Day Dreamer", "Wetland", "Anubis", "Midnight Tiger", "Scapter", "Gravestomper", "Tarnish", "Rush", "Angler", "Spacedust", "Money Maker", "RSL", "White Sauce", "Biotrip", "Underwater", "Hallows"}, "Stock", "SkinsTabPistolsGlock")
SkinsTabPistols:AddDropdown("Dual Berettas", {"Stock", "Floral", "Xmas", "Neon web", "Hexline", "Carbonized", "Old Fashioned", "Dusty Manor"}, "Stock", "SkinsTabPistolsDualBerettas")
SkinsTabPistols:AddDropdown("P250", {"Stock", "Bomber", "Green Web", "TC250", "Amber", "Frosted", "Solstice", "Equinox", "Goldish", "Shark", "Midnight"}, "Stock", "SkinsTabPistolsP250")
SkinsTabPistols:AddDropdown("TEC-9", {"Stock", "Gift Wrapped", "Ironline", "Skintech", "Stocking Stuffer", "Samurai", "Phol", "Charger", "Performer", "Seasoned"}, "Stock", "SkinsTabPistolsTec9")
SkinsTabPistols:AddDropdown("Deagle", {"Stock", "Glittery", "Grim", "Weeb", "Krystallos", "Honor-bound", "TC", "Xmas", "Scapter", "Cool Blue", "Survivor", "Cold Truth", "Heat", "ROLVe", "Independence", "Racer", "Pumpkin Buster", "Skin Committee", "DropX", "Crystal", "Blue Fur"}, "Stock", "SkinsTabPistolsDesertEagle")
SkinsTabPistols:AddDropdown("PX4", {"Stock", "Comet", "Golden Age", "Apathy", "Candycorn", "Lunar", "Ruby", "Camo Dipped", "Dark Beast", "Pinkie", "Silence"}, "Stock", "SkinsTabPistolsP2000")
SkinsTabPistols:AddDropdown("Five-seveN", {"Stock", "Stigma", "Danjo", "Summer", "Gifted", "Midnight Ride", "Fluid", "Sub Zero", "Autumn Fade", "Mr. Anatomy"}, "Stock", "SkinsTabPistolsFiveSeven")
SkinsTabPistols:AddDropdown("USP-S", {"Stock", "Skull", "Yellowbelly", "Crimson", "Jade Dream", "Racing", "Frostbite", "Nighttown", "Paradise", "Dizzy", "Kraken", "Worlds Away", "Unseen", "Holiday", "Survivor"}, "Stock", "SkinsTabPistolsUSP")
SkinsTabPistols:AddDropdown("CZ75-Auto", {"Stock", "Lightning", "Orange Web", "Festive", "Spectre", "Designed", "Holidays", "Hallow"}, "Stock", "SkinsTabPistolsCZ")
SkinsTabPistols:AddDropdown("44 Magnum", {"Stock", "Violet", "Hunter", "Spades", "Exquisite", "TG"}, "Stock", "SkinsTabPistolsR8")

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
					    if library.pointers.SkinsTabAddSelection.value == "All" then
						    for i,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
							    if v:IsA("Folder") and game.ReplicatedStorage.Weapons:FindFirstChild(v.Name) then
								    if v.Name == "Gut Knife" or v.Name == "Bayonet" or v.Name == "Butterfly Knife" or v.Name == "Falchion Knife" or v.Name == "Karambit" or v.Name == "Huntsman Knife" or v.Name == "Cleaver" or v.Name == "Sickle" or v.Name == "Beared Axe" then
									    table.insert(AllSkinsTable, {v.Name.."_Stock"})
									
									    for i2,v2 in pairs(v:GetChildren()) do
										    if v2.Name ~= "Stock" then
											    table.insert(AllSkinsTable, {v.Name.."_"..v2.Name})
										    end
									    end
								    end
							    end
						    end
							
						    for i,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
							    if v:IsA("Folder") and game.ReplicatedStorage.Weapons:FindFirstChild(v.Name) then
								    table.insert(AllSkinsTable, {v.Name.."_Stock"})
							    end
						    end
				
						    for i,v in pairs(game.ReplicatedStorage.Gloves:GetChildren()) do
							    if v:IsA("Folder") and v.Name ~= "Models" then
								    for i2,v2 in pairs(v:GetChildren()) do
									    table.insert(AllSkinsTable, {v.Name.."_"..v2.Name})
								    end
							    end
						    end
					    elseif library.pointers.SkinsTabAddSelection.value == "Knives&Gloves" then
						    for i,v in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
							    if v:IsA("Folder") and game.ReplicatedStorage.Weapons:FindFirstChild(v.Name) then
								    if v.Name == "Gut Knife" or v.Name == "Bayonet" or v.Name == "Butterfly Knife" or v.Name == "Falchion Knife" or v.Name == "Karambit" or v.Name == "Huntsman Knife" or v.Name == "Cleaver" or v.Name == "Sickle" or v.Name == "Beared Axe" then
									    table.insert(AllSkinsTable, {v.Name.."_Stock"})
									
									    for i2,v2 in pairs(v:GetChildren()) do
										    if v2.Name ~= "Stock" then
											    table.insert(AllSkinsTable, {v.Name.."_"..v2.Name})
										    end
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
					    elseif library.pointers.SkinsTabAddSelection.value == "Stock Weapons" then
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
SkinsTabAdd:AddDropdown("Additional", {"Default", "Knives&Gloves", "Stock Weapons", "All"}, "Default", "SkinsTabAddSelection")

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

SettingsTabCategoryConfigs:AddDropdown("Branch", {"Hexagon Modified", "Skin Changer"}, "Skin Changer", "SettingsTabCategoryConfigsBranch")
SettingsTabCategoryConfigs:AddDropdown("Build", {"-"}, "-", "SettingsTabCategoryConfigsBuild")
SettingsTabCategoryConfigs:AddButton("Save", function()
	if library.pointers.SettingsTabCategoryConfigsBranch.value == "Hexagon Modified" then
        if library.pointers.SettingsTabCategoryConfigsBuild.value == "Stable" then
            writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModified.lua")
        elseif library.pointers.SettingsTabCategoryConfigsBuild.value == "Alpha" then
            writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonModifiedAlpha.lua")
        end
    elseif library.pointers.SettingsTabCategoryConfigsBranch.value == "Skin Changer" then
        if library.pointers.SettingsTabCategoryConfigsBuild.value == "-" then
            writefile("hexagon/load_version.txt", "https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/HexagonSkinChanger.lua")
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    pcall(function()
        if library.pointers.SettingsTabCategoryConfigsBranch.value == "Hexagon Modified" then
            library.pointers.SettingsTabCategoryConfigsBuild.options = {"Stable", "Alpha"}
            if library.pointers.SettingsTabCategoryConfigsBuild.value == "-" then
                library.pointers.SettingsTabCategoryConfigsBuild:Set("Stable")
            end
        elseif library.pointers.SettingsTabCategoryConfigsBranch.value == "Skin Changer" then
            library.pointers.SettingsTabCategoryConfigsBuild.options = {"-"}
            if library.pointers.SettingsTabCategoryConfigsBuild.value ~= "-" then
                library.pointers.SettingsTabCategoryConfigsBuild:Set("-")
            end
        end
    end)
end)

local SettingsTabCategoryCredits = SettingsTab:AddCategory("Credits", 2)

SettingsTabCategoryCredits:AddLabel("ESP - Modified Kiriot ESP")
SettingsTabCategoryCredits:AddLabel("UI Library - Modified Phantom Ware")

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