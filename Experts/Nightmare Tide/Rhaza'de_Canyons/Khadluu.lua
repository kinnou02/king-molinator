-- Khadluu Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRCKHA_Settings = nil
chKBMNTRCKHA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Rhaza'de_Canyons"]

local MOD = {
	Directory = Instance.Directory,
	File = "Khadluu.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RC_Khadluu",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Khadluu = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Khadluu Khan",
	--NameShort = "Khadluu",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0792F9C87076CDED",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Flash = KBM.Defaults.AlertObj.Create("red"),
			Energy = KBM.Defaults.AlertObj.Create("cyan"),
			Beam = KBM.Defaults.AlertObj.Create("cyan"),
			}
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Khadluu = KBM.Language:Add(MOD.Khadluu.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Flash = KBM.Language:Add("Ruby Flash")
MOD.Lang.Ability.Energy = KBM.Language:Add("Gathering Energy")
MOD.Lang.Ability.Beam = KBM.Language:Add("Solar Beam")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Khadluu[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Khadluu.Name] = self.Khadluu,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Khadluu.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Khadluu.Settings.TimersRef,
		AlertsRef = self.Khadluu.Settings.AlertsRef,
	}
	KBMNTRCKHA_Settings = self.Settings
	chKBMNTRCKHA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRCKHA_Settings = self.Settings
		self.Settings = chKBMNTRCKHA_Settings
	else
		chKBMNTRCKHA_Settings = self.Settings
		self.Settings = KBMNTRCKHA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRCKHA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRCKHA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRCKHA_Settings = self.Settings
	else
		KBMNTRCKHA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRCKHA_Settings = self.Settings
	else
		KBMNTRCKHA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Khadluu.UnitID == UnitID then
		self.Khadluu.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Khadluu.UnitID == UnitID then
		self.Khadluu.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Khadluu.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Khadluu.Dead = false
				self.Khadluu.Casting = false
				self.Khadluu.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Khadluu.Name, 0, 100)
				self.Phase = 1
			end
			self.Khadluu.UnitID = unitID
			self.Khadluu.Available = true
			return self.Khadluu
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Khadluu.Available = false
	self.Khadluu.UnitID = nil
	self.Khadluu.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Khadluu)
	
	-- Create Alerts
	self.Khadluu.AlertsRef.Flash = KBM.Alert:Create("Turn Around!", nil, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Khadluu)
	
	-- Assign Alerts and Timers to Triggers
	self.Khadluu.Triggers.Flash = KBM.Trigger:Create(self.Lang.Ability.Flash[KBM.Lang], "cast", self.Khadluu)
	self.Khadluu.Triggers.Flash:AddAlert(self.Khadluu.AlertsRef.Flash)
	
	self.Khadluu.CastBar = KBM.Castbar:Add(self, self.Khadluu)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end