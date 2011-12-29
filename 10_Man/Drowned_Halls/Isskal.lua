-- Isskal Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHIL_Settings = nil
chKBMDHIL_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local DH = KBM.BossMod["Drowned Halls"]

local IL = {
	Enabled = true,
	Instance = DH.Name,
	Lang = {},
	ID = "Isskal",
	}

IL.Isskal = {
	Mod = IL,
	Level = "??",
	Active = false,
	Name = "Isskal",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(IL.ID, IL)

IL.Lang.Isskal = KBM.Language:Add(IL.Isskal.Name)

IL.Isskal.Name = IL.Lang.Isskal[KBM.Lang]

function IL:AddBosses(KBM_Boss)
	self.Isskal.Descript = self.Isskal.Name
	self.MenuName = self.Isskal.Descript
	self.Bosses = {
		[self.Isskal.Name] = self.Isskal,
	}
	KBM_Boss[self.Isskal.Name] = self.Isskal	
end

function IL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Isskal.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMDHIL_Settings = self.Settings
	chKBMDHIL_Settings = self.Settings
end

function IL:SwapSettings(bool)

	if bool then
		KBMDHIL_Settings = self.Settings
		self.Settings = chKBMDHIL_Settings
	else
		chKBMDHIL_Settings = self.Settings
		self.Settings = KBMDHIL_Settings
	end

end

function IL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHIL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHIL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHIL_Settings = self.Settings
	else
		KBMDHIL_Settings = self.Settings
	end	
end

function IL:SaveVars()	
	if KBM.Options.Character then
		chKBMDHIL_Settings = self.Settings
	else
		KBMDHIL_Settings = self.Settings
	end	
end

function IL:Castbar(units)
end

function IL:RemoveUnits(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Available = false
		return true
	end
	return false
end

function IL:Death(UnitID)
	if self.Isskal.UnitID == UnitID then
		self.Isskal.Dead = true
		return true
	end
	return false
end

function IL:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Isskal.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Isskal.Dead = false
					self.Isskal.Casting = false
					self.Isskal.CastBar:Create(unitID)
				end
				self.Isskal.UnitID = unitID
				self.Isskal.Available = true
				return self.Isskal
			end
		end
	end
end

function IL:Reset()
	self.EncounterRunning = false
	self.Isskal.Available = false
	self.Isskal.UnitID = nil
	self.Isskal.Dead = false
	self.Isskal.CastBar:Remove()
end

function IL:Timer()
	
end

function IL.Isskal:SetTimers(bool)	
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

function IL.Isskal:SetAlerts(bool)
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

function IL:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Isskal, self.Enabled)
end

function IL:Start()
	self.Isskal.CastBar = KBM.CastBar:Add(self, self.Isskal, true)
	self:DefineMenu()
end