-- Ahgnox Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBFAHG_Settings = nil
chKBMSLNMUBFAHG_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Unhallowed Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ahgnox.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Ahgnox",
	Object = "MOD",
}

MOD.Ahgnox = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Ahgnox",
	NameShort = "Ahgnox",
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
MOD.Lang.Unit.Ahgnox = KBM.Language:Add(MOD.Ahgnox.Name)
MOD.Lang.Unit.Ahgnox:SetGerman()
MOD.Ahgnox.Name = MOD.Lang.Unit.Ahgnox[KBM.Lang]
MOD.Descript = MOD.Ahgnox.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Ahgnox")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Ahgnox.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ahgnox.Name] = self.Ahgnox,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ahgnox.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ahgnox.Settings.TimersRef,
		-- AlertsRef = self.Ahgnox.Settings.AlertsRef,
	}
	KBMSLNMUBFAHG_Settings = self.Settings
	chKBMSLNMUBFAHG_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMUBFAHG_Settings = self.Settings
		self.Settings = chKBMSLNMUBFAHG_Settings
	else
		chKBMSLNMUBFAHG_Settings = self.Settings
		self.Settings = KBMSLNMUBFAHG_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMUBFAHG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMUBFAHG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMUBFAHG_Settings = self.Settings
	else
		KBMSLNMUBFAHG_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMUBFAHG_Settings = self.Settings
	else
		KBMSLNMUBFAHG_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ahgnox.UnitID == UnitID then
		self.Ahgnox.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ahgnox.UnitID == UnitID then
		self.Ahgnox.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ahgnox.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ahgnox.Dead = false
					self.Ahgnox.Casting = false
					self.Ahgnox.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ahgnox.Name, 0, 100)
					self.Phase = 1
				end
				self.Ahgnox.UnitID = unitID
				self.Ahgnox.Available = true
				return self.Ahgnox
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ahgnox.Available = false
	self.Ahgnox.UnitID = nil
	self.Ahgnox.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Ahgnox, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ahgnox)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ahgnox)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ahgnox.CastBar = KBM.CastBar:Add(self, self.Ahgnox)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end