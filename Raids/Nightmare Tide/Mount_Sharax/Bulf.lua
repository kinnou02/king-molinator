-- Bulf Boss Mod for King Boss Mods
-- Written by Maatang
--

KBMNTRDMSBLF_Settings = nil
chKBMNTRDMSBLF_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local MS = KBM.BossMod["RMount_Sharax"]

local BLF = {
	Directory = MS.Directory,
	File = "Bulf.lua",
	Enabled = true,
	Instance = MS.Name,
	InstanceObj = MS,
	Lang = {},
	--Enrage = 5 * 60,
	ID = "Bulf",
	Object = "BLF",
}

KBM.RegisterMod(BLF.ID, BLF)

-- Main Unit Dictionary
BLF.Lang.Unit = {}
BLF.Lang.Unit.Bulf = KBM.Language:Add("Bulf")
BLF.Lang.Unit.Bulf:SetFrench("Bulf")

-- Ability Dictionary
BLF.Lang.Ability = {}

-- Verbose Dictionary
BLF.Lang.Verbose = {}

-- Buff Dictionary
BLF.Lang.Buff = {}

-- Debuff Dictionary
BLF.Lang.Debuff = {}

-- Description Dictionary
BLF.Lang.Main = {}

BLF.Descript = BLF.Lang.Unit.Bulf[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
BLF.BulfFirst = {
	Mod = BLF,
	Level = "??",
	Active = false,
	Name = BLF.Lang.Unit.Bulf[KBM.Lang],
	Menu = {},
	Dead = false,
	--AlertsRef = {},
	--TimersRef = {},
	--MechRef = {},
	Available = false,
	UTID = "U5663BE415EE6AFD9",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
			-- Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
		-- },
		-- MechRef = {
			-- Enabled = true,
		-- },
	}
}

BLF.BulfSecond = {
	Mod = BLF,
	Level = "??",
	Active = false,
	Name = BLF.Lang.Unit.Bulf[KBM.Lang],
	Menu = {},
	Dead = false,
	--AlertsRef = {},
	--TimersRef = {},
	--MechRef = {},
	Available = false,
	UTID = "U201592457D0DF64E",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
			-- Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
		-- },
		-- MechRef = {
			-- Enabled = true,
		-- },
	}
}

BLF.BulfThird = {
	Mod = BLF,
	Level = "??",
	Active = false,
	Name = BLF.Lang.Unit.Bulf[KBM.Lang],
	Menu = {},
	Dead = false,
	--AlertsRef = {},
	--TimersRef = {},
	--MechRef = {},
	Available = false,
	UTID = "U5BF2DDAA425A3D7B",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
			-- Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
		-- },
		-- MechRef = {
			-- Enabled = true,
		-- },
	}
}

BLF.BulfFinal = {
	Mod = BLF,
	Level = "??",
	Active = false,
	Name = BLF.Lang.Unit.Bulf[KBM.Lang],
	Menu = {},
	Dead = false,
	--AlertsRef = {},
	--TimersRef = {},
	--MechRef = {},
	Available = false,
	UTID = "U17D5CC845643421A",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
			-- Enabled = true,
		--},
		-- AlertsRef = {
			-- Enabled = true,
		-- },
		-- MechRef = {
			-- Enabled = true,
		-- },
	}
}

function BLF:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.BulfFirst.Name] = self.BulfFirst,
		[self.BulfSecond.Name] = self.BulfSecond,
		[self.BulfThird.Name] = self.BulfThird,
		[self.BulfFinal.Name] = self.BulfFinal,
	}
end

function BLF:InitVars()
	self.Settings = {
		Enabled = true,
		--CastBar = self.Bulf.Settings.CastBar,
		BulfFirst = {
			CastBar = self.BulfFirst.Settings.CastBar,
		},
		BulfSecond = {
			CastBar = self.BulfSecond.Settings.CastBar,
		},
		BulfThird = {
			CastBar = self.BulfThird.Settings.CastBar,
		},
		BulfFinal = {
			CastBar = self.BulfFinal.Settings.CastBar,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		--MechTimer = KBM.Defaults.MechTimer(),
		--Alerts = KBM.Defaults.Alerts(),
		--MechSpy = KBM.Defaults.MechSpy(),
		--TimersRef = self.Bulf.Settings.TimersRef,
		--AlertsRef = self.Bulf.Settings.AlertsRef,
		--MechRef = self.Bulf.Settings.MechRef,
	}
	KBMNTRDMSBLF_Settings = self.Settings
	chKBMNTRDMSBLF_Settings = self.Settings
	
end

function BLF:SwapSettings(bool)

	if bool then
		KBMNTRDMSBLF_Settings = self.Settings
		self.Settings = chKBMNTRDMSBLF_Settings
	else
		chKBMNTRDMSBLF_Settings = self.Settings
		self.Settings = KBMNTRDMSBLF_Settings
	end

end

function BLF:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSBLF_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSBLF_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDMSBLF_Settings = self.Settings
	else
		KBMNTRDMSBLF_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function BLF:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSBLF_Settings = self.Settings
	else
		KBMNTRDMSBLF_Settings = self.Settings
	end	
end

function BLF:Castbar(units)
end

function BLF:RemoveUnits(UnitID)
	if self.Bulf.UnitID == UnitID then
		self.Bulf.Available = false
		return true
	end
	return false
end

function BLF:Death(UnitID)
	if self.BulfFirst.UnitID == UnitID then
		self.BulfFirst.Dead = true
		BLF.PhaseObj.Objectives:Remove()
		BLF.Phase = 2
		BLF.PhaseObj:SetPhase("Second Bulf")
		BLF.PhaseObj.Objectives:AddPercent(BLF.BulfSecond, 0, 100)	
	elseif self.BulfSecond.UnitID == UnitID then
		self.BulfSecond.Dead = true
		BLF.PhaseObj.Objectives:Remove()
		BLF.Phase = 3
		BLF.PhaseObj:SetPhase("Third Bulf")
		BLF.PhaseObj.Objectives:AddPercent(BLF.BulfThird, 0, 100)	
	elseif self.BulfThird.UnitID == UnitID then
		self.BulfThird.Dead = true
		BLF.PhaseObj.Objectives:Remove()
		BLF.Phase = 4
		BLF.PhaseObj:SetPhase("Final Bulf")
		BLF.PhaseObj.Objectives:AddPercent(BLF.BulfFinal, 0, 100)	
	elseif self.BulfFinal.UnitID == UnitID then
		self.BulfFinal.Dead = true
		return true
	end
	return false
end

function BLF:UnitHPCheck(uDetails, unitID)	
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
				BossObj.CastBar:Create(unitID)
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("First Bulf")
				self.PhaseObj.Objectives:AddPercent(self.BulfFirst, 0, 100)
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

function BLF:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.BulfFirst.CastBar:Remove()
	self.BulfSecond.CastBar:Remove()
	self.BulfThird.CastBar:Remove()
	self.BulfFinal.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function BLF:Timer()	
end

function BLF:Start()

	-- Create Timers
	
	
	-- Create Alerts
--	KBM.Defaults.AlertObj.Assign(self.Bulf)
	
	-- Create Spies
	--KBM.Defaults.MechObj.Assign(self.Bulf)

	-- Assign Alerts and Timers to Triggers
	
	self.BulfFirst.CastBar = KBM.Castbar:Add(self, self.BulfFirst)
	self.BulfSecond.CastBar = KBM.Castbar:Add(self, self.BulfSecond)
	self.BulfThird.CastBar = KBM.Castbar:Add(self, self.BulfThird)
	self.BulfFinal.CastBar = KBM.Castbar:Add(self, self.BulfFinal)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end