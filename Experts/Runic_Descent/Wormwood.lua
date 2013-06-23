-- Wormwood Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXRDWD_Settings = nil
chKBMEXRDWD_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Runic Descent"]

local MOD = {
	Directory = Instance.Directory,
	File = "Wormwood.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Wormwood",
	Object = "MOD",
}

MOD.Wormwood = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Wormwood",
	--NameShort = "Wormwood",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U7DA7C4360F5A75EF",
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
MOD.Lang.Unit.Wormwood = KBM.Language:Add(MOD.Wormwood.Name)
MOD.Lang.Unit.Wormwood:SetGerman("Wurmholz")
MOD.Lang.Unit.Wormwood:SetFrench("Verbois")
MOD.Lang.Unit.Wormwood:SetRussian("Черводрев")
MOD.Lang.Unit.Wormwood:SetKorean("웜우드")
MOD.Wormwood.Name = MOD.Lang.Unit.Wormwood[KBM.Lang]
MOD.Descript = MOD.Wormwood.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Wormwood.Name] = self.Wormwood,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Wormwood.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Wormwood.Settings.TimersRef,
		-- AlertsRef = self.Wormwood.Settings.AlertsRef,
	}
	KBMEXRDWD_Settings = self.Settings
	chKBMEXRDWD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXRDWD_Settings = self.Settings
		self.Settings = chKBMEXRDWD_Settings
	else
		chKBMEXRDWD_Settings = self.Settings
		self.Settings = KBMEXRDWD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXRDWD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXRDWD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXRDWD_Settings = self.Settings
	else
		KBMEXRDWD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXRDWD_Settings = self.Settings
	else
		KBMEXRDWD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Wormwood.UnitID == UnitID then
		self.Wormwood.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Wormwood.UnitID == UnitID then
		self.Wormwood.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Wormwood.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Wormwood.Dead = false
					self.Wormwood.Casting = false
					self.Wormwood.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Wormwood.Name, 0, 100)
					self.Phase = 1
				end
				self.Wormwood.UnitID = unitID
				self.Wormwood.Available = true
				return self.Wormwood
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Wormwood.Available = false
	self.Wormwood.UnitID = nil
	self.Wormwood.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Wormwood:SetTimers(bool)	
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

function MOD.Wormwood:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Wormwood)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Wormwood)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Wormwood.CastBar = KBM.CastBar:Add(self, self.Wormwood)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end