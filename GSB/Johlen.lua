-- Infiltrator Johlen Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBIJ_Settings = nil
chKBMGSBIJ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GSB = KBM.BossMod["Greenscales Blight"]

local IJ = {
	Enabled = true,
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	ID = "Johlen",
}

IJ.Johlen = {
	Mod = IJ,
	Level = "52",
	Active = false,
	Name = "Infiltrator Johlen",
	NameShort = "Johlen",
	Menu = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Blinding = KBM.Defaults.AlertObj.Create("yellow"),
			Bomb = KBM.Defaults.AlertObj.Create("red"),
		},
	},
}

KBM.RegisterMod(IJ.ID, IJ)

IJ.Lang.Johlen = KBM.Language:Add(IJ.Johlen.Name)
IJ.Lang.Johlen.French = "Infiltrateur Johlen"

-- Ability Dictionary
IJ.Lang.Ability = {}
IJ.Lang.Ability.Blinding = KBM.Language:Add("Blinding Bomb")

-- Verbose Dictionary 
IJ.Lang.Verbose = {}
IJ.Lang.Verbose.Bomb = KBM.Language:Add("Devastation")

-- Unit Dictionary
IJ.Lang.Unit = {}
IJ.Lang.Unit.Bomb = KBM.Language:Add("Devastating Bomb")

IJ.Johlen.Name = IJ.Lang.Johlen[KBM.Lang]

IJ.Bomb = {
	Mod = ID,
	Level = "??",
	Name = IJ.Lang.Unit.Bomb[KBM.Lang],
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

function IJ:AddBosses(KBM_Boss)
	self.Johlen.Descript = self.Johlen.Name
	self.MenuName = self.Johlen.Descript
	self.Bosses = {
		[self.Johlen.Name] = self.Johlen,
		[self.Bomb.Name] = self.Bomb,
	}
	KBM_Boss[self.Johlen.Name] = self.Johlen
	KBM.SubBoss[self.Bomb.Name] = self.Bomb
end

function IJ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Johlen.Settings.CastBar,
		AlertsRef = self.Johlen.Settings.AlertsRef,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMGSBIJ_Settings = self.Settings
	chKBMGSBIJ_Settings = self.Settings
end

function IJ:SwapSettings(bool)
	if bool then
		KBMGSBIJ_Settings = self.Settings
		self.Settings = chKBMGSBIJ_Settings
	else
		chKBMGSBIJ_Settings = self.Settings
		self.Settings = KBMGSBIJ_Settings
	end
end

function IJ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBIJ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBIJ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBIJ_Settings = self.Settings
	else
		KBMGSBIJ_Settings = self.Settings
	end	
end

function IJ:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBIJ_Settings = self.Settings
	else
		KBMGSBIJ_Settings = self.Settings
	end	
end

function IJ:Castbar(units)
end

function IJ:RemoveUnits(UnitID)
	if self.Johlen.UnitID == UnitID then
		self.Johlen.Available = false
		return true
	end
	return false
end

function IJ:Death(UnitID)
	if self.Johlen.UnitID == UnitID then
		self.Johlen.Dead = true
		return true
	elseif self.Bomb.UnitList[UnitID] then
		self.Bomb.UnitList[UnitID].Dead = true
		self.PhaseObj.Objectives:Remove(self.Lang.Unit.Bomb[KBM.Lang])
		self.PhaseObj:SetPhase(self.Phase)
	end
	return false
end

function IJ:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Johlen.Name then
				if not self.Johlen.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Johlen.Dead = false
					self.Johlen.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Johlen.Name, 75, 100)
					self.PhaseObj:SetPhase(1)
				end
				self.Johlen.Casting = false
				self.Johlen.UnitID = unitID
				self.Johlen.Available = true
				return self.Johlen
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = IJ,
						Level = "??",
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
				else
					self.Bosses[uDetails.name].UnitList[unitID].Available = true
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]			
			end
		end
	end
end

function IJ.PhaseTwo()
	IJ.PhaseObj.Objectives:Remove()
	IJ.Phase = 2
	IJ.PhaseObj:SetPhase("Bomb 1/3")
	IJ.PhaseObj.Objectives:AddPercent(IJ.Johlen.Name, 50, 75)
	IJ.PhaseObj.Objectives:AddPercent(IJ.Bomb.Name, 0, 100)	
end

function IJ.PhaseThree()
	IJ.PhaseObj.Objectives:Remove()
	IJ.Phase = 3
	IJ.PhaseObj:SetPhase("Bomb 2/3")
	IJ.PhaseObj.Objectives:AddPercent(IJ.Johlen.Name, 25, 50)
	IJ.PhaseObj.Objectives:AddPercent(IJ.Bomb.Name, 0, 100)	
end

function IJ.PhaseFour()
	IJ.PhaseObj.Objectives:Remove()
	IJ.Phase = 4
	IJ.PhaseObj:SetPhase("Bomb 3/3")
	IJ.PhaseObj.Objectives:AddPercent(IJ.Johlen.Name, 0, 25)
	IJ.PhaseObj.Objectives:AddPercent(IJ.Bomb.Name, 0, 100)	
end

function IJ:Reset()
	self.EncounterRunning = false
	self.Johlen.Available = false
	self.Johlen.UnitID = nil
	self.Johlen.CastBar:Remove()
	self.Johlen.Dead = false
	self.Bomb.UnitList = {}
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())
end

function IJ:Timer()	
end

function IJ.Johlen:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function IJ.Johlen:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function IJ:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Johlen, self.Enabled)
end

function IJ:Start()
	-- Create Alerts
	self.Johlen.AlertsRef.Blinding = KBM.Alert:Create(self.Lang.Ability.Blinding[KBM.Lang], 5, true, true, "yellow")
	self.Johlen.AlertsRef.Bomb = KBM.Alert:Create(self.Lang.Verbose.Bomb[KBM.Lang], 25, false, true, "red")
	self.Johlen.AlertsRef.Bomb.MenuName = self.Lang.Unit.Bomb[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Johlen)
	
	-- Assign and Create Triggers
	self.Johlen.Triggers.Bomb = KBM.Trigger:Create(self.Lang.Unit.Bomb[KBM.Lang], "notify", self.Johlen)
	self.Johlen.Triggers.Bomb:AddAlert(self.Johlen.AlertsRef.Bomb)
	self.Johlen.Triggers.Blinding = KBM.Trigger:Create(self.Lang.Ability.Blinding[KBM.Lang], "cast", self.Johlen)
	self.Johlen.Triggers.Blinding:AddAlert(self.Johlen.AlertsRef.Blinding)
	self.Johlen.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Johlen)
	self.Johlen.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Johlen.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Johlen)
	self.Johlen.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Johlen.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Johlen)
	self.Johlen.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	self.Johlen.CastBar = KBM.CastBar:Add(self, self.Johlen)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end