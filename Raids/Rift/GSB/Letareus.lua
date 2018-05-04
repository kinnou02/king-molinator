-- Duke Letareus Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBDL_Settings = nil
chKBMGSBDL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GSB = KBM.BossMod["Greenscales Blight"]

local DL = {
	Enabled = true,
	Directory = GSB.Directory,
	File = "Letareus.lua",
	Instance = GSB.Name,
	InstanceObj = GSB,
	HasPhases = true,
	Lang = {},
	Enrage = (8 * 60),
	ID = "Letareus",
	HasChronicle = true,
	Object = "DL",
}

DL.Letareus = {
	Mod = DL,
	ChronicleID = "U0C72E33D4A11BCFE",
	UTID = "U03AED7765DDCDB5D",
	Level = 52,
	Active = false,
	Name = "Duke Letareus",
	NameShort = "Letareus",
	Menu = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	TimeOut = 3,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Wrath = KBM.Defaults.AlertObj.Create("red"),
			Tank = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(DL.ID, DL)

-- Main Unit Dictionary
DL.Lang.Unit = {}
DL.Lang.Unit.Letareus = KBM.Language:Add(DL.Letareus.Name)
DL.Lang.Unit.Letareus:SetGerman("Herzog Letareus")
DL.Lang.Unit.Letareus:SetFrench("Duc Letareus")
DL.Lang.Unit.Letareus:SetRussian("Герцог Летареус")
DL.Lang.Unit.Letareus:SetKorean("레타레우스 공작")
DL.Letareus.Name = DL.Lang.Unit.Letareus[KBM.Lang]

-- Ability Dictionary
DL.Lang.Ability = {}
DL.Lang.Ability.Wrath = KBM.Language:Add("Duke's Wrath")
DL.Lang.Ability.Wrath:SetGerman("Zorn des Herzogs")
DL.Lang.Ability.Wrath:SetFrench("Colère du Duc")
DL.Lang.Ability.Wrath:SetRussian("Ярость герцога")
DL.Lang.Ability.Wrath:SetKorean("공작의 진노")

-- Mechanic Dictionary
DL.Lang.Mechanic = {}
DL.Lang.Mechanic.TankPhase = KBM.Language:Add("Tank Phase")
DL.Lang.Mechanic.TankPhase:SetRussian("Фаза танкования")
DL.Lang.Mechanic.TankPhase:SetFrench("Phase Tank")
DL.Lang.Mechanic.TankPhase:SetGerman("Tank Phase")
DL.Lang.Mechanic.TankPhase:SetKorean("탱킹 단계")
DL.Lang.Mechanic.Tank = KBM.Language:Add("Tank")
DL.Lang.Mechanic.Tank:SetRussian("Танкуем")
DL.Lang.Mechanic.Tank:SetGerman()
DL.Lang.Mechanic.Tank:SetFrench()
DL.Lang.Mechanic.Tank:SetKorean("탱킹")
DL.Lang.Mechanic.Kite = KBM.Language:Add("Kite")
DL.Lang.Mechanic.Kite:SetRussian("Кайтим")
DL.Lang.Mechanic.Kite:SetFrench("Kiting")
DL.Lang.Mechanic.Kite:SetGerman("Kite")
DL.Lang.Mechanic.Kite:SetKorean("보스몰이")

DL.Descript = DL.Letareus.Name

function DL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Letareus.Name] = self.Letareus,
	}
end

function DL:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = true,
		Alerts = KBM.Defaults.Alerts(),
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = self.Letareus.Settings.CastBar,
		AlertsRef = self.Letareus.Settings.AlertsRef,
	}
	KBMGSBDL_Settings = self.Settings
	chKBMGSBDL_Settings = self.Settings	
end

function DL:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBDL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBDL_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMGSBDL_Settings = self.Settings
	else
		KBMGSBDL_Settings = self.Settings
	end	
end

function DL:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBDL_Settings = self.Settings
	else
		KBMGSBDL_Settings = self.Settings
	end	
end

function DL:Castbar(units)
end

function DL:RemoveUnits(UnitID)
	if self.Letareus.UnitID == UnitID then
		self.Letareus.Available = false
		return true
	end
	return false
end

function DL:Death(UnitID)
	if self.Letareus.UnitID == UnitID then
		self.Letareus.Dead = true
		return true
	end
	return false
end

function DL:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Phase = 1
				BossObj.Dead = false
				BossObj.CastBar:Create(unitID)
				BossObj.UnitID = unitID
				self.PhaseObj:SetPhase(DL.Lang.Mechanic.Tank[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Letareus, 86, 100)
				self.PhaseObj:Start(self.StartTime)
			else
				self.Letareus.UnitID = unitID
				self.Letareus.Available = true
			end
			return BossObj
		end
	end
end

function DL:PhaseTwo()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Kite[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 76, 86)	
end

function DL:PhaseThree()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Tank[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 61, 76)
end

function DL:PhaseFour()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Kite[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 51, 61)
end

function DL:PhaseFive()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Tank[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 36, 51)
end

function DL:PhaseSix()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Kite[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 26, 36)
end

function DL.PhaseSeven()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Tank[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 11, 26)
end

function DL.PhaseEight()
	DL.PhaseObj.Objectives:Remove()
	DL.PhaseObj:SetPhase(DL.Lang.Mechanic.Kite[KBM.Lang])
	DL.PhaseObj.Objectives:AddPercent(DL.Letareus, 0, 11)
end

function DL:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.Phase = 1
	self.PhaseObj:End()
end

function DL:Timer()
end

function DL:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Letareus, self.Enabled)
end

DL.Custom = {}
DL.Custom.Encounter = {}
function DL.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Chronicle(bool)
		DL.Settings.Chronicle = bool
	end

	Header = Menu:CreateHeader(KBM.Language.Encounter.Chronicle[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(DL.Settings.Chronicle)
	Header:SetHook(Callbacks.Chronicle)
	
end

function DL:Start()
	-- Create Timers
	
	-- Create AlertsRef
	self.Letareus.AlertsRef.Wrath = KBM.Alert:Create(self.Lang.Ability.Wrath[KBM.Lang], nil, true, true, "red")
	self.Letareus.AlertsRef.Tank = KBM.Alert:Create(self.Lang.Mechanic.TankPhase[KBM.Lang], 2, true, false, "orange")
	KBM.Defaults.AlertObj.Assign(self.Letareus)
	
	-- Assign Mechanics to Triggers
	self.Letareus.Triggers.Wrath = KBM.Trigger:Create(self.Lang.Ability.Wrath[KBM.Lang], "cast", self.Letareus)
	self.Letareus.Triggers.Wrath:AddAlert(self.Letareus.AlertsRef.Wrath)
	self.Letareus.Triggers.PhaseTwo = KBM.Trigger:Create(86, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Letareus.Triggers.PhaseThree = KBM.Trigger:Create(76, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Letareus.Triggers.PhaseThree:AddAlert(self.Letareus.AlertsRef.Tank)
	self.Letareus.Triggers.PhaseFour = KBM.Trigger:Create(61, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Letareus.Triggers.PhaseFive = KBM.Trigger:Create(51, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	self.Letareus.Triggers.PhaseFive:AddAlert(self.Letareus.AlertsRef.Tank)
	self.Letareus.Triggers.PhaseSix = KBM.Trigger:Create(36, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseSix:AddPhase(self.PhaseSix)
	self.Letareus.Triggers.PhaseSeven = KBM.Trigger:Create(26, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseSeven:AddPhase(self.PhaseSeven)
	self.Letareus.Triggers.PhaseSeven:AddAlert(self.Letareus.AlertsRef.Tank)
	self.Letareus.Triggers.PhaseEight = KBM.Trigger:Create(11, "percent", self.Letareus)
	self.Letareus.Triggers.PhaseEight:AddPhase(self.PhaseEight)
		
	-- Initialize Castbar and Phase Object.
	self.Letareus.CastBar = KBM.Castbar:Add(self, self.Letareus)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(DL.Lang.Mechanic.Tank[KBM.Lang])
	
end