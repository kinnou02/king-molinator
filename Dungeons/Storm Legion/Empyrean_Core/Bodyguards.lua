-- Kaliban's Bodyguards Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMECKBB_Settings = nil
chKBMSLNMECKBB_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Empyrean Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Bodyguards.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Bodyguards",
	Object = "MOD",
}

MOD.Bodyguards = {
	Mod = MOD,
	Level = "60",
	Active = false,
	Name = "Kaliban's Bodyguards",
	NameShort = "Kalibans",
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
MOD.Lang.Unit.Bodyguards = KBM.Language:Add(MOD.Bodyguards.Name)
MOD.Lang.Unit.Bodyguards:SetGerman("Kalibans Leibwachen")
MOD.Bodyguards.Name = MOD.Lang.Unit.Bodyguards[KBM.Lang]
MOD.Lang.Unit.AndShort = KBM.Language:Add("Bodyguards")
MOD.Lang.Unit.AndShort:SetGerman("Leibwachen")
MOD.Bodyguards.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Description
MOD.Lang.Main = {}
MOD.Lang.Main.Descript = KBM.Language:Add("Kaliban's Bodyguards")
MOD.Descript = MOD.Lang.Main.Descript[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Bodyguards.Name] = self.Bodyguards,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Bodyguards.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Bodyguards.Settings.TimersRef,
		-- AlertsRef = self.Bodyguards.Settings.AlertsRef,
	}
	KBMSLNMECKBB_Settings = self.Settings
	chKBMSLNMECKBB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMECKBB_Settings = self.Settings
		self.Settings = chKBMSLNMECKBB_Settings
	else
		chKBMSLNMECKBB_Settings = self.Settings
		self.Settings = KBMSLNMECKBB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMECKBB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMECKBB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMECKBB_Settings = self.Settings
	else
		KBMSLNMECKBB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMECKBB_Settings = self.Settings
	else
		KBMSLNMECKBB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Bodyguards.UnitID == UnitID then
		self.Bodyguards.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Bodyguards.UnitID == UnitID then
		self.Bodyguards.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Bodyguards.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Bodyguards.Dead = false
					self.Bodyguards.Casting = false
					self.Bodyguards.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Bodyguards.Name, 0, 100)
					self.Phase = 1
				end
				self.Bodyguards.UnitID = unitID
				self.Bodyguards.Available = true
				return self.Bodyguards
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Bodyguards.Available = false
	self.Bodyguards.UnitID = nil
	self.Bodyguards.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Bodyguards, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Bodyguards)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Bodyguards)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Bodyguards.CastBar = KBM.CastBar:Add(self, self.Bodyguards)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end