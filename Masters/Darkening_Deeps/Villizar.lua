-- Emissary Villizar Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMDDEV_Settings = nil
chKBMMMDDEV_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["MM_Darkening_Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Villizar.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Villizar",
	Object = "MOD",
}

MOD.Villizar = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Emissary Villizar",
	NameShort = "Villizar",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U5E32E9491A67613A",
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
MOD.Lang.Unit.Villizar = KBM.Language:Add(MOD.Villizar.Name)
MOD.Lang.Unit.Villizar:SetGerman("Abgesandter Villizar") 
MOD.Lang.Unit.Villizar:SetFrench("Émissaire Villizar")
MOD.Lang.Unit.Villizar:SetRussian("Посол Виллизар")
MOD.Lang.Unit.Villizar:SetKorean("밀사 빌리자르")
MOD.Villizar.Name = MOD.Lang.Unit.Villizar[KBM.Lang]
MOD.Descript = MOD.Villizar.Name
MOD.Lang.Unit.VilShort = KBM.Language:Add("Villizar")
MOD.Lang.Unit.VilShort:SetGerman()
MOD.Lang.Unit.VilShort:SetFrench()
MOD.Lang.Unit.VilShort:SetRussian("Виллизар")
MOD.Lang.Unit.VilShort:SetKorean("빌리자르")
MOD.Villizar.NameShort = MOD.Lang.Unit.VilShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Villizar.Name] = self.Villizar,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Villizar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Villizar.Settings.TimersRef,
		-- AlertsRef = self.Villizar.Settings.AlertsRef,
	}
	KBMMMDDEV_Settings = self.Settings
	chKBMMMDDEV_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMDDEV_Settings = self.Settings
		self.Settings = chKBMMMDDEV_Settings
	else
		chKBMMMDDEV_Settings = self.Settings
		self.Settings = KBMMMDDEV_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMDDEV_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMDDEV_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMDDEV_Settings = self.Settings
	else
		KBMMMDDEV_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMDDEV_Settings = self.Settings
	else
		KBMMMDDEV_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Villizar.UnitID == UnitID then
		self.Villizar.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Villizar.UnitID == UnitID then
		self.Villizar.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Villizar.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Villizar.Dead = false
					self.Villizar.Casting = false
					self.Villizar.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Villizar.Name, 0, 100)
					self.Phase = 1
				end
				self.Villizar.UnitID = unitID
				self.Villizar.Available = true
				return self.Villizar
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Villizar.Available = false
	self.Villizar.UnitID = nil
	self.Villizar.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Villizar:SetTimers(bool)	
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

function MOD.Villizar:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Villizar, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Villizar)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Villizar)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Villizar.CastBar = KBM.CastBar:Add(self, self.Villizar)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end