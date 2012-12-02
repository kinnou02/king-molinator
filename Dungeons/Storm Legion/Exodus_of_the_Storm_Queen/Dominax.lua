-- Dominax Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLNMSQDX_Settings = nil
chKBMSLNMSQDX_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Exodus of the Storm Queen"]

local MOD = {
	Directory = Instance.Directory,
	File = "Dominax.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Norm_Dominax",
	Object = "MOD",
}

MOD.Dominax = {
	Mod = MOD,
	Level = "52",
	Active = false,
	Name = "Dominax",
	NameShort = "Dominax",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	UTID = {
		[1] = "UFD1CF44625E9D7D8",
		[2] = "UFD86E1980386C4F2",
	},
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

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Dominax = KBM.Language:Add(MOD.Dominax.Name)
MOD.Lang.Unit.Dominax:SetGerman()
MOD.Lang.Unit.Dominax:SetFrench()
MOD.Dominax.Name = MOD.Lang.Unit.Dominax[KBM.Lang]
MOD.Descript = MOD.Dominax.Name
MOD.Lang.Unit.AndShort = KBM.Language:Add("Dominax")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Dominax.NameShort = MOD.Lang.Unit.AndShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Dominax.Name] = self.Dominax,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Dominax.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Dominax.Settings.TimersRef,
		-- AlertsRef = self.Dominax.Settings.AlertsRef,
	}
	KBMSLNMSQDX_Settings = self.Settings
	chKBMSLNMSQDX_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLNMSQDX_Settings = self.Settings
		self.Settings = chKBMSLNMSQDX_Settings
	else
		chKBMSLNMSQDX_Settings = self.Settings
		self.Settings = KBMSLNMSQDX_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLNMSQDX_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLNMSQDX_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLNMSQDX_Settings = self.Settings
	else
		KBMSLNMSQDX_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLNMSQDX_Settings = self.Settings
	else
		KBMSLNMSQDX_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD.PhaseFinal()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj.Objectives:AddPercent(MOD.Dominax.Name, 0, 100)
	MOD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	MOD.Phase = 2
end

function MOD:RemoveUnits(UnitID)
	if self.Dominax.UnitID == UnitID then
		self.Dominax.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Dominax.UnitID == UnitID then
		if self.Dominax.Type == self.Dominax.UTID[2] then
			self.Dominax.Dead = true
			return true
		end
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			BossObj.Type = uDetails.type
			BossObj.UnitID = unitID
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				self.Timeout = 25
				if self.Dominax.UTID[1] == uDetails.type then
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Dominax, 0, 100)
					self.Phase = 1
				end
			end
			if BossObj.Type == self.Dominax.UTID[2] then
				if self.Phase == 1 then
					self.PhaseFinal()
					self.Timeout = 0
				end
			end
			if BossObj.UnitID ~= unitID then
				if BossObj.CastBar.Active then
					BossObj.CastBar:Remove()
				end
				BossObj.CastBar:Create(unitID)
			end
			BossObj.Available = true
			return BossObj
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Dominax.Available = false
	self.Dominax.UnitID = nil
	self.Dominax.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase = 1
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Dominax, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Dominax)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Dominax)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Dominax.CastBar = KBM.CastBar:Add(self, self.Dominax)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end