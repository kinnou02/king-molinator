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
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
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
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Gangnum.Settings.TimersRef,
		-- AlertsRef = self.Gangnum.Settings.AlertsRef,
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

function GGM:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
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
					self.PhaseObj.Objectives:AddPercent(self.Gangnum.Name, 0, 100)
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
	-- KBM.Defaults.AlertObj.Assign(self.Gangnum)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Gangnum.CastBar = KBM.CastBar:Add(self, self.Gangnum)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end