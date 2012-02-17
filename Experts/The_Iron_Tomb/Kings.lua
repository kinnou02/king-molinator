-- The Three Kings Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTITTK_Settings = nil
chKBMEXTITTK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["The Iron Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Laric.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	TimeoutOverride = true,
	Timeout = 15,
	HasPhases = true,
	Lang = {},
	ID = "Laric",
}

MOD.Laric = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Laric the Ascendant",
	NameShort = "Laric",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	ExpertID = "Expert",
	-- MasterID = "U024CAD61448FED64",
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

MOD.Lang.Laric = KBM.Language:Add(MOD.Laric.Name)
-- MOD.Lang.Laric:SetGerman("")
-- MOD.Lang.Laric:SetFrench("")
-- MOD.Lang.Laric:SetRussian("")
MOD.Laric.Name = MOD.Lang.Laric[KBM.Lang]
MOD.Lang.Descript = KBM.Language:Add("The Three Kings")
-- MOD.Lang.Descript.German = ""
MOD.Descript = MOD.Lang.Descript[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Derribec = KBM.Language:Add("Derribec the Magus")
-- MOD.Lang.Unit.Derribec.German = ""
MOD.Lang.Unit.Humbart = KBM.Language:Add("Humbart the Bold")
-- MOD.Lang.Unit.Humbart.German = ""

MOD.Derribec = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Derribec[KBM.Lang],
	NameShort = "Derribec",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

MOD.Humbart = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Humbart[KBM.Lang],
	NameShort = "Humbart",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Laric.Name] = self.Laric,
		[self.Derribec.Name] = self.Derribec,
		[self.Humbart.Name] = self.Humbart
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Laric.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Laric.Settings.TimersRef,
		-- AlertsRef = self.Laric.Settings.AlertsRef,
	}
	KBMEXTITTK_Settings = self.Settings
	chKBMEXTITTK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXTITTK_Settings = self.Settings
		self.Settings = chKBMEXTITTK_Settings
	else
		chKBMEXTITTK_Settings = self.Settings
		self.Settings = KBMEXTITTK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXTITTK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXTITTK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXTITTK_Settings = self.Settings
	else
		KBMEXTITTK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXTITTK_Settings = self.Settings
	else
		KBMEXTITTK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Laric.UnitID == UnitID then
		self.Laric.Available = false
		return true
	end
	return false
end

function MOD.SetObjectives()
	MOD.PhaseObj.Objectives:Remove()
	if not MOD.Laric.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Laric.Name, 0, 100)
		MOD.PhaseObj.Objectives:AddPercent(MOD.Derribec.Name, 0, 100)	
		MOD.PhaseObj.Objectives:AddPercent(MOD.Humbart.Name, 0, 100)
	end
end

function MOD:Death(UnitID)
	if self.Laric.UnitID == UnitID then
		self.Laric.Dead = true
		self.Laric.CastBar:Remove()
	elseif self.Derribec.UnitID == UnitID then
		self.Derribec.Dead = true
	elseif self.Humbart.UnitID == UnitID then
		self.Humbart.Dead = true
	end
	if self.Laric.Dead and self.Derribec.Dead and self.Humbart.Dead then
		if self.Phase == 1 then
			self.PhaseObj.Objectives:Remove()
			self.Phase = 2
			self.PhaseObj:SetPhase(2)
			self.SetObjectives()
			self.Laric.Dead = false
			self.Derribec.Dead = false
			self.Humbart.Dead = false
		else
			return true
		end
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
					if BossObj.Name == self.Laric.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.SetObjectives()
					if BossObj.Name == self.Humbart.Name then
						self.Phase = 1
					end
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Laric.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Laric
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
	self.Laric.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Laric:SetTimers(bool)	
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

function MOD.Laric:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Laric, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Laric)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Laric)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Laric.CastBar = KBM.CastBar:Add(self, self.Laric)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end