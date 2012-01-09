-- Guurloth Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGPGH_Settings = nil
chKBMGPGH_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Guilded Prophecy"]

local GH = {
	Enabled = true,
	Instance = GP.Name,
	Lang = {},
	ID = "Guurloth",
	}

GH.Guurloth = {
	Mod = GH,
	Level = "??",
	Active = false,
	Name = "Guurloth",
	NameShort = "Guurloth",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(GH.ID, GH)

GH.Lang.Guurloth = KBM.Language:Add(GH.Guurloth.Name)

GH.Guurloth.Name = GH.Lang.Guurloth[KBM.Lang]
GH.Descript = GH.Guurloth.Name

function GH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Guurloth.Name] = self.Guurloth,
	}
	KBM_Boss[self.Guurloth.Name] = self.Guurloth	
end

function GH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Guurloth.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMGPGH_Settings = self.Settings
	chKBMGPGH_Settings = self.Settings
end

function GH:SwapSettings(bool)

	if bool then
		KBMGPGH_Settings = self.Settings
		self.Settings = chKBMGPGH_Settings
	else
		chKBMGPGH_Settings = self.Settings
		self.Settings = KBMGPGH_Settings
	end

end

function GH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPGH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPGH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPGH_Settings = self.Settings
	else
		KBMGPGH_Settings = self.Settings
	end	
end

function GH:SaveVars()	
	if KBM.Options.Character then
		chKBMGPGH_Settings = self.Settings
	else
		KBMGPGH_Settings = self.Settings
	end	
end

function GH:Castbar(units)
end

function GH:RemoveUnits(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Available = false
		return true
	end
	return false
end

function GH:Death(UnitID)
	if self.Guurloth.UnitID == UnitID then
		self.Guurloth.Dead = true
		return true
	end
	return false
end

function GH:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Guurloth.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Guurloth.Dead = false
					self.Guurloth.Casting = false
					self.Guurloth.CastBar:Create(unitID)
				end
				self.Guurloth.UnitID = unitID
				self.Guurloth.Available = true
				return self.Guurloth
			end
		end
	end
end

function GH:Reset()
	self.EncounterRunning = false
	self.Guurloth.Available = false
	self.Guurloth.UnitID = nil
	self.Guurloth.Dead = false
	self.Guurloth.CastBar:Remove()
end

function GH:Timer()
	
end

function GH.Guurloth:SetTimers(bool)	
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

function GH.Guurloth:SetAlerts(bool)
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

function GH:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Guurloth, self.Enabled)
end

function GH:Start()
	-- Create Timers
	
	-- Create Alerts
	
	-- Assign Timers and Alerts to Triggers
	
	self.Guurloth.CastBar = KBM.CastBar:Add(self, self.Guurloth, true)
	self:DefineMenu()
end