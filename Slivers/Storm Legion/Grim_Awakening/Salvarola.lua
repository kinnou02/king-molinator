-- Salvarola Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLGASAL_Settings = nil
chKBMSLSLGASAL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GA = KBM.BossMod["SGrim_Awakening"]

local SAL = {
	Directory = GA.Directory,
	File = "Salvarola.lua",
	Enabled = true,
	Instance = GA.Name,
	InstanceObj = GA,
	Lang = {},
	Enrage = (5 * 60) + 30,
	ID = "SSalvarola",
	Object = "SAL",
}

KBM.RegisterMod(SAL.ID, SAL)

-- Main Unit Dictionary
SAL.Lang.Unit = {}
SAL.Lang.Unit.Salvarola = KBM.Language:Add("Salvarola")
SAL.Lang.Unit.Salvarola:SetFrench("Salvarola")
SAL.Lang.Unit.Salvarola:SetGerman("Salvarola")
SAL.Lang.Unit.Spark = KBM.Language:Add("Spark of Thought")
SAL.Lang.Unit.Spark:SetFrench("Étincelle de pensée")
SAL.Lang.Unit.Spark:SetGerman("Gedankenblitz")
SAL.Lang.Unit.SparkShort = KBM.Language:Add("Spark")
SAL.Lang.Unit.SparkShort:SetFrench("Étincelle")
SAL.Lang.Unit.SparkShort:SetGerman("Gedankenblitz")
SAL.Lang.Unit.Blood = KBM.Language:Add("Lord of Blood")
SAL.Lang.Unit.Blood:SetFrench("Seigneur des Flammes")
SAL.Lang.Unit.Flames = KBM.Language:Add("Lord of Flames")
SAL.Lang.Unit.Flames:SetFrench("Seigneur du Sang")
SAL.Lang.Unit.Fanatic = KBM.Language:Add("Warped Fanatic")
SAL.Lang.Unit.Fanatic:SetFrench("Fanatique perverti")

-- Ability Dictionary
SAL.Lang.Ability = {}
SAL.Lang.Ability.Incineration = KBM.Language:Add("Soul Incineration")
SAL.Lang.Ability.Incineration:SetFrench("Incinération d'âme")
SAL.Lang.Ability.Incineration:SetGerman("Seelenverbrennung")

-- Verbose Dictionary
SAL.Lang.Verbose = {}

-- Buff Dictionary
SAL.Lang.Buff = {}
SAL.Lang.Buff.Power = KBM.Language:Add("Overwhelming Power")
SAL.Lang.Buff.Power:SetFrench("Puissance submergeante")

-- Debuff Dictionary
SAL.Lang.Debuff = {}
SAL.Lang.Debuff.Bloodboil = KBM.Language:Add("Bloodboil")
SAL.Lang.Debuff.Bloodboil:SetFrench("Ébullation sanglante")
SAL.Lang.Debuff.Bloodboil:SetGerman("Blutgeschwür")
SAL.Lang.Debuff.BloodboilID = "B6D7DCF642AF39C2C"
SAL.Lang.Debuff.Mindsear = KBM.Language:Add("Mindsear")
SAL.Lang.Debuff.Mindsear:SetFrench("Incandesprit")
SAL.Lang.Debuff.Mindsear:SetGerman("Geistesohr")
SAL.Lang.Debuff.MindsearID = "B4C023E009A6B6FF8"
SAL.Lang.Debuff.Magma = KBM.Language:Add("Curse of Magma")

-- Description Dictionary
SAL.Lang.Main = {}

SAL.Descript = SAL.Lang.Unit.Salvarola[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
SAL.Salvarola = {
	Mod = SAL,
	Level = "??",
	Active = false,
	Name = SAL.Lang.Unit.Salvarola[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U7252154B0F81EE7E",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Incineration = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Incineration = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Mindsear = KBM.Defaults.MechObj.Create("dark_green"),
			Magma = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

SAL.Blood = {
	Mod = SAL,
	Level = "??",
	Name = SAL.Lang.Unit.Blood[KBM.Lang],
	Ignore = true,
	UTID = "none",
}

SAL.Flames = {
	Mod = SAL,
	Level = "??",
	Name = SAL.Lang.Unit.Flames[KBM.Lang],
	Ignore = true,
	UTID = "none",
}

--SAL.Spark = {
--	Mod = SAL,
--	Level = "??",
--	Name = SAL.Lang.Unit.Spark[KBM.Lang],
--	NameShort = SAL.Lang.Unit.SparkShort[KBM.Lang],
--	UnitList = {},
--	Ignore = true,
--	UTID = "U750B79AF4D5BC450",
--	Type = "multi",
--}

function SAL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Salvarola.Name] = self.Salvarola,
		--[self.Spark.Name] = self.Spark,
	}
end

function SAL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Salvarola.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Salvarola.Settings.TimersRef,
		AlertsRef = self.Salvarola.Settings.AlertsRef,
		MechRef = self.Salvarola.Settings.MechRef,
	}
	KBMSLSLGASAL_Settings = self.Settings
	chKBMSLSLGASAL_Settings = self.Settings
	
end

function SAL:SwapSettings(bool)

	if bool then
		KBMSLSLGASAL_Settings = self.Settings
		self.Settings = chKBMSLSLGASAL_Settings
	else
		chKBMSLSLGASAL_Settings = self.Settings
		self.Settings = KBMSLSLGASAL_Settings
	end

end

function SAL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLGASAL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLGASAL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLGASAL_Settings = self.Settings
	else
		KBMSLSLGASAL_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function SAL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLGASAL_Settings = self.Settings
	else
		KBMSLSLGASAL_Settings = self.Settings
	end	
end

function SAL:Castbar(units)
end

function SAL:RemoveUnits(UnitID)
	if self.Salvarola.UnitID == UnitID then
		self.Salvarola.Available = false
		return true
	end
	return false
end

function SAL:Death(UnitID)
	if self.Salvarola.UnitID == UnitID then
		self.Salvarola.Dead = true
		return true
	end
	return false
end

function SAL:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Salvarola then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Salvarola, 0, 100)
				self.Phase = 1
				if BossObj == self.Salvarola then
					KBM.TankSwap:Start(self.Lang.Debuff.BloodboilID, unitID)
				end
			else
				if BossObj == self.Salvarola then
					if not KBM.TankSwap.Active then
						KBM.TankSwap:Start(self.Lang.Debuff.BloodboilID, unitID)
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Salvarola then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function SAL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Salvarola.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function SAL:Timer()	
end

function SAL:Start()

	-- Create Timers
	self.Salvarola.TimersRef.Incineration = KBM.MechTimer:Add(self.Lang.Ability.Incineration[KBM.Lang], 37, false)
	KBM.Defaults.TimerObj.Assign(self.Salvarola)
	
	-- Create Alerts
	self.Salvarola.AlertsRef.Incineration = KBM.Alert:Create(self.Lang.Ability.Incineration[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Salvarola)

	-- Create Spies
	self.Salvarola.MechRef.Mindsear = KBM.MechSpy:Add(self.Lang.Debuff.Mindsear[KBM.Lang], nil, "playerDebuff", self.Salvarola)
	self.Salvarola.MechRef.Magma = KBM.MechSpy:Add(self.Lang.Debuff.Magma[KBM.Lang], nil, "playerDebuff", self.Salvarola)
	KBM.Defaults.MechObj.Assign(self.Salvarola)

	-- Assign Alerts and Timers to Triggers
	self.Salvarola.Triggers.Incineration = KBM.Trigger:Create(self.Lang.Ability.Incineration[KBM.Lang], "channel", self.Salvarola)
	self.Salvarola.Triggers.Incineration:AddTimer(self.Salvarola.TimersRef.Incineration)
	self.Salvarola.Triggers.Incineration:AddAlert(self.Salvarola.AlertsRef.Incineration)
	self.Salvarola.Triggers.Magma = KBM.Trigger:Create(self.Lang.Debuff.Magma[KBM.Lang], "playerDebuff", self.Salvarola)
	self.Salvarola.Triggers.Magma:AddSpy(self.Salvarola.MechRef.Magma)
	self.Salvarola.Triggers.MagmaRem = KBM.Trigger:Create(self.Lang.Debuff.Magma[KBM.Lang], "playerBuffRemove", self.Salvarola)
	self.Salvarola.Triggers.MagmaRem:AddStop(self.Salvarola.MechRef.Magma)

	self.Salvarola.Triggers.Mindsear = KBM.Trigger:Create(self.Lang.Debuff.MindsearID, "playerIDBuff", self.Salvarola)
	self.Salvarola.Triggers.Mindsear:AddSpy(self.Salvarola.MechRef.Mindsear)
	
	self.Salvarola.CastBar = KBM.CastBar:Add(self, self.Salvarola)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end