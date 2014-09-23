-- Lord Akylios Boss Mod for King Boss Mods
-- Written by Lupercal@Brisesol
-- Copyright 2011
--

KBMSLRDBAAK_Settings = nil
chKBMSLRDBAAK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local BA = KBM.BossMod["RBinding_Akylios"]

local AK = {
	Enabled = true,
	Directory = BA.Directory,
	File = "BAkylios.lua",
	Instance = BA.Name,
	InstanceObj = BA,
	HasPhases = false,
	Lang = {},
	Enrage = 60 * 9,	
	ID = "BAkylios",
	Object = "AK",
}
AK.Tyshe = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Tyshe",
	NameShort = "Tyshe",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "U5653DEB255DABD3B",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Might = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Might = KBM.Defaults.AlertObj.Create("dark_green"),
		},
		MechRef = {
			Enabled = true,
			Might = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}
AK.Akylios = {
	Mod = AK,
	Level = "??",
	Active = false,
	Name = "Akylios",
	NameShort = "Akylios",
	Menu = {},
	Castbar = nil,
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "U0A9B5BE40D45199A",
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			Breath = KBM.Defaults.TimerObj.Create("red"),
			Tsunami = KBM.Defaults.TimerObj.Create("purple"),
			BreathOne = KBM.Defaults.TimerObj.Create("red"),
			TsunamiOne = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Breath = KBM.Defaults.AlertObj.Create("red"),
			Tsunami = KBM.Defaults.AlertObj.Create("purple"),
			BreathOne = KBM.Defaults.AlertObj.Create("red"),
			TsunamiOne = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Breath = KBM.Defaults.MechObj.Create("red"),
			Tsunami = KBM.Defaults.MechObj.Create("purple"),
			BreathOne = KBM.Defaults.MechObj.Create("red"),
			TsunamiOne = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

KBM.RegisterMod(AK.ID, AK)

-- Main Unit Dictionary
AK.Lang.Unit = {}
AK.Lang.Unit.Akylios = KBM.Language:Add(AK.Akylios.Name)
AK.Lang.Unit.Akylios:SetFrench("Akylios")
AK.Lang.Unit.Tyshe = KBM.Language:Add(AK.Tyshe.Name)
AK.Lang.Unit.Tyshe:SetFrench("Tyshe")

-- Ability Dictionary
AK.Lang.Ability = {}
-- AK.Lang.Ability.Waves = KBM.Language:Add("Strangling Blight")
-- AK.Lang.Ability.Waves:SetFrench("Marées de la démence")
AK.Lang.Ability.Breath = KBM.Language:Add("Ruthless Undertow")
AK.Lang.Ability.Breath:SetFrench("Reflux impitoyable")
AK.Lang.Ability.Tsunami = KBM.Language:Add("Tsunami of Obliteration")
AK.Lang.Ability.Tsunami:SetFrench("Tsunami d'oblitération")
AK.Lang.Ability.Might = KBM.Language:Add("Might of the Leviathan")
AK.Lang.Ability.Might:SetFrench("Puissance du Léviathan")

--Mechanic Dictionary (Verbose)
AK.Lang.Mechanic = {}
AK.Lang.Mechanic.Wave = KBM.Language:Add("Tidal Wave")
AK.Lang.Mechanic.Wave:SetGerman("Flutwelle")
AK.Lang.Mechanic.Wave:SetRussian("Приливная волна")
AK.Lang.Mechanic.Wave:SetFrench("Raz de marée")

AK.Lang.Say = {}
AK.Lang.Say.Waves = KBM.Language:Add("Akylios' tentacle trashes about creating a flurry of waves.")
AK.Lang.Say.Waves:SetFrench("Le tentacule d'Akylios s'emporte et crée une rafale de vagues.")
AK.Lang.Say.Immerge = KBM.Language:Add("Akylios' tentacle trashes about creating a flurry of waves.")
AK.Lang.Say.Immerge:SetFrench("Le tentacule d'Akylios s'emporte et crée une rafale de vagues.")

AK.Akylios.Name = AK.Lang.Unit.Akylios[KBM.Lang]
AK.Descript = AK.Akylios.Name

function AK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Tyshe.Name] = self.Tyshe,
		[self.Akylios.Name] = self.Akylios,
	}
end

function AK:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = {
			Override = true,
			Multi = true,
		},
		Akylios = {
			CastBar = AK.Akylios.Settings.CastBar,
			TimersRef = AK.Akylios.Settings.TimersRef,
			AlertsRef = AK.Akylios.Settings.AlertsRef,
			MechRef = AK.Akylios.Settings.MechRef,
		},
		Tyshe = {
			CastBar = AK.Tyshe.Settings.CastBar,
			TimersRef = AK.Tyshe.Settings.TimersRef,
			AlertsRef = AK.Tyshe.Settings.AlertsRef,
			MechRef = AK.Tyshe.Settings.MechRef,
		},
	}
	KBMSLRDBAAK_Settings = self.Settings
	chKBMSLRDBAAK_Settings = self.Settings	
end

function AK:SwapSettings(bool)
	if bool then
		KBMSLRDBAAK_Settings = self.Settings
		self.Settings = chKBMSLRDBAAK_Settings
	else
		chKBMSLRDBAAK_Settings = self.Settings
		self.Settings = KBMSLRDBAAK_Settings
	end
end

function AK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDBAAK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDBAAK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDBAAK_Settings = self.Settings
	else
		KBMSLRDBAAK_Settings = self.Settings
	end	
end

function AK:SaveVars()	
	if KBM.Options.Character then
		chKBMSLRDBAAK_Settings = self.Settings
	else
		KBMSLRDBAAK_Settings = self.Settings
	end	
end

function AK:Castbar(units)
end

function AK:RemoveUnits(UnitID)
	if self.Akylios.UnitID == UnitID then
		self.Akylios.Available = false
		return true
	end
	return false
end

function AK:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if uDetails.name == self.Tyshe.Name then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.PhaseObj:Start(self.StartTime)
						self.Phase = 1
						self.LastPhase = 1
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.Tyshe, 0, 100)
					end
					self.Tyshe.Casting = false
					self.Tyshe.UnitID = unitID
					self.Tyshe.Available = true
					return self.Tyshe
				elseif uDetails.name == self.Akylios.Name then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Akylios.CastBar:Create(unitID)
					self.PhaseObj.Objectives:AddPercent(self.Akylios, 0, 100)
					KBM.MechTimer:AddStart(self.Akylios.TimersRef.BreathOne)
					KBM.MechTimer:AddStart(self.Akylios.TimersRef.TsunamiOne)
					if not self.Akylios.UnitID then
						self.Akylios.CastBar:Create(unitID)
					end
					self.Akylios.Casting = false
					self.Akylios.UnitID = unitID
					self.Akylios.Available = true
					return self.Akylios
				elseif self.EncounterRunning then
					self.Bosses[uDetails.name].UnitList[unitID].Available = true
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
					return self.Bosses[uDetails.name].UnitList[unitID]
				end
			end
		end
	end
end

function AK:Death(UnitID)
	if self.Akylios.UnitID == UnitID then
		self.Akylios.Dead = true
	end
	if self.Tyshe.UnitID == UnitID then
		self.Tyshe.Dead = true
	end
	if self.Akylios.Dead and self.Tyshe.Dead then
		return true
	end
	return false
end

function AK:Reset()
	self.EncounterRunning = false
	self.Akylios.Available = false
	self.Akylios.UnitID = nil
	self.Akylios.CastBar:Remove()
	self.Tyshe.Available = false
	self.Tyshe.UnitID = nil
	self.Tyshe.CastBar:Remove()
	self.Akylios.Dead = false
	self.Tyshe.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
end

function AK:Timer()	
end

function AK:DefineMenu()
	self.Menu = BA.Menu:CreateEncounter(self.Akylios, self.Enabled)
end

function AK:Start()

	-- Akylios
	self.Akylios.TimersRef.BreathOne = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 30)
	self.Akylios.TimersRef.TsunamiOne = KBM.MechTimer:Add(AK.Lang.Ability.Tsunami[KBM.Lang], 45)
	self.Akylios.TimersRef.Breath = KBM.MechTimer:Add(AK.Lang.Ability.Breath[KBM.Lang], 30)
	self.Akylios.TimersRef.Tsunami = KBM.MechTimer:Add(AK.Lang.Ability.Tsunami[KBM.Lang], 60)
	
	self.Akylios.AlertsRef.BreathOne = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], nil, true, true, "red")
	self.Akylios.AlertsRef.TsunamiOne = KBM.Alert:Create(AK.Lang.Ability.Tsunami[KBM.Lang], nil, true, true, "purple")
	self.Akylios.AlertsRef.Breath = KBM.Alert:Create(AK.Lang.Ability.Breath[KBM.Lang], nil, true, true, "red")
	self.Akylios.AlertsRef.Tsunami = KBM.Alert:Create(AK.Lang.Ability.Tsunami[KBM.Lang], nil, true, true, "purple")
	
	self.Akylios.Triggers.BreathOne	= KBM.Trigger:Create(AK.Lang.Ability.Breath[KBM.Lang], "channel", self.Akylios)
	self.Akylios.Triggers.BreathOne:AddAlert(AK.Akylios.AlertsRef.Breath)
	self.Akylios.Triggers.Breath = KBM.Trigger:Create(AK.Lang.Ability.Breath[KBM.Lang], "channel", self.Akylios)
	self.Akylios.Triggers.Breath:AddTimer(AK.Akylios.TimersRef.Breath)
	self.Akylios.Triggers.Breath:AddAlert(AK.Akylios.AlertsRef.Breath)
	
	self.Akylios.Triggers.TsunamiOne = KBM.Trigger:Create(AK.Lang.Ability.Tsunami[KBM.Lang], "channel", self.Akylios)
	self.Akylios.Triggers.TsunamiOne:AddAlert(AK.Akylios.AlertsRef.Tsunami)
	self.Akylios.Triggers.Tsunami = KBM.Trigger:Create(AK.Lang.Ability.Tsunami[KBM.Lang], "channel", self.Akylios)
	self.Akylios.Triggers.Tsunami:AddTimer(AK.Akylios.TimersRef.Tsunami)
	self.Akylios.Triggers.Tsunami:AddAlert(AK.Akylios.AlertsRef.Tsunami)

	KBM.Defaults.TimerObj.Assign(AK.Akylios)
	KBM.Defaults.AlertObj.Assign(self.Akylios)
	self.Akylios.CastBar = KBM.Castbar:Add(self, self.Akylios)
	
	-- Tyshe
	self.Tyshe.TimersRef.Might = KBM.MechTimer:Add(AK.Lang.Ability.Might[KBM.Lang], 60)
	self.Tyshe.AlertsRef.Might = KBM.Alert:Create(AK.Lang.Ability.Might[KBM.Lang], nil,false, true, "dark_green")
	self.Tyshe.Triggers.Might = KBM.Trigger:Create(AK.Lang.Ability.Might[KBM.Lang], "cast", self.Tyshe)
	self.Tyshe.Triggers.Might:AddTimer(self.Tyshe.TimersRef.Might)
	self.Tyshe.Triggers.Might:AddAlert(self.Tyshe.AlertsRef.Might)
	KBM.Defaults.AlertObj.Assign(self.Tyshe)
	KBM.Defaults.TimerObj.Assign(self.Tyshe)
	self.Tyshe.CastBar = KBM.Castbar:Add(self, self.Tyshe)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end