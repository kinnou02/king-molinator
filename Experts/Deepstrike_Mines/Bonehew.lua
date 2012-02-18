-- Bonehew the Thunderer Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXDMBT_Settings = nil
chKBMEXDMBT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Deepstrike Mines"]

local MOD = {
	Directory = Instance.Directory,
	File = "Bonehew.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Bonehew",
	Counts = {
		Fragments = 0,
	}
}

MOD.Bonehew = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Bonehew the Thunderer",
	NameShort = "Bonehew",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U71B4AEF5562A56AE",
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

MOD.Lang.Bonehew = KBM.Language:Add(MOD.Bonehew.Name)
MOD.Lang.Bonehew:SetGerman("Bonehew der Donnerer")
-- MOD.Lang.Bonehew:SetFrench("")
-- MOD.Lang.Bonehew:SetRussian("")
MOD.Bonehew.Name = MOD.Lang.Bonehew[KBM.Lang]
MOD.Descript = MOD.Bonehew.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Fragment = KBM.Language:Add("Fragmented Bonehew")
MOD.Lang.Unit.Fragment.German = "Fragmentierter Bonehew"

MOD.Fragment = {
	Mod = MOD,
	Level = 52,
	Name = MOD.Lang.Unit.Fragment[KBM.Lang],
	UnitList = {},
	Ignore = true,
	ExpertID = "U5AD287837A0CDF4A",
	Type = "multi",
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Bonehew.Name] = self.Bonehew,
		[self.Fragment.Name] = self.Fragment,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Bonehew.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Bonehew.Settings.TimersRef,
		-- AlertsRef = self.Bonehew.Settings.AlertsRef,
	}
	KBMEXDMBT_Settings = self.Settings
	chKBMEXDMBT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXDMBT_Settings = self.Settings
		self.Settings = chKBMEXDMBT_Settings
	else
		chKBMEXDMBT_Settings = self.Settings
		self.Settings = KBMEXDMBT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXDMBT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXDMBT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXDMBT_Settings = self.Settings
	else
		KBMEXDMBT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXDMBT_Settings = self.Settings
	else
		KBMEXDMBT_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Bonehew.UnitID == UnitID then
		self.Bonehew.Available = false
		return true
	end
	return false
end

function MOD.PhaseTwo()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj:SetPhase("Final")
	MOD.Phase = 2
	MOD.PhaseObj.Objectives:AddDeath(MOD.Fragment.Name, 2)
end

function MOD:Death(UnitID)
	if self.Bonehew.UnitID == UnitID then
		self.Bonehew.Dead = true
	elseif self.Fragment.UnitList[UnitID] then
		if not self.Fragment.UnitList[UnitID].Dead then
			self.Counts.Fragments = self.Counts.Fragments + 1
			if self.Counts.Fragments == 2 then
				return true
			end
		end
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Bonehew.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Bonehew.Dead = false
					self.Bonehew.Casting = false
					self.Bonehew.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Bonehew.Name, 50, 100)
					self.Phase = 1
				end
				self.Bonehew.UnitID = unitID
				self.Bonehew.Available = true
				return self.Bonehew
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = MOD,
						Level = 52,
						Name = uDetails.name,
						Dead = false,
						Casting = false,
						UnitID = unitID,
						Available = true,
					}
					self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
					if self.Phase == 1 then
						self.Counts.Fragments = 0
						self.PhaseTwo()
					end
				else
					self.Bosses[uDetails.name].UnitList[unitID].Available = true
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Bonehew.Available = false
	self.Bonehew.UnitID = nil
	self.Bonehew.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
	self.Counts.Fragments = 0
	self.Phase = 1
	self.Fragment.UnitList = {}
end

function MOD:Timer()	
end

function MOD.Bonehew:SetTimers(bool)	
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

function MOD.Bonehew:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Bonehew, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Bonehew)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Bonehew)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Bonehew.CastBar = KBM.CastBar:Add(self, self.Bonehew)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end