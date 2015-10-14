-- Placeholder Boss Mod for King Boss Mods
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
	File = "Placeholder.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RC_Placeholder",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Placeholder = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Placeholder",
	--NameShort = "Placeholder",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Placeholder = KBM.Language:Add(MOD.Placeholder.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Placeholder[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Placeholder.Name] = self.Placeholder,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Placeholder.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		-- AlertsRef = self.Baird.Settings.AlertsRef,
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
	if self.Placeholder.UnitID == UnitID then
		self.Placeholder.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Placeholder.UnitID == UnitID then
		self.Placeholder.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Placeholder.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Placeholder.Dead = false
				self.Placeholder.Casting = false
				self.Placeholder.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Placeholder.Name, 0, 100)
				self.Phase = 1
			end
			self.Placeholder.UnitID = unitID
			self.Placeholder.Available = true
			return self.Placeholder
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Placeholder.Available = false
	self.Placeholder.UnitID = nil
	self.Placeholder.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Baird)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Placeholder.CastBar = KBM.Castbar:Add(self, self.Placeholder)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end