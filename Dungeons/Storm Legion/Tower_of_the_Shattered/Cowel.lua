-- Overseer Cowel Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMTOSOSC_Settings = nil
chKBMSLNMTOSOSC_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Tower of the Shattered"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cowel.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Cowel",
	Object = "MOD",
}

MOD.Cowel = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Overseer Cowel",
	NameShort = "Cowel",
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
MOD.Lang.Unit.Cowel = KBM.Language:Add(MOD.Cowel.Name)
MOD.Lang.Unit.Cowel:SetGerman("Aufseher Cowel")
MOD.Cowel.Name = MOD.Lang.Unit.Cowel[KBM.Lang]
MOD.Descript = MOD.Cowel.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Cowel")
MOD.Lang.Unit.AndShort:SetGerman("Cowel")
MOD.Cowel.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cowel.Name] = self.Cowel,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cowel.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cowel.Settings.TimersRef,
		-- AlertsRef = self.Cowel.Settings.AlertsRef,
	}
	KBMSLNMTOSOSC_Settings = self.Settings
	chKBMSLNMTOSOSC_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMTOSOSC_Settings = self.Settings
		self.Settings = chKBMSLNMTOSOSC_Settings
	else
		chKBMSLNMTOSOSC_Settings = self.Settings
		self.Settings = KBMSLNMTOSOSC_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMTOSOSC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMTOSOSC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMTOSOSC_Settings = self.Settings
	else
		KBMSLNMTOSOSC_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMTOSOSC_Settings = self.Settings
	else
		KBMSLNMTOSOSC_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cowel.UnitID == UnitID then
		self.Cowel.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cowel.UnitID == UnitID then
		self.Cowel.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Cowel.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Cowel.Dead = false
					self.Cowel.Casting = false
					self.Cowel.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Cowel.Name, 0, 100)
					self.Phase = 1
				end
				self.Cowel.UnitID = unitID
				self.Cowel.Available = true
				return self.Cowel
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cowel.Available = false
	self.Cowel.UnitID = nil
	self.Cowel.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Cowel, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Cowel)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Cowel)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cowel.CastBar = KBM.CastBar:Add(self, self.Cowel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end