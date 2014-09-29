-- Magcilian Boss Mod for King Boss Mods
-- Written by Lupercal@brisesol
-- Copyright 2011
--

KBMSLRDBMMAG_Settings = nil
chKBMSLRDBMMAG_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BM = KBM.BossMod["RBinding_Maelforge"]

local MAG = {
	Enabled = true,
	Directory = BM.Directory,
	File = "BMagcilian.lua",
	Instance = BM.Name,
	InstanceObj = BM,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 5,	
	ID = "BMagcilian",
	Object = "MAG",
}

MAG.Magcilian = {
	Mod = MAG,
	Level = "??",
	Active = false,
	Name = "Magcilian",
	NameShort = "Magcilian",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	-- Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			Enabled = true,

		-- },
		-- AlertsRef = {

		-- },
	}
}

KBM.RegisterMod(MAG.ID, MAG)

-- Main Unit Dictionary
MAG.Lang.Unit = {}
MAG.Lang.Unit.Magcilian = KBM.Language:Add(MAG.Magcilian.Name)
MAG.Lang.Unit.Magcilian:SetFrench("Magcilian")


-- Unit Dictionary


-- Ability Dictionary


--Mechanic Dictionary (Verbose)


MAG.Magcilian.Name = MAG.Lang.Unit.Magcilian[KBM.Lang]
MAG.Descript = MAG.Magcilian.Name

function MAG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Magcilian.Name] = self.Magcilian
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

function MAG:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Magcilian.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		--MechTimer = KBM.Defaults.MechTimer(),
		--PhaseMon = KBM.Defaults.PhaseMon(),
		--Alerts = KBM.Defaults.Alerts(),
		--TimersRef = self.Magcilian.Settings.TimersRef,
		--AlertsRef = self.Magcilian.Settings.AlertsRef,
	}
	KBMSLRDBMMAG_Settings = self.Settings
	chKBMSLRDBMMAG_Settings = self.Settings	
end

function MAG:SwapSettings(bool)
	if bool then
		KBMSLRDBMMAG_Settings = self.Settings
		self.Settings = chKBMSLRDBMMAG_Settings
	else
		chKBMSLRDBMMAG_Settings = self.Settings
		self.Settings = KBMSLRDBMMAG_Settings
	end
end

function MAG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBMMAG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBMMAG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBMMAG_Settings = self.Settings
	else
		KBMSLRDBMMAG_Settings = self.Settings
	end	
end

function MAG:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBMMAG_Settings = self.Settings
	else
		KBMSLRDBMMAG_Settings = self.Settings
	end	
end

function MAG:Castbar(units)
end

function MAG:RemoveUnits(UnitID)
	if self.Magcilian.UnitID == UnitID then
		self.Magcilian.Available = false
		return true
	end
	return false
end

function MAG:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		--local BossObj = self.UTID[uDetails.type]
		local BossObj = self.Bosses[uDetails.name]
		if BossObj == self.Magcilian then
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
				self.PhaseObj.Objectives:AddPercent(self.Magcilian, 0, 100)
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MAG:Death(UnitID)
	if self.Magcilian.UnitID == UnitID then
		self.Magcilian.Dead = true
		return true
	end
	return false
end

function MAG:Reset()
	self.EncounterRunning = false
	self.Magcilian.Available = false
	self.Magcilian.UnitID = nil
	self.Magcilian.CastBar:Remove()
	self.Magcilian.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function MAG:Timer()	
end

function MAG:DefineMenu()
	self.Menu = MAG.Menu:CreateEncounter(self.Magcilian, self.Enabled)
end

function MAG:Start()
	-- Create Timers

	--KBM.Defaults.TimerObj.Assign(self.Magcilian)

	-- Create Alerts
	
	--KBM.Defaults.AlertObj.Assign(self.Magcilian)
	
	-- Assign Timers and Alerts to Triggers
	
	self.Magcilian.CastBar = KBM.Castbar:Add(self, self.Magcilian)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end