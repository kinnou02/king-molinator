-- Fae Lord Twyl Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXUROTFLT_Settings = nil
chKBMEXUROTFLT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local Instance = KBM.BossMod["The Realm of the Fae"]

local MOD = {
	Directory = Instance.Directory,
	File = "Twyl.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Twyl",
}

MOD.Twyl = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Fae Lord Twyl",
	NameShort = "Twyl",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
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

MOD.Lang.Twyl = KBM.Language:Add(MOD.Twyl.Name)
-- MOD.Lang.Twyl:SetGerman("")
-- MOD.Lang.Twyl:SetFrench("")
-- MOD.Lang.Twyl:SetRussian("")
MOD.Twyl.Name = MOD.Lang.Twyl[KBM.Lang]
MOD.Descript = MOD.Twyl.Name

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Autumn = KBM.Language:Add("Avatar of Autumn")
MOD.Lang.Unit.AutumnShort = KBM.Language:Add("Autumn")
MOD.Lang.Unit.Summer = KBM.Language:Add("Avatar of Summer")
MOD.Lang.Unit.SummerShort = KBM.Language:Add("Summer")
MOD.Lang.Unit.Spring = KBM.Language:Add("Avatar of Spring")
MOD.Lang.Unit.SpringShort = KBM.Language:Add("Spring")

MOD.Autumn = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Autumn[KBM.Lang],
	NameShort = MOD.Lang.Unit.AutumnShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

MOD.Summer = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Summer[KBM.Lang],
	NameShort = MOD.Lang.Unit.SummerShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

MOD.Spring = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Spring[KBM.Lang],
	NameShort = MOD.Lang.Unit.SpringShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	ExpertID = "Expert",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Twyl.Name] = self.Twyl,
		[self.Autumn.Name] = self.Autumn,
		[self.Summer.Name] = self.Summer,
		[self.Spring.Name] = self.Spring,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Twyl.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Twyl.Settings.TimersRef,
		-- AlertsRef = self.Twyl.Settings.AlertsRef,
	}
	KBMEXUROTFLT_Settings = self.Settings
	chKBMEXUROTFLT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXUROTFLT_Settings = self.Settings
		self.Settings = chKBMEXUROTFLT_Settings
	else
		chKBMEXUROTFLT_Settings = self.Settings
		self.Settings = KBMEXUROTFLT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXUROTFLT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXUROTFLT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXUROTFLT_Settings = self.Settings
	else
		KBMEXUROTFLT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXUROTFLT_Settings = self.Settings
	else
		KBMEXUROTFLT_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Twyl.UnitID == UnitID then
		self.Twyl.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Twyl.UnitID == UnitID then
		self.Twyl.Dead = true
		return true
	end
	return false
end

function MOD:SetPhase(BossObj)
	if BossObj.Name == self.Autumn.Name then
		self.Phase = 1
	elseif BossObj.Name == self.Summer.Name then
		self.Phase = 2
	elseif BossObj.Name == self.Spring.Name then
		self.Phase = 3
	elseif BossObj.Name == self.Twyl.Name then
		self.Phase = 4
	end
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Twyl.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self:SetPhase(BossObj)
					if self.Phase < 4 then
						self.PhaseObj:SetPhase(self.Phase)
					else
						self.PhaseObj:SetPhase("Final")
					end
					self.PhaseObj.Objectives:Remove()
					self.PhaseObj.Objectives:AddPercent(BossObj.Name, 0, 100)
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Twyl.Name then
						BossObj.CastBar:Create(unitID)
					end
					self:SetPhase(BossObj)
					if self.Phase < 4 then
						self.PhaseObj:SetPhase(self.Phase)
					else
						self.PhaseObj:SetPhase("Final")
					end
					self.PhaseObj.Objectives:Remove()
					self.PhaseObj.Objectives:AddPercent(BossObj.Name, 0, 100)
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Twyl
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
	end
	self.Twyl.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Twyl:SetTimers(bool)	
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

function MOD.Twyl:SetAlerts(bool)
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
	self.Menu = Instance.Menu:CreateEncounter(self.Twyl, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Twyl)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Twyl)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Twyl.CastBar = KBM.CastBar:Add(self, self.Twyl)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end