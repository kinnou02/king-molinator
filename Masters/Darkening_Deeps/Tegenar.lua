-- Tegenar Deepfang Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMDDTD_Settings = nil
chKBMMMDDTD_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["MM_Darkening_Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Tegenar.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Tegenar",
	Object = "MOD",
}

MOD.Tegenar = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Tegenar Deepfang",
	NameShort = "Tegenar",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "none",
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
MOD.Lang.Unit.Tegenar = KBM.Language:Add(MOD.Tegenar.Name)
MOD.Lang.Unit.Tegenar:SetGerman("Tegenar Tiefzahn")
MOD.Lang.Unit.Tegenar:SetFrench("Tegenar Long-croc")
MOD.Lang.Unit.Tegenar:SetRussian("Тегенар Глубоклык")
MOD.Lang.Unit.Tegenar:SetKorean("깊은송곳니 테게나르")
MOD.Tegenar.Name = MOD.Lang.Unit.Tegenar[KBM.Lang]
MOD.Descript = MOD.Tegenar.Name
MOD.Lang.Unit.TegShort = KBM.Language:Add("Tegenar")
MOD.Lang.Unit.TegShort:SetGerman("Tegenar")
MOD.Lang.Unit.TegShort:SetFrench("Tegenar")
MOD.Lang.Unit.TegShort:SetRussian("Тегенар")
MOD.Lang.Unit.TegShort:SetKorean("테게나르")
MOD.Tegenar.NameShort = MOD.Lang.Unit.TegShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Tegenar.Name] = self.Tegenar,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Tegenar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Tegenar.Settings.TimersRef,
		-- AlertsRef = self.Tegenar.Settings.AlertsRef,
	}
	KBMMMDDTD_Settings = self.Settings
	chKBMMMDDTD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMDDTD_Settings = self.Settings
		self.Settings = chKBMMMDDTD_Settings
	else
		chKBMMMDDTD_Settings = self.Settings
		self.Settings = KBMMMDDTD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMDDTD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMDDTD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMDDTD_Settings = self.Settings
	else
		KBMMMDDTD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMDDTD_Settings = self.Settings
	else
		KBMMMDDTD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Tegenar.UnitID == UnitID then
		self.Tegenar.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Tegenar.UnitID == UnitID then
		self.Tegenar.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Tegenar.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Tegenar.Dead = false
					self.Tegenar.Casting = false
					self.Tegenar.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("Single")
					self.PhaseObj.Objectives:AddPercent(self.Tegenar.Name, 0, 100)
					self.Phase = 1
				end
				self.Tegenar.UnitID = unitID
				self.Tegenar.Available = true
				return self.Tegenar
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Tegenar.Available = false
	self.Tegenar.UnitID = nil
	self.Tegenar.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Tegenar:SetTimers(bool)	
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

function MOD.Tegenar:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Tegenar)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Tegenar)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Tegenar.CastBar = KBM.Castbar:Add(self, self.Tegenar)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end