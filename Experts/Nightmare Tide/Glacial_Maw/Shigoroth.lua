-- Shigoroth Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTGMSHI_Settings = nil
chKBMNTGMSHI_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Glacial_Maw"]

local MOD = {
	Directory = Instance.Directory,
	File = "Shigoroth.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "GM_Shigoroth",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Shigoroth = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Shigoroth",
	--NameShort = "Shigoroth",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U2885C3B042E2EF28",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Snowstorm = KBM.Defaults.AlertObj.Create("blue"),
	  },
	},
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Shigoroth = KBM.Language:Add(MOD.Shigoroth.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Snowstorm = KBM.Language:Add("Biting Snowstorm")
MOD.Lang.Ability.Snowstorm:SetFrench("Blizzard mordant")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.StormWarn = KBM.Language:Add("Run Around!")
MOD.Lang.Verbose.StormWarn:SetFrench("Courez!!!")
-- Notify Dictionary
MOD.Lang.Notify = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Shigoroth[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Shigoroth.Name] = self.Shigoroth,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Shigoroth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Shigoroth.Settings.AlertsRef,
	}
	KBMNTGMSHI_Settings = self.Settings
	chKBMNTGMSHI_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTGMSHI_Settings = self.Settings
		self.Settings = chKBMNTGMSHI_Settings
	else
		chKBMNTGMSHI_Settings = self.Settings
		self.Settings = KBMNTGMSHI_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTGMSHI_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTGMSHI_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTGMSHI_Settings = self.Settings
	else
		KBMNTGMSHI_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTGMSHI_Settings = self.Settings
	else
		KBMNTGMSHI_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Shigoroth.UnitID == UnitID then
		self.Shigoroth.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Shigoroth.UnitID == UnitID then
		self.Shigoroth.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Shigoroth.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Shigoroth.Dead = false
				self.Shigoroth.Casting = false
				self.Shigoroth.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Shigoroth.Name, 0, 100)
				self.Phase = 1
			end
			self.Shigoroth.UnitID = unitID
			self.Shigoroth.Available = true
			return self.Shigoroth
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Shigoroth.Available = false
	self.Shigoroth.UnitID = nil
	self.Shigoroth.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	self.Shigoroth.AlertsRef.Snowstorm = KBM.Alert:Create(self.Lang.Verbose.StormWarn[KBM.Lang], nil, true, true, "blue")
	KBM.Defaults.AlertObj.Assign(self.Shigoroth)
	
	-- Assign Alerts and Timers to Triggers
	self.Shigoroth.Triggers.Snowstorm = KBM.Trigger:Create(self.Lang.Ability.Snowstorm[KBM.Lang], "channel", self.Shigoroth)
	self.Shigoroth.Triggers.Snowstorm:AddAlert(self.Shigoroth.AlertsRef.Snowstorm)
	
	self.Shigoroth.CastBar = KBM.Castbar:Add(self, self.Shigoroth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end