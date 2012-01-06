-- High Priest Arakhurn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPHA_Settings = nil
chKBMROTPHA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local HA = {
	Directory = ROTP.Directory,
	File = "Arakhurn.lua",
	Enabled = true,
	Instance = ROTP.Name,
	HasPhases = true,
	Lang = {},
	TimeoutOverride = false,
	Timeout = 30,
	Phase = 1,
	Enrage = 14.5 * 60,
	ID = "Arakhurn",
}

HA.Arakhurn = {
	Mod = HA,
	Level = "??",
	Active = false,
	Name = "High Priest Arakhurn",
	NameShort = "Arakhurn",
	Menu = {},
	Castbar = nil,
	AlertsRef = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			NovaFirst = KBM.Defaults.TimerObj.Create("red"),
			Nova = KBM.Defaults.TimerObj.Create("red"),
			NovaPThree = KBM.Defaults.TimerObj.Create("red"),
			FieryFirst = KBM.Defaults.TimerObj.Create("orange"),
			Fiery = KBM.Defaults.TimerObj.Create("orange"),
			FieryPThree = KBM.Defaults.TimerObj.Create("orange"),
			AddFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Add = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Nova = KBM.Defaults.AlertObj.Create("red"),
			Fiery = KBM.Defaults.AlertObj.Create("orange"),
			NovaWarn = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

KBM.RegisterMod(HA.ID, HA)

HA.Lang.Arakhurn = KBM.Language:Add(HA.Arakhurn.Name)
HA.Lang.Arakhurn.German = "Hohepriester Arakhurn"
HA.Lang.Arakhurn.French = "Grand Pr\195\170tre Arakhurn"

-- Ability Dictionary
HA.Lang.Ability = {}
HA.Lang.Ability.Nova = KBM.Language:Add("Fire Nova")

-- Notify Dictionary
HA.Lang.Notify = {}
HA.Lang.Notify.Nova = KBM.Language:Add("High Priest Arakhurn releases the fiery energy within")
HA.Lang.Notify.Respawn = KBM.Language:Add("The lava churns violently as a large shadow moves beneath it and then rushes to the surface")
HA.Lang.Notify.Death = KBM.Language:Add("As Arakhurn turns to ash, something stirs beneath the molten lava")

-- Buff Dictionary
HA.Lang.Buff = {}
HA.Lang.Buff.Fiery = KBM.Language:Add("Fiery Metamorphosis")

-- Debuff Dictionary
HA.Lang.Debuff = {}
HA.Lang.Debuff.Armor = KBM.Language:Add("Armor Rip")

-- Unit Dictionary
HA.Lang.Unit = {}
HA.Lang.Unit.Spawn = KBM.Language:Add("Spawn of Arakhurn")
HA.Lang.Unit.Enraged = KBM.Language:Add("Enraged Spawn of Arakhurn")

HA.Lang.Verbose = {}
HA.Lang.Verbose.Nova = KBM.Language:Add("until "..HA.Lang.Ability.Nova[KBM.Lang])

-- Menu Dictionary
HA.Lang.Menu = {}
HA.Lang.Menu.FieryFirst = KBM.Language:Add("First "..HA.Lang.Buff.Fiery[KBM.Lang])
HA.Lang.Menu.FieryPThree = KBM.Language:Add("First "..HA.Lang.Buff.Fiery[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.NovaFirst = KBM.Language:Add("First "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaPThree = KBM.Language:Add("First "..HA.Lang.Ability.Nova[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.AddFirst = KBM.Language:Add("First "..HA.Lang.Unit.Enraged[KBM.Lang])
HA.Lang.Menu.NovaWarn = KBM.Language:Add("5 second warning for "..HA.Lang.Ability.Nova[KBM.Lang])

HA.Arakhurn.Name = HA.Lang.Arakhurn[KBM.Lang]

HA.Enraged = {
	Mod = HA,
	Level = "??",
	Name = HA.Lang.Unit.Enraged[KBM.Lang],
	NameShort = "Spawn",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

function HA:AddBosses(KBM_Boss)
	self.Arakhurn.Descript = self.Arakhurn.Name
	self.MenuName = self.Arakhurn.Descript
	self.Bosses = {
		[self.Arakhurn.Name] = self.Arakhurn,
		[self.Enraged.Name] = self.Enraged,
	}
	KBM_Boss[self.Arakhurn.Name] = self.Arakhurn
	KBM.SubBoss[self.Enraged.Name] = self.Enraged
end

function HA:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arakhurn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Arakhurn.Settings.AlertsRef,
		TimersRef = self.Arakhurn.Settings.TimersRef,
	}
	KBMROTPHA_Settings = self.Settings
	chKBMROTPHA_Settings = self.Settings
	
end

function HA:SwapSettings(bool)
	if bool then
		KBMROTPHA_Settings = self.Settings
		self.Settings = chKBMROTPHA_Settings
	else
		chKBMROTPGS_Settings = self.Settings
		self.Settings = KBMROTPHA_Settings
	end
end

function HA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPHA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPHA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMROTPHA_Settings = self.Settings
	else
		KBMROTPHA_Settings = self.Settings
	end	
end

function HA:SaveVars()	
	if KBM.Options.Character then
		chKBMROTPHA_Settings = self.Settings
	else
		KBMROTPHA_Settings = self.Settings
	end	
end

function HA:Castbar(units)
end

function HA:RemoveUnits(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		self.Arakhurn.Available = false
		return true
	end
	return false
end

function HA:Death(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		if self.Phase == 3 then
			self.Arakhurn.Dead = true
			return true
		end
	end
	return false
end

function HA.Stall()
	if HA.Phase == 1 then
		HA.TimeoutOverride = true
		KBM.MechTimer:AddRemove(HA.Arakhurn.TimersRef.Nova)
		KBM.MechTimer:AddRemove(HA.Arakhurn.TimersRef.Fiery)
		HA.Arakhurn.CastBar:Remove()
		HA.Phase = 2
	end
end

function HA.PhaseTwo()
	HA.PhaseObj.Objectives:Remove()
	HA.PhaseObj:SetPhase("Adds")
	HA.PhaseObj.Objectvies:AddDeath(HA.Lang.Unit.Spawn[KBM.Lang], 6)
	HA.Arakhurn.UnitID = nil
end

function HA.PhaseThree()
	HA.Phase = 3
	HA.TimeoutOverride = false
	HA.PhaseObj.Objectives:Remove()
	HA.PhaseObj:SetPhase("Final")
	HA.PhaseObj.Objectives:AddPercent(HA.Arakhurn.Name, 0, 100)
end

function HA:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Arakhurn.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arakhurn.Dead = false
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Arakhurn.Name, 0, 100)
					self.PhaseObj:SetPhase(1)
					KBM.TankSwap:Start(self.Lang.Debuff.Armor[KBM.Lang])
					KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.NovaFirst)
					KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.FieryFirst)
				elseif self.Arakhurn.UnitID ~= unitID then
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
				end
				self.Arakhurn.UnitID = unitID
				self.Arakhurn.Available = true
				return self.Arakhurn
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = HA,
						Level = "??",
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
					KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.Add)
				else
					self.Bosses[uDetails.name].UnitList[unitID].Available = true
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]
			end
		end
	end
end

function HA:Reset()
	self.EncounterRunning = false
	self.Arakhurn.Available = false
	self.Arakhurn.UnitID = nil
	self.PhaseObj:End(Inspect.Time.Real())
	self.Arakhurn.CastBar:Remove()
	self.TimeoutOverride = false
	self.Enraged.UnitList = {}
end

function HA:Timer()	
end

function HA.Arakhurn:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function HA.Arakhurn:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function HA:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Arakhurn, self.Enabled)
end

function HA:Start()
	-- Create Timers
	self.Arakhurn.TimersRef.NovaFirst = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 46)
	self.Arakhurn.TimersRef.NovaFirst.MenuName = self.Lang.Menu.NovaFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Nova = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 60)
	self.Arakhurn.TimersRef.NovaPThree = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 52)
	self.Arakhurn.TimersRef.NovaPThree.MenuName = self.Lang.Menu.NovaPThree[KBM.Lang]
	self.Arakhurn.TimersRef.FieryFirst = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 75)
	self.Arakhurn.TimersRef.FieryFirst.MenuName = self.Lang.Menu.FieryFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Fiery = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 60)
	self.Arakhurn.TimersRef.FieryPThree = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 85)
	self.Arakhurn.TimersRef.FieryPThree.MenuName = self.Lang.Menu.FieryPThree[KBM.Lang]
	self.Arakhurn.TimersRef.AddFirst = KBM.MechTimer:Add(self.Lang.Unit.Enraged[KBM.Lang], 35)
	self.Arakhurn.TimersRef.AddFirst.MenuName = self.Lang.Menu.AddFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Add = KBM.MechTimer:Add(self.Lang.Unit.Enraged[KBM.Lang], 90)
	KBM.Defaults.TimerObj.Assign(self.Arakhurn)
	
	-- Create Alerts
	self.Arakhurn.AlertsRef.Nova = KBM.Alert:Create(self.Lang.Ability.Nova[KBM.Lang], nil, false, true, "red")
	self.Arakhurn.AlertsRef.NovaWarn = KBM.Alert:Create(self.Lang.Verbose.Nova[KBM.Lang], 5, true, true, "red")
	self.Arakhurn.AlertsRef.NovaWarn.MenuName = self.Lang.Menu.NovaWarn[KBM.Lang]
	self.Arakhurn.AlertsRef.Fiery = KBM.Alert:Create(self.Lang.Buff.Fiery[KBM.Lang], nil, true, true, "orange")
	self.Arakhurn.TimersRef.NovaFirst:AddAlert(self.Arakhurn.AlertsRef.NovaWarn, 5)
	self.Arakhurn.TimersRef.Nova:AddAlert(self.Arakhurn.AlertsRef.NovaWarn, 5)
	self.Arakhurn.TimersRef.NovaPThree:AddAlert(self.Arakhurn.AlertsRef.NovaWarn, 5)
	KBM.Defaults.AlertObj.Assign(self.Arakhurn)
	
	-- Assign Timers and Alerts to Triggers
	self.Arakhurn.Triggers.Stall = KBM.Trigger:Create(1, "percent", self.Arakhurn)
	self.Arakhurn.Triggers.Stall:AddPhase(self.Stall)
	self.Arakhurn.Triggers.Nova = KBM.Trigger:Create(self.Lang.Ability.Nova[KBM.Lang], "cast", self.Arakhurn)
	self.Arakhurn.Triggers.Nova:AddTimer(self.Arakhurn.TimersRef.Nova)
	self.Arakhurn.Triggers.Nova:AddAlert(self.Arakhurn.AlertsRef.Nova)
	self.Arakhurn.Triggers.Fiery = KBM.Trigger:Create(self.Lang.Buff.Fiery[KBM.Lang], "playerBuff", self.Arakhurn)
	self.Arakhurn.Triggers.Fiery:AddTimer(self.Arakhurn.TimersRef.Fiery)
	self.Arakhurn.Triggers.Fiery:AddAlert(self.Arakhurn.AlertsRef.Fiery, true)
	self.Arakhurn.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Notify.Death[KBM.Lang], "notify", self.Arakhurn)
	self.Arakhurn.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Arakhurn.Triggers.PhaseThree = KBM.Trigger:Create(self.Lang.Notify.Respawn[KBM.Lang], "notify", self.Arakhurn)
	self.Arakhurn.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Arakhurn.Triggers.PhaseThree:AddTimer(self.Arakhurn.TimersRef.AddFirst)
	self.Arakhurn.Triggers.PhaseThree:AddTimer(self.Arakhurn.TimersRef.NovaPThree)
	self.Arakhurn.Triggers.PhaseThree:AddTimer(self.Arakhurn.TimersRef.FieryPThree)
	
	self.Arakhurn.CastBar = KBM.CastBar:Add(self, self.Arakhurn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end