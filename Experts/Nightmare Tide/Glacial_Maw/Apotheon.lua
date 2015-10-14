-- Apotheon Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTGMAPO_Settings = nil
chKBMNTGMAPO_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Glacial_Maw"]

local MOD = {
	Directory = Instance.Directory,
	File = "Apotheon.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "GM_Apotheon",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Apotheon = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Apotheon",
	--NameShort = "Apotheon",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U343BA11702EFF0D2",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Apotheon = KBM.Language:Add(MOD.Apotheon.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Notify Dictionary
MOD.Lang.Notify = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Apotheon[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Apotheon.Name] = self.Apotheon,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Apotheon.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		-- AlertsRef = self.Baird.Settings.AlertsRef,
	}
	KBMNTGMAPO_Settings = self.Settings
	chKBMNTGMAPO_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTGMAPO_Settings = self.Settings
		self.Settings = chKBMNTGMAPO_Settings
	else
		chKBMNTGMAPO_Settings = self.Settings
		self.Settings = KBMNTGMAPO_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTGMAPO_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTGMAPO_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTGMAPO_Settings = self.Settings
	else
		KBMNTGMAPO_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTGMAPO_Settings = self.Settings
	else
		KBMNTGMAPO_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Apotheon.UnitID == UnitID then
		self.Apotheon.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Apotheon.UnitID == UnitID then
		self.Apotheon.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Apotheon.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Apotheon.Dead = false
				self.Apotheon.Casting = false
				self.Apotheon.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Apotheon.Name, 0, 100)
				self.Phase = 1
			end
			self.Apotheon.UnitID = unitID
			self.Apotheon.Available = true
			return self.Apotheon
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Apotheon.Available = false
	self.Apotheon.UnitID = nil
	self.Apotheon.CastBar:Remove()
		
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
	
	self.Apotheon.CastBar = KBM.Castbar:Add(self, self.Apotheon)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end