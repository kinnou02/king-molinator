-- King Boss Mods Player Control System
-- Written By Paul Snart
-- Copyright 2012
--

local KBMTable = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMTable.data

local PC = {
	Queue = {},
}

PC.RezBank = {
	["cleric"] = {
		--["a0000000026862464"] = {},
		--["a000000004D4EFA27"] = {},
		--["a000000002942FF34"] = {},
		--["a0000000074C19819"] = {},
		["A2942FF34A490A22D"] = {}, 
		["A74C19819577CEA4D"] = {},
		["A4D4EFA27574FDC9A"] = {},
		["A26862464D9EECBE7"] = {},
	},
	["mage"] = {
		--["a000000004AE33670"] = {},
		--["a000000002D3F2123"] = {},
		["A2D3F2123EE93DE49"] = {},
		["A4AE33670A72C0F45"] = {},
	},
}

KBM.PlayerControl = PC

function PC:GatherAbilities()
	KBM.Player.AbilityTable = Inspect.Ability.New.List()
	local Count = 0
	if KBM.Player.AbilityTable then
		if self.RezBank[KBM.Player.Calling] then
			-- print("You are a calling with possible Combat Rezes... Checking.")
			for crID, crTable in pairs (self.RezBank[KBM.Player.Calling]) do
				if KBM.Player.AbilityTable[crID] then
					Count = Count + 1
					crTable = Inspect.Ability.New.Detail(crID)
					self.RezBank[KBM.Player.Calling][crID] = crTable
					KBM.Player.Rezes.List[crID] = self.RezBank[KBM.Player.Calling][crID]
					KBM.RezMaster.Rezes:Add(KBM.Player.Name, crID, crTable.currentCooldownRemaining, crTable.cooldown)
					-- print(Count..": "..self.RezBank[KBM.Player.Calling][crID].name)
				end
			end
			KBM.Player.Rezes.Count = Count
		else
			-- print("Your calling is not able to Combat Rez, lucky you!")
		end
	end
end

function PC.MessageSent(failed, message)
	--print(tostring(failed).." "..tostring(message))
end

function PC:GatherRaidInfo()
	for index = 1, 20 do
		local specifier, uID = LibSRM.Group.Inspect(index)
		if uID then
			if uID ~= KBM.Player.UnitID then
				if KBM.Unit.List.UID[uID] then
					--print(KBM.Unit.List.UID[uID].Name..": "..tostring(KBM.Unit.List.UID[uID].Details.calling))
					--KBM.Unit.List.UID[uID].Details = Inspect.Unit.Detail(uID)
					if KBM.Unit.List.UID[uID].Calling then
						if self.RezBank[KBM.Unit.List.UID[uID].Calling] then
							Command.Message.Broadcast("tell", KBM.Unit.List.UID[uID].Name, "KBMRezReq", "C", function(failed, message) PC.RezMReq(KBM.Unit.List.UID[uID].Name, failed, message) end)
							--Command.Message.Send(KBM.Unit.List.UID[uID].Name, "KBMRezReq", "C", PC.MessageSent)
						end
					else
						--print("Adding player to queue (Unknown Calling): "..KBM.Unit.List.UID[uID].Name)
						self.Queue[uID] = true
					end
				end
			end
		end
	end
end

function PC.AbilityRemove(aIDList)
	local self = PC
	local Count = KBM.Player.Rezes.Count
	if self.RezBank[KBM.Player.Calling] then
		for crID, crTable in pairs (self.RezBank[KBM.Player.Calling]) do
			if aIDList[crID] == false then
				self.RezBank[KBM.Player.Calling][crID] = Inspect.Ability.New.Detail(crID)
				KBM.Player.Rezes.List[crID] = nil
				--print(Count..": "..self.RezBank[KBM.Player.Calling][crID].name.." < Removed")
				KBM.RezMaster.Broadcast.RezRem(crID)
				Count = Count - 1
			end
		end
		KBM.Player.Rezes.Count = Count
		if KBM.Player.Rezes.Count == 0 then
			--KBM.RezMaster.Broadcast.RezClear()
		end
	end
end

function PC.AbilityAdd(aIDList)
	local self = PC
	local Count = 0
	
	if self.RezBank[KBM.Player.Calling] then
		for crID, crTable in pairs (self.RezBank[KBM.Player.Calling]) do
			if aIDList[crID] then
				Count = Count + 1
				local aDetails = Inspect.Ability.New.Detail(crID)
				self.RezBank[KBM.Player.Calling][crID] = aDetails
				KBM.Player.Rezes.List[crID] = self.RezBank[KBM.Player.Calling][crID]
				KBM.RezMaster.Rezes:Add(KBM.Player.Name, crID, aDetails.currentCooldownRemaining, aDetails.cooldown)
				KBM.RezMaster.Broadcast.RezSet(nil, crID)
				-- print(Count..": "..self.RezBank[KBM.Player.Calling][crID].name.." < Added")
			end
		end
		KBM.Player.Rezes.Count = Count
	end
end

function PC.AbilityCooldown(aIDList)
	local self = PC
	for rID, rDetails in pairs(KBM.Player.Rezes.List) do
		if aIDList[rID] then
			local aDetails = Inspect.Ability.New.Detail(rID)
			--print(math.floor(aDetails.currentCooldownDuration).." - "..math.floor(rDetails.cooldown))
			if aDetails.currentCooldownDuration then
				if aDetails.currentCooldownDuration > 2 then
					if not KBM.Player.Rezes.Resume[rID] then
						KBM.Player.Rezes.Resume[rID] = 0
					end
					if KBM.Player.Rezes.Resume[rID] <= Inspect.Time.Real() then
						--print("aDetails.currentCooldownDuration")
						--print("Rez Matched!")
						KBM.Player.Rezes.List[rID] = aDetails
						KBM.Player.Rezes.Resume[rID] = aDetails.currentCooldownBegin + aDetails.currentCooldownRemaining
						KBM.RezMaster.Rezes:Add(KBM.Player.Name, rID, aDetails.currentCooldownRemaining, aDetails.cooldown)
						KBM.RezMaster.Broadcast.RezSet(nil, rID)
					end
				end
			end
		end
	end
end

function PC.PlayerJoin()
	--print("PC -- You Join")
	KBM.RezMaster.Rezes.Tracked[KBM.Player.Name] = {
		UnitID = KBM.Player.UnitID,
		Timers = {},
	}
	KBM.Player.Grouped = true
	if KBM.Player.Calling then
		PC:GatherAbilities()
	end
	--PC:GatherRaidInfo()
end

function PC.CallingChange(uID, Calling)
	if uID == KBM.Player.UnitID then
		if KBM.Player.Calling then
			--PC:GatherAbilities()
		end
	end
	if PC.Queue[uID] then
		PC.Queue[uID] = nil
	end
end

function PC.RezMReq(name, failed, message)
	if failed then
		Command.Message.Broadcast("tell", name, "KBMRezReq", "C", PC.MessageSent)
	end
end

function PC.RezRReq(name, failed, message)

end

function PC.GroupJoin(uID)
	--print("Player joining: "..KBM.Unit.List.UID[uID].Name)
	if KBM.Player.Grouped then
	--	print("and you are in a Group")
		if not KBM.RezMaster.Rezes.Tracked[KBM.Unit.List.UID[uID].Name] then
			--print("New player has joined: Requesting BR list")
			KBM.RezMaster.Rezes.Tracked[KBM.Unit.List.UID[uID].Name] = {
				UnitID = uID,
				Timers = {},
			}
			Command.Message.Send(KBM.Unit.List.UID[uID].Name, "KBMRezReq", "C", function(failed, message) PC.RezMReq(KBM.Unit.List.UID[uID].Name, failed, message) end)
		end
	else
	--	print("you are not currently grouped")
	end
end

function PC.GroupLeave(uID)
	if KBM.Player.Grouped then
		KBM.RezMaster.Rezes:Clear(KBM.Unit.List.UID[uID].Name)
	end
end

function PC.PlayerOffline(UID, Value)
	if Value then
		-- print("Player is offline, if they have CR/BR list, disable/remove them here")
		KBM.RezMaster.Rezes:Clear(KBM.Unit.List.UID[UID].Name)
	end
end

function PC.PlayerLeave()
	-- Probably not going to use this.
	--print("Rez Master group leave message")
	KBM.Player.Grouped = false
	KBM.RezMaster.Rezes:Clear()
end

function PC.PlayerMode(Mode)
	KBM.Player.Mode = Mode
end

function PC:Start()
	self.MSG = KBM.MSG
	table.insert(Event.Ability.New.Remove, {PC.AbilityRemove, "KingMolinator", "Ability Removed"})
	table.insert(Event.Ability.New.Add, {PC.AbilityAdd, "KingMolinator", "Ability Add"})
	table.insert(Event.Ability.New.Cooldown.Begin, {PC.AbilityCooldown, "KingMolinator", "Ability Cooldown"})
	table.insert(Event.Ability.New.Cooldown.End, {PC.AbilityCooldown, "KingMolinator", "Ability Cooldown"})
	table.insert(Event.KingMolinator.System.Player.Join, {PC.PlayerJoin, "KingMolinator", "Player Join"})
	table.insert(Event.KingMolinator.System.Player.Leave, {PC.PlayerLeave, "KingMolinator", "Player Leave"})
	table.insert(Event.KingMolinator.System.Group.Join, {PC.GroupJoin, "KingMolinator", "Group Member Join"})
	table.insert(Event.KingMolinator.System.Group.Leave, {PC.GroupLeave, "KingMolinator", "Group Member Leave"})
	table.insert(Event.KingMolinator.Unit.Calling, {PC.CallingChange, "KingMolinator", "Group member calling change"})
	table.insert(Event.SafesRaidManager.Group.Offline, {PC.PlayerOffline, "KingMolinator", "Player Offline"})
	table.insert(Event.SafesRaidManager.Group.Mode, {PC.PlayerMode, "KingMolinator", "Player Group Mode"})
end