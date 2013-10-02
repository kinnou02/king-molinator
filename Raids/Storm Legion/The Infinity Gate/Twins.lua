-- Viktus & Mordan Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2013
--

KBMSLRDIGVM_Settings = nil
chKBMSLRDIGVM_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IG = KBM.BossMod["RInfinity_Gate"]

local VAM = {
	Enabled = true,
	Directory = IG.Directory,
	File = "Twins.lua",
	Instance = IG.Name,
	InstanceObj = IG,
	HasPhases = true,
	Lang = {},
	ID = "SLIGTwins",
	Object = "VAM",
	Enrage = 6 * 60 + 30,
}

KBM.RegisterMod(VAM.ID, VAM)

-- Main Unit Dictionary
VAM.Lang.Unit = {}
VAM.Lang.Unit.Viktus = KBM.Language:Add("Viktus") -- 
VAM.Lang.Unit.Mordan = KBM.Language:Add("Mordan") -- 


-- Ability Dictionary
VAM.Lang.Ability = {}
VAM.Lang.Ability.Sibling = KBM.Language:Add("Sibling Rivalry")
VAM.Lang.Ability.Ravenous = KBM.Language:Add("Ravenous Legion")
VAM.Lang.Ability.Creeper = KBM.Language:Add("Ensnaring Creepers")

-- Description Dictionary
VAM.Lang.Main = {}

-- Debuff Dictionary
VAM.Lang.Debuff = {}

-- Messages Dictionary
VAM.Lang.Messages = {}

VAM.Lang.Descript = KBM.Language:Add("Viktus and Mordan")
VAM.Descript = VAM.Lang.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
VAM.Viktus = {
	Mod = VAM,
	Level = "??",
	Active = false,
	Name = VAM.Lang.Unit.Viktus[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U2A8FBF675436F58B",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Creeper = KBM.Defaults.TimerObj.Create("dark_green"),
			Sibling = KBM.Defaults.TimerObj.Create("yellow"),			
		},
		AlertsRef = {
			Enabled = true,
			Sibling = KBM.Defaults.AlertObj.Create("yellow"),
			Creeper = KBM.Defaults.AlertObj.Create("dark_green"),
		},
		MechRef = {
			Enabled = true,
			Creeper = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

VAM.Mordan = {
	Mod = VAM,
	Level = "??",
	Active = false,
	Name = VAM.Lang.Unit.Mordan[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U256C9FF41E315FD3",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Ravenous = KBM.Defaults.TimerObj.Create("purple"),
			Sibling = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Ravenous = KBM.Defaults.AlertObj.Create("purple"),
			Sibling = KBM.Defaults.AlertObj.Create("yellow"),
		},
		MechRef = {
			Enabled = true,
			Ravenous = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}


function VAM:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Viktus.Name] = self.Viktus,
		[self.Mordan.Name] = self.Mordan,
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

function VAM:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		Viktus = {
			CastBar = self.Viktus.Settings.CastBar,
			AlertsRef = self.Viktus.Settings.AlertsRef,
			TimersRef = self.Viktus.Settings.TimersRef,
			MechRef = self.Viktus.Settings.MechRef,
		},
		Mordan = {
			CastBar = self.Mordan.Settings.CastBar,
			AlertsRef = self.Mordan.Settings.AlertsRef,
			TimersRef = self.Mordan.Settings.TimersRef,
			MechRef = self.Mordan.Settings.MechRef,
		},
	}
	KBMSLRDIGVM_Settings = self.Settings
	chKBMSLRDIGVM_Settings = self.Settings
	
end

function VAM:SwapSettings(bool)

	if bool then
		KBMSLRDIGVM_Settings = self.Settings
		self.Settings = chKBMSLRDIGVM_Settings
	else
		chKBMSLRDIGVM_Settings = self.Settings
		self.Settings = KBMSLRDIGVM_Settings
	end

end

function VAM:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDIGVM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDIGVM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDIGVM_Settings = self.Settings
	else
		KBMSLRDIGVM_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function VAM:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDIGVM_Settings = self.Settings
	else
		KBMSLRDIGVM_Settings = self.Settings
	end	
end

function VAM:Castbar(units)
end

function VAM:RemoveUnits(UnitID)
	if self.Viktus.UnitID == UnitID then
		self.Viktus.Available = false
		return true
	end
	return false
end

function VAM:Death(UnitID)
	if self.Viktus.UnitID == UnitID then
		self.Viktus.Dead = true
		return true
	elseif self.Mordan.UnitID == UnitID then
		self.Mordan.Dead = true
		return true
	end
	return false
end

function VAM:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.CastBar then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Viktus, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Mordan, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					BossObj.CastBar:Remove()
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function VAM:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function VAM:Timer()	
end

function VAM:DefineMenu()
	self.Menu = IG.Menu:CreateEncounter(self.Viktus, self.Enabled)
end

function VAM:Start()
	-- Create Timers
	self.Viktus.TimersRef.Creeper = KBM.MechTimer:Add(self.Lang.Ability.Creeper[KBM.Lang], 25, false)
	self.Viktus.TimersRef.Sibling = KBM.MechTimer:Add(self.Lang.Ability.Sibling[KBM.Lang], 40, false)
	KBM.Defaults.TimerObj.Assign(self.Viktus)

	self.Mordan.TimersRef.Sibling = KBM.MechTimer:Add(self.Lang.Ability.Sibling[KBM.Lang], 40, false)
	self.Mordan.TimersRef.Ravenous = KBM.MechTimer:Add(self.Lang.Ability.Ravenous[KBM.Lang], 25, false)
	KBM.Defaults.TimerObj.Assign(self.Mordan)
	
	-- Create Alerts
	self.Viktus.AlertsRef.Sibling = KBM.Alert:Create(self.Lang.Ability.Sibling[KBM.Lang], nil, false, true, "yellow")	
	self.Viktus.AlertsRef.Creeper = KBM.Alert:Create(self.Lang.Ability.Creeper[KBM.Lang], nil, false, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Viktus)

	self.Mordan.AlertsRef.Sibling = KBM.Alert:Create(self.Lang.Ability.Sibling[KBM.Lang], nil, false, true, "yellow")	
	self.Mordan.AlertsRef.Ravenous = KBM.Alert:Create(self.Lang.Ability.Ravenous[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Mordan)

	-- Create Mechanic Spies
	self.Viktus.MechRef.Creeper = KBM.MechSpy:Add(self.Lang.Ability.Creeper[KBM.Lang], nil, "playerDebuff", self.Viktus)
	KBM.Defaults.MechObj.Assign(self.Viktus)
	
	self.Mordan.MechRef.Ravenous = KBM.MechSpy:Add(self.Lang.Ability.Ravenous[KBM.Lang], nil, "playerDebuff", self.Mordan)
	KBM.Defaults.MechObj.Assign(self.Mordan)
	
	-- Assign Alerts and Timers to Triggers
	-- Viktus
	self.Viktus.Triggers.Sibling = KBM.Trigger:Create(self.Lang.Ability.Sibling[KBM.Lang], "channel", self.Viktus)
	self.Viktus.Triggers.Sibling:AddAlert(self.Viktus.AlertsRef.Sibling)
	self.Viktus.Triggers.Sibling:AddTimer(self.Viktus.TimersRef.Sibling)
	self.Viktus.Triggers.SiblingInt = KBM.Trigger:Create(self.Lang.Ability.Sibling[KBM.Lang], "interrupt", self.Viktus)
	self.Viktus.Triggers.SiblingInt:AddStop(self.Viktus.AlertsRef.Sibling)
	--
	self.Viktus.Triggers.Creeper = KBM.Trigger:Create(self.Lang.Ability.Creeper[KBM.Lang], "cast", self.Viktus)
	self.Viktus.Triggers.Creeper:AddTimer(self.Viktus.TimersRef.Creeper)
	self.Viktus.Triggers.Creeper:AddAlert(self.Viktus.AlertsRef.Creeper)

	-- Mordan
	self.Mordan.Triggers.Sibling = KBM.Trigger:Create(self.Lang.Ability.Sibling[KBM.Lang], "channel", self.Mordan)
	self.Mordan.Triggers.Sibling:AddAlert(self.Mordan.AlertsRef.Sibling)
	self.Mordan.Triggers.Sibling:AddTimer(self.Mordan.TimersRef.Sibling)
	self.Mordan.Triggers.SiblingInt = KBM.Trigger:Create(self.Lang.Ability.Sibling[KBM.Lang], "interrupt", self.Mordan)
	self.Mordan.Triggers.SiblingInt:AddStop(self.Mordan.AlertsRef.Sibling)
	--
	self.Mordan.Triggers.Ravenous = KBM.Trigger:Create(self.Lang.Ability.Ravenous[KBM.Lang], "cast", self.Mordan)
	self.Mordan.Triggers.Ravenous:AddTimer(self.Mordan.TimersRef.Ravenous)
	self.Mordan.Triggers.Ravenous:AddAlert(self.Mordan.AlertsRef.Ravenous)
	
	self.Viktus.CastBar = KBM.Castbar:Add(self, self.Viktus)
	self.Mordan.CastBar = KBM.Castbar:Add(self, self.Mordan)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end