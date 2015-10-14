-- Shade of Akylios Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTNCAKY_Settings = nil
chKBMNTNCAKY_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Nightmare_Coast"]

local MOD = {
	Directory = Instance.Directory,
	File = "Akylios.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NC_Akylios",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Akylios = KBM.Language:Add("Shade of Akylios")
MOD.Lang.Unit.Akylios:SetFrench("Ombre d'Akylios")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Tide = KBM.Language:Add("Crushing Tide")
MOD.Lang.Ability.Tide:SetFrench("Marée écrasante")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.TideWarn = KBM.Language:Add("Hide!")
MOD.Lang.Verbose.TideWarn:SetFrench("Cachez vous!!!")
MOD.Lang.Verbose.MadnessWarn = KBM.Language:Add("Collect 5 Green Orbs!")
MOD.Lang.Verbose.MadnessWarn:SetFrench("Prenez 5 orbes!!!")

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Madness = KBM.Language:Add("Descent Into Madness")
MOD.Lang.Debuff.Madness:SetFrench("Descente en folie")
MOD.Lang.Debuff.MadnessID = "B4B083D895F08653F"

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Akylios[KBM.Lang]

MOD.Akylios = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Akylios[KBM.Lang],
	NameShort = "Akylios",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U05C40C6B26C15AEE",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  TideWarn = KBM.Defaults.AlertObj.Create("blue"),
		  Madness = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Akylios.Name] = self.Akylios,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Akylios.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Akylios.Settings.TimersRef,
		AlertsRef = self.Akylios.Settings.AlertsRef,
	}
	KBMNTNCAKY_Settings = self.Settings
	chKBMNTNCAKY_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTNCAKY_Settings = self.Settings
		self.Settings = chKBMNTNCAKY_Settings
	else
		chKBMNTNCAKY_Settings = self.Settings
		self.Settings = KBMNTNCAKY_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTNCAKY_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTNCAKY_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTNCAKY_Settings = self.Settings
	else
		KBMNTNCAKY_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTNCAKY_Settings = self.Settings
	else
		KBMNTNCAKY_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Akylios.UnitID == UnitID then
		self.Akylios.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Akylios.UnitID == UnitID then
		self.Akylios.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Akylios.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Akylios.Dead = false
				self.Akylios.Casting = false
				self.Akylios.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Akylios, 0, 100)
				self.Phase = 1
			end
			self.Akylios.UnitID = unitID
			self.Akylios.Available = true
			return self.Akylios
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Akylios.Available = false
	self.Akylios.UnitID = nil
	self.Akylios.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end



function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Akylios)
	
	-- Create Alerts
	self.Akylios.AlertsRef.Madness = KBM.Alert:Create(self.Lang.Verbose.MadnessWarn[KBM.Lang], nil, true, true, "purple")
	self.Akylios.AlertsRef.TideWarn = KBM.Alert:Create(self.Lang.Verbose.TideWarn[KBM.Lang], nil, true, false, "blue")
	KBM.Defaults.AlertObj.Assign(self.Akylios)
	
	-- Assign Alerts and Timers to Triggers
	self.Akylios.Triggers.Madness = KBM.Trigger:Create(self.Lang.Debuff.Madness[KBM.Lang], "playerDebuff", self.Akylios)
	self.Akylios.Triggers.Madness:AddAlert(self.Akylios.AlertsRef.Madness, true)
	
	self.Akylios.Triggers.Tide = KBM.Trigger:Create(self.Lang.Ability.Tide[KBM.Lang], "cast", self.Akylios)
	self.Akylios.Triggers.Tide:AddAlert(self.Akylios.AlertsRef.TideWarn)
	
	self.Akylios.CastBar = KBM.Castbar:Add(self, self.Akylios)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end