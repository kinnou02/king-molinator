-- Core Meltdown Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMECCM_Settings = nil
chKBMSLNMECCM_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Empyrean Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Core.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Core",
	Object = "MOD",
}

MOD.Core = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Irradiated Monster",
	NameShort = "Monster",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
	Multi = true,
	UnitList = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Core = KBM.Language:Add(MOD.Core.Name)
MOD.Core.Name = MOD.Lang.Unit.Core[KBM.Lang]
MOD.Descript = MOD.Core.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Monster")
MOD.Core.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Say Dictionary
MOD.Lang.Say = {}
MOD.Lang.Say.Victory = KBM.Language:Add("Core instability within acceptable limits... Aborting lockdown sequences.")

-- Main Dictionary
MOD.Lang.Main = {}
MOD.Lang.Main.Descript = KBM.Language:Add("Core Meltdown")
MOD.Lang.Main.Descript:SetGerman("Kernschmelze")

MOD.Descript = MOD.Lang.Main.Descript[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Core.Name] = self.Core,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Core.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Core.Settings.TimersRef,
		-- AlertsRef = self.Core.Settings.AlertsRef,
	}
	KBMSLNMECCM_Settings = self.Settings
	chKBMSLNMECCM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMECCM_Settings = self.Settings
		self.Settings = chKBMSLNMECCM_Settings
	else
		chKBMSLNMECCM_Settings = self.Settings
		self.Settings = KBMSLNMECCM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMECCM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMECCM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMECCM_Settings = self.Settings
	else
		KBMSLNMECCM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMECCM_Settings = self.Settings
	else
		KBMSLNMECCM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Core.UnitID == UnitID then
		self.Core.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Core.UnitID == UnitID then
		self.Core.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.name == self.Core.Name then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Core.Dead = false
				self.Core.Casting = false
				self.Core.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddDeath(self.Core.Name, 3) -- will be changing this possibly
				self.Phase = 1
			end
			if not self.Core.UnitList[unitID] then
				local SubBossObj = {
					Mod = MOD,
					Level = "60",
					Active = true,
					Name = "Irradiated Monster",
					NameShort = "Monster",
					Menu = {},
					Dead = false,
					Available = true,
					UnitID = unitID,
					UTID = "none",
				}
				self.Core.UnitList[unitID] = SubBossObj
			end
			return self.Core.UnitList[unitID]
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Core.Available = false
	self.Core.UnitID = nil
	self.Core.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Core, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Core)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Core)
	
	-- Assign Alerts and Timers to Triggers
	self.Core.Triggers.Victory = KBM.Trigger:Create(self.Lang.Say.Victory[KBM.Lang], "say", self.Core)
	self.Core.Triggers.Victory:SetVictory()
	
	self.Core.CastBar = KBM.CastBar:Add(self, self.Core)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end