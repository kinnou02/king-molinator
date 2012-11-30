-- C1-0N3 Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMGFC1_Settings = nil
chKBMSLNMGFC1_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Golem Foundry"]

local MOD = {
	Directory = Instance.Directory,
	File = "C10N3.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_C10N3",
	Object = "MOD",
}

MOD.C10N3 = {
	Mod = MOD,
	Level = "57",
	Active = false,
	Name = "C1-0N3",
	NameShort = "C1-0N3",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFB10B04610D6EDD5",
	-- Other Clones
	-- A - UFBC947FA216CCDB6
	-- B - UFFACB3E76933F1D0
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.C10N3 = KBM.Language:Add(MOD.C10N3.Name)
MOD.Lang.Unit.C10N3:SetGerman()
MOD.Lang.Unit.C10N3:SetFrench()
MOD.C10N3.Name = MOD.Lang.Unit.C10N3[KBM.Lang]
MOD.Descript = MOD.C10N3.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("C1-0N3")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.C10N3.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.C10N3.Name] = self.C10N3,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.C10N3.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.C10N3.Settings.TimersRef,
		-- AlertsRef = self.C10N3.Settings.AlertsRef,
	}
	KBMSLNMGFC1_Settings = self.Settings
	chKBMSLNMGFC1_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMGFC1_Settings = self.Settings
		self.Settings = chKBMSLNMGFC1_Settings
	else
		chKBMSLNMGFC1_Settings = self.Settings
		self.Settings = KBMSLNMGFC1_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMGFC1_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMGFC1_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMGFC1_Settings = self.Settings
	else
		KBMSLNMGFC1_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMGFC1_Settings = self.Settings
	else
		KBMSLNMGFC1_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.C10N3.UnitID == UnitID then
		self.C10N3.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.C10N3.UnitID == UnitID then
		self.C10N3.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.C10N3.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.C10N3.Dead = false
					self.C10N3.Casting = false
					self.C10N3.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.C10N3.Name, 0, 100)
					self.Phase = 1
				end
				self.C10N3.UnitID = unitID
				self.C10N3.Available = true
				return self.C10N3
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.C10N3.Available = false
	self.C10N3.UnitID = nil
	self.C10N3.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.C10N3, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.C10N3)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.C10N3)
	
	-- Assign Alerts and Timers to Triggers
	
	self.C10N3.CastBar = KBM.CastBar:Add(self, self.C10N3)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end