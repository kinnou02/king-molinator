-- Mithe Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRCPLA_Settings = nil
chKBMNTRCPLA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Rhaza'de_Canyons"]

local MOD = {
	Directory = Instance.Directory,
	File = "Mithe.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RC_Mithe",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Mithe = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Mithe Tethson",
	--NameShort = "Mithe",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0792F9C767180A9C",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Arhee = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = "Arhee",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U05FFD9D76BEF837F",
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	},
}

MOD.Brawlok = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = "Brawlok",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U41F2D16E5FFF834A",
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	},
}

MOD.Fwil = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = "Fwil",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U0EF322F82A42C96D",
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	},
}

MOD.Sepira = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = "Sepira",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U0836108C5C948053",
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Mithe = KBM.Language:Add(MOD.Mithe.Name)

-- Additional Unit Dictionary
MOD.Lang.Unit.Arhee = KBM.Language:Add(MOD.Arhee.Name)
MOD.Lang.Unit.Brawlok = KBM.Language:Add(MOD.Brawlok.Name)
MOD.Lang.Unit.Fwil = KBM.Language:Add(MOD.Fwil.Name)
MOD.Lang.Unit.Sepira = KBM.Language:Add(MOD.Sepira.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Bite = KBM.Language:Add("Bite")
MOD.Lang.Ability.Bite:SetFrench("Mordre")

-- Additional Unit Ability Dictionary
	-- Arhee
	
	-- Brawlok
	
	-- Fwil
	
	-- Sepira
	
	
MOD.Lang.Ability.Venom = KBM.Language:Add("Ascension Venom")
MOD.Lang.Ability.Roar = KBM.Language:Add("Earthshattering Roar")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Mithe[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Mithe.Name] = self.Mithe,
		[self.Brawlok.Name] = self.Brawlok,
		[self.Fwil.Name] = self.Fwil,
		[self.Sepira.Name] = self.Sepira,
		
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Mithe.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Mithe.Settings.TimersRef,
		-- AlertsRef = self.Mithe.Settings.AlertsRef,
	}
	KBMNTRCPLA_Settings = self.Settings
	chKBMNTRCPLA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRCPLA_Settings = self.Settings
		self.Settings = chKBMNTRCPLA_Settings
	else
		chKBMNTRCPLA_Settings = self.Settings
		self.Settings = KBMNTRCPLA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRCPLA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRCPLA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRCPLA_Settings = self.Settings
	else
		KBMNTRCPLA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRCPLA_Settings = self.Settings
	else
		KBMNTRCPLA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Mithe.UnitID == UnitID then
		self.Mithe.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Mithe.UnitID == UnitID then
		self.Mithe.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Mithe.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Mithe.Dead = false
				self.Mithe.Casting = false
				self.Mithe.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Mithe.Name, 0, 100)
				self.Phase = 1
			end
			self.Mithe.UnitID = unitID
			self.Mithe.Available = true
			return self.Mithe
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Mithe.Available = false
	self.Mithe.UnitID = nil
	self.Mithe.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Mithe)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Mithe)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Mithe.CastBar = KBM.Castbar:Add(self, self.Mithe)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end