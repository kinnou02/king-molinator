-- Anrak the Foul Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPAF_Settings = nil
chKBMGPAF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Gilded Prophecy"]

local AF = {
	Directory = GP.Directory,
	File = "Anrak.lua",
	Enabled = true,
	Instance = GP.Name,
	Lang = {},
	ID = "Anrak",
	Enrage = 60 * 7,
	Object = "AF",
}

AF.Anrak = {
	Mod = AF,
	Level = "??",
	Active = false,
	Name = "Anrak the Foul",
	NameShort = "Anrak",
	Menu = {},
	Dead = false,
	Available = false,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			SpinesWarn = KBM.Defaults.AlertObj.Create("yellow"),
			Spines = KBM.Defaults.AlertObj.Create("yellow"),
			Strike = KBM.Defaults.AlertObj.Create("red"),
			Call = KBM.Defaults.AlertObj.Create("cyan"),
			Bond = KBM.Defaults.AlertObj.Create("orange"),
		},
		TimersRef = {
			Enabled = true,
			Venom = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		MechRef = {
			Enabled = true,
			Venom = KBM.Defaults.MechObj.Create("dark_green"),
		},
	},
}

KBM.RegisterMod(AF.ID, AF)

-- Main Unit Dictionary
AF.Lang.Unit = {}
AF.Lang.Unit.Anrak = KBM.Language:Add(AF.Anrak.Name)
AF.Lang.Unit.Anrak:SetGerman("Anrak der Üble")
AF.Lang.Unit.Anrak:SetFrench("Anrak l'ignoble")
AF.Lang.Unit.Anrak:SetRussian("Анрак Скверный")
AF.Lang.Unit.Anrak:SetKorean("악독한 안라크")
AF.Anrak.Name = AF.Lang.Unit.Anrak[KBM.Lang]
AF.Descript = AF.Anrak.Name

-- Ability Dictionary
AF.Lang.Ability = {}
AF.Lang.Ability.Spines = KBM.Language:Add("Spines of Earth")
AF.Lang.Ability.Spines:SetGerman("Stacheln der Erde")
AF.Lang.Ability.Spines:SetFrench("Épines de Terre")
AF.Lang.Ability.Spines:SetRussian("Гребни Земли")
AF.Lang.Ability.Spines:SetKorean("대지의 척추")
AF.Lang.Ability.Strike = KBM.Language:Add("Vicious Tail Strike")
AF.Lang.Ability.Strike:SetGerman("Bösartiger Schweifschlag")
AF.Lang.Ability.Strike:SetFrench("Coup de queue retors")
AF.Lang.Ability.Strike:SetRussian("Злобный удар хвостом")
AF.Lang.Ability.Strike:SetKorean("포악한 꼬리 일격")
AF.Lang.Ability.Call = KBM.Language:Add("Call of Anrak")
AF.Lang.Ability.Call:SetGerman("Ruf von Anrak")
AF.Lang.Ability.Call:SetFrench("L'appel d'Anrak")
AF.Lang.Ability.Call:SetRussian("Зов Анрака")
AF.Lang.Ability.Call:SetKorean("안라크의 부름")
AF.Lang.Ability.Bond = KBM.Language:Add("Bond of the Earth")
AF.Lang.Ability.Bond:SetGerman("Bande der Erde")
AF.Lang.Ability.Bond:SetFrench("Lien de la Terre")
AF.Lang.Ability.Bond:SetRussian("Земляное усиление")
AF.Lang.Ability.Bond:SetKorean("대지의 결속")

-- Debuff Dictionary
AF.Lang.Debuff = {}
AF.Lang.Debuff.Brittle = KBM.Language:Add("Brittle")
AF.Lang.Debuff.Brittle:SetGerman("Brüchig")
AF.Lang.Debuff.Brittle:SetFrench("Fragile")
AF.Lang.Debuff.Brittle:SetRussian("Хрупкость")
AF.Lang.Debuff.Brittle:SetKorean("깨지기 쉬움")
AF.Lang.Debuff.Venom = KBM.Language:Add("Explosive Venom")
AF.Lang.Debuff.Venom:SetGerman("Explosives Gift")
AF.Lang.Debuff.Venom:SetFrench("Venin explosif")
AF.Lang.Debuff.Venom:SetKorean("폭발성 맹독")

-- Menu Dictionary
AF.Lang.Menu = {}
AF.Lang.Menu.Spines = KBM.Language:Add("Spines cast warning")
AF.Lang.Menu.Spines:SetGerman("Stacheln Zauber Warnung")
AF.Lang.Menu.Spines:SetFrench("Avertissement Épines de Terre")
AF.Lang.Menu.Spines:SetRussian("Каст гребней земли")
AF.Lang.Menu.Spines:SetKorean("꼬리치기 경고")

function AF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Anrak.Name] = self.Anrak,
	}
	KBM_Boss[self.Anrak.Name] = self.Anrak	
end

function AF:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Anrak.Settings.CastBar,
		PhaseMon = KBM.Defaults.PhaseMon(),
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		AlertsRef = self.Anrak.Settings.AlertsRef,
		TimersRef = self.Anrak.Settings.TimersRef,
		MechRef = self.Anrak.Settings.MechRef,
	}
	KBMGPAF_Settings = self.Settings
	chKBMGPAF_Settings = self.Settings
end

function AF:SwapSettings(bool)

	if bool then
		KBMGPAF_Settings = self.Settings
		self.Settings = chKBMGPAF_Settings
	else
		chKBMGPAF_Settings = self.Settings
		self.Settings = KBMGPAF_Settings
	end

end

function AF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPAF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPAF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPAF_Settings = self.Settings
	else
		KBMGPAF_Settings = self.Settings
	end	
end

function AF:SaveVars()	
	if KBM.Options.Character then
		chKBMGPAF_Settings = self.Settings
	else
		KBMGPAF_Settings = self.Settings
	end	
end

function AF:Castbar(units)
end

function AF:RemoveUnits(UnitID)
	if self.Anrak.UnitID == UnitID then
		self.Anrak.Available = false
		return true
	end
	return false
end

function AF:Death(UnitID)
	if self.Anrak.UnitID == UnitID then
		self.Anrak.Dead = true
		return true
	end
	return false
end

function AF:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Anrak.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Anrak.Dead = false
					self.Anrak.Casting = false
					self.Anrak.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Anrak.Name, 0, 100)
					KBM.TankSwap:Start(self.Lang.Debuff.Brittle[KBM.Lang], unitID)
				end
				self.Anrak.UnitID = unitID
				self.Anrak.Available = true
				return self.Anrak
			end
		end
	end
end

function AF:Reset()
	self.EncounterRunning = false
	self.Anrak.Available = false
	self.Anrak.UnitID = nil
	self.Anrak.Dead = false
	self.Anrak.CastBar:Remove()
	self.PhaseObj:End(KBM.TimeElapsed)
end

function AF:Timer()
	
end

function AF.Anrak:SetTimers(bool)	
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

function AF.Anrak:SetAlerts(bool)
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

function AF:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Anrak, self.Enabled)
end

function AF:Start()
	-- Create Timers
	self.Anrak.TimersRef.Venom = KBM.MechTimer:Add(self.Lang.Debuff.Venom[KBM.Lang], 30)
	KBM.Defaults.TimerObj.Assign(self.Anrak)
	
	-- Create Mechanic Spies
	self.Anrak.MechRef.Venom = KBM.MechSpy:Add(self.Lang.Debuff.Venom[KBM.Lang], nil, "playerDebuff", self.Anrak)
	KBM.Defaults.MechObj.Assign(self.Anrak)
	
	-- Create Alerts
	self.Anrak.AlertsRef.SpinesWarn = KBM.Alert:Create(self.Lang.Ability.Spines[KBM.Lang], nil, false, true, "yellow")
	self.Anrak.AlertsRef.SpinesWarn.MenuName = self.Lang.Menu.Spines[KBM.Lang]
	self.Anrak.AlertsRef.Spines = KBM.Alert:Create(self.Lang.Ability.Spines[KBM.Lang], nil, true, true, "yellow")
	self.Anrak.AlertsRef.Strike = KBM.Alert:Create(self.Lang.Ability.Strike[KBM.Lang], nil, true, true, "red")
	self.Anrak.AlertsRef.Call = KBM.Alert:Create(self.Lang.Ability.Call[KBM.Lang], nil, true, true, "dark_green")
	self.Anrak.AlertsRef.Bond = KBM.Alert:Create(self.Lang.Ability.Bond[KBM.Lang], nil, true, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Anrak)
	
	-- Assign Timers and Alerts to Triggers
	self.Anrak.Triggers.SpinesWarn = KBM.Trigger:Create(self.Lang.Ability.Spines[KBM.Lang], "cast", self.Anrak)
	self.Anrak.Triggers.SpinesWarn:AddAlert(self.Anrak.AlertsRef.SpinesWarn)
	self.Anrak.Triggers.Spines = KBM.Trigger:Create(self.Lang.Ability.Spines[KBM.Lang], "channel", self.Anrak)
	self.Anrak.Triggers.Spines:AddAlert(self.Anrak.AlertsRef.Spines)
	self.Anrak.Triggers.Strike = KBM.Trigger:Create(self.Lang.Ability.Strike[KBM.Lang], "cast", self.Anrak)
	self.Anrak.Triggers.Strike:AddAlert(self.Anrak.AlertsRef.Strike)
	self.Anrak.Triggers.Call = KBM.Trigger:Create(self.Lang.Ability.Call[KBM.Lang], "cast", self.Anrak)
	self.Anrak.Triggers.Call:AddAlert(self.Anrak.AlertsRef.Call)
	self.Anrak.Triggers.Bond = KBM.Trigger:Create(self.Lang.Ability.Bond[KBM.Lang], "cast", self.Anrak)
	self.Anrak.Triggers.Bond:AddAlert(self.Anrak.AlertsRef.Bond)
	self.Anrak.Triggers.Venom = KBM.Trigger:Create(self.Lang.Debuff.Venom[KBM.Lang], "playerDebuff", self.Anrak)
	self.Anrak.Triggers.Venom:AddTimer(self.Anrak.TimersRef.Venom)
	self.Anrak.Triggers.Venom:AddSpy(self.Anrak.MechRef.Venom)
	self.Anrak.Triggers.VenomRemove = KBM.Trigger:Create(self.Lang.Debuff.Venom[KBM.Lang], "playerBuffRemove", self.Anrak)
	self.Anrak.Triggers.VenomRemove:AddStop(self.Anrak.MechRef.Venom)
	
	self.Anrak.CastBar = KBM.CastBar:Add(self, self.Anrak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end