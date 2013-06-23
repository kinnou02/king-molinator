-- Necrotic Throne Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMUBFNCT_Settings = nil
chKBMSLNMUBFNCT_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Unhallowed Boneforge"]

local MOD = {
	Directory = Instance.Directory,
	File = "Throne.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Throne",
	Object = "MOD",
}

MOD.Throne = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Necrotic Throne",
	NameShort = "Throne",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U52ADD1E218AEA8F1",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Throne = KBM.Language:Add(MOD.Throne.Name)
MOD.Lang.Unit.Throne:SetGerman("Nekrotischer Thron")
MOD.Lang.Unit.Throne:SetFrench("Trône nécrotique")
MOD.Lang.Unit.ThroneL = KBM.Language:Add("Left Throne")
MOD.Lang.Unit.ThroneL:SetGerman("Linker Thron")
MOD.Lang.Unit.ThroneR = KBM.Language:Add("Right Throne")
MOD.Lang.Unit.ThroneR:SetGerman("Rechter Thron")
MOD.Throne.Name = MOD.Lang.Unit.Throne[KBM.Lang]
MOD.Descript = MOD.Throne.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Throne")
MOD.Lang.Unit.AndShort:SetGerman("Thron")
MOD.Lang.Unit.AndShort:SetFrench("Trône")
MOD.Throne.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.ThroneL = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = MOD.Lang.Unit.Throne[KBM.Lang],
	DisplayName = MOD.Lang.Unit.ThroneL[KBM.Lang],
	NameShort = "Throne",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFCB7B9AC32357792",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

MOD.ThroneR = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = MOD.Lang.Unit.Throne[KBM.Lang],
	DisplayName = MOD.Lang.Unit.ThroneR[KBM.Lang],
	NameShort = "Throne",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U4DF68627120121D0",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Throne.Name] = self.Throne,
		[self.ThroneL.DisplayName] = self.ThroneL,
		[self.ThroneR.DisplayName] = self.ThroneR,
	}
	
	for Boss, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Multi = true
				BossObj.Settings.CastBar.Override = true
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
		Throne = {
			CastBar = self.Throne.Settings.CastBar,
		},
		ThroneL = {
			CastBar = self.ThroneL.Settings.CastBar,
		},
		ThroneR = {
			CastBar = self.ThroneR.Settings.CastBar,
		},
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Throne.Settings.TimersRef,
		-- AlertsRef = self.Throne.Settings.AlertsRef,
	}
	KBMSLNMUBFNCT_Settings = self.Settings
	chKBMSLNMUBFNCT_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMUBFNCT_Settings = self.Settings
		self.Settings = chKBMSLNMUBFNCT_Settings
	else
		chKBMSLNMUBFNCT_Settings = self.Settings
		self.Settings = KBMSLNMUBFNCT_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMUBFNCT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMUBFNCT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMUBFNCT_Settings = self.Settings
	else
		KBMSLNMUBFNCT_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMUBFNCT_Settings = self.Settings
	else
		KBMSLNMUBFNCT_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Throne.UnitID == UnitID then
		self.Throne.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Throne.UnitID == UnitID then
		self.Throne.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj == nil or BossObj == self.Titan then
			return
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
				BossObj.UnitID = unitID
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
				self.PhaseObj.Objectives:AddPercent(self.Throne, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.ThroneL, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.ThroneR, 0, 100)
				self.Phase = 1
			else
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			self.Throne.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Throne)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Throne)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Throne.CastBar = KBM.CastBar:Add(self, self.Throne)
	self.ThroneL.CastBar = KBM.CastBar:Add(self, self.ThroneL)
	self.ThroneR.CastBar = KBM.CastBar:Add(self, self.ThroneR)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end