local CharacterSpawner = {}

local Players = game:GetService("Players")


local function getCharacterHeight(model)
	local minY, maxY = math.huge, -math.huge
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local topY = part.Position.Y + part.Size.Y / 2
			local bottomY = part.Position.Y - part.Size.Y / 2
			maxY = math.max(maxY, topY)
			minY = math.min(minY, bottomY)
		end
	end
	return maxY - minY
end

function CharacterSpawner.SpawnCharacterOnPart(plrID:number, part:BasePart, animationId:string)
	assert(part and part:IsA("BasePart"), "Invalid part provided")
	assert(animationId and typeof(animationId) == "string", "Invalid animationId")

	-- Create a dummy character (R15)
	local dummy = Players:CreateHumanoidModelFromUserId(plrID)
	local pname = ""
	local result,err = pcall(function()
		pname = Players:GetNameFromUserIdAsync(plrID)
	end)
	dummy.Name = pname
	dummy.Parent = part

	local hrp = dummy:WaitForChild("HumanoidRootPart")
	hrp.Anchored = true
	-- Position it on top of the part
	local charHeight = getCharacterHeight(dummy)
	dummy:PivotTo(part.CFrame + Vector3.new(0, part.Size.Y/2 + charHeight/2, 0))

	-- Play animation
	local humanoid = dummy:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		--dummy:PivotTo(part.CFrame + Vector3.new(0, part.Size.Y/2 + humanoid.HipHeight, 0))
		local animation = Instance.new("Animation")
		animation.AnimationId = "rbxassetid://" .. animationId
		local track = humanoid:LoadAnimation(animation)
		track:Play()
	end

	return dummy
end

return CharacterSpawner
