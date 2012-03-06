-- Grand Apiarist Orban Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXUROTFGO_Settings = nil
chKBMEXUROTFGO_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["The Realm of the Fae"]

local MOD = {
	Directory = Instance.Directory,
	File = "Orban.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Orban",
	Object = "MOD",
}

MOD.Orban = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Grand Apiarist Orban",
	NameShort = "Orban",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "Expert",
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
MOD.Lang.Unit.Orban = KBM.Language:Add(MOD.Orban.Name)
MOD.Lang.Unit.Orban:SetGerman("Orban der große Imker")
-- MOD.Lang.Unit.Orban:SetFrench("")
-- MOD.Lang.Unit.Orban:SetRussian("")
MOD.Orban.Name = MOD.Lang.Unit.Orban[KBM.Lang]
MOD.Descript = MOD.Orban.Name
MOD.Lang.Unit.OrbanShort = KBM.Language:Add(MOD.Orban.NameShort)
MOD.Lang.Unit.OrbanShort:SetGerman("Orban")
MOD.Orban.NameShort = MOD.Lang.Unit.OrbanShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Orban.Name] = self.Orban,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Orban.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Orban.Settings.TimersRef,
		-- AlertsRef = self.Orban.Settings.AlertsRef,
	}
	KBMEXUROTFGO_Settings = self.Settings
	chKBMEXUROTFGO_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXUROTFGO_Settings = self.Settings
		self.Settings = chKBMEXUROTFGO_Settings
	else
		chKBMEXUROTFGO_Settings = self.Settings
		self.Settings = KBMEXUROTFGO_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXUROTFGO_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXUROTFGO_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXUROTFGO_Settings = self.Settings
	else
		KBMEXUROTFGO_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXUROTFGO_Settings = self.Settings
	else
		KBMEXUROTFGO_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Orban.UnitID == UnitID then
		self.Orban.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Orban.UnitID == UnitID then
		self.Orban.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Orban.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Orban.Dead = false
					self.Orban.Casting = false
					self.Orban.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Orban.Name, 0, 100)
					self.Phase = 1
				end
				self.Orban.UnitID = unitID
				self.Orban.Available = true
				return self.Orban
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Orban.Available = false
	self.Orban.UnitID = nil
	self.Orban.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Orban:SetTimers(bool)	
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

function MOD.Orban:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Orban, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Orban)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Orban)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Orban.CastBar = KBM.CastBar:Add(self, self.Orban)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end