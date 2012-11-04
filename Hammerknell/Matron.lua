-- Matron Zamira Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMZ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local MZ = {
	Directory = HK.Directory,
	File = "Matron.lua",
	Enabled = true,
	Instance = HK.Name,
	InstanceObj = HK,
	HasPhases = true,
	PhaseObj = nil,
	Timers = {},
	Lang = {},
	ID = "Matron",
	Object = "MZ",
}

MZ.Matron = {
	Mod = MZ,
	Level = "??",
	Active = false,
	Name = "Matron Zamira",
	NameShort = "Zamira",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UTID = "U6680B19865BA08FD",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Concussion = KBM.Defaults.TimerObj.Create("red"),
			Mark = KBM.Defaults.TimerObj.Create("purple"),
			Shadow = KBM.Defaults.TimerObj.Create("red"),
			Blast = KBM.Defaults.TimerObj.Create("yellow"),
			Ichor = KBM.Defaults.TimerObj.Create("cyan"),
			Adds = KBM.Defaults.TimerObj.Create("dark_green"),
			Spiritual = KBM.Defaults.TimerObj.Create("blue"),
		},
		AlertsRef = {
			Enabled = true,
			Concussion = KBM.Defaults.AlertObj.Create("red"),
			Blast = KBM.Defaults.AlertObj.Create("yellow"),
			Mark = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Mark = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(MZ.ID, MZ)

-- Main Units
MZ.Lang.Unit = {}
MZ.Lang.Unit.Matron = KBM.Language:Add(MZ.Matron.Name)
MZ.Lang.Unit.Matron:SetGerman("Matrone Zamira")
MZ.Lang.Unit.Matron:SetFrench("Matrone Zamira")
MZ.Lang.Unit.Matron:SetRussian("Старуха Замира")
MZ.Lang.Unit.Matron:SetKorean("메이트런 자미라")
MZ.Lang.Unit.MatronShort = KBM.Language:Add("Zamira")
MZ.Lang.Unit.MatronShort:SetGerman("Zamira")
MZ.Lang.Unit.MatronShort:SetFrench("Zamira")
MZ.Lang.Unit.MatronShort:SetRussian("Замира")
MZ.Lang.Unit.MatronShort:SetKorean("자미라")

-- Ability Dictionary
MZ.Lang.Ability = {}
MZ.Lang.Ability.Concussion = KBM.Language:Add("Dark Concussion")
MZ.Lang.Ability.Concussion:SetGerman("Dunkle Erschütterung")
MZ.Lang.Ability.Concussion:SetFrench("Concussion sombre")
MZ.Lang.Ability.Concussion:SetRussian("Темное сотрясение")
MZ.Lang.Ability.Concussion:SetKorean("암흑 진동")
MZ.Lang.Ability.Blast = KBM.Language:Add("Hideous Blast")
MZ.Lang.Ability.Blast:SetGerman("Schrecklicher Schlag")
MZ.Lang.Ability.Blast:SetFrench("Explosion atroce")
MZ.Lang.Ability.Blast:SetRussian("Мерзейший взрыв")
MZ.Lang.Ability.Blast:SetGerman("소름 끼치는 폭발")
MZ.Lang.Ability.Mark = KBM.Language:Add("Mark of Oblivion")
MZ.Lang.Ability.Mark:SetGerman("Zeichen der Vergessenheit")
MZ.Lang.Ability.Mark:SetFrench("Marque de l'oubli")
MZ.Lang.Ability.Mark:SetRussian("Знак забвения")
MZ.Lang.Ability.Mark:SetKorean("망각의 표식")
MZ.Lang.Ability.Shadow = KBM.Language:Add("Shadow Strike")
MZ.Lang.Ability.Shadow:SetGerman("Schattenschlag")
MZ.Lang.Ability.Shadow:SetFrench("Barrage de l'ombre")
MZ.Lang.Ability.Shadow:SetRussian("Поражение тенью")
MZ.Lang.Ability.Shadow:SetKorean("그림자 일격")
MZ.Lang.Ability.Ichor = KBM.Language:Add("Revolting Ichor")
MZ.Lang.Ability.Ichor:SetGerman("Abscheulicher Eiter")
MZ.Lang.Ability.Ichor:SetRussian("Омерзительный гной")
MZ.Lang.Ability.Ichor:SetFrench("Ichor répugnant")
MZ.Lang.Ability.Ichor:SetKorean("몸서리나는 영액")
-- Notify Dictionary
MZ.Lang.Notify = {}
MZ.Lang.Notify.Mark = KBM.Language:Add("Matron Zamira places the Mark of Oblivion upon (%a*).")
MZ.Lang.Notify.Mark:SetGerman("Matrone Zamira belegt (%a*) mit dem Zeichen der Vergessenheit.")
MZ.Lang.Notify.Mark:SetFrench("Matrone Zamira place la Marque de l'oubli sur (%a*).")
MZ.Lang.Notify.Mark:SetKorean("메이트런 자미라이(가) (%a*)에게 망각의 표식을 남깁니다.")

-- Debuff Dictionary
MZ.Lang.Debuff = {}
MZ.Lang.Debuff.Curse = KBM.Language:Add("Matron's Curse")
MZ.Lang.Debuff.Curse:SetGerman("Fluch der Matrone")
MZ.Lang.Debuff.Curse:SetFrench("Mal\195\169diction de la matrone")
MZ.Lang.Debuff.Curse:SetRussian("Проклятие старухи")
MZ.Lang.Debuff.Curse:SetKorean("메이트런의 저주")
MZ.Lang.Debuff.Spiritual = KBM.Language:Add("Spiritual Exhaustion")
MZ.Lang.Debuff.Spiritual:SetGerman("Spirituelle Erschöpfung")
MZ.Lang.Debuff.Spiritual:SetRussian("Духовное истощение")
MZ.Lang.Debuff.Spiritual:SetFrench("Esprit cauchemardesque")
MZ.Lang.Debuff.Spiritual:SetKorean("영혼 탈진")

-- Verbose Dictionary
MZ.Lang.Verbose = {}
MZ.Lang.Verbose.Adds = KBM.Language:Add("Adds spawn")
MZ.Lang.Verbose.Adds:SetGerman("Adds spawnen")
MZ.Lang.Verbose.Adds:SetRussian("Призыв аддов")
MZ.Lang.Verbose.Adds:SetFrench("Pop des Adds")
MZ.Lang.Verbose.Adds:SetKorean("대량의 쫄들 출현")
MZ.Lang.Verbose.Spiritual = KBM.Language:Add(MZ.Lang.Debuff.Spiritual[KBM.Lang].." fades")
MZ.Lang.Verbose.Spiritual:SetGerman(MZ.Lang.Debuff.Spiritual[KBM.Lang].." ausgelaufen!")
MZ.Lang.Verbose.Spiritual:SetRussian(MZ.Lang.Debuff.Spiritual[KBM.Lang].." заканчивается")
MZ.Lang.Verbose.Spiritual:SetFrench(MZ.Lang.Debuff.Spiritual[KBM.Lang].." s'estompe")
MZ.Lang.Verbose.Spiritual:SetKorean("영혼탈진이 사라짐")

-- Define Translated Names
MZ.Matron.Name = MZ.Lang.Unit.Matron[KBM.Lang]
MZ.Matron.NameShort = MZ.Lang.Unit.MatronShort[KBM.Lang]
MZ.Descript = MZ.Matron.Name

function MZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Matron.Name] = self.Matron,
	}
end

function MZ:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = self.Matron.Settings.CastBar,
		TimersRef = self.Matron.Settings.TimersRef,
		AlertsRef = self.Matron.Settings.AlertsRef,
		MechRef = self.Matron.Settings.MechSpy,
	}
	KBMMZ_Settings = self.Settings
	chKBMMZ_Settings = self.Settings
	
end

function MZ:SwapSettings(bool)

	if bool then
		KBMMZ_Settings = self.Settings
		self.Settings = chKBMMZ_Settings
	else
		chKBMMZ_Settings = self.Settings
		self.Settings = KBMMZ_Settings
	end

end

function MZ:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMZ_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMMZ_Settings = self.Settings
	else
		KBMMZ_Settings = self.Settings
	end
	
end

function MZ:SaveVars()

	if KBM.Options.Character then
		chKBMMZ_Settings = self.Settings
	else
		KBMMZ_Settings = self.Settings
	end
	
end

function MZ:Castbar(units)
end

function MZ:RemoveUnits(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Available = false
		return true
	end
	return false
end

function MZ:Death(UnitID)
	if self.Matron.UnitID == UnitID then
		self.Matron.Dead = true
		return true
	end
	return false
end

function MZ.PhaseTwo()	
	MZ.Phase = 2
	MZ.PhaseObj.Objectives:Remove()
	MZ.PhaseObj:SetPhase(2)
	MZ.PhaseObj.Objectives:AddPercent(MZ.Matron.Name, 30, 40)	
end

function MZ.PhaseThree()
	MZ.Phase = 3
	MZ.PhaseObj.Objectives:Remove()
	MZ.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MZ.PhaseObj.Objectives:AddPercent(MZ.Matron.Name, 0, 30)	
end

function MZ:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Matron.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Matron.Dead = false
					self.Matron.Casting = false
					self.Matron.CastBar:Create(unitID)
					KBM.TankSwap:Start(MZ.Lang.Debuff.Curse[KBM.Lang], unitID)
					self.PhaseObj.Objectives:AddPercent(self.Matron.Name, 40, 100)
					self.PhaseObj:Start(self.StartTime)
				end
				self.Matron.UnitID = unitID
				self.Matron.Available = true
				return self.Matron
			end
		end
	end
end

function MZ:Reset()
	self.EncounterRunning = false
	self.Matron.Available = false
	self.Matron.UnitID = nil
	self.Matron.CastBar:Remove()
	self.PhaseObj:End(self.TimeElapsed)	
end

function MZ:Timer()	
end

function MZ:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Matron, self.Enabled)
end

function MZ:Start()		
	-- Create Timers
	self.Matron.TimersRef.Concussion = KBM.MechTimer:Add(self.Lang.Ability.Concussion[KBM.Lang], 13)
	self.Matron.TimersRef.Mark = KBM.MechTimer:Add(self.Lang.Ability.Mark[KBM.Lang], 24)
	self.Matron.TimersRef.Shadow = KBM.MechTimer:Add(self.Lang.Ability.Shadow[KBM.Lang], 11)
	self.Matron.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Ability.Blast[KBM.Lang], 8)
	self.Matron.TimersRef.Ichor = KBM.MechTimer:Add(self.Lang.Ability.Ichor[KBM.Lang], 5)
	self.Matron.TimersRef.Adds = KBM.MechTimer:Add(self.Lang.Verbose.Adds[KBM.Lang], 10)
	self.Matron.TimersRef.Spiritual = KBM.MechTimer:Add(self.Lang.Verbose.Spiritual[KBM.Lang], 60)
	
	-- Create Alerts
	self.Matron.AlertsRef.Concussion = KBM.Alert:Create(self.Lang.Ability.Concussion[KBM.Lang], 2, true, false, "red")
	self.Matron.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, false, true, "yellow")
	self.Matron.AlertsRef.Mark = KBM.Alert:Create(self.Lang.Ability.Mark[KBM.Lang], 4, false, true, "purple")

	-- Create Mechanic Spies
	self.Matron.MechRef.Mark = KBM.MechSpy:Add(self.Lang.Ability.Mark[KBM.Lang], 4, "mechanic", self.Matron)
	
	KBM.Defaults.TimerObj.Assign(self.Matron)
	KBM.Defaults.AlertObj.Assign(self.Matron)
	KBM.Defaults.MechObj.Assign(self.Matron)
	
	-- Assign Mechanics to Triggers
	self.Matron.Triggers.Concussion = KBM.Trigger:Create(self.Lang.Ability.Concussion[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Concussion:AddTimer(self.Matron.TimersRef.Concussion)
	self.Matron.Triggers.Concussion:AddAlert(self.Matron.AlertsRef.Concussion)
	self.Matron.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Blast:AddAlert(self.Matron.AlertsRef.Blast)
	self.Matron.Triggers.Blast:AddTimer(self.Matron.TimersRef.Blast)
	self.Matron.Triggers.BlastInt = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "interrupt", self.Matron)
	self.Matron.Triggers.BlastInt:AddStop(self.Matron.AlertsRef.Blast)
	self.Matron.Triggers.Ichor = KBM.Trigger:Create(self.Lang.Ability.Ichor[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Ichor:AddTimer(self.Matron.TimersRef.Ichor)
	self.Matron.Triggers.Mark = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "cast", self.Matron)
	self.Matron.Triggers.Mark:AddTimer(self.Matron.TimersRef.Mark)
	if self.Lang.Notify.Mark.Translated[KBM.Lang] then
		self.Matron.Triggers.MarkNotify = KBM.Trigger:Create(self.Lang.Notify.Mark[KBM.Lang], "notify", self.Matron)
		self.Matron.Triggers.MarkNotify:AddAlert(self.Matron.AlertsRef.Mark, true)
		self.Matron.Triggers.MarkNotify:AddSpy(self.Matron.MechRef.Mark)
	else
		self.Matron.Triggers.MarkDamage = KBM.Trigger:Create(self.Lang.Ability.Mark[KBM.Lang], "damage", self.Matron)
		self.Matron.Triggers.MarkDamage:AddAlert(self.Matron.AlertsRef.Mark, true)
		self.Matron.Triggers.MarkDamage:AddSpy(self.Matron.MechRef.Mark)
	end
	self.Matron.AlertsRef.Mark:Important()
	self.Matron.Triggers.Shadow = KBM.Trigger:Create(self.Lang.Ability.Shadow[KBM.Lang], "damage", self.Matron)
	self.Matron.Triggers.Shadow:AddTimer(self.Matron.TimersRef.Shadow)
	self.Matron.Triggers.PhaseTwo = KBM.Trigger:Create(40, "percent", self.Matron)
	self.Matron.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Matron.Triggers.PhaseThree = KBM.Trigger:Create(30, "percent", self.Matron)
	self.Matron.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Matron.Triggers.Spiritual = KBM.Trigger:Create(self.Lang.Debuff.Spiritual[KBM.Lang], "playerBuff", self.Matron)
	self.Matron.Triggers.Spiritual:AddTimer(self.Matron.TimersRef.Adds)
	self.Matron.Triggers.Spiritual:AddTimer(self.Matron.TimersRef.Spiritual)
	
	-- Assign Castbar object
	self.Matron.CastBar = KBM.CastBar:Add(self, self.Matron, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()		
end