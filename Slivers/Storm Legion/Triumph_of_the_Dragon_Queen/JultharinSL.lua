-- Jultharin Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSLSLTQJN_Settings = nil
chKBMSLSLTQJN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TDQ = KBM.BossMod["STriumph_of_the_Dragon_Queen"]

local JUL = {
	Directory = TDQ.Directory,
	File = "JultharinSL.lua",
	Enabled = true,
	Instance = TDQ.Name,
	InstanceObj = TDQ,
	Lang = {},
	Enrage = 5.5 * 60,
	ID = "SJultharinSL",
	Object = "JUL",
}

KBM.RegisterMod(JUL.ID, JUL)

-- Main Unit Dictionary
JUL.Lang.Unit = {}
JUL.Lang.Unit.Jultharin = KBM.Language:Add("Jultharin")
JUL.Lang.Unit.Jultharin:SetGerman("Jultharin")
JUL.Lang.Unit.JultharinShort = KBM.Language:Add("Jultharin")
JUL.Lang.Unit.JultharinShort:SetGerman("Jultharin")

-- Ability Dictionary
JUL.Lang.Ability = {}
JUL.Lang.Ability.Tempest = KBM.Language:Add("Deranging Tempest")
JUL.Lang.Ability.Tempest:SetGerman("Verwirrender Sturm")

-- Description Dictionary
JUL.Lang.Main = {}

JUL.Descript = JUL.Lang.Unit.Jultharin[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
JUL.Jultharin = {
	Mod = JUL,
	Level = "??",
	Active = false,
	Name = JUL.Lang.Unit.Jultharin[KBM.Lang],
	NameShort = JUL.Lang.Unit.JultharinShort[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "U3F2331475EA6C7B3",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Tempest = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Tempest = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

function JUL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Jultharin.Name] = self.Jultharin,
	}
end

function JUL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Jultharin.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Jultharin.Settings.TimersRef,
		AlertsRef = self.Jultharin.Settings.AlertsRef,
	}
	KBMSLSLTQJN_Settings = self.Settings
	chKBMSLSLTQJN_Settings = self.Settings
	
end

function JUL:SwapSettings(bool)

	if bool then
		KBMSLSLTQJN_Settings = self.Settings
		self.Settings = chKBMSLSLTQJN_Settings
	else
		chKBMSLSLTQJN_Settings = self.Settings
		self.Settings = KBMSLSLTQJN_Settings
	end

end

function JUL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLTQJN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLTQJN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLTQJN_Settings = self.Settings
	else
		KBMSLSLTQJN_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function JUL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLTQJN_Settings = self.Settings
	else
		KBMSLSLTQJN_Settings = self.Settings
	end	
end

function JUL:Castbar(units)
end

function JUL:RemoveUnits(UnitID)
	if self.Jultharin.UnitID == UnitID then
		self.Jultharin.Available = false
		return true
	end
	return false
end

function JUL:Death(UnitID)
	if self.Jultharin.UnitID == UnitID then
		self.Jultharin.Dead = true
		return true
	end
	return false
end

function JUL:UnitHPCheck(uDetails, unitID)	
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
				if BossObj == self.Jultharin then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Jultharin.Name, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Jultharin then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return self.Jultharin
		end
	end
end

function JUL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Jultharin.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function JUL:Timer()	
end

function JUL:DefineMenu()
	self.Menu = TDQ.Menu:CreateEncounter(self.Jultharin, self.Enabled)
end

function JUL:Start()
	-- Create Timers
	self.Jultharin.TimersRef.Tempest = KBM.MechTimer:Add(self.Lang.Ability.Tempest[KBM.Lang], 22)
	KBM.Defaults.TimerObj.Assign(self.Jultharin)
	
	-- Create Alerts
	self.Jultharin.AlertsRef.Tempest = KBM.Alert:Create(self.Lang.Ability.Tempest[KBM.Lang], nil, false, true, "yellow")
	self.Jultharin.AlertsRef.Tempest:Important()
	KBM.Defaults.AlertObj.Assign(self.Jultharin)
	
	-- Assign Alerts and Timers to Triggers
	self.Jultharin.Triggers.Tempest = KBM.Trigger:Create(self.Lang.Ability.Tempest[KBM.Lang], "cast", self.Jultharin)
	self.Jultharin.Triggers.Tempest:AddAlert(self.Jultharin.AlertsRef.Tempest)
	self.Jultharin.Triggers.Tempest:AddTimer(self.Jultharin.TimersRef.Tempest)
	self.Jultharin.Triggers.TempestInt = KBM.Trigger:Create(self.Lang.Ability.Tempest[KBM.Lang], "interrupt", self.Jultharin)
	self.Jultharin.Triggers.TempestInt:AddStop(self.Jultharin.AlertsRef.Tempest)
	
	self.Jultharin.CastBar = KBM.CastBar:Add(self, self.Jultharin)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end