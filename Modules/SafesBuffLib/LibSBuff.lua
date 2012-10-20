-- Safe's Buff Library
-- Written By Paul Snart
-- Copyright 2012
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesBuffLib
-- Dependency: SafesBuffLib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibBuff = Inspect.Addon.Detail("SafesBuffLib").data

local AddonIni, LibSBuff = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local _int = {
	Event = {
		Buff = {},
	},
}

_int.Queue = LibSata:Create()
LibSBuff.Cache = {}
LibSBuff.Lookup = {}

_int.Event.Buff.Add = Utility.Event.Create("SafesBuffLib", "Buff.Add")
_int.Event.Buff.Change = Utility.Event.Create("SafesBuffLib", "Buff.Change")
_int.Event.Buff.Remove = Utility.Event.Create("SafesBuffLib", "Buff.Remove")

function _int:ClearBuffs(UnitID, Silent)
	if Silent then
		-- Dump all Buff caching for this Unit without Events
		if LibSBuff.Cache[UnitID] then
			for BuffID, bDetails in pairs(LibSBuff.Cache[UnitID].BuffID) do
				LibSBuff.Lookup[BuffID] = nil
			end
			LibSBuff.Cache[UnitID] = nil
			-- print("Unit: "..UnitID.." Buffs have been cleared")
		end
	else
		-- Dump all Buff caching for this Unit with Events
		if LibSBuff.Cache[UnitID] then
			for BuffID, bDetails in pairs(LibSBuff.Cache[UnitID].BuffID) do
				self.Queue:Add({Unit = UnitID, Buff = BuffID, Remove = true})
			end
		end
	end
end

function LibSBuff:BuffUpdate(UnitID)
	-- Returns true if there is a Buff list for this Unit.
	-- All Buffs will be added to the Queue to trigger Add, Remove or Change events.
	if UnitID then
		local Buffs = Inspect.Buff.List(UnitID)
		if Buffs then
			if next(Buffs) then
				if self.Cache[UnitID] then
					-- First check for missed Buff Remove events.
					for BuffID, bDetails in pairs(self.Cache[UnitID].BuffID) do
						if not Buffs[BuffID] then
							-- A cached Buff is no longer on this Unit - Queue for Removal with Event.
							_int.Queue:Add({Unit = UnitID, Buff = BuffID, Remove = true})
						end
					end
					for BuffID, BuffType in pairs(Buffs) do
						if self.Cache[UnitID].BuffID[BuffID] then
							_int.Queue:Add({Unit = UnitID, Buff = BuffID, Change = true})
						else
							_int.Queue:Add({Unit = UnitID, Buff = BuffID, Add = true})
						end
					end
				else
					-- Place all the new buffs in the Queue to be added for this Unit
					for BuffID, BuffType in pairs(Buffs) do
						_int.Queue:Add({Unit = UnitID, Buff = BuffID, Add = true})
					end
				end
				return true
			else
				-- Since this is a manual call, remove from Buffs with events
				_int:ClearBuffs(UnitID)
			end
		else
			-- Since this is a manual call, remove from Buffs with events
			_int:ClearBuffs(UnitID)
		end
	else
		error("Buff List expecting a UnitID: success = LibSBuff:BuffList(string UnitID)")
	end
end

function _int:CacheAdd(UnitID, BuffID)
	local bDetails = Inspect.Buff.Detail(UnitID, BuffID)
	if bDetails then
		if not LibSBuff.Cache[UnitID] then
			LibSBuff.Cache[UnitID] = {
				Count = 0,
				TypeID = {},
				BuffID = {},
			}
		end
		if not LibSBuff.Cache[UnitID].BuffID[BuffID] then
			LibSBuff.Cache[UnitID].Count = LibSBuff.Cache[UnitID].Count + 1
		end
		if bDetails.type then
			bDetails.LibSBuffType = bDetails.type
		elseif bDetails.rune then
			bDetails.LibSBuffType = bDetails.rune
		elseif bDetails.abilityNew then
			bDetails.LibSBuffType = bDetails.abilityNew
		else
			bDetails.LibSBuffType = bDetails.name
		end
		if not LibSBuff.Cache[UnitID].TypeID[bDetails.LibSBuffType] then
			LibSBuff.Cache[UnitID].TypeID[bDetails.LibSBuffType] = {}
		end	
		LibSBuff.Cache[UnitID].TypeID[bDetails.LibSBuffType][BuffID] = bDetails
		LibSBuff.Cache[UnitID].BuffID[BuffID] = bDetails
		LibSBuff.Lookup[BuffID] = bDetails
		-- print("Buff Cached: "..bDetails.name.." ("..bDetails.LibSBuffType..")")
	end
end

function _int:UpdateCycle()
	local _startTime = Inspect.Time.Real()
	if self.Queue:Count() > 0 then
		repeat
			-- print("----------")
			local QueueObj, BuffObj = self.Queue:First()
			if not QueueObj then
				-- print("Queue Empty: Breaking Loop")
				break
			end
			if BuffObj.Add then
				if not BuffObj.IgnoreLoad then
					self:CacheAdd(BuffObj.Unit, BuffObj.Buff)
				-- else
					-- print("Ingoring Buff Cache")				
				end
				self.Event.Buff.Add(BuffObj.Unit, BuffObj.Buff, LibSBuff.Lookup[BuffObj.Buff])
			elseif BuffObj.Change then
				if not BuffObj.IgnoreLoad then
					self:CacheAdd(BuffObj.Unit, BuffObj.Buff)
				-- else
					-- print("Ingoring Buff Cache")				
				end
				self.Event.Buff.Change(BuffObj.Unit, BuffObj.Buff, LibSBuff.Lookup[BuffObj.Buff])
			elseif BuffObj.Remove then
				if LibSBuff.Cache[BuffObj.Unit] then
					if LibSBuff.Cache[BuffObj.Unit].BuffID[BuffObj.Buff] then
						local bDetails = LibSBuff.Cache[BuffObj.Unit].BuffID[BuffObj.Buff]
						-- print("Removing: "..bDetails.name.." ("..bDetails.LibSBuffType..")")
						LibSBuff.Cache[BuffObj.Unit].Count = LibSBuff.Cache[BuffObj.Unit].Count - 1
						LibSBuff.Cache[BuffObj.Unit].BuffID[BuffObj.Buff] = nil
						LibSBuff.Cache[BuffObj.Unit].TypeID[bDetails.LibSBuffType][BuffObj.Buff] = nil
						if not next(LibSBuff.Cache[BuffObj.Unit].TypeID[bDetails.LibSBuffType]) then
							LibSBuff.Cache[BuffObj.Unit].TypeID[bDetails.LibSBuffType] = nil
							-- print("No more Buffs of this type: Removing type list")
						end
						if LibSBuff.Cache[BuffObj.Unit].Count == 0 then
							LibSBuff.Cache[BuffObj.Unit] = nil
						end
						LibSBuff.Lookup[BuffObj.Buff] = nil
						self.Event.Buff.Remove(BuffObj.Unit, BuffObj.Buff, bDetails)
					end
				end
			end
			-- If none of the above match, Item is removed regardless to prevent Queue polution.
			self.Queue:Remove(QueueObj)
		until (Inspect.Time.Real() - _startTime) > 0.05
		-- print("Queue udpate completed")
	end
end

function _int:BuffAdd(UnitID, Buffs)
	local _startTime = Inspect.Time.Real()
	local cache = true
	for BuffID, BuffType in pairs(Buffs) do
		if BuffID then
			if cache then
				-- Load up Details for the buff and assign Cache Data.
				-- print("BuffAdd: Caching Buff and Adding to Queue")
				self:CacheAdd(UnitID, BuffID)
				self.Queue:Add({Unit = UnitID, Buff = BuffID, Add = true, IgnoreLoad = true})
			else
				-- Ignore Buff Load and instead Queue for future caching.
				-- print("BuffAdd: Buff added to Queue [Not Cached]")
				self.Queue:Add({Unit = UnitID, Buff = BuffID, Add = true})
			end
		end
		if Inspect.Time.Real() - _startTime > 0.05 then
			cache = false
		end
	end
end

function _int:BuffRemove(UnitID, Buffs)
	for BuffID, BuffType in pairs(Buffs) do
		self.Queue:Add({Unit = UnitID, Buff = BuffID, Remove = true})
	end
end

function _int:BuffChange(UnitID, Buffs)
	local _startTime = Inspect.Time.Real()
	local cache = true
	for BuffID, BuffType in pairs(Buffs) do
		if BuffID then
			if cache then
				-- Load up Details for the buff and assign Cache Data.
				-- print("BuffChange: Caching Buff and Adding to Queue")
				self:CacheAdd(UnitID, BuffID)
				self.Queue:Add({Unit = UnitID, Buff = BuffID, Change = true, IgnoreLoad = true})
			else
				-- Ignore Buff Load and instead Queue for future caching.
				-- print("BuffChange: Buff added to Queue [Not Cached]")
				self.Queue:Add({Unit = UnitID, Buff = BuffID, Change = true})
			end
		end
		if Inspect.Time.Real() - _startTime > 0.05 then
			cache = false
		end
	end
end

function _int:UnitAvailable(Units)
	-- Used for Internal Caching.
	-- Currently Unused to allow for Addon Devs to manage this themselves (if required).
	-- If you require an active cache for a new Unit, use the command: success = LibSBuff:BuffUpdate(UnitID)
end

function _int:UnitRemoved(Units)
	-- Used for Internal Caching and prevention of memory leaks.
	-- No Remove events are given for this, to avoid false positives when dealing with your own Buff tracking.
	if Units then
		for UnitID, _ in pairs(Units) do
			self:ClearBuffs(UnitID, true)
		end
	end
end

function _int.DumpCache(params)
	local Count = 0
	local uCount = 0
	for UnitID, UnitCache in pairs(LibSBuff.Cache) do
		uCount = uCount + 1
		print(uCount..": Buff Cache for: "..UnitID)
		for BuffID, BuffData in pairs(UnitCache.BuffID) do
			Count = Count + 1
			print(Count..": "..tostring(BuffData.name))
		end
	end
	print("Total Units tracked: "..uCount)
	print("Total Buffs cached: "..Count)
end

-- Debug Commands
table.insert(Command.Slash.Register("libsbuff"), {_int.DumpCache, "SafesBuffLib", "Dump current cache to Console"})
-- Unit Related Events
table.insert(Event.Unit.Availability.Full, {function(...) _int:UnitAvailable(...) end, AddonIni.id, "Unit Available Handler"})
table.insert(Event.Unit.Availability.None, {function(...) _int:UnitRemoved(...) end, AddonIni.id, "Unit Removed Handler"})
-- Buff Related Events
table.insert(Event.Buff.Remove, {function(...) _int:BuffRemove(...) end, AddonIni.id, "Buff Remove Handler"})
table.insert(Event.Buff.Add, {function(...) _int:BuffAdd(...) end, AddonIni.id, "Buff Add Handler"})
table.insert(Event.Buff.Change, {function(...) _int:BuffChange(...) end, AddonIni.id, "Buff Change Handler"})
-- System Related Events
table.insert(Event.System.Update.Begin, {function() _int:UpdateCycle() end, AddonIni.id, "Buff Cycle Start"})
table.insert(Event.System.Update.End, {function() _int:UpdateCycle() end, AddonIni.id, "Buff Cycle End"})