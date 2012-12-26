-- Grand Falconer Zoles Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLSLTQGZ_Settings = nil
chKBMSLSLTQGZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TDQ = KBM.BossMod["STriumph_of_the_Dragon_Queen"]

local GFZ = {
	Directory = TDQ.Directory,
	File = "Zoles.lua",
	Enabled = true,
	Instance = TDQ.Name,
	InstanceObj = TDQ,
	Lang = {},
	Enrage = 5 * 60,
	ID = "SGrand_Falconer_Zoles",
	Object = "GFZ",
}

KBM.RegisterMod(GFZ.ID, GFZ)

-- Main Unit Dictionary
GFZ.Lang.Unit = {}
GFZ.Lang.Unit.Zoles = KBM.Language:Add("Grand Falconer Zoles")
GFZ.Lang.Unit.Zoles:SetGerman("Großfalkner Zoles")
GFZ.Lang.Unit.ZolesShort = KBM.Language:Add("Zoles")
GFZ.Lang.Unit.ZolesShort:SetGerman("Zoles")
GFZ.Lang.Unit.Sky = KBM.Language:Add("Skyscream")
GFZ.Lang.Unit.Sky:SetGerman("Himmelsschrei") 
GFZ.Lang.Unit.SkyShort = KBM.Language:Add("Skyscream")
GFZ.Lang.Unit.SkyShort:SetGerman("Himmelsschrei")

-- Ability Dictionary
GFZ.Lang.Ability = {}
GFZ.Lang.Ability.Static = KBM.Language:Add("Static Empowerment")
GFZ.Lang.Ability.Static:SetGerman("Statische Ermächtigung")

-- Verbose Dictionary
GFZ.Lang.Verbose = {}
GFZ.Lang.Verbose.Void = KBM.Language:Add("Voids spawn soon!")
GFZ.Lang.Verbose.Void:SetGerman("Void Spawn gleich!")
GFZ.Lang.Verbose.VoidFirst = KBM.Language:Add("First Voids spawn")
GFZ.Lang.Verbose.VoidFirst:SetGerman("Erster Void Spawn")
GFZ.Lang.Verbose.VoidSpawn = KBM.Language:Add("Void spawns")
GFZ.Lang.Verbose.VoidSpawn:SetGerman("Achtung Voids!")

-- Debuff Dictionary
GFZ.Lang.Debuff = {}
GFZ.Lang.Debuff.Strikes = KBM.Language:Add("Bleeding Strikes")
GFZ.Lang.Debuff.Strikes:SetGerman("Blutige Angriffe")

-- Description Dictionary
GFZ.Lang.Main = {}

GFZ.Descript = GFZ.Lang.Unit.Zoles[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
GFZ.Zoles = {
	Mod = GFZ,
	Level = "??",
	Active = false,
	Name = GFZ.Lang.Unit.Zoles[KBM.Lang],
	NameShort = GFZ.Lang.Unit.ZolesShort[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = "UFA77D6F8684E047C",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			VoidFirst = KBM.Defaults.TimerObj.Create("red"),
			Void = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Void = KBM.Defaults.AlertObj.Create("red"),
			Static = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

GFZ.Sky = {
	Mod = GFZ,
	Level = "??",
	Active = false,
	Name = GFZ.Lang.Unit.Sky[KBM.Lang],
	NameShort = GFZ.Lang.Unit.SkyShort[KBM.Lang],
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UTID = "UFE96189109B11387",
	UnitID = nil,
	Triggers = {},
	Settings = {
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


function GFZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zoles.Name] = self.Zoles,
		[self.Sky.Name] = self.Sky,
	}
end

function GFZ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Zoles.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zoles.Settings.TimersRef,
		AlertsRef = self.Zoles.Settings.AlertsRef,
	}
	KBMSLSLTQGZ_Settings = self.Settings
	chKBMSLSLTQGZ_Settings = self.Settings
	
end

function GFZ:SwapSettings(bool)

	if bool then
		KBMSLSLTQGZ_Settings = self.Settings
		self.Settings = chKBMSLSLTQGZ_Settings
	else
		chKBMSLSLTQGZ_Settings = self.Settings
		self.Settings = KBMSLSLTQGZ_Settings
	end

end

function GFZ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLTQGZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLTQGZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLTQGZ_Settings = self.Settings
	else
		KBMSLSLTQGZ_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function GFZ:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLTQGZ_Settings = self.Settings
	else
		KBMSLSLTQGZ_Settings = self.Settings
	end	
end

function GFZ:Castbar(units)
end

function GFZ:RemoveUnits(UnitID)
	if self.Zoles.UnitID == UnitID then
		self.Zoles.Available = false
		return true
	end
	return false
end

function GFZ:Death(UnitID)
	if self.Zoles.UnitID == UnitID then
		self.Zoles.Dead = true
		return true
	end
	return false
end

function GFZ:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Zoles then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Zoles, 0, 100)
				self.Phase = 1
				KBM.MechTimer:AddStart(self.Zoles.TimersRef.VoidFirst)
				if BossObj == self.Zoles then
					KBM.TankSwap:Start(self.Lang.Debuff.Strikes[KBM.Lang], unitID)
				end
			else
				if BossObj == self.Zoles then
					if not KBM.TankSwap.Active then
						KBM.TankSwap:Start(self.Lang.Debuff.Strikes[KBM.Lang], unitID)
					end
				end
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					if BossObj == self.Zoles then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function GFZ:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Zoles.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function GFZ:Timer()	
end

function GFZ:DefineMenu()
	self.Menu = TDQ.Menu:CreateEncounter(self.Zoles, self.Enabled)
end

function GFZ:Start()
	-- Create Timers
	self.Zoles.TimersRef.VoidFirst = KBM.MechTimer:Add(self.Lang.Verbose.VoidFirst[KBM.Lang], 60)
	self.Zoles.TimersRef.Void = KBM.MechTimer:Add(self.Lang.Verbose.VoidSpawn[KBM.Lang], 75, true)
	KBM.Defaults.TimerObj.Assign(self.Zoles)
	
	-- Create Alerts
	self.Zoles.AlertsRef.Static = KBM.Alert:Create(self.Lang.Ability.Static[KBM.Lang], nil, false, true, "yellow")
	self.Zoles.AlertsRef.Static:Important()
	self.Zoles.AlertsRef.Void = KBM.Alert:Create(self.Lang.Verbose.Void[KBM.Lang], 5, false, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Zoles)
	
	-- Link Alerts to Timers
	self.Zoles.TimersRef.VoidFirst:AddAlert(self.Zoles.AlertsRef.Void, 5)
	self.Zoles.TimersRef.VoidFirst:AddTimer(self.Zoles.TimersRef.Void, 0)
	self.Zoles.TimersRef.Void:AddAlert(self.Zoles.AlertsRef.Void, 5)
	
	-- Assign Alerts and Timers to Triggers
	self.Zoles.Triggers.Static = KBM.Trigger:Create(self.Lang.Ability.Static[KBM.Lang], "cast", self.Zoles)
	self.Zoles.Triggers.Static:AddAlert(self.Zoles.AlertsRef.Static)
	self.Zoles.Triggers.StaticInt = KBM.Trigger:Create(self.Lang.Ability.Static[KBM.Lang], "interrupt", self.Zoles)
	self.Zoles.Triggers.StaticInt:AddStop(self.Zoles.AlertsRef.Static)
	
	self.Zoles.CastBar = KBM.CastBar:Add(self, self.Zoles)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end