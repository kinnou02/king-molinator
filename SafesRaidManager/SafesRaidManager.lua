-- Safes Raid Manager
-- Written By Paul Snart
-- Code Fixes by Mere
-- Copyright Paul Snart 2011
--

LibSRM = {}

LibSRM.Player = {}
LibSRM.Player.ID = Inspect.Unit.Detail("player")
LibSRM.Player.Grouped = false
LibSRM.Player.Loaded = false
LibSRM.Player.Combat = false
LibSRM.Dead = 0

LibSRM.Group = {
	Combat = 0,
}

LibSRM.AddonDetails = Inspect.Addon.Detail("SafesRaidManager")

local SRM_HeldTime = Inspect.Time.Real()
local SRM_Units = {}
SRM_Units.Pets = {}
local SRM_Raid = {}
SRM_Raid.Populated = 0
local SRM_UnitQueue = {}
SRM_UnitQueue.Queued = 0
function SRM_UnitQueue:Add(RaidUnit)
	self[RaidUnit.UnitID] = RaidUnit
	self.Queued = self.Queued + 1
end
local SRM_PetQueue = {}
SRM_PetQueue.OwnerWait = {}
SRM_PetQueue.OwnerWait.Queued = 0
SRM_PetQueue.Queued = 0
function SRM_PetQueue:Add(RaidUnit, OwnerWait)
	if OwnerWait then
		-- Waiting for owner to load
		--print("Pet waiting for owner to load.")
		self.OwnerWait[RaidUnit.PetID] = {}
		self.OwnerWait[RaidUnit.PetID].UID = RaidUnit.PetID
		self.OwnerWait.Queued = self.OwnerWait.Queued + 1
	else
		-- Waiting for self to become available
		--print("Pet waiting for self to become available.")
		self[RaidUnit.PetID] = {}
		self[RaidUnit.PetID].UID = RaidUnit.PetUID
		self[RaidUnit.PetID].RaidUnit = RaidUnit
		self[RaidUnit.PetID].Group = true
		self.Queued = self.Queued + 1
	end
end

local function SRM_IndexToSpec(i, Addition)
	if not Addition then Addition = "" end
	return string.format("group%02d"..Addition, i)
end

local SRM_Group = {
	Join = {},
	Leave = {},
	Change = {},
}
SRM_Group.Join, SRM_Group.Join.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Join")
SRM_Group.Leave, SRM_Group.Leave.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Leave")
SRM_Group.Change, SRM_Group.Change.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Change")
SRM_Group.Combat = {
	Start = {},
	End = {},
	Enter = {},
	Leave = {},
	Damage = {},
	Heal = {},
	Death = {},
	Res = {},
}
SRM_Group.Combat.Enter, SRM_Group.Combat.Enter.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Enter")
SRM_Group.Combat.Leave, SRM_Group.Combat.Leave.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Leave")
SRM_Group.Combat.Start, SRM_Group.Combat.Start.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Start")
SRM_Group.Combat.End, SRM_Group.Combat.End.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.End")
SRM_Group.Combat.Damage, SRM_Group.Combat.Damage.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Damage")
SRM_Group.Combat.Heal, SRM_Group.Combat.Heal.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Heal")
SRM_Group.Combat.Death, SRM_Group.Combat.Death.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Death")
SRM_Group.Combat.Res, SRM_Group.Combat.Res.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Combat.Res")

SRM_Group.Location = {
	Change = {},
}
SRM_Group.Location.Change, SRM_Group.Location.Change.EventTable = Utility.Event.Create("SafesRaidManager", "Group.Location.Change")

local SRM_Pet = {}
SRM_Pet.Add = {}
SRM_Pet.Remove = {}
SRM_Pet.Add, SRM_Pet.Add.EventTable = Utility.Event.Create("SafesRaidManager", "Pet.Add")
SRM_Pet.Remove, SRM_Pet.Remove.EventTable = Utility.Event.Create("SafesRaidManager", "Pet.Remove")

local SRM_System = {
	Player = {
		Ready = {},
		Join = {},
		Leave = {},
		Pet = {
			Add = {},
			Remove = {},
		},
		Combat = {
			Enter = {},
			Leave = {},
		},
	},
	Combat = {
		Damage = {},
		Enter = {},
		Leave = {},
		Death = {},
		Heal = {},
	},
}

SRM_System.Player.Combat.Enter, SRM_System.Player.Combat.Enter.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Combat.Enter")
SRM_System.Player.Combat.Leave, SRM_System.Player.Combat.Leave.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Combat.Leave")
SRM_System.Player.Ready, SRM_System.Player.Ready.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Ready")
SRM_System.Player.Join, SRM_System.Player.Join.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Join")
SRM_System.Player.Leave, SRM_System.Player.Leave.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Leave") 
SRM_System.Player.Pet.Add, SRM_System.Player.Pet.Add.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Pet.Add")
SRM_System.Player.Pet.Remove, SRM_System.Player.Pet.Remove.EventTable = Utility.Event.Create("SafesRaidManager", "Player.Pet.Remove")
SRM_System.Combat.Damage, SRM_System.Combat.Damage.EventTable = Utility.Event.Create("SafesRaidManager", "Combat.Damage")
SRM_System.Combat.Enter, SRM_System.Combat.Enter.EventTable = Utility.Event.Create("SafesRaidManager", "Combat.Enter")
SRM_System.Combat.Leave, SRM_System.Combat.Leave.EventTable = Utility.Event.Create("SafesRaidManager", "Combat.Leave")
SRM_System.Combat.Death, SRM_System.Combat.Death.EventTable = Utility.Event.Create("SafesRaidManager", "Combat.Death")
SRM_System.Combat.Heal, SRM_System.Combat.Heal.EventTable = Utility.Event.Create("SafesRaidManager", "Combat.Heal")

local function SRM_CheckGroupState(force)
	--print(SRM_Raid.Populated)
	if SRM_Raid.Populated > 0 then
		if (not LibSRM.Player.Grouped) or force then
			SRM_System.Player.Join()
			--print("You have joined a group.")
		end
		LibSRM.Player.Grouped = true
	else
		if LibSRM.Player.Grouped or force then
			SRM_System.Player.Leave()
			--print("You have left a group.")
		end
		LibSRM.Player.Grouped = false
	end
end

local function SRM_Combat(units)
	for UnitID, State in pairs(units) do
		local sent = false
		if State then
			-- Entered Combat
			if SRM_Units[UnitID] then
				if not SRM_Units[UnitID].Combat then
					SRM_Units[UnitID].Combat = true
					LibSRM.Group.Combat = LibSRM.Group.Combat + 1
					if LibSRM.Group.Combat == 1 then
						SRM_Group.Combat.Start()
					end
					SRM_Group.Combat.Enter(UnitID)
					sent = true
				end
			end
			if LibSRM.Player.ID == UnitID then
				if not LibSRM.Player.Combat then
					LibSRM.Player.Combat = true
					SRM_System.Player.Combat.Enter()
					if not sent then
						SRM_Group.Combat.Start()
					end
					sent = true
				end
			end
			if not sent then
				if not SRM_Units.Pets[UnitID] and not SRM_Units[UnitID] then
					if UnitID ~= LibSRM.Player.PetID then
						SRM_System.Combat.Enter(UnitID)
					end
				end
			end
		else
			-- Left Combat
			if SRM_Units[UnitID] then
				if SRM_Units[UnitID].Combat then
					SRM_Units[UnitID].Combat = false
					LibSRM.Group.Combat = LibSRM.Group.Combat - 1
					if LibSRM.Group.Combat == 0 then
						SRM_Group.Combat.End()
					end
					SRM_Group.Combat.Leave(UnitID)
					sent = true
				end
			end
			if LibSRM.Player.ID == UnitID then
				if LibSRM.Player.Combat then
					LibSRM.Player.Combat = false
					SRM_System.Player.Combat.Leave()
					if not sent then
						SRM_Group.Combat.End()
					end
					sent = true
				end
			end
			if not sent then
				if not SRM_Units.Pets[UnitID] and not SRM_Units[UnitID] then
					if UnitID ~= LibSRM.Player.PetID then
						SRM_System.Combat.Leave(UnitID)
					end
				end
			end
		end
	end
end

local function SRM_SetSpecifier(Specifier)
	SRM_Raid[Specifier] = {}
	SRM_Raid[Specifier].UnitID = Inspect.Unit.Lookup(Specifier)
	SRM_Raid[Specifier].PetID = Inspect.Unit.Lookup(Specifier..".pet")
	SRM_Raid[Specifier].Spec = Specifier
	local Unit = SRM_Raid[Specifier]
	function Unit:PetLoad()
		if self.PetID then
			if not SRM_Units.Pets[self.PetID] then
				local petDetails = Inspect.Unit.Detail(self.PetID)
				if petDetails then
					--print("New pet added!")
					SRM_Units.Pets[self.PetID] = {}
					SRM_Units.Pets[self.PetID].Name = petDetails.name
					SRM_Units.Pets[self.PetID].UID = self.PetID
					SRM_Units.Pets[self.PetID].OwnerUID = self.UnitID
					SRM_Units.Pets[self.PetID].Specifier = self.Spec
					if not self.UnitID then
						--- Wait for Owner to load before sending message
						SRM_PetQueue:Add(self, true)
					else
						--print("Unit's Pet Loaded! (Pet Load)")
						SRM_Pet.Add(self.PetID, self.UnitID)
					end
				else
					--- Queued for owner ID association
					SRM_PetQueue:Add(self)
				end
			end
		end
	end
	
	function Unit:Leave()
		--print(SRM_Units[self.UnitID].name.." has left the group.")
		SRM_Combat({[self.UnitID] = false})
		if self.Dead then
			LibSRM.Dead = LibSRM.Dead - 1
		end
		SRM_Raid.Populated = SRM_Raid.Populated - 1
		SRM_Units[self.UnitID] = nil
		self.SRM_Unit = nil
		if self.PetID then
			--print("Pet Removed!")
			SRM_Units.Pets[self.PetID] = nil
			SRM_Pet.Remove(self.PetID, self.UnitID)
		end
		SRM_Group.Leave(tostring(self.UnitID), self.Spec)
		SRM_CheckGroupState()
		self.UnitID = nil
		self.PetID = nil
		-- Send LEAVE message HERE
	end

	function Unit:Change(UID, pet)
		--print("Unit Change Check: "..tostring(UID))
		if pet then
			--print("Pet Change Check: "..tostring(UID))
			if UID then
				if SRM_Units.Pets[UID] then
					--- Existing Pet, changed location
					self.PetID = UID
					SRM_Units.Pets[UID].Specifier = self.Spec
					--print("Existing pet.")
				else
					--- New Pet
					self.PetID = UID
					self:PetLoad(UID)
				end
			else
				if self.PetID then
					if not Inspect.Unit.Lookup(self.PetID) then
						SRM_Units.Pets[self.PetID] = nil
						SRM_Pet.Remove(self.PetID, self.UnitID)
						self.PetID = nil
						--print("Pet removed!")	
					end
				end
			end
		else
			if UID then
				if SRM_Units[UID] then
					--print("Unit Changed position: "..SRM_Units[UID].name)
					if self.UnitID then
						-- Check to see if a unit still exists here.
						local stillInRaid = false
						for i = 1, 20 do
							local cSpecifier = SRM_IndexToSpec(i)
							local cUnitID = Inspect.Unit.Lookup(cSpecifier)
							if cUnitID == self.UnitID then
								--print("Unit Changed ignoring leave message.")
								self.UnitID = nil
								self.PetID = nil
								-- SEND NO MSG
								stillInRaid = true
								break
							end
						end
						if not stillInRaid then
							self:Leave()
						end
					end
					SRM_Group.Change(UID, SRM_Units[UID].Specifier, self.Spec)
					self.UnitID = UID
					SRM_Units[UID].Specifier = self.Spec
					-- Send MOVE Message HERE
				else
					--print("Attempting to load new Unit: "..UID)
					self.UnitID = UID
					self:Load()
					-- SEND NO MSG
				end
			else
				--print("Unit possibly left group: "..SRM_Units[self.UnitID].name)
				for i = 1, 20 do
					local cSpecifier = SRM_IndexToSpec(i)
					local cUnitID = Inspect.Unit.Lookup(cSpecifier)
					if cUnitID == self.UnitID then
						--print("Unit Changed ignoring leave message.")
						self.UnitID = nil
						self.PetID = nil
						-- SEND NO MSG
						return
					end
				end
				self:Leave()
			end
		end
	end

	function Unit:Load()
		if self.UnitID then
			if not SRM_Units[self.UnitID] then
				local uDetails = Inspect.Unit.Detail(self.UnitID)
				if uDetails then
					SRM_Units[self.UnitID] = {}
					SRM_Units[self.UnitID].Specifier = self.Spec
					SRM_Units[self.UnitID].UnitID = self.UnitID
					SRM_Units[self.UnitID].name = uDetails.name
					SRM_Units[self.UnitID].Loaded = true
					if uDetails.combat then
						SRM_Combat({[self.UnitID] = true})
					end
					SRM_Units[self.UnitID].Location = uDetails.location
					SRM_Units[self.UnitID].PetID = Inspect.Unit.Lookup(self.Spec..".pet")
					if uDetails.health == 0 then
						SRM_Units[self.UnitID].Dead = true
						LibSRM.Dead = LibSRM.Dead + 1
					end
					SRM_Raid.Populated = SRM_Raid.Populated + 1
					SRM_CheckGroupState()
					if SRM_Units[self.UnitID].PetID then
						if SRM_PetQueue.OwnerWait.Queued then
							if SRM_PetQueue.OwnerWait[SRM_Units[self.UnitID].PetID] then
								SRM_PetQueue.OwnerWait[SRM_Units[self.UnitID].PetID] = nil
								SRM_PetQueue.OwnerWait.Queued = SRM_PetQueue.OwnerWait.Queued - 1
								SRM_Units.Pets[SRM_Units[self.UnitID].PetID].OwnerID = self.UnitID
								--print("Unit's Pet loaded!")
								SRM_Pet.Add(self.PetID, self.UnitID)
							end
						end
					end
					-- Send JOIN message HERE
					SRM_Group.Join(self.UnitID, self.Spec)
					--print("Unit joined group: "..uDetails.name)
				else
					-- Send JOIN-WAIT message HERE (maybe)
					SRM_UnitQueue:Add(self)
					--print("Unit joined group, details not loaded.")
				end
			end
		end
	end
	
	local event = Library.LibUnitChange.Register(Specifier)
	table.insert(event, {function (data) Unit:Change(data, false) end, "SafesRaidManager", Specifier})
	event = Library.LibUnitChange.Register(Specifier..".pet")
	table.insert(event, {function (data) Unit:Change(data, true) end, "SafesRaidManager", Specifier})
	Unit:Load()
	Unit:PetLoad()
end

local function SRM_Death(data)
	local sent = false
	if data.target then
		if LibSRM.Player.Grouped then
			if SRM_Units[data.target] then
				-- Group member damage
				if data.target == LibSRM.Player then
					data.player = true
				else
					data.player = false
				end
				if not SRM_Units[data.target].Dead then
					SRM_Units[data.target].Dead = true
					LibSRM.Dead = LibSRM.Dead + 1
				end
				data.specifier = SRM_Units[data.target].Specifier
				SRM_Group.Combat.Death(data)
				sent = true
			end
		else
			if data.target == LibSRM.Player.ID then
				-- Player damage
				data.player = true
				LibSRM.Dead = 1
				SRM_Group.Combat.Death(data)
				sent = true
			end
		end
	end
	if sent == false then
		SRM_System.Combat.Death(data.target, data.caster)
	end
end

local function SRM_Res(TargetID, CasterID)
	if SRM_Units[TargetID].Dead then
		SRM_Units[TargetID].Dead = false
		LibSRM.Dead = LibSRM.Dead - 1
		SRM_Group.Combat.Res(TargetID, CasterID)
	end
end

local function SRM_Heal(data)
	local sent = false
	if data.caster then
		if LibSRM.Player.Grouped then
			if SRM_Units[data.caster] then
				-- Group member damage
				if data.caster == LibSRM.Player then
					data.player = true
				else
					data.player = false
				end
				data.pet = false
				data.owner = nil
				data.specifier = SRM_Units[data.caster].Specifier
				if data.target then
					if SRM_Units[data.target] then
						if SRM_Units[data.target].Dead then
							-- Player was previously dead, this SHOULD be a res skill.
							SRM_Res(data.target, data.caster)
						end
					end
				end
				SRM_Group.Combat.Heal(data)
				sent = true
			elseif SRM_Units.Pets[data.caster] then
				-- Group member's pet healing. Usually only Cleric Fairy
				if SRM_Units.Pets[data.caster].OwnerID == LibSRM.Player.ID then
					data.player = true
				else
					data.player = false
				end
				data.pet = true
				data.owner = SRM_Units.Pets[data.caster].OwnerID
				data.specifier = SRM_Units.Pets[data.caster].Specifier
				SRM_Group.Combat.Heal(data)
				sent = true
			else
				PetOwnerID = Inspect.Unit.Lookup(data.caster..".owner")
				if PetOwnerID then
					if SRM_Units[PetOwnerID] then
						-- Group member's summoned pet healing? Doubtful
						if PetOwnerID == LibSRM.Player.ID then
							data.player = true
						else
							data.player = false
						end
						data.pet = true
						data.owner = PetOwnerID
						data.specifier = SRM_Units[PetOwnerID].Specifier
						SRM_Group.Combat.Heal(data)
						sent = true
					end
				end
			end
		else
			if data.caster == LibSRM.Player.ID then
				-- Player damage
				data.pet = false
				data.owner = nil
				data.player = true
				SRM_Group.Combat.Heal(data)
				sent = true
			elseif data.caster == LibSRM.Player.PetID then
				-- Player pet damage
				data.pet = true
				data.owner = LibSRM.Player.ID
				data.player = true
				SRM_Group.Combat.Heal(data)
				sent = true
			else
				PetOwnerID = Inspect.Unit.Lookup(data.caster..".owner")
				if PetOwnerID == LibSRM.Player.ID then
					-- Player Summoned pet damage
					data.pet = true
					data.owner = LibSRM.Player.ID
					data.player = true
					SRM_Group.Combat.Heal(data)
					sent = true
				end
			end
		end
	else
		if data.target then
			if SRM_Units[data.target] then
				if SRM_Units[data.target].Dead then
					-- Player was previously dead, this SHOULD be a res skill.
					SRM_Res(data.target, data.target)
					sent = true
				end
			end
		end
	end
	if sent == false then
		SRM_System.Combat.Heal(data)
	end
end

local function SRM_Damage(data)
	local sent = false
	if data.caster then
		if LibSRM.Player.Grouped then
			if SRM_Units[data.caster] then
				-- Group member damage
				if data.caster == LibSRM.Player then
					data.player = true
				else
					data.player = false
				end
				data.pet = false
				data.owner = nil
				data.specifier = SRM_Units[data.caster].Specifier
				SRM_Group.Combat.Damage(data)
				sent = true
			elseif SRM_Units.Pets[data.caster] then
				-- Group member's pet damage
				if SRM_Units.Pets[data.caster].OwnerID == LibSRM.Player.ID then
					data.player = true
				else
					data.player = false
				end
				data.pet = true
				data.owner = SRM_Units.Pets[data.caster].OwnerID
				data.specifier = SRM_Units.Pets[data.caster].Specifier
				SRM_Group.Combat.Damage(data)
				sent = true
			else
				PetOwnerID = Inspect.Unit.Lookup(data.caster..".owner")
				if PetOwnerID then
					if SRM_Units[PetOwnerID] then
						-- Group member's summoned pet damage
						if PetOwnerID == LibSRM.Player.ID then
							data.player = true
						else
							data.player = false
						end
						data.pet = true
						data.owner = PetOwnerID
						data.specifier = SRM_Units[PetOwnerID].Specifier
						SRM_Group.Combat.Damage(data)
						sent = true
					end
				end
			end
		else
			if data.caster == LibSRM.Player.ID then
				-- Player damage
				data.pet = false
				data.owner = nil
				data.player = true
				SRM_Group.Combat.Damage(data)
				sent = true
			elseif data.caster == LibSRM.Player.PetID then
				-- Player pet damage
				data.pet = true
				data.owner = LibSRM.Player.ID
				data.player = true
				SRM_Group.Combat.Damage(data)
				sent = true
			else
				PetOwnerID = Inspect.Unit.Lookup(data.caster..".owner")
				if PetOwnerID == LibSRM.Player.ID then
					-- Player Summoned pet damage
					data.pet = true
					data.owner = LibSRM.Player.ID
					data.player = true
					SRM_Group.Combat.Damage(data)
					sent = true
				end
			end
		end
	end
	if sent == false then
		SRM_System.Combat.Damage(data)
	end
end

local function SRM_InitRaid()
	local Specifier
	for i = 1, 20 do
		Specifier = SRM_IndexToSpec(i)
		SRM_SetSpecifier(Specifier)
	end
end

local function SRM_UnitAvailable(units)
	if (SRM_UnitQueue.Queued + SRM_PetQueue.Queued) > 0 then
		for UnitID, Specifier in pairs(units) do
			if SRM_UnitQueue[UnitID] then
				SRM_UnitQueue[UnitID]:Load()
				SRM_UnitQueue[UnitID] = nil
				SRM_UnitQueue.Queued = SRM_UnitQueue.Queued - 1
			elseif SRM_PetQueue[UnitID] then
				--print("Pet found in queue, loading.")
				if SRM_PetQueue[UnitID].Group then
					SRM_PetQueue[UnitID].RaidUnit:PetLoad()
					SRM_PetQueue[UnitID] = nil
					SRM_PetQueue.Queued = SRM_PetQueue.Queued - 1
				else
					
				end
			end
		end
	end
end
table.insert(Event.Unit.Available, {SRM_UnitAvailable, "SafesRaidManager", "Unit Available"})

local function SRM_PlayerPet(PetUID)
	if PetUID then
		-- Player Pet Added
		-- print("Players Pet Added.")
		LibSRM.Player.PetID = PetUID
		SRM_System.Player.Pet.Add(PetUID)
	else
		-- Player Pet Removed
		-- print("Players Pet Removed.")
		SRM_System.Player.Pet.Remove()
		LibSRM.Player.PetID = nil
	end
end

local function SRM_Stall()
	local current = Inspect.Time.Real()
	if current - SRM_HeldTime > 1 then
		local PlayerDets = {}
		LibSRM.Player.ID = Inspect.Unit.Lookup("player")
		LibSRM.Player.PetID = Inspect.Unit.Lookup("player.pet")
		PlayerDets = Inspect.Unit.Detail(LibSRM.Player.ID)
		if PlayerDets then
			if PlayerDets.name then
				-- Remove this Handler, start actual program
				for i, n in ipairs(Event.System.Update.Begin) do
					if n[2] == "SafesRaidManager" then
						table.remove(Event.System.Update.Begin, i)
						break
					end
				end
				LibSRM.Player.Loaded = true
				SRM_System.Player.Ready(LibSRM.Player.ID, PlayerDets)
				local event = Library.LibUnitChange.Register("player.pet")
				table.insert(Event.Combat.Damage, {SRM_Damage, "SafesRaidManager", "Damage Monitor"})
				table.insert(Event.Combat.Heal, {SRM_Heal, "SafesRaidManager", "Heal Monitor"})
				table.insert(Event.Combat.Death, {SRM_Death, "SafesRaidManager", "Death Monitor"})
				table.insert(Event.Unit.Detail.Combat, {SRM_Combat, "SafesRaidManager", "Combat Monitor"})
				table.insert(event, {SRM_PlayerPet, "SafesRaidManager", "player.pet"})
				if LibSRM.Player.PetID then
					--print(": Players Pet Loaded.")
					PetDetails = Inspect.Unit.Detail(LibSRM.Player.PetID)
					if PetDetails then
						LibSRM.Player.PetName = PetDetails.name
					end
				end
				print(": Initialized v"..LibSRM.AddonDetails.toc.Version)
				SRM_InitRaid()
				return
			end
		end
	end
end
table.insert(Event.System.Update.Begin, {SRM_Stall, "SafesRaidManager", "Event"})

-- Public Functions
function LibSRM.Group.Inspect(index)
	if index > 0 and index < 21 then
		local CheckSpec = SRM_IndexToSpec(index)
		local UID = nil
		if SRM_Raid[CheckSpec] then
			UID = SRM_Raid[CheckSpec].UnitID
		end
		--print("Returning: "..tostring(CheckSpec)..", "..tostring(UID))
		return CheckSpec, UID
	end
end
function LibSRM.Group.UnitExists(UID)
	if SRM_Units[UID] then
		return SRM_Units[UID].Specifier
	end
end
function LibSRM.Group.PetExists(PetID)
	if SRM_Units.Pets[PetID] then
		return SRM_Units.Pets[PetID].Specifier, SRM_Units.Pets[PetID].OwnerUID
	end
end
function LibSRM.GroupCount()
	return SRM_Raid.Populated
end
function LibSRM.Grouped()
	return LibSRM.Player.Grouped
end
function LibSRM.Player.Ready()
	return LibSRM.Player.Loaded
end

print(": Loaded")