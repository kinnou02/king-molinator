-- High Priestess Hydriss Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHHH_Settings = nil
chKBMDHHH_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local DH = KBM.BossMod["Drowned Halls"]

local HH = {
	Directory = DH.Directory,
	File = "Hydriss.lua",
	Enabled = true,
	Instance = DH.Name,
	InstanceObj = DH,
	Lang = {},
	ID = "Hydriss",
	PhaseObjects = {},
	Phase = 1,
	Enrage = 60 * 12,
	Object = "HH",
}

HH.Hydriss = {
	Mod = HH,
	Level = "??",
	Active = false,
	Name = "High Priestess Hydriss",
	NameShort = "Hydriss",
	TimersRef = {},
	AlertsRef = {},
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	RaidID = "U01904C0A16F7CCB8",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			AirFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Tsunami = KBM.Defaults.TimerObj.Create("blue"),
			SeaFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Sea = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
		},
	},
}

KBM.RegisterMod(HH.ID, HH)

-- Main Unit Dictionary
HH.Lang.Unit = {}
HH.Lang.Unit.Hydriss = KBM.Language:Add(HH.Hydriss.Name)
HH.Lang.Unit.Hydriss:SetGerman("Hohepriesterin Hydriss")
HH.Lang.Unit.Hydriss:SetFrench("Grande prêtresse Hydriss")
HH.Lang.Unit.Hydriss:SetRussian("Первосвященница Гидрисс")
HH.Lang.Unit.Hydriss:SetKorean("상급 여사제 히드리스")
HH.Lang.Unit.HydShort = KBM.Language:Add(HH.Hydriss.Name)
HH.Lang.Unit.HydShort:SetGerman()
HH.Lang.Unit.HydShort:SetFrench()
HH.Lang.Unit.HydShort:SetRussian("Гидрисс")
HH.Lang.Unit.HydShort:SetKorean("상급 여사제 히드리스")
HH.Lang.Unit.Sea = KBM.Language:Add("Seaspawn")
HH.Lang.Unit.Sea:SetGerman("Meeresbrut")
HH.Lang.Unit.Sea:SetFrench("Engeance des mers")
HH.Lang.Unit.Sea:SetRussian("Порождение моря")
HH.Lang.Unit.Sea:SetKorean("바다혈족")
HH.Lang.Unit.Hive = KBM.Language:Add("Seaclaw Hive")
HH.Lang.Unit.Hive:SetFrench("Nid de griffemarées")
HH.Lang.Unit.Hive:SetGerman("Seeklauennest")
HH.Lang.Unit.Hive:SetRussian("Гнездо водолапов")
HH.Lang.Unit.Hive:SetKorean("바다발톱 소굴")
-- Ability Dictionary
HH.Lang.Ability = {}
HH.Lang.Ability.Tsunami = KBM.Language:Add("Tsunami")
HH.Lang.Ability.Tsunami:SetGerman()
HH.Lang.Ability.Tsunami:SetFrench()
HH.Lang.Ability.Tsunami:SetRussian("Цунами")
HH.Lang.Ability.Tsunami:SetKorean("쓰나미")
HH.Lang.Ability.Shock = KBM.Language:Add("Hydrostatic Shock")
HH.Lang.Ability.Shock:SetRussian("Гидростатический удар")
HH.Lang.Ability.Shock:SetFrench("Choc hydrostatique")
HH.Lang.Ability.Shock:SetGerman("Hydrostatischer Schock")
HH.Lang.Ability.Shock:SetKorean("수압 충격")

-- Mechanic Dictionary
HH.Lang.Mechanic = {}
HH.Lang.Mechanic.Air = KBM.Language:Add("Air Phase")
HH.Lang.Mechanic.Air:SetGerman("Flug Phase")
HH.Lang.Mechanic.Air:SetFrench("Phase Air")
HH.Lang.Mechanic.Air:SetRussian("Воздушная фаза")
HH.Lang.Mechanic.Air:SetKorean("공중 단계")

HH.Seaspawn = {
	Mod = HH,
	Level = "??",
	Active = false,
	Name = HH.Lang.Unit.Sea[KBM.Lang],
	Menu = {},
	Dead = false,
	Ignore = true,
	Available = false,
	UnitID = nil,
}

HH.Hive = {

}

HH.Hydriss.Name = HH.Lang.Unit.Hydriss[KBM.Lang]
HH.Hydriss.NameShort = HH.Lang.Unit.HydShort[KBM.Lang]
HH.Descript = HH.Hydriss.Name

function HH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Hydriss.Name] = self.Hydriss,
	}
end

function HH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Hydriss.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Hydriss.Settings.TimersRef,
		AlertsRef = self.Hydriss.Settings.AlertsRef,
		PhaseMon = KBM.Defaults.PhaseMon(),
	}
	KBMDHHH_Settings = self.Settings
	chKBMDHHH_Settings = self.Settings
end

function HH:SwapSettings(bool)

	if bool then
		KBMDHHH_Settings = self.Settings
		self.Settings = chKBMDHHH_Settings
	else
		chKBMDHHH_Settings = self.Settings
		self.Settings = KBMDHHH_Settings
	end

end

function HH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHHH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHHH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHHH_Settings = self.Settings
	else
		KBMDHHH_Settings = self.Settings
	end	
end

function HH:SaveVars()	
	if KBM.Options.Character then
		chKBMDHHH_Settings = self.Settings
	else
		KBMDHHH_Settings = self.Settings
	end	
end

function HH:Castbar(units)
end

function HH:RemoveUnits(UnitID)
	if self.Hydriss.UnitID == UnitID then
		self.Hydriss.Available = false
		return true
	end
	return false
end

function HH.SpawnStart()
	HH.PhaseObjects.Sea = HH.PhaseObj.Objectives:AddPercent(HH.Seaspawn.Name, 0, 100)
	HH.PhaseObj:SetPhase(HH.Lang.Unit.Sea[KBM.Lang])
end

function HH.SpawnEnd()
	HH.PhaseObj.Objectives.Remove(HH.PhaseObjects.Sea)
	HH.PhaseObj:SetPhase(KBM.Language.Options.Ground[KBM.Lang])
end

function HH:Death(UnitID)
	if self.Hydriss.UnitID == UnitID then
		self.Hydriss.Dead = true
		return true
	end
	return false
end

function HH:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Hydriss.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hydriss.Dead = false
					self.Hydriss.Casting = false
					self.Hydriss.CastBar:Create(unitID)
					KBM.MechTimer:AddStart(self.Hydriss.TimersRef.AirFirst)
					KBM.MechTimer:AddStart(self.Hydriss.TimersRef.SeaFirst)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Hydriss.Name, 0, 100)
					self.PhaseObj:SetPhase(KBM.Language.Options.Ground[KBM.Lang])
					self.Phase = 1
				end
				self.Hydriss.UnitID = unitID
				self.Hydriss.Available = true
				return self.Hydriss
			end
		end
	end
end

function HH:Reset()
	self.EncounterRunning = false
	self.Hydriss.Available = false
	self.Hydriss.UnitID = nil
	self.Hydriss.Dead = false
	self.Hydriss.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real)
	self.Phase = 1
end

function HH:Timer()
	
end

function HH:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Hydriss, self.Enabled)
end

function HH:Start()
	-- Create Timers
	self.Hydriss.TimersRef.AirFirst = KBM.MechTimer:Add(self.Lang.Mechanic.Air[KBM.Lang], 87)
	self.Hydriss.TimersRef.Tsunami = KBM.MechTimer:Add(self.Lang.Ability.Tsunami[KBM.Lang], 10)
	self.Hydriss.TimersRef.SeaFirst = KBM.MechTimer:Add(self.Lang.Unit.Sea[KBM.Lang], 20)
	self.Hydriss.TimersRef.Sea = KBM.MechTimer:Add(self.Lang.Unit.Sea[KBM.Lang], 180, true)
	self.Hydriss.TimersRef.Sea:NoMenu()
	self.Hydriss.TimersRef.SeaFirst:AddTimer(self.Hydriss.TimersRef.Sea, 0)
	KBM.Defaults.TimerObj.Assign(self.Hydriss)
	
	-- Create Alerts
	
	-- Assign Timers and Alerts to triggers.
	self.Hydriss.Triggers.Tsunami = KBM.Trigger:Create(self.Lang.Ability.Tsunami[KBM.Lang], "cast", self.Hydriss)
	self.Hydriss.Triggers.Tsunami:AddTimer(self.Hydriss.TimersRef.Tsunami)
	
	self.Hydriss.CastBar = KBM.CastBar:Add(self, self.Hydriss, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end