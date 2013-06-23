-- Maklamos the Scryer Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDML_Settings = nil
chKBMINDML_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local ML = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Maklamos.lua",
	Instance = IND.Name,
	InstanceObj = IND,
	HasPhases = true,
	Lang = {},
	ID = "Maklamos the Scryer",
	Object = "ML",
	Enrage = 8 * 60,
}

ML.Maklamos = {
	Mod = ML,
	Level = "??",
	Active = false,
	Name = "Maklamos The Scryer",
	NameShort = "Maklamos",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U6D6AA149570398D0",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Desolation = KBM.Defaults.TimerObj.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Power = KBM.Defaults.AlertObj.Create("yellow"),
			Green = KBM.Defaults.AlertObj.Create("dark_green"),
			Blue = KBM.Defaults.AlertObj.Create("blue"),
			Red = KBM.Defaults.AlertObj.Create("red"),
			Distortion = KBM.Defaults.AlertObj.Create("cyan"),
			Desolation = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			Distortion = KBM.Defaults.MechObj.Create("cyan"),
			Green = KBM.Defaults.MechObj.Create("dark_green"),
			Blue = KBM.Defaults.MechObj.Create("blue"),
			Red = KBM.Defaults.MechObj.Create("red"),
		},
	}
}

KBM.RegisterMod(ML.ID, ML)

-- Main Unit Dictionary
ML.Lang.Unit = {}
ML.Lang.Unit.Maklamos = KBM.Language:Add(ML.Maklamos.Name)
ML.Lang.Unit.Maklamos:SetGerman("Maklamos der Wahrsager")
ML.Lang.Unit.Maklamos:SetFrench("Maklamos le Devin")
ML.Lang.Unit.Maklamos:SetRussian("Макламос Прорицатель")
ML.Lang.Unit.Maklamos:SetKorean("점술사 마클라모스")
ML.Lang.Unit.MakShort = KBM.Language:Add("Maklamos")
ML.Lang.Unit.MakShort:SetGerman()
ML.Lang.Unit.MakShort:SetFrench()
ML.Lang.Unit.MakShort:SetRussian("Макламос")
ML.Lang.Unit.MakShort:SetKorean("마클라모스")
ML.Lang.Unit.Jug = KBM.Language:Add("Ruthless Juggernaut")
ML.Lang.Unit.Jug:SetGerman("Rücksichtsloser Gigant")
ML.Lang.Unit.Jug:SetFrench("Mastodonte implacable")
ML.Lang.Unit.Jug:SetRussian("Беспощадный джаггернаут")
ML.Lang.Unit.JugShort = KBM.Language:Add("Juggernaut")
ML.Lang.Unit.JugShort:SetGerman("Gigant")
ML.Lang.Unit.JugShort:SetFrench("Mastodonte")
ML.Lang.Unit.JugShort:SetRussian("Беспощадный")
ML.Lang.Unit.MonJug = KBM.Language:Add("Monstrous Juggernaut")
ML.Lang.Unit.MonJug:SetGerman("Monströser Gigant")
ML.Lang.Unit.MonJug:SetFrench("Mastodonte monstrueux")
ML.Lang.Unit.MonJug:SetRussian("Чудовищный джаггернаут")
ML.Lang.Unit.MonShort = KBM.Language:Add("Monstrous")
ML.Lang.Unit.MonShort:SetGerman("Monströser")
ML.Lang.Unit.MonShort:SetFrench("Monstrueux")
ML.Lang.Unit.MonShort:SetRussian("Чудовищный")
ML.Lang.Unit.MerJug = KBM.Language:Add("Merciless Juggernaut")
ML.Lang.Unit.MerJug:SetGerman("Gnadenloser Gigant")
ML.Lang.Unit.MerJug:SetFrench("Mastodonte impitoyable")
ML.Lang.Unit.MerJug:SetRussian("Безжалостный джаггернаут")
ML.Lang.Unit.MerShort = KBM.Language:Add("Merciless")
ML.Lang.Unit.MerShort:SetGerman("Gnadenloser")
ML.Lang.Unit.MerShort:SetFrench("Impitoyable")
ML.Lang.Unit.MerShort:SetRussian("Безжалостный")

-- Ability Dictionary
ML.Lang.Ability = {}
ML.Lang.Ability.Power = KBM.Language:Add("Returning Power")
ML.Lang.Ability.Power:SetGerman("Wiederkehrende Kraft")
ML.Lang.Ability.Power:SetFrench("Restitution de pouvoir")
ML.Lang.Ability.Power:SetRussian("Возвращение силы")
ML.Lang.Ability.Crystal = KBM.Language:Add("Crystalline Desolation")
ML.Lang.Ability.Crystal:SetGerman("Kristallöde") 
ML.Lang.Ability.Crystal:SetFrench("Désolation cristalline")
ML.Lang.Ability.Crystal:SetRussian("Хрустальное запустение")
ML.Lang.Ability.Crystal:SetKorean("수정체 황폐")

-- Debuff Dictionary
ML.Lang.Debuff = {}
ML.Lang.Debuff.Nature = KBM.Language:Add("Fractured Nature")
ML.Lang.Debuff.Nature:SetGerman("Gespaltene Natur")
ML.Lang.Debuff.Nature:SetFrench("Nature fracturée")
ML.Lang.Debuff.Nature:SetRussian("Расколотая природа")
ML.Lang.Debuff.Green = KBM.Language:Add("Emerald Crystal Essence")
ML.Lang.Debuff.Green:SetGerman("Smaragdkristallessenz")
ML.Lang.Debuff.Green:SetFrench("Essence de cristal d'émeraude")
ML.Lang.Debuff.Blue = KBM.Language:Add("Azure Crystal Essence")
ML.Lang.Debuff.Blue:SetGerman("Azurkristall-Essenz ")
ML.Lang.Debuff.Blue:SetFrench("Essence de cristal azur")
ML.Lang.Debuff.Red = KBM.Language:Add("Scarlet Crystal Essence")
ML.Lang.Debuff.Red:SetGerman("Essenz des feuerroten Kristalls")
ML.Lang.Debuff.Red:SetFrench("Essence de cristal écarlate")
ML.Lang.Debuff.Distortion = KBM.Language:Add("Crystalline Distortion")
ML.Lang.Debuff.Distortion:SetGerman("Kristallverzerrung")
ML.Lang.Debuff.Distortion:SetFrench("Distorsion cristalline")
ML.Lang.Debuff.Distortion:SetRussian("Хрустальное искажение")
ML.Lang.Debuff.Weak = KBM.Language:Add("Weakness")
ML.Lang.Debuff.Weak:SetFrench("Faiblesse")
ML.Lang.Debuff.Weak:SetGerman("Schwäche")
ML.Lang.Debuff.Weak:SetRussian("Слабость")

ML.Maklamos.Name = ML.Lang.Unit.Maklamos[KBM.Lang]
ML.Maklamos.NameShort = ML.Lang.Unit.MakShort[KBM.Lang]
ML.Descript = ML.Maklamos.Name

ML.Jug = {
	Mod = ML,
	Level = "??",
	Name = ML.Lang.Unit.Jug[KBM.Lang],
	NameShort = ML.Lang.Unit.JugShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	UTID = "none",
	Type = "multi",
}

ML.MonJug = {
	Mod = ML,
	Level = "??",
	Name = ML.Lang.Unit.MonJug[KBM.Lang],
	NameShort = ML.Lang.Unit.MonShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	UTID = "none",
	Type = "multi",
}

ML.MerJug = {
	Mod = ML,
	Level = "??",
	Name = ML.Lang.Unit.MerJug[KBM.Lang],
	NameShort = ML.Lang.Unit.MerShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	UTID = "none",
	Type = "multi",
}

function ML:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Maklamos.Name] = self.Maklamos,
		[self.Jug.Name] = self.Jug,
		[self.MonJug.Name] = self.MonJug,
		[self.MerJug.Name] = self.MerJug,
	}
end

function ML:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Maklamos.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Maklamos.Settings.TimersRef,
		AlertsRef = self.Maklamos.Settings.AlertsRef,
		MechRef = self.Maklamos.Settings.MechRef,
	}
	KBMINDML_Settings = self.Settings
	chKBMINDML_Settings = self.Settings
	
end

function ML:SwapSettings(bool)

	if bool then
		KBMINDML_Settings = self.Settings
		self.Settings = chKBMINDML_Settings
	else
		chKBMINDML_Settings = self.Settings
		self.Settings = KBMINDML_Settings
	end

end

function ML:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDML_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDML_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDML_Settings = self.Settings
	else
		KBMINDML_Settings = self.Settings
	end	
end

function ML:SaveVars()	
	if KBM.Options.Character then
		chKBMINDML_Settings = self.Settings
	else
		KBMINDML_Settings = self.Settings
	end	
end

function ML:Castbar(units)
end

function ML:RemoveUnits(UnitID)
	if self.Maklamos.UnitID == UnitID then
		self.Maklamos.Available = false
		return true
	end
	return false
end

function ML.PhaseTwo()
	ML.Phase = 2
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(2)
	ML.PhaseObj.Objectives:AddPercent(ML.Maklamos, 50, 80)	
end

function ML.PhaseThree()
	ML.Phase = 3
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(3)
	ML.PhaseObj.Objectives:AddPercent(ML.Maklamos, 30, 50)
end

function ML.PhaseFour()
	ML.Phase = 4
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	ML.PhaseObj.Objectives:AddPercent(ML.Maklamos, 0, 30)	
end

function ML:Death(UnitID)
	if self.Maklamos.UnitID == UnitID then
		self.Maklamos.Dead = true
		return true
	end
	return false
end

function ML:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Maklamos.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Maklamos.Dead = false
					self.Maklamos.Casting = false
					self.Maklamos.CastBar:Create(unitID)
					local DebuffTable = {
						[1] = self.Lang.Debuff.Nature[KBM.Lang],
						[2] = self.Lang.Debuff.Weak[KBM.Lang],
					}
					KBM.TankSwap:Start(DebuffTable, unitID, 2)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Maklamos, 80, 100)
					self.Phase = 1
				end
				self.Maklamos.UnitID = unitID
				self.Maklamos.Available = true
				return self.Maklamos
			end
		end
	end
end

function ML:Reset()
	self.EncounterRunning = false
	self.Maklamos.Available = false
	self.Maklamos.UnitID = nil
	self.Maklamos.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function ML:Timer()	
end

function ML:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Maklamos, self.Enabled)
end

function ML:Start()
	-- Create Timers
	self.Maklamos.TimersRef.Desolation = KBM.MechTimer:Add(self.Lang.Ability.Crystal[KBM.Lang], 28)
	KBM.Defaults.TimerObj.Assign(self.Maklamos)
	
	-- Create Alerts
	self.Maklamos.AlertsRef.Green = KBM.Alert:Create(self.Lang.Debuff.Green[KBM.Lang], nil, false, true, "dark_green")
	self.Maklamos.AlertsRef.Blue = KBM.Alert:Create(self.Lang.Debuff.Blue[KBM.Lang], nil, false, true, "blue")
	self.Maklamos.AlertsRef.Red = KBM.Alert:Create(self.Lang.Debuff.Red[KBM.Lang], nil, false, true, "red")
	self.Maklamos.AlertsRef.Distortion = KBM.Alert:Create(self.Lang.Debuff.Distortion[KBM.Lang], nil, false, true, "cyan")
	self.Maklamos.AlertsRef.Desolation = KBM.Alert:Create(self.Lang.Ability.Crystal[KBM.Lang], nil, true, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Maklamos)
	
	-- Create Spies
	self.Maklamos.MechRef.Distortion = KBM.MechSpy:Add(self.Lang.Debuff.Distortion[KBM.Lang], nil, "playerBuff", self.Maklamos)
	self.Maklamos.MechRef.Green = KBM.MechSpy:Add(self.Lang.Debuff.Green[KBM.Lang], nil, "playerBuff", self.Maklamos)
	self.Maklamos.MechRef.Blue = KBM.MechSpy:Add(self.Lang.Debuff.Blue[KBM.Lang], nil, "playerBuff", self.Maklamos)
	self.Maklamos.MechRef.Red = KBM.MechSpy:Add(self.Lang.Debuff.Red[KBM.Lang], nil, "playerBuff", self.Maklamos)
	KBM.Defaults.MechObj.Assign(self.Maklamos)
	
	-- Assign Alerts and Timers to Triggers
	self.Maklamos.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Maklamos)
	self.Maklamos.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Maklamos.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Maklamos)
	self.Maklamos.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Maklamos.Triggers.PhaseFour = KBM.Trigger:Create(30, "percent", self.Maklamos)
	self.Maklamos.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Maklamos.Triggers.Green = KBM.Trigger:Create(self.Lang.Debuff.Green[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Green:AddAlert(self.Maklamos.AlertsRef.Green, true)
	self.Maklamos.Triggers.Green:AddSpy(self.Maklamos.MechRef.Green)
	self.Maklamos.Triggers.GreenRem = KBM.Trigger:Create(self.Lang.Debuff.Green[KBM.Lang], "playerBuffRemove", self.Maklamos)
	self.Maklamos.Triggers.GreenRem:AddStop(self.Maklamos.AlertsRef.Green)
	self.Maklamos.Triggers.GreenRem:AddStop(self.Maklamos.MechRef.Green)
	self.Maklamos.Triggers.Blue = KBM.Trigger:Create(self.Lang.Debuff.Blue[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Blue:AddAlert(self.Maklamos.AlertsRef.Blue, true)
	self.Maklamos.Triggers.Blue:AddSpy(self.Maklamos.MechRef.Blue)
	self.Maklamos.Triggers.BlueRem = KBM.Trigger:Create(self.Lang.Debuff.Blue[KBM.Lang], "playerBuffRemove", self.Maklamos)
	self.Maklamos.Triggers.BlueRem:AddStop(self.Maklamos.AlertsRef.Blue)
	self.Maklamos.Triggers.BlueRem:AddStop(self.Maklamos.MechRef.Blue)
	self.Maklamos.Triggers.Red = KBM.Trigger:Create(self.Lang.Debuff.Red[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Red:AddAlert(self.Maklamos.AlertsRef.Red, true)
	self.Maklamos.Triggers.Red:AddSpy(self.Maklamos.MechRef.Red, true)
	self.Maklamos.Triggers.RedRem = KBM.Trigger:Create(self.Lang.Debuff.Red[KBM.Lang], "playerBuffRemove", self.Maklamos)
	self.Maklamos.Triggers.RedRem:AddStop(self.Maklamos.AlertsRef.Red)
	self.Maklamos.Triggers.RedRem:AddStop(self.Maklamos.MechRef.Red)
	self.Maklamos.Triggers.Distortion = KBM.Trigger:Create(self.Lang.Debuff.Distortion[KBM.Lang], "playerBuff", self.Maklamos)
	self.Maklamos.Triggers.Distortion:AddAlert(self.Maklamos.AlertsRef.Distortion, true)
	self.Maklamos.Triggers.Distortion:AddSpy(self.Maklamos.MechRef.Distortion)
	self.Maklamos.Triggers.Desolation = KBM.Trigger:Create(self.Lang.Ability.Crystal[KBM.Lang], "cast", self.Maklamos)
	self.Maklamos.Triggers.Desolation:AddTimer(self.Maklamos.TimersRef.Desolation)
	
	self.Maklamos.CastBar = KBM.CastBar:Add(self, self.Maklamos)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end