-- Majolic the Bloodwalker Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXAPMB_Settings = nil
chKBMEXAPMB_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Abyssal Precipice"]

local MOD = {
	Directory = Instance.Directory,
	File = "Majolic.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Majolic",
	Object = "MOD",
}

MOD.Majolic = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Majolic the Bloodwalker",
	NameShort = "Majolic",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U1D6C16A42C8C7520",
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
MOD.Lang.Unit.Majolic = KBM.Language:Add(MOD.Majolic.Name)
MOD.Lang.Unit.Majolic:SetGerman("Majolic der Blutwandler")
MOD.Lang.Unit.Majolic:SetFrench("Majolic le Marchesang")
MOD.Lang.Unit.Majolic:SetRussian("Майолик Кровоход")
MOD.Lang.Unit.Majolic:SetKorean("살육자 마졸릭")
MOD.Majolic.Name = MOD.Lang.Unit.Majolic[KBM.Lang]
MOD.Descript = MOD.Majolic.Name
MOD.Lang.Unit.MajShort = KBM.Language:Add("Majolic")
MOD.Lang.Unit.MajShort:SetGerman()
MOD.Lang.Unit.MajShort:SetFrench()
MOD.Lang.Unit.MajShort:SetRussian("Майолик")
MOD.Lang.Unit.MajShort:SetKorean("마졸릭")
MOD.Majolic.NameShort = MOD.Lang.Unit.MajShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Majolic.Name] = self.Majolic,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Majolic.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Majolic.Settings.TimersRef,
		-- AlertsRef = self.Majolic.Settings.AlertsRef,
	}
	KBMEXAPKA_Settings = self.Settings
	chKBMEXAPKA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXAPMB_Settings = self.Settings
		self.Settings = chKBMEXAPMB_Settings
	else
		chKBMEXAPMB_Settings = self.Settings
		self.Settings = KBMEXAPMB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXAPMB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXAPMB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXAPMB_Settings = self.Settings
	else
		KBMEXAPMB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXAPMB_Settings = self.Settings
	else
		KBMEXAPMB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Majolic.UnitID == UnitID then
		self.Majolic.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Majolic.UnitID == UnitID then
		self.Majolic.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Majolic.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Majolic.Dead = false
					self.Majolic.Casting = false
					self.Majolic.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Majolic.Name, 0, 100)
					self.Phase = 1
				end
				self.Majolic.UnitID = unitID
				self.Majolic.Available = true
				return self.Majolic
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Majolic.Available = false
	self.Majolic.UnitID = nil
	self.Majolic.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Majolic:SetTimers(bool)	
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

function MOD.Majolic:SetAlerts(bool)
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




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Majolic)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Majolic)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Majolic.CastBar = KBM.CastBar:Add(self, self.Majolic)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end