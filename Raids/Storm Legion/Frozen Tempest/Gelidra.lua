-- Gelidra Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLRDFTGA_Settings = nil
chKBMSLRDFTGA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local FT = KBM.BossMod["RFrozen_Tempest"]

local GLD = {
	Enabled = true,
	Directory = FT.Directory,
	File = "Gelidra.lua",
	Instance = FT.Name,
	InstanceObj = FT,
	HasPhases = true,
	Lang = {},
	ID = "Gelidra",
	Object = "GLD",
}

KBM.RegisterMod(GLD.ID, GLD)

-- Main Unit Dictionary
GLD.Lang.Unit = {}
GLD.Lang.Unit.Gelidra = KBM.Language:Add("Gelidra")
GLD.Lang.Unit.Gelidra:SetGerman("Gelidra")
GLD.Lang.Unit.GelidraShort = KBM.Language:Add("Gelidra")
GLD.Lang.Unit.GelidraShort:SetGerman("Gelidra")

-- Ability Dictionary
GLD.Lang.Ability = {}

-- Description Dictionary
GLD.Lang.Main = {}

GLD.Descript = GLD.Lang.Unit.Gelidra[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
GLD.Gelidra = {
	Mod = GLD,
	Level = "??",
	Active = false,
	Name = GLD.Lang.Unit.Gelidra[KBM.Lang],
	NameShort = GLD.Lang.Unit.GelidraShort[KBM.Lang],
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

function GLD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gelidra.Name] = self.Gelidra,
	}
end

function GLD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gelidra.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Gelidra.Settings.TimersRef,
		-- AlertsRef = self.Gelidra.Settings.AlertsRef,
	}
	KBMSLRDFTGA_Settings = self.Settings
	chKBMSLRDFTGA_Settings = self.Settings
	
end

function GLD:SwapSettings(bool)

	if bool then
		KBMSLRDFTGA_Settings = self.Settings
		self.Settings = chKBMSLRDFTGA_Settings
	else
		chKBMSLRDFTGA_Settings = self.Settings
		self.Settings = KBMSLRDFTGA_Settings
	end

end

function GLD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDFTGA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDFTGA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDFTGA_Settings = self.Settings
	else
		KBMSLRDFTGA_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function GLD:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDFTGA_Settings = self.Settings
	else
		KBMSLRDFTGA_Settings = self.Settings
	end	
end

function GLD:Castbar(units)
end

function GLD:RemoveUnits(UnitID)
	if self.Gelidra.UnitID == UnitID then
		self.Gelidra.Available = false
		return true
	end
	return false
end

function GLD:Death(UnitID)
	if self.Gelidra.UnitID == UnitID then
		self.Gelidra.Dead = true
		return true
	end
	return false
end

function GLD:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Gelidra.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Gelidra.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Gelidra.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Gelidra
			end
		end
	end
end

function GLD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Gelidra.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function GLD:Timer()	
end

function GLD:DefineMenu()
	self.Menu = FT.Menu:CreateEncounter(self.Gelidra, self.Enabled)
end

function GLD:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Gelidra)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Gelidra)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Gelidra.CastBar = KBM.CastBar:Add(self, self.Gelidra)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end