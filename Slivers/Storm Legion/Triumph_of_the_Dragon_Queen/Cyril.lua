-- Cyril Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSLSLTQCL_Settings = nil
chKBMSLSLTQCL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TDQ = KBM.BossMod["STriumph_of_the_Dragon_Queen"]

local CRL = {
	Directory = TDQ.Directory,
	File = "Cyril.lua",
	Enabled = true,
	Instance = TDQ.Name,
	InstanceObj = TDQ,
	Lang = {},
	Enrage = 6 * 60,
	ID = "Cyril",
	Object = "CRL",
}

KBM.RegisterMod(CRL.ID, CRL)

-- Main Unit Dictionary
CRL.Lang.Unit = {}
CRL.Lang.Unit.Cyril = KBM.Language:Add("Cyril")
CRL.Lang.Unit.Cyril:SetGerman("Cyril")
CRL.Lang.Unit.CyrilShort = KBM.Language:Add("Cyril")
CRL.Lang.Unit.CyrilShort:SetGerman("Cyril")

-- Ability Dictionary
CRL.Lang.Ability = {}
CRL.Lang.Ability.Crushing = KBM.Language:Add("Crushing Burden")

-- Debuff Dictionary
CRL.Lang.Debuff = {}
CRL.Lang.Debuff.Mental = KBM.Language:Add("Mental Anguish")

-- Buff Dictionary
CRL.Lang.Buff = {}
CRL.Lang.Buff.Mien = KBM.Language:Add("Mien of Supremacy")

-- Description Dictionary
CRL.Lang.Main = {}

CRL.Descript = CRL.Lang.Unit.Cyril[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
CRL.Cyril = {
	Mod = CRL,
	Level = "??",
	Active = false,
	Name = CRL.Lang.Unit.Cyril[KBM.Lang],
	NameShort = CRL.Lang.Unit.CyrilShort[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "UFBF4C45669116886",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Crushing = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Crushing = KBM.Defaults.AlertObj.Create("red"),
			Mien = KBM.Defaults.AlertObj.Create("purple"),
		},
	}
}

function CRL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cyril.Name] = self.Cyril,
	}
end

function CRL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cyril.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Cyril.Settings.TimersRef,
		AlertsRef = self.Cyril.Settings.AlertsRef,
	}
	KBMSLSLTQCL_Settings = self.Settings
	chKBMSLSLTQCL_Settings = self.Settings
	
end

function CRL:SwapSettings(bool)

	if bool then
		KBMSLSLTQCL_Settings = self.Settings
		self.Settings = chKBMSLSLTQCL_Settings
	else
		chKBMSLSLTQCL_Settings = self.Settings
		self.Settings = KBMSLSLTQCL_Settings
	end

end

function CRL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLTQCL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLTQCL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLTQCL_Settings = self.Settings
	else
		KBMSLSLTQCL_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function CRL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLTQCL_Settings = self.Settings
	else
		KBMSLSLTQCL_Settings = self.Settings
	end	
end

function CRL:Castbar(units)
end

function CRL:RemoveUnits(UnitID)
	if self.Cyril.UnitID == UnitID then
		self.Cyril.Available = false
		return true
	end
	return false
end

function CRL:Death(UnitID)
	if self.Cyril.UnitID == UnitID then
		self.Cyril.Dead = true
		return true
	end
	return false
end

function CRL:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Cyril then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Cyril.Name, 0, 100)
				self.Phase = 1
				KBM.TankSwap:Start(self.Lang.Debuff.Mental[KBM.Lang])
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Cyril then
					BossObj.CastBar:Remove()
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return self.Cyril
		end
	end
end

function CRL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Cyril.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function CRL:Timer()	
end

function CRL:DefineMenu()
	self.Menu = TDQ.Menu:CreateEncounter(self.Cyril, self.Enabled)
end

function CRL:Start()
	-- Create Timers
	self.Cyril.TimersRef.Crushing = KBM.MechTimer:Add(self.Lang.Ability.Crushing[KBM.Lang], 30)
	KBM.Defaults.TimerObj.Assign(self.Cyril)
	
	-- Create Alerts
	self.Cyril.AlertsRef.Crushing = KBM.Alert:Create(self.Lang.Ability.Crushing[KBM.Lang], nil, true, true, "red")
	self.Cyril.AlertsRef.Mien = KBM.Alert:Create(self.Lang.Buff.Mien[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Cyril)
	
	-- Assign Alerts and Timers to Triggers
	self.Cyril.Triggers.Crushing = KBM.Trigger:Create(self.Lang.Ability.Crushing[KBM.Lang], "cast", self.Cyril)
	self.Cyril.Triggers.Crushing:AddAlert(self.Cyril.AlertsRef.Crushing)
	self.Cyril.Triggers.Crushing:AddTimer(self.Cyril.TimersRef.Crushing)
	self.Cyril.Triggers.Mien = KBM.Trigger:Create(self.Lang.Buff.Mien[KBM.Lang], "buff", self.Cyril)
	self.Cyril.Triggers.Mien:AddAlert(self.Cyril.AlertsRef.Mien)
	self.Cyril.Triggers.MienRem = KBM.Trigger:Create(self.Lang.Buff.Mien[KBM.Lang], "buffRemove", self.Cyril)
	self.Cyril.Triggers.MienRem:AddStop(self.Cyril.AlertsRef.Mien)
	
	self.Cyril.CastBar = KBM.CastBar:Add(self, self.Cyril)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end