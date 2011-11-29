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
	ModEnabled = true,
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
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
}

AK.Akylios = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Akylios",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	PhaseObj = nil,
	UnitID = nil,
	Triggers = {},
}

AK.Stinger = {
	Mod = AK,
	Level = "??",
	Name = "Stinger of Akylios",
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	UnitList = {},
	Ignore = true,
}

AK.Lasher = {
	Mod = AK,
	Level = "??",
	Name = "Lasher of Akylios",
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	UnitList = {},
	Ignore = true,
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
AK.Lang.Ability.Breath = KBM.Language:Add("Breath of Madness")

-- Debuff Dictionary.
AK.Lang.Debuff = {}

-- Mechanic Dictionary.
AK.Lang.Mechanic = {}
AK.Lang.Mechanic.Wave = KBM.Language:Add("Tidal Wave")
AK.Lang.Mechanic.Wave.German = "Flutwelle"
AK.Lang.Mechanic.Orb = KBM.Language:Add("Suffocating Orb")
AK.Lang.Mechanic.Summon = KBM.Language:Add("Summon the Abyss")

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
AK.Lang.Options.Summon = KBM.Language:Add(AK.Lang.Mechanic.Summon[KBM.Lang].." (Phase 1)")
AK.Lang.Options.SummonTwo = KBM.Language:Add(AK.Lang.Mechanic.Summon[KBM.Lang].." (Phase 2)")

function AK:AddBosses(KBM_Boss)
	self.Jornaru.Descript = "Akylios & Jornaru"
	self.Akylios.Descript = self.Jornaru.Descript
	self.MenuName = self.Akylios.Descript
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
		Timers = {
			Enabled = true,
			WaveOne = true,
			WaveFour = true,
			Orb = true,
			Breath = true,
			Summon = true,
			SummonTwo = true,
		},
		Alerts = {
			Enabled = true,
			WaveWarning = true,
			Orb = true,
			Breath = true,
			Decay = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
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
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		TargetLoad = chKBMAK_Settings
	else
		TargetLoad = KBMAK_Settings
	end
	
	if type(TargetLoad) == "table" then
		for Setting, Value in pairs(TargetLoad) do
			if type(TargetLoad[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(TargetLoad[Setting]) do
						if self.Settings[Setting][tSetting] ~= nil then
							self.Settings[Setting][tSetting] = tValue
						end
					end
				end
			else
				if self.Settings[Setting] ~= nil then
					self.Settings[Setting] = Value
				end
			end
		end
	end
	
	if KBM.Options.Character then
		chKBMAK_Settings = self.Settings
	else
		KBMAK_Settings = self.Settings
	end
	
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

function AK.PhaseTwo()
	AK.PhaseObj.Objectives:Remove()
	AK.Phase = 2
	AK.PhaseObj:SetPhase(2)
	AK.PhaseObj.Objectives:AddDeath(AK.Stinger.Name, 8)
	AK.PhaseObj.Objectives:AddDeath(AK.Lasher.Name, 4)
	KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.WaveOne)
	KBM.MechTimer:AddRemove(AK.Jornaru.TimersRef.Summon)
	KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.SummonTwo)
	AK.Jornaru.CastBar.Enabled = false
	print("Phase 2 starting!")
end

function AK.PhaseThree()
	AK.PhaseObj.Objectives:Remove()
	AK.Phase = 3
	AK.PhaseObj:SetPhase(3)
	AK.Lasher.UnitList = {}
	AK.Stinger.UnitList = {}
	AK.Counts.Stingers = 0
	AK.Counts.Lashers = 0
	AK.MechTimer:AddRemove(AK.Jornaru.TimersRef.SummonTwo)
	AK.PhaseObj.Objectives:AddPercent(AK.Akylios.Name, 55, 100)
	print("Phase 3 starting!")
end

function AK.PhaseFour()
	AK.PhaseObj.Objectives:Remove()
	AK.Phase = 4
	AK.PhaseObj:SetPhase("Final")
	KBM.MechTimer:AddStart(AK.Jornaru.TimersRef.WaveFour)
	AK.PhaseObj.Objectives:AddDeath(AK.Akylios.Name, 1)
	AK.PhaseObj.Objectives:AddDeath(AK.Jornaru.Name, 1)
	print("Final Phase starting!")
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
		if self.Phase == 2 then
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
					if not self.Jornaru.UnitID then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.Phase = 1
						self.Jornaru.CastBar:Create(unitID)
						KBM.MechTimer:AddStart(self.Jornaru.TimersRef.WaveOne)
						self.PhaseObj.Objectives:AddPercent(self.Jornaru.Name, 50, 100)
						self.PhaseObj:Start(self.StartTime)
					end
					self.Jornaru.Dead = false
					self.Jornaru.Casting = false
					self.Jornaru.UnitID = unitID
					self.Jornaru.Available = true
					return self.Jornaru
				elseif uDetails.name == self.Akylios.Name then
					if not self.Akylios.UnitID then
						self.Akylios.CastBar:Create(unitID)
					end
					self.Akylios.Dead = false
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
						self.Bosses[uDetails.name].UnitList[unitID].Dead = false
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
	self.Counts.Lashers = 0
	self.Counts.Stingers = 0
	self.Phase = 1
	for StingerID, Stinger in pairs(self.Stinger.UnitList) do
		Stinger = nil
	end
	self.Stinger.UnitList = {}
	for LasherID, Lasher in pairs(self.Lasher.UnitList) do
		Lasher = nil
	end
	self.Lasher.UnitList = {}
	self.PhaseObj:End(Inspect.Time.Real())
	
end

function AK:Timer()
end

function AK:SetTimers(bool)

	if bool then
		self.Jornaru.TimersRef.WaveOne.Enabled = self.Settings.Timers.WaveOne
		self.Jornaru.TimersRef.WaveFour.Enabled = self.Settings.Timers.WaveFour
		self.Jornaru.TimersRef.OrbFirst.Enabled = self.Settings.Timers.Orb
		self.Jornaru.TimersRef.Orb.Enabled = self.Settings.Timers.Orb
		self.Jornaru.TimersRef.Summon.Enabled = self.Settings.Timers.Summon
		self.Jornaru.TimersRef.SummonTwo.Enabled = self.Settings.Timers.SummonTwo
		self.Akylios.TimersRef.Breath.Enabled = self.Settings.Timers.Breath
	else
		self.Jornaru.TimersRef.WaveOne.Enabled = false
		self.Jornaru.TimersRef.WaveFour.Enabled = false
		self.Jornaru.TimersRef.OrbFirst.Enabled = false
		self.Jornaru.TimersRef.Orb.Enabled = false
		self.Jornaru.TimersRef.Summon.Enabled = false
		self.Jornaru.TimersRef.SummonTwo.Enabled = false
		self.Akylios.TimersRef.Breath.Enabled = false
	end

end

function AK:SetAlerts(bool)

	if bool then
		self.Jornaru.AlertsRef.WaveWarning.Enabled = self.Settings.Alerts.WaveWarning
		self.Jornaru.AlertsRef.Orb.Enabled = self.Settings.Alerts.Orb
		self.Akylios.AlertsRef.Decay.Enabled = self.Settings.Alerts.Decay
		self.Akylios.AlertsRef.BreathWarn.Enabled = self.Settings.Alerts.Breath
		self.Akylios.AlertsRef.Breath.Enabled = self.Settings.Alerts.Breath
	else
		self.Jornaru.AlertsRef.WaveWarning.Enabled = false
		self.Jornaru.AlertsRef.Orb.Enabled = false
		self.Akylios.AlertsRef.Decay.Enabled = false
		self.Akylios.AlertsRef.BreathWarn.Enabled = false
		self.Akylios.AlertsRef.Breath.Enabled = false
	end

end

function AK.Akylios:Options()
	-- Timer Options
	function self:Timers(bool)
		AK.Settings.Timers.Enabled = bool
		AK:SetTimers(bool)
	end
	function self:WaveOneTimer(bool)
		AK.Settings.Timers.WaveOne = bool
		AK.Jornaru.TimersRef.WaveOne.Enabled = bool
	end
	function self:WaveFourTimer(bool)
		AK.Settings.Timers.WaveFour = bool
		AK.Jornaru.TimersRef.WaveFour.Enabled = bool
	end
	function self:OrbTimer(bool)
		AK.Settings.Timers.Orb = bool
		AK.Jornaru.TimersRef.OrbFirst.Enabled = bool
		AK.Jornaru.TimersRef.Orb.Enabled = bool
	end
	function self:BreathTimer(bool)
		AK.Settings.Timers.Breath = bool
		AK.Akylios.TimersRef.Breath.Enabled = bool
	end
	function self:SummonTimer(bool)
		AK.Settings.Timers.Summon = bool
		AK.Jornaru.TimersRef.Summon.Enabled = bool
	end
	function self:SummonTwoTimer(bool)
		AK.Settings.Timers.SummonTwo = bool
		AK.Jornaru.TimersRef.SummonTwo.Enabled = bool
	end
	-- Alert Options
	function self:Alerts(bool)
		AK.Settings.Alerts.Enabled = bool
		AK:SetAlerts(bool)
	end
	function self:WaveWarning(bool)
		AK.Settings.Alerts.WaveWarning = bool
		AK.Jornaru.AlertsRef.WaveWarning.Enabled = bool
	end
	function self:OrbAlert(bool)
		AK.Settings.Alerts.Orb = bool
		AK.Jornaru.AlertsRef.Orb.Enabled = bool
	end
	function self:DecayAlert(bool)
		AK.Settings.Alerts.Decay = bool
		AK.Akylios.AlertsRef.Decay.Enabled = bool
	end
	function self:BreathAlert(bool)
		AK.Settings.Alerts.Breath = bool
		AK.Akylios.AlertsRef.Breath.Enabled = bool
		AK.Akylios.AlertsRef.BreathWarn.Enabled = bool
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader(KBM.Language.Options.TimersEnabled[KBM.Lang], self.Timers, AK.Settings.Timers.Enabled)
	Timers:AddCheck(AK.Lang.Options.WaveOne[KBM.Lang], self.WaveOneTimer, AK.Settings.Timers.WaveOne)
	Timers:AddCheck(AK.Lang.Options.WaveFour[KBM.Lang], self.WaveFourTimer, AK.Settings.Timers.WaveFour)
	Timers:AddCheck(AK.Lang.Mechanic.Orb[KBM.Lang], self.OrbTimer, AK.Settings.Timers.Orb)
	Timers:AddCheck(AK.Lang.Ability.Breath[KBM.Lang], self.BreathTimer, AK.Settings.Timers.Breath)
	Timers:AddCheck(AK.Lang.Options.Summon[KBM.Lang], self.SummonTimer, AK.Settings.Timers.Summon)
	Timers:AddCheck(AK.Lang.Options.SummonTwo[KBM.Lang], self.SummonTwoTimer, AK.Settings.Timers.SummonTwo)
	local Alerts = Options:AddHeader(KBM.Language.Options.AlertsEnabled[KBM.Lang], self.Alerts, AK.Settings.Alerts.Enabled)
	Alerts:AddCheck(AK.Lang.Options.WaveWarn[KBM.Lang], self.WaveWarning, AK.Settings.Alerts.WaveWarning)
	Alerts:AddCheck(AK.Lang.Mechanic.Orb[KBM.Lang], self.OrbAlert, AK.Settings.Alerts.Orb)
	Alerts:AddCheck(AK.Lang.Ability.Decay[KBM.Lang], self.DecayAlert, AK.Settings.Alerts.Decay)
	Alerts:AddCheck(AK.Lang.Ability.Breath[KBM.Lang], self.BreathAlert, AK.Settings.Alerts.Breath)
	
end

function AK:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Akylios.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Akylios, true, self.Header)
	self.Akylios.MenuItem.Check:SetEnabled(false)
	
	-- Create Timers
	self.Jornaru.TimersRef.WaveOne = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 40, true)
	self.Jornaru.TimersRef.WaveFour = KBM.MechTimer:Add(AK.Lang.Mechanic.Wave[KBM.Lang], 50, true)
	self.Jornaru.TimersRef.OrbFirst = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 50)
	self.Jornaru.TimersRef.Orb = KBM.MechTimer:Add(AK.Lang.Mechanic.Orb[KBM.Lang], 30)
	self.Jornaru.TimersRef.Summon = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 70)
	self.Jornaru.TimersRef.SummonTwo = KBM.MechTimer:Add(AK.Lang.Mechanic.Summon[KBM.Lang], 80, true)
	self.Akylios.TimersRef.Breath = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 25)
	self:SetTimers(self.Settings.Timers.Enabled)
	
	-- Create Alerts
	self.Jornaru.AlertsRef.WaveWarning = KBM.Alert:Create(AK.Lang.Mechanic.Wave[KBM.Lang], 5, true, true, "blue")
	self.Jornaru.AlertsRef.Orb = KBM.Alert:Create(AK.Lang.Mechanic.Orb[KBM.Lang], 8, true, true, "orange")
	self.Akylios.AlertsRef.Decay = KBM.Alert:Create(AK.Lang.Ability.Decay[KBM.Lang], 10, true, true, "purple")
	self.Akylios.AlertsRef.BreathWarn = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], 4, true, true, "red")
	self.Akylios.AlertsRef.Breath = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], 5, false, true, "red")
	self:SetAlerts(self.Settings.Alerts.Enabled)
	
	-- Assign Mechanics to Triggers
	self.Jornaru.TimersRef.WaveOne:AddAlert(self.Jornaru.AlertsRef.WaveWarning, 5)
	self.Jornaru.TimersRef.WaveOne:SetPhase(1)
	self.Jornaru.TimersRef.WaveFour:AddAlert(self.Jornaru.AlertsRef.WaveWarning, 5)
	self.Jornaru.Triggers.Orb = KBM.Trigger:Create(AK.Lang.Notify.Orb[KBM.Lang], "notify", self.Jornaru)
	self.Jornaru.Triggers.Orb:AddAlert(self.Jornaru.AlertsRef.Orb, true)
	self.Jornaru.Triggers.Orb:AddTimer(self.Jornaru.TimersRef.Orb)
	self.Jornaru.AlertsRef.Orb:Important()
	self.Jornaru.Triggers.PhaseTwo = KBM.Trigger:Create(AK.Lang.Say.PhaseTwo[KBM.Lang], "say", self.Jornaru)
	self.Jornaru.Triggers.PhaseTwo:AddTimer(self.Jornaru.TimersRef.OrbFirst)
	self.Jornaru.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Jornaru.Triggers.Summon = KBM.Trigger:Create(self.Lang.Mechanic.Summon[KBM.Lang], "cast", self.Jornaru)
	self.Jornaru.TimersRef.SummonTwo:SetPhase(2)
	self.Jornaru.Triggers.Summon:AddTimer(self.Jornaru.TimersRef.Summon)
	
	self.Akylios.Triggers.PhaseFour = KBM.Trigger:Create(55, "percent", self.Akylios)
	self.Akylios.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Akylios.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "buff", self.Akylios)
	self.Akylios.Triggers.Decay:AddAlert(self.Akylios.AlertsRef.Decay, true)
	self.Akylios.AlertsRef.Decay:Important()
	self.Akylios.Triggers.Breath = KBM.Trigger:Create(AK.Lang.Ability.Breath[KBM.Lang], "cast", self.Akylios)
	self.Akylios.Triggers.Breath:AddTimer(AK.Akylios.TimersRef.Breath)
	self.Akylios.Triggers.Breath:AddAlert(AK.Akylios.AlertsRef.BreathWarn)
	self.Akylios.AlertsRef.BreathWarn:AlertEnd(self.Akylios.AlertsRef.Breath)
	
	self.Jornaru.CastBar = KBM.CastBar:Add(self, self.Jornaru, true)
	self.Akylios.CastBar = KBM.CastBar:Add(self, self.Akylios, true)

	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end