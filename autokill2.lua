task.wait(1)
if not game:IsLoaded() then
	game.Loaded:Wait()
end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") -- skull
local istping = false
local cons = {}
local function tp()
	task.wait(4)
	--task.wait(2)
	local servers = {}
	local req = request({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
	local body = game.HttpService:JSONDecode(req.Body)

	if body and body.data then
		for i, v in next, body.data do
			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
				table.insert(servers, 1, v.id)
			end
		end
	end

	if #servers > 0 then
		if not istping then
			istping = true
			local success, e = pcall(function()
				game.TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)	
			end)
			if not success then istping = false tp() end
		end
	end
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

table.insert(cons, game:GetService("RunService").RenderStepped:Connect(function()
    local Tool = Player.Character:FindFirstChildOfClass("Tool")
	if Tool ~= nil then 
		Tool:Activate()
		local Handle = Tool.Handle
		for i,Targ in pairs(Players:GetPlayers()) do 
			if Targ and Targ ~= Player and Targ.Character and Targ.Character:FindFirstChildOfClass("Humanoid") and Targ.Character:FindFirstChildOfClass("Humanoid"):GetState() ~= Enum.HumanoidStateType.Dead then 
				for i,v in pairs(Targ.Character:GetChildren()) do 
					if v:IsA("BasePart") then 
						firetouchinterest(Handle, v, 0)
						firetouchinterest(Handle, v, 1)
					end
				end
			end
		end
	else
		if Player.Backpack:FindFirstChildOfClass("Tool") then 
			Player.Backpack:FindFirstChildOfClass("Tool").Parent = Player.Character
		end
	end
	Player.Character.HumanoidRootPart.CFrame = CFrame.new(31, 5000, 212)
	task.spawn(function()
		Player.Character.HumanoidRootPart.CFrame = CFrame.new(31, 5000, 212)
		for i,v in pairs(Player.Character:GetDescendants()) do 
			if v:IsA("BasePart") then 
				v.Velocity = Vector3.new(0,0,0)
				v.RotVelocity = Vector3.new(0,0,0)
			end
		end
	end)
	if #game.Players:GetPlayers() <= 23422 then 
		tp()
	end
end))

table.insert(cons, Player.OnTeleport:Connect(function()
	if not queue then
		queue = true
		for i,v in pairs(cons) do 
			v:Disconnect() 
			v = nil 
		end
		queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Paupxx/Scripts2/main/autokill2.lua"))()')
	end
end))