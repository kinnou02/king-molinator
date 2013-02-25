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
	Enrage = (7 * 60) + 30,
}

KBM.RegisterMod(PRO.ID, PRO)

-- Main Unit Dictionary
PRO.Lang.Unit = {}
PRO.Lang.Unit.Progenitor = KBM.Language:Add("Progenitor Saetos")
PRO.Lang.Unit.Progenitor:SetGerman("Erzeuger Saetos")
PRO.Lang.Unit.ProgenitorShort = KBM.Language:Add("Saetos")
PRO.Lang.Unit.ProgenitorShort:SetGerman("Saetos")
PRO.Lang.Unit.Ebassi = KBM.Language:Add("Ebassi")
PRO.Lang.Unit.Ebassi:SetGerman()
PRO.Lang.Unit.Arebus = KBM.Language:Add("Arebus")
PRO.Lang.Unit.Arebus:SetGerman() 
PRO.Lang.Unit.Rhu = KBM.Language:Add("Rhu'Megar")
PRO.Lang.Unit.Rhu:SetGerman()
PRO.Lang.Unit.Juntun = KBM.Language:Add("Juntun")
PRO.Lang.Unit.Juntun:SetGerman()

-- Ability Dictionary
PRO.Lang.Ability = {}
PRO.Lang.Ability.Ebon = KBM.Language:Add("Ebon Eruption")
PRO.Lang.Ability.Redesign = KBM.Language:Add("Twisted Redesign")
PRO.Lang.Ability.Entropic = KBM.Language:Add("Entropic Abyss")

-- Buff Dictionary
PRO.Lang.Buff = {}
PRO.Lang.Buff.Barrier = KBM.Language:Add("Ebon Barrier")
PRO.Lang.Buff.Hand = KBM.Language:Add("Hand of the Master")

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
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Redesign = KBM.Defaults.AlertObj.Create("purple"),
		},
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
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
			Barrier = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Entropic = KBM.Defaults.MechObj.Create("purple"),
		},
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
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
			Barrier = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Entropic = KBM.Defaults.MechObj.Create("purple"),
		},
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
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
			Barrier = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Entropic = KBM.Defaults.MechObj.Create("purple"),
		},
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
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Ebon = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Ebon = KBM.Defaults.AlertObj.Create("red"),
			Barrier = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Entropic = KBM.Defaults.MechObj.Create("purple"),
		},
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

	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end
end

function PRO:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Progenitor = {
			CastBar = self.Progenitor.Settings.CastBar,
			AlertsRef = self.Progenitor.Settings.AlertsRef,
			MechRef = self.Progenitor.Settings.MechRef,
		},
		Juntun = {
			CastBar = self.Juntun.Settings.CastBar,
			TimersRef = self.Juntun.Settings.TimersRef,
			AlertsRef = self.Juntun.Settings.AlertsRef,
			MechRef = self.Juntun.Settings.MechRef,
		},
		Ebassi = {
			CastBar = self.Ebassi.Settings.CastBar,
			TimersRef = self.Ebassi.Settings.TimersRef,
			AlertsRef = self.Ebassi.Settings.AlertsRef,
			MechRef = self.Ebassi.Settings.MechRef,
		},
		Arebus = {
			CastBar = self.Arebus.Settings.CastBar,
			TimersRef = self.Arebus.Settings.TimersRef,
			AlertsRef = self.Arebus.Settings.AlertsRef,
			MechRef = self.Arebus.Settings.MechRef,
		},
		Rhu = {
			CastBar = self.Rhu.Settings.CastBar,
			TimersRef = self.Rhu.Settings.TimersRef,
			AlertsRef = self.Rhu.Settings.AlertsRef,
			MechRef = self.Rhu.Settings.MechRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
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
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Progenitor, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Juntun, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Ebassi, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Arebus, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Rhu, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					BossObj.CastBar:Remove()
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
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
		BossObj.CastBar:Remove()
	end
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
	self.Progenitor.AlertsRef.Redesign = KBM.Alert:Create(self.Lang.Ability.Redesign[KBM.Lang], -1, true, true, "purple")
	self.Progenitor.AlertsRef.Redesign:Important()
	KBM.Defaults.AlertObj.Assign(self.Progenitor)
	
	-- Assign Alerts and Timers to Triggers

	self.Progenitor.Triggers.Redesign = KBM.Trigger:Create(self.Lang.Ability.Redesign[KBM.Lang], "cast", self.Progenitor)
	self.Progenitor.Triggers.Redesign:AddAlert(self.Progenitor.AlertsRef.Redesign)

	self.Progenitor.CastBar = KBM.CastBar:Add(self, self.Progenitor)

	-- Setup the 4 mini bosses identically

	for k, BossObj in ipairs({[1] = self.Juntun, [2] = self.Ebassi, [3] = self.Arebus, [4] = self.Rhu, }) do
		BossObj.TimersRef.Ebon = KBM.MechTimer:Add(self.Lang.Ability.Ebon[KBM.Lang], 23, false)
		KBM.Defaults.TimerObj.Assign(BossObj)
		BossObj.AlertsRef.Ebon = KBM.Alert:Create(self.Lang.Ability.Ebon[KBM.Lang], 10, true, true, "red")
		KBM.Defaults.AlertObj.Assign(BossObj)
		BossObj.MechRef.Entropic = KBM.MechSpy:Add(self.Lang.Ability.Entropic[KBM.Lang], 5, "cast", BossObj)
		KBM.Defaults.MechObj.Assign(BossObj)
		BossObj.Triggers.Ebon = KBM.Trigger:Create(self.Lang.Ability.Ebon[KBM.Lang], "channel", BossObj)
		BossObj.Triggers.Ebon:AddTimer(BossObj.TimersRef.Ebon)
		BossObj.Triggers.Ebon:AddAlert(BossObj.AlertsRef.Ebon)
		BossObj.Triggers.EbonInt = KBM.Trigger:Create(self.Lang.Ability.Ebon[KBM.Lang], "interrupt", BossObj)
		BossObj.Triggers.EbonInt:AddStop(BossObj.AlertsRef.Ebon)
		BossObj.Triggers.Entropic = KBM.Trigger:Create(self.Lang.Ability.Entropic[KBM.Lang], "cast", BossObj)
		BossObj.Triggers.Entropic:AddSpy(BossObj.MechRef.Entropic)
		BossObj.CastBar = KBM.CastBar:Add(self, BossObj)
	end
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end