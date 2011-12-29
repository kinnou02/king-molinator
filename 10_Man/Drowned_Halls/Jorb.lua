-- Assualt Commander Jorb Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHAJ_Settings = nil
chKBMDHAJ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local DH = KBM.BossMod["Drowned Halls"]

local AJ = {
	Enabled = true,
	Instance = DH.Name,
	Lang = {},
	Enrage = 5 * 60,
	ID = "Jorb",
}

AJ.Jorb = {
	Mod = AJ,
	Level = "??",
	Active = false,
	Name = "Assault Commander Jorb",
	NameShort = "Jorb",
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Impact = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Impact = KBM.Defaults.AlertObj.Create("purple"),
			Grasp = KBM.Defaults.AlertObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(AJ.ID, AJ)

AJ.Lang.Jorb = KBM.Language:Add(AJ.Jorb.Name)
AJ.Lang.Jorb.German = "Überfallkommandant Jorb"
AJ.Lang.Jorb.French = "Commandant d'assaut Jorb"

-- Ability Dictionary
AJ.Lang.Ability = {}
AJ.Lang.Ability.Impact = KBM.Language:Add("Forceful Impact")
AJ.Lang.Ability.Impact.German = "Machtvoller Schlag"

-- Notify Dictionary
AJ.Lang.Notify = {}
AJ.Lang.Notify.Stand = KBM.Language:Add("(%a*), stand to attention!")
AJ.Lang.Notify.Stand.German = "(%a*), Stillgestanden!"

-- Debuff Dictionary
AJ.Lang.Debuff = {}
AJ.Lang.Debuff.Grasp = KBM.Language:Add("Paralyzing Grasp")

AJ.Jorb.Name = AJ.Lang.Jorb[KBM.Lang]

function AJ:AddBosses(KBM_Boss)
	self.Jorb.Descript = self.Jorb.Name
	self.MenuName = self.Jorb.Descript
	self.Bosses = {
		[self.Jorb.Name] = self.Jorb,
	}
	KBM_Boss[self.Jorb.Name] = self.Jorb	
end

function AJ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Jorb.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		AlertsRef = self.Jorb.Settings.AlertsRef,
		TimersRef = self.Jorb.Settings.TimersRef,
	}
	KBMDHAJ_Settings = self.Settings
	chKBMDHAJ_Settings = self.Settings
end

function AJ:SwapSettings(bool)

	if bool then
		KBMDHAJ_Settings = self.Settings
		self.Settings = chKBMDHAJ_Settings
	else
		chKBMDHAJ_Settings = self.Settings
		self.Settings = KBMDHAJ_Settings
	end

end

function AJ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHAJ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHAJ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHAJ_Settings = self.Settings
	else
		KBMDHAJ_Settings = self.Settings
	end	
end

function AJ:SaveVars()	
	if KBM.Options.Character then
		chKBMDHAJ_Settings = self.Settings
	else
		KBMDHAJ_Settings = self.Settings
	end	
end

function AJ:Castbar(units)
end

function AJ:RemoveUnits(UnitID)
	if self.Jorb.UnitID == UnitID then
		self.Jorb.Available = false
		return true
	end
	return false
end

function AJ:Death(UnitID)
	if self.Jorb.UnitID == UnitID then
		self.Jorb.Dead = true
		return true
	end
	return false
end

function AJ:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Jorb.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Jorb.Dead = false
					self.Jorb.Casting = false
					self.Jorb.CastBar:Create(unitID)
				end
				self.Jorb.UnitID = unitID
				self.Jorb.Available = true
				return self.Jorb
			end
		end
	end
end

function AJ:Reset()
	self.EncounterRunning = false
	self.Jorb.Available = false
	self.Jorb.UnitID = nil
	self.Jorb.Dead = false
	self.Jorb.CastBar:Remove()
end

function AJ:Timer()
	
end

function AJ.Jorb:SetTimers(bool)	
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

function AJ.Jorb:SetAlerts(bool)
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

function AJ:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Jorb, self.Enabled)
end

function AJ:Start()
	-- Create Timers
	self.Jorb.TimersRef.Impact = KBM.MechTimer:Add(self.Lang.Ability.Impact[KBM.Lang], 16)
	KBM.Defaults.TimerObj.Assign(self.Jorb)

	-- Create Alerts
	self.Jorb.AlertsRef.Impact = KBM.Alert:Create(self.Lang.Ability.Impact[KBM.Lang], nil, true, true, "purple")
	self.Jorb.AlertsRef.Grasp = KBM.Alert:Create(self.Lang.Debuff.Grasp[KBM.Lang], 5, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Jorb)
	
	-- Assign Alerts and Timers to Triggers
	self.Jorb.Triggers.Impact = KBM.Trigger:Create(self.Lang.Ability.Impact[KBM.Lang], "cast", self.Jorb)
	self.Jorb.Triggers.Impact:AddAlert(self.Jorb.AlertsRef.Impact)
	self.Jorb.Triggers.Impact:AddTimer(self.Jorb.TimersRef.Impact)
	self.Jorb.Triggers.Grasp = KBM.Trigger:Create(self.Lang.Debuff.Grasp[KBM.Lang], "playerBuff", self.Jorb)
	self.Jorb.Triggers.Grasp:AddAlert(self.Jorb.AlertsRef.Grasp)
	
	self.Jorb.CastBar = KBM.CastBar:Add(self, self.Jorb, true)
	self:DefineMenu()
end