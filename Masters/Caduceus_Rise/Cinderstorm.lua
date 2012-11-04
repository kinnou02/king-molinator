-- Cinderstorm Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMCRCM_Settings = nil
chKBMMMCRCM_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cinderstorm.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Cinderstorm",
	Object = "MOD",
}

MOD.Cinderstorm = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Cinderstorm",
	--NameShort = "Cinderstorm",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "none",
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
MOD.Lang.Unit.Cinderstorm = KBM.Language:Add(MOD.Cinderstorm.Name)
MOD.Lang.Unit.Cinderstorm:SetGerman("Aschesturm") 
MOD.Lang.Unit.Cinderstorm:SetFrench("Cendraille")
MOD.Lang.Unit.Cinderstorm:SetRussian("Пепельный Шторм")
MOD.Lang.Unit.Cinderstorm:SetKorean("잿더미 폭풍")
MOD.Cinderstorm.Name = MOD.Lang.Unit.Cinderstorm[KBM.Lang]
MOD.Descript = MOD.Cinderstorm.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cinderstorm.Name] = self.Cinderstorm,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cinderstorm.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cinderstorm.Settings.TimersRef,
		-- AlertsRef = self.Cinderstorm.Settings.AlertsRef,
	}
	KBMMMCRCM_Settings = self.Settings
	chKBMMMCRCM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMCRCM_Settings = self.Settings
		self.Settings = chKBMMMCRCM_Settings
	else
		chKBMMMCRCM_Settings = self.Settings
		self.Settings = KBMMMCRCM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMCRCM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMCRCM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMCRCM_Settings = self.Settings
	else
		KBMMMCRCM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMCRCM_Settings = self.Settings
	else
		KBMMMCRCM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cinderstorm.UnitID == UnitID then
		self.Cinderstorm.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cinderstorm.UnitID == UnitID then
		self.Cinderstorm.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Cinderstorm.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Cinderstorm.Dead = false
					self.Cinderstorm.Casting = false
					self.Cinderstorm.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Cinderstorm.Name, 0, 100)
					self.Phase = 1
				end
				self.Cinderstorm.UnitID = unitID
				self.Cinderstorm.Available = true
				return self.Cinderstorm
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cinderstorm.Available = false
	self.Cinderstorm.UnitID = nil
	self.Cinderstorm.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Cinderstorm:SetTimers(bool)	
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

function MOD.Cinderstorm:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Cinderstorm, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Cinderstorm)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Cinderstorm)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cinderstorm.CastBar = KBM.CastBar:Add(self, self.Cinderstorm)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end