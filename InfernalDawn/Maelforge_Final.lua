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
	Enrage = 15 * 60,
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
	RaidID_P2 = "U35BDBE1D14577953",
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
			Fissure = KBM.Defaults.TimerObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Hell = KBM.Defaults.MechObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Hell_Yellow = KBM.Defaults.AlertObj.Create("yellow"),
			Hell_Green = KBM.Defaults.AlertObj.Create("dark_green"),
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

-- Notify Dictionary
MF.Lang.Notify = {}
MF.Lang.Notify.Fissure = KBM.Language:Add("Hellfire feeds on your agony!")

-- Mechanic Dictionary
MF.Lang.Mechanic = {}
MF.Lang.Mechanic.Fissure = KBM.Language:Add("Fissures")

-- Ability Dictionary
MF.Lang.Ability = {}

-- Menu Dictionary
MF.Lang.Menu = {}
MF.Lang.Menu.Hell_Green = KBM.Language:Add("Hellfire (Green)")
MF.Lang.Menu.Hell_Yellow = KBM.Language:Add("Hellfire (Yellow)")

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
	KBM.SubBossID[self.Maelforge.RaidID_P2] = self.Maelforge

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

function MF.PhaseTwo()
	if MF.Phase == 1 then
		MF.PhaseObj.Objectives:Remove()
		MF.PhaseObj.Objectives:AddPercent(MF.Maelforge.Name, 30, 65)
		MF.PhaseObj:SetPhase(2)
		MF.Phase = 2
	end
end

function MF.PhaseFinal()
	MF.PhaseObj.Objectives:Remove()
	MF.PhaseObj.Objectives:AddPercent(MF.Maelforge.Name, 0, 30)
	MF.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MF.Phase = 3
end

function MF:Death(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Dead = true
		return true
	end
	return false
end

function MF:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Maelforge.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maelforge.Dead = false
					self.Maelforge.Casting = false
					self.Maelforge.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					if uDetails.type == self.Maelforge.RaidID_P2 then
						self.PhaseTwo()
					else
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.Maelforge.Name, 65, 100)
						self.Phase = 1
					end
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
	self.Maelforge.TimersRef.Fissure = KBM.MechTimer:Add(self.Lang.Mechanic.Fissure[KBM.Lang], 60)
	KBM.Defaults.TimerObj.Assign(self.Maelforge)
	
	-- Create Spies
	self.Maelforge.MechRef.Hell = KBM.MechSpy:Add(self.Lang.Debuff.Hell[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	KBM.Defaults.MechObj.Assign(self.Maelforge)
	
	-- Create Alerts
	self.Maelforge.AlertsRef.Hell_Yellow = KBM.Alert:Create(self.Lang.Menu.Hell_Yellow[KBM.Lang], nil, false, true, "yellow")
	self.Maelforge.AlertsRef.Hell_Green = KBM.Alert:Create(self.Lang.Menu.Hell_Green[KBM.Lang], nil, false, true, "dark_green")
	self.Maelforge.AlertsRef.Fiery = KBM.Alert:Create(self.Lang.Debuff.Fiery[KBM.Lang], nil, false, true, "red")
	self.Maelforge.AlertsRef.Earthen = KBM.Alert:Create(self.Lang.Debuff.Earthen[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Maelforge)
	
	-- Assign Alerts and Timers to Triggers
	self.Maelforge.Triggers.Hell_Yellow = KBM.Trigger:Create("B58F6969FA32C3353", "playerIDBuff", self.Maelforge)
	self.Maelforge.Triggers.Hell_Yellow:AddAlert(self.Maelforge.AlertsRef.Hell_Yellow, true)
	self.Maelforge.Triggers.Hell_Yellow:AddTimer(self.Maelforge.TimersRef.Hell)
	self.Maelforge.Triggers.Hell_Yellow:AddSpy(self.Maelforge.MechRef.Hell)
	self.Maelforge.Triggers.Hell_Green = KBM.Trigger:Create("B0E7E2D5A0A251BA2", "playerIDBuff", self.Maelforge)
	self.Maelforge.Triggers.Hell_Green:AddAlert(self.Maelforge.AlertsRef.Hell_Green, true)
	self.Maelforge.Triggers.Hell_Green:AddSpy(self.Maelforge.MechRef.Hell)
	self.Maelforge.Triggers.Fissure = KBM.Trigger:Create(self.Lang.Notify.Fissure[KBM.Lang], "notify", self.Maelforge)
	self.Maelforge.Triggers.Fissure:AddTimer(self.Maelforge.TimersRef.Fissure)
	self.Maelforge.Triggers.Fiery = KBM.Trigger:Create(self.Lang.Debuff.Fiery[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Fiery:AddAlert(self.Maelforge.AlertsRef.Fiery, true)
	self.Maelforge.Triggers.Earthen = KBM.Trigger:Create(self.Lang.Debuff.Earthen[KBM.Lang], "playerBuff", self.Maelforge)
	self.Maelforge.Triggers.Earthen:AddAlert(self.Maelforge.AlertsRef.Earthen, true)
	self.Maelforge.Triggers.PhaseTwo = KBM.Trigger:Create(65, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Maelforge.Triggers.PhaseFinal = KBM.Trigger:Create(30, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	
	self.Maelforge.CastBar = KBM.CastBar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end