-- Captain Black Spit Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXUCRCBS_Settings = nil
chKBMEXUCRCBS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Upper Caduceus Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Black.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Black",
	Object = "MOD",
}

MOD.Black = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Captain Black Spit",
	NameShort = "Black Spit",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U3BF107420ECE70C6",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
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
MOD.Lang.Unit.Black = KBM.Language:Add(MOD.Black.Name)
MOD.Lang.Unit.Black:SetGerman("Kapitän Schwarzspuck")
MOD.Lang.Unit.Black:SetFrench("Capitaine Crachenoir")
MOD.Lang.Unit.Black:SetRussian("Капитан Черный Плевок")
MOD.Lang.Unit.Black:SetKorean("블랙 스핏 대장")
MOD.Black.Name = MOD.Lang.Unit.Black[KBM.Lang]
MOD.Descript = MOD.Black.Name
MOD.Lang.Unit.BlackShort = KBM.Language:Add(MOD.Black.NameShort)
MOD.Lang.Unit.BlackShort:SetGerman("Schwarzspuck")
MOD.Lang.Unit.BlackShort:SetFrench("Crachenoir")
MOD.Lang.Unit.BlackShort:SetRussian("Черный Плевок")
MOD.Lang.Unit.BlackShort:SetKorean("블랙 스핏")
MOD.Black.NameShort = MOD.Lang.Unit.BlackShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Black.Name] = self.Black,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Black.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Black.Settings.TimersRef,
		-- AlertsRef = self.Black.Settings.AlertsRef,
	}
	KBMEXUCRCBS_Settings = self.Settings
	chKBMEXUCRCBS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXUCRCBS_Settings = self.Settings
		self.Settings = chKBMEXUCRCBS_Settings
	else
		chKBMEXUCRCBS_Settings = self.Settings
		self.Settings = KBMEXUCRCBS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXUCRCBS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXUCRCBS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXUCRCBS_Settings = self.Settings
	else
		KBMEXUCRCBS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXUCRCBS_Settings = self.Settings
	else
		KBMEXUCRCBS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Black.UnitID == UnitID then
		self.Black.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Black.UnitID == UnitID then
		self.Black.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Black.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Black.Dead = false
					self.Black.Casting = false
					self.Black.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Black.Name, 0, 100)
					self.Phase = 1
				end
				self.Black.UnitID = unitID
				self.Black.Available = true
				return self.Black
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Black.Available = false
	self.Black.UnitID = nil
	self.Black.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Black:SetTimers(bool)	
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

function MOD.Black:SetAlerts(bool)
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




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Black)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Black)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Black.CastBar = KBM.Castbar:Add(self, self.Black)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end