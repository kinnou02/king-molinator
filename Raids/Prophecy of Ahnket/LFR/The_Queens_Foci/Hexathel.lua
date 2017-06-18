-- Hexathel Boss Mod for King Boss Mods
-- Written by Rikard Blixt
-- Copyright 2017
--

KBMSPEQFHE_Settings = nil
chKBMSPEQFHE_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local QF = KBM.BossMod["The_Queens_Foci"]

local HX = {
	Enabled = true,
	Directory = QF.Directory,
	File = "Hexathel.lua",
	Instance = QF.Name,
	InstanceObj = QF,
	HasPhases = false,
	Lang = {},
	ID = "Hexathel",
	Object = "HX",
--	Enrage = (60 * 5) + 35,
}

HX.Hexathel = {
	Mod = HX,
	Level = "??",
  Menu = {},
	Active = false,
	Name = "Hexathel",
  Castbar = nil,
	CastFilters = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UTID = "U39EBAB5973E792B8",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			GridStart = KBM.Defaults.TimerObj.Create("orange"),
			Grid = KBM.Defaults.TimerObj.Create("orange"),
			Corner = KBM.Defaults.TimerObj.Create("dark_green"),
			Corner2 = KBM.Defaults.TimerObj.Create("dark_green"),
			Silken = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Webtoss = KBM.Defaults.AlertObj.Create("yellow"),
			Silken = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

KBM.RegisterMod(HX.ID, HX)

-- Main Unit Dictionary
HX.Lang.Unit = {}
HX.Lang.Unit.Hexathel = KBM.Language:Add(HX.Hexathel.Name)
--HX.Lang.Unit.Hexathel:SetGerman("Hexathel")
--HX.Lang.Unit.Hexathel:SetFrench("Hexathel")
--HX.Lang.Unit.Hexathel:SetRussian("Беругаст")
--HX.Lang.Unit.Hexathel:SetKorean("베루하스트")
HX.Hexathel.Name = HX.Lang.Unit.Hexathel[KBM.Lang]
HX.Descript = HX.Hexathel.Name
-- Additional Unit Dictionary
HX.Lang.Unit.Grid = KBM.Language:Add("Grid Phase")
--HX.Lang.Unit.Grid:SetFrench("Flamme bondissante")
--HX.Lang.Unit.Grid:SetGerman("Springende Flamme")
--HX.Lang.Unit.Grid:SetRussian("Мечущееся пламя")
--HX.Lang.Unit.Grid:SetKorean("도약하는 불꽃")
HX.Lang.Unit.Corner = KBM.Language:Add("Run to Corner")
--HX.Lang.Unit.Grid:SetFrench("Flamme bondissante")
--HX.Lang.Unit.Grid:SetGerman("Springende Flamme")
--HX.Lang.Unit.Grid:SetRussian("Мечущееся пламя")
--HX.Lang.Unit.Grid:SetKorean("도약하는 불꽃")
-- Ability Dictionary
HX.Lang.Ability = {}
HX.Lang.Ability.Webtoss = KBM.Language:Add("Webtoss")
--HX.Lang.Ability.Webtoss:SetFrench("Fouet des limbes")
--HX.Lang.Ability.Webtoss:SetGerman("Infernopeitsche")
--HX.Lang.Ability.Webtoss:SetRussian("Адская плеть")
--HX.Lang.Ability.Webtoss:SetKorean("화염지옥 후려치기")
HX.Lang.Ability.Silken = KBM.Language:Add("Silken Friends")
--HX.Lang.Ability.Silken:SetGerman("Beschworene Flamme")
--HX.Lang.Ability.Silken:SetRussian("Призванный огонь")
--HX.Lang.Ability.Silken:SetFrench("Flamme invoquée")
--HX.Lang.Ability.Silken:SetKorean("소환된 불꽃")
-- Notify Dictionary
HX.Lang.Notify = {}
HX.Lang.Notify.Grid = KBM.Language:Add('You cannot hope to survive Ascended. I pull the strings. Soon you will be my new puppets.')
--HX.Lang.Notify.Grid:SetGerman('Hexathel sagt: "Ein Begleiter von Flammenmaul sollte Euch warmhalten."')
--HX.Lang.Notify.Grid:SetRussian('Беругаст говорит: "питомец Маэлфорджа вас согреет."')
--HX.Lang.Notify.Grid:SetFrench('Hexathel dit : "Un familier de Maelforge devrait vous tenir au chaud."')
--HX.Lang.Notify.Grid:SetKorean('마엘포지의 소환수가 널 따뜻하게 데워줄 것이다."라고 말합니다."')

-- Menu Dictionary
HX.Lang.Menu = {}
HX.Lang.Menu.Grid = KBM.Language:Add("First "..HX.Lang.Unit.Grid[KBM.Lang])
--HX.Lang.Menu.Grid:SetGerman("Erste "..HX.Lang.Unit.Grid[KBM.Lang])
--HX.Lang.Menu.Grid:SetRussian("Первый "..HX.Lang.Unit.Grid[KBM.Lang])
--HX.Lang.Menu.Grid:SetFrench("Première "..HX.Lang.Unit.Grid[KBM.Lang])
--HX.Lang.Menu.Grid:SetKorean("첫번째 불길 전이")
-- Verbose Dictionary
HX.Lang.Verbose = {}
HX.Lang.Verbose.Until = KBM.Language:Add(" (Until first)")
--HX.Lang.Verbose.Until:SetRussian(" (первое)")
--HX.Lang.Verbose.Until:SetFrench(" (jusqu'à la première)")
--HX.Lang.Verbose.Until:SetGerman(" (bis zum ersten)")
--HX.Lang.Verbose.Until:SetKorean(" (첫번째 까지)")

function HX:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Hexathel.Name] = self.Hexathel,
	}
end

function HX:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Hexathel.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Hexathel.Settings.AlertsRef,
		TimersRef = self.Hexathel.Settings.TimersRef,
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMSPEQFHE_Settings = self.Settings
	chKBMSPEQFHE_Settings = self.Settings
end

function HX:SwapSettings(bool)
	if bool then
		KBMSPEQFHE_Settings = self.Settings
		self.Settings = chKBMSPEQFHE_Settings
	else
		chKBMSPEQFHE_Settings = self.Settings
		self.Settings = KBMSPEQFHE_Settings
	end
end

function HX:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSPEQFHE_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSPEQFHE_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSPEQFHE_Settings = self.Settings
	else
		KBMSPEQFHE_Settings = self.Settings
	end
end

function HX:SaveVars()
	if KBM.Options.Character then
		chKBMSPEQFHE_Settings = self.Settings
	else
		KBMSPEQFHE_Settings = self.Settings
	end
end

function HX:Castbar(units)
end

function HX:RemoveUnits(UnitID)
	if self.Hexathel.UnitID == UnitID then
		self.Hexathel.Available = false
		return true
	end
	return false
end

function HX:Death(UnitID)
	if self.Hexathel.UnitID == UnitID then
		self.Hexathel.Dead = true
		return true
	end
	return false
end

function HX:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Hexathel.Name then
				if not self.Hexathel.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hexathel.Casting = false
					self.Hexathel.CastBar:Create(unitID)
					self.Hexathel.TimersRef.GridStart:Start(Inspect.Time.Real())
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Hexathel.Name, 0, 100)
					self.Phase = 1
				end
				self.Hexathel.UnitID = unitID
				self.Hexathel.Available = true
				return self.Hexathel
			end
		end
	end
end

function HX:Reset()
	self.EncounterRunning = false
	self.Hexathel.Available = false
	self.Hexathel.UnitID = nil
	self.Hexathel.CastBar:Remove()
	self.Hexathel.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function HX:Timer()
end

function HX:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Hexathel, self.Enabled)
end

function HX:Start()
	-- Alerts
	self.Hexathel.AlertsRef.Webtoss = KBM.Alert:Create(self.Lang.Ability.Webtoss[KBM.Lang], 1, true, true, "yellow")
	self.Hexathel.AlertsRef.Silken = KBM.Alert:Create(self.Lang.Ability.Silken[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Hexathel)
	
	-- Timers
	self.Hexathel.TimersRef.Grid = KBM.MechTimer:Add(self.Lang.Unit.Grid[KBM.Lang], 109)
	self.Hexathel.TimersRef.Corner = KBM.MechTimer:Add(self.Lang.Unit.Corner[KBM.Lang], 22)
	self.Hexathel.TimersRef.Corner2 = KBM.MechTimer:Add(self.Lang.Unit.Corner[KBM.Lang], 44)
	self.Hexathel.TimersRef.GridStart = KBM.MechTimer:Add(self.Lang.Unit.Grid[KBM.Lang], 30)
	self.Hexathel.TimersRef.GridStart.MenuName = self.Lang.Unit.Grid[KBM.Lang]..self.Lang.Verbose.Until[KBM.Lang]
	self.Hexathel.TimersRef.Silken = KBM.MechTimer:Add(self.Lang.Ability.Silken[KBM.Lang], 20)
	KBM.Defaults.TimerObj.Assign(self.Hexathel)
	
	-- Assign Mechanics to Triggers
	self.Hexathel.Triggers.Webtoss = KBM.Trigger:Create(self.Lang.Ability.Webtoss[KBM.Lang], "cast", self.Hexathel)
	self.Hexathel.Triggers.Webtoss:AddAlert(self.Hexathel.AlertsRef.Webtoss)
	self.Hexathel.Triggers.WebtossInt = KBM.Trigger:Create(self.Lang.Ability.Webtoss[KBM.Lang], "interrupt", self.Hexathel)
	self.Hexathel.Triggers.WebtossInt:AddStop(self.Hexathel.AlertsRef.Webtoss)
	self.Hexathel.Triggers.Grid = KBM.Trigger:Create(self.Lang.Notify.Grid[KBM.Lang], "notify", self.Hexathel)
	self.Hexathel.Triggers.Grid:AddTimer(self.Hexathel.TimersRef.Corner)
	self.Hexathel.Triggers.Grid:AddTimer(self.Hexathel.TimersRef.Corner2)
  self.Hexathel.Triggers.Grid:AddTimer(self.Hexathel.TimersRef.Grid)
	self.Hexathel.Triggers.Silken = KBM.Trigger:Create(self.Lang.Ability.Silken[KBM.Lang], "cast", self.Hexathel)
	self.Hexathel.Triggers.Silken:AddTimer(self.Hexathel.TimersRef.Silken)
	self.Hexathel.Triggers.Silken:AddAlert(self.Hexathel.AlertsRef.Silken)
	
	self.Hexathel.CastBar = KBM.Castbar:Add(self, self.Hexathel, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end