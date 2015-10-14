-- Guurloth Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMNTIGPGH_Settings = nil
chKBMNTIGPGH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IGP = KBM.BossMod["Intrepid Gilded Prophecy"]

local GH = {
	Directory = IGP.Directory,
	File = "Guurloth.lua",
	Enabled = true,
	Instance = IGP.Name,
	InstanceObj = IGP,
	Lang = {},
	ID = "IGPGuurloth",
	Object = "GH",
	Enrage = 6*60,
}

GH.Guurloth = {
	Mod = GH,
	Level = "??",
	Active = false,
	Name = "Guurloth",
	NameShort = "Guurloth",
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Menu = {},
	UTID = "U17EA527730B0A540",
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			OrbFirst = KBM.Defaults.TimerObj.Create("orange"),
			Orb = KBM.Defaults.TimerObj.Create("orange"),
			CallFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Call = KBM.Defaults.TimerObj.Create("purple"),
			Punish = KBM.Defaults.TimerObj.Create("red"),
			Geyser = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			OrbWarn = KBM.Defaults.AlertObj.Create("orange"),
			Orb = KBM.Defaults.AlertObj.Create("orange"),
			Rumbling = KBM.Defaults.AlertObj.Create("blue"),
			RumblingWarn = KBM.Defaults.AlertObj.Create("blue"),
			Call = KBM.Defaults.AlertObj.Create("purple"),
			Boulder = KBM.Defaults.AlertObj.Create("yellow"),
			Toil = KBM.Defaults.AlertObj.Create("dark_green"),
			ToilWarn = KBM.Defaults.AlertObj.Create("dark_green"),
			Punish = KBM.Defaults.AlertObj.Create("red"),
			Geyser = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Punish = KBM.Defaults.MechObj.Create("red"),
		},
	},
}

KBM.RegisterMod(GH.ID, GH)

-- Main Unit Dictionary
GH.Lang.Unit = {}
GH.Lang.Unit.Guurloth = KBM.Language:Add(GH.Guurloth.Name)
GH.Lang.Unit.Guurloth:SetGerman()
GH.Lang.Unit.Guurloth:SetFrench()
GH.Lang.Unit.Guurloth:SetRussian("Гуурлот")
GH.Lang.Unit.Guurloth:SetKorean("구를로스")
GH.Guurloth.Name = GH.Lang.Unit.Guurloth[KBM.Lang]

-- Ability Dictionary
GH.Lang.Ability = {}
GH.Lang.Ability.Orb = KBM.Language:Add("Orb of Searing Power")
GH.Lang.Ability.Orb:SetGerman("Kugel der sengenden Macht")
GH.Lang.Ability.Orb:SetFrench("Orbe de puissance brûlante")
GH.Lang.Ability.Orb:SetRussian("Сфера жгучей мощи")
GH.Lang.Ability.Orb:SetKorean("화염 누적의 보주")
GH.Lang.Ability.Rumbling = KBM.Language:Add("Rumbling Earth")
GH.Lang.Ability.Rumbling:SetGerman("Grollende Erde")
GH.Lang.Ability.Rumbling:SetFrench("Terre grondante")
GH.Lang.Ability.Rumbling:SetRussian("Гремящая земля")
GH.Lang.Ability.Rumbling:SetKorean("요동치는 대지")
GH.Lang.Ability.Call = KBM.Language:Add("Guurloth's Call")
GH.Lang.Ability.Call:SetGerman("Guurloths Ruf")
GH.Lang.Ability.Call:SetFrench("Appel de Guurloth")
GH.Lang.Ability.Call:SetRussian("Зов Гуурлота")
GH.Lang.Ability.Call:SetKorean("구를로스의 부름")
GH.Lang.Ability.Boulder = KBM.Language:Add("Boulder of Destruction")
GH.Lang.Ability.Boulder:SetGerman("Fels der Zerstörung")
GH.Lang.Ability.Boulder:SetFrench("Rocher destructeur")
GH.Lang.Ability.Boulder:SetRussian("Разрушительный булыжник")
GH.Lang.Ability.Boulder:SetKorean("파괴의 거석")
GH.Lang.Ability.Toil = KBM.Language:Add("Earthen Toil")
GH.Lang.Ability.Toil:SetGerman("Irdene Mühe")
GH.Lang.Ability.Toil:SetFrench("Travail de la terre")
GH.Lang.Ability.Toil:SetRussian("Землянистая пошлина")
GH.Lang.Ability.Toil:SetKorean("대지의 수고")
GH.Lang.Ability.Geyser = KBM.Language:Add("Earthen Geyser")
GH.Lang.Ability.Geyser:SetGerman("Erdengeysir")
GH.Lang.Ability.Geyser:SetFrench("Geyser de Terre")
GH.Lang.Ability.Geyser:SetRussian("Грязевой гейзер")
GH.Lang.Ability.Geyser:SetKorean("대지의 간헐천")

-- Debuff Dictionary
GH.Lang.Debuff = {}
GH.Lang.Debuff.Punish = KBM.Language:Add("Earthen Punishment")
GH.Lang.Debuff.Punish:SetGerman("Erdenbestrafung")
GH.Lang.Debuff.Punish:SetFrench("Punition de Terre")
GH.Lang.Debuff.Punish:SetRussian("Земляное наказание")
GH.Lang.Debuff.Punish:SetKorean("대지의 형벌")

-- Verbose Dictionary
GH.Lang.Verbose = {}
GH.Lang.Verbose.Orb = KBM.Language:Add("Look away now!")
GH.Lang.Verbose.Orb:SetGerman("WEGSCHAUEN")
GH.Lang.Verbose.Orb:SetFrench("Regardez ailleurs maintenant!")
GH.Lang.Verbose.Orb:SetRussian("Отвернитесь!")
GH.Lang.Verbose.Orb:SetKorean("보스 뒤도세요!")
GH.Lang.Verbose.Rumbling = KBM.Language:Add("Jump!")
GH.Lang.Verbose.Rumbling:SetGerman("SPRINGEN")
GH.Lang.Verbose.Rumbling:SetFrench("Sauter!")
GH.Lang.Verbose.Rumbling:SetRussian("Прыгайте!")
GH.Lang.Verbose.Rumbling:SetKorean("점프!")
GH.Lang.Verbose.Call = KBM.Language:Add("Adds Spawn")
GH.Lang.Verbose.Call:SetGerman("ADD kommt")
GH.Lang.Verbose.Call:SetFrench("Pop de l'add 	")
GH.Lang.Verbose.Call:SetFrench("Pop de l'add")
GH.Lang.Verbose.Call:SetRussian("Призывается адд!")
GH.Lang.Verbose.Call:SetKorean("쫄 소환")
GH.Lang.Verbose.Toil = KBM.Language:Add("Run around!")
GH.Lang.Verbose.Toil:SetGerman("LAUFEN")
GH.Lang.Verbose.Toil:SetFrench("Courir autour!")
GH.Lang.Verbose.Toil:SetRussian("Бегайте!")
GH.Lang.Verbose.Toil:SetKorean("달리세요!")
GH.Lang.Verbose.Punish = KBM.Language:Add("Stop!")
GH.Lang.Verbose.Punish:SetGerman("NICHTS MACHEN")
GH.Lang.Verbose.Punish:SetFrench("Arrêter!")
GH.Lang.Verbose.Punish:SetRussian("Ничего не делайте!")
GH.Lang.Verbose.Punish:SetKorean("아무것도 하지 마!")

-- Menu Dictionary
GH.Lang.Menu = {}
GH.Lang.Menu.Orb = KBM.Language:Add("First "..GH.Lang.Ability.Orb[KBM.Lang])
GH.Lang.Menu.Orb:SetGerman("Erste "..GH.Lang.Ability.Orb[KBM.Lang])
GH.Lang.Menu.Orb:SetFrench("Première Orbe de puissance brûlante")
GH.Lang.Menu.Orb:SetRussian("Первая "..GH.Lang.Ability.Orb[KBM.Lang])
GH.Lang.Menu.Orb:SetKorean("첫 능력의 보주 시간")
GH.Lang.Menu.OrbDuration = KBM.Language:Add(GH.Lang.Ability.Orb[KBM.Lang].." duration")
GH.Lang.Menu.OrbDuration:SetGerman(GH.Lang.Ability.Orb[KBM.Lang].." Dauer")
GH.Lang.Menu.OrbDuration:SetFrench("Orbe de puissance brûlante durée")
GH.Lang.Menu.OrbDuration:SetRussian("Длительность "..GH.Lang.Ability.Orb[KBM.Lang])
GH.Lang.Menu.OrbDuration:SetKorean("능력의 보주 지속시간")
GH.Lang.Menu.Rumbling = KBM.Language:Add(GH.Lang.Ability.Rumbling[KBM.Lang].." duration")
GH.Lang.Menu.Rumbling:SetGerman(GH.Lang.Ability.Rumbling[KBM.Lang].." Dauer")
GH.Lang.Menu.Rumbling:SetFrench("Terre grondante durée")
GH.Lang.Menu.Rumbling:SetRussian("Длительность "..GH.Lang.Ability.Rumbling[KBM.Lang])
GH.Lang.Menu.Rumbling:SetKorean("구르는 대지 지속시간")
GH.Lang.Menu.CallFirst = KBM.Language:Add("First "..GH.Lang.Ability.Call[KBM.Lang])
GH.Lang.Menu.CallFirst:SetGerman("Erster "..GH.Lang.Ability.Call[KBM.Lang])
GH.Lang.Menu.CallFirst:SetFrench("Premier Appel de Guurloth")
GH.Lang.Menu.CallFirst:SetRussian("Первый "..GH.Lang.Ability.Call[KBM.Lang])
GH.Lang.Menu.CallFirst:SetKorean("첫 구를로스의 부름")
GH.Lang.Menu.Toil = KBM.Language:Add(GH.Lang.Ability.Toil[KBM.Lang].." duration")
GH.Lang.Menu.Toil:SetGerman(GH.Lang.Ability.Toil[KBM.Lang].." Dauer")
GH.Lang.Menu.Toil:SetFrench("Travail de la terre durée")
GH.Lang.Menu.Toil:SetRussian("Длительность "..GH.Lang.Ability.Toil[KBM.Lang])
GH.Lang.Menu.Toil:SetKorean("대지의 토양 지속시간")

GH.Descript = GH.Guurloth.Name

function GH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Guurloth.Name] = self.Guurloth,
	}
end

function GH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Guurloth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Guurloth.Settings.AlertsRef,
		TimersRef = self.Guurloth.Settings.TimersRef,
		MechRef = self.Guurloth.Settings.MechRef,
	}
	KBMNTIGPGH_Settings = self.Settings
	chKBMNTIGPGH_Settings = self.Settings
end

function GH:SwapSettings(bool)

	if bool then
		KBMNTIGPGH_Settings = self.Settings
		self.Settings = chKBMNTIGPGH_Settings
	else
		chKBMNTIGPGH_Settings = self.Settings
		self.Settings = KBMNTIGPGH_Settings
	end

end

function GH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTIGPGH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTIGPGH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTIGPGH_Settings = self.Settings
	else
		KBMNTIGPGH_Settings = self.Settings
	end	
end

function GH:SaveVars()	
	if KBM.Options.Character then
		chKBMNTIGPGH_Settings = self.Settings
	else
		KBMNTIGPGH_Settings = self.Settings
	end	
end

function GH:Castbar(units)
end

function GH:RemoveUnits(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Available = false
		return true
	end
	return false
end

function GH:Death(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Dead = true
		return true
	end
	return false
end

function GH:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Guurloth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Guurloth.Dead = false
					self.Guurloth.Casting = false
					self.Guurloth.CastBar:Create(unitID)
					KBM.MechTimer:AddStart(self.Guurloth.TimersRef.OrbFirst)
					KBM.MechTimer:AddStart(self.Guurloth.TimersRef.CallFirst)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Guurloth.Name, 0, 100)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				end
				self.Guurloth.UnitID = unitID
				self.Guurloth.Available = true
				return self.Guurloth
			end
		end
	end
end

function GH:Reset()
	self.EncounterRunning = false
	self.Guurloth.Available = false
	self.Guurloth.UnitID = nil
	self.Guurloth.Dead = false
	self.Guurloth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function GH:Timer()
	
end

function GH:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Guurloth, self.Enabled)
end

function GH:Start()
	-- Create Timers
	self.Guurloth.TimersRef.OrbFirst = KBM.MechTimer:Add(self.Lang.Ability.Orb[KBM.Lang], 40)
	self.Guurloth.TimersRef.OrbFirst.MenuName = self.Lang.Menu.Orb[KBM.Lang]
	self.Guurloth.TimersRef.Orb = KBM.MechTimer:Add(self.Lang.Ability.Orb[KBM.Lang], 125)
	self.Guurloth.TimersRef.CallFirst = KBM.MechTimer:Add(self.Lang.Verbose.Call[KBM.Lang], 25)
	self.Guurloth.TimersRef.CallFirst.MenuName = self.Lang.Menu.CallFirst[KBM.Lang]
	self.Guurloth.TimersRef.Call = KBM.MechTimer:Add(self.Lang.Verbose.Call[KBM.Lang], 136)
	self.Guurloth.TimersRef.Call.MenuName = self.Lang.Ability.Call[KBM.Lang]
	self.Guurloth.TimersRef.Punish = KBM.MechTimer:Add(self.Lang.Debuff.Punish[KBM.Lang], 60)
	self.Guurloth.TimersRef.Geyser = KBM.MechTimer:Add(self.Lang.Ability.Geyser[KBM.Lang], 27)
	KBM.Defaults.TimerObj.Assign(self.Guurloth)
	
	-- Create Alerts
	self.Guurloth.AlertsRef.OrbWarn = KBM.Alert:Create(self.Lang.Verbose.Orb[KBM.Lang], nil, false, true, "orange")
	self.Guurloth.AlertsRef.OrbWarn.MenuName = self.Lang.Ability.Orb[KBM.Lang]
	self.Guurloth.AlertsRef.Orb = KBM.Alert:Create(self.Lang.Verbose.Orb[KBM.Lang], nil, true, true, "orange")
	self.Guurloth.AlertsRef.Orb.MenuName = self.Lang.Menu.OrbDuration[KBM.Lang]
	self.Guurloth.AlertsRef.RumblingWarn = KBM.Alert:Create(self.Lang.Verbose.Rumbling[KBM.Lang], nil, false, true, "blue")
	self.Guurloth.AlertsRef.RumblingWarn.MenuName = self.Lang.Ability.Rumbling[KBM.Lang]
	self.Guurloth.AlertsRef.Rumbling = KBM.Alert:Create(self.Lang.Verbose.Rumbling[KBM.Lang], nil, true, true, "blue")
	self.Guurloth.AlertsRef.Rumbling.MenuName = self.Lang.Menu.Rumbling[KBM.Lang]
	self.Guurloth.AlertsRef.Call = KBM.Alert:Create(self.Lang.Ability.Call[KBM.Lang], nil, true, true, "purple")
	self.Guurloth.AlertsRef.Boulder = KBM.Alert:Create(self.Lang.Ability.Boulder[KBM.Lang], nil, true, true, "yellow")
	self.Guurloth.AlertsRef.ToilWarn = KBM.Alert:Create(self.Lang.Verbose.Toil[KBM.Lang], nil, false, true, "dark_green")
	self.Guurloth.AlertsRef.ToilWarn.MenuName = self.Lang.Ability.Toil[KBM.Lang]
	self.Guurloth.AlertsRef.Toil = KBM.Alert:Create(self.Lang.Verbose.Toil[KBM.Lang], nil, true, true, "dark_green")
	self.Guurloth.AlertsRef.Toil.MenuName = self.Lang.Menu.Toil[KBM.Lang]
	self.Guurloth.AlertsRef.Punish = KBM.Alert:Create(self.Lang.Verbose.Punish[KBM.Lang], nil, true, true, "red")
	self.Guurloth.AlertsRef.Punish.MenuName = self.Lang.Debuff.Punish[KBM.Lang]
	self.Guurloth.AlertsRef.Punish:Important()
	self.Guurloth.AlertsRef.Geyser = KBM.Alert:Create(self.Lang.Ability.Geyser[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Guurloth)
	
	-- Create Mechanic Spies
	self.Guurloth.MechRef.Punish = KBM.MechSpy:Add(self.Lang.Debuff.Punish[KBM.Lang], nil, "playerDebuff", self.Guurloth)
	KBM.Defaults.MechObj.Assign(self.Guurloth)
	
	-- Assign Timers and Alerts to Triggers
	self.Guurloth.Triggers.OrbWarn = KBM.Trigger:Create(self.Lang.Ability.Orb[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.OrbWarn:AddAlert(self.Guurloth.AlertsRef.OrbWarn)
	self.Guurloth.Triggers.OrbWarn:AddTimer(self.Guurloth.TimersRef.Orb)
	self.Guurloth.Triggers.Orb = KBM.Trigger:Create(self.Lang.Ability.Orb[KBM.Lang], "channel", self.Guurloth)
	self.Guurloth.Triggers.Orb:AddAlert(self.Guurloth.AlertsRef.Orb)
	self.Guurloth.Triggers.RumblingWarn = KBM.Trigger:Create(self.Lang.Ability.Rumbling[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.RumblingWarn:AddAlert(self.Guurloth.AlertsRef.RumblingWarn)
	self.Guurloth.Triggers.Rumbling = KBM.Trigger:Create(self.Lang.Ability.Rumbling[KBM.Lang], "channel", self.Guurloth)
	self.Guurloth.Triggers.Rumbling:AddAlert(self.Guurloth.AlertsRef.Rumbling)
	self.Guurloth.Triggers.Call = KBM.Trigger:Create(self.Lang.Ability.Call[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.Call:AddAlert(self.Guurloth.AlertsRef.Call)
	self.Guurloth.Triggers.Call:AddTimer(self.Guurloth.TimersRef.Call)
	self.Guurloth.Triggers.Boulder = KBM.Trigger:Create(self.Lang.Ability.Boulder[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.Boulder:AddAlert(self.Guurloth.AlertsRef.Boulder)
	self.Guurloth.Triggers.ToilWarn = KBM.Trigger:Create(self.Lang.Ability.Toil[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.ToilWarn:AddAlert(self.Guurloth.AlertsRef.ToilWarn)
	self.Guurloth.Triggers.Toil = KBM.Trigger:Create(self.Lang.Ability.Toil[KBM.Lang], "channel", self.Guurloth)
	self.Guurloth.Triggers.Toil:AddAlert(self.Guurloth.AlertsRef.Toil)
	self.Guurloth.Triggers.Punish = KBM.Trigger:Create(self.Lang.Debuff.Punish[KBM.Lang], "playerBuff", self.Guurloth)
	self.Guurloth.Triggers.Punish:AddAlert(self.Guurloth.AlertsRef.Punish, true)
	self.Guurloth.Triggers.Punish:AddTimer(self.Guurloth.TimersRef.Punish)
	self.Guurloth.Triggers.Punish:AddSpy(self.Guurloth.MechRef.Punish)
	self.Guurloth.Triggers.Geyser = KBM.Trigger:Create(self.Lang.Ability.Geyser[KBM.Lang], "cast", self.Guurloth)
	self.Guurloth.Triggers.Geyser:AddAlert(self.Guurloth.AlertsRef.Geyser)
	self.Guurloth.Triggers.Geyser:AddTimer(self.Guurloth.TimersRef.Geyser)
	
	self.Guurloth.CastBar = KBM.Castbar:Add(self, self.Guurloth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end