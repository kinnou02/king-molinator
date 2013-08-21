-- Fae Lord Twyl Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXROTFLT_Settings = nil
chKBMEXROTFLT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["The Realm of the Fae"]

local MOD = {
	Directory = Instance.Directory,
	File = "Twyl.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	TimeoutOverride = false,
	Timeout = 80,
	HasPhases = true,
	Lang = {},
	ID = "Twyl",
	Object = "MOD",
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
	UTID = "U283A2AEA5D374F37",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
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

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Twyl = KBM.Language:Add(MOD.Twyl.Name)
MOD.Lang.Unit.Twyl:SetGerman("Feenfürst Twyl")
MOD.Lang.Unit.Twyl:SetFrench("Seigneur des Fées Twyl")
MOD.Lang.Unit.Twyl:SetRussian("Повелитель фей Твил")
MOD.Lang.Unit.Twyl:SetKorean("파에 군주 트윌")
MOD.Twyl.Name = MOD.Lang.Unit.Twyl[KBM.Lang]
MOD.Descript = MOD.Twyl.Name
MOD.Lang.Unit.TwylShort = KBM.Language:Add(MOD.Twyl.NameShort)
MOD.Lang.Unit.TwylShort:SetGerman()
MOD.Lang.Unit.TwylShort:SetFrench()
MOD.Lang.Unit.TwylShort:SetRussian("Твил")
MOD.Lang.Unit.TwylShort:SetKorean("트윌")
MOD.Twyl.NameShort = MOD.Lang.Unit.TwylShort[KBM.Lang]
MOD.Lang.Unit.Autumn = KBM.Language:Add("Avatar of Autumn")
MOD.Lang.Unit.Autumn:SetGerman("Avatar des Herbstes")
MOD.Lang.Unit.Autumn:SetFrench("Avatar d'automne")
MOD.Lang.Unit.Autumn:SetRussian("Олицетворение Осени")
MOD.Lang.Unit.Autumn:SetKorean("가을의 화신")
MOD.Lang.Unit.AutumnShort = KBM.Language:Add("Autumn")
MOD.Lang.Unit.AutumnShort:SetGerman("Herbst")
MOD.Lang.Unit.AutumnShort:SetFrench("Automne")
MOD.Lang.Unit.AutumnShort:SetRussian("Осень")
MOD.Lang.Unit.AutumnShort:SetKorean("가을")
MOD.Lang.Unit.Summer = KBM.Language:Add("Avatar of Summer")
MOD.Lang.Unit.Summer:SetGerman("Avatar des Sommers")
MOD.Lang.Unit.Summer:SetFrench("Avatar d'été")
MOD.Lang.Unit.Summer:SetRussian("Воплощение Лета")
MOD.Lang.Unit.Summer:SetKorean("여름의 화신")
MOD.Lang.Unit.SummerShort = KBM.Language:Add("Summer")
MOD.Lang.Unit.SummerShort:SetGerman("Sommer")
MOD.Lang.Unit.SummerShort:SetFrench("Été")
MOD.Lang.Unit.SummerShort:SetRussian("Лето")
MOD.Lang.Unit.Spring = KBM.Language:Add("Avatar of Spring")
MOD.Lang.Unit.Spring:SetGerman("Avatar des Frühlings")
MOD.Lang.Unit.Spring:SetFrench("Avatar de printemps")
MOD.Lang.Unit.Spring:SetRussian("Воплощение Весны")
MOD.Lang.Unit.Spring:SetKorean("봄의 화신")
MOD.Lang.Unit.SpringShort = KBM.Language:Add("Spring")
MOD.Lang.Unit.SpringShort:SetGerman("Frühling")
MOD.Lang.Unit.SpringShort:SetFrench("Printemps")
MOD.Lang.Unit.SpringShort:SetRussian("Весна")
MOD.Lang.Unit.SpringShort:SetKorean("봄")

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
	UTID = "U372CCD771C23195F",
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
	UTID = "U1220566F5B67A9EC",
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
	UTID = "U2A3DD96624187F57",
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
	KBMEXROTFLT_Settings = self.Settings
	chKBMEXROTFLT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXROTFLT_Settings = self.Settings
		self.Settings = chKBMEXROTFLT_Settings
	else
		chKBMEXROTFLT_Settings = self.Settings
		self.Settings = KBMEXROTFLT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXROTFLT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXROTFLT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXROTFLT_Settings = self.Settings
	else
		KBMEXROTFLT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXROTFLT_Settings = self.Settings
	else
		KBMEXROTFLT_Settings = self.Settings
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
	else
		self.TimeoutOverride = true
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
	self.TimeoutOverride = false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
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
				return BossObj
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




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Twyl)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Twyl)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Twyl.CastBar = KBM.Castbar:Add(self, self.Twyl)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end