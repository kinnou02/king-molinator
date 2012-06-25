-- Pyromaster Cortilnald Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFOLHPC_Settings = nil
chKBMEXFOLHPC_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["Fall of Lantern Hook"]

local MOD = {
	Directory = Instance.Directory,
	File = "Cortilnald.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Cortilnald",
	Object = "MOD",
}

MOD.Cortilnald = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Pyromaster Cortilnald",
	NameShort = "Cortilnald",
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
MOD.Lang.Unit.Cortilnald = KBM.Language:Add(MOD.Cortilnald.Name)
MOD.Lang.Unit.Cortilnald:SetGerman("Feuermeister Cortilnald") 
MOD.Lang.Unit.Cortilnald:SetFrench("Pyromaître Cortilnald")
MOD.Lang.Unit.Cortilnald:SetRussian("Пиромастер Кортильнальд")
MOD.Lang.Unit.Cortilnald:SetKorean("파이로맨서 코르틸날드")
MOD.Cortilnald.Name = MOD.Lang.Unit.Cortilnald[KBM.Lang]
MOD.Descript = MOD.Cortilnald.Name
MOD.Lang.Unit.CortShort = KBM.Language:Add("Cortilnald")
MOD.Lang.Unit.CortShort:SetGerman()
MOD.Lang.Unit.CortShort:SetFrench()
MOD.Lang.Unit.CortShort:SetRussian("Кортильнальд")
MOD.Lang.Unit.CortShort:SetKorean("코르틸날드")
MOD.Cortilnald.NameShort = MOD.Lang.Unit.CortShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Cortilnald.Name] = self.Cortilnald,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Cortilnald.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Cortilnald.Settings.TimersRef,
		-- AlertsRef = self.Cortilnald.Settings.AlertsRef,
	}
	KBMEXFOLHPC_Settings = self.Settings
	chKBMEXFOLHPC_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFOLHPC_Settings = self.Settings
		self.Settings = chKBMEXFOLHPC_Settings
	else
		chKBMEXFOLHPC_Settings = self.Settings
		self.Settings = KBMEXFOLHPC_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFOLHPC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFOLHPC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFOLHPC_Settings = self.Settings
	else
		KBMEXFOLHPC_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFOLHPC_Settings = self.Settings
	else
		KBMEXFOLHPC_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Cortilnald.UnitID == UnitID then
		self.Cortilnald.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Cortilnald.UnitID == UnitID then
		self.Cortilnald.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Cortilnald.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Cortilnald.Dead = false
					self.Cortilnald.Casting = false
					self.Cortilnald.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Cortilnald.Name, 0, 100)
					self.Phase = 1
				end
				self.Cortilnald.UnitID = unitID
				self.Cortilnald.Available = true
				return self.Cortilnald
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Cortilnald.Available = false
	self.Cortilnald.UnitID = nil
	self.Cortilnald.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Cortilnald:SetTimers(bool)	
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

function MOD.Cortilnald:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Cortilnald, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Cortilnald)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Cortilnald)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Cortilnald.CastBar = KBM.CastBar:Add(self, self.Cortilnald)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end