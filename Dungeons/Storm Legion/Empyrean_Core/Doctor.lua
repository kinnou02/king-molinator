-- Mad Doctor Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMECMD_Settings = nil
chKBMSLNMECMD_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Empyrean Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Doctor.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Doctor",
	Object = "MOD",
}

MOD.Doctor = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Doctor Perfidus",
	NameShort = "Doctor",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFBC2A94D3E395C7F",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Doctor = KBM.Language:Add(MOD.Doctor.Name)
MOD.Lang.Unit.Doctor:SetGerman("Doktor Perfidus")
MOD.Lang.Unit.Doctor:SetFrench("Docteur fou")
MOD.Doctor.Name = MOD.Lang.Unit.Doctor[KBM.Lang]
MOD.Descript = MOD.Doctor.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Doctor")
MOD.Lang.Unit.AndShort:SetGerman("Doktor")
MOD.Lang.Unit.AndShort:SetFrench("Docteur")
MOD.Doctor.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Doctor.Name] = self.Doctor,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Doctor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Doctor.Settings.TimersRef,
		-- AlertsRef = self.Doctor.Settings.AlertsRef,
	}
	KBMSLNMECMD_Settings = self.Settings
	chKBMSLNMECMD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMECMD_Settings = self.Settings
		self.Settings = chKBMSLNMECMD_Settings
	else
		chKBMSLNMECMD_Settings = self.Settings
		self.Settings = KBMSLNMECMD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMECMD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMECMD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMECMD_Settings = self.Settings
	else
		KBMSLNMECMD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMECMD_Settings = self.Settings
	else
		KBMSLNMECMD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Doctor.UnitID == UnitID then
		self.Doctor.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Doctor.UnitID == UnitID then
		self.Doctor.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Doctor.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Doctor.Dead = false
					self.Doctor.Casting = false
					self.Doctor.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Doctor.Name, 0, 100)
					self.Phase = 1
				end
				self.Doctor.UnitID = unitID
				self.Doctor.Available = true
				return self.Doctor
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Doctor.Available = false
	self.Doctor.UnitID = nil
	self.Doctor.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Doctor)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Doctor)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Doctor.CastBar = KBM.CastBar:Add(self, self.Doctor)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end