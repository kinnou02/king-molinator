-- Krasimir Barionov Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFCKB_Settings = nil
chKBMEXFCKB_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Foul Cascade"]

local MOD = {
	Directory = Instance.Directory,
	File = "Krasimir.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Krasimir",
	Object = "MOD",
}

MOD.Krasimir = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Krasimir Barionov",
	NameShort = "Krasimir",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = {
		[1] = "U5AC4C2CB54AAAE6C",
		[2] = "U31EE805D62BE070F",
	},
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

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Krasimir = KBM.Language:Add(MOD.Krasimir.Name)
MOD.Lang.Unit.Krasimir:SetGerman("Krasimir Barionov")
MOD.Lang.Unit.Krasimir:SetFrench("Krasimir Barionov")
MOD.Lang.Unit.Krasimir:SetRussian("Красимир Барионов")
MOD.Lang.Unit.Krasimir:SetKorean("크라시미르 바리오노프")
MOD.Krasimir.Name = MOD.Lang.Unit.Krasimir[KBM.Lang]
MOD.Descript = MOD.Krasimir.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Krasimir.Name] = self.Krasimir,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Krasimir.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Krasimir.Settings.TimersRef,
		-- AlertsRef = self.Krasimir.Settings.AlertsRef,
	}
	KBMEXFCKB_Settings = self.Settings
	chKBMEXFCKB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFCKB_Settings = self.Settings
		self.Settings = chKBMEXFCKB_Settings
	else
		chKBMEXFCKB_Settings = self.Settings
		self.Settings = KBMEXFCKB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFCKB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFCKB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFCKB_Settings = self.Settings
	else
		KBMEXFCKB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFCKB_Settings = self.Settings
	else
		KBMEXFCKB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Krasimir.UnitID == UnitID then
		self.Krasimir.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Krasimir.UnitID == UnitID then
		if self.Phase == 2 then
			self.Krasimir.Dead = true
			return true
		else
			self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
			self.Phase = 2
		end
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Krasimir.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Krasimir.Dead = false
					self.Krasimir.Casting = false
					self.Krasimir.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Krasimir.Name, 0, 100)
				end
				if self.Krasimir.UTID[1] == uDetails.type then
					self.PhaseObj:SetPhase(1)
					self.Phase = 1
				elseif self.Krasimir.UTID[2] == uDetails.type then
					self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
					self.Phase = 2
				end
				self.Krasimir.UnitID = unitID
				self.Krasimir.Available = true
				return self.Krasimir
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Krasimir.Available = false
	self.Krasimir.UnitID = nil
	self.Krasimir.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Krasimir:SetTimers(bool)	
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

function MOD.Krasimir:SetAlerts(bool)
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

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Krasimir, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Krasimir)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Krasimir)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Krasimir.CastBar = KBM.CastBar:Add(self, self.Krasimir)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end