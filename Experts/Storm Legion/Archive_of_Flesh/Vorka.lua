-- Vorka Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXAOFVRK_Settings = nil
chKBMSLEXAOFVRK_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EArchive_of_Flesh"]

local MOD = {
	Directory = Instance.Directory,
	File = "Vorka.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Vorka",
	Object = "MOD",
}

MOD.Vorka = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Filth Gorger Vorka",
	NameShort = "Vorka",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFA680DAF62C96082",
	TimeOut = 5,
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
MOD.Lang.Unit.Vorka = KBM.Language:Add(MOD.Vorka.Name)
MOD.Vorka.Name = MOD.Lang.Unit.Vorka[KBM.Lang]
MOD.Descript = MOD.Vorka.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Vorka")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Vorka.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Vorka.Name] = self.Vorka,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Vorka.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Vorka.Settings.TimersRef,
		-- AlertsRef = self.Vorka.Settings.AlertsRef,
	}
	KBMSLEXAOFVRK_Settings = self.Settings
	chKBMSLEXAOFVRK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXAOFVRK_Settings = self.Settings
		self.Settings = chKBMSLEXAOFVRK_Settings
	else
		chKBMSLEXAOFVRK_Settings = self.Settings
		self.Settings = KBMSLEXAOFVRK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXAOFVRK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXAOFVRK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXAOFVRK_Settings = self.Settings
	else
		KBMSLEXAOFVRK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXAOFVRK_Settings = self.Settings
	else
		KBMSLEXAOFVRK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Vorka.UnitID == UnitID then
		self.Vorka.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Vorka.UnitID == UnitID then
		self.Vorka.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Vorka.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Vorka.Dead = false
					self.Vorka.Casting = false
					self.Vorka.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Vorka.Name, 0, 100)
					self.Phase = 1
				end
				self.Vorka.UnitID = unitID
				self.Vorka.Available = true
				return self.Vorka
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Vorka.Available = false
	self.Vorka.UnitID = nil
	self.Vorka.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Vorka, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Vorka)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Vorka)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Vorka.CastBar = KBM.CastBar:Add(self, self.Vorka)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end