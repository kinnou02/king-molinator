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
	Directory = DH.Directory,
	File = "Joloral.lua",
	Enabled = true,
	Instance = DH.Name,
	Lang = {},
	ID = "Joloral",
	Object = "JR",
}

JR.Joloral = {
	Mod = JR,
	Level = "??",
	Active = false,
	Name = "Joloral Ragetide",
	NameShort = "Joloral",
	Menu = {},
	AlertsRef = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Panic = KBM.Defaults.AlertObj.Create("purple"),
			PanicDuration = KBM.Defaults.AlertObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			Panic = KBM.Defaults.TimerObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(JR.ID, JR)

-- Unit Dictionary
JR.Lang.Unit = {}
JR.Lang.Unit.Joloral = KBM.Language:Add(JR.Joloral.Name)
JR.Lang.Unit.Joloral:SetGerman("Joloral Wutflut")
JR.Lang.Unit.Joloral:SetFrench("Joloral Ragemar\195\169e")
JR.Lang.Unit.Joloral:SetRussian("Йолорал Яролив")
-- Additional Unit Dictionary
JR.Lang.Unit.Crippler = KBM.Language:Add("Plated Crippler")
JR.Lang.Unit.Crippler:SetGerman("Plattenverkrüppler")
JR.Lang.Unit.Crippler:SetFrench("Mutilateur cuirassé")

-- Ability Dictionary
JR.Lang.Ability = {}
JR.Lang.Ability.Panic = KBM.Language:Add("Panic Attack")
JR.Lang.Ability.Panic:SetGerman("Panikattacke")
JR.Lang.Ability.Panic:SetFrench("Crise de panique")
JR.Lang.Ability.Panic:SetRussian("Приступ паники")

-- Notify Dictionary
JR.Lang.Notify = {}
JR.Lang.Notify.Panic = KBM.Language:Add("Joloral Ragetide glares at (%a*)")
JR.Lang.Notify.Panic:SetGerman("Joloral Wutflut starrt (%a*) an!")
JR.Lang.Notify.Panic:SetFrench("Joloral Ragemarée lance un regard furieux à (%a*)")

-- Verbose Dictionary
JR.Lang.Verbose = {}
JR.Lang.Verbose.Crippler = KBM.Language:Add(JR.Lang.Unit.Crippler[KBM.Lang].." enters the battle")
JR.Lang.Verbose.Crippler:SetGerman(JR.Lang.Unit.Crippler[KBM.Lang].." greift in den Kampf ein!")
JR.Lang.Verbose.Crippler:SetFrench("Mutilateur cuirassé entre en combat")

-- Menu Dictionary
JR.Lang.Menu = {}
JR.Lang.Menu.Panic = KBM.Language:Add(JR.Lang.Ability.Panic[KBM.Lang].." duration.")
JR.Lang.Menu.Panic:SetGerman(JR.Lang.Ability.Panic[KBM.Lang].." Dauer.")
JR.Lang.Menu.Panic:SetFrench("Durée des Crise de panique.")
JR.Lang.Menu.Panic:SetRussian("Длительность "..JR.Lang.Ability.Panic[KBM.Lang])

JR.Joloral.Name = JR.Lang.Unit.Joloral[KBM.Lang]
JR.Descript = JR.Joloral.Name

function JR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
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
		AlertsRef = self.Joloral.Settings.AlertsRef,
		TimersRef = self.Joloral.Settings.TimersRef,
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alert = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
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
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Joloral.Name, 0, 100)
					self.Phase = 1					
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
	self.PhaseObj:End(Inspect.Time.Real())
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
	-- Create Timers
	self.Joloral.TimersRef.Panic = KBM.MechTimer:Add(self.Lang.Ability.Panic[KBM.Lang], 37)
	KBM.Defaults.TimerObj.Assign(self.Joloral)
	
	-- Create Alerts
	self.Joloral.AlertsRef.Panic = KBM.Alert:Create(self.Lang.Ability.Panic[KBM.Lang], nil, true, true, "purple")
	self.Joloral.AlertsRef.PanicDuration = KBM.Alert:Create(self.Lang.Ability.Panic[KBM.Lang], nil, false, true, "purple")
	self.Joloral.AlertsRef.PanicDuration.MenuName = self.Lang.Menu.Panic[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Joloral)
	
	-- Assign Timers and Alerts to Triggers
	self.Joloral.Triggers.Panic = KBM.Trigger:Create(self.Lang.Ability.Panic[KBM.Lang], "cast", self.Joloral)
	self.Joloral.Triggers.Panic:AddTimer(self.Joloral.TimersRef.Panic)
	self.Joloral.Triggers.Panic:AddAlert(self.Joloral.AlertsRef.Panic)
	self.Joloral.Triggers.PanicDuration = KBM.Trigger:Create(self.Lang.Ability.Panic[KBM.Lang], "playerBuff", self.Joloral)
	self.Joloral.Triggers.PanicDuration:AddAlert(self.Joloral.AlertsRef.PanicDuration)
	
	self.Joloral.CastBar = KBM.CastBar:Add(self, self.Joloral, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end