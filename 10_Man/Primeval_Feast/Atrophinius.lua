-- Atrophinius Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFAN_Settings = nil
chKBMPFAN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local AN = {
	Directory = PF.Directory,
	File = "Atrophinius.lua",
	Enabled = true,
	Instance = PF.Name,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "PF_Atrophinius",
	Object = "AN",
}

AN.Atrophinius = {
	Mod = AN,
	Level = "??",
	Active = false,
	Name = "Grandmaster Atrophinius",
	NameShort = "Atrophinius",
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(AN.ID, AN)

-- Main Unit Dictionary
AN.Lang.Unit = {}
AN.Lang.Unit.Atrophinius = KBM.Language:Add(AN.Atrophinius.Name)
AN.Lang.Unit.Atrophinius:SetGerman("Großmeister Atrophinius")
AN.Lang.Unit.AtrophiniusShort = KBM.Language:Add("Atrophinius")
AN.Lang.Unit.AtrophiniusShort:SetGerman("Atrophinius")

AN.Atrophinius.Name = AN.Lang.Unit.Atrophinius[KBM.Lang]
AN.Atrophinius.NameShort = AN.Lang.Unit.AtrophiniusShort[KBM.Lang]
AN.Descript = AN.Atrophinius.Name

function AN:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Atrophinius.Name] = self.Atrophinius,
	}
	KBM_Boss[self.Atrophinius.Name] = self.Atrophinius	
end

function AN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Atrophinius.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- AlertsRef = self.Atrophinius.Settings.AlertsRef,
		-- TimersRef = self.Atrophinius.Settings.TimersRef,
	}
	KBMPFAN_Settings = self.Settings
	chKBMPFAN_Settings = self.Settings
end

function AN:SwapSettings(bool)

	if bool then
		KBMPFAN_Settings = self.Settings
		self.Settings = chKBMPFAN_Settings
	else
		chKBMPFAN_Settings = self.Settings
		self.Settings = KBMPFAN_Settings
	end

end

function AN:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFAN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFAN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFAN_Settings = self.Settings
	else
		KBMPFAN_Settings = self.Settings
	end	
end

function AN:SaveVars()	
	if KBM.Options.Character then
		chKBMPFAN_Settings = self.Settings
	else
		KBMPFAN_Settings = self.Settings
	end	
end

function AN:Castbar(units)
end

function AN:RemoveUnits(UnitID)
	if self.Atrophinius.UnitID == UnitID then
		self.Atrophinius.Available = false
		return true
	end
	return false
end

function AN:Death(UnitID)
	if self.Atrophinius.UnitID == UnitID then
		self.Atrophinius.Dead = true
		return true
	end
	return false
end

function AN:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Atrophinius.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Atrophinius.Dead = false
					self.Atrophinius.Casting = false
					self.Atrophinius.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Atrophinius.Name, 0, 100)
					self.Phase = 1					
				end
				self.Atrophinius.UnitID = unitID
				self.Atrophinius.Available = true
				return self.Atrophinius
			end
		end
	end
end

function AN:Reset()
	self.EncounterRunning = false
	self.Atrophinius.Available = false
	self.Atrophinius.UnitID = nil
	self.Atrophinius.Dead = false
	self.Atrophinius.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function AN:Timer()
	
end

function AN.Atrophinius:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function AN.Atrophinius:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function AN:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Atrophinius, self.Enabled)
end

function AN:Start()
	-- Create Timers

	-- Create Alerts
	
	-- Assign Alerts and Timers to Triggers
	
	self.Atrophinius.CastBar = KBM.CastBar:Add(self, self.Atrophinius, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end