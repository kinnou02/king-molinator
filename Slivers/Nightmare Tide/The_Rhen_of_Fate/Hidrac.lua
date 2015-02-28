-- Hidrac, Oonta, and Weyloz Boss Mod for King Boss Mods
-- Written by Noshei
-- Copyright 2012
--

KBMNTSLROFHOW_Settings = nil
chKBMNTSLROFHOW_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROF = KBM.BossMod["SThe_Rhen_of_Fate"]

local HOW = {
	Directory = ROF.Directory,
	File = "Hidrac.lua",
	Enabled = true,
	Instance = ROF.Name,
	InstanceObj = ROF,
	Lang = {},
	Enrage = 6 * 60,
	ID = "SHidrac",
	Object = "HOW",
}

KBM.RegisterMod(HOW.ID, HOW)

-- Main Unit Dictionary
HOW.Lang.Unit = {}
HOW.Lang.Unit.Hidrac = KBM.Language:Add("Hidrac")
HOW.Lang.Unit.Oonta = KBM.Language:Add("Oonta")
HOW.Lang.Unit.Weyloz = KBM.Language:Add("Weyloz")

-- Ability Dictionary
HOW.Lang.Ability = {}

-- Verbose Dictionary
HOW.Lang.Verbose = {}

-- Buff Dictionary
HOW.Lang.Buff = {}

-- Debuff Dictionary
HOW.Lang.Debuff = {}


-- Description Dictionary
HOW.Lang.Main = {}
HOW.Lang.Main.Descript = KBM.Language:Add("Hidrac, Oonta and Weyloz")
HOW.Descript = HOW.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
HOW.Hidrac = {
	Mod = HOW,
	Level = "??",
	Active = false,
	Name = HOW.Lang.Unit.Hidrac[KBM.Lang],
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	-- MechRef = {},
	Available = false,
	UTID = "U65CA7B7E10053629",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--	Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
			
		-- },
		-- MechRef = {
			-- Enabled = true,
			
		-- },
	}
}

HOW.Oonta = {
	Mod = HOW,
	Level = "??",
	Active = false,
	Name = HOW.Lang.Unit.Oonta[KBM.Lang],
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	-- MechRef = {},
	Available = false,
	UTID = "U4890ACC15662A8CE",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--	Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
			
		-- },
		-- MechRef = {
			-- Enabled = true,
			
		-- },
	}
}

HOW.Weyloz = {
	Mod = HOW,
	Level = "??",
	Active = false,
	Name = HOW.Lang.Unit.Weyloz[KBM.Lang],
	Menu = {},
	Dead = false,
	-- AlertsRef = {},
	-- TimersRef = {},
	-- MechRef = {},
	Available = false,
	UTID = "U7A627F8E543829F2",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		--	Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
			
		-- },
		-- MechRef = {
			-- Enabled = true,
			
		-- },
	}
}

function HOW:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Hidrac.Name] = self.Hidrac,
		[self.Oonta.Name] = self.Oonta,
		[self.Weyloz.Name] = self.Weyloz,
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

function HOW:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- MechSpy = KBM.Defaults.MechSpy(),
		Hidrac = {
			CastBar = self.Hidrac.Settings.CastBar,
			-- TimersRef = self.Hidrac.Settings.TimersRef,
			-- AlertsRef = self.Hidrac.Settings.AlertsRef,
			-- MechRef = self.Hidrac.Settings.MechRef,
		},
		Oonta = {
			CastBar = self.Oonta.Settings.CastBar,
			-- TimersRef = self.Oonta.Settings.TimersRef,
			-- AlertsRef = self.Oonta.Settings.AlertsRef,
			-- MechRef = self.Oonta.Settings.MechRef,
		},
		Weyloz = {
			CastBar = self.Weyloz.Settings.CastBar,
			-- TimersRef = self.Weyloz.Settings.TimersRef,
			-- AlertsRef = self.Weyloz.Settings.AlertsRef,
			-- MechRef = self.Weyloz.Settings.MechRef,
		},
	}
	KBMNTSLROFHOW_Settings = self.Settings
	chKBMNTSLROFHOW_Settings = self.Settings
	
end

function HOW:SwapSettings(bool)

	if bool then
		KBMNTSLROFHOW_Settings = self.Settings
		self.Settings = chKBMNTSLROFHOW_Settings
	else
		chKBMNTSLROFHOW_Settings = self.Settings
		self.Settings = KBMNTSLROFHOW_Settings
	end

end

function HOW:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTSLROFHOW_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTSLROFHOW_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTSLROFHOW_Settings = self.Settings
	else
		KBMNTSLROFHOW_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function HOW:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTSLROFHOW_Settings = self.Settings
	else
		KBMNTSLROFHOW_Settings = self.Settings
	end	
end

function HOW:Castbar(units)
end

function HOW:RemoveUnits(UnitID)
	if self.Hidrac.UnitID == UnitID then
		self.Hidrac.Available = false
	elseif self.Oonta.UnitID == UnitID then
		self.Oonta.Available = false
	elseif self.Weyloz.UnitID == UnitID then
		self.Weyloz.Available = false
	end
	if not self.Hidrac.Available and not self.Oonta.Available and not self.Weyloz.Available then
		return true
	end
	return false
end

function HOW:Death(UnitID)
	if self.Hidrac.UnitID == UnitID then
		self.Hidrac.Dead = true
	elseif self.Oonta.UnitID == UnitID then
		self.Oonta.Dead = true
	elseif self.Weyloz.UnitID == UnitID then
		self.Weyloz.Dead = true
	end
	if self.Hidrac.Dead and self.Oonta.Dead and self.Weyloz.Dead then
		return true
	end
	return false
end

function HOW:UnitHPCheck(uDetails, unitID)	
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
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Hidrac, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Oonta, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Weyloz, 0, 100)
				self.Phase = 1
			else				
				BossObj.Dead = false
				BossObj.Casting = false
			end
			if BossObj.UnitID ~= unitID then
				BossObj.CastBar:Remove()
				BossObj.CastBar:Create(unitID)
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function HOW:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		BossObj.CastBar:Remove()
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function HOW:Timer()	
end

function HOW:Start()

	-- Create Timers
	
	
	-- Create Alerts
	

	-- Create Spies
	

	-- Assign Alerts and Timers to Triggers
	
	
	self.Hidrac.CastBar = KBM.Castbar:Add(self, self.Hidrac)
	self.Oonta.CastBar = KBM.Castbar:Add(self, self.Oonta)
	self.Weyloz.CastBar = KBM.Castbar:Add(self, self.Weyloz)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end