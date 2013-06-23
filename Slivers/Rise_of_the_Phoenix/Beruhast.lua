-- Beruhast Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPBT_Settings = nil
chKBMROTPBT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local BT = {
	Directory = ROTP.Directory,
	File = "Beruhast.lua",
	Enabled = true,
	Instance = ROTP.Name,
	InstanceObj = ROTP,
	HasPhases = false,
	Lang = {},
	ID = "Beruhast",
	Menu = {},
	Enrage = 60 * 8,
	Object = "BT",
}

BT.Beruhast = {
	Mod = BT,
	Level = "??",
	Menu = {},
	Active = false,
	Name = "Beruhast",
	Castbar = nil,
	CastFilters = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UTID = "U3AD7B7055620AC0E",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			FlameStart = KBM.Defaults.TimerObj.Create("orange"),
			Flame = KBM.Defaults.TimerObj.Create("orange"),
			Summon = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Inferno = KBM.Defaults.AlertObj.Create("yellow"),
			Summon = KBM.Defaults.AlertObj.Create("dark_green"),
		},
	},
}

KBM.RegisterMod(BT.ID, BT)

-- Main Unit Dictionary
BT.Lang.Unit = {}
BT.Lang.Unit.Beruhast = KBM.Language:Add(BT.Beruhast.Name)
BT.Lang.Unit.Beruhast:SetGerman("Beruhast")
BT.Lang.Unit.Beruhast:SetFrench("Beruhast")
BT.Lang.Unit.Beruhast:SetRussian("Беругаст")
BT.Lang.Unit.Beruhast:SetKorean("베루하스트")
BT.Beruhast.Name = BT.Lang.Unit.Beruhast[KBM.Lang]
BT.Descript = BT.Beruhast.Name
-- Additional Unit Dictionary
BT.Lang.Unit.Summon = KBM.Language:Add("Summoned Flame")
BT.Lang.Unit.Summon:SetGerman("Beschworene Flamme")
BT.Lang.Unit.Summon:SetRussian("Призванный огонь")
BT.Lang.Unit.Summon:SetFrench("Flamme invoquée")
BT.Lang.Unit.Summon:SetKorean("소환된 불꽃")
-- Ability Dictionary
BT.Lang.Ability = {}
BT.Lang.Ability.Inferno = KBM.Language:Add("Inferno Lash")
BT.Lang.Ability.Inferno:SetFrench("Fouet des limbes")
BT.Lang.Ability.Inferno:SetGerman("Infernopeitsche")
BT.Lang.Ability.Inferno:SetRussian("Адская плеть")
BT.Lang.Ability.Inferno:SetKorean("화염지옥 후려치기")
BT.Lang.Ability.Flame = KBM.Language:Add("Leaping Flame")
BT.Lang.Ability.Flame:SetFrench("Flamme bondissante")
BT.Lang.Ability.Flame:SetGerman("Springende Flamme")
BT.Lang.Ability.Flame:SetRussian("Мечущееся пламя")
BT.Lang.Ability.Flame:SetKorean("도약하는 불꽃")
BT.Lang.Ability.Vortex = KBM.Language:Add("Flaming Vortex")
BT.Lang.Ability.Vortex:SetFrench("Embrasement")
BT.Lang.Ability.Vortex:SetGerman("Flammenwirbel")
BT.Lang.Ability.Vortex:SetRussian("Огненный вихрь")
BT.Lang.Ability.Vortex:SetKorean("불꽃 소용돌이")
-- Notify Dictionary
BT.Lang.Notify = {}
BT.Lang.Notify.Summon = KBM.Language:Add('Beruhast says, "A pet from Maelforge should keep you warm."')
BT.Lang.Notify.Summon:SetGerman('Beruhast sagt: "Ein Begleiter von Flammenmaul sollte Euch warmhalten."')
BT.Lang.Notify.Summon:SetRussian('Беругаст говорит: "питомец Маэлфорджа вас согреет."')
BT.Lang.Notify.Summon:SetFrench('Beruhast dit : "Un familier de Maelforge devrait vous tenir au chaud."')
BT.Lang.Notify.Summon:SetKorean('마엘포지의 소환수가 널 따뜻하게 데워줄 것이다."라고 말합니다."')

-- Menu Dictionary
BT.Lang.Menu = {}
BT.Lang.Menu.Flame = KBM.Language:Add("First "..BT.Lang.Ability.Flame[KBM.Lang])
BT.Lang.Menu.Flame:SetGerman("Erste "..BT.Lang.Ability.Flame[KBM.Lang])
BT.Lang.Menu.Flame:SetRussian("Первый "..BT.Lang.Ability.Flame[KBM.Lang])
BT.Lang.Menu.Flame:SetFrench("Première "..BT.Lang.Ability.Flame[KBM.Lang])
BT.Lang.Menu.Flame:SetKorean("첫번째 불길 전이")
-- Verbose Dictionary
BT.Lang.Verbose = {}
BT.Lang.Verbose.Until = KBM.Language:Add(" (Until first)")
BT.Lang.Verbose.Until:SetRussian(" (первое)")
BT.Lang.Verbose.Until:SetFrench(" (jusqu'à la première)")
BT.Lang.Verbose.Until:SetGerman(" (bis zum ersten)")
BT.Lang.Verbose.Until:SetKorean(" (첫번째 까지)")
function BT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Beruhast.Name] = self.Beruhast,
	}
end

function BT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Beruhast.Settings.CastBar,
		MechTimer = KBM.Defaults.MechTimer(),
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Beruhast.Settings.AlertsRef,
		TimersRef = self.Beruhast.Settings.TimersRef,
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMROTPBT_Settings = self.Settings
	chKBMROTPBT_Settings = self.Settings
end

function BT:SwapSettings(bool)
	if bool then
		KBMROTPBT_Settings = self.Settings
		self.Settings = chKBMROTPBT_Settings
	else
		chKBMROTPBT_Settings = self.Settings
		self.Settings = KBMROTPBT_Settings
	end
end

function BT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPBT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPBT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMROTPBT_Settings = self.Settings
	else
		KBMROTPBT_Settings = self.Settings
	end
end

function BT:SaveVars()
	if KBM.Options.Character then
		chKBMROTPBT_Settings = self.Settings
	else
		KBMROTPBT_Settings = self.Settings
	end
end

function BT:Castbar(units)
end

function BT:RemoveUnits(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Available = false
		return true
	end
	return false
end

function BT:Death(UnitID)
	if self.Beruhast.UnitID == UnitID then
		self.Beruhast.Dead = true
		return true
	end
	return false
end

function BT:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Beruhast.Name then
				if not self.Beruhast.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Beruhast.Casting = false
					self.Beruhast.CastBar:Create(unitID)
					self.Beruhast.TimersRef.FlameStart:Start(Inspect.Time.Real())
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Beruhast.Name, 0, 100)
					self.Phase = 1
				end
				self.Beruhast.UnitID = unitID
				self.Beruhast.Available = true
				return self.Beruhast
			end
		end
	end
end

function BT:Reset()
	self.EncounterRunning = false
	self.Beruhast.Available = false
	self.Beruhast.UnitID = nil
	self.Beruhast.CastBar:Remove()
	self.Beruhast.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function BT:Timer()
end

function BT:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Beruhast, self.Enabled)
end

function BT:Start()
	-- Alerts
	self.Beruhast.AlertsRef.Inferno = KBM.Alert:Create(self.Lang.Ability.Inferno[KBM.Lang], 2, true, true, "yellow")
	self.Beruhast.AlertsRef.Summon = KBM.Alert:Create(self.Lang.Unit.Summon[KBM.Lang], nil, true, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Beruhast)
	
	-- Timers
	self.Beruhast.TimersRef.Flame = KBM.MechTimer:Add(self.Lang.Ability.Flame[KBM.Lang], 70)
	self.Beruhast.TimersRef.FlameStart = KBM.MechTimer:Add(self.Lang.Ability.Flame[KBM.Lang], 30)
	self.Beruhast.TimersRef.FlameStart.MenuName = self.Lang.Ability.Flame[KBM.Lang]..self.Lang.Verbose.Until[KBM.Lang]
	self.Beruhast.TimersRef.Summon = KBM.MechTimer:Add(self.Lang.Unit.Summon[KBM.Lang], 70)
	KBM.Defaults.TimerObj.Assign(self.Beruhast)
	
	-- Assign Mechanics to Triggers
	self.Beruhast.Triggers.Inferno = KBM.Trigger:Create(self.Lang.Ability.Inferno[KBM.Lang], "cast", self.Beruhast)
	self.Beruhast.Triggers.Inferno:AddAlert(self.Beruhast.AlertsRef.Inferno)
	self.Beruhast.Triggers.InfernoInt = KBM.Trigger:Create(self.Lang.Ability.Inferno[KBM.Lang], "interrupt", self.Beruhast)
	self.Beruhast.Triggers.InfernoInt:AddStop(self.Beruhast.AlertsRef.Inferno)
	self.Beruhast.Triggers.Flame = KBM.Trigger:Create(self.Lang.Ability.Flame[KBM.Lang], "cast", self.Beruhast)
	self.Beruhast.Triggers.Flame:AddTimer(self.Beruhast.TimersRef.Flame)
	self.Beruhast.Triggers.Summon = KBM.Trigger:Create(self.Lang.Notify.Summon[KBM.Lang], "notify", self.Beruhast)
	self.Beruhast.Triggers.Summon:AddTimer(self.Beruhast.TimersRef.Summon)
	self.Beruhast.Triggers.Summon:AddAlert(self.Beruhast.AlertsRef.Summon)
	
	self.Beruhast.CastBar = KBM.CastBar:Add(self, self.Beruhast, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end