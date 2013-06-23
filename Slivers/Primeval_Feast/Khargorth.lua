-- Swarmlord Khargroth Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFSK_Settings = nil
chKBMPFSK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local SK = {
	Directory = PF.Directory,
	File = "Khargroth.lua",
	Enabled = true,
	Instance = PF.Name,
	InstanceObj = PF,
	Lang = {},
	Enrage = 5.5 * 60,
	ID = "PF_Khargroth",
	Object = "SK",
}

SK.Khargroth = {
	Mod = SK,
	Level = "??",
	Active = false,
	Name = "Swarmlord Khargroth",
	NameShort = "Khargroth",
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U443DEDB15D439E17",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Spray = KBM.Defaults.TimerObj.Create("dark_green"),
			Return = KBM.Defaults.TimerObj.Create("blue"),
			Acid = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Acid = KBM.Defaults.AlertObj.Create("purple"),
			AcidWarn = KBM.Defaults.AlertObj.Create("purple"),
			Spray = KBM.Defaults.AlertObj.Create("dark_green"),
			Crawl = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Crawl = KBM.Defaults.MechObj.Create("red"),
			Acid = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(SK.ID, SK)

-- Main Unit Dictionary
SK.Lang.Unit = {}
SK.Lang.Unit.Khargroth = KBM.Language:Add(SK.Khargroth.Name)
SK.Lang.Unit.Khargroth:SetGerman("Schwarmherr Khargroth")
SK.Lang.Unit.Khargroth:SetFrench("Seigneur de l'Essaim Khargroth")
SK.Lang.Unit.Khargroth:SetRussian("Предводитель роя Харгрот")
SK.Lang.Unit.KhargrothShort = KBM.Language:Add("Khargroth")
SK.Lang.Unit.KhargrothShort:SetGerman("Khargroth")
SK.Lang.Unit.KhargrothShort:SetFrench("Khargroth")
SK.Lang.Unit.KhargrothShort:SetRussian("Харгрот")

-- Ability Dictionary
SK.Lang.Ability = {}
SK.Lang.Ability.Spray = KBM.Language:Add("Poison Spray")
SK.Lang.Ability.Spray:SetGerman("Gift-Sprühnebel")
SK.Lang.Ability.Spray:SetFrench("Atomiseur de Poison")
SK.Lang.Ability.Spray:SetRussian("Распыление яда")

-- Notify Dictionary
SK.Lang.Notify = {}
SK.Lang.Notify.Acid = KBM.Language:Add("Swarmlord Khargroth sends a swirling cloud of acid at (%a*)!")
SK.Lang.Notify.Acid:SetGerman("Schwarmherr Khargroth schickt (%a*) eine wirbelnde Säurewolke entgegen!")
SK.Lang.Notify.Acid:SetFrench("Seigneur de l'Essaim Khargroth envoie un nuage d'acide tourbillonnant sur (%a*) !")
SK.Lang.Notify.Acid:SetRussian("Предводитель роя Харгрот запускает клубящееся облако кислоты. (%a*) рискует остаться без глаз!")
SK.Lang.Notify.Crawl = KBM.Language:Add("The Crawler Juggernaut chases after (%a*)!")
SK.Lang.Notify.Crawl:SetGerman("Giganten-Kriecher jagt (%a*)!")
SK.Lang.Notify.Crawl:SetFrench("Rampant mastodonte poursuit (%a*) !")
SK.Lang.Notify.Crawl:SetRussian("(%a*) убегает, но Ползун-фанатик не отстает!")

-- Debuff Dictionary
SK.Lang.Debuff = {}
SK.Lang.Debuff.Acid = KBM.Language:Add("Acidic Vapors")
SK.Lang.Debuff.Acid:SetGerman("Säure-Dämpfe")
SK.Lang.Debuff.Acid:SetFrench("Vapeurs acides")
SK.Lang.Debuff.Acid:SetRussian("Кислотные испарения")
SK.Lang.Debuff.Venom = KBM.Language:Add("Lethargic Venom")
SK.Lang.Debuff.Venom:SetFrench("Venin léthargique")
SK.Lang.Debuff.Venom:SetGerman("Lethargisches Gift")
SK.Lang.Debuff.Venom:SetRussian("Усыпляющий яд")

-- Verbose Dictionary
SK.Lang.Verbose = {}
SK.Lang.Verbose.Return = KBM.Language:Add("Swarmlord Khargroth returns")
SK.Lang.Verbose.Return:SetGerman("Schwarmherr Khargroth kehrt zurück")
SK.Lang.Verbose.Return:SetFrench("Seigneur de l'Essaim Khargroth reviens")
SK.Lang.Verbose.Return:SetRussian("Харгрот возвращается")
SK.Lang.Verbose.Acid = KBM.Language:Add("Warning! Acidic Vapors")
SK.Lang.Verbose.Acid:SetGerman("Achtung! Säure-Dämpfe")
SK.Lang.Verbose.Acid:SetFrench("Avertissement! Vapeurs acides")
SK.Lang.Verbose.Acid:SetRussian("Внимание! Кислотные испарения")
SK.Lang.Verbose.Crawl = KBM.Language:Add("Chased")
SK.Lang.Verbose.Crawl:SetGerman("Gejagt")
SK.Lang.Verbose.Crawl:SetFrench("Poursuivi")
SK.Lang.Verbose.Crawl:SetRussian("Убегайте")
SK.Khargroth.Name = SK.Lang.Unit.Khargroth[KBM.Lang]
SK.Khargroth.NameShort = SK.Lang.Unit.KhargrothShort[KBM.Lang]
SK.Descript = SK.Khargroth.Name

function SK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Khargroth.Name] = self.Khargroth,
	}
end

function SK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Khargroth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		AlertsRef = self.Khargroth.Settings.AlertsRef,
		TimersRef = self.Khargroth.Settings.TimersRef,
		MechRef = self.Khargroth.Settings.MechRef,
	}
	KBMPFSK_Settings = self.Settings
	chKBMPFSK_Settings = self.Settings
end

function SK:SwapSettings(bool)

	if bool then
		KBMPFSK_Settings = self.Settings
		self.Settings = chKBMPFSK_Settings
	else
		chKBMPFSK_Settings = self.Settings
		self.Settings = KBMPFSK_Settings
	end

end

function SK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFSK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFSK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFSK_Settings = self.Settings
	else
		KBMPFSK_Settings = self.Settings
	end	
end

function SK:SaveVars()	
	if KBM.Options.Character then
		chKBMPFSK_Settings = self.Settings
	else
		KBMPFSK_Settings = self.Settings
	end	
end

function SK:Castbar(units)
end

function SK:RemoveUnits(UnitID)
	if self.Khargroth.UnitID == UnitID then
		self.Khargroth.Available = false
		return true
	end
	return false
end

function SK:StopTimers()
	KBM.MechTimer:AddRemove(self.Khargroth.TimersRef.Spray)
end

function SK.PhaseTwo()
	if SK.Phase == 1 then
		SK.Phase = 2
		SK.PhaseObj:SetPhase("2")
		SK.PhaseObj.Objectives:Remove()
		SK.PhaseObj.Objectives:AddPercent(SK.Khargroth.Name, 55, 85)
		SK:StopTimers()
	end
end

function SK.PhaseThree()
	if SK.Phase < 3 then
		SK.Phase = 3
		SK.PhaseObj:SetPhase("3")
		SK.PhaseObj.Objectives:Remove()
		SK.PhaseObj.Objectives:AddPercent(SK.Khargroth.Name, 35, 55)
		SK:StopTimers()
	end
end

function SK.PhaseFour()
	if SK.Phase < 4 then
		SK.Phase = 4
		SK.PhaseObj:SetPhase("4")
		SK.PhaseObj.Objectives:Remove()
		SK.PhaseObj.Objectives:AddPercent(SK.Khargroth.Name, 30, 35)
		SK:StopTimers()
	end
end

function SK.PhaseFinal()
	if SK.Phase < 5 then
		SK.Phase = 5
		SK.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		SK.PhaseObj.Objectives:Remove()
		SK.PhaseObj.Objectives:AddPercent(SK.Khargroth.Name, 0, 30)
	end
end

function SK:Death(UnitID)
	if self.Khargroth.UnitID == UnitID then
		self.Khargroth.Dead = true
		return true
	end
	return false
end

function SK:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Khargroth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Khargroth.Dead = false
					self.Khargroth.Casting = false
					self.Khargroth.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Khargroth.Name, 85, 100)
					KBM.TankSwap:Start(self.Lang.Debuff.Venom[KBM.Lang], unitID)
					self.Phase = 1
				end
				self.Khargroth.UnitID = unitID
				self.Khargroth.Available = true
				return self.Khargroth
			end
		end
	end
end

function SK:Reset()
	self.EncounterRunning = false
	self.Khargroth.Available = false
	self.Khargroth.UnitID = nil
	self.Khargroth.Dead = false
	self.Khargroth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function SK:Timer()
	
end

function SK.Khargroth:SetTimers(bool)	
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

function SK.Khargroth:SetAlerts(bool)
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

function SK:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Khargroth, self.Enabled)
end

function SK:Start()
	-- Create Timers
	self.Khargroth.TimersRef.Spray = KBM.MechTimer:Add(self.Lang.Ability.Spray[KBM.Lang], 11)
	self.Khargroth.TimersRef.Return = KBM.MechTimer:Add(self.Lang.Verbose.Return[KBM.Lang], 30)
	self.Khargroth.TimersRef.Acid = KBM.MechTimer:Add(self.Lang.Debuff.Acid[KBM.Lang], 45)
	KBM.Defaults.TimerObj.Assign(self.Khargroth)

	-- Create Alerts
	self.Khargroth.AlertsRef.Acid = KBM.Alert:Create(self.Lang.Debuff.Acid[KBM.Lang], nil, false, true, "purple")
	self.Khargroth.AlertsRef.Acid:Important()
	self.Khargroth.AlertsRef.AcidWarn = KBM.Alert:Create(self.Lang.Verbose.Acid[KBM.Lang], 1.5, true, true, "purple")
	self.Khargroth.AlertsRef.AcidWarn:Important()
	self.Khargroth.AlertsRef.Spray = KBM.Alert:Create(self.Lang.Ability.Spray[KBM.Lang], nil, false, true, "dark_green")
	self.Khargroth.AlertsRef.Crawl = KBM.Alert:Create(self.Lang.Verbose.Crawl[KBM.Lang], 6, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Khargroth)
	
	-- Create Spies
	self.Khargroth.MechRef.Crawl = KBM.MechSpy:Add(self.Lang.Verbose.Crawl[KBM.Lang], 6, "mechanic", self.Khargroth)
	self.Khargroth.MechRef.Acid = KBM.MechSpy:Add(self.Lang.Debuff.Acid[KBM.Lang], nil, "playerDebuff", self.Khargroth)
	KBM.Defaults.MechObj.Assign(self.Khargroth)
	
	-- Assign Alerts and Timers to Triggers
	self.Khargroth.Triggers.Acid = KBM.Trigger:Create(self.Lang.Debuff.Acid[KBM.Lang], "playerBuff", self.Khargroth)
	self.Khargroth.Triggers.Acid:AddAlert(self.Khargroth.AlertsRef.Acid, true)
	self.Khargroth.Triggers.Acid:AddSpy(self.Khargroth.MechRef.Acid)
	self.Khargroth.Triggers.AcidWarn = KBM.Trigger:Create(self.Lang.Notify.Acid[KBM.Lang], "notify", self.Khargroth)
	self.Khargroth.Triggers.AcidWarn:AddAlert(self.Khargroth.AlertsRef.AcidWarn, true)
	self.Khargroth.Triggers.AcidWarn:AddTimer(self.Khargroth.TimersRef.Acid)
	self.Khargroth.Triggers.Spray = KBM.Trigger:Create(self.Lang.Ability.Spray[KBM.Lang], "cast", self.Khargroth)
	self.Khargroth.Triggers.Spray:AddTimer(self.Khargroth.TimersRef.Spray)
	self.Khargroth.Triggers.Spray:AddAlert(self.Khargroth.AlertsRef.Spray)
	self.Khargroth.Triggers.Crawl = KBM.Trigger:Create(self.Lang.Notify.Crawl[KBM.Lang], "notify", self.Khargroth)
	self.Khargroth.Triggers.Crawl:AddSpy(self.Khargroth.MechRef.Crawl)
	self.Khargroth.Triggers.Crawl:AddAlert(self.Khargroth.AlertsRef.Crawl, true)
	self.Khargroth.Triggers.PhaseTwo = KBM.Trigger:Create(85, "percent", self.Khargroth)
	self.Khargroth.Triggers.PhaseTwo:AddTimer(self.Khargroth.TimersRef.Return)
	self.Khargroth.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Khargroth.Triggers.PhaseThree = KBM.Trigger:Create(55, "percent", self.Khargroth)
	self.Khargroth.Triggers.PhaseThree:AddTimer(self.Khargroth.TimersRef.Return)
	self.Khargroth.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Khargroth.Triggers.PhaseFour = KBM.Trigger:Create(35, "percent", self.Khargroth)
	self.Khargroth.Triggers.PhaseFour:AddTimer(self.Khargroth.TimersRef.Return)
	self.Khargroth.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Khargroth.Triggers.PhaseFinal = KBM.Trigger:Create(30, "percent", self.Khargroth)
	self.Khargroth.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	
	self.Khargroth.CastBar = KBM.CastBar:Add(self, self.Khargroth, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end