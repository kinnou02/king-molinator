-- General Thunderscar Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXTOSGTS_Settings = nil
chKBMSLEXTOSGTS_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["ETower_of_the_Shattered"]

local MOD = {
	Directory = Instance.Directory,
	File = "Thunderscar.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Thunderscar",
	Object = "MOD",
}

MOD.Thunderscar = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "General Thunderscar",
	NameShort = "Thunderscar",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFEB8F4684E17ED4D",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Thunderscar = KBM.Language:Add(MOD.Thunderscar.Name)
MOD.Lang.Unit.Thunderscar:SetGerman("General Donnernarbe")
MOD.Lang.Unit.Thunderscar:SetFrench("général Cicatonnerre")
MOD.Thunderscar.Name = MOD.Lang.Unit.Thunderscar[KBM.Lang]
MOD.Descript = MOD.Thunderscar.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Thunderscar")
MOD.Lang.Unit.AndShort:SetGerman("Donnernarbe")
MOD.Lang.Unit.AndShort:SetFrench("Cicatonnerre")
MOD.Thunderscar.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Thunderscar.Name] = self.Thunderscar,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Thunderscar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Thunderscar.Settings.TimersRef,
		-- AlertsRef = self.Thunderscar.Settings.AlertsRef,
	}
	KBMSLEXTOSGTS_Settings = self.Settings
	chKBMSLEXTOSGTS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXTOSGTS_Settings = self.Settings
		self.Settings = chKBMSLEXTOSGTS_Settings
	else
		chKBMSLEXTOSGTS_Settings = self.Settings
		self.Settings = KBMSLEXTOSGTS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXTOSGTS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXTOSGTS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXTOSGTS_Settings = self.Settings
	else
		KBMSLEXTOSGTS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXTOSGTS_Settings = self.Settings
	else
		KBMSLEXTOSGTS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Thunderscar.UnitID == UnitID then
		self.Thunderscar.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Thunderscar.UnitID == UnitID then
		self.Thunderscar.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Thunderscar.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Thunderscar.Dead = false
				self.Thunderscar.Casting = false
				self.Thunderscar.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Thunderscar.Name, 0, 100)
				self.Phase = 1
			end
			self.Thunderscar.UnitID = unitID
			self.Thunderscar.Available = true
			return self.Thunderscar
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Thunderscar.Available = false
	self.Thunderscar.UnitID = nil
	self.Thunderscar.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Thunderscar, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Thunderscar)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Thunderscar)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Thunderscar.CastBar = KBM.CastBar:Add(self, self.Thunderscar)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end