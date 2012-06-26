-- Grugonim Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGR_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local GR = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Grugonim.lua",
	Instance = HK.Name,
	Timers = {},
	Lang = {},
	Phase = 1,
	Enrage = 60 * 13,
	ID = "Grugonim",
	Object = "GR",
	Counts = {
		Towers = 0,
		Breaths = 0,
	}
}

GR.Grugonim = {
	Mod = GR,
	Level = "??",
	Active = false,
	Name = "Grugonim",
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		Filters = {
			Enabled = true,
			Decay = KBM.Defaults.CastFilter.Create("dark_green"),
			Bile = KBM.Defaults.CastFilter.Create("purple"),
			Breath = KBM.Defaults.CastFilter.Create("red"),
			Disruption = KBM.Defaults.CastFilter.Create("orange"),
			Swarm = KBM.Defaults.CastFilter.Create("blue"),
		},
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Decay = KBM.Defaults.AlertObj.Create("dark_green"),
			Bile = KBM.Defaults.AlertObj.Create("purple"),
			Breath = KBM.Defaults.AlertObj.Create("red"),
			BreathWarn = KBM.Defaults.AlertObj.Create("orange"),
		},
	}
}

GR.Tower = {
	Mod = GR,
	Level = "??",
	Name = "Manifested Death",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

KBM.RegisterMod(GR.ID, GR)

-- Main Unit Dictionary
GR.Lang.Unit = {}
GR.Lang.Unit.Grugonim = KBM.Language:Add(GR.Grugonim.Name)
GR.Lang.Unit.Grugonim:SetGerman("Grugonim")
GR.Lang.Unit.Grugonim:SetFrench("Grugonim")
GR.Lang.Unit.Grugonim:SetRussian("Гругоним")
GR.Lang.Unit.Grugonim:SetKorean("그루고님")
GR.Grugonim.Name = GR.Lang.Unit.Grugonim[KBM.Lang]
GR.Lang.Unit.Tower = KBM.Language:Add(GR.Tower.Name)
GR.Lang.Unit.Tower:SetGerman("Manifestierter Tod")
GR.Lang.Unit.Tower:SetFrench("Mort manifestée")
GR.Lang.Unit.Tower:SetRussian("Материализованная Смерть")
GR.Lang.Unit.Tower:SetKorean("드러난 죽음")
GR.Tower.Name = GR.Lang.Unit.Tower[KBM.Lang]
GR.Descript = GR.Grugonim.Name

-- Ability Dictionary
GR.Lang.Ability = {}
GR.Lang.Ability.Decay = KBM.Language:Add("Rampant Decay")
GR.Lang.Ability.Decay:SetGerman("Wilder Verfall")
GR.Lang.Ability.Decay:SetFrench("Pourriture rampante")
GR.Lang.Ability.Decay:SetRussian("Бурное разложение")
GR.Lang.Ability.Decay:SetKorean("광란의 쇠락")
GR.Lang.Ability.Bile = KBM.Language:Add("Corrosive Bile")
GR.Lang.Ability.Bile:SetGerman("Ätzende Galle")
GR.Lang.Ability.Bile:SetFrench("Vase corrosive")
GR.Lang.Ability.Bile:SetRussian("Едкая желчь")
GR.Lang.Ability.Bile:SetKorean("부식성 담즙")
GR.Lang.Ability.Breath = KBM.Language:Add("Necrotic Breath")
GR.Lang.Ability.Breath:SetGerman("Nekrotischer Atem")
GR.Lang.Ability.Breath:SetRussian("Мертвящее дыхание")
GR.Lang.Ability.Breath:SetFrench("Respiration nécrotique")
GR.Lang.Ability.Breath:SetKorean("괴사 숨결")
GR.Lang.Ability.Disruption = KBM.Language:Add("Seismic Disruption")
GR.Lang.Ability.Disruption:SetGerman("Seismische Störung")
GR.Lang.Ability.Disruption:SetFrench("Perturbation sismique")
GR.Lang.Ability.Disruption:SetRussian("Сейсмическое разрушение")
GR.Lang.Ability.Disruption:SetKorean("지진 붕괴")
GR.Lang.Ability.Swarm = KBM.Language:Add("Parasite Swarm")
GR.Lang.Ability.Swarm:SetGerman("Parasitenschwarm")
GR.Lang.Ability.Swarm:SetFrench("Nuée parasite")
GR.Lang.Ability.Swarm:SetRussian("Выводок паразитов")
GR.Lang.Ability.Swarm:SetKorean("기생 벌 떼")

-- Debuff Dictionary
GR.Lang.Debuff = {}
GR.Lang.Debuff.Toxin = KBM.Language:Add("Heart Stopping Toxin")
GR.Lang.Debuff.Toxin:SetFrench("Toxine d'arrêt cardiaque")
GR.Lang.Debuff.Toxin:SetGerman("Herzstillstandsgift")
GR.Lang.Debuff.Toxin:SetRussian("Останавливающий сердце яд")
GR.Lang.Debuff.Toxin:SetKorean("심장 정지 독소")

-- Menu Dictionary
GR.Lang.Menu = {}
GR.Lang.Menu.Breath = KBM.Language:Add(GR.Lang.Ability.Breath[KBM.Lang].." duration")
GR.Lang.Menu.Breath:SetGerman(GR.Lang.Ability.Breath[KBM.Lang].." Dauer")
GR.Lang.Menu.Breath:SetRussian(GR.Lang.Ability.Breath[KBM.Lang].." продолжительность")
GR.Lang.Menu.Breath:SetFrench(GR.Lang.Ability.Breath[KBM.Lang].." durée")
GR.Lang.Menu.Breath:SetKorean("괴사 숨결 지속")

-- Phase Monitor Dictionary
GR.Lang.Phase = {}
GR.Lang.Phase.Towers = KBM.Language:Add("Towers")
GR.Lang.Phase.Towers:SetGerman("Türme")
GR.Lang.Phase.Towers:SetRussian("Башни")
GR.Lang.Phase.Towers:SetFrench("Balises")
GR.Lang.Phase.Towers:SetKorean("비콘단계")

function GR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Grugonim.Name] = self.Grugonim,
		[self.Tower.Name] = self.Tower,
	}
	KBM_Boss[self.Grugonim.Name] = self.Grugonim
	KBM.SubBoss[self.Tower.Name] = self.Tower	
end

function GR:InitVars()	
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		CastBar = GR.Grugonim.Settings.CastBar,
		CastFilters = GR.Grugonim.Settings.Filters,
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		TimersRef = GR.Grugonim.Settings.TimersRef,
		AlertsRef = GR.Grugonim.Settings.AlertsRef,
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMGR_Settings = self.Settings
	chKBMGR_Settings = self.Settings
end

function GR:SwapSettings(bool)
	if bool then
		KBMGR_Settings = self.Settings
		self.Settings = chKBMGR_Settings
	else
		chKBMGR_Settings = self.Settings
		self.Settings = KBMGR_Settings
	end
end

function GR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGR_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMGR_Settings = self.Settings
	else
		KBMGR_Settings = self.Settings
	end
	
	self.Grugonim.CastFilters[self.Lang.Ability.Decay[KBM.Lang]] = {ID = "Decay"}
	self.Grugonim.CastFilters[self.Lang.Ability.Bile[KBM.Lang]] = {ID = "Bile"}
	self.Grugonim.CastFilters[self.Lang.Ability.Breath[KBM.Lang]] = {ID = "Breath"}
	self.Grugonim.CastFilters[self.Lang.Ability.Disruption[KBM.Lang]] = {ID = "Disruption"}
	self.Grugonim.CastFilters[self.Lang.Ability.Swarm[KBM.Lang]] = {ID = "Swarm"}
		
	KBM.Defaults.CastFilter.Assign(self.Grugonim)	
end

function GR:SaveVars()
	if KBM.Options.Character then
		chKBMGR_Settings = self.Settings
	else
		KBMGR_Settings = self.Settings
	end	
end

function GR:Castbar(units)
end

function GR:RemoveUnits(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Available = false
		return true
	end
	return false	
end

function GR.BreathCount()
	GR.Counts.Breaths = GR.Counts.Breaths + 1
	if KBM.PhaseMonitor.Objectives.Lists.Meta[GR.Lang.Ability.Breath[KBM.Lang]] then
		KBM.PhaseMonitor.Objectives.Lists.Meta[GR.Lang.Ability.Breath[KBM.Lang]]:Update(GR.Counts.Breaths)
	end
end

function GR.BreathReset()
	GR.Counts.Breaths = 0
	if KBM.PhaseMonitor.Objectives.Lists.Meta[GR.Lang.Ability.Breath[KBM.Lang]] then
		KBM.PhaseMonitor.Objectives.Lists.Meta[GR.Lang.Ability.Breath[KBM.Lang]]:Update(GR.Counts.Breaths)
	end
	GR.Grugonim.CastFilters[GR.Lang.Ability.Breath[KBM.Lang]].Current = 1
end

function GR.TowerPhase()
	GR.Counts.Breaths = 0
	GR.PhaseObj.Objectives:Remove()
	GR.PhaseObj:SetPhase(GR.Lang.Phase.Towers[KBM.Lang])
	GR.Grugonim.CastFilters[GR.Lang.Ability.Breath[KBM.Lang]].Current = 1
	if GR.Phase == 1 then
		GR.Phase = 2
		GR.PhaseObj.Objectives:AddDeath(GR.Tower.Name, 3)
	else
		GR.Phase = 4
		GR.PhaseObj.Objectives:AddDeath(GR.Tower.Name, 6)
	end
end

function GR.PhaseThree()
	GR.Phase = 3
	GR.PhaseObj.Objectives:Remove()
	GR.PhaseObj:SetPhase(GR.Phase)
	GR.PhaseObj.Objectives:AddPercent(GR.Grugonim.Name, 10, 50)
	GR.PhaseObj.Objectives:AddMeta(GR.Lang.Ability.Breath[KBM.Lang], 3, 0)
end

function GR.PhaseFive()
	GR.Phase = 5
	GR.PhaseObj.Objectives:Remove()
	GR.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	GR.PhaseObj.Objectives:AddPercent(GR.Grugonim.Name, 0, 10)
	GR.PhaseObj.Objectives:AddMeta(GR.Lang.Ability.Breath[KBM.Lang], 3, 0)
end

function GR:Death(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Dead = true
		return true
	else
		-- Tower Phase
		if self.Phase == 2 then
			if self.Tower.UnitList[UnitID] then
				if not self.Tower.UnitList[UnitID].Dead then
					self.Counts.Towers = self.Counts.Towers + 1
					self.Tower.UnitList[UnitID].Dead = true
					if self.Counts.Towers == 3 then
						self.Counts.Towers = 0
						self.Tower.UnitList = {}
						self.PhaseThree()
					end
				end
			end
		elseif self.Phase == 4 then
			if self.Tower.UnitList[UnitID] then
				if not self.Tower.UnitList[UnitID].Dead then
					self.Counts.Towers = self.Counts.Towers + 1
					self.Tower.UnitList[UnitID] = {}
					if self.Counts.Towers == 6 then
						self.Counts.Towers = 0
						self.Tower.UnitList = {}
						self.PhaseFive()
					end
				end
			end
		end
	end
	return false	
end

function GR:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
		
			if uDetails.name == self.Grugonim.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Grugonim.CastBar:Create(unitID)
					KBM.TankSwap:Start(self.Lang.Debuff.Toxin[KBM.Lang], unitID)
					self.Phase = 1
					self.Counts.Breaths = 0
					self.Counts.Towers = 0
					self.PhaseObj.Objectives:AddPercent(self.Grugonim.Name, 50, 100)
					self.PhaseObj.Objectives:AddMeta(self.Lang.Ability.Breath[KBM.Lang], 3, 0)
					self.PhaseObj:Start(self.StartTime)
					self.Grugonim.CastFilters[self.Lang.Ability.Breath[KBM.Lang]].Count = 3
					self.Grugonim.CastFilters[self.Lang.Ability.Breath[KBM.Lang]].Current = 1
				end
				self.Grugonim.Dead = false
				self.Grugonim.Casting = false
				self.Grugonim.UnitID = unitID
				self.Grugonim.Available = true
				return self.Grugonim
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = GR,
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
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]
			end
			
		end
	end
end

function GR:Reset()	
	self.EncounterRunning = false
	self.Grugonim.Available = false
	self.Grugonim.UnitID = nil
	self.Grugonim.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)
	self.Counts.Breaths = 0
	self.Counts.Towers = 0
	self.Tower.UnitList = {}	
end

function GR:Timer()
	
end

function GR.Grugonim:SetTimers(bool)	
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

function GR.Grugonim:SetAlerts(bool)
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

function GR:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Grugonim, self.Enabled)
end

function GR:Start()	
	-- AddTimers
	self.Grugonim.TimersRef.Breath = KBM.MechTimer:Add(self.Lang.Ability.Breath[KBM.Lang], 15)
	KBM.Defaults.TimerObj.Assign(self.Grugonim)
	
	-- Add Alerts
	self.Grugonim.AlertsRef.Decay = KBM.Alert:Create(self.Lang.Ability.Decay[KBM.Lang], nil, false, true, "dark_green")
	self.Grugonim.AlertsRef.Bile = KBM.Alert:Create(self.Lang.Ability.Bile[KBM.Lang], nil, false, true, "purple")
	self.Grugonim.AlertsRef.BreathWarn = KBM.Alert:Create(self.Lang.Ability.Breath[KBM.Lang], nil, true, true, "orange")
	self.Grugonim.AlertsRef.Breath = KBM.Alert:Create(self.Lang.Ability.Breath[KBM.Lang], nil, false, true, "red")
	self.Grugonim.AlertsRef.Breath.MenuName = self.Lang.Menu.Breath[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Grugonim)
	
	-- Assign Mechanics to Triggers
	self.Grugonim.Triggers.Decay = KBM.Trigger:Create(self.Lang.Ability.Decay[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Decay:AddAlert(self.Grugonim.AlertsRef.Decay)
	self.Grugonim.Triggers.Bile = KBM.Trigger:Create(self.Lang.Ability.Bile[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Bile:AddAlert(self.Grugonim.AlertsRef.Bile)
	self.Grugonim.Triggers.BreathWarn = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.BreathWarn:AddTimer(self.Grugonim.TimersRef.Breath)
	self.Grugonim.Triggers.BreathWarn:AddAlert(self.Grugonim.AlertsRef.BreathWarn)
	self.Grugonim.Triggers.BreathWarn:AddPhase(self.BreathCount)
	self.Grugonim.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "channel", self.Grugonim)
	self.Grugonim.Triggers.Breath:AddAlert(self.Grugonim.AlertsRef.Breath)
	self.Grugonim.Triggers.Disruption = KBM.Trigger:Create(self.Lang.Ability.Disruption[KBM.Lang], "cast", self.Grugonim)
	self.Grugonim.Triggers.Disruption:AddPhase(self.BreathReset)
	self.Grugonim.Triggers.Disruption:AddStop(self.Grugonim.TimersRef.Breath)
	self.Grugonim.Triggers.PhaseTwo = KBM.Trigger:Create(50, "percent", self.Grugonim)
	self.Grugonim.Triggers.PhaseTwo:AddPhase(self.TowerPhase)
	self.Grugonim.Triggers.PhaseTwo:AddStop(self.Grugonim.TimersRef.Breath)
	self.Grugonim.Triggers.PhaseFour = KBM.Trigger:Create(10, "percent", self.Grugonim)
	self.Grugonim.Triggers.PhaseFour:AddPhase(self.TowerPhase)
	self.Grugonim.Triggers.PhaseFour:AddStop(self.Grugonim.TimersRef.Breath)
	
	self.Grugonim.CastBar = KBM.CastBar:Add(self, self.Grugonim)	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)		
	self:DefineMenu()
end