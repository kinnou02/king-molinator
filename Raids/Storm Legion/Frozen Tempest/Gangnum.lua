-- Gangnum Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTGM_Settings = nil
chKBMSLRDFTGM_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local GGM = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Gangnum.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "Gangnum",
	Object = "GGM",
}

KBM.RegisterMod(GGM.ID, GGM)

-- Main Unit Dictionary
GGM.Lang.Unit = {}
GGM.Lang.Unit.Gangnum = KBM.Language:Add("Gangnum")
GGM.Lang.Unit.Gangnum:SetGerman("Gangnum")
GGM.Lang.Unit.GangnumShort = KBM.Language:Add("Gangnum")
GGM.Lang.Unit.GangnumShort:SetGerman("Gangnum")

-- Ability Dictionary
GGM.Lang.Ability = {}
GGM.Lang.Ability.Blind = KBM.Language:Add("Blinding Surge")

-- Debuff Dictionary
GGM.Lang.Debuff = {}
GGM.Lang.Debuff.Wrath = KBM.Language:Add("Tempest Wrath")

-- Verbose Dictionary
GGM.Lang.Verbose = {}
GGM.Lang.Verbose.Wrath = KBM.Language:Add("Move away!")

-- Description Dictionary
GGM.Lang.Main = {}

GGM.Descript = GGM.Lang.Unit.Gangnum[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
GGM.Gangnum = {
	Mod = GGM,
	Level = "??",
	Active = false,
	Name = GGM.Lang.Unit.Gangnum[KBM.Lang],
	NameShort = GGM.Lang.Unit.GangnumShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "UFD9406350DEB0152",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Wrath = KBM.Defaults.AlertObj.Create("purple"),
			WrathRem = KBM.Defaults.AlertObj.Create("red"),
			Blind = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Wrath = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

function GGM:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gangnum.Name] = self.Gangnum,
	}
end

function GGM:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gangnum.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		-- TimersRef = self.Gangnum.Settings.TimersRef,
		AlertsRef = self.Gangnum.Settings.AlertsRef,
		MechRef = self.Gangnum.Settings.MechRef,
	}
	KBMSLRDFTGM_Settings = self.Settings
	chKBMSLRDFTGM_Settings = self.Settings
	
end

function GGM:SwapSettings(bool)

	if bool then
		KBMSLRDFTGM_Settings = self.Settings
		self.Settings = chKBMSLRDFTGM_Settings
	else
		chKBMSLRDFTGM_Settings = self.Settings
		self.Settings = KBMSLRDFTGM_Settings
	end

end

function GGM:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTGM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTGM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTGM_Settings = self.Settings
	else
		KBMSLRDFTGM_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function GGM:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTGM_Settings = self.Settings
	else
		KBMSLRDFTGM_Settings = self.Settings
	end	
end

function GGM:Castbar(units)
end

function GGM:RemoveUnits(UnitID)
	if self.Gangnum.UnitID == UnitID then
		self.Gangnum.Available = false
		return true
	end
	return false
end

function GGM:Death(UnitID)
	if self.Gangnum.UnitID == UnitID then
		self.Gangnum.Dead = true
		return true
	end
	return false
end

function GGM:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Gangnum.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Gangnum, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Gangnum.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Gangnum
			end
		end
	end
end

function GGM:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Gangnum.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function GGM:Timer()	
end

function GGM:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Gangnum, self.Enabled)
end

function GGM:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Gangnum)
	
	-- Create Alerts
	self.Gangnum.AlertsRef.Wrath = KBM.Alert:Create(self.Lang.Debuff.Wrath[KBM.Lang], nil, false, true, "purple")
	self.Gangnum.AlertsRef.WrathRem = KBM.Alert:Create(self.Lang.Verbose.Wrath[KBM.Lang], 3, true, false, "red")
	self.Gangnum.AlertsRef.Blind = KBM.Alert:Create(self.Lang.Ability.Blind[KBM.Lang], nil, true, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Gangnum)
	
	-- Create Spies
	self.Gangnum.MechRef.Wrath = KBM.MechSpy:Add(self.Lang.Debuff.Wrath[KBM.Lang], nil, "playerDebuff", self.Gangnum)
	KBM.Defaults.MechObj.Assign(self.Gangnum)
	
	-- Assign Alerts and Timers to Triggers
	self.Gangnum.Triggers.Wrath = KBM.Trigger:Create(self.Lang.Debuff.Wrath[KBM.Lang], "playerBuff", self.Gangnum)
	self.Gangnum.Triggers.Wrath:AddAlert(self.Gangnum.AlertsRef.Wrath, true)
	self.Gangnum.Triggers.Wrath:AddSpy(self.Gangnum.MechRef.Wrath)
	self.Gangnum.Triggers.WrathRem = KBM.Trigger:Create(self.Lang.Debuff.Wrath[KBM.Lang], "playerBuffRemove", self.Gangnum)
	self.Gangnum.Triggers.WrathRem:AddAlert(self.Gangnum.AlertsRef.WrathRem, true)
	self.Gangnum.Triggers.Blind = KBM.Trigger:Create(self.Lang.Ability.Blind[KBM.Lang], "channel", self.Gangnum)
	self.Gangnum.Triggers.Blind:AddAlert(self.Gangnum.AlertsRef.Blind)
	
	self.Gangnum.CastBar = KBM.CastBar:Add(self, self.Gangnum)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end