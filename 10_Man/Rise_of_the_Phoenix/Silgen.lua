-- General Silgen Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPGS_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local GS = {
	Enabled = true,
	Instance = ROTP.Name,
	HasPhases = true,
	Lang = {},
	ID = "Silgen",
}

GS.Silgen = {
	Mod = GS,
	Level = "52",
	Active = false,
	Name = "General Silgen",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(GS.ID, GS)

GS.Lang.Silgen = KBM.Language:Add(GS.Silgen.Name)
GS.Lang.Silgen.French = "G\195\169n\195\169ral Silgen"

GS.Silgen.Name = GS.Lang.Silgen[KBM.Lang]

function GS:AddBosses(KBM_Boss)
	self.Silgen.Descript = self.Silgen.Name
	self.MenuName = self.Silgen.Descript
	self.Bosses = {
		[self.Silgen.Name] = self.Silgen,
	}
	KBM_Boss[self.Silgen.Name] = self.Silgen	
end

function GS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Silgen.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMROTPGS_Settings = self.Settings
	chKBMROTPGS_Settings = self.Settings
	
end

function GS:SwapSettings(bool)

	if bool then
		KBMROTPGS_Settings = self.Settings
		self.Settings = chKBMROTPGS_Settings
	else
		chKBMROTPGS_Settings = self.Settings
		self.Settings = KBMROTPGS_Settings
	end

end

function GS:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPGS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPGS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMROTPGS_Settings = self.Settings
	else
		KBMROTPGS_Settings = self.Settings
	end	
end

function GS:SaveVars()	
	if KBM.Options.Character then
		chKBMROTPGS_Settings = self.Settings
	else
		KBMROTPGS_Settings = self.Settings
	end	
end

function GS:Castbar(units)
end

function GS:RemoveUnits(UnitID)
	if self.Silgen.UnitID == UnitID then
		self.Silgen.Available = false
		return true
	end
	return false
end

function GS:Death(UnitID)
	if self.Silgen.UnitID == UnitID then
		self.Silgen.Dead = true
		return true
	end
	return false
end

function GS:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Silgen.Name then
				if not self.Silgen.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Silgen.Dead = false
					self.Silgen.Casting = false
					self.Silgen.CastBar:Create(unitID)
				end
				self.Silgen.UnitID = unitID
				self.Silgen.Available = true
				return self.Silgen
			end
		end
	end
end

function GS:Reset()
	self.EncounterRunning = false
	self.Silgen.Available = false
	self.Silgen.UnitID = nil
	self.Silgen.CastBar:Remove()
end

function GS:Timer()	
end

function GS.Silgen:SetTimers(bool)	
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

function GS.Silgen:SetAlerts(bool)
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

function GS:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Silgen, self.Enabled)
end

function GS:Start()	
	self.Silgen.CastBar = KBM.CastBar:Add(self, self.Silgen)
	self:DefineMenu()
end