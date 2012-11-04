-- Broodmother Venoxa Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTITBV_Settings = nil
chKBMEXTITBV_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Iron Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Venoxa.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Venoxa",
	Object = "MOD",
}

MOD.Venoxa = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Broodmother Venoxa",
	NameShort = "Venoxa",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U36E0A0F273270898",
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
MOD.Lang.Unit.Venoxa = KBM.Language:Add(MOD.Venoxa.Name)
MOD.Lang.Unit.Venoxa:SetGerman("Brutmutter Venoxa")
MOD.Lang.Unit.Venoxa:SetFrench("Matriarche Venoxa")
MOD.Lang.Unit.Venoxa:SetRussian("Праматерь Венокса")
MOD.Lang.Unit.Venoxa:SetKorean("여왕거미 베녹사")
MOD.Venoxa.Name = MOD.Lang.Unit.Venoxa[KBM.Lang]
MOD.Descript = MOD.Venoxa.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Venoxa.Name] = self.Venoxa,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Venoxa.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Venoxa.Settings.TimersRef,
		-- AlertsRef = self.Venoxa.Settings.AlertsRef,
	}
	KBMEXTITBV_Settings = self.Settings
	chKBMEXTITBV_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXTITBV_Settings = self.Settings
		self.Settings = chKBMEXTITBV_Settings
	else
		chKBMEXTITBV_Settings = self.Settings
		self.Settings = KBMEXTITBV_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXTITBV_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXTITBV_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXTITBV_Settings = self.Settings
	else
		KBMEXTITBV_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXTITBV_Settings = self.Settings
	else
		KBMEXTITBV_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Venoxa.UnitID == UnitID then
		self.Venoxa.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Venoxa.UnitID == UnitID then
		self.Venoxa.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Venoxa.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Venoxa.Dead = false
					self.Venoxa.Casting = false
					self.Venoxa.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Venoxa.Name, 0, 100)
					self.Phase = 1
				end
				self.Venoxa.UnitID = unitID
				self.Venoxa.Available = true
				return self.Venoxa
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Venoxa.Available = false
	self.Venoxa.UnitID = nil
	self.Venoxa.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Venoxa:SetTimers(bool)	
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

function MOD.Venoxa:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Venoxa, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Venoxa)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Venoxa)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Venoxa.CastBar = KBM.CastBar:Add(self, self.Venoxa)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end