-- Warden Thrax Boss Mod for King Boss Mods
-- Written by Ivnedar
-- Copyright 2013
--

KBMSLRDPBWT_Settings = nil
chKBMSLRDPBWT_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PB = KBM.BossMod["RPlanebreaker_Bastion"]

local WTX = {
	Enabled = true,
	Directory = PB.Directory,
	File = "Thrax.lua",
	Instance = PB.Name,
	InstanceObj = PB,
	HasPhases = true,
	Lang = {},
	ID = "Thrax",
	Object = "WTX",
	TimeoutOverride = true,
	Timeout = 20,
	Enrage = 7 * 60,
}

KBM.RegisterMod(WTX.ID, WTX)

-- Main Unit Dictionary
WTX.Lang.Unit = {}
WTX.Lang.Unit.Thrax = KBM.Language:Add("Warden Thrax") -- ???
WTX.Lang.Unit.Thrax:SetFrench("Garde Thrax")
WTX.Lang.Unit.Thrax:SetGerman("Bewahrer Thrax")

-- Ability Dictionary
WTX.Lang.Ability = {}
WTX.Lang.Ability.Disturbance = KBM.Language:Add("Seismic Disturbance")
WTX.Lang.Ability.Disturbance:SetFrench("Perturbation sismique")
WTX.Lang.Ability.Disturbance:SetGerman("Seismische Störung")
WTX.Lang.Ability.Suppression = KBM.Language:Add("Suppression")
WTX.Lang.Ability.Suppression:SetFrench()
WTX.Lang.Ability.Suppression:SetGerman("Unterdrückung")
WTX.Lang.Ability.Rockslide = KBM.Language:Add("Rockslide")
WTX.Lang.Ability.Rockslide:SetFrench("Éboulement de pierres")
WTX.Lang.Ability.Rockslide:SetGerman("Bergsturz")
WTX.Lang.Ability.Transference = KBM.Language:Add("Tectonic Transference")
WTX.Lang.Ability.Transference:SetFrench("Transfert tectonique")
WTX.Lang.Ability.Transference:SetGerman("Tektonische Üertragung")
WTX.Lang.Ability.GTransference = KBM.Language:Add("Greater Tectonic Transference")
WTX.Lang.Ability.GTransference:SetFrench("Transfert tectonique majeur")
WTX.Lang.Ability.GTransference:SetGerman("Große Tektonische Üertragung")
WTX.Lang.Ability.Execution = KBM.Language:Add("Execution")
WTX.Lang.Ability.Execution:SetFrench("Exécution")
WTX.Lang.Ability.Execution:SetGerman("Hinrichtung")

-- Description Dictionary
WTX.Lang.Main = {}
WTX.Lang.Main.Encounter = KBM.Language:Add("Warden Thrax")
WTX.Lang.Main.Encounter:SetFrench("Garde Thrax")
WTX.Lang.Main.Encounter:SetGerman("Bewahrer Thrax")

-- Debuff Dictionary
WTX.Lang.Debuff = {}
WTX.Lang.Debuff.Fracture = KBM.Language:Add("Fracture")
WTX.Lang.Debuff.Fracture:SetGerman("Fraktur") -- Todo
WTX.Lang.Debuff.FractureID = "B4E7B63EC5C35EA56"
WTX.Lang.Debuff.Chain = KBM.Language:Add("Chain Gang")
WTX.Lang.Debuff.Chain:SetFrench("Esclavage")
WTX.Lang.Debuff.Chain:SetGerman("Sträflingskolonne")
WTX.Lang.Debuff.ChainID = "B0A2FB1C08CAD24B2"
 
-- Messages Dictionary
WTX.Lang.Messages = {}
WTX.Lang.Messages.MoveSoon = KBM.Language:Add("Move Soon")
WTX.Lang.Messages.MoveSoon:SetFrench("Déplacement Bientôt")
WTX.Lang.Messages.MoveSoon:SetGerman("Bald laufen")
WTX.Lang.Messages.MoveNow = KBM.Language:Add("Move Now!")
WTX.Lang.Messages.MoveNow:SetFrench("Déplacement Maintenant!")
WTX.Lang.Messages.MoveNow:SetGerman("Laufen jetzt!")
WTX.Lang.Messages.Knockback = KBM.Language:Add("Knockback Soon!")
WTX.Lang.Messages.Knockback:SetFrench("Repoussement Bientôt!")
WTX.Lang.Messages.Knockback:SetGerman("Rückstoß kommt!")
WTX.Lang.Debuff.FractureID = "B4E7B63EC5C35EA56"

WTX.Descript = WTX.Lang.Main.Encounter[KBM.Lang]

WTX.Thrax = {
	Mod = WTX,
	Level = "??",
	Active = false,
	Name = WTX.Lang.Unit.Thrax[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U35A6DC786F32286E",
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
			GTransference = KBM.Defaults.TimerObj.Create("red"),
			MoveSoon = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Chain = KBM.Defaults.AlertObj.Create("dark_green"),
			Rockslide = KBM.Defaults.AlertObj.Create("purple"),
			Execution = KBM.Defaults.AlertObj.Create("orange"),
			GTransferenceMove = KBM.Defaults.AlertObj.Create("red"),
			MoveSoon = KBM.Defaults.AlertObj.Create("yellow"),
			MoveNow = KBM.Defaults.AlertObj.Create("red"),
			Disturbance = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
			Enabled = true,
			Chain = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

function WTX:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Thrax.Name] = self.Thrax,
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

function WTX:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Thrax = {
			CastBar = self.Thrax.Settings.CastBar,
			TimersRef = self.Thrax.Settings.TimersRef,
			AlertsRef = self.Thrax.Settings.AlertsRef,
			MechRef = self.Thrax.Settings.MechRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDPBWT_Settings = self.Settings
	chKBMSLRDPBWT_Settings = self.Settings
	
end

function WTX:SwapSettings(bool)

	if bool then
		KBMSLRDPBWT_Settings = self.Settings
		self.Settings = chKBMSLRDPBWT_Settings
	else
		chKBMSLRDPBWT_Settings = self.Settings
		self.Settings = KBMSLRDPBWT_Settings
	end

end

function WTX:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDPBWT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDPBWT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDPBWT_Settings = self.Settings
	else
		KBMSLRDPBWT_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function WTX:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDPBWT_Settings = self.Settings
	else
		KBMSLRDPBWT_Settings = self.Settings
	end	
end

function WTX:Castbar(units)
end

function WTX:RemoveUnits(UnitID)
	if self.Thrax.UnitID == UnitID then
		self.Thrax.Available = false
		return true
	end
	return false
end

function WTX:Death(UnitID)
	if self.Thrax.UnitID == UnitID then
		self.Thrax.Dead = true
		return true
	end
	return false
end

function WTX:UnitHPCheck(uDetails, unitID)	
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
				self.Phase = 1
				self.PhaseObj.Objectives:AddPercent(self.Thrax, 0, 100)
				KBM.TankSwap:Start(self.Lang.Debuff.FractureID, unitID)
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

function WTX:Reset()
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

function WTX:Timer()	
end

function WTX:DefineMenu()
	self.Menu = WTX.Menu:CreateEncounter(self.Thrax, self.Enabled)
end

function WTX:Start()
	-- Create Timers
	self.Thrax.TimersRef.GTransference = KBM.MechTimer:Add(self.Lang.Ability.GTransference[KBM.Lang], 100, false)
	self.Thrax.TimersRef.GTransference:Wait()
	self.Thrax.TimersRef.MoveSoon = KBM.MechTimer:Add(self.Lang.Messages.MoveSoon[KBM.Lang], 15.5, false)
	KBM.Defaults.TimerObj.Assign(self.Thrax)

	-- Create Alerts
	self.Thrax.AlertsRef.Chain = KBM.Alert:Create(self.Lang.Debuff.Chain[KBM.Lang], nil, true, true, "dark_green")
	self.Thrax.AlertsRef.Rockslide = KBM.Alert:Create(self.Lang.Ability.Rockslide[KBM.Lang], 3, true, true, "purple")
	self.Thrax.AlertsRef.Execution = KBM.Alert:Create(self.Lang.Ability.Execution[KBM.Lang], nil, false, true, "orange")
	self.Thrax.AlertsRef.MoveNow = KBM.Alert:Create(self.Lang.Messages.MoveNow[KBM.Lang], 3, true, false, "red")
	self.Thrax.AlertsRef.MoveSoon = KBM.Alert:Create(self.Lang.Messages.MoveSoon[KBM.Lang], 15.5, false, true, "yellow")
	self.Thrax.AlertsRef.MoveSoon:AlertEnd(self.Thrax.AlertsRef.MoveNow)
	self.Thrax.AlertsRef.Disturbance = KBM.Alert:Create(self.Lang.Messages.Knockback[KBM.Lang], nil, true, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Thrax)

	--self.Thrax.TimersRef.MoveSoon:AddAlert(self.Thrax.AlertsRef.MoveNow, 0)

	-- Create Mechanic Spies
	self.Thrax.MechRef.Chain = KBM.MechSpy:Add(self.Lang.Debuff.Chain[KBM.Lang], nil, "playerDebuff", self.Thrax)
	KBM.Defaults.MechObj.Assign(self.Thrax)

	-- Assign Alerts and Timers for Triggers
	self.Thrax.Triggers.GTransference = KBM.Trigger:Create(self.Lang.Ability.GTransference[KBM.Lang], "cast", self.Thrax)
	self.Thrax.Triggers.GTransference:AddTimer(self.Thrax.TimersRef.GTransference)

	self.Thrax.Triggers.MoveSoon = KBM.Trigger:Create(self.Lang.Ability.GTransference[KBM.Lang], "channel", self.Thrax)
	self.Thrax.Triggers.MoveSoon:AddTimer(self.Thrax.TimersRef.MoveSoon)

	self.Thrax.Triggers.Chain = KBM.Trigger:Create(self.Lang.Debuff.Chain[KBM.Lang], "playerDebuff", self.Thrax)
	self.Thrax.Triggers.Chain:AddAlert(self.Thrax.AlertsRef.Chain, true)
	self.Thrax.Triggers.Chain:AddSpy(self.Thrax.MechRef.Chain)

	self.Thrax.Triggers.Rockslide = KBM.Trigger:Create(self.Lang.Ability.Rockslide[KBM.Lang], "cast", self.Thrax)
	self.Thrax.Triggers.Rockslide:AddAlert(self.Thrax.AlertsRef.Rockslide)

	self.Thrax.Triggers.Execution = KBM.Trigger:Create(self.Lang.Ability.Execution[KBM.Lang], "channel", self.Thrax)
	self.Thrax.Triggers.Execution:AddAlert(self.Thrax.AlertsRef.Execution)
	
	self.Thrax.Triggers.Disturbance = KBM.Trigger:Create(self.Lang.Ability.Disturbance[KBM.Lang], "cast", self.Thrax)
	self.Thrax.Triggers.Disturbance:AddAlert(self.Thrax.AlertsRef.Disturbance)

	self.Thrax.CastBar = KBM.Castbar:Add(self, self.Thrax)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
end