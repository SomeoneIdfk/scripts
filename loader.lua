--[[
    Made by:
    SomeoneIdfk
]]--

repeat wait() until game:IsLoaded()

-- Environment
local isfolder = isfolder or false

-- Config
if not isfolder("oblivion") then
    makefolder("oblivion")
end

-- Main
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local versions = loadstring("return "..game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/versions.cfg"))()

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
				
				--[[if Key:match'%s' then
					Key = ('["%s"]'):format(Key)
				end]]--
				
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

local function checkId(func)
	for i,v in pairs(versions) do
        if type(v.gameid) == "table" and table.find(v.gameid, game.PlaceId) or type(v.gameid) == "number" and v.gameid == game.PlaceId then
            return func == "table" and v or func == "gameid" and game.PlaceId
        end
    end

	return false
end

local function checkFile(func)
    if isfile("oblivion/settings.cfg") then
        local var = loadstring("return "..readfile("oblivion/settings.cfg"))()
		if var and func == "file" then
			return var
		end
		if var and type(var) == "table" then
			for i,v in pairs(var) do
				local gameid = checkId("gameid")
				local idtable = checkId("table")
				if gameid and idtable then
					if type(v.gameid) == "table" and table.find(v.gameid, gameid) and table.find(idtable.tables, v.branch) and table.find(idtable.data[v.branch].tables, v.build) and v.url == idtable.data[v.branch].data[v.build] and v.folder == idtable.folder or type(v.gameid) == "number" and v.gameid == gameid and table.find(idtable.tables, v.branch) and table.find(idtable.data[v.branch].tables, v.build) and v.url == idtable.data[v.branch].data[v.build] and v.folder == idtable.folder then
						return func == "url" and v.url or func == "build" and v.build
					end
				end
			end
		end
    end

    return false
end

local function getAllNames(datatable)
    local temp = {}
	table.foreach(datatable, function(i,v) table.insert(temp, v) end)
	return temp
end

-- GUI
local preidcheck = checkId("table")
local prefilecheck = checkFile("url")
if preidcheck and prefilecheck then
    OrionLib:MakeNotification({Name = "Oblivion", Content = "Loading "..checkFile("build")..".", Image = "rbxassetid://4483362458", Time = 5})
    loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/"..prefilecheck))();
elseif preidcheck and prefilecheck == false then
    OrionLib:MakeNotification({Name = "Oblivion", Content = "Welcome to Oblivion - "..game.Players.LocalPlayer.Name, Image = "rbxassetid://4431165334", Time = 5})
    local Window = OrionLib:MakeWindow({Name = "Oblivion Loader", HidePremium = true, SaveConfig = false, ConfigFolder = "oblivion"})
    local SettingsTab = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://3605022185", PremiumOnly = false})

    SettingsTab:AddDropdown({Name = "Branch", Default = "-", Options = {"-"}, Flag = "branch", Callback = function(val)
        if OrionLib.Flags["build"] then
            OrionLib.Flags["build"]:Refresh(getAllNames(preidcheck["data"][val]["tables"]), true)
            OrionLib.Flags["build"]:Set(preidcheck["data"][val]["tables"][1])
        end
    end})
    SettingsTab:AddDropdown({Name = "Build", Default = "-", Options = {"-"}, Flag = "build"})
    SettingsTab:AddButton({Name = "Set", Callback = function()
		local prefilecheckdata = checkFile("file")
		local temp = {}
		if prefilecheckdata then
			for i,v in pairs(prefilecheckdata) do
                if table.find(preidcheck.tables, v.branch) and table.find(preidcheck.data[v.branch].tables, v.build) and preidcheck.data[v.branch].data[v.build] ~= v.url then
                    table.insert(temp, v)
                elseif table.find(preidcheck.tables, v.branch) == false then
                    table.insert(temp, v)
                end
			end
		end
		table.insert(temp, {url = preidcheck.data[OrionLib.Flags["branch"].Value].data[OrionLib.Flags["build"].Value], branch = OrionLib.Flags["branch"].Value, build = OrionLib.Flags["build"].Value, folder = preidcheck.folder, gameid = preidcheck.gameid})
        writefile("oblivion/settings.cfg", SaveTable(temp))
		OrionLib:MakeNotification({Name = "Oblivion", Content = "Loading "..checkFile("build")..".", Image = "rbxassetid://4483362458", Time = 5})
    	loadstring(game:HttpGet("https://raw.githubusercontent.com/SomeoneIdfk/scripts/main/"..checkFile("url")))();
    end})

    OrionLib.Flags["branch"]:Refresh(preidcheck["tables"], true)
    OrionLib.Flags["branch"]:Set(preidcheck["tables"][1])
    OrionLib:Init()
elseif not preidcheck then
	OrionLib:MakeNotification({Name = "Oblivion", Content = "Failed to load: Running on an incompatible game!", Image = "rbxassetid://4384402990", Time = 5})
end