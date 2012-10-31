-- Soulrender Zilas Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local SZ = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Zilas.lua",
	Instance = HK.Name,
	InstanceObj = HK,
	PhaseObj = nil,
	Phase = 1,
	Timers = {},
	Lang = {},
	ID = "Zilas",
	Object = "SZ",
}

SZ.Zilas = {
	Mod = SZ,
	Level = "??",
	Active = false,
	Name = "Soulrender Zilas",
	NameShort = "Zilas",
	CastFilters = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	RaidID = "Raid",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Grasp = KBM.Defaults.TimerObj.Create("red"),
			GraspFirst = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			GraspWarn = KBM.Defaults.AlertObj.Create("orange"),
			Grasp = KBM.Defaults.AlertObj.Create("red"),
		},		
	},
}

KBM.RegisterMod(SZ.ID, SZ)

-- Main Unit Dictionary
SZ.Lang.Unit = {}
SZ.Lang.Unit.Zilas = KBM.Language:Add(SZ.Zilas.Name)
SZ.Lang.Unit.Zilas:SetGerman("Seelenreißer Zilas")
SZ.Lang.Unit.Zilas:SetFrench("\195\137tripeur d'\195\162mes Zilas")
SZ.Lang.Unit.Zilas:SetRussian("Душераздиратель Зилас")
SZ.Lang.Unit.Zilas:SetKorean("영혼구현자 질라스")
SZ.Zilas.Name = SZ.Lang.Unit.Zilas[KBM.Lang]
SZ.Descript = SZ.Zilas.Name
SZ.Lang.Unit.ZilasShort = KBM.Language:Add("Zilas")
SZ.Lang.Unit.ZilasShort:SetGerman("Zilas")
SZ.Lang.Unit.ZilasShort:SetFrench("Zilas")
SZ.Lang.Unit.ZilasShort:SetRussian("Зилас")
SZ.Lang.Unit.ZilasShort:SetKorean("질라스")
SZ.Zilas.NameShort = SZ.Lang.Unit.ZilasShort[KBM.Lang]
-- Additional Unit Dictionary
SZ.Lang.Unit.Imp = KBM.Language:Add("Escaped Imp")
SZ.Lang.Unit.Imp:SetGerman("Entflohener Imp")
SZ.Lang.Unit.Imp:SetRussian("Сбежавший бес")
SZ.Lang.Unit.Imp:SetFrench("Diablotin évadé")
SZ.Lang.Unit.Imp:SetKorean("탈옥한 임프")
SZ.Lang.Unit.ImpShort = KBM.Language:Add("Imp")
SZ.Lang.Unit.ImpShort:SetGerman("Imp")
SZ.Lang.Unit.ImpShort:SetRussian("Бес")
SZ.Lang.Unit.ImpShort:SetFrench("Diablotin")
SZ.Lang.Unit.ImpShort:SetKorean("임프")
SZ.Lang.Unit.Spirit = KBM.Language:Add("Drifting Spirit")
SZ.Lang.Unit.Spirit:SetGerman("Treibender Geist")
SZ.Lang.Unit.Spirit:SetRussian("Неприкаянная душа")
SZ.Lang.Unit.Spirit:SetFrench("Esprit errant")
SZ.Lang.Unit.Spirit:SetKorean("떠돌이 영혼")
SZ.Lang.Unit.SpiritShort = KBM.Language:Add("Spirit")
SZ.Lang.Unit.SpiritShort:SetGerman("Geist")
SZ.Lang.Unit.SpiritShort:SetRussian("Душа")
SZ.Lang.Unit.SpiritShort:SetFrench("Esprit")
SZ.Lang.Unit.SpiritShort:SetKorean("영혼")

-- Ability Dictionary
SZ.Lang.Ability = {}
SZ.Lang.Ability.Grasp = KBM.Language:Add("Soulrender's Grasp")
SZ.Lang.Ability.Grasp:SetGerman("Seelenreißer-Griff")
SZ.Lang.Ability.Grasp:SetFrench("Poigne d'Étripeur d'âmes")
SZ.Lang.Ability.Grasp:SetRussian("Хватка душедера")
SZ.Lang.Ability.Grasp:SetKorean("영혼분열자의 손아귀")
SZ.Lang.Ability.Cede = KBM.Language:Add("Cede Spirit")
SZ.Lang.Ability.Cede:SetGerman("Geist abgeben")
SZ.Lang.Ability.Cede:SetRussian("Передача духа")
SZ.Lang.Ability.Cede:SetFrench("Pacte impie")
SZ.Lang.Ability.Cede:SetKorean("영혼 양도")
SZ.Lang.Ability.Volley = KBM.Language:Add("Dark Volley")
SZ.Lang.Ability.Volley:SetGerman("Dunkler Treffer")
SZ.Lang.Ability.Volley:SetRussian("Темный залп")
SZ.Lang.Ability.Volley:SetFrench("Volée obscure")
SZ.Lang.Ability.Volley:SetKorean("암흑 공세")

-- Menu Dictionary
SZ.Lang.Menu = {}
SZ.Lang.Menu.Grasp = KBM.Language:Add("First "..SZ.Lang.Ability.Grasp[KBM.Lang])
SZ.Lang.Menu.Grasp:SetGerman("Erste "..SZ.Lang.Ability.Grasp[KBM.Lang])
SZ.Lang.Menu.Grasp:SetRussian("Первая "..SZ.Lang.Ability.Grasp[KBM.Lang])
SZ.Lang.Menu.Grasp:SetFrench("Première "..SZ.Lang.Ability.Grasp[KBM.Lang])

SZ.Imp = {
	Mod = SZ,
	Level = "??",
	Name = SZ.Lang.Unit.Imp[KBM.Lang],
	NameShort = SZ.Lang.Unit.ImpShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	RaidID = "Raid",
	AlertsRef = {},
	Ignore = true,
	Type = "multi",
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Cede = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

SZ.Spirit = {
	Mod = SZ,
	Level = "??",
	Name = SZ.Lang.Unit.Spirit[KBM.Lang],
	NameShort = SZ.Lang.Unit.SpiritShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	AlertsRef = {},
	RaidID = "Raid",
	Ignore = true,
	Type = "multi",
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Volley = KBM.Defaults.AlertObj.Create("purple"),
		},
	}
}

function SZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zilas.Name] = self.Zilas,
		[self.Imp.Name] = self.Imp,
		[self.Spirit.Name] = self.Spirit
	}
	KBM_Boss[self.Zilas.Name] = self.Zilas
	KBM.SubBoss[self.Imp.Name] = self.Imp
	KBM.SubBoss[self.Spirit.Name] = self.Spirit
end

function SZ:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		Zilas = {
			CastBar = self.Zilas.Settings.CastBar,
			TimersRef = self.Zilas.Settings.TimersRef,
			AlertsRef = self.Zilas.Settings.AlertsRef,
		},
		Imp = {
			AlertsRef = self.Imp.Settings.AlertsRef,
		},
		Spirit = {
			AlertsRef = self.Spirit.Settings.AlertsRef,
		},
	}
	KBMSZ_Settings = self.Settings
	chKBMSZ_Settings = self.Settings
	
end

function SZ:SwapSettings(bool)

	if bool then
		KBMSZ_Settings = self.Settings
		self.Settings = chKBMSZ_Settings
	else
		chKBMSZ_Settings = self.Settings
		self.Settings = KBMSZ_Settings
	end

end

function SZ:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSZ_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMSZ_Settings = self.Settings
	else
		KBMSZ_Settings = self.Settings
	end
	
	self.Zilas.Settings.AlertsRef.Grasp.Enabled = true
	
end

function SZ:SaveVars()
	
	if KBM.Options.Settings then
		chKBMSZ_Settings = self.Settings
	else
		KBMSZ_Settings = self.Settings
	end
	
end

function SZ:Castbar(units)
end

function SZ:RemoveUnits(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Available = false
		return true
	end
	return false
end

function SZ:Death(UnitID)
	if self.Zilas.UnitID == UnitID then
		self.Zilas.Dead = true
		return true
	elseif self.Imp.UnitList[UnitID] then
		self.Imp.UnitList[UnitID].CastBar:Remove()
		self.Imp.UnitList[UnitID].Dead = true
		self.Imp.UnitList[UnitID].CastBar = nil
	elseif self.Spirit.UnitList[UnitID] then
		self.Spirit.UnitList[UnitID].CastBar:Remove()
		self.Spirit.UnitList[UnitID].Dead = true
		self.Spirit.UnitList[UnitID].CastBar = nil
	end
	return false
end

function SZ:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Zilas.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zilas.CastBar:Create(unitID)
					self.PhaseObj.Objectives:AddPercent(self.Zilas.Name, 80, 100)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
				end
				self.Zilas.Dead = false
				self.Zilas.Casting = false
				self.Zilas.UnitID = unitID
				self.Zilas.Available = true
				return self.Zilas
			else
				if self.Bosses[uDetails.name] then
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						SubBossObj = {
							Mod = SZ,
							Level = "??",
							Name = uDetails.name,
							Dead = false,
							Casting = false,
							UnitID = unitID,
							Available = true,
						}
						self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
						if uDetails.name == self.Imp.Name then
							SubBossObj.CastBar = KBM.CastBar:Add(self, self.Imp, false, true)
							SubBossObj.CastBar:Create(unitID)
						elseif uDetails.name == self.Spirit.Name then
							SubBossObj.CastBar = KBM.CastBar:Add(self, self.Spirit, false, true)
							SubBossObj.CastBar:Create(unitID)
						end
					else
						self.Bosses[uDetails.name].UnitList[unitID].Available = true
						self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
					end
					return self.Bosses[uDetails.name].UnitList[unitID]
				end
			end
		end
	end
end

function SZ.PhaseTwo()
	SZ.Phase = 2
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(2)
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 70, 80)
	print("Phase 2 starting!")
end

function SZ.PhaseThree()
	SZ.Phase = 3
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(3)
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 40, 70)
	print("Phase 3 starting!")
end

function SZ.PhaseFour()
	SZ.Phase = 4
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(4)
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 20, 40)
	print("Phase 4 starting!")	
end

function SZ.PhaseFive()
	SZ.Phase = 5
	SZ.PhaseObj.Objectives:Remove()
	SZ.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	SZ.PhaseObj.Objectives:AddPercent(SZ.Zilas.Name, 0, 20)
	print("Final Phase!")
end

function SZ:Reset()
	self.EncounterRunning = false
	self.Zilas.Available = false
	self.Zilas.UnitID = nil
	self.Zilas.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)
	for UnitID, BossObj in pairs(self.Imp.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	for UnitID, BossObj in pairs(self.Spirit.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.Imp.UnitList = {}
	self.Spirit.UnitList = {}
	self.Phase = 1	
end

function SZ:Timer()
end

function SZ:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Zilas, self.Enabled)
end

function SZ:Start()
	-- Create Timers
	self.Zilas.TimersRef.Grasp = KBM.MechTimer:Add(self.Lang.Ability.Grasp[KBM.Lang], 58)
	self.Zilas.TimersRef.GraspFirst = KBM.MechTimer:Add(self.Lang.Ability.Grasp[KBM.Lang], 42)
	self.Zilas.TimersRef.GraspFirst.MenuName = self.Lang.Menu.Grasp[KBM.Lang]
	
	-- Create Alerts
	-- Zilas
	self.Zilas.AlertsRef.GraspWarn = KBM.Alert:Create(self.Lang.Ability.Grasp[KBM.Lang], 5, true, true)
	self.Zilas.AlertsRef.Grasp = KBM.Alert:Create(self.Lang.Ability.Grasp[KBM.Lang], 9, false, true)
	self.Zilas.AlertsRef.Grasp:NoMenu()
	-- Escaped Imp
	self.Imp.AlertsRef.Cede = KBM.Alert:Create(self.Lang.Ability.Cede[KBM.Lang], nil, false, true, "yellow")
	-- Drifting Spirit
	self.Spirit.AlertsRef.Volley = KBM.Alert:Create(self.Lang.Ability.Volley[KBM.Lang], nil, false, true, "purple")
	
	KBM.Defaults.TimerObj.Assign(self.Zilas)
	KBM.Defaults.AlertObj.Assign(self.Zilas)
	KBM.Defaults.AlertObj.Assign(self.Imp)
	KBM.Defaults.AlertObj.Assign(self.Spirit)
	
	-- Assign Mechanics to Triggers.
	-- Zilas
	self.Zilas.Triggers.Grasp = KBM.Trigger:Create(self.Lang.Ability.Grasp[KBM.Lang], "cast", self.Zilas)
	self.Zilas.Triggers.Grasp:AddTimer(self.Zilas.TimersRef.Grasp)
	self.Zilas.Triggers.Grasp:AddAlert(self.Zilas.AlertsRef.GraspWarn)
	self.Zilas.AlertsRef.GraspWarn:AlertEnd(self.Zilas.AlertsRef.Grasp)
	self.Zilas.Triggers.PhaseTwo = KBM.Trigger:Create(90, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Zilas.Triggers.PhaseThree = KBM.Trigger:Create(70, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseThree:AddTimer(self.Zilas.TimersRef.GraspFirst)
	self.Zilas.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Zilas.Triggers.PhaseFour = KBM.Trigger:Create(40, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Zilas.Triggers.PhaseFive = KBM.Trigger:Create(20, "percent", self.Zilas)
	self.Zilas.Triggers.PhaseFive:AddPhase(self.PhaseFive)
	
	-- Imps
	self.Imp.Triggers.Cede = KBM.Trigger:Create(self.Lang.Ability.Cede[KBM.Lang], "personalCast", self.Imp)
	self.Imp.Triggers.Cede:AddAlert(self.Imp.AlertsRef.Cede)
	self.Imp.Triggers.CedeInt = KBM.Trigger:Create(self.Lang.Ability.Cede[KBM.Lang], "personalInterrupt", self.Imp)
	self.Imp.Triggers.CedeInt:AddStop(self.Imp.AlertsRef.Cede)
	
	-- Spirits
	self.Spirit.Triggers.Volley = KBM.Trigger:Create(self.Lang.Ability.Volley[KBM.Lang], "cast", self.Spirit)
	self.Spirit.Triggers.Volley:AddAlert(self.Spirit.AlertsRef.Volley)
	self.Spirit.Triggers.VolleyInt = KBM.Trigger:Create(self.Lang.Ability.Volley[KBM.Lang], "interrupt", self.Spirit)
	self.Spirit.Triggers.VolleyInt:AddStop(self.Spirit.AlertsRef.Volley)
	
	-- Assign Castbar object.
	self.Zilas.CastBar = KBM.CastBar:Add(self, self.Zilas, true)
	
	-- Assing Phase Tracking.
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end