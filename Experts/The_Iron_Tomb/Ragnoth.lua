-- Ragnoth the Despoiler Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTITRD_Settings = nil
chKBMEXTITRD_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Iron Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ragnoth.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ragnoth",
	Object = "MOD",
}

MOD.Ragnoth = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Ragnoth the Despoiler",
	NameShort = "Ragnoth",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U74F95B786F7E7273",
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
MOD.Lang.Unit.Ragnoth = KBM.Language:Add(MOD.Ragnoth.Name)
MOD.Lang.Unit.Ragnoth:SetGerman("Ragnoth der Brandschatzer")
MOD.Lang.Unit.Ragnoth:SetFrench("Ragnoth le Dévastateur")
MOD.Lang.Unit.Ragnoth:SetRussian("Рагнот Разоритель")
MOD.Lang.Unit.Ragnoth:SetKorean("박탈자 라그노스")
MOD.Ragnoth.Name = MOD.Lang.Unit.Ragnoth[KBM.Lang]
MOD.Descript = MOD.Ragnoth.Name
MOD.Lang.Unit.RagShort = KBM.Language:Add("Ragnoth")
MOD.Lang.Unit.RagShort:SetGerman("Ragnoth")
MOD.Lang.Unit.RagShort:SetFrench("Ragnoth")
MOD.Lang.Unit.RagShort:SetRussian("Рагнот")
MOD.Lang.Unit.RagShort:SetKorean("라그노스")
MOD.Ragnoth.NameShort = MOD.Lang.Unit.RagShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ragnoth.Name] = self.Ragnoth,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ragnoth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ragnoth.Settings.TimersRef,
		-- AlertsRef = self.Ragnoth.Settings.AlertsRef,
	}
	KBMEXTITRD_Settings = self.Settings
	chKBMEXTITRD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXTITRD_Settings = self.Settings
		self.Settings = chKBMEXTITRD_Settings
	else
		chKBMEXTITRD_Settings = self.Settings
		self.Settings = KBMEXTITRD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXTITRD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXTITRD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXTITRD_Settings = self.Settings
	else
		KBMEXTITRD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXTITRD_Settings = self.Settings
	else
		KBMEXTITRD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ragnoth.UnitID == UnitID then
		self.Ragnoth.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ragnoth.UnitID == UnitID then
		self.Ragnoth.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Ragnoth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ragnoth.Dead = false
					self.Ragnoth.Casting = false
					self.Ragnoth.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ragnoth.Name, 0, 100)
					self.Phase = 1
				end
				self.Ragnoth.UnitID = unitID
				self.Ragnoth.Available = true
				return self.Ragnoth
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ragnoth.Available = false
	self.Ragnoth.UnitID = nil
	self.Ragnoth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Ragnoth:SetTimers(bool)	
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

function MOD.Ragnoth:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Ragnoth, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Ragnoth)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Ragnoth)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Ragnoth.CastBar = KBM.CastBar:Add(self, self.Ragnoth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end