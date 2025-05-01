local PlayerFuncs = {}

local Players = game:GetService("Players")

function PlayerFuncs.GetCharacters()
	local chars = {}
	for _,plr in Players:GetPlayers() do
		if plr.Character then
			table.insert(chars,plr.Character)
		end
	end
	return chars
end

function PlayerFuncs.GetCharactersNear(pos:Vector3,radius:number)
	local near = {}
	local chars = PlayerFuncs.GetCharacters()
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

function PlayerFuncs.GetPlayersNear(pos:Vector3,radius:number)
	local charsNear = PlayerFuncs.GetCharactersNear(pos,radius)
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

function PlayerFuncs.MoveCharsToCF(characters:{Model},newCF:CFrame)
	for _,char in characters do
		char:PivotTo(newCF)
	end
end

function PlayerFuncs.MovePlayersToCF(players:{Player},newCF:CFrame)
	for _,plr in players do
		if plr.Character then
			plr.Character:PivotTo(newCF)
		end
	end
end

function PlayerFuncs.MovePlayersToParts(players:{Player},parts:{BasePart})
	for i,plr in players do
		if plr.Character then
			plr.Character:PivotTo(parts[(i-1)%#parts+1])
		end
	end
end

return PlayerFuncs
