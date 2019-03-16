-- Enclave of Ahnket Header for King Boss Mods
-- Written by Yarrellii
-- March 2019

KBMPOAEAALLA_Settings = nil
chKBMPOAEAALLA_Settings = nil

-- Second boss Allajax :
-- cleaves
-- cast smash (bigs heals / spread out mechanic)

-- Lingering Touch : B5DE7C143926A4D01
-- purge or aoe damage around boss

-- Ahnket Parasite : B094125D7A428EDB7
-- "(%a*) has been infected with an Ahnket Parasite!"

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Enclave_Of_Ahnket"]

local MOD = {
	Directory = Instance.Directory,
	File = "Allajax.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "EA_ALLA",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Allajax = KBM.Language:Add("Allajax")

MOD.Allajax = {
	Mod = MOD,
	Level = "72",
	Active = false,
	Name = MOD.Lang.Unit.Allajax[KBM.Lang],
	NameShort = "Allajax",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U7EA9DDD90269710C",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Parasite = KBM.Defaults.AlertObj.Create("orange"),
		  Touch = KBM.Defaults.AlertObj.Create("red"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Touch = KBM.Language:Add("Purge!")
MOD.Lang.Verbose.Parasite = KBM.Language:Add("Find the portal before you die!")

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Touch = KBM.Language:Add("Lingering Touch") --Lingering Touch : B5DE7C143926A4D01

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Parasite = KBM.Language:Add("Ahnket Parasite") --Ahnket Parasite : B094125D7A428EDB7

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Parasite = KBM.Language:Add("(%a*) has been infected with an Ahnket Parasite!")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Allajax[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Allajax.Name] = self.Allajax,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Allajax.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Allajax.Settings.AlertsRef,
		MechRef = self.Allajax.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMPOAEAALLA_Settings = self.Settings
	chKBMPOAEAALLA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAEAALLA_Settings = self.Settings
		self.Settings = chKBMPOAEAALLA_Settings
	else
		chKBMPOAEAALLA_Settings = self.Settings
		self.Settings = KBMPOAEAALLA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAEAALLA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAEAALLA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAEAALLA_Settings = self.Settings
	else
		KBMPOAEAALLA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAEAALLA_Settings = self.Settings
	else
		KBMPOAEAALLA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Allajax.UnitID == UnitID then
		self.Allajax.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Allajax.UnitID == UnitID then
		self.Allajax.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Allajax.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Allajax.Dead = false
				self.Allajax.Casting = false
				self.Allajax.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				MOD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Allajax.Name, 0, 100)
				self.Phase = 1
			end
			self.Allajax.UnitID = unitID
			self.Allajax.Available = true
			return self.Allajax
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Allajax.Available = false
	self.Allajax.UnitID = nil
	self.Allajax.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Allajax)
	
	--KBM.Defaults.MechObj.Assign(self.Allajax)
	
	-- Create Alerts
	self.Allajax.AlertsRef.Parasite = KBM.Alert:Create(self.Lang.Verbose.Parasite[KBM.Lang], nil, true, true, "red")
	self.Allajax.AlertsRef.Touch = KBM.Alert:Create(self.Lang.Verbose.Touch[KBM.Lang], nil, true, true, "red")
	
	
	-- Assign Alerts and Timers to Triggers
	self.Allajax.Triggers.Victory = KBM.Trigger:Create(0, "percent", self.Allajax)
	self.Allajax.Triggers.Victory:SetVictory()
	
	self.Allajax.Triggers.Touch = KBM.Trigger:Create(self.Lang.Buff.Touch[KBM.Lang], "buff", self.Allajax)
	self.Allajax.Triggers.Touch:AddAlert(self.Allajax.AlertsRef.Touch)
	
	self.Allajax.Triggers.Parasite = KBM.Trigger:Create(self.Lang.Debuff.Parasite[KBM.Lang], "playerDebuff", self.Allajax)
    self.Allajax.Triggers.Parasite:AddAlert(self.Allajax.AlertsRef.Parasite, true)
	
	KBM.Defaults.AlertObj.Assign(self.Allajax)
			
	self.Allajax.CastBar = KBM.Castbar:Add(self, self.Allajax)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end