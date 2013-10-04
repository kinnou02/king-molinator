-- Breaker X-1 "Onyx" Boss Mod for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDIGBX_Settings = nil
chKBMSLRDIGBX_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IG = KBM.BossMod["RInfinity_Gate"]

local BXO = {
	Enabled = true,
	Directory = IG.Directory,
	File = "BreakerX1.lua",
	Instance = IG.Name,
	InstanceObj = IG,
	HasPhases = true,
	Lang = {},
	ID = "BreakerX1",
	Object = "BXO",
	Enrage = 9 * 60,
}

KBM.RegisterMod(BXO.ID, BXO)

-- Main Unit Dictionary
BXO.Lang.Unit = {}
BXO.Lang.Unit.BreakerX1 = KBM.Language:Add("Breaker X-1 \"Onyx\"") -- U4EA7C88766C1B6B9
BXO.Lang.Unit.BreakerX1:SetGerman("Brecher X-1 \"Onyx\"")
BXO.Lang.Unit.CoreAlpha = KBM.Language:Add("Core Systems Routine Alpha") -- U01D9CC8C1FF2D603
BXO.Lang.Unit.Colossus = KBM.Language:Add("Irradiated Colossus") -- U44B144E14DCEBE34

-- Ability Dictionary
BXO.Lang.Ability = {}
BXO.Lang.Ability.Disruptor = KBM.Language:Add("Quantum Disruptor")
BXO.Lang.Ability.Disruptor:SetGerman("Quantum Störer")

-- Description Dictionary
BXO.Lang.Main = {}

-- Debuff Dictionary
BXO.Lang.Debuff = {}
BXO.Lang.Debuff.Fission = KBM.Language:Add("Fission Burst")
BXO.Lang.Debuff.Fission:SetGerman("Kernexplosion")
BXO.Lang.Debuff.FissionID = "B515B723DE6ADCB47"
BXO.Lang.Debuff.Decay = KBM.Language:Add("Ionic Decay")
BXO.Lang.Debuff.Decay:SetGerman("Ionische Verwesung")
BXO.Lang.Debuff.DecayID = "B4BD63B7F078EA6FB"
BXO.Lang.Debuff.Distortion = KBM.Language:Add("Kinetic Distortion")
BXO.Lang.Debuff.Distortion:SetGerman("Kinetische Verzerrung")
BXO.Lang.Debuff.DistortionID = "B5B9A68A148310AA5"

-- Messages Dictionary
BXO.Lang.Messages = {}

BXO.Descript = BXO.Lang.Unit.BreakerX1[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
BXO.BreakerX1 = {
	Mod = BXO,
	Level = "??",
	Active = false,
	Name = BXO.Lang.Unit.BreakerX1[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U4EA7C88766C1B6B9",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
		},
		AlertsRef = {
			Enabled = true,
			Decay = KBM.Defaults.AlertObj.Create("cyan"),
			Disruptor = KBM.Defaults.AlertObj.Create("yellow"),
			Distortion = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Decay = KBM.Defaults.MechObj.Create("cyan"),
			Distortion = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

function BXO:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.BreakerX1.Name] = self.BreakerX1,
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

function BXO:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		BreakerX1 = {
			CastBar = self.BreakerX1.Settings.CastBar,
			AlertsRef = self.BreakerX1.Settings.AlertsRef,
			TimersRef = self.BreakerX1.Settings.TimersRef,
			MechRef = self.BreakerX1.Settings.MechRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDIGBX_Settings = self.Settings
	chKBMSLRDIGBX_Settings = self.Settings
	
end

function BXO:SwapSettings(bool)

	if bool then
		KBMSLRDIGBX_Settings = self.Settings
		self.Settings = chKBMSLRDIGBX_Settings
	else
		chKBMSLRDIGBX_Settings = self.Settings
		self.Settings = KBMSLRDIGBX_Settings
	end

end

function BXO:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDIGBX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDIGBX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDIGBX_Settings = self.Settings
	else
		KBMSLRDIGBX_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function BXO:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDIGBX_Settings = self.Settings
	else
		KBMSLRDIGBX_Settings = self.Settings
	end	
end

function BXO:Castbar(units)
end

function BXO:RemoveUnits(UnitID)
	if self.BreakerX1.UnitID == UnitID then
		self.BreakerX1.Available = false
		return true
	end
	return false
end

function BXO:Death(UnitID)
	if self.BreakerX1.UnitID == UnitID then
		self.BreakerX1.Dead = true
		return true
	end
	return false
end

function BXO:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.CastBar then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.BreakerX1, 0, 100)
				self.Phase = 1
				KBM.TankSwap:Start(self.Lang.Debuff.FissionID, unitID)
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

function BXO:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function BXO:Timer()	
end

function BXO:DefineMenu()
	self.Menu = IG.Menu:CreateEncounter(self.BreakerX1, self.Enabled)
end

function BXO:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.BreakerX1)
	
	-- Create Alerts
	self.BreakerX1.AlertsRef.Disruptor = KBM.Alert:Create(self.Lang.Ability.Disruptor[KBM.Lang], nil, true, true, "yellow")
	self.BreakerX1.AlertsRef.Distortion = KBM.Alert:Create(self.Lang.Debuff.Distortion[KBM.Lang], nil, true, true, "red")
	self.BreakerX1.AlertsRef.Decay = KBM.Alert:Create(self.Lang.Debuff.Decay[KBM.Lang], nil, false, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.BreakerX1)

	-- Create Mechanic Spies (BreakerX1)
	self.BreakerX1.MechRef.Decay = KBM.MechSpy:Add(self.Lang.Debuff.Decay[KBM.Lang], nil, "playerDebuff", self.BreakerX1)
	self.BreakerX1.MechRef.Distortion = KBM.MechSpy:Add(self.Lang.Debuff.Distortion[KBM.Lang], nil, "playerDebuff", self.BreakerX1)
	KBM.Defaults.MechObj.Assign(self.BreakerX1)

	-- Assign Alerts and Timers to Triggers
	self.BreakerX1.Triggers.Decay = KBM.Trigger:Create(self.Lang.Debuff.DecayID, "playerIDBuff", self.BreakerX1)
	self.BreakerX1.Triggers.Decay:AddAlert(self.BreakerX1.AlertsRef.Decay, true)
	self.BreakerX1.Triggers.Decay:AddSpy(self.BreakerX1.MechRef.Decay)
	self.BreakerX1.Triggers.DecayRem = KBM.Trigger:Create(self.Lang.Debuff.DecayID, "playerIDBuffRemove", self.BreakerX1)
	self.BreakerX1.Triggers.DecayRem:AddStop(self.BreakerX1.MechRef.Decay)
	self.BreakerX1.Triggers.Distortion = KBM.Trigger:Create(self.Lang.Debuff.DistortionID, "playerIDBuff", self.BreakerX1)
	self.BreakerX1.Triggers.Distortion:AddAlert(self.BreakerX1.AlertsRef.Distortion, true)

	self.BreakerX1.Triggers.Disruptor = KBM.Trigger:Create(self.Lang.Ability.Disruptor[KBM.Lang], "cast", self.BreakerX1)
	self.BreakerX1.Triggers.Disruptor:AddAlert(self.BreakerX1.AlertsRef.Disruptor)
	self.BreakerX1.Triggers.DisruptorInt = KBM.Trigger:Create(self.Lang.Ability.Disruptor[KBM.Lang], "interrupt", self.BreakerX1)
	self.BreakerX1.Triggers.DisruptorInt:AddStop(self.BreakerX1.AlertsRef.Disruptor)
	
	self.BreakerX1.CastBar = KBM.Castbar:Add(self, self.BreakerX1)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end