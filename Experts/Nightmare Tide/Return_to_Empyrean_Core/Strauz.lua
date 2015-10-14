-- Strauz and Mercutial Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTECSM_Settings = nil
chKBMNTRTECSM_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["RTEmpyrean_Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Strauz.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RTEC_Strauz",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Strauz = KBM.Language:Add("Strauz")
MOD.Lang.Unit.Strauz:SetFrench("Strauz")
MOD.Lang.Unit.Mercutial = KBM.Language:Add("Mercutial")
MOD.Lang.Unit.Mercutial:SetFrench("Mercutiale")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Warp = KBM.Language:Add("Enter the Warp")
MOD.Lang.Ability.Warp:SetFrench("Entrée dans le Vortex")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Victory = KBM.Language:Add("Strong... for something so small.")
MOD.Lang.Notify.Victory:SetFrench("Si forts… et pourtant si petits.")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Strauz[KBM.Lang].." & "..MOD.Lang.Unit.Mercutial[KBM.Lang]

MOD.Strauz = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Strauz[KBM.Lang],
	--NameShort = "",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U7FF53DEB457814B2",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Mercutial = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Mercutial[KBM.Lang],
	--NameShort = "",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U4CA622C936361AC5",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
		  Enabled = true,
		  Warp = KBM.Defaults.AlertObj.Create("purple"),
		}
	}
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Strauz.Name] = self.Strauz,
		[self.Mercutial.Name] = self.Mercutial,
	}
	
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end
	
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		Strauz = {
			CastBar = self.Strauz.Settings.CastBar,
			AlertsRef = self.Strauz.Settings.AlertsRef,
		},
		Mercutial = {
			CastBar = self.Mercutial.Settings.CastBar,
			AlertsRef = self.Mercutial.Settings.AlertsRef,
		},
	}
	KBMNTRTECSM_Settings = self.Settings
	chKBMNTRTECSM_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTECSM_Settings = self.Settings
		self.Settings = chKBMNTRTECSM_Settings
	else
		chKBMNTRTECSM_Settings = self.Settings
		self.Settings = KBMNTRTECSM_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTECSM_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTECSM_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTECSM_Settings = self.Settings
	else
		KBMNTRTECSM_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTECSM_Settings = self.Settings
	else
		KBMNTRTECSM_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Strauz.UnitID == UnitID then
		self.Strauz.Available = false
	elseif self.Mercutial.UnitID == UnitID then
		self.Mercutial.Available = false
	end
	
	if not self.Strauz.Available and not self.Mercutial.Available then
		return true
	end
	
	return false
end

function MOD:Death(UnitID)
	if self.Strauz.UnitID == UnitID then
		self.Strauz.Dead = true
	elseif self.Mercutial.UnitID == UnitID then
		self.Mercutial.Dead = true
	end
	if self.Strauz.Dead == true and self.Mercutial.Dead == true then
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Mercutial, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Strauz, 0, 100)
				self.Phase = 1
			end
			if not BossObj.CastBar.Active then
				BossObj.CastBar:Create(unitID)
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Dead = false
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.CastBar:Remove()
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	self.Mercutial.AlertsRef.Warp = KBM.Alert:Create(self.Lang.Ability.Warp[KBM.Lang], nil, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Mercutial)
	
	-- Assign Alerts and Timers to Triggers
	self.Mercutial.Triggers.Warp = KBM.Trigger:Create(self.Lang.Ability.Warp[KBM.Lang], "cast", self.Mercutial)
	self.Mercutial.Triggers.Warp:AddAlert(self.Mercutial.AlertsRef.Warp)
	
	
	self.Strauz.CastBar = KBM.Castbar:Add(self, self.Strauz)
	self.Mercutial.CastBar = KBM.Castbar:Add(self, self.Mercutial)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end