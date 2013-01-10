-- Emphalea Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXAOFEMP_Settings = nil
chKBMSLEXAOFEMP_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EArchive_of_Flesh"]

local MOD = {
	Directory = Instance.Directory,
	File = "Emphalea.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Emphalea",
	Object = "MOD",
}

MOD.Emphalea = {
	Mod = MOD,
	Level = "59",
	Active = false,
	Name = "Emphalea",
	NameShort = "Emphalea",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFBED7D2C1778E164",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Emphalea = KBM.Language:Add(MOD.Emphalea.Name)
MOD.Lang.Unit.Emphalea:SetGerman()
MOD.Lang.Unit.Emphalea:SetFrench()
MOD.Emphalea.Name = MOD.Lang.Unit.Emphalea[KBM.Lang]
MOD.Descript = MOD.Emphalea.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Emphalea")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Emphalea.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Emphalea.Name] = self.Emphalea,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Emphalea.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Emphalea.Settings.TimersRef,
		-- AlertsRef = self.Emphalea.Settings.AlertsRef,
	}
	KBMSLEXAOFEMP_Settings = self.Settings
	chKBMSLEXAOFEMP_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXAOFEMP_Settings = self.Settings
		self.Settings = chKBMSLEXAOFEMP_Settings
	else
		chKBMSLEXAOFEMP_Settings = self.Settings
		self.Settings = KBMSLEXAOFEMP_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXAOFEMP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXAOFEMP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXAOFEMP_Settings = self.Settings
	else
		KBMSLEXAOFEMP_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXAOFEMP_Settings = self.Settings
	else
		KBMSLEXAOFEMP_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Emphalea.UnitID == UnitID then
		self.Emphalea.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Emphalea.UnitID == UnitID then
		self.Emphalea.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.UnitID = unitID
				BossObj.Dead = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Emphalea, 0, 100)
				self.Phase = 1
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Emphalea.Available = false
	self.Emphalea.UnitID = nil
	self.Emphalea.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Emphalea, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Emphalea)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Emphalea)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Emphalea.CastBar = KBM.CastBar:Add(self, self.Emphalea)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end