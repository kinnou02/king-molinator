-- Volan Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2013
--

KBMSLRDIGVN_Settings = nil
chKBMSLRDIGVN_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IG = KBM.BossMod["RInfinity_Gate"]

local VOL = {
	Enabled = true,
	Directory = IG.Directory,
	File = "Volan.lua",
	Instance = IG.Name,
	InstanceObj = IG,
	HasPhases = true,
	Lang = {},
	ID = "SLIGVolan",
	Object = "VOL",
	--Enrage = 6 * 60 + 30,
}

KBM.RegisterMod(VOL.ID, VOL)

-- Main Unit Dictionary
VOL.Lang.Unit = {}
VOL.Lang.Unit.Volan = KBM.Language:Add("Volan") -- 
VOL.Lang.Unit.VolanLL = KBM.Language:Add("Volan's Left Leg")
VOL.Lang.Unit.VolanRL = KBM.Language:Add("Volan's Right Leg")

-- Ability Dictionary
VOL.Lang.Ability = {}

-- Description Dictionary
VOL.Lang.Main = {}

-- Debuff Dictionary
VOL.Lang.Debuff = {}

-- Messages Dictionary
VOL.Lang.Messages = {}

VOL.Descript = VOL.Lang.Unit.Volan[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
VOL.Volan = {
	Mod = VOL,
	Level = "??",
	Active = false,
	Name = VOL.Lang.Unit.Volan[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	-- MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Disruptor = KBM.Defaults.AlertObj.Create("yellow"),
			-- Distortion = KBM.Defaults.AlertObj.Create("red"),
		-- },
		-- MechRef = {
			-- Enabled = true,
			-- Decay = KBM.Defaults.MechObj.Create("cyan"),
			-- Distortion = KBM.Defaults.MechObj.Create("red"),
		-- },
	}
}

VOL.VolanLL = {
	Mod = VOL,
	Level = "??",
	Active = false,
	Name = VOL.Lang.Unit.VolanLL[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	-- MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Disruptor = KBM.Defaults.AlertObj.Create("yellow"),
			-- Distortion = KBM.Defaults.AlertObj.Create("red"),
		-- },
		-- MechRef = {
			-- Enabled = true,
			-- Decay = KBM.Defaults.MechObj.Create("cyan"),
			-- Distortion = KBM.Defaults.MechObj.Create("red"),
		-- },
	}
}

VOL.VolanRL = {
	Mod = VOL,
	Level = "??",
	Active = false,
	Name = VOL.Lang.Unit.VolanRL[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	-- MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		-- TimersRef = {
			-- Enabled = true,
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Disruptor = KBM.Defaults.AlertObj.Create("yellow"),
			-- Distortion = KBM.Defaults.AlertObj.Create("red"),
		-- },
		-- MechRef = {
			-- Enabled = true,
			-- Decay = KBM.Defaults.MechObj.Create("cyan"),
			-- Distortion = KBM.Defaults.MechObj.Create("red"),
		-- },
	}
}

function VOL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Volan.Name] = self.Volan,
		[self.VolanLL.Name] = self.VolanLL,
		[self.VolanRL.Name] = self.VolanRL,
	}
end

function VOL:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		--MechSpy = KBM.Defaults.MechSpy(),
		Volan = {
			CastBar = self.Volan.Settings.CastBar,
			-- AlertsRef = self.Volan.Settings.AlertsRef,
			-- TimersRef = self.Volan.Settings.TimersRef,
			-- MechRef = self.Volan.Settings.MechRef,
		},
		--MechTimer = KBM.Defaults.MechTimer(),
		--Alerts = KBM.Defaults.Alerts(),
	}
	KBMSLRDIGVN_Settings = self.Settings
	chKBMSLRDIGVN_Settings = self.Settings
	
end

function VOL:SwapSettings(bool)

	if bool then
		KBMSLRDIGVN_Settings = self.Settings
		self.Settings = chKBMSLRDIGVN_Settings
	else
		chKBMSLRDIGVN_Settings = self.Settings
		self.Settings = KBMSLRDIGVN_Settings
	end

end

function VOL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLRDIGVN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLRDIGVN_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLRDIGVN_Settings = self.Settings
	else
		KBMSLRDIGVN_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function VOL:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLRDIGVN_Settings = self.Settings
	else
		KBMSLRDIGVN_Settings = self.Settings
	end	
end

function VOL:Castbar(units)
end

function VOL:RemoveUnits(UnitID)
	if self.Volan.UnitID == UnitID then
		self.Volan.Available = false
		return true
	end
	return false
end

function VOL:Death(UnitID)
	if self.Volan.UnitID == UnitID then
		self.Volan.Dead = true
		return true
	end
	return false
end

function VOL:UnitHPCheck(uDetails, unitID)	
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
				if BossObj.CastBar then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Volan, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VolanLL, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VolanRL, 0, 100)
				self.Phase = 1
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.UnitID ~= unitID then
					BossObj.CastBar:Remove()
					BossObj.CastBar:Create(unitID)
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function VOL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function VOL:Timer()	
end

function VOL:DefineMenu()
	self.Menu = IG.Menu:CreateEncounter(self.Volan, self.Enabled)
end

function VOL:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Volan)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Volan)

	-- Create Mechanic Spies (Volan)
	--KBM.Defaults.MechObj.Assign(self.Volan)

	-- Assign Alerts and Timers to Triggers
	
	self.Volan.CastBar = KBM.Castbar:Add(self, self.Volan)
	self.VolanLL.CastBar = KBM.Castbar:Add(self, self.VolanLL)
	self.VolanRL.CastBar = KBM.Castbar:Add(self, self.VolanRL)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end