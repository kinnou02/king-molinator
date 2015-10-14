-- Dalraak the Shadowlord Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTNCDTS_Settings = nil
chKBMNTNCDTS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Nightmare_Coast"]

local MOD = {
	Directory = Instance.Directory,
	File = "Dalraak.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NC_Dalraak",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Dalraak = KBM.Language:Add("Dalraak the Shadowlord")
MOD.Lang.Unit.Dalraak:SetFrench("Dalraak le Seigneur des ombres")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Blade = KBM.Language:Add("Blade of Tyranny")
MOD.Lang.Ability.Blade:SetFrench("Lame de tyrannie")
MOD.Lang.Ability.Demon = KBM.Language:Add("The Demon Within")
MOD.Lang.Ability.Demon:SetFrench("Démon intérieur")
MOD.Lang.Ability.Warped = KBM.Language:Add("Warped Reality")
MOD.Lang.Ability.Warped:SetFrench("Réalité pervertie")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.DemonWarn = KBM.Language:Add("Spread Out!")
MOD.Lang.Verbose.DemonWarn:SetFrench("Dispersion!!!")

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Dalraak[KBM.Lang]

MOD.Dalraak = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Dalraak[KBM.Lang],
	NameShort = "Dalraak",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U0FE1988C1B5A5702",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Demon = KBM.Defaults.AlertObj.Create("purple"),
		  Warped = KBM.Defaults.AlertObj.Create("red"),
		}
	}
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Dalraak.Name] = self.Dalraak,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Dalraak.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Dalraak.Settings.TimersRef,
		AlertsRef = self.Dalraak.Settings.AlertsRef,
	}
	KBMNTNCDTS_Settings = self.Settings
	chKBMNTNCDTS_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTNCDTS_Settings = self.Settings
		self.Settings = chKBMNTNCDTS_Settings
	else
		chKBMNTNCDTS_Settings = self.Settings
		self.Settings = KBMNTNCDTS_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTNCDTS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTNCDTS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTNCDTS_Settings = self.Settings
	else
		KBMNTNCDTS_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTNCDTS_Settings = self.Settings
	else
		KBMNTNCDTS_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Dalraak.UnitID == UnitID then
		self.Dalraak.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Dalraak.UnitID == UnitID then
		self.Dalraak.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if uDetails.type == self.Dalraak.UTID then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				self.Dalraak.Dead = false
				self.Dalraak.Casting = false
				self.Dalraak.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Dalraak.Name, 0, 100)
				self.Phase = 1
			end
			self.Dalraak.UnitID = unitID
			self.Dalraak.Available = true
			return self.Dalraak
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Dalraak.Available = false
	self.Dalraak.UnitID = nil
	self.Dalraak.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	self.Dalraak.AlertsRef.Demon = KBM.Alert:Create(self.Lang.Verbose.DemonWarn[KBM.Lang], nil, true, false, "purple")
	--self.Dalraak.AlertsRef.Warped = KBM.Alert:Create(self.Lang.Ability.Warped[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Dalraak)
	
	-- Assign Alerts and Timers to Triggers
	self.Dalraak.Triggers.DemonWarn = KBM.Trigger:Create(self.Lang.Ability.Demon[KBM.Lang], "cast", self.Dalraak)
	self.Dalraak.Triggers.DemonWarn:AddAlert(self.Dalraak.AlertsRef.Demon)
	--self.Dalraak.Triggers.Warped = KBM.Trigger:Create(self.Lang.Ability.Warped[KBM.Lang], "cast", self.Dalraak)
	--self.Dalraak.Triggers.Warped:AddAlert(self.Dalraak.AlertsRef.Warped)
	
	
	self.Dalraak.CastBar = KBM.Castbar:Add(self, self.Dalraak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end