-- Dread Lord Goloch Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEDG_Settings = nil
chKBMSLRDEEDG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local DLG = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Goloch.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "Goloch",
	Object = "DLG",
}

DLG.Goloch = {
	Mod = DLG,
	Level = "??",
	Active = false,
	Name = "Dread Lord Goloch",
	NameShort = "Goloch",
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

KBM.RegisterMod(DLG.ID, DLG)

-- Main Unit Dictionary
DLG.Lang.Unit = {}
DLG.Lang.Unit.Goloch = KBM.Language:Add("Dread Lord Goloch")
DLG.Lang.Unit.Goloch:SetGerman("Schreckensfürst Goloch")
DLG.Lang.Unit.GolochShort = KBM.Language:Add("Goloch")
DLG.Lang.Unit.GolochShort:SetGerman("Goloch")

-- Ability Dictionary
DLG.Lang.Ability = {}

-- Debuff Dictionary
DLG.Lang.Debuff = {}
DLG.Lang.Debuff.Dread = KBM.Language:Add("Dread Scythe")

-- Description Dictionary
DLG.Lang.Main = {}
DLG.Lang.Main.Descript = KBM.Language:Add("Dread Lord Goloch")
DLG.Lang.Main.Descript:SetGerman("Schreckensfürst Goloch")
DLG.Descript = DLG.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
DLG.Goloch.Name = DLG.Lang.Unit.Goloch[KBM.Lang]
DLG.Goloch.NameShort = DLG.Lang.Unit.GolochShort[KBM.Lang]

function DLG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Goloch.Name] = self.Goloch,
	}
end

function DLG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Goloch.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Goloch.Settings.TimersRef,
		-- AlertsRef = self.Goloch.Settings.AlertsRef,
	}
	KBMSLRDEEDG_Settings = self.Settings
	chKBMSLRDEEDG_Settings = self.Settings
	
end

function DLG:SwapSettings(bool)

	if bool then
		KBMSLRDEEDG_Settings = self.Settings
		self.Settings = chKBMSLRDEEDG_Settings
	else
		chKBMSLRDEEDG_Settings = self.Settings
		self.Settings = KBMSLRDEEDG_Settings
	end

end

function DLG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEDG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEDG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEDG_Settings = self.Settings
	else
		KBMSLRDEEDG_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function DLG:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEDG_Settings = self.Settings
	else
		KBMSLRDEEDG_Settings = self.Settings
	end	
end

function DLG:Castbar(units)
end

function DLG:RemoveUnits(UnitID)
	if self.Goloch.UnitID == UnitID then
		self.Goloch.Available = false
		return true
	end
	return false
end

function DLG:Death(UnitID)
	if self.Goloch.UnitID == UnitID then
		self.Goloch.Dead = true
		return true
	end
	return false
end

function DLG:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if self.Bosses[uDetails.name] then
			local BossObj = self.Bosses[uDetails.name]
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Goloch then
					BossObj.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Dread[KBM.Lang], unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Goloch, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Goloch then
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return self.Goloch
		end
	end
end

function DLG:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Goloch.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function DLG:Timer()	
end

function DLG:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Goloch, self.Enabled)
end

function DLG:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Goloch)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Goloch)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Goloch.CastBar = KBM.CastBar:Add(self, self.Goloch)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end