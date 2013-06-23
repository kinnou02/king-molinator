-- Prince Kaliban Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXECKB_Settings = nil
chKBMSLEXECKB_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EEmpyrean_Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kaliban.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Kaliban",
	Object = "MOD",
}

MOD.Kaliban = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Prince Kaliban",
	NameShort = "Kaliban",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFA52F2A775BE6FC6",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Kaliban = KBM.Language:Add(MOD.Kaliban.Name)
MOD.Lang.Unit.Kaliban:SetGerman("Prinz Kaliban")
MOD.Lang.Unit.Kaliban:SetFrench("prince Kaliban")
MOD.Kaliban.Name = MOD.Lang.Unit.Kaliban[KBM.Lang]
MOD.Descript = MOD.Kaliban.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Kaliban")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Kaliban.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kaliban.Name] = self.Kaliban,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kaliban.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Kaliban.Settings.TimersRef,
		-- AlertsRef = self.Kaliban.Settings.AlertsRef,
	}
	KBMSLEXECKB_Settings = self.Settings
	chKBMSLEXECKB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXECKB_Settings = self.Settings
		self.Settings = chKBMSLEXECKB_Settings
	else
		chKBMSLEXECKB_Settings = self.Settings
		self.Settings = KBMSLEXECKB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXECKB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXECKB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXECKB_Settings = self.Settings
	else
		KBMSLEXECKB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXECKB_Settings = self.Settings
	else
		KBMSLEXECKB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kaliban.UnitID == UnitID then
		self.Kaliban.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Kaliban.UnitID == UnitID then
		self.Kaliban.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Kaliban.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Kaliban.Dead = false
				self.Kaliban.Casting = false
				self.Kaliban.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Kaliban.Name, 0, 100)
				self.Phase = 1
			end
			self.Kaliban.UnitID = unitID
			self.Kaliban.Available = true
			return self.Kaliban
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Kaliban.Available = false
	self.Kaliban.UnitID = nil
	self.Kaliban.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Kaliban)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Kaliban)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Kaliban.CastBar = KBM.CastBar:Add(self, self.Kaliban)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end