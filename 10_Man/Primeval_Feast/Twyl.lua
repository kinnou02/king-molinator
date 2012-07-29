-- Lord Twyl Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFLT_Settings = nil
chKBMPFLT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local LT = {
	Directory = PF.Directory,
	File = "Twyl.lua",
	Enabled = true,
	Instance = PF.Name,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "PF_Twyl",
	Object = "LT",
}

LT.Twyl = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = "Lord Twyl",
	NameShort = "Twyl",
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

KBM.RegisterMod(LT.ID, LT)

-- Main Unit Dictionary
LT.Lang.Unit = {}
LT.Lang.Unit.Twyl = KBM.Language:Add(LT.Twyl.Name)
LT.Lang.Unit.Twyl:SetGerman("Fürst Twyl")
LT.Lang.Unit.Twyl:SetFrench("Seigneur des Fées Twyl")
LT.Lang.Unit.Twyl:SetRussian("Повелитель Твил")
LT.Lang.Unit.TwylShort = KBM.Language:Add("Twyl")
LT.Lang.Unit.TwylShort:SetGerman("Twyl")
LT.Lang.Unit.TwylShort:SetFrench("Twyl")
LT.Lang.Unit.TwylShort:SetRussian("Твил")
LT.Twyl.Name = LT.Lang.Unit.Twyl[KBM.Lang]
LT.Twyl.NameShort = LT.Lang.Unit.TwylShort[KBM.Lang]
LT.Descript = LT.Twyl.Name

function LT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Twyl.Name] = self.Twyl,
	}
	KBM_Boss[self.Twyl.Name] = self.Twyl	
end

function LT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Twyl.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- AlertsRef = self.Twyl.Settings.AlertsRef,
		-- TimersRef = self.Twyl.Settings.TimersRef,
	}
	KBMPFLT_Settings = self.Settings
	chKBMPFLT_Settings = self.Settings
end

function LT:SwapSettings(bool)

	if bool then
		KBMPFLT_Settings = self.Settings
		self.Settings = chKBMPFLT_Settings
	else
		chKBMPFLT_Settings = self.Settings
		self.Settings = KBMPFLT_Settings
	end

end

function LT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFLT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFLT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFLT_Settings = self.Settings
	else
		KBMPFLT_Settings = self.Settings
	end	
end

function LT:SaveVars()	
	if KBM.Options.Character then
		chKBMPFLT_Settings = self.Settings
	else
		KBMPFLT_Settings = self.Settings
	end	
end

function LT:Castbar(units)
end

function LT:RemoveUnits(UnitID)
	if self.Twyl.UnitID == UnitID then
		self.Twyl.Available = false
		return true
	end
	return false
end

function LT:Death(UnitID)
	if self.Twyl.UnitID == UnitID then
		self.Twyl.Dead = true
		return true
	end
	return false
end

function LT:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Twyl.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Twyl.Dead = false
					self.Twyl.Casting = false
					self.Twyl.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Twyl.Name, 0, 100)
					self.Phase = 1					
				end
				self.Twyl.UnitID = unitID
				self.Twyl.Available = true
				return self.Twyl
			end
		end
	end
end

function LT:Reset()
	self.EncounterRunning = false
	self.Twyl.Available = false
	self.Twyl.UnitID = nil
	self.Twyl.Dead = false
	self.Twyl.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function LT:Timer()
	
end

function LT.Twyl:SetTimers(bool)	
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

function LT.Twyl:SetAlerts(bool)
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

function LT:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Twyl, self.Enabled)
end

function LT:Start()
	-- Create Timers

	-- Create Alerts
	
	-- Assign Alerts and Timers to Triggers
	
	self.Twyl.CastBar = KBM.CastBar:Add(self, self.Twyl, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end