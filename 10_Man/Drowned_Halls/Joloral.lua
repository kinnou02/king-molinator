-- Joloral Ragetide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHRT_Settings = nil
chKBMDHRT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local DH = KBM.BossMod["Drowned Halls"]

local JR = {
	Enabled = true,
	Instance = DH.Name,
	Lang = {},
	ID = "Joloral",
	}

JR.Joloral = {
	Mod = JR,
	Level = "??",
	Active = false,
	Name = "Joloral Ragetide",
	NameShort = "Joloral",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(JR.ID, JR)

JR.Lang.Joloral = KBM.Language:Add(JR.Joloral.Name)
JR.Lang.Joloral.German = "Joloral Wutflut"
JR.Lang.Joloral.French = "Joloral Ragemar\195\169e"

JR.Joloral.Name = JR.Lang.Joloral[KBM.Lang]

function JR:AddBosses(KBM_Boss)
	self.Joloral.Descript = self.Joloral.Name
	self.MenuName = self.Joloral.Descript
	self.Bosses = {
		[self.Joloral.Name] = self.Joloral,
	}
	KBM_Boss[self.Joloral.Name] = self.Joloral	
end

function JR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Joloral.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMDHJR_Settings = self.Settings
	chKBMDHJR_Settings = self.Settings
end

function JR:SwapSettings(bool)

	if bool then
		KBMDHJR_Settings = self.Settings
		self.Settings = chKBMDHJR_Settings
	else
		chKBMDHJR_Settings = self.Settings
		self.Settings = KBMDHJR_Settings
	end

end

function JR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHJR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHJR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHJR_Settings = self.Settings
	else
		KBMDHJR_Settings = self.Settings
	end	
end

function JR:SaveVars()	
	if KBM.Options.Character then
		chKBMDHJR_Settings = self.Settings
	else
		KBMDHJR_Settings = self.Settings
	end	
end

function JR:Castbar(units)
end

function JR:RemoveUnits(UnitID)
	if self.Joloral.UnitID == UnitID then
		self.Joloral.Available = false
		return true
	end
	return false
end

function JR:Death(UnitID)
	if self.Joloral.UnitID == UnitID then
		self.Joloral.Dead = true
		return true
	end
	return false
end

function JR:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Joloral.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Joloral.Dead = false
					self.Joloral.Casting = false
					self.Joloral.CastBar:Create(unitID)
				end
				self.Joloral.UnitID = unitID
				self.Joloral.Available = true
				return self.Joloral
			end
		end
	end
end

function JR:Reset()
	self.EncounterRunning = false
	self.Joloral.Available = false
	self.Joloral.UnitID = nil
	self.Joloral.Dead = false
	self.Joloral.CastBar:Remove()
end

function JR:Timer()
	
end

function JR.Joloral:SetTimers(bool)	
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

function JR.Joloral:SetAlerts(bool)
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

function JR:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Joloral, self.Enabled)
end

function JR:Start()
	self.Joloral.CastBar = KBM.CastBar:Add(self, self.Joloral, true)
	self:DefineMenu()
end