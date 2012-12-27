-- Progenitor Saetos Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEPR_Settings = nil
chKBMSLRDEEPR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local PRO = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Progenitor.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "RProgenitor",
	Object = "PRO",
}

KBM.RegisterMod(PRO.ID, PRO)

-- Main Unit Dictionary
PRO.Lang.Unit = {}
PRO.Lang.Unit.Progenitor = KBM.Language:Add("Progenitor Saetos")
PRO.Lang.Unit.Progenitor:SetGerman("Erzeuger Saetos")
PRO.Lang.Unit.ProgenitorShort = KBM.Language:Add("Saetos")
PRO.Lang.Unit.ProgenitorShort:SetGerman("Saetos")
PRO.Lang.Unit.Ebassi = KBM.Language:Add("Ebassi")
PRO.Lang.Unit.Arebus = KBM.Language:Add("Arebus")
PRO.Lang.Unit.Rhu = KBM.Language:Add("Rhu'Megar")
PRO.Lang.Unit.Juntun = KBM.Language:Add("Juntun")

-- Ability Dictionary
PRO.Lang.Ability = {}

-- Description Dictionary
PRO.Lang.Main = {}

PRO.Descript = PRO.Lang.Unit.Progenitor[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
PRO.Progenitor = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Progenitor[KBM.Lang],
	NameShort = PRO.Lang.Unit.ProgenitorShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD291C6A48356A9E",
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

PRO.Ebassi = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Ebassi[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFB8F268E16C8A192",
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

PRO.Arebus = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Arebus[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC1DFC775231ADB4",
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

PRO.Rhu = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Rhu[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFB51152D35742133",
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

PRO.Juntun = {
	Mod = PRO,
	Level = "??",
	Active = false,
	Name = PRO.Lang.Unit.Juntun[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFC8E06386D2DCB01",
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

function PRO:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Progenitor.Name] = self.Progenitor,
		[self.Ebassi.Name] = self.Ebassi,
		[self.Arebus.Name] = self.Arebus,
		[self.Rhu.Name] = self.Rhu,
		[self.Juntun.Name] = self.Juntun,
	}
end

function PRO:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Progenitor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Progenitor.Settings.TimersRef,
		-- AlertsRef = self.Progenitor.Settings.AlertsRef,
	}
	KBMSLRDEEPR_Settings = self.Settings
	chKBMSLRDEEPR_Settings = self.Settings
	
end

function PRO:SwapSettings(bool)

	if bool then
		KBMSLRDEEPR_Settings = self.Settings
		self.Settings = chKBMSLRDEEPR_Settings
	else
		chKBMSLRDEEPR_Settings = self.Settings
		self.Settings = KBMSLRDEEPR_Settings
	end

end

function PRO:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEPR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEPR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEPR_Settings = self.Settings
	else
		KBMSLRDEEPR_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function PRO:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEPR_Settings = self.Settings
	else
		KBMSLRDEEPR_Settings = self.Settings
	end	
end

function PRO:Castbar(units)
end

function PRO:RemoveUnits(UnitID)
	if self.Progenitor.UnitID == UnitID then
		self.Progenitor.Available = false
		return true
	end
	return false
end

function PRO:Death(UnitID)
	if self.Progenitor.UnitID == UnitID then
		self.Progenitor.Dead = true
		return true
	end
	return false
end

function PRO:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Progenitor then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Progenitor, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Progenitor then
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return self.Progenitor
		end
	end
end

function PRO:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Progenitor.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function PRO:Timer()	
end

function PRO:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Progenitor, self.Enabled)
end

function PRO:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Progenitor)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Progenitor)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Progenitor.CastBar = KBM.CastBar:Add(self, self.Progenitor)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end