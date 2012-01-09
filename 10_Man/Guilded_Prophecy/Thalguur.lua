-- Thalguur Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPTR_Settings = nil
chKBMGPTR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Guilded Prophecy"]

local TR = {
	Enabled = true,
	Instance = GP.Name,
	Lang = {},
	ID = "Thalguur",
	}

TR.Thalguur = {
	Mod = TR,
	Level = "??",
	Active = false,
	Name = "Thalguur",
	NameShort = "Thalguur",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(TR.ID, TR)

TR.Lang.Thalguur = KBM.Language:Add(TR.Thalguur.Name)

TR.Thalguur.Name = TR.Lang.Thalguur[KBM.Lang]
TR.Descript = TR.Thalguur.Name

function TR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Thalguur.Name] = self.Thalguur,
	}
	KBM_Boss[self.Thalguur.Name] = self.Thalguur	
end

function TR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Thalguur.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMGPTR_Settings = self.Settings
	chKBMGPTR_Settings = self.Settings
end

function TR:SwapSettings(bool)

	if bool then
		KBMGPTR_Settings = self.Settings
		self.Settings = chKBMGPTR_Settings
	else
		chKBMGPTR_Settings = self.Settings
		self.Settings = KBMGPTR_Settings
	end

end

function TR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPTR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPTR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPTR_Settings = self.Settings
	else
		KBMGPTR_Settings = self.Settings
	end	
end

function TR:SaveVars()	
	if KBM.Options.Character then
		chKBMGPTR_Settings = self.Settings
	else
		KBMGPTR_Settings = self.Settings
	end	
end

function TR:Castbar(units)
end

function TR:RemoveUnits(UnitID)
	if self.Thalguur.UnitID == UnitID then
		self.Thalguur.Available = false
		return true
	end
	return false
end

function TR:Death(UnitID)
	if self.Thalguur.UnitID == UnitID then
		self.Thalguur.Dead = true
		return true
	end
	return false
end

function TR:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Thalguur.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Thalguur.Dead = false
					self.Thalguur.Casting = false
					self.Thalguur.CastBar:Create(unitID)
				end
				self.Thalguur.UnitID = unitID
				self.Thalguur.Available = true
				return self.Thalguur
			end
		end
	end
end

function TR:Reset()
	self.EncounterRunning = false
	self.Thalguur.Available = false
	self.Thalguur.UnitID = nil
	self.Thalguur.Dead = false
	self.Thalguur.CastBar:Remove()
end

function TR:Timer()
	
end

function TR.Thalguur:SetTimers(bool)	
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

function TR.Thalguur:SetAlerts(bool)
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

function TR:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Thalguur, self.Enabled)
end

function TR:Start()
	-- Create Timers
	
	-- Create Alerts
	
	-- Assign Timers and Alerts to Triggers
	
	self.Thalguur.CastBar = KBM.CastBar:Add(self, self.Thalguur, true)
	self:DefineMenu()
end