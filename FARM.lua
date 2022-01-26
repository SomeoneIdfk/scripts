local plr  = game:GetService('Players').LocalPlayer
local team = game:GetService("ReplicatedStorage").Events.JoinTeam
local data = game:GetService("Workspace").Status
local v_u  = game:GetService('VirtualUser')

local script_version = '1.1'
local script_creator = 'SomeoneIdfk'
local github = 'https://raw.githubusercontent.com/BotTheWarrior/scripts/main/FARM.lua'

print('[FARM] Version:', script_version)
print('[FARM] Info: This was made with scripts found online and heavily modified to customize it to my liking.')
print('[FARM] Warning: This is still in beta and is not garanteed to always work.')
print('[FARM] Creator:', script_creator)
print('[FARM] Github:', github)

print('[FARM] Loading...')

worker = 0
value = 0
last_team = 'Spectator'

--Auto-team to join a team automatically.
local function win_check()

    worker = worker + 1

    --If the last round is tied and if either team is below 5 wins, server-hop.
    if data.TWins.Value == 7 and data.CTWins.Value == 7 then
        Serverhop()
    elseif data.TWins.Value < 5 and data.CTWins.Value < 5 then
        Serverhop()

    elseif data.TWins.Value ~= data.CTWins.Value then
        --Check if T wins are above 4 and try and join it.
        --Check if wins are above 4.
        if data.TWins.Value > 4 and data.TWins.Value > data.CTWins.Value then
            --Check if wins are higher then the competition.
            --Loop so you don't get kicked for switching teams to fast.
            if value ~= 30 then
                value = value + 1
            else
                value = 0

                if game:GetService('Players').LocalPlayer.Team ~= last_team then
                    print('[FARM][T] Trying to join the team. >', game:GetService('Players').LocalPlayer.Team, '<')
                    team:FireServer('T')
                    if game:GetService('Players').LocalPlayer.Team ~= 'Counter-Terrorists' then
                        last_team = game:GetService('Players').LocalPlayer.Team
                        print('[FARM][T] Joined the team. >', last_team, '<')
                    end
                else
                    team:FireServer('T')
                end
            end

        --Check if CT wins are above 4 and try and join it.
        --Check if wins are above 4.
        elseif data.CTWins.Value > 4 and data.CTWins.Value > data.TWins.Value then
            --Check if wins are higher then the competition.
            --Loop so you don't get kicked for switching teams to fast.
            if value ~= 30 then
                value = value + 1
            else
                value = 0

                if game:GetService('Players').LocalPlayer.Team ~= last_team then
                    print('[FARM][CT] Trying to join the team. >', game:GetService('Players').LocalPlayer.Team, '<')
                    team:FireServer('CT')
                    if game:GetService('Players').LocalPlayer.Team ~= 'Terrorists' then
                        last_team = game:GetService('Players').LocalPlayer.Team
                        print('[FARM][CT] Joined the team. >', last_team, '<')
                    end
                else
                    team:FireServer('CT')
                end
            end
        end
    end
end



print('[FARM] Loaded auto-team.')


--Anti-afk so you won't get kicked for being afk.
game:GetService("Players").LocalPlayer.Idled:connect(function()
    v_u:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    v_u:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
 end)

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



--Loop the auto-team.
game:GetService('RunService'):BindToRenderStep('win_check',190,win_check)
