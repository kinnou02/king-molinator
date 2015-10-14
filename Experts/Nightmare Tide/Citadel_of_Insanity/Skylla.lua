-- Skylla Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTCOISKY_Settings = nil
chKBMNTCOISKY_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Citadel_of_Insanity"]

local MOD = {
	Directory = Instance.Directory,
	File = "Skylla.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "COI_Skylla",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Skylla = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Skylla",
	--NameShort = "Skylla",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U52BA8DB20F32CC1F",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Skylla = KBM.Language:Add(MOD.Skylla.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Pillars = KBM.Language:Add("Fuel Nightmare Portal")
MOD.Lang.Ability.Pillars:SetFrench("Renforcement du portail")
MOD.Lang.Ability.Contagion = KBM.Language:Add("Arrersting Contagion")
MOD.Lang.Ability.Contagion:SetFrench("Contagion saisissante")
MOD.Lang.Ability.AoN = KBM.Language:Add("All or Nothing")
MOD.Lang.Ability.AoN:SetFrench("Tout ou rien!")
MOD.Lang.Ability.Bite = KBM.Language:Add("Infection Bite")
MOD.Lang.Ability.Bite:SetFrench("Bile infectieuse")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Skylla[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Skylla.Name] = self.Skylla,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Skylla.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		-- AlertsRef = self.Baird.Settings.AlertsRef,
	}
	KBMNTCOISKY_Settings = self.Settings
	chKBMNTCOISKY_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTCOISKY_Settings = self.Settings
		self.Settings = chKBMNTCOISKY_Settings
	else
		chKBMNTCOISKY_Settings = self.Settings
		self.Settings = KBMNTCOISKY_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTCOISKY_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTCOISKY_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTCOISKY_Settings = self.Settings
	else
		KBMNTCOISKY_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTCOISKY_Settings = self.Settings
	else
		KBMNTCOISKY_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Skylla.UnitID == UnitID then
		self.Skylla.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Skylla.UnitID == UnitID then
		self.Skylla.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Skylla.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Skylla.Dead = false
				self.Skylla.Casting = false
				self.Skylla.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Skylla, 0, 100)
				self.Phase = 1
			end
			self.Skylla.UnitID = unitID
			self.Skylla.Available = true
			return self.Skylla
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Skylla.Available = false
	self.Skylla.UnitID = nil
	self.Skylla.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Baird)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Skylla.CastBar = KBM.Castbar:Add(self, self.Skylla)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end