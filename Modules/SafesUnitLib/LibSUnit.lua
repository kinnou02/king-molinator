-- Safe's Unit Library
-- Written By Paul Snart
-- Copyright 2012
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesUnitLib
-- Dependency: SafesUnitLib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibSUnit = Inspect.Addon.Detail("SafesUnitLib").data

SafesUnitLib_Settings = {}

local AddonIni, LibSUnit = ...

-- Timer Locals
local _inspect = Inspect.Unit.Detail
local _timeReal = Inspect.Time.Real
local _lastTick = _timeReal()

-- Used for purging Idle units (Segments in seconds)
-- Constant
local _tSegThrottle = 15
local _idleSeg = 3
local _deadSeg = 12
local _reserveSeg = 120
-- Variable
local _lastSeg = math.floor(_lastTick / _tSegThrottle)

-- Raid, Group and Player registers.
local _SpecList = {
	 [0] = "player",
	 [1] = "group01",
	 [2] = "group02",
	 [3] = "group03",
	 [4] = "group04",
	 [5] = "group05",
	 [6] = "group06",
	 [7] = "group07",
	 [8] = "group08",
	 [9] = "group09",
	[10] = "group10",
	[11] = "group11",
	[12] = "group12",
	[13] = "group13",
	[14] = "group14",
	[15] = "group15",
	[16] = "group16",
	[17] = "group17",
	[18] = "group18",
	[19] = "group19",
	[20] = "group20",
}

LibSUnit.Raid = {
	Lookup = {},
	UID = {},
	Queue = {},
	Move = {},
	Pets = {},
	Members = 0,
	Group = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		Total = 0,
	},
	Grouped = false,
	Combat = false,
	CombatTotal = 0,
	Wiped = false,
	DeadTotal = 0,
	Offline = 0,
	Mode = "party",
}

LibSUnit.Cache = {
	Avail = {},
	Partial = {},
	Idle = {},
}

LibSUnit.Lookup = {
	UID = {},
	UTID = {},
	Name = {},
}

LibSUnit.Total = {
	UID = 0,
	UTID = 0,
	Name = 0,
	Avail = 0,
	Partial = 0,
	Idle = 0,
	Reserved = 0,
	Players = 0,
	NPC = 0,
}

LibSUnit.Player = {}

LibSUnit._internal = {
	Avail = {},
	Combat = {},
	Unit = {},
	Segment = {},
	Context = UI.CreateContext(AddonIni.id),
	Settings = {
		Debug = false,
		Tracker = {
			Show = false,
			x = false,
			y = false,
		},
	},
	Event = {
		Unit = {
			New = {
				Full = Utility.Event.Create(AddonIni.id, "Unit.New.Full"),
				Partial = Utility.Event.Create(AddonIni.id, "Unit.New.Partial"),
				Idle = Utility.Event.Create(AddonIni.id, "Unit.New.Idle"),
			},
			Full = Utility.Event.Create(AddonIni.id, "Unit.Full"),
			Partial = Utility.Event.Create(AddonIni.id, "Unit.Partial"),
			Idle = Utility.Event.Create(AddonIni.id, "Unit.Idle"),
			Removed = Utility.Event.Create(AddonIni.id, "Unit.Removed"),
			Detail = {
				Percent = Utility.Event.Create(AddonIni.id, "Unit.Detail.Percent"),
				PercentFlat = Utility.Event.Create(AddonIni.id, "Unit.Detail.PercentFlat"),
				Health = Utility.Event.Create(AddonIni.id, "Unit.Detail.Health"),
				HealthMax = Utility.Event.Create(AddonIni.id, "Unit.Detail.HealthMax"),
				Mark = Utility.Event.Create(AddonIni.id, "Unit.Mark"),
				Relation = Utility.Event.Create(AddonIni.id, "Unit.Detail.Relation"),
				Role = Utility.Event.Create(AddonIni.id, "Unit.Detail.Role"),
				Name = Utility.Event.Create(AddonIni.id, "Unit.Detail.Name"),
				Power = Utility.Event.Create(AddonIni.id, "Unit.Detail.Power"),
				PowerMax = Utility.Event.Create(AddonIni.id, "Unit.Detail.PowerMax"),
				PowerMode = Utility.Event.Create(AddonIni.id, "Unit.Detail.PowerMode"),
				Calling = Utility.Event.Create(AddonIni.id, "Unit.Detail.Calling"),
				Combat = Utility.Event.Create(AddonIni.id, "Unit.Detail.Combat"),
				Offline = Utility.Event.Create(AddonIni.id, "Unit.Detail.Offline"),
				Planar = Utility.Event.Create(AddonIni.id, "Unit.Detail.Planar"),
				PlanarMax = Utility.Event.Create(AddonIni.id, "Unit.Detail.PlanarMax"),
				Ready = Utility.Event.Create(AddonIni.id, "Unit.Detail.Ready"),
				Vitality = Utility.Event.Create(AddonIni.id, "Unit.Detail.Vitality"),
				Level = Utility.Event.Create(AddonIni.id, "Unit.Detail.Level"),
				Zone = Utility.Event.Create(AddonIni.id, "Unit.Detail.Zone"),
				Location = Utility.Event.Create(AddonIni.id, "Unit.Detail.Location"),
				Warfront = Utility.Event.Create(AddonIni.id, "Unit.Detail.Warfront"),
			},
			Target = Utility.Event.Create(AddonIni.id, "Unit.Target"),
			TargetCount = Utility.Event.Create(AddonIni.id, "Unit.TargetCount"),
		},
		Combat = {
			Death = Utility.Event.Create(AddonIni.id, "Combat.Death"),
			Damage = Utility.Event.Create(AddonIni.id, "Combat.Damage"),
			Heal = Utility.Event.Create(AddonIni.id, "Combat.Heal"),
			Immune = Utility.Event.Create(AddonIni.id, "Combat.Immune"),
		},
		Raid = {
			Join = Utility.Event.Create(AddonIni.id, "Raid.Join"),
			Leave = Utility.Event.Create(AddonIni.id, "Raid.Leave"),
			Member = {
				Join = Utility.Event.Create(AddonIni.id, "Raid.Member.Join"),
				Leave = Utility.Event.Create(AddonIni.id, "Raid.Member.Leave"),
				Move = Utility.Event.Create(AddonIni.id, "Raid.Member.Move"),
			},
			Pet = {
				Join = Utility.Event.Create(AddonIni.id, "Raid.Pet.Join"),
				Leave = Utility.Event.Create(AddonIni.id, "Raid.Pet.Leave"),
			},
			Combat = {
				Enter = Utility.Event.Create(AddonIni.id, "Raid.Combat.Enter"),
				Leave = Utility.Event.Create(AddonIni.id, "Raid.Combat.Leave"),
			},
			Wipe = Utility.Event.Create(AddonIni.id, "Raid.Wipe"),
			Res = Utility.Event.Create(AddonIni.id, "Raid.Res"),
			Death = Utility.Event.Create(AddonIni.id, "Raid.Death"),
			Mode = Utility.Event.Create(AddonIni.id, "Raid.Mode"),
		},
		System = {
			Start = Utility.Event.Create(AddonIni.id, "System.Start"),
		},
	},
}
_lsu = LibSUnit._internal

_lsu.TargetQueue = {}

-- Settings
function _lsu.Load(handle, AddonId)
	if AddonId == AddonIni.id then
		if next(SafesUnitLib_Settings) then
			_lsu.Settings = SafesUnitLib_Settings
		else
			SafesUnitLib_Settings = _lsu.Settings
		end
		_lsu.Debug:Init()
		if _lsu.Settings.Debug then
			_lsu.Debug.GUI.Header:SetVisible(true)
		end
	end
end

function _lsu.Save(handle, AddonId)
	if AddonId == AddonIni.id then
		SafesUnitLib_Settings = _lsu.Settings
	end
end

-- Unit Management Event Handlers and Functions
function _lsu.Unit:UpdateTarget(UnitObj, newTar)
	-- if newTar == nil then
		-- newTar = Inspect.Unit.Lookup(UnitObj.UnitID..".target")
	-- end
	if newTar ~= UnitObj.Target then
		if UnitObj.Target then
			local targetObj = LibSUnit.Lookup.UID[UnitObj.Target]
			if targetObj then
				if targetObj.TargetList[UnitObj.UnitID] then
					targetObj.TargetCount = targetObj.TargetCount - 1
					targetObj.TargetList[UnitObj.UnitID] = nil
					_lsu.Event.Unit.TargetCount(targetObj)
				end
			end
		end
		UnitObj.Target = newTar
		if newTar then
			local targetObj = LibSUnit.Lookup.UID[newTar]
			if not targetObj then
				targetObj = _lsu:Create(newTar, _inspect(newTar), "Avail")
			end
			if targetObj then
				if not targetObj.TargetList[UnitObj.UnitID] then
					targetObj.TargetCount = targetObj.TargetCount + 1
					targetObj.TargetList[UnitObj.UnitID] = UnitObj
					_lsu.Event.Unit.TargetCount(targetObj)
				end
			end
		end
		-- Target Change Event
		_lsu.Event.Unit.Target(UnitObj)
	end
end

function _lsu.Unit:CalcPerc(UnitObj)
	-- Calculate Percentages
	UnitObj.PercentRaw = UnitObj.Health/UnitObj.HealthMax
	if UnitObj.PercentRaw > 1 then
		UnitObj.PercentRaw = 1
	end
	UnitObj.Percent = UnitObj.PercentRaw * 100
	UnitObj.PercentFlat = math.ceil(UnitObj.Percent)
	UnitObj.Percent = tonumber(string.format("%0.2f", UnitObj.Percent))
	
	if UnitObj.PercentLast ~= UnitObj.Percent then
		-- Fire Percent (2 decimal place) change.
		_lsu.Event.Unit.Detail.Percent(UnitObj)
		
		if UnitObj.PercentFlat ~= UnitObj.PercentFlatLast then
			-- Fire a Percent Flat change Event.
			_lsu.Event.Unit.Detail.PercentFlat(UnitObj)
			-- Store change.
			UnitObj.PercentFlatLast = UnitObj.PercentFlat
		end
		-- Store change.
		UnitObj.PercentLast = UnitObj.Percent
	end
end

function _lsu.Unit:UpdateSegment(UnitObj, New, uDetails)
	-- Adjust Idle segment placement
	if UnitObj.IdleSegment then
		_lsu.Segment[UnitObj.IdleSegment][UnitObj.UnitID] = nil
		if UnitObj.Reserved then
			UnitObj.Reserved = false
			LibSUnit.Total.Reserved = LibSUnit.Total.Reserved - 1
		end
	end
	if New then
		if _lsu.Segment[New] then
			_lsu.Segment[New][UnitObj.UnitID] = UnitObj
		else
			_lsu.Segment[New] = {[UnitObj.UnitID] = UnitObj}
		end
		UnitObj.IdleSegment = New
		if uDetails then
			--self.Details(UnitObj, uDetails)
			if UnitObj.Health ~= uDetails.health then
				UnitObj.Health = uDetails.health or 0
				self:CalcPerc(UnitObj)
			end
			if uDetails.name then
				if UnitObj.Name ~= uDetails.name then
					_lsu.Unit.Name(Event.Unit.Detail.Name, {[UnitObj.UnitID] = uDetails.name})
				end
			end
		end
	else
		UnitObj.IdleSegment = false	
	end
end

function _lsu:Create(UID, uDetails, Type)
	-- Creates a new Unit Object ready for tracking.
	if not uDetails then
		return
	end
	
	local _type = LibSUnit.Cache[Type]
	local _total = LibSUnit.Total
	local _UID = LibSUnit.Lookup.UID
	local _name = LibSUnit.Lookup.Name
	local _calc = self.Unit.CalcPerc
	
	_UID[UID] = {
		Details = uDetails,
		Loaded = false,
		IdleSegment = false,
		CurrentTable = _type,
		CurrentKey = Type,
		PercentRaw = 0,
		PercentFlat = 0,
		Percent = 0,
		Type = uDetails.type,
		Tier = uDetails.tier,
		Level = uDetails.level,
		Player = uDetails.player,
		Mark = tonumber(uDetails.mark),
		Relation = uDetails.relation,
		HealthMax = uDetails.healthMax or 1,
		Health = uDetails.health or 0,
		Role = uDetails.role,
		Calling = uDetails.calling,
		GuaranteedLoot = uDetails.guaranteedLoot,
		Offline = uDetails.offline,
		Combat = uDetails.combat,
		Ready = uDetails.ready,
		Planar = uDetails.planar,
		PlanarMax = uDetails.planarMax,
		Vitality = uDetails.vitality,
		Zone = uDetails.zone,
		Location = uDetails.locationName,
		Target = nil,
		UnitID = UID,
		OwnerID = uDetails.ownerID,
		Dead = false,
		Name = uDetails.name or "",
		TargetCount = 0,
		Reserved = false,
		Warfront = uDetails.warfront,
		TargetList = {},
		Position = {
			X = uDetails.coordX or 0,
			Y = uDetails.coordY or 0,
			Z = uDetails.coordZ or 0,
		},
	}
	
	local UnitObj = _UID[UID]
	if uDetails.mana then
		UnitObj.PowerMode = "mana"
		UnitObj.PowerMax = uDetails.manaMax
	elseif uDetails.power then
		UnitObj.PowerMode = "power"
		UnitObj.PowerMax = 100
	elseif uDetails.energy then
		UnitObj.PowerMode = "energy"
		UnitObj.PowerMax = uDetails.energyMax
	else
		UnitObj.PowerMode = ""
		UnitObj.PowerMax = 1
		UnitObj.Power = 1
	end
		
	UnitObj.Power = uDetails[PowerMode]
	
	_type[UID] = UnitObj
	_total[Type] = _total[Type] + 1
	if uDetails.availability == "full" then
		if UnitObj.Health == 0 then
			UnitObj.Dead = true
		end
		if UnitObj.Name == "" then
			UnitObj.Name = "<Unknown>"
		end
		if _name[UnitObj.Name] then
			_name[UnitObj.Name][UID] = UnitObj
		else
			_name[UnitObj.Name] = {[UID] = UnitObj}
		end
		-- Unit has been fully loaded at some point. Flag this here to ensure safe Detail reading of all fields.
		UnitObj.Loaded = true
		-- Calculate initial percentages, bypassing related events to avoid garbage results.
		UnitObj.PercentRaw = UnitObj.Health/UnitObj.HealthMax
		if UnitObj.PercentRaw > 1 then
			UnitObj.PercentRaw = 1
		end
		UnitObj.Percent = tonumber(string.format("%0.2f", UnitObj.PercentRaw * 100))
		UnitObj.PercentLast = UnitObj.Percent -- Ensure the last recorded percentage is initialized.
		UnitObj.PercentFlat = math.ceil(UnitObj.Percent)
		UnitObj.PercentFlatLast = UnitObj.PercentFlat -- Ensure the last recorded flat percentage is initialized.
		_lsu.Unit:UpdateTarget(UnitObj, Inspect.Unit.Detail(UID..".target"))
		if Type == "Avail" then
			-- Fire Unit New Full Event
			_lsu.Event.Unit.New.Full(UnitObj)
		else
			-- Fire Unit Idle Full Event
			_lsu.Event.Unit.New.Idle(UnitObj)
		end
	else
		if Type == "Avail" then
			-- Fire Unit New Partial Event
			_lsu.Event.Unit.New.Partial(UnitObj)
		else
			-- Fire Unit Idle Partial Event
			_lsu.Event.Unit.New.Idle(UnitObj)
		end
	end
	if LibSUnit.Raid.Queue[UID] then
		_lsu.Raid.newCheck(UID, LibSUnit.Raid.Queue[UID])
		LibSUnit.Raid.Queue[UID] = nil
	end
	if UnitObj.Mark then
		_lsu.Event.Unit.Detail.Mark({[UID] = UnitObj})
	end
	return UnitObj
end

-- Details Updates
function _lsu.Unit.Name(handle, uList)
	local _lookup = LibSUnit.Lookup.Name
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Name in pairs(uList) do
		if Name then
			if Name ~= "" then
				local UnitObj = _cache[UID]
				if UnitObj.Name ~= Name then
					if _lookup[UnitObj.Name] then
						_lookup[UnitObj.Name][UID] = nil
						if not next(_lookup[UnitObj.Name]) then
							_lookup[UnitObj.Name] = nil
						end
					end				
				end
				UnitObj.Details.name = Name
				UnitObj.Name = Name
				if _lookup[UnitObj.Name] then
					_lookup[UnitObj.Name][UID] = UnitObj
				else
					_lookup[UnitObj.Name] = {[UID] = UnitObj}
				end
				newList[UID] = UnitObj
			end
		end
	end
	_lsu.Event.Unit.Detail.Name(newList)	
end

function _lsu.Unit.Health(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Health in pairs(uList) do
		Health = tonumber(Health) or 0
		local UnitObj = _cache[UID]
		UnitObj.Health = Health
		_lsu.Unit:CalcPerc(UnitObj)
		newList[UID] = UnitObj
		if Health == 0 then
			if not UnitObj.Dead then
				_lsu.Raid.ManageDeath(UnitObj, true)
			end
		elseif Health > 0 then
			if UnitObj.Dead then
				_lsu.Raid.ManageDeath(UnitObj, false)
			end
		end
	end
	_lsu.Event.Unit.Detail.Health(newList)
end

function _lsu.Unit.HealthMax(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, HealthMax in pairs(uList) do
		HealthMax = tonumber(HealthMax)
		if HealthMax then
			if HealthMax ~= _cache[UID].HealthMax then
				_cache[UID].HealthMax = HealthMax
				_lsu.Unit:CalcPerc(_cache[UID])
				newList[UID] = _cache[UID]
			end
		end
	end
	_lsu.Event.Unit.Detail.HealthMax(newList)	
end

function _lsu.Unit.Power(handle, uList, PowerMode)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Power in pairs(uList) do
		if Power then
			if Power ~= _cache[UID].Power then
				if PowerMode ~= _cache[UID].PowerMode then
					_cache[UID].PowerMode = PowerMode
					_lsu.Event.Unit.Detail.PowerMode(_cache[UID])
				end
				_cache[UID].Power = Power
				newList[UID] = _cache[UID]
			end
		end
	end
	_lsu.Event.Unit.Detail.Power(newList)	
end

function _lsu.Unit.PowerMax(handle, uList, PowerMode)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, PowerMax in pairs(uList) do
		if PowerMax then
			if PowerMax ~= _cache[UID].PowerMax then
				if PowerMode ~= _cache[UID].PowerMode then
					_cache[UID].PowerMode = PowerMode
					_lsu.Event.Unit.Detail.PowerMode(_cache[UID])
				end
				_cache[UID].PowerMax = PowerMax
				newList[UID] = _cache[UID]
			end
		end
	end
	_lsu.Event.Unit.Detail.PowerMax(newList)	
end

function _lsu.Unit.Offline(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Offline in pairs(uList) do
		_cache[UID].Offline = Offline
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Offline(newList)
end

function _lsu.Unit.Vitality(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Vitality in pairs(uList) do
		_cache[UID].Vitality = Vitality
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Vitality(newList)	
end

function _lsu.Unit.Ready(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Ready in pairs(uList) do
		_cache[UID].Ready = Ready
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Ready(newList)
end

function _lsu.Unit.Mark(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Mark in pairs(uList) do
		_cache[UID].Mark = tonumber(Mark)
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Mark(newList)
end

function _lsu.Unit.Planar(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Planar in pairs(uList) do
		_cache[UID].Planar = Planar
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Planar(newList)
end

function _lsu.Unit.Level(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Level in pairs(uList) do
		_cache[UID].Level = Level
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Level(newList)	
end

function _lsu.Unit.Zone(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Zone in pairs(uList) do
		_cache[UID].Zone = Zone
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Zone(newList)	
end

function _lsu.Unit.Location(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Location in pairs(uList) do
		_cache[UID].Location = Location or "Unavailable"
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Location(newList)
end

function _lsu.Unit.Role(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Role in pairs(uList) do
		if Role then
			_cache[UID].Role = Role
			newList[UID] = _cache[UID]
		end
	end
	_lsu.Event.Unit.Detail.Role(newList)
end

function _lsu.Unit.PlanarMax(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, PlanarMax in pairs(uList) do
		_cache[UID].PlanarMax = PlanarMax
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.PlanarMax(newList)
end

function _lsu.Unit.Warfront(handle, uList)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Warfront in pairs(uList) do
		_cache[UID].Warfront = Warfront
		newList[UID] = _cache[UID]
	end
	_lsu.Event.Unit.Detail.Warfront(newList)
end

function _lsu.Unit.Combat(handle, uList, Silent)
	local _cache = LibSUnit.Lookup.UID
	local newList = {}
	for UID, Combat in pairs(uList) do
		if LibSUnit.Raid.UID[UID] then
			-- Adjust Raid Combat State
			if Combat ~= _cache[UID].Combat then
				if Combat then
					LibSUnit.Raid.CombatTotal = LibSUnit.Raid.CombatTotal + 1
					if not LibSUnit.Raid.Combat then
						LibSUnit.Raid.Combat = true
						--print("Raid Entered Combat")
						_lsu.Event.Raid.Combat.Enter()
					end
					if _lsu.Settings.Debug then
						_lsu.Debug:UpdateCombat()
					end
				else
					LibSUnit.Raid.CombatTotal = LibSUnit.Raid.CombatTotal - 1
					if LibSUnit.Raid.Combat then
						if LibSUnit.Raid.CombatTotal == 0 then
							LibSUnit.Raid.Combat = false
							--print("Raid Left Combat")
							_lsu.Event.Raid.Combat.Leave()
						end
					end
					if _lsu.Settings.Debug then
						_lsu.Debug:UpdateCombat()
					end
				end
			end
		end
		_cache[UID].Combat = Combat
		newList[UID] = _cache[UID]
	end
	if not Silent then
		_lsu.Event.Unit.Detail.Combat(newList)
	end
end

function _lsu.Unit.Details(UnitObj, uDetails)
	if UnitObj.CurrentKey == "Partial" then
		
	else
		UnitObj.Type = uDetails.type
		UnitObj.Tier = uDetails.tier
		UnitObj.Player = uDetails.player
		UnitObj.Location = uDetails.locationName
		UnitObj.GuaranteedLoot = uDetails.guaranteedLoot
		if uDetails.role then
			UnitObj.Role = uDetails.role
		end
		if uDetails.name then
			if UnitObj.Name ~= uDetails.name then
				if uDetails.name ~= "" then
					_lsu.Unit.Name(Event.Unit.Detail.Name, {[UnitObj.UnitID] = uDetails.name})
				end
			end
		end
		local nMark = tonumber(uDetails.mark)
		if UnitObj.Mark ~= nMark then
			UnitObj.Mark = nMark
			_lsu.Event.Unit.Detail.Mark({[UnitObj.UnitID] = UnitObj})
		end
		if uDetails.zone then
			if uDetails.zone ~= UnitObj.Zone then
				UnitObj.Zone = uDetails.zone
				_lsu.Event.Unit.Detail.Zone({[UnitObj.UnitID] = UnitObj})
			end
		end
		if uDetails.relation then
			if UnitObj.Relation ~= uDetails.relation then
				UnitObj.Relation = uDetails.relation
				_lsu.Event.Unit.Detail.Relation(UnitObj)
			end
		end
		if uDetails.player then
			if uDetails.role then
				if UnitObj.Role ~= uDetails.role then
					UnitObj.Role = uDetails.role
					_lsu.Event.Unit.Detail.Role(UnitObj)
				end
			end
		end
		if uDetails.calling then
			if UnitObj.Calling ~= uDetails.calling then
				UnitObj.Calling = uDetails.calling
				_lsu.Event.Unit.Detail.Calling(UnitObj)
			end
		end
		if uDetails.healthMax then
			if uDetails.healthMax ~= UnitObj.HealthMax then
				UnitObj.HealthMax = uDetails.healthMax
			end
		end
		if uDetails.level then
			if uDetails.level ~= UnitObj.Level then
				UnitObj.Level = uDetails.level
			end
		end
		if uDetails.warfront ~= UnitObj.Warfront then
			_lsu.Unit.Warfront(handle, {[UnitObj.UnitID] = uDetails.warfront or false})
		end
		UnitObj.Health = uDetails.health or 0
		if uDetails.health ~= UnitObj.Health then
			UnitObj.Health = uDetails.health
		end
		if UnitObj.PowerMode then
			if UnitObj.PowerMode == "mana" then
				UnitObj.Power = uDetails.mana
				UnitObj.PowerMax = uDetails.manaMax
			elseif UnitObj.PowerMode == "power" then
				UnitObj.Power = uDetails.power
				UnitObj.PowerMax = 100
			elseif UnitObj.PowerMode == "energy" then
				UnitObj.Power = uDetails.energy
				UnitObj.PowerMax = uDetails.energyMax
			end
		end
		UnitObj.Planar = uDetails.planar
		UnitObj.PlanarMax = uDetails.planarMax
		UnitObj.Ready = uDetails.ready
		UnitObj.Vitality = uDetails.vitality
		if UnitObj.Combat ~= uDetails.combat then
			_lsu.Unit.Combat(Event.Unit.Detail.Combat, {[UnitObj.UnitID] = uDetails.combat})
		end
		_lsu.Unit:CalcPerc(UnitObj)
		UnitObj.Details = uDetails
		UnitObj.Loaded = true
		if UnitObj.Health == 0 then
			if not UnitObj.Dead then
				_lsu.Raid.ManageDeath(UnitObj, true)
			end
		elseif UnitObj.Health > 0 then
			if UnitObj.Dead then
				_lsu.Raid.ManageDeath(UnitObj, false)
			end
		end
	end
end

function _lsu:Available(UnitObj, uDetails)
	-- Switches State for Units to Available.
	local UID = UnitObj.UnitID
	local Total = LibSUnit.Total
	
	Total[UnitObj.CurrentKey] = Total[UnitObj.CurrentKey] - 1
	UnitObj.CurrentTable[UID] = nil
	UnitObj.CurrentTable = LibSUnit.Cache.Avail
	UnitObj.CurrentKey = "Avail"
	LibSUnit.Cache.Avail[UID] = UnitObj
	self.Unit:UpdateSegment(UnitObj)
	Total.Avail = Total.Avail + 1
	self.Unit.Details(UnitObj, uDetails)
	
	self.Event.Unit.Full(UnitObj)
end

function _lsu:Partial(UnitObj, uDetails)
	-- Switches State for Units to Partial.
	local UID = UnitObj.UnitID
	local Total = LibSUnit.Total
	
	Total[UnitObj.CurrentKey] = Total[UnitObj.CurrentKey] - 1
	UnitObj.CurrentTable[UID] = nil
	UnitObj.CurrentTable = LibSUnit.Cache.Partial
	UnitObj.CurrentKey = "Partial"
	LibSUnit.Cache.Partial[UID] = UnitObj
	self.Unit:UpdateSegment(UnitObj)
	Total.Partial = Total.Partial + 1
	if UnitObj.Combat then
		_lsu.Unit.Combat(Event.Unit.Detail.Combat, {[UnitObj.UnitID] = false})
	end
	
	self.Event.Unit.Partial(UnitObj)
end

function _lsu:Idle(UnitObj)
	-- Switches State for Units to Unavailable.
	local UID = UnitObj.UnitID
	local Total = LibSUnit.Total
	
	Total[UnitObj.CurrentKey] = Total[UnitObj.CurrentKey] - 1
	UnitObj.CurrentTable[UID] = nil
	UnitObj.CurrentTable = LibSUnit.Cache.Idle
	UnitObj.CurrentKey = "Idle"
	LibSUnit.Cache.Idle[UID] = UnitObj
	self.Unit:UpdateSegment(UnitObj, _idleSeg + _lastSeg)
	Total.Idle = Total.Idle + 1
	if UnitObj.Mark then
		UnitObj.Mark = nil
		_lsu.Event.Unit.Detail.Mark{[UnitObj.UnitID] = UnitObj}
	end
	
	self.Event.Unit.Idle(UnitObj)
end

-- Unit Availability Handlers
function _lsu.Avail.Full(handle, uList)
	-- Main handler for new Units

	-- Optimize
	local _lookup = LibSUnit.Lookup.UID
	local _create = _lsu.Create
	
	-- Manage Units.
	for UID, Spec in pairs(uList) do
		local UnitObj = _lookup[UID]
		if not UnitObj then
			UnitObj = _create(_lsu, UID, _inspect(UID), "Avail")
		else
			_lsu:Available(UnitObj, _inspect(UID))
		end
	end
	
	if _lsu.Settings.Debug then
		_lsu.Debug:UpdateAll()
	end
end

function _lsu.Avail.Partial(handle, uList)
	-- Main handler for Partial Units

	-- Optimize
	local _lookup = LibSUnit.Lookup.UID
	local _create = _lsu.Create
	local _part = _lsu.Partial
	
	-- Manage Units.
	for UID, Spec in pairs(uList) do
		if not _lookup[UID] then
			_create(_lsu, UID, _inspect(UID), "Partial")
		else
			_part(_lsu, _lookup[UID], _inspect(UID))
		end
	end
	if _lsu.Settings.Debug then
		_lsu.Debug:UpdateAll()
	end
end

function _lsu.Avail.None(handle, uList)
	-- Move to Idle

	-- Optimize
	local _lookup = LibSUnit.Lookup.UID
	local _create = _lsu.Create
	local _idle = _lsu.Idle
	
	-- Manage Units.
	for UID, Spec in pairs(uList) do
		if not _lookup[UID] then
		else
			_idle(_lsu, _lookup[UID])
		end
	end
	
	if _lsu.Settings.Debug then
		_lsu.Debug:UpdateAll()
	end
end

function _lsu.Unit.Change(UnitID, Spec)
	local sourceUID = Inspect.Unit.Lookup(Spec)
	if sourceUID then
		local UnitObj = LibSUnit.Lookup.UID[sourceUID]
		if UnitObj then
			_lsu.Unit:UpdateTarget(UnitObj, UnitID)
		end
	end
end

-- Raid Management
_lsu.Raid = {}
function _lsu.Raid.ManageDeath(UnitObj, Dead, sourceObj)
	--print("Checking Death State for: "..UnitObj.Name)
	if UnitObj.Loaded then
		if UnitObj.CurrentKey ~= "Partial" then
			if LibSUnit.Raid.UID[UnitObj.UnitID] then
				if Dead then 
					if not UnitObj.Dead then
						LibSUnit.Raid.DeadTotal = LibSUnit.Raid.DeadTotal + 1
						--print(">>> "..UnitObj.Name.." has died")
						if UnitObj.Combat then
							_lsu.Unit.Combat(Event.Unit.Detail.Combat, {[UnitObj.UnitID] = false})
						end
						_lsu.Event.Raid.Death(UnitObj)
						if LibSUnit.Raid.DeadTotal == LibSUnit.Raid.Members then
							if not LibSUnit.Raid.Wiped then
								LibSUnit.Raid.Wiped = true
								_lsu.Event.Raid.Wipe()
							end
						end
						if _lsu.Settings.Debug then
							_lsu.Debug:UpdateDeath()
						end
					end
				else
					if UnitObj.Dead then
					--	print("<<< "..UnitObj.Name.." has is now alive")
						LibSUnit.Raid.DeadTotal = LibSUnit.Raid.DeadTotal - 1
						LibSUnit.Raid.Wiped = false
						_lsu.Event.Raid.Res(UnitObj, sourceObj)
						if _lsu.Settings.Debug then
							_lsu.Debug:UpdateDeath()
						end
					end
				end
			end
			UnitObj.Dead = Dead	
		end
	end
end

function _lsu.Raid.GroupCheck(newGroup, oldGroup)
	if newGroup then
		LibSUnit.Raid.Group[newGroup] = LibSUnit.Raid.Group[newGroup] + 1
		if LibSUnit.Raid.Group[newGroup] == 1 then
			LibSUnit.Raid.Group.Total = LibSUnit.Raid.Group.Total + 1
		end
	end
	if oldGroup then
		LibSUnit.Raid.Group[oldGroup] = LibSUnit.Raid.Group[oldGroup] - 1
		if LibSUnit.Raid.Group[oldGroup] == 0 then
			LibSUnit.Raid.Group.Total = LibSUnit.Raid.Group.Total - 1
		end
	end
	if LibSUnit.Raid.Group.Total <= 1 and LibSUnit.Raid.Mode ~= "party" then
		LibSUnit.Raid.Mode = "party"
		_lsu.Event.Raid.Mode()
	elseif LibSUnit.Raid.Group.Total > 1 and LibSUnit.Raid.Mode ~= "raid" then
		LibSUnit.Raid.Mode = "raid"
		_lsu.Event.Raid.Mode()
	end
	if _lsu.Settings.Debug then
		_lsu.Debug:UpdateMode()
	end
end

function _lsu.Raid.Check(UnitID, Spec)
	if UnitID == LibSUnit.Raid.Lookup[Spec].UID then
		-- Already Handled Raid Change
		-- print("No action required for "..Spec)
		-- print("--------------")
		return
	end
	local newUnitID
	local newUnitObj
	local currentUnitID
	local currentUnitObj
	local totalchanges = 0
	local movedCount = 0
	local leftCount = 0
	local newCount = 0
	local SpecChanged = {}
	local UIDChanged = {
		Moved = {},
		Joined = {},
		Left = {},
	}
	for Index, Spec in pairs(_SpecList) do
		if Index > 0 then
			newUnitID = Inspect.Unit.Lookup(Spec)
			currentUnitObj = LibSUnit.Raid.Lookup[Spec].Unit
			if currentUnitObj then
				currentUnitID = currentUnitObj.UnitID
			else
				currentUnitID = nil
			end
			if newUnitID ~= currentUnitID then
				-- totalchanges = totalchanges + 1
				SpecChanged[Spec] = newUnitID or false
				-- First Check if Pending
				if newUnitID and currentUnitID then
					-- Slot changed Unit
					-- print("Slot Unit Changed: "..Spec)
					newUnitObj = LibSUnit.Lookup.UID[newUnitID]
					currentUnitObj = LibSUnit.Lookup.UID[currentUnitID]
					if not newUnitObj then
						newUnitObj = _lsu:Create(newUnitID, _inspect(newUnitID), "Avail")
					end
					if LibSUnit.Raid.UID[newUnitID] then
						UIDChanged.Moved[newUnitID] = {New = Spec, Old = newUnitObj.RaidLoc}
						-- movedCount = movedCount + 1
						if UIDChanged.Left[newUnitID] then
							-- leftCount = leftCount - 1
							UIDChanged.Left[newUnitID] = nil
						end
					elseif not UIDChanged.Moved[newUnitID] then
						UIDChanged.Joined[newUnitID] = Spec
						-- newCount = newCount + 1
					end
					if UIDChanged.Left[currentUnitID] then
						UIDChanged.Moved[currentUnitID] = {New = Spec, Old = currentUnitObj.RaidLoc}
						-- movedCount = movedCount + 1
						if UIDChanged.Left[currentUnitID] then
							-- leftCount = leftCount - 1
							UID.Changed.Left[currentUnitID] = nil
						end
					elseif not UIDChanged.Moved[currentUnitID] then
						UIDChanged.Left[currentUnitID] = Spec
						-- leftCount = leftCount + 1
					end
				elseif newUnitID then
					-- Empty slot taken
					-- print("Empty Slot Taken: "..Spec)
					newUnitObj = LibSUnit.Lookup.UID[newUnitID]
					if not newUnitObj then
						newUnitObj = _lsu:Create(newUnitID, _inspect(newUnitID), "Avail")
					end
					if LibSUnit.Raid.UID[newUnitID] then
						UIDChanged.Moved[newUnitID] = {New = Spec, Old = newUnitObj.RaidLoc}
						-- movedCount = movedCount + 1
						if UIDChanged.Left[newUnitID] then
							UIDChanged.Left[newUnitID] = nil
							-- leftCount = leftCount - 1
						end
					elseif not UIDChanged.Moved[newUnitID] then
						UIDChanged.Joined[newUnitID] = Spec
						--newCount = newCount + 1
					end
				elseif currentUnitID then
					-- Slot no longer taken
					-- print("Slot now empty: "..Spec)
					currentUnitObj = LibSUnit.Lookup.UID[currentUnitID]
					if UIDChanged.Left[currentUnitID] then
						UIDChanged.Moved[currentUnitID] = {New = Spec, Old = currentUnitObj.RaidLoc}
						--movedCount = movedCount + 1
						if UIDChanged.Left[currentUnitID] then
							--leftCount = leftCount - 1
							UIDChanged.Left[currentUnitID] = nil
						end
					elseif not UIDChanged.Moved[currentUnitID] then
						UIDChanged.Left[currentUnitID] = Spec
						--leftCount = leftCount + 1
					end
				else
					-- no action required
				
				end
			else
				-- no action required
			end
		end
	end
	-- Handle Moves
	for UID, SpecChanges in pairs(UIDChanged.Moved) do
		local UnitObj = LibSUnit.Lookup.UID[UID]
		local newSpec = SpecChanges.New
		local oldSpec = SpecChanges.Old
		local newGroup = LibSUnit.Raid.Lookup[newSpec].Group
		local oldGroup = nil
		LibSUnit.Raid.Lookup[newSpec].Unit = UnitObj
		LibSUnit.Raid.Lookup[newSpec].UID = UID
		LibSUnit.Raid.UID[UnitObj.UnitID] = UnitObj
		UnitObj.RaidLoc = newSpec
		if not SpecChanged[oldSpec] then
			--print("Old Spec Cleared: "..oldSpec)
			LibSUnit.Raid.Lookup[oldSpec].Unit = nil
			LibSUnit.Raid.Lookup[oldSpec].UID = false
			oldGroup = LibSUnit.Raid.Lookup[oldSpec].Group
		end
		_lsu.Raid.GroupCheck(newGroup, oldGroup)
		-- print(UnitObj.Name.." moved to "..newSpec.." from "..oldSpec)
		_lsu.Event.Raid.Member.Move(UnitObj, oldSpec, newSpec)
	end
	
	-- Handle Leaves
	for UID, Spec in pairs(UIDChanged.Left) do
		if LibSUnit.Raid.UID[UID] then
			local UnitObj = LibSUnit.Lookup.UID[UID]
			if UnitObj.Combat then
				LibSUnit.Raid.CombatTotal = LibSUnit.Raid.CombatTotal - 1
				if LibSUnit.Raid.CombatTotal == 0 then
					LibSUnit.Raid.Combat = false
					_lsu.Event.Raid.Combat.Leave()
				end
			end
			LibSUnit.Raid.Lookup[Spec].Unit = nil
			LibSUnit.Raid.Lookup[Spec].UID = false
			LibSUnit.Raid.Members = LibSUnit.Raid.Members - 1
			local oldGroup = LibSUnit.Raid.Lookup[Spec].Group
			LibSUnit.Raid.UID[UnitObj.UnitID] = nil
			UnitObj.RaidLoc = nil
			-- print(UnitObj.Name.." left the Raid")
			if UnitObj.Dead then
				LibSUnit.Raid.DeadTotal = LibSUnit.Raid.DeadTotal - 1
				--print(UnitObj.Name.." has left the Raid and removed death count")
			end
			_lsu.Raid.GroupCheck(nil, oldGroup)
			_lsu.Event.Raid.Member.Leave(UnitObj, Spec)
			if LibSUnit.Raid.Members == 0 then
				LibSUnit.Raid.Grouped = false
				LibSUnit.Raid.Wiped = false
				_lsu.Event.Raid.Leave()
			elseif LibSUnit.Raid.Members > 1 then
				if LibSUnit.Raid.Members == LibSUnit.Raid.DeadTotal then
					if not LibSUnit.Raid.Wiped then
						LibSUnit.Raid.Wiped = true
						_lsu.Event.Raid.Wipe()
					end
				else
					LibSUnit.Raid.Wiped = false
				end				
			end
			if _lsu.Settings.Debug then
				_lsu.Debug:UpdateDeath()
				_lsu.Debug:UpdateCombat()
			end
		end
	end
	
	-- Handle Joins
	for UID, Spec in pairs(UIDChanged.Joined) do
		if not LibSUnit.Raid.UID[UID] then
			local UnitObj = LibSUnit.Lookup.UID[UID]
			local newGroup = LibSUnit.Raid.Lookup[Spec].Group
			LibSUnit.Raid.Members = LibSUnit.Raid.Members + 1
			LibSUnit.Raid.Lookup[Spec].Unit = UnitObj
			LibSUnit.Raid.Lookup[Spec].UID = UID
			LibSUnit.Raid.UID[UID] = UnitObj
			UnitObj.RaidLoc = Spec
			if LibSUnit.Raid.Members == 1 then
				-- print("You have joined a Raid or Group")
				LibSUnit.Raid.Grouped = true
				_lsu.Event.Raid.Join()
			end
			-- print("New Player Joined Raid: "..UnitObj.Name)
			_lsu.Raid.GroupCheck(newGroup, nil)
			_lsu.Event.Raid.Member.Join(UnitObj, Spec)
			if UnitObj.Combat then
				LibSUnit.Raid.CombatTotal = LibSUnit.Raid.CombatTotal + 1
				if LibSUnit.Raid.CombatTotal == 1 then
					LibSUnit.Raid.Combat = true
					_lsu.Event.Raid.Combat.Enter()
				end
			end
			if UnitObj.Dead then
				LibSUnit.Raid.DeadTotal = LibSUnit.Raid.DeadTotal + 1
				-- print(UnitObj.Name.." joined and marked as Dead")
			end
			if LibSUnit.Raid.Members == LibSUnit.Raid.DeadTotal then
				if not LibSUnit.Raid.Wiped then
					LibSUnit.Raid.Wiped = true
					_lsu.Event.Raid.Wipe()
				end
			else
				if LibSUnit.Raid.Wiped then
					LibSUnit.Raid.Wiped = false
				end
			end
			if _lsu.Settings.Debug then
				_lsu.Debug:UpdateDeath()
				_lsu.Debug:UpdateCombat()
			end
		end
	end
	
	-- local Groups = 0
	-- for Group, Value in pairs(LibSUnit.Raid.Group) do
		-- if Value > 0 then
			-- Groups = Groups + 1
		-- end
	-- end
	-- if Groups > 1 then
		-- if LibSUnit.Raid.Mode ~= "raid" then
			-- LibSUnit.Raid.Mode = "raid"
			-- _lsu.Event.Raid.Mode()
		-- end
	-- else
		-- if LibSUnit.Raid.Mode ~= "party" then
			-- LibSUnit.Raid.Mode = "party"
			-- _lsu.Event.Raid.Mode()
		-- end
	-- end
	
	-- print("Total Changes found: "..totalchanges)
	-- print("Player Moved: "..movedCount)
	-- print("New Players: "..newCount)
	-- print("Players left: "..leftCount)
	-- print("--------------")
end

function _lsu.Raid.PetChange(UnitID, Spec)

end

-- Combat Handlers
function _lsu.Combat.stdHandler(UID, segPlus)
	if UID then
		local _cache = LibSUnit.Lookup.UID
		local UnitObj = _cache[UID]
		if UnitObj then
			if UnitObj.CurrentKey == "Idle" then
				_lsu.Unit:UpdateSegment(UnitObj, segPlus + _lastSeg, _inspect(UID))
			end
		else
			UnitObj = _lsu:Create(UID, _inspect(UID), "Idle")
			if UnitObj then
				_lsu.Unit:UpdateSegment(UnitObj, segPlus + _lastSeg)
			end
		end
		return UnitObj
	end
end

function _lsu.Combat.Damage(handle, info)
	local _stdHandler = _lsu.Combat.stdHandler
	local targetObj, sourceObj
	info.damage = info.damage or 0
	targetObj = _stdHandler(info.target, _idleSeg)
	sourceObj = _stdHandler(info.caster, _idleSeg)
	info.targetObj = targetObj
	info.sourceObj = sourceObj
	_lsu.Event.Combat.Damage(info)
end

function _lsu.Combat.Heal(handle, info)
	local _stdHandler = _lsu.Combat.stdHandler
	local targetObj, sourceObj
	info.heal = info.heal or 0
	targetObj = _stdHandler(info.target, _idleSeg)
	sourceObj = _stdHandler(info.caster, _idleSeg)
	info.targetObj = targetObj
	info.sourceObj = sourceObj
	if targetObj then
		if targetObj.Dead then
			_lsu.Raid.ManageDeath(targetObj, false, sourceObj)
		end
		_lsu.Event.Combat.Heal(info)
	end
end

function _lsu.Combat.Immune(handle, info)
	local _stdHandler = _lsu.Combat.stdHandler
	local targetObj, sourceObj
	targetObj = _stdHandler(info.target, _idleSeg)
	sourceObj = _stdHandler(info.caster, _idleSeg)
	info.targetObj = targetObj
	info.sourceObj = sourceObj
	_lsu.Event.Combat.Immune(info)
end

function _lsu.Combat.Death(handle, info)
	local _cache = LibSUnit.Lookup.UID
	local targetObj, sourceObj
	sourceObj = _lsu.Combat.stdHandler(info.caster, _idleSeg)
	info.sourceObj = sourceObj
	targetObj = _lsu.Combat.stdHandler(info.target, _deadSeg)
	info.targetObj = targetObj
	if targetObj then
		if not targetObj.Dead then
			_lsu.Raid.ManageDeath(targetObj, true, sourceObj)
		end
		_lsu.Event.Combat.Death(info)
	end
end

-- Base Functions
function _lsu:UpdateSegment(_tSeg)
	local _lookup = LibSUnit.Lookup
	local _cache = LibSUnit.Cache
	local _total = LibSUnit.Total

	if self.Segment[_tSeg] then
		local RemoveList = {}
		for UID, UnitObj in pairs(self.Segment[_tSeg]) do
			if UnitObj.Reserved then
				_lookup.UID[UID] = nil
				if UnitObj.Name then
					if _lookup.Name[UnitObj.Name] then
						_lookup.Name[UnitObj.Name][UID] = nil
						if not next(_lookup.Name[UnitObj.Name]) then
							_lookup.Name[UnitObj.Name] = nil
						end
					end
				end
				_cache.Idle[UID] = nil
				_total.Idle = _total.Idle - 1
				LibSUnit.Total.Reserved = LibSUnit.Total.Reserved - 1
				_lsu.Unit:UpdateTarget(UnitObj)
			else
				RemoveList[UID] = UnitObj
				_lsu.Unit:UpdateSegment(UnitObj, _reserveSeg + _lastSeg)
				UnitObj.Reserved = true
				LibSUnit.Total.Reserved = LibSUnit.Total.Reserved + 1
			end
		end
		self.Event.Unit.Removed(RemoveList)
	end
	self.Segment[_tSeg] = nil
	if self.Settings.Debug then
		self.Debug:UpdateAll()
	end
end

function _lsu.Tick()
	local _cTime = _timeReal()
	local _tSeg = math.floor(_cTime / _tSegThrottle)
		
	if _tSeg ~= _lastSeg then
		for iSeg = _lastSeg + 1, _tSeg do
			_lsu:UpdateSegment(iSeg)
		end
		_lastSeg = _tSeg
	end
	_lastTick = _cTime	
end

function _lsu.Wait(handle, uList)
	if uList[_lsu.PlayerID] then
		-- Initialize Player Data
		_lsu.Avail.Full(Event.Unit.Availability.Full, {[_lsu.PlayerID] = "player"})
		LibSUnit.Player = LibSUnit.Lookup.UID[_lsu.PlayerID]
		
		_lsu.Event.System.Start()
		
		-- Check current availability list.
		local uList = Inspect.Unit.List()
		_lsu.Avail.Full(Event.Unit.Availability.Full, uList)
		Command.Event.Detach(Event.Unit.Availability.Full, _lsu.Wait, "System Wait Start")
		
		-- Unit Management Events
		Command.Event.Attach(Event.Unit.Availability.Full, _lsu.Avail.Full, "Unit Availability Full Handler")
		Command.Event.Attach(Event.Unit.Availability.Partial, _lsu.Avail.Partial, "Unit Availability Partial Handler")
		Command.Event.Attach(Event.Unit.Availability.None, _lsu.Avail.None, "Unit Availability None Handler")

		-- Unit Data Change
		Command.Event.Attach(Event.Unit.Detail.Health, _lsu.Unit.Health, "Unit HP Change")
		Command.Event.Attach(Event.Unit.Detail.Name, _lsu.Unit.Name, "Unit Name Change")
		Command.Event.Attach(Event.Unit.Detail.Level, _lsu.Unit.Level, "Unit Level Change")
		Command.Event.Attach(Event.Unit.Detail.HealthMax, _lsu.Unit.HealthMax, "Unit HP Max Change")
		Command.Event.Attach(Event.Unit.Detail.Power, function (handle, List) _lsu.Unit.Power(handle, List, "power") end, "Power Change")
		Command.Event.Attach(Event.Unit.Detail.Energy, function (handle, List) _lsu.Unit.Power(handle, List, "energy") end, "Energy Change")
		Command.Event.Attach(Event.Unit.Detail.Mana, function (handle, List) _lsu.Unit.Power(handle, List, "mana") end, "Mana Change")
		Command.Event.Attach(Event.Unit.Detail.EnergyMax, function (handle, List) _lsu.Unit.PowerMax(handle, List, "energy") end, "Energy Max Change")
		Command.Event.Attach(Event.Unit.Detail.ManaMax, function (handle, List) _lsu.Unit.PowerMax(handle, List, "mana") end, "Mana Max Change")
		Command.Event.Attach(Event.Unit.Detail.Offline, _lsu.Unit.Offline, "Unit Offline state Change")
		Command.Event.Attach(Event.Unit.Detail.Combat, _lsu.Unit.Combat, "Unit Combat state Change")
		Command.Event.Attach(Event.Unit.Detail.Planar, _lsu.Unit.Planar, "Unit Planar Chanage")
		Command.Event.Attach(Event.Unit.Detail.PlanarMax, _lsu.Unit.PlanarMax, "Unit Planar Max Change")
		Command.Event.Attach(Event.Unit.Detail.Ready, _lsu.Unit.Ready, "Unit Ready State Change")
		Command.Event.Attach(Event.Unit.Detail.Vitality, _lsu.Unit.Vitality, "Unit Vitality Change")
		Command.Event.Attach(Event.Unit.Detail.Mark, _lsu.Unit.Mark, "Unit Mark Change")
		Command.Event.Attach(Event.Unit.Detail.Zone, _lsu.Unit.Zone, "Unit Zone Change")
		Command.Event.Attach(Event.Unit.Detail.LocationName, _lsu.Unit.Location, "Unit Location Change")
		Command.Event.Attach(Event.Unit.Detail.Role, _lsu.Unit.Role, "Unit Role Change")
		Command.Event.Attach(Event.Unit.Detail.Warfront, _lsu.Unit.Warfront, "Unit Warfront Change")
		
		-- Unit Combat Events
		Command.Event.Attach(Event.Combat.Damage, _lsu.Combat.Damage, "Unit Combat Damage")
		Command.Event.Attach(Event.Combat.Heal, _lsu.Combat.Heal, "Unit Combat Heal")
		Command.Event.Attach(Event.Combat.Immune, _lsu.Combat.Immune, "Unit Immune")
		Command.Event.Attach(Event.Combat.Death, _lsu.Combat.Death, "Unit Death")
	
		-- Register Events with LibUnitChange
		local EventTable
		local raidBuild = {}
		for Index, Spec in pairs(_SpecList) do
			if Spec ~= "player" then
				EventTable = Library.LibUnitChange.Register(Spec)
				Command.Event.Attach(EventTable, function (handle, data) _lsu.Raid.Check(data, Spec) end, Spec.." changed")
				EventTable = Library.LibUnitChange.Register(Spec..".pet")
				Command.Event.Attach(EventTable, function (handle, data) _lsu.Raid.PetChange(data, Spec) end, Spec.." pet changed")
				LibSUnit.Raid.Lookup[Spec] = {
					Group = math.ceil(Index / 5),
					Specifier = Spec,
					UID = false,
				}
				LibSUnit.Raid.Pets[Spec] = {
					Group = LibSUnit.Raid.Lookup[Spec].Group,
					Specifier = Spec..".pet",
					UID = false,
				}
				local UID = Inspect.Unit.Lookup(Spec)
				if UID then
					raidBuild[Spec] = UID
				end
			end
			EventTable = Library.LibUnitChange.Register(Spec..".pet.target")
			Command.Event.Attach(EventTable, function (handle, data) _lsu.Unit.Change(data, Spec..".pet") end, Spec.." pet target changed")
			EventTable = Library.LibUnitChange.Register(Spec..".pet.target.target")
			Command.Event.Attach(EventTable, function (handle, data) _lsu.Unit.Change(data, Spec..".pet.target") end, Spec.." pet targets target changed")
			EventTable = Library.LibUnitChange.Register(Spec..".target")
			Command.Event.Attach(EventTable, function (handle, data) _lsu.Unit.Change(data, Spec) end, Spec.." target changed")
			EventTable = Library.LibUnitChange.Register(Spec..".target.target")
			Command.Event.Attach(EventTable, function (handle, data) _lsu.Unit.Change(data, Spec..".target") end, Spec.." targets target changed")
		end
		for Spec, UID in pairs(raidBuild) do
			_lsu.Raid.Check(UID, Spec)
		end
	end
end

function _lsu.Start(handle, AddonId)
	if AddonId == AddonIni.id then
		_lsu.PlayerID = Inspect.Unit.Lookup("player")
		Command.Event.Attach(Event.Unit.Availability.Full, _lsu.Wait, "System Wait Start")
	end
end

function _lsu.SlashHandler(handle, cmd)
	cmd = string.lower(cmd or "")
	if cmd == "debug" then
		if _lsu.Settings.Debug then
			_lsu.Settings.Debug = false
			_lsu.Debug.GUI.Header:SetVisible(false)
		else
			_lsu.Settings.Debug = true
			_lsu.Debug.GUI.Header:SetVisible(true)
			_lsu.Debug:UpdateAll()
		end
	elseif cmd == "listidle" then
		for UnitID, UnitObj in pairs(LibSUnit.Cache.Idle) do
			print(UnitID..": "..UnitObj.Name.." - Seg: "..UnitObj.IdleSegment)
		end
		print("----")
		print("Current Segment: ".._lastSeg)
	end
end

-- Addon Specific Events
Command.Event.Attach(Event.Addon.Load.End, _lsu.Start, "Initialize all currently seen Units if any")
Command.Event.Attach(Event.Addon.SavedVariables.Load.End, _lsu.Load, "Load Vars")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, _lsu.Save, "Save Vars")

-- System Specific Events
Command.Event.Attach(Event.System.Update.Begin, _lsu.Tick, "Redraw start")
Command.Event.Attach(Command.Slash.Register("libsunit"), _lsu.SlashHandler, "LibSUnit Slash Command")

-- DEBUG STUFF
_lsu.Debug = {}
function _lsu.AttachDragFrame(parent, hook, name, layer)
	if not name then name = "" end
	if not layer then layer = 0 end
	
	local Drag = {}
	Drag.Frame = UI.CreateFrame("Frame", "Drag Frame", parent)
	Drag.Frame:SetPoint("TOPLEFT", parent, "TOPLEFT")
	Drag.Frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	Drag.Frame.parent = parent
	Drag.Frame.MouseDown = false
	Drag.Frame:SetLayer(layer)
	Drag.hook = hook
	Drag.Layer = parent:GetLayer()
	Drag.Parent = parent
	
	function Drag.Frame.Event:LeftDown()
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.MyStartX = self.parent:GetLeft()
		self.MyStartY = self.parent:GetTop()
		self.StartX = mouseData.x - self.MyStartX
		self.StartY = mouseData.y - self.MyStartY
		tempX = self.parent:GetLeft()
		tempY = self.parent:GetTop()
		tempW = self.parent:GetWidth()
		tempH =	self.parent:GetHeight()
		self.parent:ClearAll()
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", tempX, tempY)
		self.parent:SetWidth(tempW)
		self.parent:SetHeight(tempH)
		self:SetBackgroundColor(0,0,0,0.5)
		Drag.hook("start")
		Drag.Parent:SetLayer(10)
	end
	
	function Drag.Frame.Event:MouseMove(mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	
	function Drag.Frame.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			Drag.hook("end")
			Drag.Parent:SetLayer(Drag.Layer)
		end
	end
	
	function Drag.Frame:Remove()	
		self.Event.LeftDown = nil
		self.Event.MouseMove = nil
		self.Event.LeftUp = nil
		Drag.hook = nil
		self:sRemove()
		self.Remove = nil		
	end	
	return Drag.Frame
end

function _lsu.Debug:Init()
	self.Constant = {
		Width = 150,
		Height = 20,
		Text = 12,
	}
	self.Callbacks = {}
	function self.Callbacks.Position(Type)
		if Type == "end" then
			_lsu.Settings.Tracker.x = _lsu.Debug.GUI.Header:GetLeft()
			_lsu.Settings.Tracker.y = _lsu.Debug.GUI.Header:GetTop()
		end
	end
	self.GUI = {}
	self.GUI.Header = UI.CreateFrame("Texture", "Unit_Tracking_Debug_Header", _lsu.Context)
	self.GUI.Header:SetVisible(false)
	self.GUI.Header:SetWidth(self.Constant.Width)
	self.GUI.Header:SetHeight(self.Constant.Height)
	self.GUI.Header:SetBackgroundColor(0.5, 0, 0, 0.75)
	if not _lsu.Settings.Tracker.x then
		self.GUI.Header:SetPoint("CENTER", UIParent, "CENTER")
	else
		self.GUI.Header:SetPoint("TOPLEFT", UIParent, "TOPLEFT", _lsu.Settings.Tracker.x, _lsu.Settings.Tracker.y)
	end
	self.GUI.HeadText = UI.CreateFrame("Text", "Unit_Tracking_Debug_HText", self.GUI.Header)
	self.GUI.HeadText:SetFontSize(self.Constant.Text)
	self.GUI.HeadText:SetText("Unit Tracker")
	self.GUI.HeadText:SetPoint("CENTER", self.GUI.Header, "CENTER")
	self.GUI.DragFrame = _lsu.AttachDragFrame(self.GUI.Header, self.Callbacks.Position, "Drag", 5)
	self.GUI.Trackers = {}
	self.GUI.LastTracker = self.GUI.Header
	function self:CreateTrack(Name, R, G, B)
		local TrackObj = {
			GUI = {},
		}
		TrackObj.GUI.Frame = UI.CreateFrame("Frame", Name, self.GUI.Header)
		TrackObj.GUI.Frame:SetBackgroundColor(0,0,0,0.33)
		TrackObj.GUI.Frame:SetPoint("TOPLEFT", self.GUI.LastTracker, "BOTTOMLEFT")
		TrackObj.GUI.Frame:SetPoint("RIGHT", self.GUI.LastTracker, "RIGHT")
		TrackObj.GUI.Frame:SetHeight(self.Constant.Height)
		TrackObj.GUI.Text = UI.CreateFrame("Text", Name.."_Text", TrackObj.GUI.Frame)
		TrackObj.GUI.Text:SetText(Name)
		TrackObj.GUI.Text:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Text:SetPoint("CENTERLEFT", TrackObj.GUI.Frame, "CENTERLEFT", 2, 0)
		TrackObj.GUI.Data = UI.CreateFrame("Text", Name.."_Data", TrackObj.GUI.Frame)
		TrackObj.GUI.Data:SetText("0")
		TrackObj.GUI.Data:SetFontColor(R, G, B)
		TrackObj.GUI.Data:SetFontSize(self.Constant.Text)
		TrackObj.GUI.Data:SetPoint("CENTERRIGHT", TrackObj.GUI.Frame, "CENTERRIGHT", -2, 0)
		function TrackObj:UpdateDisplay(New)
			self.GUI.Data:SetText(tostring(New))
		end
		self.GUI.Trackers[Name] = TrackObj
		self.GUI.LastTracker = TrackObj.GUI.Frame
	end
	self:CreateTrack("Idle", 0.9, 0.5, 0.35)
	self:CreateTrack("Partial", 0.75, 0.75, 0.37)
	self:CreateTrack("Available", 0, 0.9, 0)
	self:CreateTrack("Total States", 1, 1, 1)
	self:CreateTrack("Reserved", 1, 0.7, 0.7)
	self:CreateTrack("Raid Size", 0, 0.9, 0)
	self:CreateTrack("Raid Mode", 0, 0.9, 0)
	self:CreateTrack("In Combat", 0, 0.9, 0)
	self:CreateTrack("Dead", 0, 0.9, 0)
	self:CreateTrack("Wiped", 0.9, 0.9, 0)
	function self:UpdateAll()
		self.GUI.Trackers["Idle"]:UpdateDisplay(LibSUnit.Total.Idle - LibSUnit.Total.Reserved)
		self.GUI.Trackers["Partial"]:UpdateDisplay(LibSUnit.Total.Partial)
		self.GUI.Trackers["Available"]:UpdateDisplay(LibSUnit.Total.Avail)		
		self.GUI.Trackers["Total States"]:UpdateDisplay(LibSUnit.Total.Idle + LibSUnit.Total.Partial + LibSUnit.Total.Avail - LibSUnit.Total.Reserved)
		self.GUI.Trackers["Reserved"]:UpdateDisplay(LibSUnit.Total.Reserved)
		self.GUI.Trackers["Raid Size"]:UpdateDisplay(tostring(LibSUnit.Raid.Members or 0))
		self:UpdateMode()
		self:UpdateCombat()
		self:UpdateDeath()
	end
	function self:UpdateCombat()
		self.GUI.Trackers["In Combat"]:UpdateDisplay(tostring(LibSUnit.Raid.CombatTotal or 0))	
	end
	function self:UpdateDeath()
		self.GUI.Trackers["Dead"]:UpdateDisplay(tostring(LibSUnit.Raid.DeadTotal or 0))
		self.GUI.Trackers["Wiped"]:UpdateDisplay(tostring(LibSUnit.Raid.Wiped))
	end
	function self:UpdateMode()
		self.GUI.Trackers["Raid Mode"]:UpdateDisplay(LibSUnit.Raid.Mode)
	end
end