-- Totek the Ancient Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXTITTA_Settings = nil
chKBMEXTITTA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Iron Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Totek.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Totek",
	Object = "MOD",
}

MOD.Totek = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Totek the Ancient",
	NameShort = "Totek",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "Expert",
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

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Totek = KBM.Language:Add(MOD.Totek.Name)
MOD.Lang.Unit.Totek:SetGerman("Totek der Alte") 
MOD.Lang.Unit.Totek:SetFrench("Totek l'Ancient")
MOD.Lang.Unit.Totek:SetRussian("Тотек Древний")
MOD.Lang.Unit.Totek:SetKorean("고대인 토테크")
MOD.Totek.Name = MOD.Lang.Unit.Totek[KBM.Lang]
MOD.Descript = MOD.Totek.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Totek.Name] = self.Totek,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Totek.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Totek.Settings.TimersRef,
		-- AlertsRef = self.Totek.Settings.AlertsRef,
	}
	KBMEXTITTA_Settings = self.Settings
	chKBMEXTITTA_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXTITTA_Settings = self.Settings
		self.Settings = chKBMEXTITTA_Settings
	else
		chKBMEXTITTA_Settings = self.Settings
		self.Settings = KBMEXTITTA_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXTITTA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXTITTA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXTITTA_Settings = self.Settings
	else
		KBMEXTITTA_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXTITTA_Settings = self.Settings
	else
		KBMEXTITTA_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Totek.UnitID == UnitID then
		self.Totek.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Totek.UnitID == UnitID then
		self.Totek.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Totek.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Totek.Dead = false
					self.Totek.Casting = false
					self.Totek.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Totek.Name, 0, 100)
					self.Phase = 1
				end
				self.Totek.UnitID = unitID
				self.Totek.Available = true
				return self.Totek
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Totek.Available = false
	self.Totek.UnitID = nil
	self.Totek.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Totek:SetTimers(bool)	
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

function MOD.Totek:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Totek, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Totek)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Totek)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Totek.CastBar = KBM.CastBar:Add(self, self.Totek)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end