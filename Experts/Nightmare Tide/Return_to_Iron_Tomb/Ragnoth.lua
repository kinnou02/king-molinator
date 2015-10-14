-- Ragnoth the Despoiler Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTITRD_Settings = nil
chKBMNTRTITRD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["RTIron_Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Ragnoth.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NT_Ragnoth",
	Object = "MOD",
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Ragnoth = KBM.Language:Add("Nightmare Ragnoth")
MOD.Lang.Unit.Ragnoth:SetFrench("Ragnoth cauchemardesque")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Torrent = KBM.Language:Add("Torrent of Ragnoth")
MOD.Lang.Ability.Torrent:SetFrench("Torrent de Ragnoth")

-- Verbose Dictionary 
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.TorrentWarn = KBM.Language:Add("Get to a safe zone!")
MOD.Lang.Verbose.TorrentWarn:SetFrench("Allez dans la zone safe!!!")

MOD.Descript = MOD.Lang.Unit.Ragnoth[KBM.Lang]

MOD.Ragnoth = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Ragnoth[KBM.Lang],
	NameShort = "Ragnoth",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "U465F0BD90485B649",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
      Enabled = true,
      Torrent = KBM.Defaults.AlertObj.Create("blue"),
    },
	}
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ragnoth.Name] = self.Ragnoth,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Ragnoth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Ragnoth.Settings.TimersRef,
		AlertsRef = self.Ragnoth.Settings.AlertsRef,
	}
	KBMNTRTITRD_Settings = self.Settings
	chKBMNTRTITRD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTITRD_Settings = self.Settings
		self.Settings = chKBMNTRTITRD_Settings
	else
		chKBMNTRTITRD_Settings = self.Settings
		self.Settings = KBMNTRTITRD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTITRD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTITRD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTITRD_Settings = self.Settings
	else
		KBMNTRTITRD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTITRD_Settings = self.Settings
	else
		KBMNTRTITRD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Ragnoth.UnitID == UnitID then
		self.Ragnoth.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Ragnoth.UnitID == UnitID then
		self.Ragnoth.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Ragnoth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Ragnoth.Dead = false
					self.Ragnoth.Casting = false
					self.Ragnoth.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Ragnoth.Name, 0, 100)
					self.Phase = 1
				end
				self.Ragnoth.UnitID = unitID
				self.Ragnoth.Available = true
				return self.Ragnoth
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Ragnoth.Available = false
	self.Ragnoth.UnitID = nil
	self.Ragnoth.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Ragnoth:SetTimers(bool)	
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

function MOD.Ragnoth:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Ragnoth)
	
	-- Create Alerts
  self.Ragnoth.AlertsRef.Torrent = KBM.Alert:Create(self.Lang.Verbose.TorrentWarn[KBM.Lang], nil, true, true, "blue")
  KBM.Defaults.AlertObj.Assign(self.Ragnoth)
  
  -- Assign Alerts and Timers to Triggers
  self.Ragnoth.Triggers.Torrent = KBM.Trigger:Create(self.Lang.Ability.Torrent[KBM.Lang], "cast", self.Ragnoth)
  self.Ragnoth.Triggers.Torrent:AddAlert(self.Ragnoth.AlertsRef.Torrent)
	
	self.Ragnoth.CastBar = KBM.Castbar:Add(self, self.Ragnoth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end