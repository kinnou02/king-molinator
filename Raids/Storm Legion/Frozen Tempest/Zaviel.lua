-- Zaviel Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTZL_Settings = nil
chKBMSLRDFTZL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local ZVL = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Zaviel.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "Zaviel",
	Object = "ZVL",
}

KBM.RegisterMod(ZVL.ID, ZVL)

-- Main Unit Dictionary
ZVL.Lang.Unit = {}
ZVL.Lang.Unit.Zaviel = KBM.Language:Add("Artifex Zaviel")
ZVL.Lang.Unit.Zaviel:SetGerman("Artifex Zaviel")
ZVL.Lang.Unit.ZavielShort = KBM.Language:Add("Zaviel")
ZVL.Lang.Unit.ZavielShort:SetGerman("Zaviel")

-- Ability Dictionary
ZVL.Lang.Ability = {}
ZVL.Lang.Ability.Conduit = KBM.Language:Add("Energy Conduit")
ZVL.Lang.Ability.Conduit:SetGerman("Energieleitung")
ZVL.Lang.Ability.Jolt = KBM.Language:Add("Ensnaring Jolt")
ZVL.Lang.Ability.Jolt:SetGerman("Verlangsamender Stromschlag")

-- Debuff Dictionary
ZVL.Lang.Debuff = {}
ZVL.Lang.Debuff.Arc = KBM.Language:Add("Arc Weld")
ZVL.Lang.Debuff.Arc:SetGerman("Bogenverschweißung")
ZVL.Lang.Debuff.Vitality = KBM.Language:Add("Dissonant Vitality")
ZVL.Lang.Debuff.Vitality:SetGerman("Dissonante Vitalität")

-- Verbose Dictionary
ZVL.Lang.Verbose = {}
ZVL.Lang.Verbose.ConduitWarn = KBM.Language:Add("Casting: Energy Conduit")
ZVL.Lang.Verbose.ConduitWarn:SetGerman("Achtung: Energieleitung")
ZVL.Lang.Verbose.Conduit = KBM.Language:Add("Cleanse Energy Conduit!")
ZVL.Lang.Verbose.Conduit:SetGerman("Energieleitung dispellen!")
ZVL.Lang.Verbose.Jolt = KBM.Language:Add("Run around!")
ZVL.Lang.Verbose.Jolt:SetGerman("Laufen!")

-- Description Dictionary
ZVL.Lang.Main = {}

ZVL.Descript = ZVL.Lang.Unit.Zaviel[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
ZVL.Zaviel = {
	Mod = ZVL,
	Level = "??",
	Active = false,
	Name = ZVL.Lang.Unit.Zaviel[KBM.Lang],
	NameShort = ZVL.Lang.Unit.ZavielShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	MechRef = {},
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
			Arc = KBM.Defaults.AlertObj.Create("purple"),
			ConduitWarn = KBM.Defaults.AlertObj.Create("orange"),
			Conduit = KBM.Defaults.AlertObj.Create("orange"),
			JoltWarn = KBM.Defaults.AlertObj.Create("red"),
			Jolt = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Arc = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

function ZVL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zaviel.Name] = self.Zaviel,
	}
end

function ZVL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Zaviel.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zaviel.Settings.TimersRef,
		AlertsRef = self.Zaviel.Settings.AlertsRef,
		MechRef = self.Zaviel.Settings.MechRef,
	}
	KBMSLRDFTZL_Settings = self.Settings
	chKBMSLRDFTZL_Settings = self.Settings
	
end

function ZVL:SwapSettings(bool)

	if bool then
		KBMSLRDFTZL_Settings = self.Settings
		self.Settings = chKBMSLRDFTZL_Settings
	else
		chKBMSLRDFTZL_Settings = self.Settings
		self.Settings = KBMSLRDFTZL_Settings
	end

end

function ZVL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTZL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTZL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTZL_Settings = self.Settings
	else
		KBMSLRDFTZL_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function ZVL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTZL_Settings = self.Settings
	else
		KBMSLRDFTZL_Settings = self.Settings
	end	
end

function ZVL:Castbar(units)
end

function ZVL:RemoveUnits(UnitID)
	if self.Zaviel.UnitID == UnitID then
		self.Zaviel.Available = false
		return true
	end
	return false
end

function ZVL.PhaseTwo()
	if ZVL.Phase == 1 then
		ZVL.Phase = 1
		ZVL.PhaseObj.Objectives:Remove()
		ZVL.PhaseObj.Objectives:AddPercent(ZVL.Zaviel, 0, 50)
		ZVL.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	end
end

function ZVL:Death(UnitID)
	if self.Zaviel.UnitID == UnitID then
		self.Zaviel.Dead = true
		return true
	end
	return false
end

function ZVL:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Zaviel.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Zaviel, 50, 100)
					self.Phase = 1
					local DebuffTable = {
							[1] = self.Lang.Debuff.Vitality[KBM.Lang],
							[2] = self.Lang.Ability.Conduit[KBM.Lang],
					}
					KBM.TankSwap:Start(DebuffTable, unitID, 2)
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Zaviel.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function ZVL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Zaviel.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function ZVL:Timer()	
end

function ZVL:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Zaviel, self.Enabled)
end

function ZVL:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Zaviel)
	
	-- Create Alerts
	self.Zaviel.AlertsRef.Arc = KBM.Alert:Create(self.Lang.Debuff.Arc[KBM.Lang], nil, true, false, "purple")
	self.Zaviel.AlertsRef.ConduitWarn = KBM.Alert:Create(self.Lang.Verbose.ConduitWarn[KBM.Lang], nil, true, true, "orange")
	self.Zaviel.AlertsRef.Conduit = KBM.Alert:Create(self.Lang.Verbose.Conduit[KBM.Lang], nil, false, true, "orange")
	self.Zaviel.AlertsRef.JoltWarn = KBM.Alert:Create(self.Lang.Ability.Jolt[KBM.Lang], nil, false, true, "red")
	self.Zaviel.AlertsRef.Jolt = KBM.Alert:Create(self.Lang.Verbose.Jolt[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Zaviel)
	
	-- Create Spies
	self.Zaviel.MechRef.Arc = KBM.MechSpy:Add(self.Lang.Debuff.Arc[KBM.Lang], nil, "playerBuff", self.Zaviel)
	KBM.Defaults.MechObj.Assign(self.Zaviel)
	
	-- Assign Alerts and Timers to Triggers
	self.Zaviel.Triggers.Arc = KBM.Trigger:Create(self.Lang.Debuff.Arc[KBM.Lang], "playerBuff", self.Zaviel)
	self.Zaviel.Triggers.Arc:AddAlert(self.Zaviel.AlertsRef.Arc, true)
	self.Zaviel.Triggers.Arc:AddSpy(self.Zaviel.MechRef.Arc)
	self.Zaviel.Triggers.ArcRem = KBM.Trigger:Create(self.Lang.Debuff.Arc[KBM.Lang], "playerBuffRemove", self.Zaviel)
	self.Zaviel.Triggers.ArcRem:AddStop(self.Zaviel.AlertsRef.Arc)
	self.Zaviel.Triggers.ArcRem:AddStop(self.Zaviel.MechRef.Arc)
	self.Zaviel.Triggers.ConduitWarn = KBM.Trigger:Create(self.Lang.Ability.Conduit[KBM.Lang], "cast", self.Zaviel)
	self.Zaviel.Triggers.ConduitWarn:AddAlert(self.Zaviel.AlertsRef.ConduitWarn)
	self.Zaviel.Triggers.Conduit = KBM.Trigger:Create(self.Lang.Ability.Conduit[KBM.Lang], "playerBuff", self.Zaviel)
	self.Zaviel.Triggers.Conduit:AddAlert(self.Zaviel.AlertsRef.Conduit)
	self.Zaviel.Triggers.ConduitRem = KBM.Trigger:Create(self.Lang.Ability.Conduit[KBM.Lang], "playerBuffRemove", self.Zaviel)
	self.Zaviel.Triggers.ConduitRem:AddStop(self.Zaviel.AlertsRef.Conduit)
	self.Zaviel.Triggers.JoltWarn = KBM.Trigger:Create(self.Lang.Ability.Jolt[KBM.Lang], "cast", self.Zaviel)
	self.Zaviel.Triggers.JoltWarn:AddAlert(self.Zaviel.AlertsRef.JoltWarn)
	self.Zaviel.Triggers.Jolt = KBM.Trigger:Create(self.Lang.Ability.Jolt[KBM.Lang], "buff", self.Zaviel)
	self.Zaviel.Triggers.Jolt:AddAlert(self.Zaviel.AlertsRef.Jolt)
	-- Phase
	self.Zaviel.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Zaviel)
	self.Zaviel.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	
	self.Zaviel.CastBar = KBM.CastBar:Add(self, self.Zaviel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end