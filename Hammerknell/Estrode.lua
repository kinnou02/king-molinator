-- Estrode Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMES_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local ES = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Estrode.lua",
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Lang = {},
	Enrage = 60 * 12,
	ID = "Estrode",
	Object = "ES",
}

ES.Estrode = {
	Mod = ES,
	Level = "??",
	Active = false,
	Name = "Estrode",
	CastBar = nil,
	CastFilters = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Soul = KBM.Defaults.TimerObj.Create("red"),
			Mind = KBM.Defaults.TimerObj.Create("purple"),
			North = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Dancing = KBM.Defaults.AlertObj.Create("red"),
			DancingWarn = KBM.Defaults.AlertObj.Create("red"),
			North = KBM.Defaults.AlertObj.Create("orange"),
			Chastise = KBM.Defaults.AlertObj.Create("yellow"),
			Rift = KBM.Defaults.AlertObj.Create("orange"),
			Grasp = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(ES.ID, ES)

-- Main Unit Dictionary
ES.Lang.Unit = {}
ES.Lang.Unit.Estrode = KBM.Language:Add(ES.Estrode.Name)
ES.Lang.Unit.Estrode:SetGerman("Estrode")
ES.Lang.Unit.Estrode:SetFrench("Estrode")
ES.Lang.Unit.Estrode:SetRussian("Эстрода")
ES.Lang.Unit.Estrode:SetKorean("에스트로드")
ES.Estrode.Name = ES.Lang.Unit.Estrode[KBM.Lang]
ES.Descript = ES.Estrode.Name

-- Ability Dictionary
ES.Lang.Ability = {}
ES.Lang.Ability.Soul = KBM.Language:Add("Soul Capture")
ES.Lang.Ability.Soul:SetGerman("Seelenfang")
ES.Lang.Ability.Soul:SetRussian("Захват души")
ES.Lang.Ability.Soul:SetFrench("Capture d'âme")
ES.Lang.Ability.Soul:SetKorean("혼 포획")
ES.Lang.Ability.Mind = KBM.Language:Add("Mind Control")
ES.Lang.Ability.Mind:SetGerman("Gedankenkontrolle")
ES.Lang.Ability.Mind:SetRussian("Контроль разума")
ES.Lang.Ability.Mind:SetFrench("Volonté impérieuse")
ES.Lang.Ability.Mind:SetKorean("마음의 동요")
ES.Lang.Ability.Dancing = KBM.Language:Add("Dancing Steel")
ES.Lang.Ability.Dancing:SetGerman("Tanzender Stahl")
ES.Lang.Ability.Dancing:SetFrench("Dance de l'acier")
ES.Lang.Ability.Dancing:SetRussian("Танцующая сталь")
ES.Lang.Ability.Dancing:SetKorean("춤추는 검")
ES.Lang.Ability.North = KBM.Language:Add("Rage of the North")
ES.Lang.Ability.North:SetGerman("Wut des Nordens")
ES.Lang.Ability.North:SetRussian("Ярость севера")
ES.Lang.Ability.North:SetFrench("Rage du Nord")
ES.Lang.Ability.North:SetKorean("북방의 분노")
ES.Lang.Ability.Chastise = KBM.Language:Add("Chastise")
ES.Lang.Ability.Chastise:SetGerman("Züchtigung")
ES.Lang.Ability.Chastise:SetFrench("Châtiment")
ES.Lang.Ability.Chastise:SetKorean("처벌")
ES.Lang.Ability.Rift = KBM.Language:Add("Mistress of the Rift")
ES.Lang.Ability.Rift:SetGerman("Herrin des Risses")
ES.Lang.Ability.Rift:SetFrench("Avatar de la Faille")
ES.Lang.Ability.Rift:SetKorean("리프트의 여군주")
-- Debuff Dictionary
ES.Lang.Debuff = {}
ES.Lang.Debuff.Grasp = KBM.Language:Add("Neddra's Grasp")
ES.Lang.Debuff.Grasp:SetGerman("Neddras Griff")
ES.Lang.Debuff.Grasp:SetFrench("Poigne de Neddra")
ES.Lang.Debuff.Grasp:SetKorean("네드라의 손아귀")
-- Speak Dictionary
ES.Lang.Say = {}
ES.Lang.Say.Mind = KBM.Language:Add("Mmmm, you look delectable.")
ES.Lang.Say.Mind:SetGerman("Hm, Ihr seht köstlich aus.")
ES.Lang.Say.Mind:SetRussian("М-м-м, а ты выглядишь вкусно.")
ES.Lang.Say.Mind:SetFrench("Hum, vous avez l'air délectable.")
ES.Lang.Say.Mind:SetKorean("음, 너는 연약해 보이는군.")
-- Menu Dictionary
ES.Lang.Menu = {}
ES.Lang.Menu.Dancing = KBM.Language:Add(ES.Lang.Ability.Dancing[KBM.Lang].." duration")
ES.Lang.Menu.Dancing:SetGerman(ES.Lang.Ability.Dancing[KBM.Lang].." Dauer")
ES.Lang.Menu.Dancing:SetRussian(ES.Lang.Ability.Dancing[KBM.Lang].." продолжительность")
ES.Lang.Menu.Dancing:SetFrench(ES.Lang.Ability.Dancing[KBM.Lang].." durée")
ES.Lang.Menu.Dancing:SetKorean("춤추는 검 지속")
function ES:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Estrode.Name] = self.Estrode,
	}
	KBM_Boss[self.Estrode.Name] = self.Estrode	
end

function ES:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),		
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Estrode.Settings.CastBar,
		TimersRef = self.Estrode.Settings.TimersRef,
		AlertsRef = self.Estrode.Settings.AlertsRef,
	}
	KBMES_Settings = self.Settings
	chKBMES_Settings = self.Settings	
end

function ES:SwapSettings(bool)
	if bool then
		KBMES_Settings = self.Settings
		self.Settings = chKBMES_Settings
	else
		chKBMES_Settings = self.Settings
		self.Settings = KBMES_Settings
	end
end

function ES:LoadVars()
	local TargetLoad = nil	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMES_Settings, self.Settings)
	else
		KBM.LoadTable(KBMES_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMES_Settings = self.Settings
	else
		KBMES_Settings = self.Settings
	end	
end

function ES:SaveVars()
	if KBM.Options.Character then
		chKBMES_Settings = self.Settings
	else
		KBMES_Settings = self.Settings
	end	
end

function ES:Castbar(units)
end

function ES:RemoveUnits(UnitID)
	if self.Estrode.UnitID == UnitID then
		self.Estrode.Available = false
		return true
	end
	return false
end

function ES:Death(UnitID)
	if self.Estrode.UnitID == UnitID then
		self.Estrode.Dead = true
		return true
	end
	return false
end

function ES:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Estrode.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Estrode.Dead = false
					self.Estrode.Casting = false
					self.Estrode.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Estrode.Name, 0, 100)
					self.Phase = 1
				end
				self.Estrode.UnitID = unitID
				self.Estrode.Available = true
				return self.Estrode
			end
		end
	end
end

function ES:Reset()
	self.EncounterRunning = false
	self.Estrode.Available = false
	self.Estrode.UnitID = nil
	self.Estrode.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function ES:Timer()
	
end

function ES.Estrode:SetTimers(bool)	
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

function ES.Estrode:SetAlerts(bool)
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

function ES:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Estrode, self.Enabled)
end

function ES:Start()	
	-- Create Timers
	self.Estrode.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Ability.Soul[KBM.Lang], 40)
	self.Estrode.TimersRef.Mind = KBM.MechTimer:Add(self.Lang.Ability.Mind[KBM.Lang], 60)
	self.Estrode.TimersRef.North = KBM.MechTimer:Add(self.Lang.Ability.North[KBM.Lang], 8)
	
	-- Screen Alerts
	self.Estrode.AlertsRef.DancingWarn = KBM.Alert:Create(self.Lang.Ability.Dancing[KBM.Lang], nil, false, true, "red")
	self.Estrode.AlertsRef.Dancing = KBM.Alert:Create(self.Lang.Ability.Dancing[KBM.Lang], nil, true, true, "red")
	self.Estrode.AlertsRef.Dancing.MenuName = self.Lang.Menu.Dancing[KBM.Lang]
	self.Estrode.AlertsRef.North = KBM.Alert:Create(self.Lang.Ability.North[KBM.Lang], 2, true, false, "orange")
	self.Estrode.AlertsRef.Chastise = KBM.Alert:Create(self.Lang.Ability.Chastise[KBM.Lang], nil, true, true, "yellow")
	self.Estrode.AlertsRef.Rift = KBM.Alert:Create(self.Lang.Ability.Rift[KBM.Lang], 2, true, false, "orange")
	self.Estrode.AlertsRef.Grasp = KBM.Alert:Create(self.Lang.Debuff.Grasp[KBM.Lang], nil, false, true, "purple")
	
	KBM.Defaults.TimerObj.Assign(self.Estrode)
	KBM.Defaults.AlertObj.Assign(self.Estrode)
	
	-- Assign Mechanics to Triggers
	self.Estrode.Triggers.Soul = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Soul:AddTimer(self.Estrode.TimersRef.Soul)
	self.Estrode.Triggers.Soul:AddStop(self.Estrode.TimersRef.North)
	self.Estrode.Triggers.Mind = KBM.Trigger:Create(self.Lang.Say.Mind[KBM.Lang], "say", self.Estrode)
	self.Estrode.Triggers.Mind:AddTimer(self.Estrode.TimersRef.Mind)
	self.Estrode.Triggers.DancingWarn = KBM.Trigger:Create(self.Lang.Ability.Dancing[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.DancingWarn:AddAlert(self.Estrode.AlertsRef.DancingWarn)
	self.Estrode.Triggers.Dancing = KBM.Trigger:Create(self.Lang.Ability.Dancing[KBM.Lang], "channel", self.Estrode)
	self.Estrode.Triggers.Dancing:AddAlert(self.Estrode.AlertsRef.Dancing)
	self.Estrode.Triggers.North = KBM.Trigger:Create(self.Lang.Ability.North[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.North:AddAlert(self.Estrode.AlertsRef.North)
	self.Estrode.Triggers.North:AddTimer(self.Estrode.TimersRef.North)
	self.Estrode.Triggers.Chastise = KBM.Trigger:Create(self.Lang.Ability.Chastise[KBM.Lang], "cast", self.Estrode)
	self.Estrode.Triggers.Chastise:AddAlert(self.Estrode.AlertsRef.Chastise)
	self.Estrode.Triggers.ChastiseInt = KBM.Trigger:Create(self.Lang.Ability.Chastise[KBM.Lang], "interrupt", self.Estrode)
	self.Estrode.Triggers.ChastiseInt:AddStop(self.Estrode.AlertsRef.Chastise)
	self.Estrode.Triggers.Rift = KBM.Trigger:Create(self.Lang.Ability.Rift[KBM.Lang], "buff", self.Estrode)
	self.Estrode.Triggers.Rift:AddAlert(self.Estrode.AlertsRef.Rift)
	self.Estrode.Triggers.Grasp = KBM.Trigger:Create(self.Lang.Debuff.Grasp[KBM.Lang], "playerBuff", self.Estrode)
	self.Estrode.Triggers.Grasp:AddAlert(self.Estrode.AlertsRef.Grasp, true)
	self.Estrode.Triggers.Grasp = KBM.Trigger:Create(self.Lang.Debuff.Grasp[KBM.Lang], "playerBuffRemove", self.Estrode)
	self.Estrode.Triggers.Grasp:AddStop(self.Estrode.AlertsRef.Grasp)
	
	self.Estrode.CastBar = KBM.CastBar:Add(self, self.Estrode, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()	
end