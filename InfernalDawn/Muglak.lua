-- Gorlach Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDMK_Settings = nil
chKBMINDMK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local MK = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Muglak.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Muglak",
	Object = "MK",
}

MK.Muglak = {
	Mod = MK,
	Level = "??",
	Active = false,
	Name = "Muglak",
	NameShort = "Muglak",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

KBM.RegisterMod(MK.ID, MK)

-- Main Unit Dictionary
MK.Lang.Unit = {}
MK.Lang.Unit.Muglak = KBM.Language:Add(MK.Muglak.Name)
MK.Lang.Unit.Muglak:SetFrench()
MK.Lang.Unit.Muglak:SetGerman()
MK.Lang.Unit.Muglak:SetRussian("Маглак")
MK.Lang.Unit.MuglakShort = KBM.Language:Add("Muglak")
MK.Lang.Unit.MuglakShort:SetFrench()
MK.Lang.Unit.MuglakShort:SetGerman()
MK.Lang.Unit.MuglakShort:SetRussian("Маглак")

-- Ability Dictionary
MK.Lang.Ability = {}

-- Description Dictionary
MK.Lang.Main = {}
MK.Lang.Main.Descript = KBM.Language:Add("Muglak")
MK.Lang.Main.Descript:SetFrench("Muglak")
MK.Lang.Main.Descript:SetGerman("Muglak")
MK.Lang.Main.Descript:SetRussian("Маглак")
MK.Descript = MK.Lang.Main.Descript[KBM.Lang]

MK.Muglak.Name = MK.Lang.Unit.Muglak[KBM.Lang]
MK.Muglak.NameShort = MK.Lang.Unit.MuglakShort[KBM.Lang]

function MK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Muglak.Name] = self.Muglak,
	}
	KBM_Boss[self.Muglak.Name] = self.Muglak
end

function MK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Muglak.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Muglak.Settings.TimersRef,
		-- AlertsRef = self.Muglak.Settings.AlertsRef,
	}
	KBMINDMK_Settings = self.Settings
	chKBMINDMK_Settings = self.Settings
	
end

function MK:SwapSettings(bool)

	if bool then
		KBMINDMK_Settings = self.Settings
		self.Settings = chKBMINDMK_Settings
	else
		chKBMINDMK_Settings = self.Settings
		self.Settings = KBMINDMK_Settings
	end

end

function MK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDMK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDMK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDMK_Settings = self.Settings
	else
		KBMINDMK_Settings = self.Settings
	end	
end

function MK:SaveVars()	
	if KBM.Options.Character then
		chKBMINDMK_Settings = self.Settings
	else
		KBMINDMK_Settings = self.Settings
	end	
end

function MK:Castbar(units)
end

function MK:RemoveUnits(UnitID)
	if self.Muglak.UnitID == UnitID then
		self.Muglak.Available = false
		return true
	end
	return false
end

function MK:Death(UnitID)
	if self.Muglak.UnitID == UnitID then
		self.Muglak.Dead = true
		self.Muglak.CastBar:Remove()
		return true
	end
	return false
end

function MK:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Muglak.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Muglak.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Muglak.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Muglak
			end
		end
	end
end

function MK:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Muglak.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MK:Timer()	
end

function MK.Muglak:SetTimers(bool)	
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

function MK.Muglak:SetAlerts(bool)
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

function MK:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Muglak, self.Enabled)
end

function MK:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Muglak)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Muglak)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Muglak.CastBar = KBM.CastBar:Add(self, self.Muglak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end