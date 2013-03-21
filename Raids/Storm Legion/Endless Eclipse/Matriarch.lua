-- Matriarch of Pestilence Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDEEMP_Settings = nil
chKBMSLRDEEMP_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local EE = KBM.BossMod["REndless_Eclipse"]

local MOP = {
	Enabled = true,
	Directory = EE.Directory,
	File = "Matriarch.lua",
	Instance = EE.Name,
	InstanceObj = EE,
	HasPhases = true,
	Lang = {},
	ID = "RMatriarch_of_Pestilence",
	Object = "MOP",
	Enrage = 7 * 60,
}

KBM.RegisterMod(MOP.ID, MOP)

-- Main Unit Dictionary
MOP.Lang.Unit = {}
MOP.Lang.Unit.Matriarch = KBM.Language:Add("Matriarch of Pestilence")
MOP.Lang.Unit.Matriarch:SetGerman("Matriarchin der Pestilenz")
MOP.Lang.Unit.Matriarch:SetFrench("Matriarche pestilentielle")
MOP.Lang.Unit.MatriarchShort = KBM.Language:Add("Matriarch")
MOP.Lang.Unit.MatriarchShort:SetGerman("Matriarchin")
MOP.Lang.Unit.MatriarchShort:SetFrench("Matriarche")

-- Ability Dictionary
MOP.Lang.Ability = {}
MOP.Lang.Ability.Wave = KBM.Language:Add("Wave of Decay")
MOP.Lang.Ability.Wave:SetGerman("Welle der Verwesung")
MOP.Lang.Ability.Wave:SetFrench("Vague de putréfaction")
MOP.Lang.Ability.Doom = KBM.Language:Add("Sudden Doom")
MOP.Lang.Ability.Doom:SetFrench("Condamnation soudaine")

-- Messages Dictionary
MOP.Lang.Messages = {}
MOP.Lang.Messages.Spores = KBM.Language:Add("Matriarch of Pestilence covers (%a*) with Necrotic Spores!")
MOP.Lang.Messages.Spores:SetFrench("Matriarche pestilentielle recouvre (%a*) de Spores nécrotiques !")
MOP.Lang.Messages.Infect = KBM.Language:Add("Matriarch of Pestilence infects (%a*) with an unholy disease!")
MOP.Lang.Messages.Infect:SetFrench("Matriarche pestilentielle infecte (%a*) en lui transmettant une maladie impie !")
MOP.Lang.Messages.ChildeSpawn = KBM.Language:Add("You shall sate the hunger of my children!")
MOP.Lang.Messages.ChildeSpawn:SetFrench("Vous assouvirez l'appétit de mes petits !")

-- Debuff Dictionary
MOP.Lang.Debuff = {}
MOP.Lang.Debuff.Spores = KBM.Language:Add("Necrotic Spores")
MOP.Lang.Debuff.Spores:SetGerman("Nekrotische Sporen")
MOP.Lang.Debuff.Spores:SetFrench("Spores nécrotiques")
MOP.Lang.Debuff.Infect = KBM.Language:Add("Volatile Infection")
MOP.Lang.Debuff.Infect:SetGerman("Flüchtige Infektion")
MOP.Lang.Debuff.Infect:SetFrench("Infection volatile")
MOP.Lang.Debuff.Ichor = KBM.Language:Add("Dark Ichor")
MOP.Lang.Debuff.Ichor:SetFrench("Pourriture noire")
MOP.Lang.Debuff.Torment = KBM.Language:Add("Torment")
MOP.Lang.Debuff.Torment:SetFrench("Tourmente")

-- Description Dictionary
MOP.Lang.Main = {}

MOP.Descript = MOP.Lang.Unit.Matriarch[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
MOP.Matriarch = {
	Mod = MOP,
	Level = "??",
	Active = false,
	Name = MOP.Lang.Unit.Matriarch[KBM.Lang],
	NameShort = MOP.Lang.Unit.MatriarchShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFF3F18BC4F5ACD62",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Wave = KBM.Defaults.TimerObj.Create("yellow"),
			Doom = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Spores = KBM.Defaults.AlertObj.Create("dark_green"),
			Infect = KBM.Defaults.AlertObj.Create("red"),
			Wave = KBM.Defaults.AlertObj.Create("yellow"),
		},
		MechRef = {
			Enabled = true,
			Spores = KBM.Defaults.MechObj.Create("dark_green"),
			Infect = KBM.Defaults.MechObj.Create("red"),
			Torment = KBM.Defaults.MechObj.Create("pink"),
		},
	}
}

function MOP:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Matriarch.Name] = self.Matriarch,
	}
end

function MOP:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Matriarch.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Matriarch.Settings.TimersRef,
		AlertsRef = self.Matriarch.Settings.AlertsRef,
		MechRef = self.Matriarch.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMSLRDEEMP_Settings = self.Settings
	chKBMSLRDEEMP_Settings = self.Settings
	
end

function MOP:SwapSettings(bool)

	if bool then
		KBMSLRDEEMP_Settings = self.Settings
		self.Settings = chKBMSLRDEEMP_Settings
	else
		chKBMSLRDEEMP_Settings = self.Settings
		self.Settings = KBMSLRDEEMP_Settings
	end

end

function MOP:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDEEMP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDEEMP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDEEMP_Settings = self.Settings
	else
		KBMSLRDEEMP_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function MOP:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDEEMP_Settings = self.Settings
	else
		KBMSLRDEEMP_Settings = self.Settings
	end	
end

function MOP:Castbar(units)
end

function MOP:RemoveUnits(UnitID)
	if self.Matriarch.UnitID == UnitID then
		self.Matriarch.Available = false
		return true
	end
	return false
end

function MOP:Death(UnitID)
	if self.Matriarch.UnitID == UnitID then
		self.Matriarch.Dead = true
		return true
	end
	return false
end

function MOP:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Matriarch then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Matriarch, 0, 100)
				self.Phase = 1
				KBM.TankSwap:Start(self.Lang.Debuff.Ichor[KBM.Lang], unitID)
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Matriarch then
					if BossObj.UnitID ~= unitID then
						BossObj.CastBar:Remove()
					end
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function MOP:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Matriarch.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOP:Timer()	
end

function MOP:DefineMenu()
	self.Menu = EE.Menu:CreateEncounter(self.Matriarch, self.Enabled)
end

function MOP:Start()
	-- Create Timers
	self.Matriarch.TimersRef.Wave = KBM.MechTimer:Add(MOP.Lang.Ability.Wave[KBM.Lang], 5, false)
	self.Matriarch.TimersRef.Doom = KBM.MechTimer:Add(MOP.Lang.Ability.Doom[KBM.Lang], 30, false)
	KBM.Defaults.TimerObj.Assign(self.Matriarch)
	
	-- Create Alerts
	self.Matriarch.AlertsRef.Spores = KBM.Alert:Create(self.Lang.Debuff.Spores[KBM.Lang], nil, true, true, "dark_green")
	self.Matriarch.AlertsRef.Infect = KBM.Alert:Create(self.Lang.Debuff.Infect[KBM.Lang], nil, false, true, "red")
	self.Matriarch.AlertsRef.Infect:Important()
	self.Matriarch.AlertsRef.Wave = KBM.Alert:Create(self.Lang.Ability.Wave[KBM.Lang], nil, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Matriarch)

	-- Create Spies
	self.Matriarch.MechRef.Spores = KBM.MechSpy:Add(self.Lang.Debuff.Spores[KBM.Lang], nil, "playerDebuff", self.Matriarch)
	self.Matriarch.MechRef.Infect = KBM.MechSpy:Add(self.Lang.Debuff.Infect[KBM.Lang], nil, "playerDebuff", self.Matriarch)
	self.Matriarch.MechRef.Torment = KBM.MechSpy:Add(self.Lang.Debuff.Torment[KBM.Lang], nil, "playerDebuff", self.Matriarch)
	KBM.Defaults.MechObj.Assign(self.Matriarch)
	
	-- Assign Alerts and Timers to Triggers
	self.Matriarch.Triggers.Spores = KBM.Trigger:Create(self.Lang.Debuff.Spores[KBM.Lang], "playerDebuff", self.Matriarch)
	self.Matriarch.Triggers.Spores:AddAlert(self.Matriarch.AlertsRef.Spores, true)
	self.Matriarch.Triggers.Spores:AddSpy(self.Matriarch.MechRef.Spores)
	self.Matriarch.Triggers.SporesN = KBM.Trigger:Create(self.Lang.Messages.Spores[KBM.Lang], "notify", self.Matriarch)
	self.Matriarch.Triggers.SporesN:AddAlert(self.Matriarch.AlertsRef.Spores, true)
	self.Matriarch.Triggers.SporesN:AddSpy(self.Matriarch.MechRef.Spores)
	self.Matriarch.Triggers.SporesRem = KBM.Trigger:Create(self.Lang.Debuff.Spores[KBM.Lang], "playerBuffRemove", self.Matriarch)
	self.Matriarch.Triggers.SporesRem:AddStop(self.Matriarch.AlertsRef.Spores)
	self.Matriarch.Triggers.Infect = KBM.Trigger:Create(self.Lang.Debuff.Infect[KBM.Lang], "playerDebuff", self.Matriarch)
	self.Matriarch.Triggers.Infect:AddAlert(self.Matriarch.AlertsRef.Infect, true)
	self.Matriarch.Triggers.Infect:AddSpy(self.Matriarch.MechRef.Infect)
	self.Matriarch.Triggers.InfectN = KBM.Trigger:Create(self.Lang.Messages.Infect[KBM.Lang], "notify", self.Matriarch)
	self.Matriarch.Triggers.InfectN:AddAlert(self.Matriarch.AlertsRef.Infect, true)
	self.Matriarch.Triggers.InfectN:AddSpy(self.Matriarch.MechRef.Infect)
	self.Matriarch.Triggers.Wave = KBM.Trigger:Create(self.Lang.Ability.Wave[KBM.Lang], "cast", self.Matriarch)
	self.Matriarch.Triggers.Wave:AddTimer(self.Matriarch.TimersRef.Wave)
	self.Matriarch.Triggers.Wave:AddAlert(self.Matriarch.AlertsRef.Wave)
	self.Matriarch.Triggers.WaveInt = KBM.Trigger:Create(self.Lang.Ability.Wave[KBM.Lang], "interrupt", self.Matriarch)
	self.Matriarch.Triggers.WaveInt:AddStop(self.Matriarch.AlertsRef.Wave)
	self.Matriarch.Triggers.Torment = KBM.Trigger:Create(self.Lang.Debuff.Torment[KBM.Lang], "playerDebuff", self.Matriarch)
	self.Matriarch.Triggers.Torment:AddSpy(self.Matriarch.MechRef.Torment)
	self.Matriarch.Triggers.Doom = KBM.Trigger:Create(self.Lang.Ability.Doom[KBM.Lang], "cast", self.Matriarch)
	self.Matriarch.Triggers.Doom:AddTimer(self.Matriarch.TimersRef.Doom)
	
	self.Matriarch.CastBar = KBM.CastBar:Add(self, self.Matriarch)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end