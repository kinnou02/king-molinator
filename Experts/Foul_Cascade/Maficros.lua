-- Tephra Lord Maficros Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFCTM_Settings = nil
chKBMEXFCTM_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Foul Cascade"]

local MOD = {
	Directory = Instance.Directory,
	File = "Maficros.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Maficros",
	Object = "MOD",
}

MOD.Maficros = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Tephra Lord Maficros",
	NameShort = "Maficros",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U438906C70E91EC3A",
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
MOD.Lang.Unit.Maficros = KBM.Language:Add(MOD.Maficros.Name)
MOD.Lang.Unit.Maficros:SetGerman("Tephraherrscher Maficros")
MOD.Lang.Unit.Maficros:SetFrench("Seigneur Tephra Maficros")
MOD.Lang.Unit.Maficros:SetRussian("Повелитель пепла Мафикрос")
MOD.Lang.Unit.Maficros:SetKorean("테프라 군주 마피크로스")
MOD.Maficros.Name = MOD.Lang.Unit.Maficros[KBM.Lang]
MOD.Descript = MOD.Maficros.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maficros.Name] = self.Maficros,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maficros.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Maficros.Settings.TimersRef,
		-- AlertsRef = self.Maficros.Settings.AlertsRef,
	}
	KBMEXFCTM_Settings = self.Settings
	chKBMEXFCTM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFCTM_Settings = self.Settings
		self.Settings = chKBMEXFCTM_Settings
	else
		chKBMEXFCTM_Settings = self.Settings
		self.Settings = KBMEXFCTM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFCTM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFCTM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFCTM_Settings = self.Settings
	else
		KBMEXFCTM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFCTM_Settings = self.Settings
	else
		KBMEXFCTM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Maficros.UnitID == UnitID then
		self.Maficros.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Maficros.UnitID == UnitID then
		self.Maficros.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Maficros.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maficros.Dead = false
					self.Maficros.Casting = false
					self.Maficros.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Maficros.Name, 0, 100)
					self.Phase = 1
				end
				self.Maficros.UnitID = unitID
				self.Maficros.Available = true
				return self.Maficros
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Maficros.Available = false
	self.Maficros.UnitID = nil
	self.Maficros.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Maficros:SetTimers(bool)	
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

function MOD.Maficros:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Maficros, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Maficros)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Maficros)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Maficros.CastBar = KBM.CastBar:Add(self, self.Maficros)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end