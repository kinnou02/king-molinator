-- Shadehorror Phantasm Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXKBSP_Settings = nil
chKBMEXKBSP_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Kings Breach"]

local MOD = {
	Directory = Instance.Directory,
	File = "Shadehorror.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Shadehorror",
	Object = "MOD",
}

MOD.Shadehorror = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Shadehorror Phantasm",
	NameShort = "Shadehorror",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U3BC9C0480EDED0FC",
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
MOD.Lang.Unit.Shadehorror = KBM.Language:Add(MOD.Shadehorror.Name)
MOD.Lang.Unit.Shadehorror:SetGerman("Schattenschrecktrugbild") 
MOD.Lang.Unit.Shadehorror:SetFrench("Chimère Ombreffroi")
MOD.Lang.Unit.Shadehorror:SetRussian("Фантазм теневого ужаса")
MOD.Lang.Unit.Shadehorror:SetKorean("어둠공포 환영")
MOD.Shadehorror.Name = MOD.Lang.Unit.Shadehorror[KBM.Lang]
MOD.Descript = MOD.Shadehorror.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Shadehorror.Name] = self.Shadehorror,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Shadehorror.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Shadehorror.Settings.TimersRef,
		-- AlertsRef = self.Shadehorror.Settings.AlertsRef,
	}
	KBMEXKBSP_Settings = self.Settings
	chKBMEXKBSP_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXKBSP_Settings = self.Settings
		self.Settings = chKBMEXKBSP_Settings
	else
		chKBMEXKBSP_Settings = self.Settings
		self.Settings = KBMEXKBSP_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXKBSP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXKBSP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXKBSP_Settings = self.Settings
	else
		KBMEXKBSP_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXKBSP_Settings = self.Settings
	else
		KBMEXKBSP_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Shadehorror.UnitID == UnitID then
		self.Shadehorror.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Shadehorror.UnitID == UnitID then
		self.Shadehorror.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Shadehorror.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Shadehorror.Dead = false
					self.Shadehorror.Casting = false
					self.Shadehorror.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Shadehorror.Name, 0, 100)
					self.Phase = 1
				end
				self.Shadehorror.UnitID = unitID
				self.Shadehorror.Available = true
				return self.Shadehorror
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Shadehorror.Available = false
	self.Shadehorror.UnitID = nil
	self.Shadehorror.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Shadehorror:SetTimers(bool)	
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

function MOD.Shadehorror:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Shadehorror, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Shadehorror)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Shadehorror)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Shadehorror.CastBar = KBM.CastBar:Add(self, self.Shadehorror)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end