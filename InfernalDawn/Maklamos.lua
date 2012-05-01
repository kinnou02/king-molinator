-- Maklamos the Scryer Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDML_Settings = nil
chKBMINDML_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local ML = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maklamos.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Maklamos the Scryer",
	Object = "ML",
}

ML.Maklamos = {
	Mod = ML,
	Level = "??",
	Active = false,
	Name = "Maklamos The Scryer",
	NameShort = "Maklamos",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Power = KBM.Defaults.AlertObj.Create("yellow"),
			Green = KBM.Defaults.AlertObj.Create("dark_green"),
			Blue = KBM.Defaults.AlertObj.Create("blue"),
			Red = KBM.Defaults.AlertObj.Create("red"),
			Distortion = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Distortion = KBM.Defaults.MechObj.Create("cyan"),
		},
	}
}

KBM.RegisterMod(ML.ID, ML)

-- Main Unit Dictionary
ML.Lang.Unit = {}
ML.Lang.Unit.Maklamos = KBM.Language:Add(ML.Maklamos.Name)
ML.Lang.Unit.Maklamos:SetGerman("Maklamos der Wahrsager")
ML.Lang.Unit.Maklamos:SetFrench("Maklamos le Divin")
ML.Lang.Unit.Jug = KBM.Language:Add("Ruthless Juggernaut")
ML.Lang.Unit.JugShort = KBM.Language:Add("Juggernaut")

-- Ability Dictionary
ML.Lang.Ability = {}
ML.Lang.Ability.Power = KBM.Language:Add("Returning Power")
ML.Lang.Ability.Crystal = KBM.Language:Add("Crystalline Desolation")

-- Debuff Dictionary
ML.Lang.Debuff = {}
ML.Lang.Debuff.Nature = KBM.Language:Add("Fractured Nature")
ML.Lang.Debuff.Green = KBM.Language:Add("Emerald Crystal Essence")
ML.Lang.Debuff.Blue = KBM.Language:Add("Azure Crystal Essence")
ML.Lang.Debuff.Red = KBM.Language:Add("Scarlet Crystal Essence")
ML.Lang.Debuff.Distortion = KBM.Language:Add("Crystalline Distortion")

ML.Maklamos.Name = ML.Lang.Unit.Maklamos[KBM.Lang]
ML.Descript = ML.Maklamos.Name

ML.Jug = {
	Mod = ML,
	Level = "??",
	Name = ML.Lang.Unit.Jug[KBM.Lang],
	NameShort = ML.Lang.Unit.JugShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
}

function ML:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maklamos.Name] = self.Maklamos,
	}
	KBM_Boss[self.Maklamos.Name] = self.Maklamos
end

function ML:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maklamos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		-- TimersRef = self.Maklamos.Settings.TimersRef,
		AlertsRef = self.Maklamos.Settings.AlertsRef,
		MechRef = self.Maklamos.Settings.MechRef,
	}
	KBMINDML_Settings = self.Settings
	chKBMINDML_Settings = self.Settings
	
end

function ML:SwapSettings(bool)

	if bool then
		KBMINDML_Settings = self.Settings
		self.Settings = chKBMINDML_Settings
	else
		chKBMINDML_Settings = self.Settings
		self.Settings = KBMINDML_Settings
	end

end

function ML:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDML_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDML_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDML_Settings = self.Settings
	else
		KBMINDML_Settings = self.Settings
	end	
end

function ML:SaveVars()	
	if KBM.Options.Character then
		chKBMINDML_Settings = self.Settings
	else
		KBMINDML_Settings = self.Settings
	end	
end

function ML:Castbar(units)
end

function ML:RemoveUnits(UnitID)
	if self.Maklamos.UnitID == UnitID then
		self.Maklamos.Available = false
		return true
	end
	return false
end

function ML.PhaseTwo()
	ML.Phase = 2
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(2)
	ML.PhaseObj.Objectives:AddPercent(ML.Maklamos.Name, 50, 80)	
end

function ML.PhaseThree()
	ML.Phase = 3
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(3)
	ML.PhaseObj.Objectives:AddPercent(ML.Maklamos.Name, 30, 50)
end

function ML.PhaseFour()
	ML.Phase = 4
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	ML.PhaseObj.Objectives:AddPercent(ML.Maklamos.Name, 0, 30)	
end

function ML:Death(UnitID)
	if self.Maklamos.UnitID == UnitID then
		self.Maklamos.Dead = true
		return true
	end
	return false
end

function ML:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Maklamos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maklamos.Dead = false
					self.Maklamos.Casting = false
					self.Maklamos.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Nature[KBM.Lang], unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Maklamos.Name, 80, 100)
					self.Phase = 1
				end
				self.Maklamos.UnitID = unitID
				self.Maklamos.Available = true
				return self.Maklamos
			end
		end
	end
end

function ML:Reset()
	self.EncounterRunning = false
	self.Maklamos.Available = false
	self.Maklamos.UnitID = nil
	self.Maklamos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function ML:Timer()	
end

function ML.Maklamos:SetTimers(bool)	
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

function ML.Maklamos:SetAlerts(bool)
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

function ML:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maklamos, self.Enabled)
end

function ML:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Maklamos)
	
	-- Create Alerts
	self.Maklamos.AlertsRef.Green = KBM.Alert:Create(self.Lang.Debuff.Green[KBM.Lang], nil, false, true, "dark_green")
	self.Maklamos.AlertsRef.Blue = KBM.Alert:Create(self.Lang.Debuff.Blue[KBM.Lang], nil, false, true, "blue")
	self.Maklamos.AlertsRef.Red = KBM.Alert:Create(self.Lang.Debuff.Red[KBM.Lang], nil, false, true, "red")
	self.Maklamos.AlertsRef.Distortion = KBM.Alert:Create(self.Lang.Debuff.Distortion[KBM.Lang], nil, false, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Maklamos)
	
	-- Create Spies
	self.Maklamos.MechRef.Distortion = KBM.MechSpy:Add(self.Lang.Debuff.Distortion[KBM.Lang], nil, "playerBuff", self.Maklamos)
	KBM.Defaults.MechObj.Assign(self.Maklamos)
	
	-- Assign Alerts and Timers to Triggers
	self.Maklamos.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Maklamos)
	self.Maklamos.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Maklamos.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Maklamos)
	self.Maklamos.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Maklamos.Triggers.PhaseFour = KBM.Trigger:Create(30, "percent", self.Maklamos)
	self.Maklamos.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Maklamos.Triggers.Green = KBM.Trigger:Create(self.Lang.Debuff.Green[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Green:AddAlert(self.Maklamos.AlertsRef.Green, true)
	self.Maklamos.Triggers.Blue = KBM.Trigger:Create(self.Lang.Debuff.Blue[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Blue:AddAlert(self.Maklamos.AlertsRef.Blue, true)
	self.Maklamos.Triggers.Red = KBM.Trigger:Create(self.Lang.Debuff.Red[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Red:AddAlert(self.Maklamos.AlertsRef.Red, true)
	self.Maklamos.Triggers.Distortion = KBM.Trigger:Create(self.Lang.Debuff.Distortion, "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Distortion:AddAlert(self.Maklamos.AlertsRef.Distortion, true)
	self.Maklamos.Triggers.Distortion:AddSpy(self.Maklamos.MechRef.Distortion)
	
	self.Maklamos.CastBar = KBM.CastBar:Add(self, self.Maklamos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end