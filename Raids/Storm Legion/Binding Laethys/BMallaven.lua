-- Mallaven Boss Mod for King Boss Mods
-- Written by Lupercal@brisesol
-- Copyright 2011
--

KBMSLRDBAMAL_Settings = nil
chKBMSLRDBAMAL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BL = KBM.BossMod["RBinding_Laethys"]

local MAL = {
	Enabled = true,
	Directory = BL.Directory,
	File = "BMallaven.lua",
	Instance = BL.Name,
	InstanceObj = BL,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 5,	
	ID = "BMallaven",
	Object = "MAL",
}

MAL.Mallaven = {
	Mod = MAL,
	Level = "??",
	Active = false,
	Name = "Mallaven",
	NameShort = "Mallaven",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "U098EC98C590A0147",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			--Enabled = true,

		},
		AlertsRef = {

		},
	}
}

KBM.RegisterMod(MAL.ID, MAL)

-- Main Unit Dictionary
MAL.Lang.Unit = {}
MAL.Lang.Unit.Mallaven = KBM.Language:Add(MAL.Mallaven.Name)
MAL.Lang.Unit.Mallaven:SetFrench("Mallaven")


-- Unit Dictionary


-- Ability Dictionary


--Mechanic Dictionary (Verbose)


MAL.Mallaven.Name = MAL.Lang.Unit.Mallaven[KBM.Lang]
MAL.Descript = MAL.Mallaven.Name

function MAL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Mallaven.Name] = self.Mallaven
	}
	for BossName, BossObj in pairs(self.Bosses) do
			if BossObj.Settings then
					if BossObj.Settings.CastBar then
							BossObj.Settings.CastBar.Override = true
							BossObj.Settings.CastBar.Multi = true
					end
			end
	end    
end

function MAL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Mallaven.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		--MechTimer = KBM.Defaults.MechTimer(),
		--PhaseMon = KBM.Defaults.PhaseMon(),
		--Alerts = KBM.Defaults.Alerts(),
		--TimersRef = self.Mallaven.Settings.TimersRef,
		--AlertsRef = self.Mallaven.Settings.AlertsRef,
	}
	KBMSLRDBLMAL_Settings = self.Settings
	chKBMSLRDBLMAL_Settings = self.Settings	
end

function MAL:SwapSettings(bool)
	if bool then
		KBMSLRDBLMAL_Settings = self.Settings
		self.Settings = chKBMSLRDBLMAL_Settings
	else
		chKBMSLRDBLMAL_Settings = self.Settings
		self.Settings = KBMSLRDBLMAL_Settings
	end
end

function MAL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBLMAL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBLMAL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBLMAL_Settings = self.Settings
	else
		KBMSLRDBLMAL_Settings = self.Settings
	end	
end

function MAL:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBAMAL_Settings = self.Settings
	else
		KBMSLRDBAMAL_Settings = self.Settings
	end	
end

function MAL:Castbar(units)
end

function MAL:RemoveUnits(UnitID)
	if self.Mallaven.UnitID == UnitID then
		self.Mallaven.Available = false
		return true
	end
	return false
end

function MAL:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		--local BossObj = self.Bosses[uDetails.name]
		if BossObj == self.Mallaven then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.UnitID = unitID
				BossObj.Dead = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.Phase = 1
				self.LastPhase = 2
				self.PhaseObj:SetPhase(1)
				--self.PhaseObj.Objectives:AddPercent(self.Mallaven, 75, 100)
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MAL:Death(UnitID)
	if self.Mallaven.UnitID == UnitID then
		self.Mallaven.Dead = true
		return true
	end
	return false
end

function MAL:Reset()
	self.EncounterRunning = false
	self.Mallaven.Available = false
	self.Mallaven.UnitID = nil
	self.Mallaven.CastBar:Remove()
	self.Mallaven.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function MAL:Timer()	
end

function MAL:DefineMenu()
	self.Menu = MAL.Menu:CreateEncounter(self.Mallaven, self.Enabled)
end

function MAL:Start()
	-- Create Timers

	KBM.Defaults.TimerObj.Assign(self.Mallaven)

	-- Create Alerts
	
	 KBM.Defaults.AlertObj.Assign(self.Mallaven)
	
	-- Assign Timers and Alerts to Triggers
	
	self.Mallaven.CastBar = KBM.Castbar:Add(self, self.Mallaven)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end