-- King Boss Mods Player Control System
-- Written By Paul Snart
-- Copyright 2012
--

local KBMTable = Inspect.Addon.Detail("KingMolinator")
local KBM = KBMTable.data

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local PC = {
	Queue = {},
}

PC.RezBank = {
	["cleric"] = {
		--["a0000000026862464"] = {},
		--["a000000004D4EFA27"] = {},
		--["a000000002942FF34"] = {},
		--["a0000000074C19819"] = {},
		["A2942FF34A490A22D"] = {}, -- River of Life
		["A74C19819577CEA4D"] = {}, -- Flash of the Phoenix
		["A4D4EFA27574FDC9A"] = {}, -- Absolution
		["A26862464D9EECBE7"] = {}, -- Life's Return
		["AFDD327BDD0828E57"] = {}, -- Death's Embrace
	},
	["mage"] = {
		--["a000000004AE33670"] = {},
		--["a000000002D3F2123"] = {},
		["A2D3F2123EE93DE48"] = {}, -- Spark of Life
		["A4AE33670A72C0F45"] = {}, -- Soul Tether
	},
}

KBM.PlayerControl = PC

function PC:GatherAbilities()
	KBM.Player.AbilityTable = Inspect.Ability.New.List()
	local Count = 0
	if KBM.Player.AbilityTable then
		if self.RezBank[LibSUnit.Player.Calling] then
			-- print("You are a calling with possible Combat Rezes... Checking.")
			for crID, crTable in pairs (self.RezBank[LibSUnit.Player.Calling]) do
				if KBM.Player.AbilityTable[crID] then
					Count = Count + 1
					crTable = Inspect.Ability.New.Detail(crID)
					self.RezBank[LibSUnit.Player.Calling][crID] = crTable
					KBM.Player.Rezes.List[crID] = self.RezBank[LibSUnit.Player.Calling][crID]
					KBM.RezMaster.Rezes:Add(LibSUnit.Player.Name, crID, crTable.currentCooldownRemaining, crTable.cooldown)
					-- print(Count..": "..self.RezBank[LibSUnit.Player.Calling][crID].name)
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
	for UnitID, UnitObj in pairs(LibSUnit.Raid.UID) do
		if UnitID then
			if UnitID ~= LibSUnit.Player.UnitID then
				if UnitObj then
					if UnitObj.Calling then
						if self.RezBank[UnitObj.Calling] then
							Command.Message.Broadcast("tell", UnitObj.Name, "KBMRezReq", "C", function(failed, message) PC.RezMReq(UnitObj.Name, failed, message) end)
						end
					else
						--print("Adding player to queue (Unknown Calling): "..KBM.Unit.List.UID[uID].Name)
						self.Queue[UnitID] = true
					end
				end
			end
		end
	end
end


function PC.AbilityRemove(handle, aIDList)
	if not Inspect.System.Secure() then
		local self = PC
		local Count = KBM.Player.Rezes.Count
		if self.RezBank[LibSUnit.Player.Calling] then
			for crID, crTable in pairs (self.RezBank[LibSUnit.Player.Calling]) do
				if aIDList[crID] == false then
					self.RezBank[LibSUnit.Player.Calling][crID] = Inspect.Ability.New.Detail(crID)
					KBM.Player.Rezes.List[crID] = nil
					-- print(Count..": "..self.RezBank[LibSUnit.Player.Calling][crID].name.." < Removed")
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
end

function PC.AbilityAdd(handle, aIDList)
	local self = PC
	local Count = 0
	
	if self.RezBank[LibSUnit.Player.Calling] then
		for crID, crTable in pairs (self.RezBank[LibSUnit.Player.Calling]) do
			if aIDList[crID] then
				Count = Count + 1
				local aDetails = Inspect.Ability.New.Detail(crID)
				self.RezBank[LibSUnit.Player.Calling][crID] = aDetails
				KBM.Player.Rezes.List[crID] = self.RezBank[LibSUnit.Player.Calling][crID]
				KBM.RezMaster.Rezes:Add(LibSUnit.Player.Name, crID, aDetails.currentCooldownRemaining, aDetails.cooldown)
				KBM.RezMaster.Broadcast.RezSet(nil, crID)
				-- print(Count..": "..self.RezBank[LibSUnit.Player.Calling][crID].name.." < Added")
			end
		end
		KBM.Player.Rezes.Count = Count
	end
end

function PC.SlashAbility()
	local aIDList = Inspect.Ability.New.List()
	for crID, bool in pairs(aIDList) do
		local aDetails = Inspect.Ability.New.Detail(crID)
		print(aDetails.name.." = "..crID)
	end
end

function PC.AbilityCooldown(handle, aIDList)
	local self = PC
	for rID, rDetails in pairs(KBM.Player.Rezes.List) do
		if aIDList[rID] then
			local aDetails = Inspect.Ability.New.Detail(rID)
			--print(math.floor(aDetails.currentCooldownDuration).." - "..math.floor(rDetails.cooldown))
			if aDetails.currentCooldownDuration then
				if aDetails.currentCooldownDuration > 2 and aDetails.currentCooldownRemaining > 2 then
					if not KBM.Player.Rezes.Resume[rID] then
						KBM.Player.Rezes.Resume[rID] = 0
					end
					if KBM.Player.Rezes.Resume[rID] <= Inspect.Time.Real() then
						--print("aDetails.currentCooldownDuration")
						--print("Rez Matched!")
						KBM.Player.Rezes.List[rID] = aDetails
						KBM.Player.Rezes.Resume[rID] = aDetails.currentCooldownBegin + aDetails.currentCooldownRemaining
						KBM.RezMaster.Rezes:Add(LibSUnit.Player.Name, rID, aDetails.currentCooldownRemaining, aDetails.cooldown)
						KBM.RezMaster.Broadcast.RezSet(nil, rID)
					end
				end
			end
		end
	end
end

function PC.PlayerJoin()
	--print("PC -- You Join")
	KBM.RezMaster.Rezes.Tracked[LibSUnit.Player.Name] = {
		UnitID = LibSUnit.Player.UnitID,
		Timers = {},
	}
	if LibSUnit.Player.Calling then
		PC:GatherAbilities()
	end
	-- PC:GatherRaidInfo()
end

function PC.CallingChange(handle, UnitObj)
	if KBM.RezMaster.Rezes.Tracked[UnitObj.Name] then
		if KBM.RezMaster.Rezes.Tracked[UnitObj.Name].Class ~= UnitObj.Calling then
			if UnitObj.Calling ~= "" and UnitObj.Calling ~= nil then
				for aID, Timer in pairs(KBM.RezMaster.Rezes.Tracked[UnitObj.Name].Timers) do
					KBM.RezMaster.Rezes:Add(UnitObj.Name, aID, Timer.Remaining, Timer.Duration)
				end
			end
		end
	else
		-- Request BR
		if UnitObj.Calling == "mage" or UnitObj.Calling == "cleric" then
			KBM.RezMaster.Rezes.Tracked[UnitObj.Name] = {
				UnitID = UnitObj.UnitID,
				Timers = {},
			}
			Command.Message.Send(UnitObj.Name, "KBMRezReq", "C", function(failed, message) PC.RezMReq(UnitObj.Name, failed, message) end)
		end
	end
	if PC.Queue[uID] then
		PC.Queue[uID] = nil
	end
end

function PC.RezMReq(name, failed, message)
	if failed then
		--print("Message Failed for "..tostring(name)..": "..tostring(message))
		Command.Message.Broadcast("tell", name, "KBMRezReq", "C", PC.MessageSent)
	end
end

function PC.RezRReq(name, failed, message)

end

function PC.GroupJoin(handle, UnitObj, Spec)
	if LibSUnit.Raid.Grouped then
		if UnitObj.Name ~= LibSUnit.Player.Name then
			if not KBM.RezMaster.Rezes.Tracked[UnitObj.Name] then
				if not UnitObj.Offline then
					if UnitObj.Calling == "mage" or UnitObj.Calling == "cleric" then
						KBM.RezMaster.Rezes.Tracked[UnitObj.Name] = {
							UnitID = UnitObj.UnitID,
							Timers = {},
						}
						Command.Message.Send(UnitObj.Name, "KBMRezReq", "C", function(failed, message) PC.RezMReq(UnitObj.Name, failed, message) end)
					end
				end
			else
				if UnitObj.Calling then
					if KBM.RezMaster.Rezes.Tracked[UnitObj.Name].Class ~= UnitObj.Calling then
						for aID, Timer in pairs(KBM.RezMaster.Rezes.Tracked[UnitObj.Name].Timers) do
							KBM.RezMaster.Rezes:Add(UnitObj.Name, aID, Timer.Remaining, Timer.Duration)
						end
					end
				end
			end
		end
	end
end

function PC.GroupLeave(handle, UnitObj, Spec)
	if LibSUnit.Raid.Grouped then
		KBM.RezMaster.Rezes:Clear(UnitObj.Name)
	end
end

function PC.PlayerOffline(handle, Units)
	for UnitID, UnitObj in pairs(Units) do
		if UnitObj.Offline then
			if KBM.RezMaster.Rezes.Tracked[UnitObj.Name] then
				KBM.RezMaster.Rezes:Clear(UnitObj.Name)
			end
		end
	end
end

function PC.PlayerLeave()
	KBM.RezMaster.Rezes:Clear()
end

function PC:Start()
	self.MSG = KBM.MSG
	Command.Event.Attach(Event.Ability.New.Remove, PC.AbilityRemove, "Ability Removed")
	Command.Event.Attach(Event.Ability.New.Add, PC.AbilityAdd, "Ability Add")
	Command.Event.Attach(Event.Ability.New.Cooldown.Begin, PC.AbilityCooldown, "Ability Cooldown")
	Command.Event.Attach(Event.Ability.New.Cooldown.End, PC.AbilityCooldown, "Ability Cooldown")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Join, PC.PlayerJoin, "Player Join")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Leave, PC.PlayerLeave, "Player Leave")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Member.Join, PC.GroupJoin, "Group Member Join")
	Command.Event.Attach(Event.SafesUnitLib.Raid.Member.Leave, PC.GroupLeave, "Group Member Leave")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Calling, PC.CallingChange, "Group member calling change")
	Command.Event.Attach(Event.SafesUnitLib.Unit.Detail.Offline, PC.PlayerOffline, "Player Offline")
	Command.Event.Attach(Command.Slash.Register("kbmability"), PC.SlashAbility, "Player Ability List")
end