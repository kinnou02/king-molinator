-- Ereandorn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPEN_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local EN = {
	Directory = ROTP.Directory,
	File = "Ereandorn.lua",
	Enabled = true,
	Instance = ROTP.Name,
	InstanceObj = ROTP,
	HasPhases = false,
	Lang = {},
	TankSwap = false,
	ID = "Ereandorn",
	Menu = {},
	Object = "EN",
}

EN.Ereandorn = {
	Mod = EN,
	Level = 52,
	Active = false,
	Name = "Ereandorn",
	Menu = {},
	Castbar = nil,
	CastFilters = {},
	HasCastFilters = false,
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UTID = "U3F8B7916402E8F10",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Combustion = KBM.Defaults.AlertObj.Create("red"),
			Growth = KBM.Defaults.AlertObj.Create("red"),
			Eruption = KBM.Defaults.AlertObj.Create("orange"),
		},
		MechRef = {
			Enabled = true,
			Combustion = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

KBM.RegisterMod(EN.ID, EN)

-- Main Unit Dictionary
EN.Lang.Unit = {}
EN.Lang.Unit.Ereandorn = KBM.Language:Add(EN.Ereandorn.Name)
EN.Lang.Unit.Ereandorn:SetGerman()
EN.Lang.Unit.Ereandorn:SetFrench()
EN.Lang.Unit.Ereandorn:SetRussian("Эреандорн")
EN.Lang.Unit.Ereandorn:SetKorean("에레안도른")
EN.Ereandorn.Name = EN.Lang.Unit.Ereandorn[KBM.Lang]
EN.Descript = EN.Ereandorn.Name

-- Notify Dictionary
EN.Lang.Notify = {}
EN.Lang.Notify.Combustion = KBM.Language:Add('Ereandorn says, "(%a*), how does it feel to burn?"')
EN.Lang.Notify.Combustion:SetGerman('Ereandorn sagt: "(%a*), wie fühlt es sich an, zu verbrennen?"')
EN.Lang.Notify.Combustion:SetFrench('Ereandorn dit : "Cà vous fait quel effet de brûler, (%a*) ?"')
EN.Lang.Notify.Combustion:SetRussian('Эреандорн спрашивает: "Ну как, (%a*), нравится тебе гореть?"')
EN.Lang.Notify.Combustion:SetKorean('에레안도른이 "(%a*), 타오르는 느낌이 어떠냐?"라고 말합니다.')
EN.Lang.Notify.Growth = KBM.Language:Add("The corpse of (%a*) will fuel our conquest")
EN.Lang.Notify.Growth:SetGerman("Der Leichnam von (%a*) wird unsere Eroberung vorantreiben")
EN.Lang.Notify.Growth:SetFrench("Le cadavre de (%a*) alimentera notre conquête !")
EN.Lang.Notify.Growth:SetRussian("(%a*) - вот чей труп поможет нам в нашем вторжении!")
EN.Lang.Notify.Growth:SetKorean("(%a*)의 시체는 우리 승리의 토대가 될 것이다!")
EN.Lang.Notify.Eruption = KBM.Language:Add("I will rebuild this world in flames!")
EN.Lang.Notify.Eruption:SetGerman("Ich werde diese Welt in Flammen neu formen!")
EN.Lang.Notify.Eruption:SetFrench("Je rebâtirai ce monde dans les flammes !")
EN.Lang.Notify.Eruption:SetRussian("Я предам этот мир огню!")
EN.Lang.Notify.Eruption:SetKorean("이 세계를 불꽃으로 재건할 것이다!")
-- Ability Dictionary
EN.Lang.Ability = {}
EN.Lang.Ability.Combustion = KBM.Language:Add("Excitable Combustion")
EN.Lang.Ability.Combustion:SetGerman("Anregbare Verbrennung")
EN.Lang.Ability.Combustion:SetRussian("Опасное сгорание")
EN.Lang.Ability.Combustion:SetFrench("Combustion tendue")
EN.Lang.Ability.Combustion:SetKorean("촉발성 연소")
EN.Lang.Ability.Growth = KBM.Language:Add("Molten Growth")
EN.Lang.Ability.Growth:SetGerman("Geschmolzener Wuchs")
EN.Lang.Ability.Growth:SetRussian("Извержение лавы")
EN.Lang.Ability.Growth:SetFrench("Éruption liquide")
EN.Lang.Ability.Growth:SetKorean("고온용암 성장")
EN.Lang.Ability.Eruption = KBM.Language:Add("Volcanic Eruption")
EN.Lang.Ability.Eruption:SetGerman("Vulkanausbruch")
EN.Lang.Ability.Eruption:SetRussian("Извержение вулкана")
EN.Lang.Ability.Eruption:SetFrench("Éruption volcanique")
EN.Lang.Ability.Eruption:SetKorean("화산 폭발")

function EN:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ereandorn.Name] = self.Ereandorn,
	}
end

function EN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ereandorn.Settings.CastBar,
		AlertsRef = self.Ereandorn.Settings.AlertsRef,
		MechRef = self.Ereandorn.Settings.MechRef,
		PhaseMon = KBM.Defaults.PhaseMon(),
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMROTPEN_Settings = self.Settings
	chKBMROTPEN_Settings = self.Settings
	
end

function EN:SwapSettings(bool)
	if bool then
		KBMROTPEN_Settings = self.Settings
		self.Settings = chKBMROTPEN_Settings
	else
		chKBMROTPEN_Settings = self.Settings
		self.Settings = KBMROTPEN_Settings
	end
end

function EN:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPEN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPEN_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROTPEN_Settings = self.Settings
	else
		KBMROTPEN_Settings = self.Settings
	end	
end

function EN:SaveVars()	
	if KBM.Options.Character then
		chKBMROTPEN_Settings = self.Settings
	else
		KBMROTPEN_Settings = self.Settings
	end	
end

function EN:Castbar(units)
end

function EN:RemoveUnits(UnitID)
	if self.Ereandorn.UnitID == UnitID then
		self.Ereandorn.Available = false
		return true
	end
	return false
end

function EN:Death(UnitID)
	if self.Ereandorn.UnitID == UnitID then
		self.Ereandorn.Dead = true
		return true
	end
	return false
end

function EN:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ereandorn.Name then
				if not self.Ereandorn.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ereandorn.Casting = false
					self.Ereandorn.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ereandorn.Name, 0, 100)
					self.Phase = 1
				end
				self.Ereandorn.UnitID = unitID
				self.Ereandorn.Available = true
				return self.Ereandorn
			end
		end
	end
end

function EN:Reset()
	self.EncounterRunning = false
	self.Ereandorn.Available = false
	self.Ereandorn.UnitID = nil
	self.Ereandorn.CastBar:Remove()
	self.Ereandorn.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function EN:Timer()	
end

function EN.Ereandorn:SetTimers(bool)	
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

function EN.Ereandorn:SetAlerts(bool)
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

function EN:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Ereandorn, self.Enabled)
end

function EN:Start()
	-- Alerts
	self.Ereandorn.AlertsRef.Combustion = KBM.Alert:Create(self.Lang.Ability.Combustion[KBM.Lang], nil, true, false, "red")
	self.Ereandorn.AlertsRef.Growth = KBM.Alert:Create(self.Lang.Ability.Growth[KBM.Lang], 8, true, true, "red")
	self.Ereandorn.AlertsRef.Eruption = KBM.Alert:Create(self.Lang.Ability.Eruption[KBM.Lang], 5, true, false, "orange")
	KBM.Defaults.AlertObj.Assign(self.Ereandorn)
	
	-- Create Mechanic Spies
	self.Ereandorn.MechRef.Combustion = KBM.MechSpy:Add(self.Lang.Ability.Combustion[KBM.Lang], nil, "playerDebuff", self.Ereandorn)
	KBM.Defaults.MechObj.Assign(self.Ereandorn)
		
	-- Assign mechanics to Triggers
	self.Ereandorn.Triggers.Combustion = KBM.Trigger:Create(self.Lang.Ability.Combustion[KBM.Lang], "playerDebuff", self.Ereandorn)
	self.Ereandorn.Triggers.Combustion:AddAlert(self.Ereandorn.AlertsRef.Combustion, true)
	self.Ereandorn.Triggers.Combustion:AddSpy(self.Ereandorn.MechRef.Combustion)
	self.Ereandorn.Triggers.Growth = KBM.Trigger:Create(self.Lang.Notify.Growth[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Growth:AddAlert(self.Ereandorn.AlertsRef.Growth)
	self.Ereandorn.Triggers.Eruption = KBM.Trigger:Create(self.Lang.Notify.Eruption[KBM.Lang], "notify", self.Ereandorn)
	self.Ereandorn.Triggers.Eruption:AddAlert(self.Ereandorn.AlertsRef.Eruption)
	
	self.Ereandorn.CastBar = KBM.Castbar:Add(self, self.Ereandorn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end