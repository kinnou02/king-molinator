-- Swarmlord Khargroth Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFSK_Settings = nil
chKBMPFSK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local SK = {
	Directory = PF.Directory,
	File = "Khargroth.lua",
	Enabled = true,
	Instance = PF.Name,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "PF_Khargroth",
	Object = "SK",
}

SK.Khargroth = {
	Mod = SK,
	Level = "??",
	Active = false,
	Name = "Swarmlord Khargroth",
	NameShort = "Khargroth",
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

KBM.RegisterMod(SK.ID, SK)

-- Main Unit Dictionary
SK.Lang.Unit = {}
SK.Lang.Unit.Khargroth = KBM.Language:Add(SK.Khargroth.Name)
SK.Lang.Unit.Khargroth:SetGerman("Schwarmherr Khargroth")
SK.Lang.Unit.Khargroth:SetFrench("Seigneur de l'Essaim Khargroth")
SK.Lang.Unit.KhargrothShort = KBM.Language:Add("Khargroth")
SK.Lang.Unit.KhargrothShort:SetGerman("Khargroth")
SK.Lang.Unit.KhargrothShort:SetFrench("Khargroth")

SK.Khargroth.Name = SK.Lang.Unit.Khargroth[KBM.Lang]
SK.Khargroth.NameShort = SK.Lang.Unit.KhargrothShort[KBM.Lang]
SK.Descript = SK.Khargroth.Name

function SK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Khargroth.Name] = self.Khargroth,
	}
	KBM_Boss[self.Khargroth.Name] = self.Khargroth	
end

function SK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Khargroth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- AlertsRef = self.Khargroth.Settings.AlertsRef,
		-- TimersRef = self.Khargroth.Settings.TimersRef,
	}
	KBMPFSK_Settings = self.Settings
	chKBMPFSK_Settings = self.Settings
end

function SK:SwapSettings(bool)

	if bool then
		KBMPFSK_Settings = self.Settings
		self.Settings = chKBMPFSK_Settings
	else
		chKBMPFSK_Settings = self.Settings
		self.Settings = KBMPFSK_Settings
	end

end

function SK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFSK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFSK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFSK_Settings = self.Settings
	else
		KBMPFSK_Settings = self.Settings
	end	
end

function SK:SaveVars()	
	if KBM.Options.Character then
		chKBMPFSK_Settings = self.Settings
	else
		KBMPFSK_Settings = self.Settings
	end	
end

function SK:Castbar(units)
end

function SK:RemoveUnits(UnitID)
	if self.Khargroth.UnitID == UnitID then
		self.Khargroth.Available = false
		return true
	end
	return false
end

function SK:Death(UnitID)
	if self.Khargroth.UnitID == UnitID then
		self.Khargroth.Dead = true
		return true
	end
	return false
end

function SK:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Khargroth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Khargroth.Dead = false
					self.Khargroth.Casting = false
					self.Khargroth.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Khargroth.Name, 0, 100)
					self.Phase = 1					
				end
				self.Khargroth.UnitID = unitID
				self.Khargroth.Available = true
				return self.Khargroth
			end
		end
	end
end

function SK:Reset()
	self.EncounterRunning = false
	self.Khargroth.Available = false
	self.Khargroth.UnitID = nil
	self.Khargroth.Dead = false
	self.Khargroth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function SK:Timer()
	
end

function SK.Khargroth:SetTimers(bool)	
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

function SK.Khargroth:SetAlerts(bool)
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

function SK:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Khargroth, self.Enabled)
end

function SK:Start()
	-- Create Timers

	-- Create Alerts
	
	-- Assign Alerts and Timers to Triggers
	
	self.Khargroth.CastBar = KBM.CastBar:Add(self, self.Khargroth, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end