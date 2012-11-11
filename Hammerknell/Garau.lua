-- Inquisitor Garau Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGU_Settings = nil
chKBMGU_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local GU = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Garau.lua",
	Instance = HK.Name,
	InstanceObj = HK,
	Lang = {},
	Enrage = 60 * 12,
	ID = "Garau",
	Object = "GU",
}

GU.Garau = {
	Mod = GU,
	Level = "??",
	Active = false,
	Name = "Inquisitor Garau",
	NameShort = "Garau",
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UTID = "U504BFBBC441D3B2C",
	UnitID = nil,
	Descript = "Inquisitor Garau",
	TimeOut = 3,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Blood = KBM.Defaults.TimerObj.Create("red"),
			Porter = KBM.Defaults.TimerObj.Create("purple"),
			Essence = KBM.Defaults.TimerObj.Create("orange"),
			Crawler = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Porter = KBM.Defaults.AlertObj.Create("purple"),
			Shield = KBM.Defaults.AlertObj.Create("blue"),
		},
	},
}

KBM.RegisterMod(GU.ID, GU)

-- Main Unit Dictionary
GU.Lang.Unit = {}
GU.Lang.Unit.Garau = KBM.Language:Add(GU.Garau.Name)
GU.Lang.Unit.Garau:SetGerman("Inquisitor Garau")
GU.Lang.Unit.Garau:SetFrench("Inquisiteur Garau")
GU.Lang.Unit.Garau:SetRussian("Инквизитор Гарау")
GU.Lang.Unit.Garau:SetKorean("인퀴지터 가라우")
GU.Garau.Name = GU.Lang.Unit.Garau[KBM.Lang]
GU.Descript = GU.Garau.Name
GU.Lang.Unit.GarauShort = KBM.Language:Add("Garau")
GU.Lang.Unit.GarauShort:SetGerman("Garau")
GU.Lang.Unit.GarauShort:SetFrench("Garau")
GU.Lang.Unit.GarauShort:SetRussian("Гарау")
GU.Lang.Unit.GarauShort:SetKorean("가라우")
GU.Garau.NameShort = GU.Lang.Unit.GarauShort[KBM.Lang]
-- Addtional Unit Dictionary
GU.Lang.Unit.Porter = KBM.Language:Add("Arcane Porter")
GU.Lang.Unit.Porter:SetGerman("Arkane Torwache")
GU.Lang.Unit.Porter:SetRussian("Привратник Магической Руки")
GU.Lang.Unit.Porter:SetFrench("Arcaniste Noirflux")
GU.Lang.Unit.Porter:SetKorean("비전 짐꾼")
GU.Lang.Unit.Crawler = KBM.Language:Add("Infused Crawler")
GU.Lang.Unit.Crawler:SetGerman("Durchdrungener Kriecher")
GU.Lang.Unit.Crawler:SetRussian("Наполненный ползун")
GU.Lang.Unit.Crawler:SetFrench("Rampant suintant")
GU.Lang.Unit.Crawler:SetKorean("마력 깃든 크롤러")

-- Ability Dictionary
GU.Lang.Ability = {}
GU.Lang.Ability.Arcane = KBM.Language:Add("Arcane Essence")
GU.Lang.Ability.Arcane:SetFrench("Syphon d'essence")
GU.Lang.Ability.Arcane:SetGerman("Essenzabsauger")
GU.Lang.Ability.Arcane:SetRussian("Насос сущности")
GU.Lang.Ability.Arcane:SetKorean("비전 정수")
GU.Lang.Ability.Blood = KBM.Language:Add("Bloodtide")
GU.Lang.Ability.Blood:SetGerman("Blutflut")
GU.Lang.Ability.Blood:SetRussian("Кровавая волна")
GU.Lang.Ability.Blood:SetFrench("Raz-de-sang")
GU.Lang.Ability.Blood:SetKorean("핏빛물결")

-- Buff Dictionary
GU.Lang.Buff = {}
GU.Lang.Buff.Shield = KBM.Language:Add("Glacial Shield")
GU.Lang.Buff.Shield:SetGerman("Gletscherschild")
GU.Lang.Buff.Shield:SetRussian("Ледниковый щит")
GU.Lang.Buff.Shield:SetFrench("Bouclier glacial")
GU.Lang.Buff.Shield:SetKorean("빙하 보호막")

-- Speak Dictionary
GU.Lang.Say = {}
GU.Lang.Say.Power = KBM.Language:Add("Power my creation!")
GU.Lang.Say.Power:SetFrench("Alimentez ma création !")
GU.Lang.Say.Power:SetGerman("Macht meiner Schöpfung!")
GU.Lang.Say.Power:SetRussian("Наполни мое творение силой!")
GU.Lang.Say.Arcane = KBM.Language:Add("Inquisitor Garau siphons arcane essence from nearby enemies!")
GU.Lang.Say.Arcane:SetFrench("Inquisiteur Garau siphonne l'essence occulte des ennemis à proximité !")
GU.Lang.Say.Arcane:SetGerman("Inquisitor Garau saugt von Feinden in der Nähe arkane Essenz ab!")
GU.Lang.Say.Arcane:SetRussian("Инквизитор Гарау высасывает магическую энергию из окружающих врагов!")
GU.Lang.Say.Arcane:SetKorean("인퀴지터 가라우이(가) 근처에 있는 적으로부터 비전 정수를 흡입합니다!")
GU.Lang.Say.Bask = KBM.Language:Add("Bask in the power of Akylios!")
GU.Lang.Say.Bask:SetFrench("Savourez le pouvoir d'Akylios !")
GU.Lang.Say.Bask:SetGerman("Preiset die Macht des Akylios!")
GU.Lang.Say.Bask:SetRussian("Познайте мощь Акилиоса!")
GU.Lang.Say.Sacrifice = KBM.Language:Add("Sacrifice your lives for Akylios!")
GU.Lang.Say.Sacrifice:SetFrench("Sacrifiez vos vies pour Akylios !")
GU.Lang.Say.Sacrifice:SetGerman("Opfert Eure Leben dem Akylios!")
GU.Lang.Say.Sacrifice:SetRussian("Ваши жизни станут жертвой в честь Акилиоса!")
	
function GU:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Garau.Name] = self.Garau,
	}
end

function GU:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),		
		CastBar = self.Garau.Settings.CastBar,
		TimersRef = self.Garau.Settings.TimersRef,
		AlertsRef = self.Garau.Settings.AlertsRef,
		PhaseMon = KBM.Defaults.PhaseMon()
	}
	KBMGU_Settings = self.Settings
	chKBMGU_Settings = self.Settings
	
end

function GU:SwapSettings(bool)
	if bool then
		KBMGU_Settings = self.Settings
		self.Settings = chKBMGU_Settings
	else
		chKBMGU_Settings = self.Settings
		self.Settings = KBMGU_Settings
	end
end

function GU:LoadVars()
	local TargetLoad = nil	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGU_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGU_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMGU_Settings = self.Settings
	else
		KBMGU_Settings = self.Settings
	end	
end

function GU:SaveVars()
	if KBM.Options.Character then
		chKBMGU_Settings = self.Settings
	else
		KBMGU_Settings = self.Settings
	end	
end

function GU:Castbar(units)
end

function GU:RemoveUnits(UnitID)
	if self.Garau.UnitID == UnitID then
		self.Garau.Available = false
		return true
	end
	return false
end

function GU:Death(UnitID)
	if self.Garau.UnitID == UnitID then
		self.Garau.Dead = true
		return true
	end
	return false
end

function GU:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Garau.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Garau.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Garau.Name, 0, 100)
				end
				self.Garau.Casting = false
				self.Garau.UnitID = unitID
				self.Garau.Available = true
				return self.Garau
			end
		end
	end
end

function GU:Reset()
	self.EncounterRunning = false
	self.Garau.Available = false
	self.Garau.UnitID = nil
	self.Garau.CastBar:Remove()
	self.Garau.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function GU:Timer()	
end

function GU:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Garau, self.Enabled)
end

function GU:Start()
	-- Create Timers
	self.Garau.TimersRef.Blood = KBM.MechTimer:Add(GU.Lang.Ability.Blood[KBM.Lang], 18)
	self.Garau.TimersRef.Crawler = KBM.MechTimer:Add(self.Lang.Unit.Crawler[KBM.Lang], 30)
	self.Garau.TimersRef.Porter = KBM.MechTimer:Add(GU.Lang.Unit.Porter[KBM.Lang], 45)
	self.Garau.TimersRef.Essence = KBM.MechTimer:Add(GU.Lang.Ability.Arcane[KBM.Lang], 20)
	KBM.Defaults.TimerObj.Assign(self.Garau)
	
	-- Create Alerts
	self.Garau.AlertsRef.Porter = KBM.Alert:Create(self.Lang.Unit.Porter[KBM.Lang], 2, true, false, "purple")
	self.Garau.AlertsRef.Shield = KBM.Alert:Create(self.Lang.Buff.Shield[KBM.Lang], nil, false, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Garau)
	
	-- Assign Mechanics to Triggers
	self.Garau.Triggers.Blood = KBM.Trigger:Create(GU.Lang.Ability.Blood[KBM.Lang], "cast", self.Garau)
	self.Garau.Triggers.Blood:AddTimer(self.Garau.TimersRef.Blood)
	self.Garau.Triggers.CrawlerA = KBM.Trigger:Create(GU.Lang.Say.Bask[KBM.Lang], "say", self.Garau)
	self.Garau.Triggers.CrawlerA:AddTimer(self.Garau.TimersRef.Crawler)
	self.Garau.Triggers.CrawlerB = KBM.Trigger:Create(GU.Lang.Say.Sacrifice[KBM.Lang], "say", self.Garau)
	self.Garau.Triggers.CrawlerB:AddTimer(self.Garau.TimersRef.Crawler)
	self.Garau.Triggers.Porter = KBM.Trigger:Create(GU.Lang.Say.Power[KBM.Lang], "say", self.Garau)
	self.Garau.Triggers.Porter:AddTimer(self.Garau.TimersRef.Porter)
	self.Garau.Triggers.Porter:AddAlert(self.Garau.AlertsRef.Porter)
	self.Garau.Triggers.Essence = KBM.Trigger:Create(GU.Lang.Say.Arcane[KBM.Lang], "notify", self.Garau)
	self.Garau.Triggers.Essence:AddTimer(self.Garau.TimersRef.Essence)
	self.Garau.Triggers.Shield = KBM.Trigger:Create(GU.Lang.Buff.Shield[KBM.Lang], "buff", self.Garau)
	self.Garau.Triggers.Shield:AddAlert(self.Garau.AlertsRef.Shield)
	self.Garau.Triggers.Shield = KBM.Trigger:Create(GU.Lang.Buff.Shield[KBM.Lang], "buffRemove", self.Garau)
	self.Garau.Triggers.Shield:AddStop(self.Garau.AlertsRef.Shield)
	
	self.Garau.CastBar = KBM.CastBar:Add(self, self.Garau, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end