--[[
by proximitynode @voxeledphoton
this script allows for the creation of "BadgeGiver" parts
steps:
  put this in serverscriptservice
  add a part and tag it with BadgeGiver
  create a badge and use it to set a number attribute called badgeID on the part
]]

local CS = game:GetService("CollectionService")
local BS = game:GetService("BadgeService")
local Players = game:GetService("Players")

local tagName = "BadgeGiver"
local function setupBadgePart(part:BasePart)
	local badgeID = part:GetAttribute("badgeID")
	if not badgeID then warn("badgeID attribute not assigned") return end
	part.Touched:Connect(function(hit)
		if hit.Parent then
			local plr = Players:GetPlayerFromCharacter(hit.Parent)
			if plr then
				BS:AwardBadge(plr.UserId,badgeID)
			end
		end
	end)
end

CS:GetInstanceAddedSignal(tagName)
for _,v in CS:GetTagged(tagName) do
	setupBadgePart(v)
end
