-- Crucia Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTCR_Settings = nil
chKBMSLRDFTCR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local CRC = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Crucia.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "Crucia",
	Object = "CRC",
}

KBM.RegisterMod(CRC.ID, CRC)

-- Main Unit Dictionary
CRC.Lang.Unit = {}
CRC.Lang.Unit.Crucia = KBM.Language:Add("Crucia")
CRC.Lang.Unit.Crucia:SetGerman("Crucia")
CRC.Lang.Unit.CruciaShort = KBM.Language:Add("Crucia")
CRC.Lang.Unit.CruciaShort:SetGerman("Crucia")

-- Ability Dictionary
CRC.Lang.Ability = {}

-- Description Dictionary
CRC.Lang.Main = {}

CRC.Descript = CRC.Lang.Unit.Crucia[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
CRC.Crucia = {
	Mod = CRC,
	Level = "??",
	Active = false,
	Name = CRC.Lang.Unit.Crucia[KBM.Lang],
	NameShort = CRC.Lang.Unit.CruciaShort[KBM.Lang],
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

function CRC:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Crucia.Name] = self.Crucia,
	}
end

function CRC:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Crucia.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Crucia.Settings.TimersRef,
		-- AlertsRef = self.Crucia.Settings.AlertsRef,
	}
	KBMSLRDFTCR_Settings = self.Settings
	chKBMSLRDFTCR_Settings = self.Settings
	
end

function CRC:SwapSettings(bool)

	if bool then
		KBMSLRDFTCR_Settings = self.Settings
		self.Settings = chKBMSLRDFTCR_Settings
	else
		chKBMSLRDFTCR_Settings = self.Settings
		self.Settings = KBMSLRDFTCR_Settings
	end

end

function CRC:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTCR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTCR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTCR_Settings = self.Settings
	else
		KBMSLRDFTCR_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function CRC:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTCR_Settings = self.Settings
	else
		KBMSLRDFTCR_Settings = self.Settings
	end	
end

function CRC:Castbar(units)
end

function CRC:RemoveUnits(UnitID)
	if self.Crucia.UnitID == UnitID then
		self.Crucia.Available = false
		return true
	end
	return false
end

function CRC:Death(UnitID)
	if self.Crucia.UnitID == UnitID then
		self.Crucia.Dead = true
		return true
	end
	return false
end

function CRC:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Crucia.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Crucia.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Crucia.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Crucia
			end
		end
	end
end

function CRC:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Crucia.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function CRC:Timer()	
end

function CRC:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Crucia, self.Enabled)
end

function CRC:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Crucia)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Crucia)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Crucia.CastBar = KBM.CastBar:Add(self, self.Crucia)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end