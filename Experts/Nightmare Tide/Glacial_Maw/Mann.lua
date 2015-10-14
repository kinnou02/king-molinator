-- Cosmologist Mann Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTGMMAN_Settings = nil
chKBMNTGMMAN_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Glacial_Maw"]

local MOD = {
	Directory = Instance.Directory,
	File = "Mann.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "GM_Mann",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Mann = KBM.Language:Add("Cosmologist Mann")
MOD.Lang.Unit.Mann:SetFrench("Cosmologiste Mann")
MOD.Lang.Unit.Heart = KBM.Language:Add("Heart of Izbithu")
MOD.Lang.Unit.Heart:SetFrench("Cœur d'Izbithu")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Soulstorm = KBM.Language:Add("Soul Storm")
MOD.Lang.Ability.Soulstorm:SetFrench("Tempête d'âmes")
MOD.Lang.Ability.Grip = KBM.Language:Add("Icy Grip")
MOD.Lang.Ability.Grip:SetFrench("Emprise glaciale")
MOD.Lang.Ability.Frost = KBM.Language:Add("Frost Bite")
MOD.Lang.Ability.Frost:SetFrench("Morsure du gel")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Notify Dictionary
MOD.Lang.Notify = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Mann[KBM.Lang] .." & "..MOD.Lang.Unit.Heart[KBM.Lang]

MOD.Mann = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Mann[KBM.Lang],
	NameShort = "Mann",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U352293BC6D7FA0E0",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Grip = KBM.Defaults.AlertObj.Create("red"),
		  Frost = KBM.Defaults.AlertObj.Create("cyan"),
		},
	},
}

MOD.Heart = {
  Mod = MOD,
  Level = "??",
  Active = false,
  Name = MOD.Lang.Unit.Heart[KBM.Lang],
  --NameShort = "Heart",
  Menu = {},
  AlertsRef = {},
  Castbar = nil,
  Dead = false,
  Available = false,
  UnitID = nil,
  UTID = "U5C06C5363E198E74",
  TimeOut = 5,
  Triggers = {},
  Settings = {
    CastBar = KBM.Defaults.Castbar(),
    AlertsRef = {
      Enabled = true,
      Soulstorm = KBM.Defaults.AlertObj.Create("purple"),
    },
  },
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Mann.Name] = self.Mann,
		[self.Heart.Name] = self.Heart,
	}	
		for BossName, BossObj in pairs(self.Bosses) do
    if BossObj.Settings then
      if BossObj.Settings.CastBar then
        BossObj.Settings.CastBar.Override = true
        BossObj.Settings.CastBar.Multi = true
      end
    end
  end
end

function MOD:InitVars()
	self.Settings = {
    Enabled = true,
    CastBar = {
      Multi = true,
      Override = true,
    },
    EncTimer = KBM.Defaults.EncTimer(),
    PhaseMon = KBM.Defaults.PhaseMon(),
    Alerts = KBM.Defaults.Alerts(),
      Mann = {
        CastBar = self.Mann.Settings.CastBar,
        AlertsRef = self.Mann.Settings.AlertsRef,
      },
      Heart = {
        CastBar = self.Heart.Settings.CastBar,
        AlertsRef = self.Heart.Settings.AlertsRef,
      },
  }
	KBMNTGMMAN_Settings = self.Settings
	chKBMNTGMMAN_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTGMMAN_Settings = self.Settings
		self.Settings = chKBMNTGMMAN_Settings
	else
		chKBMNTGMMAN_Settings = self.Settings
		self.Settings = KBMNTGMMAN_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTGMMAN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTGMMAN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTGMMAN_Settings = self.Settings
	else
		KBMNTGMMAN_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTGMMAN_Settings = self.Settings
	else
		KBMNTGMMAN_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
  if self.Mann.UnitID == UnitID then
    self.Mann.Available = false
  elseif self.Heart.UnitID == UnitID then
    self.Heart.Available = false
  end
  
  if not self.Mann.Available and not self.Heart.Available then
    return true
  end
  
  return false
end

function MOD:Death(UnitID)
  if self.Mann.UnitID == UnitID then
    self.Mann.Dead = true
  elseif self.Heart.UnitID == UnitID then
    self.Heart.Dead = true
  end
  if self.Mann.Dead == true and self.Heart.Dead == true then
    return true
  end
  return false
end

function MOD:UnitHPCheck(uDetails, unitID)  
  if uDetails and unitID then
    local BossObj = self.UTID[uDetails.type]
    if BossObj then
      if not self.EncounterRunning then
        self.EncounterRunning = true
        self.StartTime = Inspect.Time.Real()
        self.HeldTime = self.StartTime
        self.TimeElapsed = 0
        BossObj.Dead = false
        BossObj.Casting = false
        self.PhaseObj:Start(self.StartTime)
        self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
        self.PhaseObj.Objectives:AddPercent(self.Mann, 0, 100)
        self.PhaseObj.Objectives:AddPercent(self.Heart, 0, 100)
        self.Phase = 1
        --Update this to multiphase at some point. first boss to 75% gets the shield, then next boss to 50%, then next boss to 25%, then death.
      end
      if not BossObj.CastBar.Active then
        BossObj.CastBar:Create(unitID)
      end
      BossObj.UnitID = unitID
      BossObj.Available = true
      return BossObj
    end
  end
end

function MOD:Reset()
  self.EncounterRunning = false
  for Name, BossObj in pairs(self.Bosses) do
    BossObj.Dead = false
    BossObj.Available = false
    BossObj.UnitID = nil
    BossObj.CastBar:Remove()
  end
  self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Mann)
	
	-- Create Alerts
	self.Mann.AlertsRef.Frost = KBM.Alert:Create(self.Lang.Ability.Frost[KBM.Lang], nil, true, true, "cyan")	
	self.Mann.AlertsRef.Grip = KBM.Alert:Create(self.Lang.Ability.Grip[KBM.Lang], nil, true, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Mann)
	
	self.Heart.AlertsRef.Soulstorm = KBM.Alert:Create(self.Lang.Ability.Soulstorm[KBM.Lang], nil, true, false, "purple")
	KBM.Defaults.AlertObj.Assign(self.Heart)
	
	-- Assign Alerts and Timers to Triggers
	self.Mann.Triggers.Frost = KBM.Trigger:Create(self.Lang.Ability.Frost[KBM.Lang], "cast", self.Mann)
	self.Mann.Triggers.Frost:AddAlert(self.Mann.AlertsRef.Frost)
	
	self.Mann.Triggers.Grip = KBM.Trigger:Create(self.Lang.Ability.Grip[KBM.Lang], "cast", self.Mann)
	self.Mann.Triggers.Grip:AddAlert(self.Mann.AlertsRef.Grip)
  
	self.Heart.Triggers.Soulstorm = KBM.Trigger:Create(self.Lang.Ability.Soulstorm[KBM.Lang], "cast", self.Heart)
	self.Heart.Triggers.Soulstorm:AddAlert(self.Heart.AlertsRef.Soulstorm)
	
	self.Mann.CastBar = KBM.Castbar:Add(self, self.Mann)
	self.Heart.CastBar = KBM.Castbar:Add(self, self.Heart)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end