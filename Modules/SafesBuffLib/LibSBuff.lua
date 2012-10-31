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

-- Initialize Internal Structure
local _int = {
	Event = {
		Buff = {},
	},
	Monitor = {
		Buffs = {},
		Times = {},
		Units = {},
	},
	Queued = {
		Add = {},
		Change = {},
		Remove = {},
	},
	Queue = LibSata:Create(),
	_lastCall = math.floor(Inspect.Time.Real()),
	_Started = false,
}

LibSBuff.Cache = {}
LibSBuff.Lookup = {}

-- External Event Ports
_int.Event.Buff.Add = Utility.Event.Create("SafesBuffLib", "Buff.Add")
_int.Event.Buff.Change = Utility.Event.Create("SafesBuffLib", "Buff.Change")
_int.Event.Buff.Remove = Utility.Event.Create("SafesBuffLib", "Buff.Remove")

function _int.Monitor:RemoveBuff(BuffID)
	local endTime = self.Buffs[BuffID].Time
	local UnitID = self.Buffs[BuffID].Unit
	self.Times[endTime][BuffID] = nil
	self.Units[UnitID][BuffID] = nil
	self.Buffs[BuffID] = nil
end

function _int.Monitor:ClearUnit(UnitID)
	if self.Units[UnitID] then
		for BuffID, bDetails in pairs(self.Units[UnitID]) do
			if self.Buffs[BuffID] then
				self.Times[self.Buffs[BuffID].Time][BuffID] = nil
				self.Buffs[BuffID] = nil
			end
		end
		self.Units[UnitID] = nil
	end
end

function _int.Monitor:AddBuffs(UnitID)
	if LibSBuff.Cache[UnitID] then
		self.Units[UnitID] = LibSBuff.Cache[UnitID].BuffID
		for BuffID, bDetails in pairs(self.Units[UnitID]) do
			if bDetails.duration and bDetails.begin then
				local endTime = math.ceil(bDetails.duration + bDetails.begin)
				if self.Buffs[BuffID] then
					if endTime ~= self.Buffs[BuffID].Time then
						self.Times[endTime][BuffID] = nil
					end
				end
				self.Buffs[BuffID] = {Unit = UnitID, Time = endTime}
				if not self.Times[endTime] then
					self.Times[endTime] = {}
				end
				self.Times[endTime][BuffID] = UnitID
				--print("Buff: "..bDetails.name.." added for removal @ "..endTime)
			end
		end
		return true
	end
end

function _int:ClearBuffs(UnitID)
	-- Dump all Buff caching for this Unit without Events to the Monitor.
	-- The Monitor will be used for pulling Buff Details back during Unit.Availability.Full first.
	if self.Monitor:AddBuffs(UnitID) then
		for BuffID, bDetails in pairs(LibSBuff.Cache[UnitID].BuffID) do
			LibSBuff.Lookup[BuffID] = nil
		end
		LibSBuff.Cache[UnitID] = nil
		-- print("Unit: "..UnitID.." Buffs have been cleared")
	end
	-- print("Cache cleared for: "..UnitID)
end

function LibSBuff:GetBuffTable(UnitID)
	-- Returns the current active Buff Table for this unit if one exists
	-- The Table is in the form. Key = (string)Buff ID, Value = (table)Buff Details.
	-- This is identical to the tables provided by Buff.Add, Buff.Change and Buff.Remove
	if self.Cache[UnitID] then
		if self.Cache[UnitID].BuffID then
			return self.Cache[UnitID].BuffID
		end
	end
end

function _int:BuffUpdate(UnitID)
	-- Used for Announcing new Buffs on Units entering the players Seen field.
	if UnitID then
		local Buffs = Inspect.Buff.List(UnitID)
		if Buffs then
			if next(Buffs) then
				if LibSBuff.Cache[UnitID] then
					-- First check for missed Buff Remove events.
					for BuffID, bDetails in pairs(LibSBuff.Cache[UnitID].BuffID) do
						if not Buffs[BuffID] then
							if not self.Queued.Remove[BuffID] then
								-- A cached Buff is no longer on this Unit - Queue for Removal with Event.
								self.Queue:Add({Unit = UnitID, Buff = BuffID, Remove = true})
								self.Queued.Remove[BuffID] = true
							end
						end
					end
					for BuffID, BuffType in pairs(Buffs) do
						if not LibSBuff.Cache[UnitID].BuffID[BuffID] then
							if not self.Queued.Add[BuffID] then
								self.Queue:Add({Unit = UnitID, Buff = BuffID, Add = true})
								self.Queued.Add[BuffID] = true
							end
						end
					end
				else
					-- Place all the new buffs in the Queue to be added for this Unit
					for BuffID, BuffType in pairs(Buffs) do
						if not self.Queued.Add[BuffID] then
							if self.Monitor.Buffs[BuffID] then
								-- Cache silently as this buff has already been seen.
								self:CacheAdd(UnitID, BuffID, self.Monitor.Units[UnitID][BuffID])
								self.Monitor:RemoveBuff(BuffID)
							else
								-- More than likely a new Buff, create an event and cache trigger.
								self.Queue:Add({Unit = UnitID, Buff = BuffID, Add = true})
								self.Queued.Add[BuffID] = true
							end
						end
					end
				end
				return true
			else
				-- Remove from Buffs with events
				self:ClearBuffs(UnitID)
			end
		else
			-- Since this is a manual call, remove from Buffs with events
			self:ClearBuffs(UnitID)
		end
	else
		error("Buff List expecting a UnitID: success = LibSBuff:BuffList(string UnitID)")
	end
end

function _int:CacheAdd(UnitID, BuffID, bDetails)
	local _startTime = Inspect.Time.Real()
	bDetails = bDetails or Inspect.Buff.Detail(UnitID, BuffID)
	local _duration = Inspect.Time.Real() - _startTime
	if _duration > 0.045 then
		print("Performance Warning: LibSBuff has noticed the Rift Client is running slow.")
		print(string.format("Time taken to call internal Rift command Inspect.Buff.Detail - %0.03f", _duration))
	--else
		--print(string.format("Call safe: %0.06f", _duration))
	end
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
		-- Update .remaining portion of this Buffs details table.
		if bDetails.begin and bDetails.duration then
			bDetails.remaining = (bDetails.begin + bDetails.duration) - Inspect.Time.Frame()
		end
		-- print("Buff Cached: "..bDetails.name.." ("..bDetails.id..")")
	end
end

function _int:UpdateCycle()
	if not Inspect.System.Secure() then
		Command.System.Watchdog.Quiet()
	end
	local _buffs = {
		Add = {},
		Change = {},
		Remove = {},
	}
	local _startTime = Inspect.Time.Real()
	local _last
	local _currentTime = math.floor(_startTime)
	local _callDiff = _currentTime - self._lastCall
	if self.Queue:Count() > 0 then
		repeat
			-- print("----------")
			local QueueObj, BuffObj = self.Queue:First()
			if not QueueObj then
				-- print("Queue Empty: Breaking Loop")
				break
			end
			if BuffObj.Add then
				if _last then
					if _last ~= "Add" then
						-- Send event for last batch, to maintain consistency (Change or Remove)
						self.Event.Buff[_last](_buffs[_last])
						_buffs[_last] = {}
					end
				end
				_last = "Add"
				if not BuffObj.IgnoreLoad then
					-- print("BuffAdd: Calling Cache")
					self:CacheAdd(BuffObj.Unit, BuffObj.Buff)
				-- else
					-- print("Ingoring Buff Cache: "..LibSBuff.Lookup[BuffObj.Buff].name)
				end
				-- self.Event.Buff.Add(BuffObj.Unit, BuffObj.Buff, LibSBuff.Lookup[BuffObj.Buff])
				if not _buffs.Add[BuffObj.Unit] then
					_buffs.Add[BuffObj.Unit] = {}
				end
				_buffs.Add[BuffObj.Unit][BuffObj.Buff] = LibSBuff.Lookup[BuffObj.Buff]
				_int.Queued.Add[BuffObj.Buff] = nil
			elseif BuffObj.Change then
				if _last then
					if _last ~= "Change" then
						-- Send event for last batch to maintain consistency (Add or Remove)
						self.Event.Buff[_last](_buffs[_last])
						_buffs[_last] = {}
					end
				end
				_last = "Change"
				if not BuffObj.IgnoreLoad then
					self:CacheAdd(BuffObj.Unit, BuffObj.Buff)
				-- else
					-- print("Ingoring Buff Cache")				
				end
				if not _buffs.Change[BuffObj.Unit] then
					_buffs.Change[BuffObj.Unit] = {}
				end
				_buffs.Change[BuffObj.Unit][BuffObj.Buff] = LibSBuff.Lookup[BuffObj.Buff]
				_int.Queued.Change[BuffObj.Buff] = nil
				--self.Event.Buff.Change(BuffObj.Unit, BuffObj.Buff, LibSBuff.Lookup[BuffObj.Buff])
			elseif BuffObj.Remove then
				if LibSBuff.Cache[BuffObj.Unit] then
					if LibSBuff.Cache[BuffObj.Unit].BuffID[BuffObj.Buff] then
						if _last then
							if _last ~= "Remove" then
								-- Send event for last batch to maintain consistency (Add or Change)
								self.Event.Buff[_last](_buffs[_last])
								_buffs[_last] = {}
							end
						end
						_last = "Remove"
						local bDetails = LibSBuff.Cache[BuffObj.Unit].BuffID[BuffObj.Buff] or {}
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
						if not _buffs.Remove[BuffObj.Unit] then
							_buffs.Remove[BuffObj.Unit] = {}
						end
						_buffs.Remove[BuffObj.Unit][BuffObj.Buff] = bDetails
						--self.Event.Buff.Remove(BuffObj.Unit, BuffObj.Buff, bDetails)
					end
				end
				_int.Queued.Remove[BuffObj.Buff] = nil
			end
			-- If none of the above match, Item is removed regardless to prevent Queue polution.
			self.Queue:Remove(QueueObj)
		until (Inspect.Time.Real() - _startTime) > 0.045
		if _last then
			if next(_buffs[_last]) then
				self.Event.Buff[_last](_buffs[_last])
			end
		end
		_buffs = nil
		-- print("Queue update completed")
	end
	if _callDiff > 0 then
		for checkTime = self._lastCall+1, _currentTime do
			if next(self.Monitor.Times) then
				if self.Monitor.Times[checkTime] then
					-- print("Buffs found for removal @ "..checkTime)
					for BuffID, UnitID in pairs(self.Monitor.Times[checkTime]) do
						-- print("Removing: "..self.Monitor.Units[UnitID][BuffID].name)
						-- print("From: "..UnitID)
						-- print("----------------")
						self.Monitor:RemoveBuff(BuffID)
					end
					self.Monitor.Times[checkTime] = nil
				end
			end
		end
		self._lastCall = _currentTime
	end
end

function _int:BuffAdd(UnitID, Buffs)
	if not Inspect.System.Secure() then
		Command.System.Watchdog.Quiet()
	end
	local _startTime = Inspect.Time.Real()
	local cache = true
	for BuffID, BuffType in pairs(Buffs) do
		if BuffID then
			if not LibSBuff.Lookup[BuffID] then
				if not self.Queued.Add[BuffID] then
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
					self.Queued.Add[BuffID] = true
				end
			end
		end
		if Inspect.Time.Real() - _startTime > 0.045 then
			cache = false
		end
	end
end

function _int:BuffRemove(UnitID, Buffs)
	for BuffID, BuffType in pairs(Buffs) do
		if not self.Queued.Remove[BuffID] then
			self.Queue:Add({Unit = UnitID, Buff = BuffID, Remove = true})
			self.Queued.Remove[BuffID] = true
		end
	end
end

function _int:BuffChange(UnitID, Buffs)
	local _startTime = Inspect.Time.Real()
	local cache = true
	for BuffID, BuffType in pairs(Buffs) do
		if not self.Queued.Change[BuffID] then
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
		end
		if Inspect.Time.Real() - _startTime > 0.045 then
			cache = false
		end
	end
end

function _int:UnitAvailable(Units)
	-- Used for Internal Caching.
	-- If you require an active cache for a new Unit, use the commands: 
	-- BuffTable = LibSBuff:GetBuffTable(UnitID)
	for UnitID, _ in pairs(Units) do
		_int:BuffUpdate(UnitID)
		_int.Monitor:ClearUnit(UnitID)
	end
end

function _int:UnitRemoved(Units)
	-- Used for Internal Caching and prevention of memory leaks.
	-- No Remove events are given for this, to avoid false positives when dealing with your own Buff tracking.
	if Units then
		for UnitID, _ in pairs(Units) do
			self:ClearBuffs(UnitID)
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
	dump(_int.Monitor.Units)
end

-- function _int:DelayStart()
	-- if not self.FirstUpdate then
		-- self.FirstUpdate = Inspect.Time.Real()
	-- else
		-- if Inspect.Time.Real() - _int.FirstUpdate > 10 then
			-- self.FirstUpdate = nil
			-- self.Started = true
			-- for i, Table in ipairs(Event.System.Update.Begin) do
				-- if Table[2] == AddonIni.id then
					-- Event.System.Update.Begin[i] = {function() self:UpdateCycle() end, AddonIni.id, "Buff Cycle Start"}
				-- end
			-- end
			-- table.insert(Event.System.Update.End, {function() self:UpdateCycle() end, AddonIni.id, "Buff Cycle End"})
		-- end
	-- end
-- end

function _int:Start()
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
table.insert(Event.Addon.Load.End, {function() _int:Start() end, AddonIni.id, "Buff Pre-cache"})