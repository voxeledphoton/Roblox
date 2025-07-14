
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- this would work better as a module you can require from a modulescript so client can use it to promptpurchase
local passes = {
	RainbowCarpetID = 000000 -- replace with gamepass id
}

local rainbowTool = script:WaitForChild("Rainbow")

local function givePassBonus(plr:Player,id:number)
	if id==passes.RainbowCarpetID then
		local newRainbow = rainbowTool:Clone()
		newRainbow.Parent = plr.Backpack
		
		plr.CharacterAdded:Connect(function()
			local newRainbow = rainbowTool:Clone()
			newRainbow.Parent = plr.Backpack
		end)
	end
end

-- Handle a completed prompt and purchase
local function onPromptPurchaseFinished(player, purchasedPassID, purchaseSuccess)
	if purchaseSuccess then
		print(player.Name .. " purchased the Pass with ID " .. purchasedPassID)
		-- Assign the user the ability or bonus related to the pass
		givePassBonus(player,purchasedPassID)
	end
end
MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptPurchaseFinished)


local function onPlayerAdded(plr:Player)
	for passName,passID in passes do
		local hasPass = false

		-- Check if user already owns the pass
		local success, message = pcall(function()
			hasPass = MarketplaceService:UserOwnsGamePassAsync(plr.UserId, passID)
		end)

		if not success then
			-- Issue a warning and exit the function
			warn("Error while checking if player has pass: " .. tostring(message))
			return
		end

		if hasPass then
			-- Assign user the ability or bonus related to the pass
			print(plr.Name .. " owns the Pass with ID " .. passID)
			givePassBonus(plr,passID)
		end
	end
	
end
Players.PlayerAdded:Connect(onPlayerAdded)
for _,plr in Players:GetPlayers() do
	onPlayerAdded(plr)
end


