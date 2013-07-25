-- Magma Lord Kaliban Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLGAMLK_Settings = nil
chKBMSLSLGAMLK_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GA = KBM.BossMod["SGrim_Awakening"]

local MLK = {
	Directory = GA.Directory,
	File = "MLKaliban.lua",
	Enabled = true,
	Instance = GA.Name,
	InstanceObj = GA,
	Lang = {},
	Enrage = 5 * 60,
	ID = "SMagma_Lord_Kaliban",
	Object = "MLK",
}

KBM.RegisterMod(MLK.ID, MLK)

-- Main Unit Dictionary
MLK.Lang.Unit = {}
MLK.Lang.Unit.Kaliban = KBM.Language:Add("Magma Lord Kaliban")
MLK.Lang.Unit.Kaliban:SetFrench("le Seigneur du magma Kaliban")
MLK.Lang.Unit.Kaliban:SetGerman("Magmafürst Kaliban")

MLK.Lang.Unit.KalibanShort = KBM.Language:Add("Kaliban")
MLK.Lang.Unit.KalibanShort:SetFrench("Kaliban")
MLK.Lang.Unit.KalibanShort:SetGerman("Kaliban")

-- Ability Dictionary
MLK.Lang.Ability = {}
MLK.Lang.Ability.Incantation = KBM.Language:Add("Sanguine Incantation")
MLK.Lang.Ability.Incantation:SetFrench("Incantation sanguine")
MLK.Lang.Ability.Incantation:SetGerman("Blutbeschwörung")

-- Verbose Dictionary
MLK.Lang.Verbose = {}

-- Debuff Dictionary
MLK.Lang.Debuff = {}
MLK.Lang.Debuff.Crushed = KBM.Language:Add("Crushed Armor")
MLK.Lang.Debuff.Crushed:SetFrench("Armure broyée")
MLK.Lang.Debuff.Crushed:SetGerman("Zerschmetterte Rüstung")
MLK.Lang.Debuff.CrushedID = "B5972BA5D4FC57573"
MLK.Lang.Debuff.Gaze = KBM.Language:Add("Gaze")
MLK.Lang.Debuff.Gaze:SetFrench("Regard")
MLK.Lang.Debuff.Gaze:SetGerman("Blick")
MLK.Lang.Debuff.GazeID = "B5EBCEDB6E9F1DE58"
MLK.Lang.Debuff.Shatter = KBM.Language:Add("Soul Shatter")
MLK.Lang.Debuff.Shatter:SetFrench("Brisement d'âme")
MLK.Lang.Debuff.Shatter:SetGerman("Seelenzerschmetterer")
MLK.Lang.Debuff.ShatterID = "B14ACAFFACA5B427A"
MLK.Lang.Debuff.Shattered = KBM.Language:Add("Soul Shatter")
MLK.Lang.Debuff.Shattered:SetFrench("Brisement d'âme")
MLK.Lang.Debuff.Shattered:SetGerman("Seelenzerschmetterer")
MLK.Lang.Debuff.ShatteredID = "B3BEFCBF84F96F023"
MLK.Lang.Debuff.Silenced = KBM.Language:Add("Crushing Silence")
MLK.Lang.Debuff.Silenced:SetFrench("Silence écrasant")
MLK.Lang.Debuff.Silenced:SetGerman("Zerschmetternde Stille")
MLK.Lang.Debuff.SilencedID = "B5283B687DD0CBD4D"
MLK.Lang.Debuff.Flames = KBM.Language:Add("Swirling Flames")

-- Description Dictionary
MLK.Lang.Main = {}

MLK.Descript = MLK.Lang.Unit.Kaliban[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
MLK.Kaliban = {
	Mod = MLK,
	Level = "??",
	Active = false,
	Name = MLK.Lang.Unit.Kaliban[KBM.Lang],
	NameShort = MLK.Lang.Unit.KalibanShort[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U46E963A3698AD99B",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Gaze = KBM.Defaults.TimerObj.Create("red"),
			Shatter = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Gaze = KBM.Defaults.AlertObj.Create("red"),
			Shatter = KBM.Defaults.AlertObj.Create("orange"),
			Incantation = KBM.Defaults.AlertObj.Create("yellow"),
		},
		MechRef = {
			Enabled = true,
			Gaze = KBM.Defaults.MechObj.Create("red"),
			Shatter = KBM.Defaults.MechObj.Create("orange"),
			Flames = KBM.Defaults.MechObj.Create("yellow"),
		},
	}
}


function MLK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kaliban.Name] = self.Kaliban,
	}
end

function MLK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kaliban.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Kaliban.Settings.TimersRef,
		AlertsRef = self.Kaliban.Settings.AlertsRef,
		MechRef = self.Kaliban.Settings.MechRef,
	}
	KBMSLSLGAMLK_Settings = self.Settings
	chKBMSLSLGAMLK_Settings = self.Settings
	
end

function MLK:SwapSettings(bool)

	if bool then
		KBMSLSLGAMLK_Settings = self.Settings
		self.Settings = chKBMSLSLGAMLK_Settings
	else
		chKBMSLSLGAMLK_Settings = self.Settings
		self.Settings = KBMSLSLGAMLK_Settings
	end

end

function MLK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLGAMLK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLGAMLK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLGAMLK_Settings = self.Settings
	else
		KBMSLSLGAMLK_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function MLK:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLGAMLK_Settings = self.Settings
	else
		KBMSLSLGAMLK_Settings = self.Settings
	end	
end

function MLK:Castbar(units)
end

function MLK:RemoveUnits(UnitID)
	if self.Kaliban.UnitID == UnitID then
		self.Kaliban.Available = false
		return true
	end
	return false
end

function MLK:Death(UnitID)
	if self.Kaliban.UnitID == UnitID then
		self.Kaliban.Dead = true
		return true
	end
	return false
end

function MLK:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Kaliban then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Kaliban, 0, 100)
				self.Phase = 1
				if BossObj == self.Kaliban then
					KBM.TankSwap:Start(self.Lang.Debuff.CrushedID, unitID)
				end
			else
				if BossObj == self.Kaliban then
					if not KBM.TankSwap.Active then
						KBM.TankSwap:Start(self.Lang.Debuff.CrushedID, unitID)
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Kaliban then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function MLK:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Kaliban.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MLK:Timer()	
end

function MLK:DefineMenu()
	self.Menu = GA.Menu:CreateEncounter(self.Kaliban, self.Enabled)
end

function MLK:Start()

	-- Create Timers
	self.Kaliban.TimersRef.Gaze = KBM.MechTimer:Add(self.Lang.Debuff.Gaze[KBM.Lang], 65)
	self.Kaliban.TimersRef.Shatter = KBM.MechTimer:Add(self.Lang.Debuff.Shatter[KBM.Lang], 25)
	KBM.Defaults.TimerObj.Assign(self.Kaliban)
	
	-- Create Alerts
	self.Kaliban.AlertsRef.Gaze = KBM.Alert:Create(self.Lang.Debuff.Gaze[KBM.Lang], nil, false, true, "red")
	self.Kaliban.AlertsRef.Gaze:Important()
	self.Kaliban.AlertsRef.Shatter = KBM.Alert:Create(self.Lang.Debuff.Shatter[KBM.Lang], nil, false, true, "orange")
	self.Kaliban.AlertsRef.Shatter:Important()
	self.Kaliban.AlertsRef.Incantation = KBM.Alert:Create(self.Lang.Ability.Incantation[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Kaliban)

	-- Create Spies
	self.Kaliban.MechRef.Gaze = KBM.MechSpy:Add(self.Lang.Debuff.Gaze[KBM.Lang], nil, "playerDebuff", self.Kaliban)
	self.Kaliban.MechRef.Shatter = KBM.MechSpy:Add(self.Lang.Debuff.Shatter[KBM.Lang], nil, "playerDebuff", self.Kaliban)
	KBM.Defaults.MechObj.Assign(self.Kaliban)

	-- Assign Alerts and Timers to Triggers
	self.Kaliban.Triggers.Gaze = KBM.Trigger:Create(self.Lang.Debuff.GazeID, "playerIDBuff", self.Kaliban)
	self.Kaliban.Triggers.Gaze:AddTimer(self.Kaliban.TimersRef.Gaze)
	self.Kaliban.Triggers.Gaze:AddAlert(self.Kaliban.AlertsRef.Gaze, true)
	self.Kaliban.Triggers.Gaze:AddSpy(self.Kaliban.MechRef.Gaze)

	self.Kaliban.Triggers.Shatter = KBM.Trigger:Create(self.Lang.Debuff.ShatterID, "playerIDBuff", self.Kaliban)
	self.Kaliban.Triggers.Shatter:AddTimer(self.Kaliban.TimersRef.Shatter)
	self.Kaliban.Triggers.Shatter:AddAlert(self.Kaliban.AlertsRef.Shatter, true)
	self.Kaliban.Triggers.Shatter:AddSpy(self.Kaliban.MechRef.Shatter)
	
	self.Kaliban.Triggers.Incantation = KBM.Trigger:Create(self.Lang.Ability.Incantation[KBM.Lang], "channel", self.Kaliban)
	self.Kaliban.Triggers.Incantation:AddAlert(self.Kaliban.AlertsRef.Incantation)
	self.Kaliban.Triggers.IncantationInt = KBM.Trigger:Create(self.Lang.Ability.Incantation[KBM.Lang], "interrupt", self.Kaliban)
	self.Kaliban.Triggers.IncantationInt:AddStop(self.Kaliban.AlertsRef.Incantation)
	
	self.Kaliban.CastBar = KBM.CastBar:Add(self, self.Kaliban)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end