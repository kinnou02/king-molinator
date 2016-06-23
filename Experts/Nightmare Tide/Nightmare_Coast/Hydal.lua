-- Hydal Ithral Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTNCHYD_Settings = nil
chKBMNTNCHYD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Nightmare_Coast"]

local MOD = {
	Directory = Instance.Directory,
	File = "Hydal.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NC_Hydal",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Hydal = KBM.Language:Add("Hydal Ithral")
MOD.Lang.Unit.Hydal:SetFrench("Hydal Ithral")

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Devour = KBM.Language:Add("Devour Fear")
MOD.Lang.Buff.Devour:SetFrench("Peur vampirisée")

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Nightshade = KBM.Language:Add("Nightshade")
MOD.Lang.Debuff.Nightshade:SetFrench("Ombrenuit")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Hydal[KBM.Lang]
MOD.Hydal = {
	Mod = MOD,
	Level = "67",
	Active = false,
	Name = MOD.Lang.Unit.Hydal[KBM.Lang],
	-- NameShort = "Hydal",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U55DF84DE3433468C",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Devour = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Nightshade = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Hydal.Name] = self.Hydal,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Hydal.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechRef = self.Hydal.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Hydal.Settings.TimersRef,
		AlertsRef = self.Hydal.Settings.AlertsRef,
	}
	KBMNTNCHYD_Settings = self.Settings
	chKBMNTNCHYD_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTNCHYD_Settings = self.Settings
		self.Settings = chKBMNTNCHYD_Settings
	else
		chKBMNTNCHYD_Settings = self.Settings
		self.Settings = KBMNTNCHYD_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTNCHYD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTNCHYD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTNCHYD_Settings = self.Settings
	else
		KBMNTNCHYD_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTNCHYD_Settings = self.Settings
	else
		KBMNTNCHYD_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Hydal.UnitID == UnitID then
		self.Hydal.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Hydal.UnitID == UnitID then
		self.Hydal.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)
	print("hydal OK")
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Hydal.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Hydal.Dead = false
					self.Hydal.Casting = false
					self.Hydal.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Hydal, 0, 100)
					self.Phase = 1
				end
				self.Hydal.UnitID = unitID
				self.Hydal.Available = true
				return self.Hydal
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Hydal.Available = false
	self.Hydal.UnitID = nil
	self.Hydal.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Hydal)
	
	-- Create Spies
	self.Hydal.MechRef.Nightshade = KBM.MechSpy:Add(self.Lang.Debuff.Nightshade[KBM.Lang], nil, "playerDebuff", self.Hydal)
	KBM.Defaults.MechObj.Assign(self.Hydal)
	
	-- Create Alerts
	self.Hydal.AlertsRef.Devour = KBM.Alert:Create(self.Lang.Buff.Devour[KBM.Lang], nil, false, false, "purple") --causing the fight to not work?
	KBM.Defaults.AlertObj.Assign(self.Hydal)
	
	-- Assign Alerts and Timers to Triggers
	self.Hydal.Triggers.Nightshade = KBM.Trigger:Create(self.Lang.Debuff.Nightshade[KBM.Lang], "playerBuff", self.Hydal)
	self.Hydal.Triggers.Nightshade:AddSpy(self.Hydal.MechRef.Nightshade)
	self.Hydal.Triggers.NightshadeRem = KBM.Trigger:Create(self.Lang.Debuff.Nightshade[KBM.Lang], "playerBuffRemove", self.Hydal)
	self.Hydal.Triggers.NightshadeRem:AddStop(self.Hydal.MechRef.Nightshade)
	self.Hydal.Triggers.Devour = KBM.Trigger:Create(self.Lang.Buff.Devour[KBM.Lang], "buff", self.Hydal)
	self.Hydal.Triggers.Devour:AddAlert(self.Hydal.AlertsRef.Devour)
	
	self.Hydal.CastBar = KBM.Castbar:Add(self, self.Hydal)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end