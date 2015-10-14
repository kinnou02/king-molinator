-- The Three Kings Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015

KBMNTRTITK_Settings = nil
chKBMNTRTITK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["RTIron_Tomb"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kings.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	TimeoutOverride = true,
	Timeout = 15,
	HasPhases = true,
	Lang = {},
	ID = "NT_Kings",
	Object = "MOD",
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Laric = KBM.Language:Add("Nightmare Laric")
MOD.Lang.Unit.Laric:SetFrench("Laric cauchemardesque")
MOD.Lang.Unit.Derribec = KBM.Language:Add("Nightmare Derribec")
MOD.Lang.Unit.Derribec:SetFrench("Derribec cauchemardesque")
MOD.Lang.Unit.Humbart = KBM.Language:Add("Nightmare Humbart")
MOD.Lang.Unit.Humbart:SetFrench("Humbart cauchemardesque")


-- Mod Description
MOD.Lang.Verbose = {}
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.Descript = KBM.Language:Add("The Three Kings")
MOD.Lang.Verbose.Descript:SetGerman("Die drei Könige")
MOD.Lang.Verbose.Descript:SetFrench("les Trois Rois")
MOD.Lang.Verbose.Descript:SetRussian("Три короля")
MOD.Lang.Verbose.Descript:SetKorean("세 명의 왕")


-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Healing = KBM.Language:Add("Unholy Healing")
MOD.Lang.Ability.Healing:SetFrench("Guérison impie")
MOD.Lang.Ability.Mending = KBM.Language:Add("Unholy Mending")
MOD.Lang.Ability.Mending:SetFrench("Soins impies")


-- Descript Dictionary
--MOD.Descript = MOD.Laric.Name.." & "..MOD.Derribec.Name.." & "..MOD.Humbart.Name
MOD.Descript = MOD.Lang.Verbose.Descript[KBM.Lang]

MOD.Laric = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Laric[KBM.Lang],
	NameShort = "Laric",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U39985EF17EA82059",
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Healing = KBM.Defaults.AlertObj.Create("dark_green"),
		  Mending = KBM.Defaults.AlertObj.Create("cyan"),
		},
	},
}

MOD.Derribec = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Derribec[KBM.Lang],
	NameShort = "Derribec",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0E37AB7F011EB5C7",
	TimeOut = 5,
}

MOD.Humbart = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Humbart[KBM.Lang],
	NameShort = "Humbart",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U036E40D715FC0A30",
	TimeOut = 5,
}

KBM.RegisterMod(MOD.ID, MOD)


function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Laric.Name] = self.Laric,
		[self.Derribec.Name] = self.Derribec,
		[self.Humbart.Name] = self.Humbart
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Laric.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Laric.Settings.TimersRef,
		AlertsRef = self.Laric.Settings.AlertsRef,
	}
	KBMNTRTITK_Settings = self.Settings
	chKBMNTRTITK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTITK_Settings = self.Settings
		self.Settings = chKBMNTRTITK_Settings
	else
		chKBMNTRTITK_Settings = self.Settings
		self.Settings = KBMNTRTITK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTITK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTITK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTITK_Settings = self.Settings
	else
		KBMNTRTITK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTITK_Settings = self.Settings
	else
		KBMNTRTITK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Laric.UnitID == UnitID then
		self.Laric.Available = false
		return true
	elseif self.Humbart.UnitID == UnitID then
		self.Humbart.Available = false
		return true
	elseif self.Derribec.UnitID == UnitID then
		self.Derribec.Available = false
		return true
	end
	return false
end

function MOD.SetObjectives()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Humbart, 0, 100)
	MOD.PhaseObj.Objectives:AddPercent(MOD.Derribec, 0, 100)  
	MOD.PhaseObj.Objectives:AddPercent(MOD.Laric, 0, 100)
end

function MOD:Death(UnitID)
	if self.Laric.UnitID == UnitID then
		self.Laric.Dead = true
		self.Laric.CastBar:Remove()
		elseif self.Derribec.UnitID == UnitID then
			self.Derribec.Dead = true
		elseif self.Humbart.UnitID == UnitID then
			self.Humbart.Dead = true
		end
		if self.Laric.Dead and self.Derribec.Dead and self.Humbart.Dead then
			if self.Phase == 1 then
				self.PhaseObj.Objectives:Remove()
				self.Phase = 2
				self.PhaseObj:SetPhase(2)
				self.Laric.Dead = false
				self.Derribec.Dead = false
				self.Humbart.Dead = false
			else
				return true
			end
		end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)  
  if uDetails and unitID then
    if not uDetails.player then
      if self.Bosses[uDetails.name] then
        local BossObj = self.Bosses[uDetails.name]
        if not self.EncounterRunning then
			self.EncounterRunning = true
			self.StartTime = Inspect.Time.Real()
			self.HeldTime = self.StartTime
			self.TimeElapsed = 0
			BossObj.Dead = false
			BossObj.Casting = false
			if BossObj.Name == self.Laric.Name then
				BossObj.CastBar:Create(unitID)
			end
			self.PhaseObj:Start(self.StartTime)
			self.PhaseObj:SetPhase(1)
			self.SetObjectives()
		elseif self.Phase == 2 then
			self.SetObjectives()
        else
			BossObj.Dead = false
			BossObj.Casting = false
			if BossObj.Name == self.Laric.Name then
				BossObj.CastBar:Create(unitID)
			end
        end
        BossObj.UnitID = unitID
        BossObj.Available = true
        return BossObj
      end
    end
  end
end

function MOD:Reset()
  self.EncounterRunning = false
  for BossName, BossObj in pairs(self.Bosses) do
    BossObj.Available = false
    BossObj.UnitID = nil
    BossObj.Dead = false
    BossObj.Casting = false
  end
  self.Laric.CastBar:Remove() 
  self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Laric:SetTimers(bool)	
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

function MOD.Laric:SetAlerts(bool)
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
	--KBM.Defaults.TimerObj.Assign(self.Laric)
	
	-- Create Alerts
	self.Laric.AlertsRef.Healing = KBM.Alert:Create(self.Lang.Ability.Healing[KBM.Lang], nil, true, true, "dark_green")
	self.Laric.AlertsRef.Mending = KBM.Alert:Create(self.Lang.Ability.Mending[KBM.Lang], nil, true, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Laric)
	
	-- Assign Alerts and Timers to Triggers
	self.Laric.Triggers.Healing = KBM.Trigger:Create(self.Lang.Ability.Healing[KBM.Lang], "cast", self.Laric)
	self.Laric.Triggers.Healing:AddAlert(self.Laric.AlertsRef.Healing)
	self.Laric.Triggers.HealingInt = KBM.Trigger:Create(self.Lang.Ability.Healing[KBM.Lang], "interrupt", self.Laric)
	self.Laric.Triggers.HealingInt:AddStop(self.Laric.AlertsRef.Healing)
	self.Laric.Triggers.Mending = KBM.Trigger:Create(self.Lang.Ability.Mending[KBM.Lang], "cast", self.Laric)
	self.Laric.Triggers.Mending:AddAlert(self.Laric.AlertsRef.Mending)
	self.Laric.Triggers.MendingInt = KBM.Trigger:Create(self.Lang.Ability.Mending[KBM.Lang], "interrupt", self.Laric)
	self.Laric.Triggers.MendingInt:AddStop(self.Laric.AlertsRef.Mending)
	
	self.Laric.CastBar = KBM.Castbar:Add(self, self.Laric)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end