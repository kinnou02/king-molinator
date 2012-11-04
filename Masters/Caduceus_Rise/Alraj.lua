-- Faultwalker Alraj Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMCRFA_Settings = nil
chKBMMMCRFA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Alraj.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Alraj",
	Object = "MOD",
}

MOD.Alraj = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Faultwalker Alraj",
	NameShort = "Alraj",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U2D401BA071054D42",
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
MOD.Lang.Unit.Alraj = KBM.Language:Add(MOD.Alraj.Name)
MOD.Lang.Unit.Alraj:SetGerman("Bruchwandler Alraj")
MOD.Lang.Unit.Alraj:SetFrench("Alraj l'Éclopé")
MOD.Lang.Unit.Alraj:SetRussian("Альрадж Хромой")
MOD.Lang.Unit.Alraj:SetKorean("폴트워커 알라즈")
MOD.Alraj.Name = MOD.Lang.Unit.Alraj[KBM.Lang]
MOD.Descript = MOD.Alraj.Name
MOD.Lang.Unit.AlShort = KBM.Language:Add("Alraj")
MOD.Lang.Unit.AlShort:SetGerman("Alraj")
MOD.Lang.Unit.AlShort:SetFrench("Alraj")
MOD.Lang.Unit.AlShort:SetRussian("Альрадж")
MOD.Lang.Unit.AlShort:SetKorean("알라즈")
MOD.Alraj.NameShort = MOD.Lang.Unit.AlShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Alraj.Name] = self.Alraj,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Alraj.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Alraj.Settings.TimersRef,
		-- AlertsRef = self.Alraj.Settings.AlertsRef,
	}
	KBMMMCRFA_Settings = self.Settings
	chKBMMMCRFA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMCRFA_Settings = self.Settings
		self.Settings = chKBMMMCRFA_Settings
	else
		chKBMMMCRFA_Settings = self.Settings
		self.Settings = KBMMMCRFA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMCRFA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMCRFA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMCRFA_Settings = self.Settings
	else
		KBMMMCRFA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMCRFA_Settings = self.Settings
	else
		KBMMMCRFA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Alraj.UnitID == UnitID then
		self.Alraj.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Alraj.UnitID == UnitID then
		self.Alraj.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Alraj.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Alraj.Dead = false
					self.Alraj.Casting = false
					self.Alraj.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Alraj.Name, 0, 100)
					self.Phase = 1
				end
				self.Alraj.UnitID = unitID
				self.Alraj.Available = true
				return self.Alraj
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Alraj.Available = false
	self.Alraj.UnitID = nil
	self.Alraj.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Alraj:SetTimers(bool)	
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

function MOD.Alraj:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Alraj, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Alraj)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Alraj)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Alraj.CastBar = KBM.CastBar:Add(self, self.Alraj)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end