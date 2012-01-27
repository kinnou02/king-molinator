-- Sicaron Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSN_Settings = nil
chKBMSN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local SN = {
	Enabled = true,
	Instance = HK.Name,
	Lang = {},
	Enrage = 60 * 12,
	PhaseObj = nil,
	Phase = 1,
	ID = "Sicaron",
}

SN.Sicaron = {
	Mod = SN,
	Level = "??",
	Active = false,
	Name = "Sicaron",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		Filters = {
			Enabled = true,
			Hex = KBM.Defaults.CastFilter.Create("purple"),
			Contract = KBM.Defaults.CastFilter.Create("blue"),
			Decay = KBM.Defaults.CastFilter.Create("dark_green"),
		},
		TimersRef = {
			Enabled = true,
			Contract = KBM.Defaults.TimerObj.Create("blue"),
			Hex = KBM.Defaults.TimerObj.Create("purple"),
			Decay = KBM.Defaults.TimerObj.Create("dark_green"),
			Soul = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Contract = KBM.Defaults.AlertObj.Create("blue"),
			ContractRed = KBM.Defaults.AlertObj.Create("red"),
			Hex = KBM.Defaults.AlertObj.Create("purple"),
			Decay = KBM.Defaults.AlertObj.Create("dark_green"),
		},
	},
}

KBM.RegisterMod(SN.ID, SN)

-- Define Name
SN.Lang.Sicaron = KBM.Language:Add(SN.Sicaron.Name)
SN.Lang.Sicaron.Russian = "Сикарон"
SN.Sicaron.Name = SN.Lang.Sicaron[KBM.Lang]
SN.Descript = SN.Sicaron.Name

-- Ability Dictionary
SN.Lang.Ability = {}
SN.Lang.Ability.Hex = KBM.Language:Add("Excruciating Hex")
SN.Lang.Ability.Hex.German = "Quälende Verhexung"
SN.Lang.Ability.Hex.Russian = "Смертоностное проклятие"
SN.Lang.Ability.Decay = KBM.Language:Add("Moldering Decay")
SN.Lang.Ability.Decay.German = "Zerfallende Verwesung"
SN.Lang.Ability.Decay.Russian = "Тлеющее увядание" 

-- Notify Dictionary
SN.Lang.Notify = {}
SN.Lang.Notify.Contract = KBM.Language:Add("Sicaron forces (%a*) into an unholy contract")
SN.Lang.Notify.Contract.German = "Sicaron zwingt (%a*) in einen unheiligen Pakt"
SN.Lang.Notify.Contract.Russian = "Сикарон заключает дьявольский контракт. Партнер - (%a*)."

-- Debuff Dictionary
SN.Lang.Debuff = {}
SN.Lang.Debuff.Contract = KBM.Language:Add("Unholy Contract")
SN.Lang.Debuff.Contract.German = "Unheiliger Vertrag"
SN.Lang.Debuff.Contract.French = "Contrat impie"
SN.Lang.Debuff.Contract.Russian = "Нечестивый договор"
SN.Lang.Debuff.Soul = KBM.Language:Add("Soul Harvest")
SN.Lang.Debuff.Soul.German = "Seelenernte"
SN.Lang.Debuff.Soul.Russian = "Сбор души"

function SN:AddBosses(KBM_Boss)
	self.MenuName = self.Sicaron.Descript
	self.Bosses = {
		[self.Sicaron.Name] = self.Sicaron,
	}
	KBM_Boss[self.Sicaron.Name] = self.Sicaron	
end

function SN:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastFilters = self.Sicaron.Settings.Filters,
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Sicaron.Settings.CastBar,
		TimersRef = self.Sicaron.Settings.TimersRef,
		AlertsRef = self.Sicaron.Settings.AlertsRef,
	}
	KBMSN_Settings = self.Settings
	chKBMSN_Settings = self.Settings	
end

function SN:SwapSettings(bool)

	if bool then
		KBMSN_Settings = self.Settings
		self.Settings = chKBMSN_Settings
	else
		chKBMSN_Settings = self.Settings
		self.Settings = KBMSN_Settings
	end

end

function SN:LoadVars()	
	local TargetLoad = nil	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSN_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMSN_Settings = self.Settings
	else
		KBMSN_Settings = self.Settings
	end
	self.Sicaron.CastFilters[self.Lang.Ability.Hex[KBM.Lang]] = {ID = "Hex"}
	self.Sicaron.CastFilters[self.Lang.Debuff.Contract[KBM.Lang]] = {ID = "Contract"}
	self.Sicaron.CastFilters[self.Lang.Ability.Decay[KBM.Lang]] = {ID = "Decay"}
	KBM.Defaults.CastFilter.Assign(self.Sicaron)	
	
	self.Sicaron.Settings.AlertsRef.ContractRed.Enabled = true
end

function SN:SaveVars()
	if KBM.Options.Settings then
		chKBMSN_Settings = self.Settings
	else
		KBMSN_Settings = self.Settings
	end	
end

function SN:Castbar(units)
end

function SN:RemoveUnits(UnitID)
	if self.Sicaron.UnitID == UnitID then
		self.Sicaron.Available = false
		return true
	end
	return false
end

function SN:Death(UnitID)
	if self.Sicaron.UnitID == UnitID then
		self.Sicaron.Dead = true
		return true
	end
	return false
end

function SN:UnitHPCheck(unitDetails, unitID)
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Sicaron.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Sicaron.Dead = false
					self.Sicaron.CastBar:Create(unitID)
					self.PhaseObj.Objectives:AddPercent(self.Sicaron.Name, 80, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Sicaron.Casting = false
				self.Sicaron.UnitID = unitID
				self.Sicaron.Available = true
				return self.Sicaron
			end
		end
	end
end

function SN.PhaseTwo()
	SN.Phase = 2
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 50, 80)
	SN.PhaseObj:SetPhase(SN.Phase)
	print("Phase 2 Starting, 20s purges.")
end

function SN.PhaseThree()
	SN.Phase = 3
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 25, 50)
	SN.PhaseObj:SetPhase(SN.Phase)
	print("Phase 3 Starting, 16s purges.")
end

function SN.PhaseFour()
	SN.Phase = 4
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 10, 25)
	SN.PhaseObj:SetPhase(SN.Phase)
	print("Phase 4 Starting, 12s purges.")
end

function SN.PhaseFive()
	SN.Phase = 5
	SN.PhaseObj.Objectives:Remove()
	SN.PhaseObj.Objectives:AddPercent(SN.Sicaron.Name, 0, 10)
	SN.PhaseObj:SetPhase("Final")
	print("Final Phase! 8s purges.")
end

function SN:Reset()
	self.EncounterRunning = false
	self.Sicaron.Available = false
	self.Sicaron.UnitID = nil
	self.Sicaron.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)
	self.Phase = 1	
end

function SN:Timer()
	
end

function SN.Sicaron:SetTimers(bool)	
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

function SN.Sicaron:SetAlerts(bool)
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

function SN:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Sicaron, self.Enabled)
end

function SN:Start()		
	-- Create Timers
	self.Sicaron.TimersRef.Contract = KBM.MechTimer:Add(self.Lang.Debuff.Contract[KBM.Lang], 17)
	self.Sicaron.TimersRef.Hex = KBM.MechTimer:Add(self.Lang.Ability.Hex[KBM.Lang], 26)
	self.Sicaron.TimersRef.Decay = KBM.MechTimer:Add(self.Lang.Ability.Decay[KBM.Lang], 20.5)
	self.Sicaron.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Debuff.Soul[KBM.Lang], nil)
	KBM.Defaults.TimerObj.Assign(self.Sicaron)
	
	-- Create Alerts
	self.Sicaron.AlertsRef.Contract = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 12, false, true, "blue")
	self.Sicaron.AlertsRef.ContractRed = KBM.Alert:Create(self.Lang.Debuff.Contract[KBM.Lang], 5, true, true, "red")
	self.Sicaron.AlertsRef.ContractRed:NoMenu()
	self.Sicaron.AlertsRef.Hex = KBM.Alert:Create(self.Lang.Ability.Hex[KBM.Lang], nil, true, true, "purple")
	self.Sicaron.AlertsRef.Decay = KBM.Alert:Create(self.Lang.Ability.Decay[KBM.Lang], nil, true, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Sicaron)
	
	-- Assign Mechanics to Triggers
	self.Sicaron.Triggers.Contract = KBM.Trigger:Create(self.Lang.Notify.Contract[KBM.Lang], "notify", self.Sicaron)
	self.Sicaron.Triggers.Contract:AddTimer(self.Sicaron.TimersRef.Contract)
	self.Sicaron.Triggers.Contract:AddAlert(self.Sicaron.AlertsRef.Contract, true)
	self.Sicaron.AlertsRef.Contract:Important()
	self.Sicaron.AlertsRef.Contract:AlertEnd(self.Sicaron.AlertsRef.ContractRed)
	self.Sicaron.Triggers.Hex = KBM.Trigger:Create(self.Lang.Ability.Hex[KBM.Lang], "cast", self.Sicaron)
	self.Sicaron.Triggers.Hex:AddAlert(self.Sicaron.AlertsRef.Hex)
	self.Sicaron.Triggers.Hex:AddTimer(self.Sicaron.TimersRef.Hex)
	self.Sicaron.Triggers.DecayWarn = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "cast", self.Sicaron)
	self.Sicaron.Triggers.DecayWarn:AddAlert(self.Sicaron.AlertsRef.Decay)
	self.Sicaron.Triggers.DecayWarn:AddTimer(self.Sicaron.TimersRef.Decay)
	self.Sicaron.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Sicaron.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Sicaron.Triggers.PhaseFour = KBM.Trigger:Create(25, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Sicaron.Triggers.PhaseFive = KBM.Trigger:Create(10, "percent", self.Sicaron)
	self.Sicaron.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	self.Sicaron.Triggers.Soul = KBM.Trigger:Create(self.Lang.Debuff.Soul[KBM.Lang], "buff", self.Sicaron)
	self.Sicaron.Triggers.Soul:AddTimer(self.Sicaron.TimersRef.Soul)
	
	-- Assign Castbar object.
	self.Sicaron.CastBar = KBM.CastBar:Add(self, self.Sicaron)
	
	-- Assign Phase Monitor.
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()	
end