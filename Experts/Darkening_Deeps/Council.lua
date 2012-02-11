-- The Gedlo Council Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDDTC_Settings = nil
chKBMEXDDTC_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Darkening Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Nuggo.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Nuggo",
}

MOD.Nuggo = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "High Shaman Nuggo",
	NameShort = "Nuggo",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	ExpertID = "U43E685D74CAA6694",
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

MOD.Lang.Nuggo = KBM.Language:Add(MOD.Nuggo.Name)
MOD.Lang.Nuggo:SetGerman("Oberschamane Nuggo")
-- MOD.Lang.Nuggo:SetFrench("")
-- MOD.Lang.Nuggo:SetRussian("")
MOD.Nuggo.Name = MOD.Lang.Nuggo[KBM.Lang]
MOD.Lang.Descript = KBM.Language:Add("The Gedlo Council")
MOD.Lang.Descript.German = "Gedlo-Rat"
MOD.Descript = MOD.Lang.Descript[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Swedge = KBM.Language:Add("Warlord Swedge")
MOD.Lang.Unit.Swedge.German = "Kriegsherr Swedge"
MOD.Lang.Unit.Gerbik = KBM.Language:Add("Incinerator Gerbik")
MOD.Lang.Unit.Gerbik.German = "Entflammer Gerbik"

MOD.Swedge = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Swedge[KBM.Lang],
	NameShort = "Swedge",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

MOD.Gerbik = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Gerbik[KBM.Lang],
	NameShort = "Gerbik",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Nuggo.Name] = self.Nuggo,
		[self.Swedge.Name] = self.Swedge,
		[self.Gerbik.Name] = self.Gerbik
	}
	KBM_Boss[self.Nuggo.Name] = self.Nuggo
	KBM_Boss[self.Swedge.Name] = self.Swedge
	KBM_Boss[self.Gerbik.Name] = self.Gerbik
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Nuggo.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Nuggo.Settings.TimersRef,
		-- AlertsRef = self.Nuggo.Settings.AlertsRef,
	}
	KBMEXDDAB_Settings = self.Settings
	chKBMEXDDAB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDDAB_Settings = self.Settings
		self.Settings = chKBMEXDDAB_Settings
	else
		chKBMEXDDAB_Settings = self.Settings
		self.Settings = KBMEXDDAB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDDAB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDDAB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDDAB_Settings = self.Settings
	else
		KBMEXDDAB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDDAB_Settings = self.Settings
	else
		KBMEXDDAB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Nuggo.UnitID == UnitID then
		self.Nuggo.Available = false
		return true
	end
	return false
end

function MOD.SetObjectives()
	MOD.PhaseObj.Objectives:Remove()
	if not MOD.Nuggo.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Nuggo.Name, 0, 100)
	end
	if not MOD.Swedge.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Swedge.Name, 0, 100)	
	end
	if not MOD.Gerbik.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Gerbik.Name, 0, 100)
	end
end

function MOD:Death(UnitID)
	if self.Nuggo.UnitID == UnitID then
		self.Nuggo.Dead = true
		self.SetObjectives()
		self.Nuggo.CastBar:Remove()
	elseif self.Swedge.UnitID == UnitID then
		self.Swedge.Dead = true
		self.SetObjectives()
	elseif self.Gerbik.UnitID == UnitID then
		self.Gerbik.Dead = true
		self.SetObjectives()
	end
	if self.Nuggo.Dead and self.Swedge.Dead and self.Gerbik.Dead then
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
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
					if BossObj.Name == self.Nuggo.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.SetObjectives()
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Nuggo.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Nuggo
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Nuggo.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Nuggo:SetTimers(bool)	
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

function MOD.Nuggo:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Nuggo, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Nuggo)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Nuggo)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Nuggo.CastBar = KBM.CastBar:Add(self, self.Nuggo)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end