-- Toknoth Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTGMTOK_Settings = nil
chKBMNTGMTOK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Glacial_Maw"]

local MOD = {
	Directory = Instance.Directory,
	File = "Toknoth.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "GM_Toknoth",
	Object = "MOD",
	--Enrage = 5*60,
}

MOD.Toknoth = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Toknoth",
	--NameShort = "Toknoth",
	Menu = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U6B33D4A4757F70A7",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		MechRef = {
      Enabled = true,
      Chest = KBM.Defaults.MechObj.Create("purple"),
    },
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Toknoth = KBM.Language:Add(MOD.Toknoth.Name)

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Notify Dictionary
MOD.Lang.Notify = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Chest = KBM.Language:Add("Chest Borer")
MOD.Lang.Debuff.Chest:SetFrench("Creuse-thorax")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Toknoth[KBM.Lang]

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Toknoth.Name] = self.Toknoth,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Toknoth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Toknoth.Settings.AlertsRef,
		MechRef = self.Toknoth.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMNTGMTOK_Settings = self.Settings
	chKBMNTGMTOK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTGMTOK_Settings = self.Settings
		self.Settings = chKBMNTGMTOK_Settings
	else
		chKBMNTGMTOK_Settings = self.Settings
		self.Settings = KBMNTGMTOK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTGMTOK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTGMTOK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTGMTOK_Settings = self.Settings
	else
		KBMNTGMTOK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTGMTOK_Settings = self.Settings
	else
		KBMNTGMTOK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Toknoth.UnitID == UnitID then
		self.Toknoth.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Toknoth.UnitID == UnitID then
		self.Toknoth.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Toknoth.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Toknoth.Dead = false
				self.Toknoth.Casting = false
				self.Toknoth.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Toknoth.Name, 0, 100)
				self.Phase = 1
			end
			self.Toknoth.UnitID = unitID
			self.Toknoth.Available = true
			return self.Toknoth
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Toknoth.Available = false
	self.Toknoth.UnitID = nil
	self.Toknoth.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Toknoth)
	
	-- Create Mechanic Spy
	self.Toknoth.MechRef.Chest = KBM.MechSpy:Add(self.Lang.Debuff.Chest[KBM.Lang], nil, "playerDebuff", self.Toknoth)
  KBM.Defaults.MechObj.Assign(self.Toknoth)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Toknoth)
	
	-- Assign Alerts and Timers to Triggers
	self.Toknoth.Triggers.Chest = KBM.Trigger:Create(self.Lang.Debuff.Chest[KBM.Lang], "playerBuff", self.Toknoth)
  self.Toknoth.Triggers.Chest:AddSpy(self.Toknoth.MechRef.Chest)
	
	self.Toknoth.CastBar = KBM.Castbar:Add(self, self.Toknoth)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end