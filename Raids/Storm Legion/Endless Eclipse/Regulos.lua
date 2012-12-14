-- Regulos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEERS_Settings = nil
chKBMSLRDEERS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local REG = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Regulos.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "Regulos",
	Object = "REG",
}

REG.Regulos = {
	Mod = REG,
	Level = "??",
	Active = false,
	Name = "Regulos",
	NameShort = "Regulos",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	UTID = "none",
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

KBM.RegisterMod(REG.ID, REG)

-- Main Unit Dictionary
REG.Lang.Unit = {}
REG.Lang.Unit.Regulos = KBM.Language:Add("Regulos")
REG.Lang.Unit.Regulos:SetGerman("Regulos")
REG.Lang.Unit.RegulosShort = KBM.Language:Add("Regulos")
REG.Lang.Unit.RegulosShort:SetGerman("Regulos")

-- Ability Dictionary
REG.Lang.Ability = {}

-- Description Dictionary
REG.Lang.Main = {}
REG.Lang.Main.Descript = KBM.Language:Add("Regulos")
REG.Lang.Main.Descript:SetGerman("Schreckensfürst Regulos")
REG.Descript = REG.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
REG.Regulos.Name = REG.Lang.Unit.Regulos[KBM.Lang]
REG.Regulos.NameShort = REG.Lang.Unit.RegulosShort[KBM.Lang]

function REG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Regulos.Name] = self.Regulos,
	}
end

function REG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Regulos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Regulos.Settings.TimersRef,
		-- AlertsRef = self.Regulos.Settings.AlertsRef,
	}
	KBMSLRDEERS_Settings = self.Settings
	chKBMSLRDEERS_Settings = self.Settings
	
end

function REG:SwapSettings(bool)

	if bool then
		KBMSLRDEERS_Settings = self.Settings
		self.Settings = chKBMSLRDEERS_Settings
	else
		chKBMSLRDEERS_Settings = self.Settings
		self.Settings = KBMSLRDEERS_Settings
	end

end

function REG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEERS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEERS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEERS_Settings = self.Settings
	else
		KBMSLRDEERS_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function REG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEERS_Settings = self.Settings
	else
		KBMSLRDEERS_Settings = self.Settings
	end	
end

function REG:Castbar(units)
end

function REG:RemoveUnits(UnitID)
	if self.Regulos.UnitID == UnitID then
		self.Regulos.Available = false
		return true
	end
	return false
end

function REG:Death(UnitID)
	if self.Regulos.UnitID == UnitID then
		self.Regulos.Dead = true
		return true
	end
	return false
end

function REG:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Regulos.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Regulos.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Regulos.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Regulos
			end
		end
	end
end

function REG:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Regulos.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function REG:Timer()	
end

function REG:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Regulos, self.Enabled)
end

function REG:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Regulos)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Regulos)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Regulos.CastBar = KBM.CastBar:Add(self, self.Regulos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end