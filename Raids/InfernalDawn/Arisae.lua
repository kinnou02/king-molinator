-- Arisae the Scryer Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDML_Settings = nil
chKBMINDML_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local ML = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Arisae.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Arisae",
	Object = "ML",
	Enrage = 8 * 60,
}

ML.Arisae = {
	Mod = ML,
	Level = "??",
	Active = false,
	Name = "Arisae",
	NameShort = "Arisae",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 1000,
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
ML.Lang.Unit.Arisae = KBM.Language:Add(ML.Arisae.Name)
ML.Lang.Unit.MakShort = KBM.Language:Add("Arisae")
ML.Lang.Unit.Jug = KBM.Language:Add("Ruthless Juggernaut")
ML.Lang.Unit.Jug:SetGerman("Rücksichtsloser Gigant")
ML.Lang.Unit.Jug:SetFrench("Mastodonte implacable")
ML.Lang.Unit.JugShort = KBM.Language:Add("Juggernaut")
ML.Lang.Unit.JugShort:SetGerman("Gigant")
ML.Lang.Unit.JugShort:SetFrench("Mastodonte")
ML.Lang.Unit.MonJug = KBM.Language:Add("Monstrous Juggernaut")
ML.Lang.Unit.MonJug:SetGerman("Monströser Gigant")
ML.Lang.Unit.MonJug:SetFrench("Mastodonte monstrueux")
ML.Lang.Unit.MonShort = KBM.Language:Add("Monstrous")
ML.Lang.Unit.MonShort:SetGerman("Monströser")
ML.Lang.Unit.MonShort:SetFrench("Monstrueux")
ML.Lang.Unit.MerJug = KBM.Language:Add("Merciless Juggernaut")
ML.Lang.Unit.MerJug:SetGerman("Gnadenloser Gigant")
ML.Lang.Unit.MerJug:SetFrench("Mastodonte impitoyable")
ML.Lang.Unit.MerShort = KBM.Language:Add("Merciless")
ML.Lang.Unit.MerShort:SetGerman("Gnadenloser")
ML.Lang.Unit.MerShort:SetFrench("Impitoyable")

-- Ability Dictionary
ML.Lang.Ability = {}
ML.Lang.Ability.Power = KBM.Language:Add("Returning Power")
ML.Lang.Ability.Power:SetGerman("Wiederkehrende Kraft")
ML.Lang.Ability.Power:SetFrench("Restitution de pouvoir")
ML.Lang.Ability.Crystal = KBM.Language:Add("Crystalline Desolation")
ML.Lang.Ability.Crystal:SetGerman("Kristallöde") 
ML.Lang.Ability.Crystal:SetFrench("Désolation cristalline")

-- Debuff Dictionary
ML.Lang.Debuff = {}
ML.Lang.Debuff.Nature = KBM.Language:Add("Spiritual Deficiency")
ML.Lang.Debuff.Nature:SetGerman("Gespaltene Natur")
ML.Lang.Debuff.Nature:SetFrench("Nature fracturée")
ML.Lang.Debuff.Green = KBM.Language:Add("Emerald Crystal Essence")
ML.Lang.Debuff.Green:SetGerman("Smaragdkristallessenz")
ML.Lang.Debuff.Green:SetFrench("Essence de cristal d'émeraude")
ML.Lang.Debuff.Blue = KBM.Language:Add("Azure Crystal Essence")
ML.Lang.Debuff.Blue:SetGerman("Azurkristall-Essenz")
ML.Lang.Debuff.Blue:SetFrench("Essence de cristal azur")
ML.Lang.Debuff.Red = KBM.Language:Add("Scarlet Crystal Essence")
ML.Lang.Debuff.Red:SetGerman("Essenz des feuerroten Kristalls")
ML.Lang.Debuff.Red:SetFrench("Essence de cristal écarlate")
ML.Lang.Debuff.Distortion = KBM.Language:Add("Crystalline Distortion")
ML.Lang.Debuff.Distortion:SetGerman("Kristallverzerrung")
ML.Lang.Debuff.Distortion:SetFrench("Distorsion cristalline")
ML.Lang.Debuff.Weak = KBM.Language:Add("Vex")

ML.Arisae.Name = ML.Lang.Unit.Arisae[KBM.Lang]
ML.Arisae.NameShort = ML.Lang.Unit.MakShort[KBM.Lang]
ML.Descript = ML.Arisae.Name

ML.Jug = {
	Mod = ML,
	Level = "??",
	Name = ML.Lang.Unit.Jug[KBM.Lang],
	NameShort = ML.Lang.Unit.JugShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
}

function ML:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Arisae.Name] = self.Arisae,
	}
	KBM_Boss[self.Arisae.Name] = self.Arisae
end

function ML:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arisae.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Arisae.Settings.TimersRef,
		AlertsRef = self.Arisae.Settings.AlertsRef,
		MechRef = self.Arisae.Settings.MechRef,
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
	if self.Arisae.UnitID == UnitID then
		self.Arisae.Available = false
		return true
	end
	return false
end

function ML.PhaseTwo()
	ML.Phase = 2
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(2)
	ML.PhaseObj.Objectives:AddPercent(ML.Arisae.Name, 50, 80)	
end

function ML.PhaseThree()
	ML.Phase = 3
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(3)
	ML.PhaseObj.Objectives:AddPercent(ML.Arisae.Name, 30, 50)
end

function ML.PhaseFour()
	ML.Phase = 4
	ML.PhaseObj.Objectives:Remove()
	ML.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	ML.PhaseObj.Objectives:AddPercent(ML.Arisae.Name, 0, 30)	
end

function ML:Death(UnitID)
	if self.Arisae.UnitID == UnitID then
		self.Arisae.Dead = true
		return true
	end
	return false
end

function ML:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		--if not uDetails.player then
			if uDetails.name == self.Arisae.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arisae.Dead = false
					self.Arisae.Casting = false
					self.Arisae.CastBar:Create(unitID)
					-- local DebuffTable = {
						-- [1] = self.Lang.Debuff.Nature[KBM.Lang],
						-- [2] = self.Lang.Debuff.Weak[KBM.Lang],
					-- }
					--KBM.TankSwap:Start(DebuffTable, unitID, 2)
					KBM.TankSwap:Start(self.Lang.Debuff.Nature[KBM.Lang], unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Arisae.Name, 80, 100)
					self.Phase = 1
				end
				self.Arisae.UnitID = unitID
				self.Arisae.Available = true
				return self.Arisae
			end
		--end
	end
end

function ML:Reset()
	self.EncounterRunning = false
	self.Arisae.Available = false
	self.Arisae.UnitID = nil
	self.Arisae.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function ML:Timer()	
end

function ML.Arisae:SetTimers(bool)	
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

function ML.Arisae:SetAlerts(bool)
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

function ML:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Arisae, self.Enabled)
end

function ML:Start()
	-- Create Timers
	self.Arisae.TimersRef.Desolation = KBM.MechTimer:Add(self.Lang.Ability.Crystal[KBM.Lang], 40)
	KBM.Defaults.TimerObj.Assign(self.Arisae)
	
	-- Create Alerts
	self.Arisae.AlertsRef.Green = KBM.Alert:Create(self.Lang.Debuff.Green[KBM.Lang], nil, false, true, "dark_green")
	self.Arisae.AlertsRef.Blue = KBM.Alert:Create(self.Lang.Debuff.Blue[KBM.Lang], nil, false, true, "blue")
	self.Arisae.AlertsRef.Red = KBM.Alert:Create(self.Lang.Debuff.Red[KBM.Lang], nil, false, true, "red")
	self.Arisae.AlertsRef.Distortion = KBM.Alert:Create(self.Lang.Debuff.Distortion[KBM.Lang], nil, false, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Arisae)
	
	-- Create Spies
	self.Arisae.MechRef.Distortion = KBM.MechSpy:Add(self.Lang.Debuff.Distortion[KBM.Lang], nil, "playerBuff", self.Arisae)
	self.Arisae.MechRef.Green = KBM.MechSpy:Add(self.Lang.Debuff.Green[KBM.Lang], nil, "playerBuff", self.Arisae)
	self.Arisae.MechRef.Blue = KBM.MechSpy:Add(self.Lang.Debuff.Blue[KBM.Lang], nil, "playerBuff", self.Arisae)
	self.Arisae.MechRef.Red = KBM.MechSpy:Add(self.Lang.Debuff.Red[KBM.Lang], nil, "playerBuff", self.Arisae)
	KBM.Defaults.MechObj.Assign(self.Arisae)
	
	-- Assign Alerts and Timers to Triggers
	self.Arisae.Triggers.PhaseTwo = KBM.Trigger:Create(80, "percent", self.Arisae)
	self.Arisae.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Arisae.Triggers.PhaseThree = KBM.Trigger:Create(50, "percent", self.Arisae)
	self.Arisae.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Arisae.Triggers.PhaseFour = KBM.Trigger:Create(30, "percent", self.Arisae)
	self.Arisae.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Arisae.Triggers.Green = KBM.Trigger:Create(self.Lang.Debuff.Green[KBM.Lang], "playerBuff", self.Arisae)
	self.Arisae.Triggers.Green:AddAlert(self.Arisae.AlertsRef.Green, true)
	self.Arisae.Triggers.Green:AddSpy(self.Arisae.MechRef.Green)
	self.Arisae.Triggers.GreenRem = KBM.Trigger:Create(self.Lang.Debuff.Green[KBM.Lang], "playerBuffRemove", self.Arisae)
	self.Arisae.Triggers.GreenRem:AddStop(self.Arisae.AlertsRef.Green)
	self.Arisae.Triggers.GreenRem:AddStop(self.Arisae.MechRef.Green)
	self.Arisae.Triggers.Blue = KBM.Trigger:Create(self.Lang.Debuff.Blue[KBM.Lang], "playerBuff", self.Arisae)
	self.Arisae.Triggers.Blue:AddAlert(self.Arisae.AlertsRef.Blue, true)
	self.Arisae.Triggers.Blue:AddSpy(self.Arisae.MechRef.Blue)
	self.Arisae.Triggers.BlueRem = KBM.Trigger:Create(self.Lang.Debuff.Blue[KBM.Lang], "playerBuffRemove", self.Arisae)
	self.Arisae.Triggers.BlueRem:AddStop(self.Arisae.AlertsRef.Blue)
	self.Arisae.Triggers.BlueRem:AddStop(self.Arisae.MechRef.Blue)
	self.Arisae.Triggers.Red = KBM.Trigger:Create(self.Lang.Debuff.Red[KBM.Lang], "playerBuff", self.Arisae)
	self.Arisae.Triggers.Red:AddAlert(self.Arisae.AlertsRef.Red, true)
	self.Arisae.Triggers.Red:AddSpy(self.Arisae.MechRef.Red, true)
	self.Arisae.Triggers.RedRem = KBM.Trigger:Create(self.Lang.Debuff.Red[KBM.Lang], "playerBuffRemove", self.Arisae)
	self.Arisae.Triggers.RedRem:AddStop(self.Arisae.AlertsRef.Red)
	self.Arisae.Triggers.RedRem:AddStop(self.Arisae.MechRef.Red)
	self.Arisae.Triggers.Distortion = KBM.Trigger:Create(self.Lang.Debuff.Distortion[KBM.Lang], "playerBuff", self.Arisae)
	self.Arisae.Triggers.Distortion:AddAlert(self.Arisae.AlertsRef.Distortion, true)
	self.Arisae.Triggers.Distortion:AddSpy(self.Arisae.MechRef.Distortion)
	self.Arisae.Triggers.Desolation = KBM.Trigger:Create(self.Lang.Ability.Crystal[KBM.Lang], "cast", self.Arisae)
	self.Arisae.Triggers.Desolation:AddTimer(self.Arisae.TimersRef.Desolation)
	
	self.Arisae.CastBar = KBM.CastBar:Add(self, self.Arisae)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end