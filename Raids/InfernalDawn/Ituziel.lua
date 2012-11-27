-- Ituziel Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDIZ_Settings = nil
chKBMINDIZ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local IZ = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Ituziel.lua",
	Instance = IND.Name,
	InstanceObj = IND,
	HasPhases = true,
	Lang = {},
	ID = "Ituziel",
	Object = "IZ",
	Enrage = (60 * 5) + 35,
}

IZ.Ituziel = {
	Mod = IZ,
	Level = "??",
	Active = false,
	Name = "Ituziel",
	NameShort = "Ituziel",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U2548A17D2D0E9F2F",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Word = KBM.Defaults.TimerObj.Create("red"),
			Brimstone = KBM.Defaults.TimerObj.Create("purple"),
			WaveFirst = KBM.Defaults.TimerObj.Create("orange"),
			Wave = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Word = KBM.Defaults.AlertObj.Create("red"),
			Brimstone = KBM.Defaults.AlertObj.Create("purple"),
			Wave = KBM.Defaults.AlertObj.Create("orange"),
		},
	}
}

KBM.RegisterMod(IZ.ID, IZ)

-- Main Unit Dictionary
IZ.Lang.Unit = {}
IZ.Lang.Unit.Ituziel = KBM.Language:Add(IZ.Ituziel.Name)
IZ.Lang.Unit.Ituziel:SetFrench()
IZ.Lang.Unit.Ituziel:SetGerman()
IZ.Lang.Unit.Ituziel:SetRussian("Итузиэль")
IZ.Lang.Unit.Ituziel:SetKorean("이투지엘")

-- Ability Dictionary
IZ.Lang.Ability = {}
IZ.Lang.Ability.Word = KBM.Language:Add("Word of Incineration")
IZ.Lang.Ability.Word:SetGerman("Wort der Verbrennung")
IZ.Lang.Ability.Word:SetFrench("Parole d'incinération")
IZ.Lang.Ability.Word:SetRussian("Слово испепеления")

-- Buff Dictionary
IZ.Lang.Buff = {}
IZ.Lang.Buff.Brimstone = KBM.Language:Add("Brimstone")
IZ.Lang.Buff.Brimstone:SetGerman("Schwefel")
IZ.Lang.Buff.Brimstone:SetFrench("Soufre")
IZ.Lang.Buff.Brimstone:SetRussian("Серный камень")
IZ.Lang.Buff.Brimstone:SetKorean("유황석")

-- Mechanic Dictionary
IZ.Lang.Mechanic = {}
IZ.Lang.Mechanic.Wave = KBM.Language:Add("Flame Waves")
IZ.Lang.Mechanic.Wave:SetFrench("Vagues de flammes")
IZ.Lang.Mechanic.Wave:SetRussian("Огненная волна")
IZ.Lang.Mechanic.Wave:SetGerman("Flammenwelle")
IZ.Lang.Mechanic.Wave:SetKorean("불꽃 파도들")

-- Menu Dictionary
IZ.Lang.Menu = {}
IZ.Lang.Menu.Wave = KBM.Language:Add("First Flame Wave")
IZ.Lang.Menu.Wave:SetFrench("Première Vague de flammes")
IZ.Lang.Menu.Wave:SetRussian("Первая Огненная волна")
IZ.Lang.Menu.Wave:SetGerman("Erste Flammenwelle")
IZ.Lang.Menu.Wave:SetKorean("첫번재 불꽃 파도")

-- Debuff Dictionary
IZ.Lang.Debuff = {}
IZ.Lang.Debuff.Curse = KBM.Language:Add("Incinerating Curse")
IZ.Lang.Debuff.Curse:SetGerman("Einäschernder Fluch")
IZ.Lang.Debuff.Curse:SetFrench("Malédiction d'incinération")
IZ.Lang.Debuff.Curse:SetRussian("Испепеляющее проклятье")
IZ.Lang.Debuff.Curse:SetKorean("소각 저주")
IZ.Lang.Debuff.Wave = KBM.Language:Add("Flame Wave")
IZ.Lang.Debuff.Wave:SetFrench("Vague de flamme")
IZ.Lang.Debuff.Wave:SetGerman("Flammenwellen")

-- Assign Translated Versions
IZ.Ituziel.Name = IZ.Lang.Unit.Ituziel[KBM.Lang]
IZ.Ituziel.NameShort = IZ.Lang.Unit.Ituziel[KBM.Lang]
IZ.Descript = IZ.Ituziel.Name

function IZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ituziel.Name] = self.Ituziel,
	}
end

function IZ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ituziel.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Ituziel.Settings.TimersRef,
		AlertsRef = self.Ituziel.Settings.AlertsRef,
	}
	KBMINDIZ_Settings = self.Settings
	chKBMINDIZ_Settings = self.Settings
	
end

function IZ:SwapSettings(bool)

	if bool then
		KBMINDIZ_Settings = self.Settings
		self.Settings = chKBMINDIZ_Settings
	else
		chKBMINDIZ_Settings = self.Settings
		self.Settings = KBMINDIZ_Settings
	end

end

function IZ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDIZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDIZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDIZ_Settings = self.Settings
	else
		KBMINDIZ_Settings = self.Settings
	end	
end

function IZ:SaveVars()	
	if KBM.Options.Character then
		chKBMINDIZ_Settings = self.Settings
	else
		KBMINDIZ_Settings = self.Settings
	end	
end

function IZ:Castbar(units)
end

function IZ:RemoveUnits(UnitID)
	if self.Ituziel.UnitID == UnitID then
		self.Ituziel.Available = false
		return true
	end
	return false
end

function IZ.PhaseTwo()
	if IZ.Phase == 1 then
		IZ.PhaseObj.Objectives:Remove()
		IZ.PhaseObj.Objectives:AddPercent(IZ.Ituziel.Name, 0, 33)
		IZ.Phase = 2
		IZ.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	end
end

function IZ:Death(UnitID)
	if self.Ituziel.UnitID == UnitID then
		self.Ituziel.Dead = true
		return true
	end
	return false
end

function IZ:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ituziel.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ituziel.Dead = false
					self.Ituziel.Casting = false
					self.Ituziel.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Ituziel.Name, 33, 100)
					self.CurrentBrimstone = 12
					KBM.MechTimer:AddStart(self.Ituziel.TimersRef.WaveFirst)
					local DebuffTable = {
							[1] = self.Lang.Debuff.Curse[KBM.Lang],
							[2] = self.Lang.Debuff.Wave[KBM.Lang],
					}
					KBM.TankSwap:Start(DebuffTable, unitID, 2)					
					self.Phase = 1
				end
				self.Ituziel.UnitID = unitID
				self.Ituziel.Available = true
				return self.Ituziel
			end
		end
	end
end

function IZ:Reset()
	self.EncounterRunning = false
	self.Ituziel.Available = false
	self.Ituziel.UnitID = nil
	self.Ituziel.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function IZ.BrimstoneChange()
	if IZ.CurrentBrimstone == 14 then
		IZ.CurrentBrimstone = 12
		KBM.MechTimer:AddStart(IZ.Ituziel.TimersRef.Brimstone, 12)
	else
		IZ.CurrentBrimstone = 14
		KBM.MechTimer:AddStart(IZ.Ituziel.TimersRef.Brimstone, 14)
	end
end

function IZ:Timer()	
end

function IZ:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Ituziel, self.Enabled)
end

function IZ:Start()
	-- Create Timers
	self.Ituziel.TimersRef.Word = KBM.MechTimer:Add(self.Lang.Ability.Word[KBM.Lang], 26)
	self.Ituziel.TimersRef.Wave = KBM.MechTimer:Add(self.Lang.Mechanic.Wave[KBM.Lang], 36, true)
	self.Ituziel.TimersRef.WaveFirst = KBM.MechTimer:Add(self.Lang.Mechanic.Wave[KBM.Lang], 22)
	self.Ituziel.TimersRef.WaveFirst.MenuName = self.Lang.Menu.Wave[KBM.Lang]
	self.Ituziel.TimersRef.WaveFirst:AddTimer(self.Ituziel.TimersRef.Wave, 0)
	self.Ituziel.TimersRef.Brimstone = KBM.MechTimer:Add(self.Lang.Buff.Brimstone[KBM.Lang], nil)
	KBM.Defaults.TimerObj.Assign(self.Ituziel)
	
	-- Create Alerts
	self.Ituziel.AlertsRef.Word = KBM.Alert:Create(self.Lang.Ability.Word[KBM.Lang], nil, false, true, "red")
	self.Ituziel.AlertsRef.Brimstone = KBM.Alert:Create(self.Lang.Buff.Brimstone[KBM.Lang], nil, false, true, "purple")
	self.Ituziel.AlertsRef.Wave = KBM.Alert:Create(self.Lang.Mechanic.Wave[KBM.Lang], 5, false, true, "orange")
	self.Ituziel.TimersRef.WaveFirst:AddAlert(self.Ituziel.AlertsRef.Wave, 5)
	self.Ituziel.TimersRef.Wave:AddAlert(self.Ituziel.AlertsRef.Wave, 5)
	KBM.Defaults.AlertObj.Assign(self.Ituziel)
	
	-- Assign Alerts and Timers to Triggers
	self.Ituziel.Triggers.PhaseTwo = KBM.Trigger:Create(33, "percent", self.Ituziel)
	self.Ituziel.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Ituziel.Triggers.Word = KBM.Trigger:Create(self.Lang.Ability.Word[KBM.Lang], "cast", self.Ituziel)
	self.Ituziel.Triggers.Word:AddAlert(self.Ituziel.AlertsRef.Word)
	self.Ituziel.Triggers.Word:AddTimer(self.Ituziel.TimersRef.Word)
	self.Ituziel.Triggers.Brimstone = KBM.Trigger:Create(self.Lang.Buff.Brimstone[KBM.Lang], "buff", self.Ituziel)
	self.Ituziel.Triggers.Brimstone:AddAlert(self.Ituziel.AlertsRef.Brimstone)
	self.Ituziel.Triggers.Brimstone:AddPhase(self.BrimstoneChange)
	self.Ituziel.Triggers.BrimRemove = KBM.Trigger:Create(self.Lang.Buff.Brimstone[KBM.Lang], "buffRemove", self.Ituziel)
	self.Ituziel.Triggers.BrimRemove:AddStop(self.Ituziel.AlertsRef.Brimstone)
	
	self.Ituziel.CastBar = KBM.CastBar:Add(self, self.Ituziel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end