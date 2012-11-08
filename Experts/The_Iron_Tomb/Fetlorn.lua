-- Bonelord Fetlorn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTITBF_Settings = nil
chKBMEXTITBF_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Iron Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Fetlorn.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Fetlorn",
	Object = "MOD",
}

MOD.Fetlorn = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Bonelord Fetlorn",
	NameShort = "Fetlorn",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U2FB196D076D553D2",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Fetlorn = KBM.Language:Add(MOD.Fetlorn.Name)
MOD.Lang.Unit.Fetlorn:SetGerman("Knochenlord Fetlorn")
MOD.Lang.Unit.Fetlorn:SetFrench("Seigner des ossements Fetlorn")
MOD.Lang.Unit.Fetlorn:SetRussian("Костяной владыка Фетлорн")
MOD.Lang.Unit.Fetlorn:SetKorean("해골군주 펫론")
MOD.Fetlorn.Name = MOD.Lang.Unit.Fetlorn[KBM.Lang]
MOD.Descript = MOD.Fetlorn.Name
MOD.Lang.Unit.FetShort = KBM.Language:Add("Fetlorn")
MOD.Lang.Unit.FetShort:SetGerman("Fetlorn")
MOD.Lang.Unit.FetShort:SetFrench("Fetlorn")
MOD.Lang.Unit.FetShort:SetRussian("Фетлорн")
MOD.Lang.Unit.FetShort:SetKorean("펫론")
MOD.Fetlorn.NameShort = MOD.Lang.Unit.FetShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Fetlorn.Name] = self.Fetlorn,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Fetlorn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Fetlorn.Settings.TimersRef,
		-- AlertsRef = self.Fetlorn.Settings.AlertsRef,
	}
	KBMEXTITBF_Settings = self.Settings
	chKBMEXTITBF_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXTITBF_Settings = self.Settings
		self.Settings = chKBMEXTITBF_Settings
	else
		chKBMEXTITBF_Settings = self.Settings
		self.Settings = KBMEXTITBF_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXTITBF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXTITBF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXTITBF_Settings = self.Settings
	else
		KBMEXTITBF_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXTITBF_Settings = self.Settings
	else
		KBMEXTITBF_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Fetlorn.UnitID == UnitID then
		self.Fetlorn.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Fetlorn.UnitID == UnitID then
		self.Fetlorn.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Fetlorn.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Fetlorn.Dead = false
					self.Fetlorn.Casting = false
					self.Fetlorn.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Fetlorn.Name, 0, 100)
					self.Phase = 1
				end
				self.Fetlorn.UnitID = unitID
				self.Fetlorn.Available = true
				return self.Fetlorn
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Fetlorn.Available = false
	self.Fetlorn.UnitID = nil
	self.Fetlorn.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Fetlorn:SetTimers(bool)	
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

function MOD.Fetlorn:SetAlerts(bool)
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

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Fetlorn, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Fetlorn)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Fetlorn)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Fetlorn.CastBar = KBM.CastBar:Add(self, self.Fetlorn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end