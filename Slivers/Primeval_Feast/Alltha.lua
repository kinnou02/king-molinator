-- Alltha the Reaper Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFAR_Settings = nil
chKBMPFAR_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local AR = {
	Directory = PF.Directory,
	File = "Alltha.lua",
	Enabled = true,
	Instance = PF.Name,
	InstanceObj = PF,
	Lang = {},
	Enrage = 6 * 60,
	ID = "PF_Alltha",
	Object = "AR",
}

AR.Alltha = {
	Mod = AR,
	Level = "??",
	Active = false,
	Name = "Alltha the Reaper",
	NameShort = "Alltha",
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	SliverID = "Sliver",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		MechRef = {
			Enabled = true,
			Spore = KBM.Defaults.MechObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Spore = KBM.Defaults.AlertObj.Create("purple"),
			Fae = KBM.Defaults.AlertObj.Create("cyan"),
		},
		TimersRef = {
			Enabled = true,
			Reapers = KBM.Defaults.TimerObj.Create("red"),
			Natures = KBM.Defaults.TimerObj.Create("dark_green"),
			Fae = KBM.Defaults.TimerObj.Create("cyan"),
		},
	},
}

KBM.RegisterMod(AR.ID, AR)

-- Main Unit Dictionary
AR.Lang.Unit = {}
AR.Lang.Unit.Alltha = KBM.Language:Add(AR.Alltha.Name)
AR.Lang.Unit.Alltha:SetGerman("Alltha die Schnitterin")
AR.Lang.Unit.Alltha:SetFrench("Alltha la Faucheuse")
AR.Lang.Unit.Alltha:SetRussian("Алльта Потрошительница")
AR.Lang.Unit.AllthaShort = KBM.Language:Add("Alltha")
AR.Lang.Unit.AllthaShort:SetGerman("Alltha")
AR.Lang.Unit.AllthaShort:SetFrench("Alltha")
AR.Lang.Unit.AllthaShort:SetRussian("Алльта")

-- Ability Dictionary
AR.Lang.Ability = {}
AR.Lang.Ability.Fae = KBM.Language:Add("Fae Torrent")
AR.Lang.Ability.Fae:SetGerman("Feen-Strom")
AR.Lang.Ability.Fae:SetFrench("Torrent de fée")

-- Debuff Dictionary
AR.Lang.Debuff = {}
AR.Lang.Debuff.Spore = KBM.Language:Add("Toxic Spore")
AR.Lang.Debuff.Spore:SetFrench("Spore toxique")
AR.Lang.Debuff.Spore:SetGerman("Giftige Spore")
AR.Lang.Debuff.Spore:SetRussian("Ядовитая спора")

-- Buff Dictionary
AR.Lang.Buff = {}
AR.Lang.Buff.Reapers = KBM.Language:Add("Reaper's Rage")
AR.Lang.Buff.Reapers:SetGerman("Schnitter's Wut")
AR.Lang.Buff.Reapers:SetFrench("Force Sauvage")
AR.Lang.Buff.Natures = KBM.Language:Add("Nature's Fury")
AR.Lang.Buff.Natures:SetGerman("Zorn der Natur")
AR.Lang.Buff.Natures:SetFrench("Fureur de la nature")

-- Phase Dictionary
AR.Lang.Phase = {}
AR.Lang.Phase.Portals = KBM.Language:Add("Portals")
AR.Lang.Phase.Portals:SetGerman("Portale")
AR.Lang.Phase.Portals:SetFrench("Portails")
AR.Lang.Phase.Puddles = KBM.Language:Add("Puddles")
AR.Lang.Phase.Puddles:SetGerman("Pfützen")
AR.Lang.Phase.Puddles:SetFrench("Tornades")

AR.Alltha.Name = AR.Lang.Unit.Alltha[KBM.Lang]
AR.Alltha.NameShort = AR.Lang.Unit.AllthaShort[KBM.Lang]
AR.Descript = AR.Alltha.Name


function AR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Alltha.Name] = self.Alltha,
	}
	KBM_Boss[self.Alltha.Name] = self.Alltha	
end

function AR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Alltha.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		AlertsRef = self.Alltha.Settings.AlertsRef,
		TimersRef = self.Alltha.Settings.TimersRef,
		MechRef = self.Alltha.Settings.MechRef,
	}
	KBMPFAR_Settings = self.Settings
	chKBMPFAR_Settings = self.Settings
end

function AR:SwapSettings(bool)

	if bool then
		KBMPFAR_Settings = self.Settings
		self.Settings = chKBMPFAR_Settings
	else
		chKBMPFAR_Settings = self.Settings
		self.Settings = KBMPFAR_Settings
	end

end

function AR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFAR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFAR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFAR_Settings = self.Settings
	else
		KBMPFAR_Settings = self.Settings
	end	
end

function AR:SaveVars()	
	if KBM.Options.Character then
		chKBMPFAR_Settings = self.Settings
	else
		KBMPFAR_Settings = self.Settings
	end	
end

function AR:Castbar(units)
end

function AR.PhasePortals()
	AR.PhaseObj:SetPhase(AR.Lang.Phase.Portals[KBM.Lang])
end

function AR.PhasePuddles()
	AR.PhaseObj:SetPhase(AR.Lang.Phase.Puddles[KBM.Lang])
end

function AR:RemoveUnits(UnitID)
	if self.Alltha.UnitID == UnitID then
		self.Alltha.Available = false
		return true
	end
	return false
end

function AR:Death(UnitID)
	if self.Alltha.UnitID == UnitID then
		self.Alltha.Dead = true
		return true
	end
	return false
end

function AR:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Alltha.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Alltha.Dead = false
					self.Alltha.Casting = false
					self.Alltha.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(self.Lang.Phase.Portals[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Alltha.Name, 0, 100)
					self.Phase = 1					
				end
				self.Alltha.UnitID = unitID
				self.Alltha.Available = true
				return self.Alltha
			end
		end
	end
end

function AR:Reset()
	self.EncounterRunning = false
	self.Alltha.Available = false
	self.Alltha.UnitID = nil
	self.Alltha.Dead = false
	self.Alltha.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function AR:Timer()
	
end

function AR:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Alltha, self.Enabled)
end

function AR:Start()
	-- Create Timers
	self.Alltha.TimersRef.Natures = KBM.MechTimer:Add(self.Lang.Buff.Natures[KBM.Lang], 35)
	self.Alltha.TimersRef.Reapers = KBM.MechTimer:Add(self.Lang.Buff.Reapers[KBM.Lang], 55)
	self.Alltha.TimersRef.Fae = KBM.MechTimer:Add(self.Lang.Ability.Fae[KBM.Lang], 8)
	KBM.Defaults.TimerObj.Assign(self.Alltha)
	
	-- Create Alerts
	self.Alltha.AlertsRef.Spore = KBM.Alert:Create(self.Lang.Debuff.Spore[KBM.Lang], nil, false, true, "purple")
	self.Alltha.AlertsRef.Fae = KBM.Alert:Create(self.Lang.Ability.Fae[KBM.Lang], nil, true, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Alltha)
	
	-- Create Spies
	self.Alltha.MechRef.Spore = KBM.MechSpy:Add(self.Lang.Debuff.Spore[KBM.Lang], nil, "playerDebuff", self.Alltha)
	KBM.Defaults.MechObj.Assign(self.Alltha)
	
	-- Assign Alerts and Timers to Triggers
	self.Alltha.Triggers.Spore = KBM.Trigger:Create(self.Lang.Debuff.Spore[KBM.Lang], "playerBuff", self.Alltha)
	self.Alltha.Triggers.Spore:AddSpy(self.Alltha.MechRef.Spore)
	self.Alltha.Triggers.Spore:AddAlert(self.Alltha.AlertsRef.Spore, true)
	self.Alltha.Triggers.SporeRem = KBM.Trigger:Create(self.Lang.Debuff.Spore[KBM.Lang], "playerBuffRemove", self.Alltha)
	self.Alltha.Triggers.SporeRem:AddStop(self.Alltha.MechRef.Spore)
	self.Alltha.Triggers.Reapers = KBM.Trigger:Create(self.Lang.Buff.Reapers[KBM.Lang], "buff", self.Alltha)
	self.Alltha.Triggers.Reapers:AddTimer(self.Alltha.TimersRef.Natures)
	self.Alltha.Triggers.Reapers:AddPhase(self.PhasePortals)
	self.Alltha.Triggers.Reapers:AddTimer(self.Alltha.TimersRef.Fae)
	self.Alltha.Triggers.Natures = KBM.Trigger:Create(self.Lang.Buff.Natures[KBM.Lang], "buff", self.Alltha)
	self.Alltha.Triggers.Natures:AddTimer(self.Alltha.TimersRef.Reapers)
	self.Alltha.Triggers.Natures:AddPhase(self.PhasePuddles)
	self.Alltha.Triggers.Fae = KBM.Trigger:Create(self.Lang.Ability.Fae[KBM.Lang], "cast", self.Alltha)
	self.Alltha.Triggers.Fae:AddTimer(self.Alltha.TimersRef.Fae)
	self.Alltha.Triggers.Fae:AddAlert(self.Alltha.AlertsRef.Fae)
	
	self.Alltha.CastBar = KBM.CastBar:Add(self, self.Alltha, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end