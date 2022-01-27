local plr  = game:GetService('Players').LocalPlayer
local team = game:GetService("ReplicatedStorage").Events.JoinTeam
local data = game:GetService("Workspace").Status
local v_u  = game:GetService('VirtualUser')

local script_version = '1.2'
local script_creator = 'SomeoneIdfk'
local github = 'https://raw.githubusercontent.com/BotTheWarrior/scripts/main/FARM.lua'

print('[FARM] Version:', script_version)
print('[FARM] Info: This was made with scripts found online and heavily modified to customize it to my liking. It also uses the Hexagon hub.')
print('[FARM] Warning: This is still in beta and is not garanteed to always work.')
print('[FARM] Creator:', script_creator)
print('[FARM] Github:', github)

print('[FARM] Loading...')

worker = 0
fvalue = 0
svalue = 0
last_team = 'Spectator'
last_team_try = 'Spectator'
team:FireServer('Spectator')

--Auto-team to join a team automatically.
local function win_check()

    worker = worker + 1



    if fvalue ~= 60 then
        fvalue = fvalue + 1

        --If the first or last round is tied, server-hop.
        if data.TWins.Value == 7 and data.CTWins.Value == 7 then
            Serverhop()
        elseif data.TWins.Value == 0 and data.CTWins.Value == 0 then
            Serverhop()

        elseif data.TWins.Value ~= data.CTWins.Value then
            --Check if T wins are above 4 and try and join it.
            --Check if wins are above 4.
            if svalue == 60 then
                svalue = 0
                if data.TWins.Value > 4 and data.TWins.Value > data.CTWins.Value then
                    if tostring(game:GetService('Players').LocalPlayer.Team) ~= last_team then
                        if last_team_try ~= 'Terrorists' then
                            last_team_try = 'Terrorists'
                            print('[FARM][T] Trying to join the team. >', game:GetService('Players').LocalPlayer.Team, '<')
                        end
                        
                        team:FireServer('T')
                        if tostring(game:GetService('Players').LocalPlayer.Team) == 'Terrorists' then
                            last_team = tostring(game:GetService('Players').LocalPlayer.Team)
                            print('[FARM][T] Joined the team. >', last_team, '<')
                        --else
                            --if last_team == 'Spectator' then
                                --team:FireServer('CT')
                            --end
                        end
                    end
            

                --Check if CT wins are above 4 and try and join it.
                --Check if wins are above 4.
                elseif data.CTWins.Value > 4 and data.CTWins.Value > data.TWins.Value then
                    if tostring(game:GetService('Players').LocalPlayer.Team) ~= last_team then
                        if last_team_try ~= 'Counter-Terrorists' then
                            last_team_try = 'Counter-Terrorists'
                            print('[FARM][CT] Trying to join the team. >', game:GetService('Players').LocalPlayer.Team, '<')
                        end
                        
                        team:FireServer('CT')
                        if tostring(game:GetService('Players').LocalPlayer.Team) == 'Counter-Terrorists' then
                            last_team = tostring(game:GetService('Players').LocalPlayer.Team)
                            print('[FARM][CT] Joined the team. >', last_team, '<')
                        --else
                            --if last_team == 'Spectator' then
                                --team:FireServer('T')
                            --end
                        end
                    end
                end
            else
                svalue = svalue + 1
            end
        end
    else
        fvalue = 0

        if plr.Character.Humanoid.Health ~= 0 then
            if data.TWins.Value >= data.CTWins.Value and tostring(game:GetService('Players').LocalPlayer.Team) == 'Terrorists' then
                --Anti-afk so you won't get kicked for being afk.
                wait(6)
                if plr.Character.Humanoid.Health ~= 0 then
                    print('[FARM][Anti-AFK] Setting health to 0 so you will hopefully not be kicked for being idle. (Not very well tested and will improve this system in the future.)')

                    plr.Character.Humanoid.Health = 0
                end

            elseif data.CTWins.Value >= data.TWins.Value and tostring(game:GetService('Players').LocalPlayer.Team) == 'Counter-Terrorists' then
                --Anti-afk so you won't get kicked for being afk.
                wait(6)
                if plr.Character.Humanoid.Health ~= 0 then
                    print('[FARM][Anti-AFK] Setting health to 0 so you will hopefully not be kicked for being idle. (Not very well tested and will improve this system in the future.)')

                    plr.Character.Humanoid.Health = 0
                end
            end
        end
    end
end

print('[FARM] Loaded auto-team.')
print('[FARM] Loaded anti-afk.')


--Server-hopping for various reasons.
function Serverhop()
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

if data.TWins.Value < 5 and data.CTWins.Value < 5 then
    Serverhop()
    wait(10)
end

repeat wait() until game:IsLoaded()

loadstring(game:HttpGet("https://raw.githubusercontent.com/ionlol/Hexagon-fixed-for-July-28-Roblox-update-/main/fix"))();

--Loop the auto-team.
game:GetService('RunService'):BindToRenderStep('win_check',190,win_check)
