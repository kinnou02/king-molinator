-- Glubmuk Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDDGK_Settings = nil
chKBMEXDDGK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Darkening Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Glubmuk.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Glubmuk",
	Object = "MOD",
}

MOD.Glubmuk = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Glubmuk",
	--NameShort = "Glubmuk",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U0CFEAAB42ECC5CD1",
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
MOD.Lang.Unit.Glubmuk = KBM.Language:Add(MOD.Glubmuk.Name)
MOD.Lang.Unit.Glubmuk:SetGerman("Glubmuk")
-- MOD.Lang.Unit.Glubmuk:SetFrench("")
-- MOD.Lang.Unit.Glubmuk:SetRussian("")
MOD.Glubmuk.Name = MOD.Lang.Unit.Glubmuk[KBM.Lang]
MOD.Descript = MOD.Glubmuk.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Glubmuk.Name] = self.Glubmuk,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Glubmuk.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Glubmuk.Settings.TimersRef,
		-- AlertsRef = self.Glubmuk.Settings.AlertsRef,
	}
	KBMEXDDGK_Settings = self.Settings
	chKBMEXDDGK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDDGK_Settings = self.Settings
		self.Settings = chKBMEXDDGK_Settings
	else
		chKBMEXDDGK_Settings = self.Settings
		self.Settings = KBMEXDDGK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDDGK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDDGK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDDGK_Settings = self.Settings
	else
		KBMEXDDGK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDDGK_Settings = self.Settings
	else
		KBMEXDDGK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Glubmuk.UnitID == UnitID then
		self.Glubmuk.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Glubmuk.UnitID == UnitID then
		self.Glubmuk.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Glubmuk.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Glubmuk.Dead = false
					self.Glubmuk.Casting = false
					self.Glubmuk.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Glubmuk.Name, 0, 100)
					self.Phase = 1
				end
				self.Glubmuk.UnitID = unitID
				self.Glubmuk.Available = true
				return self.Glubmuk
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Glubmuk.Available = false
	self.Glubmuk.UnitID = nil
	self.Glubmuk.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Glubmuk:SetTimers(bool)	
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

function MOD.Glubmuk:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Glubmuk, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Glubmuk)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Glubmuk)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Glubmuk.CastBar = KBM.CastBar:Add(self, self.Glubmuk)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end