task.wait(0.1)
local function tp()
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
		game.TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
	end
end

game.Players.PlayerRemoving:Connect(function(p)
	if #game.Players:GetPlayers() <= 5 then 
		tp()
	end
end)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

game:GetService("RunService").RenderStepped:Connect(function()
    if Player and Player.Character then 
		Player.Character.HumanoidRootPart.CFrame = CFrame.new(31, 5000, 212)
        for i,v in pairs(Player.Character:GetDescendants()) do 
			if v:IsA("BasePart") then 
				v.Velocity = Vector3.new(0,0,0)
				v.RotVelocity = Vector3.new(0,0,0)
			end
		end
		local Handle = Player.Character:FindFirstChildOfClass("Tool") and Player.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Handle")
        if Handle then 
			Handle.Parent:Activate()
			for i,Targ in pairs(game.Players:GetPlayers()) do 
				if Targ and Targ ~= Player and Targ.Character and Targ.Character:FindFirstChildOfClass("Humanoid") and Targ.Character:FindFirstChildOfClass("Humanoid"):GetState() ~= Enum.HumanoidStateType.Dead then 
					if not Targ.Character:FindFirstChildOfClass("ForceField") then 
						for i,v in pairs(Targ.Character:GetChildren()) do 
							if v:IsA("BasePart") then 
								firetouchinterest(Handle, v, 0)
								firetouchinterest(Handle, v, 1)
							end
						end
					end
				end
			end
		else
			if Player.Backpack:FindFirstChildOfClass("Tool") then 
				Player.Backpack:FindFirstChildOfClass("Tool").Parent = Player.Character
			end
        end
    end
	if #game.Players:GetPlayers() <= 5 then 
		tp()
	end
end)

game.Players.LocalPlayer.OnTeleport:Connect(function()
	queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/Paupxx/Scripts2/main/autokill%5Bno%20constant%20hop%5D.lua"))()')
end)