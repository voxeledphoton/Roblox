local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local CS = game:GetService("CollectionService")

local mExtras = require(RS.Modules.Extras)

local enemies = {}
local connections = {}

local function clearEnemy(enemy)
	enemy:Destroy()
	for _,con in connections[enemies[i]] do
		con:Disconnect()
	end
	table.remove(enemies,table.find(enemy))
end

local function destroyEnemies()
	for i=#enemies,1,-1 do
		clearEnemy(enemies[i])
	end
end

local function setupEnemy(enemy:Model)
	local hum:Humanoid = enemy:WaitForChild("Humanoid")
	local startPos = enemy:GetPivot().Position
	connections[enemy] = {}
	connections[enemy].PreSimulation = RunService.PreSimulation:Connect(function()
		local nearPlr,nearChar,nearPos = mExtras.FindNear(enemy:GetPivot().Position)
		if nearPos then
			if (startPos-nearPos).Magnitude<16 then
				hum:MoveTo(nearPos)
			else
				hum:MoveTo(startPos)
			end
		end
	end)
	connections[enemy].AncestryChanged = enemy.AncestryChanged:Connect(function(child,parent)
		if parent==nil then
			clearEnemy(enemy)
		end
	end)
	
	table.insert(enemies,enemy)
end

CS:GetInstanceAddedSignal("Enemy"):Connect(setupEnemy)
for _,enemy in CS:GetTagged("Enemy") do
	setupEnemy(enemy)
end
