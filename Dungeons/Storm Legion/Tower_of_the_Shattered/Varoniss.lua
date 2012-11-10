-- Commissar Varoniss Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMTOSCVS_Settings = nil
chKBMSLNMTOSCVS_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Tower of the Shattered"]

local MOD = {
	Directory = Instance.Directory,
	File = "Varoniss.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Varoniss",
	Object = "MOD",
}

MOD.Varoniss = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Commissar Varoniss",
	NameShort = "Varoniss",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Varoniss = KBM.Language:Add(MOD.Varoniss.Name)
MOD.Lang.Unit.Varoniss:SetGerman("Kommissarin Varoniss")
MOD.Varoniss.Name = MOD.Lang.Unit.Varoniss[KBM.Lang]
MOD.Descript = MOD.Varoniss.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Varoniss")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Varoniss.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Varoniss.Name] = self.Varoniss,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Varoniss.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Varoniss.Settings.TimersRef,
		-- AlertsRef = self.Varoniss.Settings.AlertsRef,
	}
	KBMSLNMTOSCVS_Settings = self.Settings
	chKBMSLNMTOSCVS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMTOSCVS_Settings = self.Settings
		self.Settings = chKBMSLNMTOSCVS_Settings
	else
		chKBMSLNMTOSCVS_Settings = self.Settings
		self.Settings = KBMSLNMTOSCVS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMTOSCVS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMTOSCVS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMTOSCVS_Settings = self.Settings
	else
		KBMSLNMTOSCVS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMTOSCVS_Settings = self.Settings
	else
		KBMSLNMTOSCVS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Varoniss.UnitID == UnitID then
		self.Varoniss.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Varoniss.UnitID == UnitID then
		self.Varoniss.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Varoniss.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Varoniss.Dead = false
					self.Varoniss.Casting = false
					self.Varoniss.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Varoniss.Name, 0, 100)
					self.Phase = 1
				end
				self.Varoniss.UnitID = unitID
				self.Varoniss.Available = true
				return self.Varoniss
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Varoniss.Available = false
	self.Varoniss.UnitID = nil
	self.Varoniss.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Varoniss, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Varoniss)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Varoniss)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Varoniss.CastBar = KBM.CastBar:Add(self, self.Varoniss)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end