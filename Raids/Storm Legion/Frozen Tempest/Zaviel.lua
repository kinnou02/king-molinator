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
ZVL.Lang.Unit.Zaviel = KBM.Language:Add("Zaviel")
ZVL.Lang.Unit.Zaviel:SetGerman("Zaviel")
ZVL.Lang.Unit.ZavielShort = KBM.Language:Add("Zaviel")
ZVL.Lang.Unit.ZavielShort:SetGerman("Zaviel")

-- Ability Dictionary
ZVL.Lang.Ability = {}

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
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zaviel.Settings.TimersRef,
		-- AlertsRef = self.Zaviel.Settings.AlertsRef,
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

function ZVL:Death(UnitID)
	if self.Zaviel.UnitID == UnitID then
		self.Zaviel.Dead = true
		return true
	end
	return false
end

function ZVL:UnitHPCheck(unitDetails, unitID)	
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
					if BossObj.Name == self.Zaviel.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Zaviel.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Zaviel.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Zaviel
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
	-- KBM.Defaults.AlertObj.Assign(self.Zaviel)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Zaviel.CastBar = KBM.CastBar:Add(self, self.Zaviel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end