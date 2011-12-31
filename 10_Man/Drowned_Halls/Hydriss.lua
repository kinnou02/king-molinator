-- High Priestess Hydriss Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHHH_Settings = nil
chKBMDHHH_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local DH = KBM.BossMod["Drowned Halls"]

local HH = {
	Enabled = true,
	Instance = DH.Name,
	Lang = {},
	ID = "Hydriss",
	Enrage = 60 * 12,
	}

HH.Hydriss = {
	Mod = HH,
	Level = "??",
	Active = false,
	Name = "High Priestess Hydriss",
	NameShort = "Hydriss",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(HH.ID, HH)

HH.Lang.Hydriss = KBM.Language:Add(HH.Hydriss.Name)
HH.Lang.Hydriss.German = "Hohepriesterin Hydriss"

HH.Hydriss.Name = HH.Lang.Hydriss[KBM.Lang]

function HH:AddBosses(KBM_Boss)
	self.Hydriss.Descript = self.Hydriss.Name
	self.MenuName = self.Hydriss.Descript
	self.Bosses = {
		[self.Hydriss.Name] = self.Hydriss,
	}
	KBM_Boss[self.Hydriss.Name] = self.Hydriss	
end

function HH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Hydriss.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMDHHH_Settings = self.Settings
	chKBMDHHH_Settings = self.Settings
end

function HH:SwapSettings(bool)

	if bool then
		KBMDHHH_Settings = self.Settings
		self.Settings = chKBMDHHH_Settings
	else
		chKBMDHHH_Settings = self.Settings
		self.Settings = KBMDHHH_Settings
	end

end

function HH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHHH_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHHH_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHHH_Settings = self.Settings
	else
		KBMDHHH_Settings = self.Settings
	end	
end

function HH:SaveVars()	
	if KBM.Options.Character then
		chKBMDHHH_Settings = self.Settings
	else
		KBMDHHH_Settings = self.Settings
	end	
end

function HH:Castbar(units)
end

function HH:RemoveUnits(UnitID)
	if self.Hydriss.UnitID == UnitID then
		self.Hydriss.Available = false
		return true
	end
	return false
end

function HH:Death(UnitID)
	if self.Hydriss.UnitID == UnitID then
		self.Hydriss.Dead = true
		return true
	end
	return false
end

function HH:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Hydriss.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hydriss.Dead = false
					self.Hydriss.Casting = false
					self.Hydriss.CastBar:Create(unitID)
				end
				self.Hydriss.UnitID = unitID
				self.Hydriss.Available = true
				return self.Hydriss
			end
		end
	end
end

function HH:Reset()
	self.EncounterRunning = false
	self.Hydriss.Available = false
	self.Hydriss.UnitID = nil
	self.Hydriss.Dead = false
	self.Hydriss.CastBar:Remove()
end

function HH:Timer()
	
end

function HH.Hydriss:SetTimers(bool)	
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

function HH.Hydriss:SetAlerts(bool)
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

function HH:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Hydriss, self.Enabled)
end

function HH:Start()
	self.Hydriss.CastBar = KBM.CastBar:Add(self, self.Hydriss, true)
	self:DefineMenu()
end