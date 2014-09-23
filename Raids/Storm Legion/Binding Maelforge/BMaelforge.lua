-- Maelforge Boss Mod for King Boss Mods
-- Written by Lifeismystery
-- Copyright 2014
--

KBMSLRDBMMLF_Settings = nil
chKBMSLRDBMMLF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BM = KBM.BossMod["RBinding_Maelforge"]

local MLF = {
	Enabled = true,
	Directory = BM.Directory,
	File = "BMaelforge.lua",
	Instance = BM.Name,
	InstanceObj = BM,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 13,	
	ID = "BMaelforge",
	Object = "MLF",
}

MLF.Maelforge = {
	Mod = MLF,
	Level = "??",
	Active = false,
	Name = "Maelforge",
	NameShort = "Maelforge",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U070BF8B77ED0A8FA",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			BlindingLight = KBM.Defaults.TimerObj.Create("blue"),
			InfernalSeed = KBM.Defaults.TimerObj.Create("dark_green"),
			Implosion = KBM.Defaults.TimerObj.Create("orange"),

		},
		AlertsRef = {
			Enabled = true,
			BlindingLight = KBM.Defaults.AlertObj.Create("blue"),
			InfernalSeed = KBM.Defaults.AlertObj.Create("dark_green"),
			Implosion = KBM.Defaults.AlertObj.Create("orange"),
			CinderStorm = KBM.Defaults.AlertObj.Create("cyan"),
			PulsarField = KBM.Defaults.AlertObj.Create("dark_green"),
			RagingInferno = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Destroy = KBM.Defaults.MechObj.Create("yellow"),
			CinderStorm = KBM.Defaults.MechObj.Create("cyan"),
			PulsarField = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

KBM.RegisterMod(MLF.ID, MLF)

-- Main Unit Dictionary
MLF.Lang.Unit = {}
MLF.Lang.Unit.Maelforge = KBM.Language:Add(MLF.Maelforge.Name)
MLF.Lang.Unit.Maelforge:SetFrench("Maelforge")


-- Unit Dictionary
MLF.Lang.Unit.TritiumCore = KBM.Language:Add("Tritium Core")
MLF.Lang.Unit.PyroniteDemon = KBM.Language:Add("Pyronite Demon")

-- Ability Dictionary
MLF.Lang.Ability = {}
MLF.Lang.Ability.BlindingLight = KBM.Language:Add("Blinding Light")
MLF.Lang.Ability.InfernalSeed = KBM.Language:Add("Infernal Seed")
MLF.Lang.Ability.Implosion = KBM.Language:Add("Implosion")

-- Description Dictionary
MLF.Lang.Main = {}
MLF.Lang.Main.Descript = KBM.Language:Add("Maelforge")
MLF.Descript = MLF.Lang.Main.Descript[KBM.Lang]

-- Menu Dictionary
MLF.Lang.Menu = {}
MLF.Lang.Menu.BlindingLight = KBM.Language:Add("Blinding Light")
MLF.Lang.Menu.InfernalSeed = KBM.Language:Add("Infernal Seed")
MLF.Lang.Menu.Implosion = KBM.Language:Add("Implosion")

--Mechanic Dictionary (Verbose)
MLF.Maelforge.Name = MLF.Lang.Unit.Maelforge[KBM.Lang]
MLF.Descript = MLF.Maelforge.Name

-- Mechanic Dictionary
MLF.Lang.Mechanic = {}

-- Debuff Dictionary
MLF.Lang.Debuff = {}
MLF.Lang.Debuff.CinderStorm = KBM.Language:Add("Cinder Storm")
MLF.Lang.Debuff.PulsarField = KBM.Language:Add("Pulsar Field")

-- Notify Dictionary
MLF.Lang.Notify = {}
MLF.Lang.Notify.Destroy = KBM.Language:Add("Maelforge prepares to destroy (%a+)%!")

-- Messages Dictionary
MLF.Lang.Messages = {}
MLF.Lang.Messages.Destroy = KBM.Language:Add("Move from:")
MLF.Lang.Messages.BlindingLight = KBM.Language:Add("Turn away!")

-- Buff Dictionary
MLF.Lang.Buff = {}
MLF.Lang.Buff.RagingInferno = KBM.Language:Add("Raging Inferno")

-- Verbose Dictionary
MLF.Lang.Verbose = {}
MLF.Lang.Verbose.RagingInferno = KBM.Language:Add("PURGE!!!!!!!")

function MLF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maelforge.Name] = self.Maelforge
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

function MLF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maelforge.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Maelforge.Settings.TimersRef,
		AlertsRef = self.Maelforge.Settings.AlertsRef,
	}
	KBMSLRDBMMLF_Settings = self.Settings
	chKBMSLRDBMMLF_Settings = self.Settings	
end

function MLF:SwapSettings(bool)
	if bool then
		KBMSLRDBMMLF_Settings = self.Settings
		self.Settings = chKBMSLRDBMMLF_Settings
	else
		chKBMSLRDBMMLF_Settings = self.Settings
		self.Settings = KBMSLRDBMMLF_Settings
	end
end

function MLF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBMMLF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBMMLF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBMMLF_Settings = self.Settings
	else
		KBMSLRDBMMLF_Settings = self.Settings
	end	
end

function MLF:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBMMLF_Settings = self.Settings
	else
		KBMSLRDBMMLF_Settings = self.Settings
	end	
end

function MLF:Castbar(units)
end

function MLF:RemoveUnits(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Available = false
		return true
	end
	return false
end

function MLF:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj == self.Maelforge then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.UnitID = unitID
				BossObj.Dead = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.Phase = 1
				self.LastPhase = 2
				self.PhaseObj:SetPhase(1)
				self.PhaseObj.Objectives:AddPercent(self.Maelforge, 80, 100)
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MLF.PhaseTwo()
	MLF.PhaseObj.Objectives:Remove()
	MLF.Phase = 2
	MLF.PhaseObj:SetPhase(2)
	MLF.PhaseObj.Objectives:AddPercent(MLF.Maelforge, 60, 80)
end

function MLF.PhaseThree()
	MLF.PhaseObj.Objectives:Remove()
	MLF.Phase = 3
	MLF.PhaseObj:SetPhase(3)
	MLF.PhaseObj.Objectives:AddPercent(MLF.Maelforge, 30, 60)	
end

function MLF.PhaseFour()
	MLF.PhaseObj.Objectives:Remove()
	MLF.Phase = 4
	MLF.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MLF.PhaseObj.Objectives:AddPercent(MLF.Maelforge, 0, 30)
end

function MLF:Death(UnitID)
	if self.Maelforge.UnitID == UnitID then
		self.Maelforge.Dead = true
		return true
	end
	return false
end

function MLF:Reset()
	self.EncounterRunning = false
	self.Maelforge.Available = false
	self.Maelforge.UnitID = nil
	self.Maelforge.CastBar:Remove()
	self.Maelforge.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function MLF:Timer()	
end

function MLF:DefineMenu()
	self.Menu = MLF.Menu:CreateEncounter(self.Maelforge, self.Enabled)
end

function MLF:Start()
	-- Create Timers
	self.Maelforge.TimersRef.InfernalSeed = KBM.MechTimer:Add(self.Lang.Ability.InfernalSeed[KBM.Lang], 30)
	self.Maelforge.TimersRef.Implosion = KBM.MechTimer:Add(self.Lang.Ability.Implosion[KBM.Lang], 69)
	self.Maelforge.TimersRef.BlindingLight = KBM.MechTimer:Add(self.Lang.Ability.BlindingLight[KBM.Lang], 90)	
	KBM.Defaults.TimerObj.Assign(self.Maelforge)

	-- Create Mechanic Spies
	self.Maelforge.MechRef.CinderStorm = KBM.MechSpy:Add(self.Lang.Debuff.CinderStorm[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	self.Maelforge.MechRef.PulsarField = KBM.MechSpy:Add(self.Lang.Debuff.PulsarField[KBM.Lang], nil, "playerDebuff", self.Maelforge)
	self.Maelforge.MechRef.Destroy = KBM.MechSpy:Add(self.Lang.Messages.Destroy[KBM.Lang], 4, "mechanic", self.Maelforge)
	KBM.Defaults.MechObj.Assign(self.Maelforge)	

	-- Create Alerts
	self.Maelforge.AlertsRef.BlindingLight = KBM.Alert:Create(self.Lang.Ability.BlindingLight[KBM.Lang], nil, false, true, "blue")
	self.Maelforge.AlertsRef.InfernalSeed = KBM.Alert:Create(self.Lang.Ability.InfernalSeed[KBM.Lang], nil, true, true, "dark_green")
	self.Maelforge.AlertsRef.Implosion = KBM.Alert:Create(self.Lang.Ability.Implosion[KBM.Lang], nil, false, true, "orange")
	self.Maelforge.AlertsRef.RagingInferno = KBM.Alert:Create(self.Lang.Verbose.RagingInferno[KBM.Lang], nil, false, true, "red")
	
	KBM.Defaults.AlertObj.Assign(self.Maelforge)
	
	-- Assign Timers and Alerts to Triggers
	
	self.Maelforge.Triggers.InfernalSeed = KBM.Trigger:Create(self.Lang.Ability.InfernalSeed[KBM.Lang], "cast", self.Maelforge)
	self.Maelforge.Triggers.InfernalSeed:AddTimer(self.Maelforge.TimersRef.InfernalSeed)
	self.Maelforge.Triggers.InfernalSeed:AddAlert(self.Maelforge.AlertsRef.InfernalSeed)
	
	self.Maelforge.Triggers.BlindingLight = KBM.Trigger:Create(self.Lang.Ability.BlindingLight[KBM.Lang], "cast", self.Maelforge)
	self.Maelforge.Triggers.BlindingLight:AddAlert(self.Maelforge.AlertsRef.BlindingLight)
	
	self.Maelforge.Triggers.Implosion = KBM.Trigger:Create(self.Lang.Ability.Implosion[KBM.Lang], "cast", self.Maelforge)
	self.Maelforge.Triggers.Implosion:AddAlert(self.Maelforge.AlertsRef.Implosion)
	
	self.Maelforge.Triggers.RagingInferno = KBM.Trigger:Create(self.Lang.Buff.RagingInferno[KBM.Lang], "buff", self.Maelforge)
	self.Maelforge.Triggers.RagingInferno:AddAlert(self.Maelforge.AlertsRef.RagingInferno)
	
	self.Maelforge.Triggers.CinderStorm = KBM.Trigger:Create(self.Lang.Debuff.CinderStorm[KBM.Lang], "playerBuff", self.Maelforge)
	--self.Maelforge.Triggers.CinderStorm:AddAlert(self.Maelforge.AlertsRef.CinderStorm, true)
	self.Maelforge.Triggers.CinderStorm:AddSpy(self.Maelforge.MechRef.CinderStorm)
	self.Maelforge.Triggers.CinderStormRem = KBM.Trigger:Create(self.Lang.Debuff.CinderStorm[KBM.Lang], "playerBuffRemove", self.Maelforge)
	self.Maelforge.Triggers.CinderStormRem:AddStop(self.Maelforge.MechRef.CinderStorm)
	
	self.Maelforge.Triggers.PulsarField = KBM.Trigger:Create(self.Lang.Debuff.PulsarField[KBM.Lang], "playerBuff", self.Maelforge)
	--self.Maelforge.Triggers.PulsarField:AddAlert(self.Maelforge.AlertsRef.PulsarField, true)
	self.Maelforge.Triggers.PulsarField:AddSpy(self.Maelforge.MechRef.PulsarField)
	self.Maelforge.Triggers.PulsarFieldRem = KBM.Trigger:Create(self.Lang.Debuff.PulsarField[KBM.Lang], "playerBuffRemove", self.Maelforge)
	self.Maelforge.Triggers.PulsarFieldRem:AddStop(self.Maelforge.MechRef.PulsarField)
	
	self.Maelforge.Triggers.Destroy = KBM.Trigger:Create(self.Lang.Notify.Destroy[KBM.Lang], "notify", self.Maelforge)
	--self.Maelforge.Triggers.Destroy:AddAlert(self.Maelforge.AlertsRef.Destroy, true)
	self.Maelforge.Triggers.Destroy:AddSpy(self.Maelforge.MechRef.Destroy)
	
	self.Maelforge.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	
	self.Maelforge.Triggers.PhaseThree = KBM.Trigger:Create(60, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	
	self.Maelforge.Triggers.PhaseFour = KBM.Trigger:Create(30, "percent", self.Maelforge)
	self.Maelforge.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	self.Maelforge.CastBar = KBM.Castbar:Add(self, self.Maelforge)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end