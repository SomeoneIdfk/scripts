local plr  = game:GetService('Players').LocalPlayer
local team = game:GetService("ReplicatedStorage").Events.JoinTeam
local data = game:GetService("Workspace").Status
local v_u  = game:GetService('VirtualUser')

local script_version = '1.3'
local script_creator = 'SomeoneIdfk#4763'
local github = 'https://github.com/SomeoneIdfk/scripts'

print('[FARM] Version:', script_version)
print('[FARM] Warning: This is still in beta and is not garanteed to always work.')
print('[FARM] Creator:', script_creator)
print('[FARM] Github:', github)

print('[FARM] Loading...')

trueorfalse = true
last_team_try = 'Spectator'
value = 0
map = game:GetService("Workspace").Map.Origin.Value

local function win_check()
    if value ~= 30 then
        value = value + 1
        if value == 15 then
            if data.TWins.Value == 7 and data.CTWins.Value == 7 then
                while true do
                    Serverhop()
                    wait(10)
                end
            elseif data.Rounds.Value == 1 then
                while true do
                    Serverhop()
                    wait(10)
                end
        
            elseif data.TWins.Value ~= data.CTWins.Value then
                if data.TWins.Value > 4 and data.TWins.Value > data.CTWins.Value then
                    if game:GetService('Players').LocalPlayer.Status.Team.Value ~= "T" then
                        if last_team_try ~= "T" then
                            last_team_try = "T"
                            print('[FARM][T] Trying to join the team. >', game:GetService('Players').LocalPlayer.Status.Team.Value, '<')
                        end
        
                        if data.NumT.Value <= data.NumCT.Value then
                            team:FireServer('T')
                            wait(1)
                            if game:GetService('Players').LocalPlayer.Status.Team.Value == "T" then
                                print('[FARM][T] Joined the team. >', game:GetService('Players').LocalPlayer.Status.Team.Value, '<')
                            end
                        elseif (data.NumT.Value - data.NumCT.Value) == 1 then
                            if game:GetService('Players').LocalPlayer.Status.Team.Value == "Spectator" then
                                team:FireServer('CT')
                                team:FireServer('T')
                                wait(1)
                                if game:GetService('Players').LocalPlayer.Status.Team.Value == "T" then
                                    print('[FARM][T] Joined the team. >', game:GetService('Players').LocalPlayer.Status.Team.Value, '<')
                                end
                            end
                        end
                    end
        
                elseif data.CTWins.Value > 4 and data.CTWins.Value > data.TWins.Value then
                    if game:GetService('Players').LocalPlayer.Status.Team.Value ~= "CT" then
                        if last_team_try ~= "CT" then
                            last_team_try = "CT"
                            print('[FARM][CT] Trying to join the team. >', game:GetService('Players').LocalPlayer.Status.Team.Value, '<')
                        end
        
                        if data.NumCT.Value <= data.NumT.Value then
                            team:FireServer('CT')
                            wait(1)
                            if game:GetService('Players').LocalPlayer.Status.Team.Value == "CT" then
                                print('[FARM][CT] Joined the team. >', game:GetService('Players').LocalPlayer.Status.Team.Value, '<')
                            end
                        elseif (data.NumCT.Value - data.NumT.Value) == 1 then
                            if game:GetService('Players').LocalPlayer.Status.Team.Value == "Spectator" then
                                team:FireServer('T')
                                team:FireServer('CT')
                                wait(1)
                                if game:GetService('Players').LocalPlayer.Status.Team.Value == "CT" then
                                    print('[FARM][CT] Joined the team. >', game:GetService('Players').LocalPlayer.Status.Team.Value, '<')
                                end
                            end
                        end
                    end
                end
            end
        elseif value == 29 then
            if game:GetService("Workspace").Map.Origin.Value ~= map then
                while true do
                    Serverhop()
                    wait(10)
                end
            end
        end
    elseif value == 30 then
        value = 0
        if plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health ~= 0 and trueorfalse == true then
                trueorfalse = false
                wait(6)
                plr.Character.Humanoid.Health = 0
                print('[FARM][Anti-AFK] Setting health to 0 so you will hopefully not be vote kicked by other players for being idle.')
                wait(1)
                trueorfalse = true
            end
        end
    end
end

print('[FARM] Loaded auto-team.')
print('[FARM] Loaded anti-afk.')

function Serverhop()
    wait(1)
	local x = {}
	for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
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

print('[FARM] Loaded server-hop.')

repeat wait() until game:IsLoaded()

if data.TWins.Value < 5 or data.CTWins.Value < 5 then
    while true do
        Serverhop()
        wait(10)
    end
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/ionlol/Hexagon-fixed-for-July-28-Roblox-update-/main/fix"))();

game:GetService('RunService'):BindToRenderStep('win_check',190,win_check)
