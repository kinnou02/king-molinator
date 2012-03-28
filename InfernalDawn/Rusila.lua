-- Rusila Dreadblade Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDRS_Settings = nil
chKBMINDRS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local RS = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Rusila.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Rusila Dreadblade",
	Object = "RS",
}

RS.Rusila = {
	Mod = RS,
	Level = "??",
	Active = false,
	Name = "Rusila Dreadblade",
	NameShort = "Rusila",
	Dead = false,
	Available = false,
	Menu = {},
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

KBM.RegisterMod(RS.ID, RS)

-- Main Unit Dictionary
RS.Lang.Unit = {}
RS.Lang.Unit.Rusila = KBM.Language:Add(RS.Rusila.Name)
-- RS.Lang.Unit.Rusila:SetGerman("")
-- RS.Lang.Unit.Rusila:SetFrench("")
-- RS.Lang.Unit.Rusila:SetRussian("")

-- Ability Dictionary
RS.Lang.Ability = {}

RS.Lang.Ability.Saw = KBM.Language:Add("Buzz Saw")
-- RS.Lang.Ability.Saw:SetGerman("")
-- RS.Lang.Ability.Saw:SetFrench("")
-- RS.Lang.Ability.Saw:SetRussian("")
RS.Lang.Ability.DreadShot = KBM.Language:Add("Dread Shot")
-- RS.Lang.Ability.DreadShot:SetGerman("")
-- RS.Lang.Ability.DreadShot:SetFrench("")
-- RS.Lang.Ability.DreadShot:SetRussian("")
RS.Lang.Ability.Fist = KBM.Language:Add("Fist")
-- RS.Lang.Ability.Fist:SetGerman("")
-- RS.Lang.Ability.Fist:SetFrench("")
-- RS.Lang.Ability.Fist:SetRussian("")
RS.Lang.Ability.Wrath = KBM.Language:Add("Iron Wrath")
-- RS.Lang.Ability.Wrath:SetGerman("")
-- RS.Lang.Ability.Wrath:SetFrench("")
-- RS.Lang.Ability.Wrath:SetRussian("")
RS.Lang.Ability.Chain = KBM.Language:Add("Barbed Chain")
-- RS.Lang.Ability.Chain:SetGerman("")
-- RS.Lang.Ability.Chain:SetFrench("")
-- RS.Lang.Ability.Chain:SetRussian("")

RS.Rusila.Name = RS.Lang.Unit.Rusila[KBM.Lang]
RS.Descript = RS.Rusila.Name

function RS:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Rusila.Name] = self.Rusila,
	}
end

function RS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rusila.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Rusila.Settings.TimersRef,
		-- AlertsRef = self.Rusila.Settings.AlertsRef,
	}
	KBMINDRS_Settings = self.Settings
	chKBMINDRS_Settings = self.Settings
	
end

function RS:SwapSettings(bool)

	if bool then
		KBMINDRS_Settings = self.Settings
		self.Settings = chKBMINDRS_Settings
	else
		chKBMINDRS_Settings = self.Settings
		self.Settings = KBMINDRS_Settings
	end

end

function RS:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDRS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDRS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDRS_Settings = self.Settings
	else
		KBMINDRS_Settings = self.Settings
	end	
end

function RS:SaveVars()	
	if KBM.Options.Character then
		chKBMINDRS_Settings = self.Settings
	else
		KBMINDRS_Settings = self.Settings
	end	
end

function RS:Castbar(units)
end

function RS:RemoveUnits(UnitID)
	if self.Rusila.UnitID == UnitID then
		self.Rusila.Available = false
		return true
	end
	return false
end

function RS:Death(UnitID)
	if self.Rusila.UnitID == UnitID then
		self.Rusila.Dead = true
		return true
	end
	return false
end

function RS:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Rusila.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Rusila.Dead = false
					self.Rusila.Casting = false
					self.Rusila.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Rusila.Name, 0, 100)
					self.Phase = 1
				end
				self.Rusila.UnitID = unitID
				self.Rusila.Available = true
				return self.Rusila
			end
		end
	end
end

function RS:Reset()
	self.EncounterRunning = false
	self.Rusila.Available = false
	self.Rusila.UnitID = nil
	self.Rusila.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function RS:Timer()	
end

function RS.Rusila:SetTimers(bool)	
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

function RS.Rusila:SetAlerts(bool)
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

function RS:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Rusila, self.Enabled)
end

function RS:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Rusila)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Rusila)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Rusila.CastBar = KBM.CastBar:Add(self, self.Rusila)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end