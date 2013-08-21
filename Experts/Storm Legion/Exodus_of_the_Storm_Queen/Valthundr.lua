-- Valthundr Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSQVR_Settings = nil
chKBMSLEXSQVR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EExodus_of_the_Storm_Queen"]

local MOD = {
	Directory = Instance.Directory,
	File = "Valthundr.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "EValthundr",
	Object = "MOD",
}

MOD.Valthundr = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = "Valthundr",
	NameShort = "Valthundr",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFCFC32E67487CD7E",
	TimeOut = 5,
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Frost = KBM.Defaults.AlertObj.Create("blue"),
			Winter = KBM.Defaults.AlertObj.Create("red"),
			WinterWarn = KBM.Defaults.AlertObj.Create("orange"),
		},
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Valthundr = KBM.Language:Add(MOD.Valthundr.Name)
MOD.Lang.Unit.Valthundr:SetGerman()
MOD.Lang.Unit.Valthundr:SetFrench()
MOD.Valthundr.Name = MOD.Lang.Unit.Valthundr[KBM.Lang]
MOD.Descript = MOD.Valthundr.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Valthundr")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Valthundr.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Frost = KBM.Language:Add("Frost Bound")
MOD.Lang.Ability.Frost:SetGerman("Frostfessel")
MOD.Lang.Ability.Winter = KBM.Language:Add("Winter's Fury")
MOD.Lang.Ability.Winter:SetGerman("Raserei des Winters") 

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.WinterWarn = KBM.Language:Add("Find a pillar and hide!")
MOD.Lang.Verbose.WinterWarn:SetGerman("Säule suchen und verstecken!")
MOD.Lang.Verbose.Winter = KBM.Language:Add("Stay hidden!")
MOD.Lang.Verbose.Winter:SetGerman("Bleib ausser Sicht!")

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Valthundr.Name] = self.Valthundr,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Valthundr.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Valthundr.Settings.TimersRef,
		AlertsRef = self.Valthundr.Settings.AlertsRef,
	}
	KBMSLEXSQVR_Settings = self.Settings
	chKBMSLEXSQVR_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXSQVR_Settings = self.Settings
		self.Settings = chKBMSLEXSQVR_Settings
	else
		chKBMSLEXSQVR_Settings = self.Settings
		self.Settings = KBMSLEXSQVR_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXSQVR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXSQVR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXSQVR_Settings = self.Settings
	else
		KBMSLEXSQVR_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXSQVR_Settings = self.Settings
	else
		KBMSLEXSQVR_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Valthundr.UnitID == UnitID then
		self.Valthundr.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Valthundr.UnitID == UnitID then
		self.Valthundr.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.UnitID = unitID
				BossObj.Dead = false
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Valthundr, 0, 100)
				self.Phase = 1
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Valthundr.Available = false
	self.Valthundr.UnitID = nil
	self.Valthundr.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Valthundr)
	
	-- Create Alerts
	self.Valthundr.AlertsRef.Frost = KBM.Alert:Create(self.Lang.Ability.Frost[KBM.Lang], nil, true, true, "blue")
	self.Valthundr.AlertsRef.WinterWarn = KBM.Alert:Create(self.Lang.Verbose.WinterWarn[KBM.Lang], nil, false, false, "orange")
	self.Valthundr.AlertsRef.Winter = KBM.Alert:Create(self.Lang.Verbose.Winter[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Valthundr)
	
	-- Assign Alerts and Timers to Triggers
	self.Valthundr.Triggers.Frost = KBM.Trigger:Create(self.Lang.Ability.Frost[KBM.Lang], "cast", self.Valthundr)
	self.Valthundr.Triggers.Frost:AddAlert(self.Valthundr.AlertsRef.Frost)
	self.Valthundr.Triggers.WinterWarn = KBM.Trigger:Create(self.Lang.Ability.Winter[KBM.Lang], "cast", self.Valthundr)
	self.Valthundr.Triggers.WinterWarn:AddAlert(self.Valthundr.AlertsRef.WinterWarn)
	self.Valthundr.Triggers.Winter = KBM.Trigger:Create(self.Lang.Ability.Winter[KBM.Lang], "channel", self.Valthundr)
	self.Valthundr.Triggers.Winter:AddAlert(self.Valthundr.AlertsRef.Winter)
	
	self.Valthundr.CastBar = KBM.Castbar:Add(self, self.Valthundr)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end