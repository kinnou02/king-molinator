-- Akylios Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMAK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local AK = {
	Enabled = true,
	Akylios = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	Counts = {
		Stingers = 0,
		Lashers = 0,
	},
	Timers = {},
	Lang = {},
	ID = "Akylios",
	Enrage = 60 * 20,
}

AK.Jornaru = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Jornaru",
	CastBar = nil,
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			WaveOne = KBM.Defaults.TimerObj.Create("blue"),
			WaveFour = KBM.Defaults.TimerObj.Create("blue"),
			Orb = KBM.Defaults.TimerObj.Create("orange"),
			OrbFirst = KBM.Defaults.TimerObj.Create("orange"),
			Summon = KBM.Defaults.TimerObj.Create("dark_green"),
			SummonTwo = KBM.Defaults.TimerObj.Create("dark_green"),
			SummonTwoFirst = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			WaveWarn = KBM.Defaults.AlertObj.Create("blue"),
			Orb = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

AK.Akylios = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Akylios",
	CastBar = nil,
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	PhaseObj = nil,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create("red"),
			EmergeFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			BreathFirst = KBM.Defaults.TimerObj.Create("red"),
			Emerge = KBM.Defaults.TimerObj.Create("dark_green"),
			Submerge = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Breath = KBM.Defaults.AlertObj.Create("red"),
			BreathWarn = KBM.Defaults.AlertObj.Create("red"),
			Decay = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}

AK.Stinger = {
	Mod = AK,
	Level = "??",
	Name = "Stinger of Akylios",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

AK.Lasher = {
	Mod = AK,
	Level = "??",
	Name = "Lasher of Akylios",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

KBM.RegisterMod(AK.ID, AK)

AK.Lang.Akylios = KBM.Language:Add(AK.Akylios.Name)
AK.Akylios.Name = AK.Lang.Akylios[KBM.Lang]
AK.Lang.Jornaru = KBM.Language:Add(AK.Jornaru.Name)
AK.Jornaru.Name = AK.Lang.Jornaru[KBM.Lang]

-- Unit List
AK.Lang.Unit = {}
AK.Lang.Unit.Stinger = KBM.Language:Add(AK.Stinger.Name)
AK.Stinger.Name = AK.Lang.Unit.Stinger[KBM.Lang]
AK.Lang.Unit.Lasher = KBM.Language:Add(AK.Lasher.Name)
AK.Lasher.Name = AK.Lang.Unit.Lasher[KBM.Lang]

-- Ability Dictionary.
AK.Lang.Ability = {}
AK.Lang.Ability.Decay = KBM.Language:Add("Mind Decay")
AK.Lang.Ability.Decay.German = "Geistiger Verfall"
AK.Lang.Ability.Breath = KBM.Language:Add("Breath of Madness")
AK.Lang.Ability.Breath.German = "Hauch des Wahnsinns"
AK.Lang.Ability.Grave = KBM.Language:Add("Watery Grave")

-- Debuff Dictionary.
AK.Lang.Debuff = {}

-- Mechanic Dictionary.
AK.Lang.Mechanic = {}
AK.Lang.Mechanic.Wave = KBM.Language:Add("Tidal Wave")
AK.Lang.Mechanic.Wave.German = "Flutwelle"
AK.Lang.Mechanic.Orb = KBM.Language:Add("Suffocating Orb")
AK.Lang.Mechanic.Orb.German = "Erstickungskugel"
AK.Lang.Mechanic.Summon = KBM.Language:Add("Summon the Abyss")
AK.Lang.Mechanic.Emerge = KBM.Language:Add("Akylios emerges")
AK.Lang.Mechanic.Emerge.German = "Akylios taucht auf"
AK.Lang.Mechanic.Submerge = KBM.Language:Add("Akylios submerges")
AK.Lang.Mechanic.Submerge.German = "Akylios taucht unter"

-- Notify Dictionary
AK.Lang.Notify = {}
AK.Lang.Notify.Orb = KBM.Language:Add("Jornaru launches a suffocating orb at (%a*)")

-- Say Dictionary
AK.Lang.Say = {}
AK.Lang.Say.PhaseTwo = KBM.Language:Add("Master, your plan is fulfilled. After a millennia of manipulation, the wards of Hammerknell are shattered. I release you, Akylios! Come forth and claim this world.")

-- Options Dictionary.
AK.Lang.Options = {}
AK.Lang.Options.WaveOne = KBM.Language:Add(AK.Lang.Mechanic.Wave[KBM.Lang].." (Phase 1)")
AK.Lang.Options.WaveFour = KBM.Language:Add(AK.Lang.Mechanic.Wave[KBM.Lang].." (Phase 4)")
AK.Lang.Options.WaveWarn = KBM.Language:Add("Warning for Waves at 5 seconds.")
AK.Lang.Options.WaveWarn.German = "Warnung für Flutwellen 5 Sekunden vorher."
AK.Lang.Options.Summon = KBM.Language:Add(AK.Lang.Mechanic.Summon[KBM.Lang].." (Phase 1)")
AK.Lang.Options.SummonTwo = KBM.Language:Add(AK.Lang.Mechanic.Summon[KBM.Lang].." (Phase 2)")
AK.Lang.Options.Orb = KBM.Language:Add(AK.Lang.Mechanic.Orb[KBM.Lang].." (P2 First)")
AK.Lang.Options.Breath = KBM.Language:Add(AK.Lang.Ability.Breath[KBM.Lang].." duration.")
AK.Lang.Options.Breath.German = AK.Lang.Ability.Breath[KBM.Lang].." Dauer." 

AK.Descript = "Akylios & Jornaru"

function AK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Jornaru.Name] = self.Jornaru,
		[self.Akylios.Name] = self.Akylios,
		[self.Stinger.Name] = self.Stinger,
		[self.Lasher.Name] = self.Lasher,
	}
	KBM_Boss[self.Jornaru.Name] = self.Jornaru
	KBM_Boss[self.Akylios.Name] = self.Akylios
	KBM.SubBoss[self.Stinger.Name] = self.Stinger
	KBM.SubBoss[self.Lasher.Name] = self.Lasher	
end

function AK:InitVars()
	self.Settings = {
		Enabled = true,
		PhaseAlt = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = {
			Override = true,
			Multi = true,
		},
		Akylios = {
			CastBar = AK.Akylios.Settings.CastBar,
			TimersRef = AK.Akylios.Settings.TimersRef,
			AlertsRef = AK.Akylios.Settings.AlertsRef,
		},
		Jornaru = {
			CastBar = AK.Jornaru.Settings.CastBar,
			TimersRef = AK.Jornaru.Settings.TimersRef,
			AlertsRef = AK.Jornaru.Settings.AlertsRef,
		},
	}
	KBMAK_Settings = self.Settings
	chKBMAK_Settings = self.Settings	
end

function AK:SwapSettings(bool)
	if bool then
		KBMAK_Settings = self.Settings
		self.Settings = chKBMAK_Settings
	else
		chKBMAK_Settings = self.Settings
		self.Settings = KBMAK_Settings
	end
end

function AK:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMAK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMAK_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMAK_Settings = self.Settings
	else
		KBMAK_Settings = self.Settings
	end

	self.Akylios.Settings.CastBar.Override = true
	self.Jornaru.Settings.CastBar.Override = true
	self.Akylios.Settings.CastBar.Multi = true
	self.Jornaru.Settings.CastBar.Multi = true
end

function AK:SaveVars()	
	if KBM.Options.Character then
		chKBMAK_Settings = self.Settings
	else
		KBMAK_Settings = self.Settings
	end	
end

function AK:Castbar(units)
end

function AK.PhaseTwo(Type)
	if (Type == "percent" and AK.Settings.PhaseAlt == true) or (Type == "say" and AK.Settings.PhaseAlt == false) then
		if AK.Phase == 1 then
			AK.PhaseObj.Objectives:Remove()
			AK.Phase = 2
			AK.PhaseObj:SetPhase(2)
			AK.PhaseObj.Objectives:AddDeath(AK.Stinger.Name, 8)
			AK.PhaseObj.Objectives:AddDeath(AK.Lasher.Name, 4)
			KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.WaveOne)
			KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.Summon)
			KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.SummonTwoFirst)
			KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.OrbFirst)
			AK.Jornaru.CastBar:Remove()
			print("Phase 2 starting!")
		end
	end
end

function AK.PhaseThree()
	AK.PhaseObj.Objectives:Remove()
	AK.Phase = 3
	AK.PhaseObj:SetPhase(3)
	AK.Lasher.UnitList = {}
	AK.Stinger.UnitList = {}
	AK.Counts.Stingers = 0
	AK.Counts.Lashers = 0
	KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.SummonTwo)
	KBM.MechTimer:AddStart(AK.Akylios.TimersRef.EmergeFirst)
	KBM.MechTimer:AddStart(AK.Akylios.TimersRef.BreathFirst)
	AK.PhaseObj.Objectives:AddPercent(AK.Akylios.Name, 55, 100)
	AK.PhaseObj.Objectives:AddPercent(AK.Jornaru.Name, 0, 50)
	print("Phase 3 starting!")	
end

function AK.PhaseFour()
	if AK.Phase < 4 then
		AK.PhaseObj.Objectives:Remove()
		AK.Phase = 4
		AK.PhaseObj:SetPhase(4)
		KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.WaveFour)
		if AK.Jornaru.UnitID then
			AK.Jornaru.CastBar:Create(AK.Jornaru.UnitID)
		end
		AK.PhaseObj.Objectives:AddPercent(AK.Akylios.Name, 15, 55)
		AK.PhaseObj.Objectives:AddPercent(AK.Jornaru.Name, 0, 50)
		print("Phase 4 starting!")
	end
end

function AK.PhaseFinal()
	if AK.Phase < 5 then
		AK.PhaseObj.Objectives:Remove()
		AK.Phase = 5
		AK.PhaseObj:SetPhase("Final")
		KBM.MechTimer:AddRemove(AK.Akylios.TimersRef.Emerge)
		KBM.MechTimer:AddRemove(AK.Akylios.TimersRef.Submerge)
		AK.PhaseObj.Objectives:AddPercent(AK.Akylios.Name, 0, 15)
		AK.PhaseObj.Objectives:AddPercent(AK.Jornaru.Name, 0, 15)
		print("Final phase starting - Good Luck!")
	end
end

function AK:RemoveUnits(UnitID)
	if self.Jornaru.UnitID == UnitID then
		self.Jornaru.Available = false
		return true
	end
	return false
end

function AK:Death(UnitID)
	if self.Jornaru.UnitID == UnitID then
		self.Jornaru.Dead = true
		if self.Akylios.Dead then
			return true
		end
	elseif self.Akylios.UnitID == UnitID then
		self.Akylios.Dead = true
		if self.Jornaru.Dead then
			return true
		end
	else
		if self.Phase < 3 then
			if self.Stinger.UnitList[UnitID] then
				self.Counts.Stingers = self.Counts.Stingers + 1
				self.Stinger.UnitList[UnitID].Dead = true
			elseif self.Lasher.UnitList[UnitID] then
				self.Counts.Lashers = self.Counts.Lashers + 1
				self.Lasher.UnitList[UnitID].Dead = true
			end
			if self.Counts.Stingers == 8 and self.Counts.Lashers == 4 then
				AK.PhaseThree()
			end
		end
	end
	return false	
end

function AK:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if uDetails.name == self.Jornaru.Name then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.Phase = 1
						self.Jornaru.CastBar:Create(unitID)
						KBM.MechTimer:AddStart(self.Jornaru.TimersRef.WaveOne)
						self.PhaseObj.Objectives:AddPercent(self.Jornaru.Name, 50, 100)
						self.PhaseObj:SetPhase(1)
						self.PhaseObj:Start(self.StartTime)
					end
					self.Jornaru.Casting = false
					self.Jornaru.UnitID = unitID
					self.Jornaru.Available = true
					return self.Jornaru
				elseif uDetails.name == self.Akylios.Name then
					if not self.Akylios.UnitID then
						self.Akylios.CastBar:Create(unitID)
					end
					self.Akylios.Casting = false
					self.Akylios.UnitID = unitID
					self.Akylios.Available = true
					return self.Akylios
				else
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						SubBossObj = {
							Mod = AK,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
					else
						self.Bosses[uDetails.name].UnitList[unitID].Available = true
						self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
					end
					return self.Bosses[uDetails.name].UnitList[unitID]
				end
			end
		end
	end	
end

function AK:Reset()
	self.EncounterRunning = false
	self.Jornaru.UnitID = nil
	self.Akylios.UnitID = nil
	self.Jornaru.Dead = false
	self.Jornaru.CastBar:Remove()
	self.Akylios.Dead = false
	self.Akylios.CastBar:Remove()
	self.Counts.Lashers = 0
	self.Counts.Stingers = 0
	self.Phase = 1
	self.Stinger.UnitList = {}
	self.Lasher.UnitList = {}
	self.PhaseObj:End(Inspect.Time.Real())	
end

function AK:Timer()
end

AK.Custom = {}
AK.Custom.Encounter = {}
function AK.Custom.Encounter.Menu(Menu)
	local Callbacks = {}

	function Callbacks:Enabled(bool)
		AK.Settings.PhaseAlt = bool
		if bool then
			AK.Jornaru.TimersRef.OrbFirst.Time = 65
			AK.Jornaru.TimersRef.SummonTwoFirst.Time = 58
		else
			AK.Jornaru.TimersRef.OrbFirst.Time = 50
			AK.Jornaru.TimersRef.SummonTwoFirst.Time = 45
		end
	end

	Header = Menu:CreateHeader("Use percentage based trigger for Phase 2", "check", "Encounter", "Main")
	Header:SetChecked(AK.Settings.PhaseAlt)
	Header:SetHook(Callbacks.Enabled)	
end

function AK.Jornaru:SetTimers(bool)	
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

function AK.Jornaru:SetAlerts(bool)
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

function AK.Akylios:SetTimers(bool)
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

function AK.Akylios:SetAlerts(bool)
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

function AK:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Akylios, self.Enabled)
end

function AK:Start()	
	-- Create Timers
	self.Jornaru.TimersRef.WaveOne = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 40, true)
	self.Jornaru.TimersRef.WaveOne.MenuName = AK.Lang.Options.WaveOne[KBM.Lang]
	self.Jornaru.TimersRef.WaveOne:SetPhase(1)
	self.Jornaru.TimersRef.WaveFour = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 50, true)
	self.Jornaru.TimersRef.WaveFour.MenuName = AK.Lang.Options.WaveFour[KBM.Lang]
	if not self.Settings.PhaseAlt then
		self.Jornaru.TimersRef.OrbFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 50)
	else
		self.Jornaru.TimersRef.OrbFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 65)
	end
	self.Jornaru.TimersRef.OrbFirst.MenuName = AK.Lang.Options.Orb[KBM.Lang]
	self.Jornaru.TimersRef.Orb = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 30)
	self.Jornaru.TimersRef.Summon = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 70)
	self.Jornaru.TimersRef.Summon:SetPhase(1)
	self.Jornaru.TimersRef.Summon.MenuName = AK.Lang.Options.Summon[KBM.Lang]
	self.Jornaru.TimersRef.SummonTwo = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 80, true)
	self.Jornaru.TimersRef.SummonTwo:SetPhase(2)
	self.Jornaru.TimersRef.SummonTwo:NoMenu()
	if not self.Settings.PhaseAlt then
		self.Jornaru.TimersRef.SummonTwoFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 45)
	else
		self.Jornaru.TimersRef.SummonTwoFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 58)
	end
	self.Jornaru.TimersRef.SummonTwoFirst:AddTimer(self.Jornaru.TimersRef.SummonTwo, 0)
	self.Jornaru.TimersRef.SummonTwoFirst.MenuName = AK.Lang.Options.SummonTwo[KBM.Lang]
	self.Akylios.TimersRef.Breath = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 25)
	self.Akylios.TimersRef.Emerge = KBM.MechTimer:Add(AK.Lang.Mechanic.Emerge[KBM.Lang], 75)
	self.Akylios.TimersRef.Emerge:NoMenu()
	self.Akylios.TimersRef.Submerge = KBM.MechTimer:Add(AK.Lang.Mechanic.Submerge[KBM.Lang], 80)
	self.Akylios.TimersRef.Submerge:NoMenu()
	self.Akylios.TimersRef.Submerge:SetPhase(4)
	self.Akylios.TimersRef.Submerge:AddTimer(self.Akylios.TimersRef.Emerge, 0)
	self.Akylios.TimersRef.Emerge:AddTimer(self.Akylios.TimersRef.Submerge, 0)
	self.Akylios.TimersRef.Emerge:SetPhase(4)
	self.Akylios.TimersRef.EmergeFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Emerge[KBM.Lang], 80)
	self.Akylios.TimersRef.EmergeFirst.MenuName = "Emerge/Submerge Timers"
	self.Akylios.TimersRef.EmergeFirst:AddTimer(self.Akylios.TimersRef.Submerge, 0)
	self.Akylios.TimersRef.BreathFirst = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 87)
	self.Akylios.TimersRef.BreathFirst.MenuName = "First Breath in Phase 3"
	
	-- Create Alerts
	self.Jornaru.AlertsRef.WaveWarn = KBM.Alert:Create(AK.Lang.Mechanic.Wave[KBM.Lang], 5, true, true, "blue")
	self.Jornaru.AlertsRef.WaveWarn.MenuName = AK.Lang.Options.WaveWarn[KBM.Lang]
	self.Jornaru.TimersRef.WaveOne:AddAlert(self.Jornaru.AlertsRef.WaveWarn, 5)
	self.Jornaru.TimersRef.WaveFour:AddAlert(self.Jornaru.AlertsRef.WaveWarn, 5)
	self.Jornaru.AlertsRef.Orb = KBM.Alert:Create(AK.Lang.Mechanic.Orb[KBM.Lang], 8, false, true, "orange")
	self.Jornaru.AlertsRef.Orb:Important()
	self.Akylios.AlertsRef.Decay = KBM.Alert:Create(AK.Lang.Ability.Decay[KBM.Lang], 10, false, true, "purple")
	self.Akylios.AlertsRef.Decay:Important()
	self.Akylios.AlertsRef.Breath = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], nil, false, true, "red")
	self.Akylios.AlertsRef.Breath.MenuName = self.Lang.Options.Breath[KBM.Lang]
	self.Akylios.AlertsRef.BreathWarn = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], nil, true, true, "red")

	KBM.Defaults.AlertObj.Assign(self.Jornaru)
	KBM.Defaults.AlertObj.Assign(self.Akylios)
	
	KBM.Defaults.TimerObj.Assign(self.Jornaru)
	KBM.Defaults.TimerObj.Assign(self.Akylios)
	
	-- Assign Mechanics to Triggers
	self.Jornaru.Triggers.Orb = KBM.Trigger:Create(AK.Lang.Notify.Orb[KBM.Lang], "notify", self.Jornaru)
	self.Jornaru.Triggers.Orb:AddAlert(self.Jornaru.AlertsRef.Orb, true)
	self.Jornaru.Triggers.Orb:AddTimer(self.Jornaru.TimersRef.Orb)
	self.Jornaru.Triggers.PhaseTwo = KBM.Trigger:Create(AK.Lang.Say.PhaseTwo[KBM.Lang], "say", self.Jornaru)
	self.Jornaru.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Jornaru.Triggers.PhaseTwoAlt = KBM.Trigger:Create(50, "percent", self.Jornaru)
	self.Jornaru.Triggers.PhaseTwoAlt:AddPhase(self.PhaseTwo)
	self.Jornaru.Triggers.Summon = KBM.Trigger:Create(self.Lang.Mechanic.Summon[KBM.Lang], "cast", self.Jornaru)
	self.Jornaru.Triggers.Summon:AddTimer(self.Jornaru.TimersRef.Summon)
	
	self.Akylios.Triggers.PhaseFour = KBM.Trigger:Create(55, "percent", self.Akylios)
	self.Akylios.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Akylios.Triggers.PhaseFinal = KBM.Trigger:Create(15, "percent", self.Akylios)
	self.Akylios.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	self.Akylios.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "playerBuff", self.Akylios)
	self.Akylios.Triggers.Decay:AddAlert(self.Akylios.AlertsRef.Decay, true)
	self.Akylios.Triggers.DecayRemove = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "playerBuffRemove", self.Akylios)
	self.Akylios.Triggers.DecayRemove:AddStop(self.Akylios.AlertsRef.Decay)
	self.Akylios.Triggers.BreathWarn = KBM.Trigger:Create(AK.Lang.Ability.Breath[KBM.Lang], "cast", self.Akylios)
	self.Akylios.Triggers.BreathWarn:AddTimer(AK.Akylios.TimersRef.Breath)
	self.Akylios.Triggers.BreathWarn:AddAlert(AK.Akylios.AlertsRef.BreathWarn)
	self.Akylios.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "channel", self.Akylios)
	self.Akylios.Triggers.Breath:AddAlert(self.Akylios.AlertsRef.Breath)
	
	self.Jornaru.CastBar = KBM.CastBar:Add(self, self.Jornaru)
	self.Akylios.CastBar = KBM.CastBar:Add(self, self.Akylios)

	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
	self:DefineMenu()	
end