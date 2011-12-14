-- Grugonim Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGR_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local GR = {
	Enabled = true,
	Grugonim = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = HK.Name,
	Timers = {},
	Lang = {},
	Phase = 1,
	Enrage = 60 * 13,
	ID = "Grugonim",
	Towers = 0,
	Breaths = 0,	
}

GR.Grugonim = {
	Mod = GR,
	Level = "??",
	Active = false,
	Name = "Grugonim",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = false,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Decay = KBM.Defaults.AlertObj.Create("purple"),
			Bile = KBM.Defaults.AlertObj.Create("dark_green"),
			Breath = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

GR.Tower = {
	Mod = GR,
	Level = "??",
	Name = "Manifested Death",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

KBM.RegisterMod(GR.ID, GR)

GR.Lang.Grugonim = KBM.Language:Add(GR.Grugonim.Name)
GR.Lang.Tower = KBM.Language:Add(GR.Tower.Name)
GR.Lang.Tower.German = "Manifestierter Tod"
GR.Lang.Tower.French = "Mort manifestée"

-- Ability Dictionary
GR.Lang.Ability = {}
GR.Lang.Ability.Decay = KBM.Language:Add("Rampant Decay")
GR.Lang.Ability.Decay.German = "Wilder Verfall"
GR.Lang.Ability.Decay.French = "Pourriture rampante"
GR.Lang.Ability.Bile = KBM.Language:Add("Corrosive Bile")
GR.Lang.Ability.Bile.German = "Ätzende Galle"
GR.Lang.Ability.Bile.French = "Vase corrosive"
GR.Lang.Ability.Breath = KBM.Language:Add("Necrotic Breath")
GR.Lang.Ability.Breath.German = "Nekrotischer Atem"
GR.Lang.Ability.Disruption = KBM.Language:Add("Seismic Disruption")
GR.Lang.Ability.Disruption.German = "Seismische Störung"

GR.Grugonim.Name = GR.Lang.Grugonim[KBM.Lang]
GR.Tower.Name = GR.Lang.Tower[KBM.Lang]

function GR:AddBosses(KBM_Boss)
	self.Grugonim.Descript = self.Grugonim.Name
	self.MenuName = self.Grugonim.Descript
	self.Bosses = {
		[self.Grugonim.Name] = self.Grugonim,
		[self.Tower.Name] = self.Tower,
	}
	KBM_Boss[self.Grugonim.Name] = self.Grugonim
	KBM.SubBoss[self.Tower.Name] = self.Tower	
end

function GR:InitVars()	
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		CastBar = GR.Grugonim.Settings.CastBar,
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = GR.Grugonim.Settings.TimersRef,
		AlertsRef = GR.Grugonim.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMGR_Settings = self.Settings
	chKBMGR_Settings = self.Settings	
end

function GR:SwapSettings(bool)
	if bool then
		KBMGR_Settings = self.Settings
		self.Settings = chKBMGR_Settings
	else
		chKBMGR_Settings = self.Settings
		self.Settings = KBMGR_Settings
	end
end

function GR:LoadVars()	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMGR_Settings
	else
		TargetLoad = KBMGR_Settings
	end
	
	if type(TargetLoad) == "table" then
		KBM.LoadTable(TargetLoad, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGR_Settings = self.Settings
	else
		KBMGR_Settings = self.Settings
	end	
end

function GR:SaveVars()
	if KBM.Options.Character then
		chKBMGR_Settings = self.Settings
	else
		KBMGR_Settings = self.Settings
	end	
end

function GR:Castbar(units)
end

function GR:RemoveUnits(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Available = false
		return true
	end
	return false	
end

function GR:Death(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Dead = true
		return true
	else
		-- Tower Phase
		if self.Phase == 2 then
			self.Towers = self.Towers + 1
			if self.Towers == 3 then
				self.Towers = 0
				self.PhaseThree()
			end
		elseif self.Phase == 4 then
			self.Towers = self.Towers + 1
			if self.Towers == 6 then
				self.Towers = 0
				self.PhaseFive()
			end
		end
	end
	return false	
end

function GR.BreathCount()
	GR.Breaths = GR.Breaths + 1
	KBM.PhaseMonitor.Objectives.Lists.Meta[GR.Lang.Ability.Breath[KBM.Lang]]:Update(GR.Breaths)
end

function GR.BreathReset()
	GR.Breaths = 0
	KBM.PhaseMonitor.Objectives.Lists.Meta[GR.Lang.Ability.Breath[KBM.Lang]]:Update(GR.Breaths)
end

function GR.TowerPhase()
	GR.Breaths = 0
	GR.PhaseObj.Objectives:Remove()
	GR.PhaseObj:SetPhase("Towers")
	if GR.Phase == 1 then
		GR.Phase = 2
		GR.PhaseObj.Objectives:AddDeath(GR.Tower.Name, 3)
	else
		GR.Phase = 4
		GR.PhaseObj.Objectives:AddDeath(GR.Tower.Name, 6)
	end
end

function GR.PhaseThree()
	GR.Phase = 3
	GR.PhaseObj.Objectives:Remove()
	GR.PhaseObj:SetPhase(GR.Phase)
	GR.PhaseObj.Objectives:AddPercent(GR.Grugonim.Name, 10, 50)
	GR.PhaseObj.Objectives:AddMeta(GR.Lang.Ability.Breath[KBM.Lang], 3, 0)
end

function GR.PhaseFive()
	GR.Phase = 5
	GR.PhaseObj.Objectives:Remove()
	GR.PhaseObj:SetPhase("Final")
	GR.PhaseObj.Objectives:AddPercent(GR.Grugonim.Name, 0, 10)
	GR.PhaseObj.Objectives:AddMeta(GR.Lang.Ability.Breath[KBM.Lang], 3, 0)
end

function GR:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
		
			if uDetails.name == self.Grugonim.Name then
				if not self.Grugonim.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Grugonim.CastBar:Create(unitID)
					KBM.TankSwap:Start("Heart Stopping Toxin")
					self.Phase = 1
					self.Breaths = 0
					self.PhaseObj.Objectives:AddPercent(self.Grugonim.Name, 50, 100)
					self.PhaseObj.Objectives:AddMeta(self.Lang.Ability.Breath[KBM.Lang], 3, 0)
					self.PhaseObj:Start(self.StartTime)
				end
				self.Grugonim.Dead = false
				self.Grugonim.Casting = false
				self.Grugonim.UnitID = unitID
				self.Grugonim.Available = true
				return self.Grugonim
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = GR,
						Level = "??",
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
				else
					self.Bosses[uDetails.name].UnitList[unitID].Dead = false
					self.Bosses[uDetails.name].UnitList[unitID].Available = true
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]
			end
			
		end
	end
end

function GR:Reset()	
	self.EncounterRunning = false
	self.Grugonim.Available = false
	self.Grugonim.UnitID = nil
	self.Grugonim.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)
	self.Breaths = 0
	for TowerID, Tower in pairs(self.Tower.UnitList) do
		Tower = nil
	end
	self.Tower.UnitList = {}	
end

function GR:Timer()
	
end

function GR.Grugonim:SetTimers(bool)	
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

function GR.Grugonim:SetAlerts(bool)
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

function GR:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Grugonim, self.Enabled)
end

function GR:Start()	
	-- AddTimers
	self.Grugonim.TimersRef.Breath = KBM.MechTimer:Add(self.Lang.Ability.Breath[KBM.Lang], 15)
	KBM.Defaults.TimerObj.Assign(self.Grugonim)
	
	-- Add Alerts
	self.Grugonim.AlertsRef.Decay = KBM.Alert:Create(self.Lang.Ability.Decay[KBM.Lang], 3, true, true)
	self.Grugonim.AlertsRef.Bile = KBM.Alert:Create(self.Lang.Ability.Bile[KBM.Lang], 2, true, true)
	self.Grugonim.AlertsRef.Breath = KBM.Alert:Create(self.Lang.Ability.Breath[KBM.Lang], nil, true, true)
	KBM.Defaults.AlertObj.Assign(self.Grugonim)
	
	-- Assign Mechanics to Triggers
	self.Grugonim.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Decay:AddAlert(self.Grugonim.AlertsRef.Decay)
	self.Grugonim.Triggers.Bile = KBM.Trigger:Create(self.Lang.Ability.Bile[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Bile:AddAlert(self.Grugonim.AlertsRef.Bile)
	self.Grugonim.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Breath:AddTimer(self.Grugonim.TimersRef.Breath)
	self.Grugonim.Triggers.Breath:AddAlert(self.Grugonim.AlertsRef.Breath)
	self.Grugonim.Triggers.Breath:AddPhase(self.BreathCount)
	self.Grugonim.Triggers.Disruption = KBM.Trigger:Create(self.Lang.Ability.Disruption[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Disruption:AddPhase(self.BreathReset)
	self.Grugonim.Triggers.Disruption:AddStop(self.Grugonim.TimersRef.Breath)
	self.Grugonim.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Grugonim)
	self.Grugonim.Triggers.PhaseTwo:AddPhase(self.TowerPhase)
	self.Grugonim.Triggers.PhaseFour = KBM.Trigger:Create(10, "percent", self.Grugonim)
	self.Grugonim.Triggers.PhaseFour:AddPhase(self.TowerPhase)
	
	self.Grugonim.CastBar = KBM.CastBar:Add(self, self.Grugonim, true)	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
	
	self:DefineMenu()
end