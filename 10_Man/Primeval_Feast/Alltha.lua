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
	-- TimersRef = {},
	MechRef = {},
	Available = false,
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

-- Debuff Dictionary
AR.Lang.Debuff = {}
AR.Lang.Debuff.Spore = KBM.Language:Add("Toxic Spore")
AR.Lang.Debuff.Spore:SetFrench("Spore toxique")
AR.Lang.Debuff.Spore:SetGerman("Giftige Spore")
AR.Lang.Debuff.Spore:SetRussian("Ядовитая спора")
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
		Alerts = KBM.Defaults.Alerts(),
		AlertsRef = self.Alltha.Settings.AlertsRef,
		-- TimersRef = self.Alltha.Settings.TimersRef,
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
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
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

function AR.Alltha:SetTimers(bool)	
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

function AR.Alltha:SetAlerts(bool)
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

function AR:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Alltha, self.Enabled)
end

function AR:Start()
	-- Create Timers

	-- Create Alerts
	self.Alltha.AlertsRef.Spore = KBM.Alert:Create(self.Lang.Debuff.Spore[KBM.Lang], nil, false, true, "purple")
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
	
	self.Alltha.CastBar = KBM.CastBar:Add(self, self.Alltha, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end