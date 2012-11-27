-- Matriarch of Pestilence Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEMP_Settings = nil
chKBMSLRDEEMP_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local MOP = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Matriarch.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "RMatriarch_of_Pestilence",
	Object = "MOP",
}

KBM.RegisterMod(MOP.ID, MOP)

-- Main Unit Dictionary
MOP.Lang.Unit = {}
MOP.Lang.Unit.Matriarch = KBM.Language:Add("Matriarch of Pestilence")
MOP.Lang.Unit.Matriarch:SetGerman("Matriarchin der Pestilenz")
MOP.Lang.Unit.MatriarchShort = KBM.Language:Add("Matriarch")
MOP.Lang.Unit.MatriarchShort:SetGerman("Matriarchin")

-- Ability Dictionary
MOP.Lang.Ability = {}

-- Description Dictionary
MOP.Lang.Main = {}

MOP.Descript = MOP.Lang.Unit.Matriarch[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
MOP.Matriarch = {
	Mod = MOP,
	Level = "??",
	Active = false,
	Name = MOP.Lang.Unit.Matriarch[KBM.Lang],
	NameShort = MOP.Lang.Unit.MatriarchShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

function MOP:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Matriarch.Name] = self.Matriarch,
	}
end

function MOP:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Matriarch.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Matriarch.Settings.TimersRef,
		-- AlertsRef = self.Matriarch.Settings.AlertsRef,
	}
	KBMSLRDEEMP_Settings = self.Settings
	chKBMSLRDEEMP_Settings = self.Settings
	
end

function MOP:SwapSettings(bool)

	if bool then
		KBMSLRDEEMP_Settings = self.Settings
		self.Settings = chKBMSLRDEEMP_Settings
	else
		chKBMSLRDEEMP_Settings = self.Settings
		self.Settings = KBMSLRDEEMP_Settings
	end

end

function MOP:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEMP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEMP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEMP_Settings = self.Settings
	else
		KBMSLRDEEMP_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function MOP:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEMP_Settings = self.Settings
	else
		KBMSLRDEEMP_Settings = self.Settings
	end	
end

function MOP:Castbar(units)
end

function MOP:RemoveUnits(UnitID)
	if self.Matriarch.UnitID == UnitID then
		self.Matriarch.Available = false
		return true
	end
	return false
end

function MOP:Death(UnitID)
	if self.Matriarch.UnitID == UnitID then
		self.Matriarch.Dead = true
		return true
	end
	return false
end

function MOP:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Matriarch.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Matriarch.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Matriarch.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Matriarch
			end
		end
	end
end

function MOP:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Matriarch.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOP:Timer()	
end

function MOP:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Matriarch, self.Enabled)
end

function MOP:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Matriarch)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Matriarch)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Matriarch.CastBar = KBM.CastBar:Add(self, self.Matriarch)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end