-- Life Anchors Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPFLA_Settings = nil
chKBMPFLA_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local PF = KBM.BossMod["Primeval Feast"]

local LA = {
	Directory = PF.Directory,
	File = "Anchors.lua",
	Enabled = true,
	Instance = PF.Name,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "PF_Anchors",
	Object = "LA",
}

LA.Anchor = {
	Mod = LA,
	Level = "??",
	Active = false,
	Name = "Life Anchor",
	NameShort = "Anchor",
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(LA.ID, LA)

-- Main Unit Dictionary
LA.Lang.Unit = {}
LA.Lang.Unit.Anchor = KBM.Language:Add(LA.Anchor.Name)
LA.Lang.Unit.Anchor:SetGerman("Lebensanker")
LA.Lang.Unit.Anchor:SetFrench("Ancre vitale")
LA.Lang.Unit.Anchor:SetRussian("Якорь Жизни")
LA.Lang.Unit.AnchorShort = KBM.Language:Add("Anchor")
LA.Lang.Unit.AnchorShort:SetGerman("Anker")
LA.Lang.Unit.AnchorShort:SetFrench("Ancre")
LA.Lang.Unit.AnchorShort:SetRussian("Якорь")
LA.Anchor.Name = LA.Lang.Unit.Anchor[KBM.Lang]
LA.Anchor.NameShort = LA.Lang.Unit.AnchorShort[KBM.Lang]

-- Description
LA.Lang.Main = {}
LA.Lang.Main.Descript = KBM.Language:Add("Life Anchors")
LA.Lang.Main.Descript:SetGerman("Lebensanker")
LA.Lang.Main.Descript:SetFrench("Ancre vitale")
LA.Lang.Main.Descript:SetRussian("Якоря Жизни")
LA.Descript = LA.Lang.Main.Descript[KBM.Lang]

function LA:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Anchor.Name] = self.Anchor,
	}
	KBM_Boss[self.Anchor.Name] = self.Anchor	
end

function LA:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Anchor.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- AlertsRef = self.Anchor.Settings.AlertsRef,
		-- TimersRef = self.Anchor.Settings.TimersRef,
	}
	KBMPFLA_Settings = self.Settings
	chKBMPFLA_Settings = self.Settings
end

function LA:SwapSettings(bool)

	if bool then
		KBMPFLA_Settings = self.Settings
		self.Settings = chKBMPFLA_Settings
	else
		chKBMPFLA_Settings = self.Settings
		self.Settings = KBMPFLA_Settings
	end

end

function LA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPFLA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPFLA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPFLA_Settings = self.Settings
	else
		KBMPFLA_Settings = self.Settings
	end	
end

function LA:SaveVars()	
	if KBM.Options.Character then
		chKBMPFLA_Settings = self.Settings
	else
		KBMPFLA_Settings = self.Settings
	end	
end

function LA:Castbar(units)
end

function LA:RemoveUnits(UnitID)
	if self.Anchor.UnitID == UnitID then
		self.Anchor.Available = false
		return true
	end
	return false
end

function LA:Death(UnitID)
	if self.Anchor.UnitID == UnitID then
		self.Anchor.Dead = true
		return true
	end
	return false
end

function LA:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Anchor.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Anchor.Dead = false
					self.Anchor.Casting = false
					self.Anchor.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Anchor.Name, 0, 100)
					self.Phase = 1					
				end
				self.Anchor.UnitID = unitID
				self.Anchor.Available = true
				return self.Anchor
			end
		end
	end
end

function LA:Reset()
	self.EncounterRunning = false
	self.Anchor.Available = false
	self.Anchor.UnitID = nil
	self.Anchor.Dead = false
	self.Anchor.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())	
end

function LA:Timer()
	
end

function LA.Anchor:SetTimers(bool)	
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

function LA.Anchor:SetAlerts(bool)
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

function LA:DefineMenu()
	self.Menu = PF.Menu:CreateEncounter(self.Anchor, self.Enabled)
end

function LA:Start()
	-- Create Timers

	-- Create Alerts
	
	-- Assign Alerts and Timers to Triggers
	
	self.Anchor.CastBar = KBM.CastBar:Add(self, self.Anchor, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end