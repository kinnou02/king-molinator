-- Isskal Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSLSLIDHIL_Settings = nil
chKBMSLSLIDHIL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local DH = KBM.BossMod["Intrepid Drowned Halls"]

local IL = {
	Directory = DH.Directory,
	File = "Isskal.lua",
	Enabled = true,
	Instance = DH.Name,
	InstanceObj = DH,
	Lang = {},
	ID = "IDHIsskal",
	Object = "IL",
}

IL.Isskal = {
	Mod = IL,
	Level = "??",
	Active = false,
	Name = "Isskal",
	Menu = {},
	Dead = false,
	Available = false,
	AlertsRef = {},
	TimersRef = {},
	UnitID = nil,
	UTID = "none",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Shard = KBM.Defaults.AlertObj.Create("yellow"),
			Whirlpool = KBM.Defaults.AlertObj.Create("blue"),
			Inner = KBM.Defaults.AlertObj.Create("cyan"),
			Middle = KBM.Defaults.AlertObj.Create("cyan"),
			Outer = KBM.Defaults.AlertObj.Create("cyan"),
		},
		TimersRef = {
			Enabled = true,
			WhirlpoolFirst = KBM.Defaults.TimerObj.Create("blue"),
			Whirlpool = KBM.Defaults.TimerObj.Create("blue"),
			WhirlpoolEnd = KBM.Defaults.TimerObj.Create("blue"),
			Reverse = KBM.Defaults.TimerObj.Create("blue"),
			Wave = KBM.Defaults.TimerObj.Create("cyan"),
			WaveFirst = KBM.Defaults.TimerObj.Create("cyan"),
			MiddleFirst = KBM.Defaults.TimerObj.Create("cyan"),
			MiddleSecond = KBM.Defaults.TimerObj.Create("cyan"),
			Middle = KBM.Defaults.TimerObj.Create("cyan"),
			OuterFirst = KBM.Defaults.TimerObj.Create("cyan"),
			Outer = KBM.Defaults.TimerObj.Create("cyan"),
			Inner = KBM.Defaults.TimerObj.Create("cyan"),
			DanceEnd = KBM.Defaults.TimerObj.Create("dark_green"),
		},
	},
}

KBM.RegisterMod(IL.ID, IL)

-- Main Unit Dictionary
IL.Lang.Unit = {}
IL.Lang.Unit.Isskal = KBM.Language:Add(IL.Isskal.Name)
IL.Lang.Unit.Isskal:SetGerman()
IL.Lang.Unit.Isskal:SetFrench()
IL.Lang.Unit.Isskal:SetRussian("Ишкар")
IL.Lang.Unit.Isskal:SetKorean("이스칼")

-- Ability Dictionary
IL.Lang.Ability = {}
IL.Lang.Ability.Shard = KBM.Language:Add("Ice Shard")
IL.Lang.Ability.Shard:SetGerman("Eissplitter")
IL.Lang.Ability.Shard:SetFrench("Pique de glace")
IL.Lang.Ability.Shard:SetRussian("Осколок льда")
IL.Lang.Ability.Shard:SetKorean("얼음 조각")
IL.Lang.Ability.Wave = KBM.Language:Add("Glacial Wave")
IL.Lang.Ability.Wave:SetGerman("Gletscherwelle")
IL.Lang.Ability.Wave:SetFrench("Vague glaciale")
IL.Lang.Ability.Wave:SetRussian("Ледяная волна")
IL.Lang.Ability.Wave:SetKorean("빙하 파도")

-- Mechanic Dictionary
IL.Lang.Mechanic = {}
IL.Lang.Mechanic.Whirlpool = KBM.Language:Add("Whirlpool")
IL.Lang.Mechanic.Whirlpool:SetGerman()
IL.Lang.Mechanic.Whirlpool:SetFrench("Tourbillon d'eau")
IL.Lang.Mechanic.Whirlpool:SetRussian("Вихрь смерти")
IL.Lang.Mechanic.Whirlpool:SetKorean("세탁기")
IL.Lang.Mechanic.Anti = KBM.Language:Add("Anti-Clockwise")
IL.Lang.Mechanic.Anti:SetGerman("Gegen Uhrzeigersinn")
IL.Lang.Mechanic.Anti:SetFrench("Anti-horaire") 
IL.Lang.Mechanic.Anti:SetRussian("Против часовой")
IL.Lang.Mechanic.Anti:SetKorean("반시계 방향")
IL.Lang.Mechanic.Clock = KBM.Language:Add("Clockwise")
IL.Lang.Mechanic.Clock:SetGerman("Im Uhrzeigersinn")
IL.Lang.Mechanic.Clock:SetFrench("Sens horaire")
IL.Lang.Mechanic.Clock:SetRussian("По часовой")
IL.Lang.Mechanic.Clock:SetKorean("시계방향")
IL.Lang.Mechanic.WhirlpoolEnd = KBM.Language:Add("Whirlpool ends")
IL.Lang.Mechanic.WhirlpoolEnd:SetGerman("Whirlpool beendet")
IL.Lang.Mechanic.WhirlpoolEnd:SetFrench("Tourbillon d'eau terminé")
IL.Lang.Mechanic.WhirlpoolEnd:SetRussian("Конец водоворота")
IL.Lang.Mechanic.WhirlpoolEnd:SetKorean("세탁기 끝")
IL.Lang.Mechanic.Reverse = KBM.Language:Add("Changing direction")
IL.Lang.Mechanic.Reverse:SetGerman("Richtung wechseln")
IL.Lang.Mechanic.Reverse:SetFrench("Changé de direction")
IL.Lang.Mechanic.Reverse:SetRussian("Смена направления")
IL.Lang.Mechanic.Reverse:SetKorean("방향 전환")

-- Mechanic Notify
IL.Lang.Notify = {}
IL.Lang.Notify.Whirlpool = KBM.Language:Add("Go with the current %- or die!")
IL.Lang.Notify.Whirlpool:SetGerman("Folgt dem Strom, oder sterbt!")
IL.Lang.Notify.Whirlpool:SetFrench("Suivez le courant... ou disparaissez !")
IL.Lang.Notify.Whirlpool:SetRussian("Плывите по течению")
IL.Lang.Notify.Whirlpool:SetKorean("흐름을 따르십시오. 그러지 않으면 죽게 됩니다!")
IL.Lang.Notify.Reverse = KBM.Language:Add("You're going the wrong way, fools!")
IL.Lang.Notify.Reverse:SetGerman("Ihr Narren geht in die falsche Richtung!")
IL.Lang.Notify.Reverse:SetFrench("Vous allez dans le mauvais direction, pauvres fous !")
IL.Lang.Notify.Reverse:SetRussian("Вы не туда идете, придурки!")
IL.Lang.Notify.Reverse:SetKorean("길을 잘못 들었다고, 바보야!")

-- Verbose Dictionary
IL.Lang.Verbose = {}
IL.Lang.Verbose.Middle = KBM.Language:Add("Middle")
IL.Lang.Verbose.Middle:SetGerman("Mitte")
IL.Lang.Verbose.Middle:SetFrench("Milieu")
IL.Lang.Verbose.Middle:SetRussian("Середина")
IL.Lang.Verbose.Middle:SetKorean("중간")
IL.Lang.Verbose.Inner = KBM.Language:Add("Inner")
IL.Lang.Verbose.Inner:SetGerman("Innen")
IL.Lang.Verbose.Inner:SetFrench("Intérieur")
IL.Lang.Verbose.Inner:SetRussian("К боссу")
IL.Lang.Verbose.Inner:SetKorean("안쪽")
IL.Lang.Verbose.Outer = KBM.Language:Add("Outer")
IL.Lang.Verbose.Outer:SetGerman("Aussen")
IL.Lang.Verbose.Outer:SetFrench("Extérieur")
IL.Lang.Verbose.Outer:SetRussian("Назад")
IL.Lang.Verbose.Outer:SetKorean("바깥쪽")
IL.Lang.Verbose.DanceEnd = KBM.Language:Add("Dance sequence ends")
IL.Lang.Verbose.DanceEnd:SetRussian("Бег закончен")
IL.Lang.Verbose.DanceEnd:SetFrench("Fin séquence de la dance")
IL.Lang.Verbose.DanceEnd:SetGerman("Tanz Sequenz beendet")
IL.Lang.Verbose.DanceEnd:SetKorean("똥물댄스 단계 끝")

-- Menu Dictionary
IL.Lang.Menu = {}
IL.Lang.Menu.WhirlpoolFirst = KBM.Language:Add("First "..IL.Lang.Mechanic.Whirlpool[KBM.Lang])
IL.Lang.Menu.WhirlpoolFirst:SetGerman("Erster "..IL.Lang.Mechanic.Whirlpool[KBM.Lang])
IL.Lang.Menu.WhirlpoolFirst:SetRussian("Первый "..IL.Lang.Mechanic.Whirlpool[KBM.Lang])
IL.Lang.Menu.WhirlpoolFirst:SetFrench("Premier Tourbillon d'eau")
IL.Lang.Menu.WhirlpoolFirst:SetKorean("첫번째 세탁기")

IL.Isskal.Name = IL.Lang.Unit.Isskal[KBM.Lang]
IL.Descript = IL.Isskal.Name

function IL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Isskal.Name] = self.Isskal,
	}
end

function IL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Isskal.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		AlertsRef = self.Isskal.Settings.AlertsRef,
		TimersRef = self.Isskal.Settings.TimersRef,
	}
	KBMSLSLIDHIL_Settings = self.Settings
	chKBMSLSLIDHIL_Settings = self.Settings
end

function IL:SwapSettings(bool)

	if bool then
		KBMSLSLIDHIL_Settings = self.Settings
		self.Settings = chKBMSLSLIDHIL_Settings
	else
		chKBMSLSLIDHIL_Settings = self.Settings
		self.Settings = KBMSLSLIDHIL_Settings
	end

end

function IL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLIDHIL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLIDHIL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLIDHIL_Settings = self.Settings
	else
		KBMSLSLIDHIL_Settings = self.Settings
	end	
end

function IL:SaveVars()	
	if KBM.Options.Character then
		chKBMSLSLIDHIL_Settings = self.Settings
	else
		KBMSLSLIDHIL_Settings = self.Settings
	end	
end

function IL:Castbar(units)
end

function IL:RemoveUnits(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Available = false
		return true
	end
	return false
end

function IL:Death(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Dead = true
		return true
	end
	return false
end

function IL:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Isskal.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Isskal.Dead = false
					self.Isskal.Casting = false
					self.Isskal.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Isskal.Name, 0, 100)
					self.Phase = 1
					KBM.MechTimer:AddStart(self.Isskal.TimersRef.WhirlpoolFirst)
					KBM.MechTimer:AddStart(self.Isskal.TimersRef.WaveFirst)
				end
				self.Isskal.UnitID = unitID
				self.Isskal.Available = true
				return self.Isskal
			end
		end
	end
end

function IL:Reset()
	self.EncounterRunning = false
	self.Isskal.Available = false
	self.Isskal.UnitID = nil
	self.Isskal.Dead = false
	self.Isskal.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function IL:Timer()
	
end

function IL:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Isskal, self.Enabled)
end

function IL:Start()
	-- Create Timers
	self.Isskal.TimersRef.WhirlpoolFirst = KBM.MechTimer:Add(self.Lang.Mechanic.Whirlpool[KBM.Lang], 33)
	self.Isskal.TimersRef.WhirlpoolFirst.MenuName = self.Lang.Menu.WhirlpoolFirst[KBM.Lang]
	self.Isskal.TimersRef.Whirlpool = KBM.MechTimer:Add(self.Lang.Mechanic.Whirlpool[KBM.Lang], 120)
	self.Isskal.TimersRef.Reverse = KBM.MechTimer:Add(self.Lang.Mechanic.Reverse[KBM.Lang], 14)
	self.Isskal.TimersRef.WhirlpoolEnd = KBM.MechTimer:Add(self.Lang.Mechanic.WhirlpoolEnd[KBM.Lang], 14)
	self.Isskal.TimersRef.MiddleFirst = KBM.MechTimer:Add(self.Lang.Verbose.Middle[KBM.Lang], 5)
	self.Isskal.TimersRef.MiddleFirst:NoMenu()
	self.Isskal.TimersRef.OuterFirst = KBM.MechTimer:Add(self.Lang.Verbose.Outer[KBM.Lang], 5)
	self.Isskal.TimersRef.OuterFirst:NoMenu()
	self.Isskal.TimersRef.MiddleFirst:AddTimer(self.Isskal.TimersRef.OuterFirst, 0)
	self.Isskal.TimersRef.MiddleSecond = KBM.MechTimer:Add(self.Lang.Verbose.Middle[KBM.Lang], 5)
	self.Isskal.TimersRef.MiddleSecond:NoMenu()
	self.Isskal.TimersRef.OuterFirst:AddTimer(self.Isskal.TimersRef.MiddleSecond, 0)
	self.Isskal.TimersRef.Inner = KBM.MechTimer:Add(self.Lang.Verbose.Inner[KBM.Lang], 5)
	self.Isskal.TimersRef.Inner:NoMenu()
	self.Isskal.TimersRef.MiddleSecond:AddTimer(self.Isskal.TimersRef.Inner, 0)
	self.Isskal.TimersRef.Middle = KBM.MechTimer:Add(self.Lang.Verbose.Middle[KBM.Lang], 5)
	self.Isskal.TimersRef.Middle:NoMenu()
	self.Isskal.TimersRef.Inner:AddTimer(self.Isskal.TimersRef.Middle, 0)
	self.Isskal.TimersRef.Outer = KBM.MechTimer:Add(self.Lang.Verbose.Outer[KBM.Lang], 5)
	self.Isskal.TimersRef.Outer:NoMenu()
	self.Isskal.TimersRef.Middle:AddTimer(self.Isskal.TimersRef.Outer, 0)
	self.Isskal.TimersRef.DanceEnd = KBM.MechTimer:Add(self.Lang.Verbose.DanceEnd[KBM.Lang], 5)
	self.Isskal.TimersRef.DanceEnd:NoMenu()
	self.Isskal.TimersRef.Outer:AddTimer(self.Isskal.TimersRef.DanceEnd, 0)
	self.Isskal.TimersRef.Wave = KBM.MechTimer:Add(self.Lang.Ability.Wave[KBM.Lang], 120, true)
	self.Isskal.TimersRef.Wave:NoMenu()
	self.Isskal.TimersRef.Wave:AddTimer(self.Isskal.TimersRef.MiddleFirst, 5)
	self.Isskal.TimersRef.WaveFirst = KBM.MechTimer:Add(self.Lang.Ability.Wave[KBM.Lang], 90)
	self.Isskal.TimersRef.WaveFirst:AddTimer(self.Isskal.TimersRef.Wave, 0)
	self.Isskal.TimersRef.WaveFirst:AddTimer(self.Isskal.TimersRef.MiddleFirst, 5)
	KBM.Defaults.TimerObj.Assign(self.Isskal)
	
	-- Create Alerts
	self.Isskal.AlertsRef.Shard = KBM.Alert:Create(self.Lang.Ability.Shard[KBM.Lang], nil, true, true, "yellow")
	self.Isskal.AlertsRef.Whirlpool = KBM.Alert:Create(self.Lang.Mechanic.Whirlpool[KBM.Lang], 2, true, false, "blue")
	self.Isskal.AlertsRef.Inner = KBM.Alert:Create(self.Lang.Verbose.Inner[KBM.Lang], 4, false, false, "cyan")
	self.Isskal.AlertsRef.Inner:NoMenu()
	self.Isskal.AlertsRef.Middle = KBM.Alert:Create(self.Lang.Verbose.Middle[KBM.Lang], 4, false, false, "cyan")
	self.Isskal.AlertsRef.Middle:NoMenu()
	self.Isskal.AlertsRef.Outer = KBM.Alert:Create(self.Lang.Verbose.Outer[KBM.Lang], 4, false, false, "cyan")
	self.Isskal.AlertsRef.Outer:NoMenu()
	KBM.Defaults.AlertObj.Assign(self.Isskal)
	
	-- Assign Alerts to Dance timers
	self.Isskal.TimersRef.MiddleFirst:AddAlert(self.Isskal.AlertsRef.Middle, 0)
	self.Isskal.TimersRef.MiddleSecond:AddAlert(self.Isskal.AlertsRef.Middle, 0)
	self.Isskal.TimersRef.Middle:AddAlert(self.Isskal.AlertsRef.Middle, 0)
	self.Isskal.TimersRef.OuterFirst:AddAlert(self.Isskal.AlertsRef.Outer, 0)
	self.Isskal.TimersRef.Outer:AddAlert(self.Isskal.AlertsRef.Outer, 0)
	self.Isskal.TimersRef.Inner:AddAlert(self.Isskal.AlertsRef.Inner, 0)

	-- Assign Timers and Alerts to triggers.
	self.Isskal.Triggers.Shard = KBM.Trigger:Create(self.Lang.Ability.Shard[KBM.Lang], "cast", self.Isskal)
	self.Isskal.Triggers.Shard:AddAlert(self.Isskal.AlertsRef.Shard)
	self.Isskal.Triggers.ShardInt = KBM.Trigger:Create(self.Lang.Ability.Shard[KBM.Lang], "interrupt", self.Isskal)
	self.Isskal.Triggers.ShardInt:AddStop(self.Isskal.AlertsRef.Shard)
	self.Isskal.Triggers.Whirlpool = KBM.Trigger:Create(self.Lang.Notify.Whirlpool[KBM.Lang], "notify", self.Isskal)
	self.Isskal.Triggers.Whirlpool:AddAlert(self.Isskal.AlertsRef.Whirlpool)
	self.Isskal.Triggers.Whirlpool:AddTimer(self.Isskal.TimersRef.Reverse)
	self.Isskal.Triggers.Whirlpool:AddTimer(self.Isskal.TimersRef.Whirlpool)
	self.Isskal.Triggers.WhirlpoolEnd = KBM.Trigger:Create(self.Lang.Notify.Reverse[KBM.Lang], "notify", self.Isskal)
	self.Isskal.Triggers.WhirlpoolEnd:AddTimer(self.Isskal.TimersRef.WhirlpoolEnd)
		
	self.Isskal.CastBar = KBM.Castbar:Add(self, self.Isskal, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end