-- Baron Slagstorm Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMSBPBSS_Settings = nil
chKBMSLNMSBPBSS_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Storm Breaker Protocol"]

local MOD = {
	Directory = Instance.Directory,
	File = "Slagstorm.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Slagstorm",
	Object = "MOD",
}

MOD.Slagstorm = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Baron Slagstorm",
	NameShort = "Slagstorm",
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
MOD.Lang.Unit.Slagstorm = KBM.Language:Add(MOD.Slagstorm.Name)
MOD.Lang.Unit.Slagstorm:SetGerman("Baron Schlackensturm")
MOD.Lang.Unit.Slagstorm:SetFrench("Baron Volescories")
MOD.Slagstorm.Name = MOD.Lang.Unit.Slagstorm[KBM.Lang]
MOD.Descript = MOD.Slagstorm.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Slagstorm")
MOD.Lang.Unit.AndShort:SetGerman("Schlackensturm")
MOD.Lang.Unit.AndShort:SetFrench("Volescories")
MOD.Slagstorm.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Slagstorm.Name] = self.Slagstorm,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Slagstorm.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Slagstorm.Settings.TimersRef,
		-- AlertsRef = self.Slagstorm.Settings.AlertsRef,
	}
	KBMSLNMSBPBSS_Settings = self.Settings
	chKBMSLNMSBPBSS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMSBPBSS_Settings = self.Settings
		self.Settings = chKBMSLNMSBPBSS_Settings
	else
		chKBMSLNMSBPBSS_Settings = self.Settings
		self.Settings = KBMSLNMSBPBSS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMSBPBSS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMSBPBSS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMSBPBSS_Settings = self.Settings
	else
		KBMSLNMSBPBSS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMSBPBSS_Settings = self.Settings
	else
		KBMSLNMSBPBSS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Slagstorm.UnitID == UnitID then
		self.Slagstorm.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Slagstorm.UnitID == UnitID then
		self.Slagstorm.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Slagstorm.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Slagstorm.Dead = false
					self.Slagstorm.Casting = false
					self.Slagstorm.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Slagstorm.Name, 0, 100)
					self.Phase = 1
				end
				self.Slagstorm.UnitID = unitID
				self.Slagstorm.Available = true
				return self.Slagstorm
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Slagstorm.Available = false
	self.Slagstorm.UnitID = nil
	self.Slagstorm.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Slagstorm)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Slagstorm)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Slagstorm.CastBar = KBM.Castbar:Add(self, self.Slagstorm)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end