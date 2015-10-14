-- Glacieus Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTCOIGLA_Settings = nil
chKBMNTCOIGLA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Citadel_of_Insanity"]

local MOD = {
	Directory = Instance.Directory,
	File = "Glacieus.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "COI_Glacieus",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Glacieus = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Glacieus",
	--NameShort = "Glacieus",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U5F7BBC0649FDEFA7",
	TimeOut = 5,
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			 Enabled = true,
			 Spike = KBM.Defaults.AlertObj.Create("red"),
		 },
	},
}

MOD.Elemental = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Frost Elemental",
	NameShort ="Elemental",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U020EF73F3F5F1574",
	TimeOut = 5,
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Glacieus = KBM.Language:Add(MOD.Glacieus.Name)

-- Aditional Unit Dictionary
MOD.Lang.Unit.Elemental = KBM.Language:Add(MOD.Elemental.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Armor = KBM.Language:Add("Deepice Armor")
MOD.Lang.Ability.Armor:SetFrench("Armure de glace profonde")
MOD.Lang.Ability.Strike = KBM.Language:Add("Froststrike")
MOD.Lang.Ability.Strike:SetFrench("Frappe glacée")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Spike = KBM.Language:Add("Glacieus prepares to throw a frozen spike at (%a*)!")
MOD.Lang.Notify.Spike:SetFrench("Glacieus s'apprête à lancer une pointe glacée sur (%a*)!")

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Glacieus[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Glacieus.Name] = self.Glacieus,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Glacieus.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Glacieus.Settings.AlertsRef,
	}
	KBMNTCOIGLA_Settings = self.Settings
	chKBMNTCOIGLA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTCOIGLA_Settings = self.Settings
		self.Settings = chKBMNTCOIGLA_Settings
	else
		chKBMNTCOIGLA_Settings = self.Settings
		self.Settings = KBMNTCOIGLA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTCOIGLA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTCOIGLA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTCOIGLA_Settings = self.Settings
	else
		KBMNTCOIGLA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTCOIGLA_Settings = self.Settings
	else
		KBMNTCOIGLA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Glacieus.UnitID == UnitID then
		self.Glacieus.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Glacieus.UnitID == UnitID then
		self.Glacieus.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Glacieus.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Glacieus.Dead = false
				self.Glacieus.Casting = false
				self.Glacieus.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Glacieus, 0, 100)
				self.Phase = 1
			end
			self.Glacieus.UnitID = unitID
			self.Glacieus.Available = true
			return self.Glacieus
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Glacieus.Available = false
	self.Glacieus.UnitID = nil
	self.Glacieus.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	self.Glacieus.AlertsRef.Spike = KBM.Alert:Create(self.Lang.Notify.Spike[KBM.Lang],nil, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Glacieus)
	
	-- Assign Alerts and Timers to Triggers
	self.Glacieus.Triggers.Spike = KBM.Trigger:Create(self.Lang.Notify.Spike[KBM.Lang], "notify", self.Glacieus)
	self.Glacieus.Triggers.Spike:AddAlert(self.Glacieus.AlertsRef.Spike, true)
	
	self.Glacieus.CastBar = KBM.Castbar:Add(self, self.Glacieus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end