local useful = {}

local Players = game:GetService("Players")

useful.tau = math.pi*2
local charOlap = OverlapParams.new()
charOlap.FilterType = Enum.RaycastFilterType.Include

function useful.GetCharacters()
	local chars = {}
	for _,plr in Players:GetPlayers() do
		if plr.Character then
			table.insert(chars,plr.Character)
		end
	end
	return chars
end

function useful.GetCharactersNear(pos:Vector3,radius:number)
	local near = {}
	local chars = useful.GetCharacters()
	for _,char in chars do
		local hrp:BasePart = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			if (hrp.Position-pos).Magnitude<radius then
				table.insert(near,char)
			end
		end
	end
	return near
end

function useful.GetPlayersNear(pos:Vector3,radius:number)
	local charsNear = useful.GetCharactersNear(pos,radius)
	local playersNear = {}
	for _,char in charsNear do
		local plr = Players:GetPlayerFromCharacter(char)
		if plr then
			table.insert(playersNear,plr)
		end
	end
	charsNear = nil
	return playersNear
end

function useful.GetPlayersInPart(part:Part)
	local plrs = {}
	charOlap.FilterDescendantsInstances = useful.GetCharacters()
	
	local charParts = workspace:GetPartsInPart(part,charOlap)
	for _,charPart in charParts do
		local pfound = Players:GetPlayerFromCharacter(charPart.Parent)
		if pfound then
			if not table.find(plrs,pfound) then
				table.insert(plrs,pfound)
			end
		end
	end
	return plrs
end

function useful.MoveCharsToCF(characters:{Model},newCF:CFrame)
	for _,char in characters do
		char:PivotTo(newCF)
	end
end

function useful.MovePlayersToCF(players:{Player},newCF:CFrame)
	for _,plr in players do
		if plr.Character then
			plr.Character:PivotTo(newCF)
		end
	end
end

function useful.MovePlayersToParts(players:{Player},parts:{BasePart},radius:number?,offset:Vector3?)
	local radius = radius or 0
	local offset = offset or Vector3.yAxis*4
	for i,plr in players do
		if plr.Character then
			local ang = math.random()*useful.tau
			plr.Character:PivotTo(
				parts[(i-1)%#parts+1].CFrame+offset+
					Vector3.new(math.cos(ang)*radius,0,math.sin(ang)*radius)
			)
		end
	end
end

function useful.RandomWithDuplicates(theTable: {}, count: number)
	local chosenValues = {}
	local keyBank = {}

	-- Gather all keys
	for k, _ in pairs(theTable) do
		table.insert(keyBank, k)
	end

	-- Pull unique values first
	local available = math.min(count, #keyBank)
	for i = 1, available do
		local chooseI = math.random(1, #keyBank)
		local key = keyBank[chooseI]
		table.insert(chosenValues, theTable[key])
		table.remove(keyBank, chooseI)
	end

	-- Fill the rest with random values (can include duplicates)
	local keys = {}
	for k, _ in pairs(theTable) do
		table.insert(keys, k)
	end
	for i = available + 1, count do
		local randKey = keys[math.random(1, #keys)]
		table.insert(chosenValues, theTable[randKey])
	end

	return chosenValues
end

function useful.RandomNoDuplicates(theTable:{},count:number)
	local chosenValues = {}
	local keyBank = {}
	for k,v in theTable do
		table.insert(keyBank,k)
	end
	for i=1,count do
		print(#keyBank)
		local chooseI = math.random(1,#keyBank+1)
		table.insert(chosenValues,theTable[keyBank[chooseI]])
		table.remove(keyBank,chooseI)
	end
	print(chosenValues)
	return chosenValues
end

return useful
