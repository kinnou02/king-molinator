-- Grand Falconer Zoles Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLTQGZ_Settings = nil
chKBMSLSLTQGZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TDQ = KBM.BossMod["STriumph_of_the_Dragon_Queen"]

local GFZ = {
	Directory = TDQ.Directory,
	File = "Zoles.lua",
	Enabled = true,
	Instance = TDQ.Name,
	InstanceObj = TDQ,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "SGrand_Falconer_Zoles",
	Object = "GFZ",
}

KBM.RegisterMod(GFZ.ID, GFZ)

-- Main Unit Dictionary
GFZ.Lang.Unit = {}
GFZ.Lang.Unit.Zoles = KBM.Language:Add("Grand Falconer Zoles")
GFZ.Lang.Unit.Zoles:SetGerman("Großfalkner Zoles")
GFZ.Lang.Unit.ZolesShort = KBM.Language:Add("Zoles")
GFZ.Lang.Unit.ZolesShort:SetGerman("Zoles")

-- Ability Dictionary
GFZ.Lang.Ability = {}

-- Description Dictionary
GFZ.Lang.Main = {}

GFZ.Descript = GFZ.Lang.Unit.Zoles[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
GFZ.Zoles = {
	Mod = GFZ,
	Level = "??",
	Active = false,
	Name = GFZ.Lang.Unit.Zoles[KBM.Lang],
	NameShort = GFZ.Lang.Unit.ZolesShort[KBM.Lang],
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UTID = "none",
	UnitID = nil,
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

function GFZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zoles.Name] = self.Zoles,
	}
end

function GFZ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Zoles.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zoles.Settings.TimersRef,
		-- AlertsRef = self.Zoles.Settings.AlertsRef,
	}
	KBMSLSLTQGZ_Settings = self.Settings
	chKBMSLSLTQGZ_Settings = self.Settings
	
end

function GFZ:SwapSettings(bool)

	if bool then
		KBMSLSLTQGZ_Settings = self.Settings
		self.Settings = chKBMSLSLTQGZ_Settings
	else
		chKBMSLSLTQGZ_Settings = self.Settings
		self.Settings = KBMSLSLTQGZ_Settings
	end

end

function GFZ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLTQGZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLTQGZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLTQGZ_Settings = self.Settings
	else
		KBMSLSLTQGZ_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function GFZ:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLTQGZ_Settings = self.Settings
	else
		KBMSLSLTQGZ_Settings = self.Settings
	end	
end

function GFZ:Castbar(units)
end

function GFZ:RemoveUnits(UnitID)
	if self.Zoles.UnitID == UnitID then
		self.Zoles.Available = false
		return true
	end
	return false
end

function GFZ:Death(UnitID)
	if self.Zoles.UnitID == UnitID then
		self.Zoles.Dead = true
		return true
	end
	return false
end

function GFZ:UnitHPCheck(unitDetails, unitID)	
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
					if BossObj.Name == self.Zoles.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Zoles.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Zoles.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Zoles
			end
		end
	end
end

function GFZ:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Zoles.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function GFZ:Timer()	
end

function GFZ:DefineMenu()
	self.Menu = TDQ.Menu:CreateEncounter(self.Zoles, self.Enabled)
end

function GFZ:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Zoles)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Zoles)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Zoles.CastBar = KBM.CastBar:Add(self, self.Zoles)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end