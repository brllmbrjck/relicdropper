-- RelicDropper.lua
-- by: Goldeen
--
-- Based on:
-- RelicInspector.lua
-- Author: Thoralie

local addonName, addon = ...

function findRelicID(spellId)
	retVal = {}
	for x, spell_id in pairs(addon.SpellIDByRelic) do
		if spell_id == spellId then
			table.insert(retVal, x)
		end
		
	end
	return retVal
end

--Type,Name,Boss,Zone == Item ID
function findRelicDetails(relicId)
	for key, value in pairs(addon.Relics) do
		
		if  (tonumber(relicId) == tonumber(key)) then
			--print ("matched:  "..key, value)
			--local relic_type, relic_name, boss, zone = string.gmatch(value, "[^%.]+")
			local relic_type, relic_name, boss, zone
			
			--This is stupid because i have to iiterate over this parse
			index = 1
			for i in string.gmatch(value, "[^%.]+") do
				if index == 1 then
					relic_type = i
				end
				
				if index == 2 then
					relic_name = i
				end
				
				if index == 3 then
					boss = i
				end
				
				if index == 4 then
					zone = i
				end
				index = (index % 4) + 1
			end
			--debuging prints
			--if not (relic_type == nil) then print("relic_type: "..relic_type); end
			--if not (relic_name == nil) then print("relic_name: "..relic_name); end
			--if not (boss == nil) then print("boss: "..boss); end
			--if not (zone == nil) then print("zone: "..zone); end
			
			return relic_type, relic_name, boss, zone;
		end
	 end
end

hooksecurefunc(GameTooltip, "SetArtifactPowerByID", function(self, id)
	if id then
		local powerInfo = C_ArtifactUI.GetPowerInfo(id);
		local spellId = powerInfo.spellID
		local maxRank = powerInfo.maxRank;
		if maxRank > 2 then
			if maxRank < 10 then
				local relic_id_table = findRelicID(spellId)
				--GameTooltip:AddLine("Id: "..id)
				--GameTooltip:AddLine("SpellId: "..spellId)
				--GameTooltip:AddLine("MaxRank: "..maxRank)
				GameTooltip:AddLine("\n|c00ffffffImproved By:|r\n")
				
				for relic_id in pairs(relic_id_table) do
					spec_id, relic_item_id = relic_id_table[relic_id]:match("([^.]+)\.([^.]+)")
					local relicName, relicIcon, relicType, relicLink = C_ArtifactUI.GetRelicInfoByItemID(relic_item_id)
					if not (relicLink == nil) then
						local relic_type, relic_name, boss, zone = findRelicDetails(relic_item_id)
						local itemName, _, quality, _, _, _, _, _, equipSlot, icon = GetItemInfo(relic_item_id)
						
						-- I would like this to filter by items that are, and aren't warforge, and titanforgable instead of by quality. (If possible)
						if quality >= 4 then			
							if not (zone == nil) then
								GameTooltip:AddDoubleLine(format("|T%s:20:20:0:0:64:64:5:59:5:59:%d|t  %s", relicIcon, 20, relicLink), relicType)
								GameTooltip:AddDoubleLine(boss, '('..zone..')', 1,1,1,1,1,1)
							end
						end
					end
					
				end
				
				GameTooltip:Show()
				
			end
		end
	end
end)

