-- Maelforge Final Encounter Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDMFF_Settings = nil
chKBMINDMFF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local MF = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maelforge_Final.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Maelforge_Final",
	Object = "MF",
}

MF.Maelforge = {
	Mod = MF,
	Level = "??",
	Active = false,
	Name = "Maelforge",
	NameShort = "Maelforge",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	RaidID = "U22D6DD797E7A5F87",
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Hell = KBM.Defaults.TimerObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Hell = KBM.Defaults.MechObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Hell = KBM.Defaults.AlertObj.Create("purple"),
			Fiery = KBM.Defaults.AlertObj.Create("red"),
			Earthen = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

KBM.RegisterMod(MF.ID, MF)

-- Main Unit Dictionary
MF.Lang.Unit = {}
MF.Lang.Unit.Maelforge = KBM.Language:Add(MF.Maelforge.Name)
MF.Lang.Unit.Maelforge:SetGerman("Flammenmaul")
MF.Lang.Unit.Maelforge:SetFrench()
MF.Lang.Unit.Maelforge:SetRussian("Маэлфорж")
MF.Lang.Unit.Maelforge:SetKorean("마엘포지")

-- Location Dictionary
MF.Lang.Location = {}
MF.Lang.Location.Spires = KBM.Language:Add("Spires of Sacrifice")

-- Debuff Dictionary
MF.Lang.Debuff = {}
MF.Lang.Debuff.Hell = KBM.Language:Add("Hellfire")
MF.Lang.Debuff.Earthen = KBM.Language:Add("Earthen Fissure")
MF.Lang.Debuff.Fiery = KBM.Language:Add("Fiery Fissure")

-- Ability Dictionary
MF.Lang.Ability = {}

-- Description
MF.Lang.Descript = {}
MF.Lang.Descript.Main = KBM.Language:Add("Maelforge - Final")

MF.Maelforge.Name = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Maelforge.NameShort = MF.Lang.Unit.Maelforge[KBM.Lang]
MF.Maelforge.LocationReq = MF.Lang.Location.Spires[KBM.Lang]
MF.Descript = MF.Lang.Descript.Main[KBM.Lang]

function MF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelforge.Name] = self.Maelforge,
	}
	KBM.SubBossID[self.Maelforge.RaidID] = self.Maelforge

end

function MF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelforge.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Maelforge.Settings.TimersRef,
		MechRef = self.Maelforge.Settings.MechRef,
		AlertsRef = self.Maelforge.Settings.AlertsRef,
	}
	KBMINDMFF_Settings = self.Settings
	chKBMINDMFF_Settings = self.Settings
	
end

function MF:SwapSettings(bool)

	if bool then
		KBMINDMFF_Settings = self.Settings
		self.Settings = chKBMINDMFF_Settings
	else
		chKBMINDMFF_Settings = self.Settings
		self.Settings = KBMINDMFF_Settings
	end

end

function MF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDMFF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDMFF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDMFF_Settings = self.Settings
	else
		KBMINDMFF_Settings = self.Settings
	end	
end

function MF:SaveVars()	
	if KBM.Options.Character then
		chKBMINDMFF_Settings = self.Settings
	else
		KBMINDMFF_Settings = self.Settings
	end	
end

function MF:Castbar(units)
end

function MF:RemoveUnits(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Available = false
		return true
	end
	return false
end

function MF:Death(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Dead = true
		return true
	end
	return false
end

function MF:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Maelforge.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maelforge.Dead = false
					self.Maelforge.Casting = false
					self.Maelforge.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Maelforge.Name, 0, 100)
					self.Phase = 1
				end
				self.Maelforge.UnitID = unitID
				self.Maelforge.Available = true
				return self.Maelforge
			end
		end
	end
end

function MF:Reset()
	self.EncounterRunning = false
	self.Maelforge.Available = false
	self.Maelforge.UnitID = nil
	self.Maelforge.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MF:Timer()	
end

function MF:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maelforge, self.Enabled)
end

function MF:Start()
	-- Create Timers
	self.Maelforge.TimersRef.Hell = KBM.MechTimer:Add(self.Lang.Debuff.Hell[KBM.Lang], 50)
	KBM.Defaults.TimerObj.Assign(self.Maelforge)
	
	-- Create Spies
	self.Maelforge.MechRef.Hell = KBM.MechSpy:Add(self.Lang.Debuff.Hell[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	KBM.Defaults.MechObj.Assign(self.Maelforge)
	
	-- Create Alerts
	self.Maelforge.AlertsRef.Hell = KBM.Alert:Create(self.Lang.Debuff.Hell[KBM.Lang], nil, true, true, "purple")
	self.Maelforge.AlertsRef.Fiery = KBM.Alert:Create(self.Lang.Debuff.Fiery[KBM.Lang], 18, false, true, "red")
	self.Maelforge.AlertsRef.Earthen = KBM.Alert:Create(self.Lang.Debuff.Earthen[KBM.Lang], 18, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Maelforge)
	
	-- Assign Alerts and Timers to Triggers
	self.Maelforge.Triggers.Hell = KBM.Trigger:Create(self.Lang.Debuff.Hell[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Hell:AddAlert(self.Maelforge.AlertsRef.Hell, true)
	self.Maelforge.Triggers.Hell:AddTimer(self.Maelforge.TimersRef.Hell)
	self.Maelforge.Triggers.Hell:AddSpy(self.Maelforge.MechRef.Hell)
	self.Maelforge.Triggers.Fiery = KBM.Trigger:Create(self.Lang.Debuff.Fiery[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Fiery:AddAlert(self.Maelforge.AlertsRef.Fiery, true)
	self.Maelforge.Triggers.Earthen = KBM.Trigger:Create(self.Lang.Debuff.Earthen[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Earthen:AddAlert(self.Maelforge.AlertsRef.Earthen, true)
	
	self.Maelforge.CastBar = KBM.CastBar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end