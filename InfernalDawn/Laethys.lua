-- Laethys Boss Mod for King Boss Mods
-- Written by Paul Snart & Ciladan
-- Copyright 2011
--

KBMINDLT_Settings = nil
chKBMINDLT_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local LT = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Laethys.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Phase = 1,
	Enrage = 10 * 60,
	Lang = {},
	ID = "Laethys",
	Object = "LT",
}

LT.Laethys = {
	Mod = LT,
	Level = "??",
	Active = false,
	Name = "Laethys",
--  Name = "Normal Practice Dummy",
	NameShort = "Laethys",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		 TimersRef = {
			Enabled = true,
			PhaseTwoTrans = KBM.Defaults.TimerObj.Create("dark_green"),
			Funnel = KBM.Defaults.TimerObj.Create("red"),
			StormFirst = KBM.Defaults.TimerObj.Create("red"),
		  	Storm = KBM.Defaults.TimerObj.Create("red"),
		  	Breath = KBM.Defaults.TimerObj.Create("blue"),
		  	OrbFirst = KBM.Defaults.TimerObj.Create("dark_green"),
		  	Orb = KBM.Defaults.TimerObj.Create("dark_green"), 
		  	FlareFirst = KBM.Defaults.TimerObj.Create("cyan"),
		  	Flare = KBM.Defaults.TimerObj.Create("cyan"),
		  	GoldFirst = KBM.Defaults.TimerObj.Create("yellow"),
		  	Gold = KBM.Defaults.TimerObj.Create("yellow"),
		 	AddsFirst = KBM.Defaults.TimerObj.Create("purple"),
		 	Adds = KBM.Defaults.TimerObj.Create("purple"),
			LiqGoldFirst = KBM.Defaults.TimerObj.Create("yellow"),
			LiqGold = KBM.Defaults.TimerObj.Create("yellow"),
		  
		 },
		 AlertsRef = {
			Enabled = true,
			Funnel = KBM.Defaults.AlertObj.Create("red"),
			Storm = KBM.Defaults.AlertObj.Create("red"),
			Orb = KBM.Defaults.AlertObj.Create("dark_green"),
			Flare = KBM.Defaults.AlertObj.Create("cyan"),
			LiqGold = KBM.Defaults.AlertObj.Create("yellow"),
			TGold = KBM.Defaults.AlertObj.Create("purple"),
			--TGoldWarn = KBM.Defaults.AlertObj.Create("dark_grey"),
		 },
	}
}

KBM.RegisterMod(LT.ID, LT)

-- Main Unit Dictionary
LT.Lang.Unit = {}
LT.Lang.Unit.Laethys = KBM.Language:Add(LT.Laethys.Name)
LT.Lang.Unit.Laethys:SetGerman()
LT.Lang.Unit.Laethys:SetFrench()
LT.Lang.Unit.Laethys:SetRussian("Лэтис")
LT.Lang.Unit.Laethys:SetKorean("레시스")
-- Additional Units
LT.Lang.Unit.Seer = KBM.Language:Add("Wizened Stoneseer")
LT.Lang.Unit.Seer:SetGerman("Verschrumpelter Steindeuter")
LT.Lang.Unit.Seer:SetFrench("Oracle de pierre ratatiné")
LT.Lang.Unit.Seer:SetRussian("Иссохший прорицатель")
LT.Lang.Unit.SeerShort = KBM.Language:Add("Stoneseer")
LT.Lang.Unit.SeerShort:SetGerman("Steindeuter")
LT.Lang.Unit.SeerShort:SetFrench("Oracle")
LT.Lang.Unit.SeerShort:SetRussian("Прорицатель")

-- Ability Dictionary
LT.Lang.Ability = {}
LT.Lang.Ability.Breath = KBM.Language:Add("Golden Breath")
LT.Lang.Ability.Breath:SetGerman("Goldatem")
LT.Lang.Ability.Breath:SetFrench("Souffle d'or")
LT.Lang.Ability.Breath:SetRussian("Золотое дыхание")
LT.Lang.Ability.Storm = KBM.Language:Add("Storm of Treasure")
LT.Lang.Ability.Storm:SetGerman("Sturm der Schätze")
LT.Lang.Ability.Storm:SetFrench("Tempête de trésor")
LT.Lang.Ability.Storm:SetRussian("Шторм сокровищ")
LT.Lang.Ability.Flare = KBM.Language:Add("Annihilating Flare")
LT.Lang.Ability.Flare:SetGerman("Auslöschende Fackel")
LT.Lang.Ability.Flare:SetFrench("Flamboiement d'annihilation")
LT.Lang.Ability.Flare:SetRussian("Уничтожительная вспышка")
LT.Lang.Ability.Orb = KBM.Language:Add("Metallic Orb")
LT.Lang.Ability.Orb:SetGerman("Metallische Kugel")
LT.Lang.Ability.Orb:SetFrench("Orbe métallique")
LT.Lang.Ability.Orb:SetRussian("Металлический шар")
LT.Lang.Ability.Gold = KBM.Language:Add("Molten Gold")
LT.Lang.Ability.Gold:SetGerman("Geschmolzenes Gold")
LT.Lang.Ability.Gold:SetFrench("Or en fusion")
LT.Lang.Ability.Gold:SetRussian("Расплавленное золото")
LT.Lang.Ability.Resto = KBM.Language:Add("Wizened Restoration")
LT.Lang.Ability.Resto:SetGerman("Verschrumpelte Wiederherstellung")
LT.Lang.Ability.Resto:SetFrench("Restauration ratatinée")
LT.Lang.Ability.Resto:SetRussian("Иссохшее восстановление")
LT.Lang.Ability.LiqGold = KBM.Language:Add("Laethic Gold")
LT.Lang.Ability.LiqGold:SetGerman("Laethic-Gold")
LT.Lang.Ability.LiqGold:SetFrench("Or laethique")

-- Mechanic Dictionary
LT.Lang.Mechanic = {}
LT.Lang.Mechanic.Adds = KBM.Language:Add("Adds spawn")
LT.Lang.Mechanic.Adds:SetFrench("Pop des Adds")
LT.Lang.Mechanic.Adds:SetGerman("Add Spawn")
LT.Lang.Mechanic.Adds:SetKorean("쫄들 소환")
LT.Lang.Mechanic.Adds:SetRussian("Адды")
LT.Lang.Mechanic.PhaseTwoTrans = KBM.Language:Add("until Phase 2 begins!")
LT.Lang.Mechanic.PhaseTwoTrans:SetFrench("jusqu'au démarrage de la phase 2 !")
LT.Lang.Mechanic.PhaseTwoTrans:SetRussian("до фазы 2!")
LT.Lang.Mechanic.PhaseTwoTrans:SetGerman("bis Phase 2 beginnt!")

-- Buff Dictionary
LT.Lang.Buff = {}
LT.Lang.Buff.Wisdom = KBM.Language:Add("Stoneseers Wisdom")
LT.Lang.Buff.Wisdom:SetGerman("Weisheit des Steindeuters")
LT.Lang.Buff.Wisdom:SetFrench("Sagesse de l'oracle de pierre")
LT.Lang.Buff.Wisdom:SetRussian("Мудрость прорицателя")

-- Debuff Dictionary
LT.Lang.Debuff = {}
LT.Lang.Debuff.Gold = KBM.Language:Add("Touch of Gold")
LT.Lang.Debuff.Gold:SetFrench("Toucher de l'or")
LT.Lang.Debuff.Gold:SetGerman("Berührung des Goldes")
--LT.Lang.Debuff.TGold = KBM.Language:Add("Use ability soon!")

-- Notify Dictionary
LT.Lang.Notify = {}
LT.Lang.Notify.PhaseTwoTrans = KBM.Language:Add("Laethys roars, \"How dare you scuff my beautiful form%?! You will pay for this...\"")
LT.Lang.Notify.PhaseTwoTrans:SetFrench("Laethys rugit : \"Comment osez-vous vous en prendre à tant de beauté %? Vous me le paierez...\"")
LT.Lang.Notify.PhaseTwoTrans:SetGerman("Laethys brüllt: \"Wie könnt Ihr es wagen, meiner wunderschönen Gestalt zu schaden. Dafür werdet Ihr büßen ...\"")
LT.Lang.Notify.PhaseTwoStart = KBM.Language:Add("Laethys says, \"Behold your doom! Put down your weapons and perhaps I shall grant you a swift demise!\"")
LT.Lang.Notify.PhaseTwoStart:SetFrench("Laethys dit : \"Nul ne peut échapper à son destin ! Rendez les armes et je vous accorderai un léger sursis.\"")
LT.Lang.Notify.PhaseTwoStart:SetGerman("Laethys sagt: \"Seht Eurem Untergang entgegen! Legt Eure Waffen nieder und ich gewähre Euch ein schnelles Ende ... vielleicht!\"")
LT.Lang.Notify.LiqGold = KBM.Language:Add("Laethys unleashes a wave of liquid gold.")
LT.Lang.Notify.LiqGold:SetGerman("Laethys entfesselt eine Welle aus flüssigem Gold.")
LT.Lang.Notify.LiqGold:SetFrench("Laethys lance une vague d'or liquide.")

-- Menu Dictionary
LT.Lang.Menu = {}
LT.Lang.Menu.Storm = KBM.Language:Add("First Storm of Treasure")
LT.Lang.Menu.Storm:SetGerman("Erste Sturm der Schätze")
LT.Lang.Menu.Storm:SetFrench("Première Tempête de trésor")
LT.Lang.Menu.Storm:SetRussian("Первый Шторм сокровищ")
LT.Lang.Menu.Flare = KBM.Language:Add("First Annihilating Flare")
LT.Lang.Menu.Flare:SetGerman("Erste Auslöschende Fackel")
LT.Lang.Menu.Flare:SetFrench("Premier Flamboiement d'annihilation")
LT.Lang.Menu.Flare:SetRussian("Первая Уничтожительная вспышка")
LT.Lang.Menu.Orb = KBM.Language:Add("First Metallic Orb")
LT.Lang.Menu.Orb:SetGerman("Erste Metallische Kugel")
LT.Lang.Menu.Orb:SetFrench("Premier Orbe métallique")
LT.Lang.Menu.Orb:SetRussian("Первый Металлический шар")
LT.Lang.Menu.Gold = KBM.Language:Add("First Molten Gold")
LT.Lang.Menu.Gold:SetGerman("Erste Geschmolzenes Gold")
LT.Lang.Menu.Gold:SetFrench("Premier Or en fusion")
LT.Lang.Menu.Gold:SetRussian("Первое Расплавленное золото")
LT.Lang.Menu.Adds = KBM.Language:Add("First Adds spawn")
LT.Lang.Menu.Adds:SetGerman("Erster Add Spawn")
LT.Lang.Menu.Adds:SetFrench("Premier Pop des Adds")
LT.Lang.Menu.Adds:SetRussian("Первые Адды")
LT.Lang.Menu.LiqGold = KBM.Language:Add("First Laethic Gold")
LT.Lang.Menu.LiqGold:SetGerman("Erste Laethic-Gold")
LT.Lang.Menu.LiqGold:SetFrench("Premier Or laethique")
--LT.Lang.Menu.TGold = KBM.Language:Add("Touch of Gold 5 second warning")

LT.Laethys.Name = LT.Lang.Unit.Laethys[KBM.Lang]
LT.Laethys.NameShort = LT.Lang.Unit.Laethys[KBM.Lang]
LT.Descript = LT.Laethys.Name

LT.Seer = {
	Mod = LT,
	Level = "??",
	Name = LT.Lang.Unit.Seer[KBM.Lang],
	NameShort = LT.Lang.Unit.SeerShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	AlertsRef = {},
	TimersRef = {},
	Ignore = true,
	Type = "multi",
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Resto = KBM.Defaults.AlertObj.Create("yellow"),
		},
		TimersRef = {
			Enabled = true,
			Resto = KBM.Defaults.TimerObj.Create("yellow"),
		},
	}
}

function LT:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Laethys.Name] = self.Laethys,
		[self.Seer.Name] = self.Seer,
	}
	KBM_Boss[self.Laethys.Name] = self.Laethys
	KBM.SubBoss[self.Seer.Name] = self.Seer
end

function LT:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Laethys.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		Laethys = {
			TimersRef = self.Laethys.Settings.TimersRef,
			AlertsRef = self.Laethys.Settings.AlertsRef,
		},
		Seer = {
			TimersRef = self.Seer.Settings.TimersRef,
			AlertsRef = self.Seer.Settings.AlertsRef,
		},
	}
	KBMINDLT_Settings = self.Settings
	chKBMINDLT_Settings = self.Settings
	
end

function LT:SwapSettings(bool)

	if bool then
		KBMINDLT_Settings = self.Settings
		self.Settings = chKBMINDLT_Settings
	else
		chKBMINDLT_Settings = self.Settings
		self.Settings = KBMINDLT_Settings
	end

end

function LT:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDLT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDLT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDLT_Settings = self.Settings
	else
		KBMINDLT_Settings = self.Settings
	end	
end

function LT:SaveVars()	
	if KBM.Options.Character then
		chKBMINDLT_Settings = self.Settings
	else
		KBMINDLT_Settings = self.Settings
	end	
end

function LT:Castbar(units)
end

function LT:RemoveUnits(UnitID)
	if self.Laethys.UnitID == UnitID then
		self.Laethys.Available = false
		return true
	end
	return false
end

function LT:Death(UnitID)
	if self.Laethys.UnitID == UnitID then
		self.Laethys.Dead = true
		return true
	end
	return false
end

function LT:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Laethys.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Laethys.Dead = false
					self.Laethys.Casting = false
					self.Laethys.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Laethys.Name, 51, 100)
					self.Phase = 1
					KBM.MechTimer:AddStart(self.Laethys.TimersRef.StormFirst)
					KBM.MechTimer:AddStart(self.Laethys.TimersRef.OrbFirst)
					KBM.MechTimer:AddStart(self.Laethys.TimersRef.FlareFirst)
					KBM.MechTimer:AddStart(self.Laethys.TimersRef.GoldFirst)
					KBM.MechTimer:AddStart(self.Laethys.TimersRef.AddsFirst)
				elseif unitID ~= self.Laethys.UnitID then
					self.Laethys.CastBar:Remove()
					self.Laethys.CastBar:Create(unitID)
				end
				self.Laethys.UnitID = unitID
				self.Laethys.Available = true
				return self.Laethys
			elseif self.EncounterRunning then
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = LT,
						Level = "??",
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
					if uDetails.name == self.Seer.Name then
						SubBossObj.CastBar = KBM.CastBar:Add(self, self.Seer, false, true)
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

function LT:Reset()
	self.EncounterRunning = false
	self.Laethys.Available = false
	self.Laethys.UnitID = nil
	self.Laethys.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function LT:Timer()	
end

function LT:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Laethys, self.Enabled)
end

function LT.PhaseTwo()
	if LT.Phase == 1 then
		LT.PhaseObj.Objectives:Remove()
		LT.Phase = 2
		LT.PhaseObj:SetPhase("2")
		LT.PhaseObj.Objectives:AddPercent(LT.Laethys.Name, 0, 100)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.Storm)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.Breath)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.Orb)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.Flare)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.Gold)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.AddsFirst)
		KBM.MechTimer:AddRemove(LT.Laethys.TimersRef.Adds)
	end
end


function LT:Start()
	-- Create Timers for Laethys
	self.Laethys.TimersRef.StormFirst = KBM.MechTimer:Add(self.Lang.Ability.Storm[KBM.Lang], 40)
 	self.Laethys.TimersRef.StormFirst.MenuName = self.Lang.Menu.Storm[KBM.Lang]
 	self.Laethys.TimersRef.Storm = KBM.MechTimer:Add(self.Lang.Ability.Storm[KBM.Lang], 60)
 	self.Laethys.TimersRef.Breath = KBM.MechTimer:Add(self.Lang.Ability.Breath[KBM.Lang], 11)
 	self.Laethys.TimersRef.OrbFirst = KBM.MechTimer:Add(self.Lang.Ability.Orb[KBM.Lang], 35)
 	self.Laethys.TimersRef.OrbFirst.MenuName = self.Lang.Menu.Orb[KBM.Lang]
 	self.Laethys.TimersRef.Orb = KBM.MechTimer:Add(self.Lang.Ability.Orb[KBM.Lang], 35)
 	self.Laethys.TimersRef.FlareFirst = KBM.MechTimer:Add(self.Lang.Ability.Flare[KBM.Lang], 23)
 	self.Laethys.TimersRef.FlareFirst.MenuName = self.Lang.Menu.Flare[KBM.Lang]
 	self.Laethys.TimersRef.Flare = KBM.MechTimer:Add(self.Lang.Ability.Flare[KBM.Lang], 23)
 	self.Laethys.TimersRef.GoldFirst = KBM.MechTimer:Add(self.Lang.Ability.Gold[KBM.Lang],20)
	self.Laethys.TimersRef.GoldFirst.MenuName = self.Lang.Menu.Gold[KBM.Lang]
 	self.Laethys.TimersRef.Gold = KBM.MechTimer:Add(self.Lang.Ability.Gold[KBM.Lang], 30)
 	self.Laethys.TimersRef.AddsFirst = KBM.MechTimer:Add(self.Lang.Menu.Adds[KBM.Lang], 34)
 	self.Laethys.TimersRef.Adds = KBM.MechTimer:Add(self.Lang.Mechanic.Adds[KBM.Lang], 90, true)
	self.Laethys.TimersRef.Adds:SetPhase(1)
	-- Phase Two
	self.Laethys.TimersRef.PhaseTwoTrans = KBM.MechTimer:Add(self.Lang.Mechanic.PhaseTwoTrans[KBM.Lang], 40)
	self.Laethys.TimersRef.LiqGoldFirst = KBM.MechTimer:Add(self.Lang.Menu.LiqGold[KBM.Lang], 70)
	self.Laethys.TimersRef.LiqGold = KBM.MechTimer:Add(self.Lang.Ability.LiqGold[KBM.Lang], 92)
	KBM.Defaults.TimerObj.Assign(self.Laethys)
	
	-- Create Timer for Stoneseer
	self.Seer.TimersRef.Resto = KBM.MechTimer:Add(self.Lang.Ability.Resto[KBM.Lang], 10)
	KBM.Defaults.TimerObj.Assign(self.Seer)
	 
	-- Create Alerts for Laethys
	self.Laethys.AlertsRef.Storm = KBM.Alert:Create(self.Lang.Ability.Storm[KBM.Lang], nil, false, true, "red")
	self.Laethys.AlertsRef.Orb = KBM.Alert:Create(self.Lang.Ability.Orb[KBM.Lang], nil, false, true, "dark_green")
	self.Laethys.AlertsRef.Flare = KBM.Alert:Create(self.Lang.Ability.Flare[KBM.Lang], nil, false, true, "cyan")
	self.Laethys.AlertsRef.TGold = KBM.Alert:Create(self.Lang.Debuff.Gold[KBM.Lang], nil, false, true, "purple")
	--self.Laethys.AlertsRef.TGoldWarn = KBM.Alert:Create(self.Lang.Debuff.TGold[KBM.Lang], 5, false, true, "dark_grey")
	--self.Laethys.AlertsRef.TGold:AddAlert(self.Laethys.AlertsRef.TGoldWarn, 5)
	--self.Laethys.AlertsRef.TGold.MenuName = self.Lang.Menu.TGold[KBM.Lang]
	-- Phase Two
	self.Laethys.AlertsRef.LiqGold = KBM.Alert:Create(self.Lang.Ability.LiqGold[KBM.Lang], 5, true, true, "yellow")
	self.Laethys.TimersRef.LiqGoldFirst:AddAlert(self.Laethys.AlertsRef.LiqGold, 5)
	self.Laethys.TimersRef.LiqGold:AddAlert(self.Laethys.AlertsRef.LiqGold, 5)
	KBM.Defaults.AlertObj.Assign(self.Laethys)
	
	-- Create Alert for Stoneseer
	self.Seer.AlertsRef.Resto = KBM.Alert:Create(self.Lang.Ability.Resto[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Seer)
	
	-- Assign Alerts and Timers to Triggers
	-- Wizened Stoneseer
	self.Seer.Triggers.Resto = KBM.Trigger:Create(self.Lang.Ability.Resto[KBM.Lang], "personalCast", self.Seer)
	self.Seer.Triggers.Resto:AddAlert(self.Seer.AlertsRef.Resto)
	self.Seer.Triggers.Resto:AddTimer(self.Seer.TimersRef.Resto)
	
	self.Seer.Triggers.RestoInt = KBM.Trigger:Create(self.Lang.Ability.Resto[KBM.Lang], "personalInterrupt", self.Seer)
	self.Seer.Triggers.RestoInt:AddStop(self.Seer.AlertsRef.Resto)
	
	-- Laethys
	self.Laethys.Triggers.PhaseTwoTrans = KBM.Trigger:Create(self.Lang.Notify.PhaseTwoTrans[KBM.Lang], "notify", self.Laethys)
	self.Laethys.Triggers.PhaseTwoTrans:AddPhase(self.PhaseTwo)
	self.Laethys.Triggers.PhaseTwoTrans:AddTimer(self.Laethys.TimersRef.PhaseTwoTrans)
	self.Laethys.Triggers.PhaseTwoStart = KBM.Trigger:Create(self.Lang.Notify.PhaseTwoStart[KBM.Lang], "notify", self.Laethys)
	self.Laethys.Triggers.PhaseTwoStart:AddTimer(self.Laethys.TimersRef.LiqGoldFirst)
	
	self.Laethys.Triggers.LiqGold = KBM.Trigger:Create(self.Lang.Notify.LiqGold[KBM.Lang], "notify", self.Laethys)
	self.Laethys.Triggers.LiqGold:AddTimer(self.Laethys.TimersRef.LiqGold)
	
	self.Laethys.Triggers.Adds = KBM.Trigger:Create(34, "time", self.Laethys)
	self.Laethys.Triggers.Adds:AddTimer(self.Laethys.TimersRef.Adds)
	
	self.Laethys.Triggers.TGold = KBM.Trigger:Create(self.Lang.Debuff.Gold[KBM.Lang], "playerDebuff", self.Laethys)
	self.Laethys.Triggers.TGold:AddAlert(self.Laethys.AlertsRef.TGold, true)
	
	-- self.Laethys.Triggers.Adds2 = KBM.Trigger:Create(115, "time", self.Laethys)
	-- self.Laethys.Triggers.Adds2:AddTimer(self.Laethys.TimersRef.Adds)
	
	self.Laethys.Triggers.Gold = KBM.Trigger:Create(self.Lang.Ability.Gold[KBM.Lang], "damage", self.Laethys)
	self.Laethys.Triggers.Gold:AddTimer(self.Laethys.TimersRef.Gold)
	
	self.Laethys.Triggers.Breath = KBM.Trigger:Create(self.Lang.Ability.Breath[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.Breath:AddTimer(self.Laethys.TimersRef.Breath)
	
	self.Laethys.Triggers.Storm = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.Storm:AddAlert(self.Laethys.AlertsRef.Storm)
	self.Laethys.Triggers.Storm:AddTimer(self.Laethys.TimersRef.Storm)

	self.Laethys.Triggers.Orb = KBM.Trigger:Create(self.Lang.Ability.Orb[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.Orb:AddAlert(self.Laethys.AlertsRef.Orb)
	self.Laethys.Triggers.Orb:AddTimer(self.Laethys.TimersRef.Orb)
	
	self.Laethys.Triggers.Flare = KBM.Trigger:Create(self.Lang.Ability.Flare[KBM.Lang], "cast", self.Laethys)
	self.Laethys.Triggers.Flare:AddAlert(self.Laethys.AlertsRef.Flare)
	self.Laethys.Triggers.Flare:AddTimer(self.Laethys.TimersRef.Flare)
	
	self.Laethys.CastBar = KBM.CastBar:Add(self, self.Laethys)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end