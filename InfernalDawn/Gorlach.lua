-- Gorlach Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDGL_Settings = nil
chKBMINDGL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local GL = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Gorlach.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Gorlach",
	Object = "GL",
}

GL.Gorlach = {
	Mod = GL,
	Level = "??",
	Active = false,
	Name = "Gorlach",
	NameShort = "Gorlach",
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

KBM.RegisterMod(GL.ID, GL)

-- Main Unit Dictionary
GL.Lang.Unit = {}
GL.Lang.Unit.Gorlach = KBM.Language:Add(GL.Gorlach.Name)
GL.Lang.Unit.Gorlach:SetFrench()
GL.Lang.Unit.GorlachShort = KBM.Language:Add("Gorlach")
GL.Lang.Unit.GorlachShort:SetFrench()
GL.Lang.Unit.Bouldergut = KBM.Language:Add("Bouldergut")
GL.Lang.Unit.Bouldergut:SetFrench("Rochentraille")
GL.Lang.Unit.BouldergutShort = KBM.Language:Add("Bouldergut")
GL.Lang.Unit.BouldergutShort:SetFrench("Rochentraille")

-- Ability Dictionary
GL.Lang.Ability = {}

-- Description Dictionary
GL.Lang.Main = {}
GL.Lang.Main.Descript = KBM.Language:Add("Gorlach & Bouldergut")
GL.Lang.Main.Descript:SetFrench("Gorlach & Rochentraille")
GL.Descript = GL.Lang.Main.Descript[KBM.Lang]

GL.Bouldergut = {
	Mod = WD,
	Level = "??",
	Active = false,
	Name = "Bouldergut",
	NameShort = "Bouldergut",
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

function GL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gorlach.Name] = self.Gorlach,
		[self.Bouldergut.Name] = self.Bouldergut,
	}
	KBM_Boss[self.Gorlach.Name] = self.Gorlach
	KBM_Boss[self.Bouldergut.Name] = self.Bouldergut
end

function GL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gorlach.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Gorlach.Settings.TimersRef,
		-- AlertsRef = self.Gorlach.Settings.AlertsRef,
	}
	KBMINDGL_Settings = self.Settings
	chKBMINDGL_Settings = self.Settings
	
end

function GL:SwapSettings(bool)

	if bool then
		KBMINDGL_Settings = self.Settings
		self.Settings = chKBMINDGL_Settings
	else
		chKBMINDGL_Settings = self.Settings
		self.Settings = KBMINDGL_Settings
	end

end

function GL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDGL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDGL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDGL_Settings = self.Settings
	else
		KBMINDGL_Settings = self.Settings
	end	
end

function GL:SaveVars()	
	if KBM.Options.Character then
		chKBMINDGL_Settings = self.Settings
	else
		KBMINDGL_Settings = self.Settings
	end	
end

function GL:Castbar(units)
end

function GL:RemoveUnits(UnitID)
	if self.Gorlach.UnitID == UnitID then
		self.Gorlach.Available = false
		return true
	end
	return false
end

function GL:Death(UnitID)
	if self.Gorlach.UnitID == UnitID then
		self.Gorlach.Dead = true
		self.SetObjectives()
		self.Gorlach.CastBar:Remove()
	elseif self.Bouldergut.UnitID == UnitID then
		self.Bouldergut.Dead = true
		self.SetObjectives()
	end
	if self.Gorlach.Dead and self.Bouldergut.Dead then
		return true
	end
	return false
end

function GL:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Gorlach.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.SetObjectives()
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Gorlach.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Gorlach
			end
		end
	end
end

function GL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Gorlach.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function GL:Timer()	
end

function GL.Gorlach:SetTimers(bool)	
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

function GL.Gorlach:SetAlerts(bool)
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

function GL:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Gorlach, self.Enabled)
end

function GL:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Gorlach)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Gorlach)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Gorlach.CastBar = KBM.CastBar:Add(self, self.Gorlach)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end