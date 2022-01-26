local plr  = game:GetService('Players').LocalPlayer
local team = game:GetService("ReplicatedStorage").Events.JoinTeam
local data = game:GetService("Workspace").Status
local v_u  = game:GetService('VirtualUser')

local script_version = '1.0'
local script_creator = 'Unknown'

print('[FARM] Version:', script_version)
print('[FARM] Info: This was made with scripts found online and modified to customize it to my liking.')
print('[FARM] Warning: This is still in beta and is not garanteed to work.')
print('[FARM] Creator:', script_creator)

print('[FARM] Loading...')

jvalue = 0
lvalue = 0

local function win_check()
    if data.TWins.Value == 7 and data.CTWins.Value == 7 then
        Serverhop()
    elseif data.TWins.Value == 0 and data.CTWins.Value == 0 then
        Serverhop()
    elseif data.TWins.Value == 1 and data.CTWins.Value == 1 then
        Serverhop()
    elseif data.TWins.Value == 2 and data.CTWins.Value == 2 then
        Serverhop()
    elseif data.TWins.Value == 3 and data.CTWins.Value == 3 then
        Serverhop()
    end

    if data.TWins.Value > 7 and game:GetService('Players').LocalPlayer.Team == 'Terrorists' then
        wait(15)
        Serverhop()
    elseif data.TWins.Value > 7 and game:GetService('Players').LocalPlayer.Team == 'Counter-Terrorists' then
        Serverhop()
    elseif data.CTWins.Value > 7 and game:GetService('Players').LocalPlayer.Team == 'Counter-Terrorists' then
        wait(15)
        Serverhop()
    elseif data.CTWins.Value > 7 and game:GetService('Players').LocalPlayer.Team == 'Terrorists' then
        Serverhop()
    end

    if data.TWins.Value ~= data.CTWins.Value then

        if data.TWins.Value > 4 and game:GetService('Players').LocalPlayer.Team ~= 'Terrorists' then
            if data.TWins.Value > data.CTWins.Value then
                if jvalue ~= 100 then
                    jvalue = jvalue + 1
                else
                    lvalue = 0
                    jvalue = 0
                    print('[FARM][T] Trying to join the team or spectating it.')

                    team:FireServer('T')
                    team:FireServer('CT')
                    team:FireServer('T')
                end
            end
        
           
        elseif data.CTWins.Value > 4 and game:GetService('Players').LocalPlayer.Team ~= 'Counter-Terrorists' then
            if data.CTWins.Value > data.TWins.Value then
                if jvalue ~= 100 then
                    jvalue = jvalue + 1
                else
                    lvalue = 0
                    jvalue = 0
                    print('[FARM][CT] Trying to join the team or spectating it.')
                    
                    team:FireServer('CT')
                    team:FireServer('T')
                    team:FireServer('CT')
                end
            end

        else
            print(lvalue, 'out of 2000 before server-hopping.')
            if lvalue ~= 2000 then
                lvalue = lvalue + 1
            else
                Serverhop()
            end
        end

    else
        print(lvalue, 'out of 2000 before server-hopping.')
        if lvalue ~= 2000 then
            lvalue = lvalue + 1
        else
            Serverhop()
        end
    end
end

print('[FARM] Loaded auto-team.')

game:GetService("Players").LocalPlayer.Idled:connect(function()
    v_u:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    v_u:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
 end)

print('[FARM] Loaded anti-afk.')

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

game:GetService('RunService'):BindToRenderStep('win_check',190,win_check)
