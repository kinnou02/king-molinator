-- Cahail Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMAOFCHL_Settings = nil
chKBMSLNMAOFCHL_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Archive of Flesh"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cahail.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Cahail",
	Object = "MOD",
}

MOD.Cahail = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Animator Cahail",
	NameShort = "Cahail",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFE09FEC82A456DB5",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Cahail = KBM.Language:Add(MOD.Cahail.Name)
MOD.Lang.Unit.Cahail:SetGerman()
MOD.Cahail.Name = MOD.Lang.Unit.Cahail[KBM.Lang]
MOD.Descript = MOD.Cahail.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Cahail")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Cahail.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cahail.Name] = self.Cahail,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cahail.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cahail.Settings.TimersRef,
		-- AlertsRef = self.Cahail.Settings.AlertsRef,
	}
	KBMSLNMAOFCHL_Settings = self.Settings
	chKBMSLNMAOFCHL_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMAOFCHL_Settings = self.Settings
		self.Settings = chKBMSLNMAOFCHL_Settings
	else
		chKBMSLNMAOFCHL_Settings = self.Settings
		self.Settings = KBMSLNMAOFCHL_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMAOFCHL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMAOFCHL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMAOFCHL_Settings = self.Settings
	else
		KBMSLNMAOFCHL_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMAOFCHL_Settings = self.Settings
	else
		KBMSLNMAOFCHL_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cahail.UnitID == UnitID then
		self.Cahail.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cahail.UnitID == UnitID then
		self.Cahail.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Cahail.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Cahail.Dead = false
					self.Cahail.Casting = false
					self.Cahail.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Cahail.Name, 0, 100)
					self.Phase = 1
				end
				self.Cahail.UnitID = unitID
				self.Cahail.Available = true
				return self.Cahail
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cahail.Available = false
	self.Cahail.UnitID = nil
	self.Cahail.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Cahail, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Cahail)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Cahail)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cahail.CastBar = KBM.CastBar:Add(self, self.Cahail)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end