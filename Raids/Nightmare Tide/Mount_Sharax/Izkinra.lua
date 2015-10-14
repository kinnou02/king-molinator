-- Ilrath and Shaddoth Boss Mod for King Boss Mods
-- Written by Lupercal@Brisesol
-- Copyright 2015
--

KBMNTRDMSIZ_Settings = nil
chKBMNTRDMSIZ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local MS = KBM.BossMod["RMount_Sharax"]

local IZ = {
	Enabled = true,
	Directory = MS.Directory,
	File = "Izkinra.lua",
	Instance = MS.Name,
	InstanceObj = MS,
	HasPhases = true,
	Lang = {},
	ID = "Izkinra",
	Object = "IZ",
	Enrage = 9 * 60 + 30,
}

KBM.RegisterMod(IZ.ID, IZ)

-- Main Unit Dictionary
IZ.Lang.Unit = {}
IZ.Lang.Unit.Ilrath = KBM.Language:Add("Warmaster Ilrath")
IZ.Lang.Unit.Ilrath:SetGerman()
IZ.Lang.Unit.Ilrath:SetFrench("Maître de guerre Ilrath") 
IZ.Lang.Unit.IlrathShort = KBM.Language:Add("Ilrath")
IZ.Lang.Unit.IlrathShort:SetGerman()
IZ.Lang.Unit.IlrathShort:SetFrench("Ilrath") 
IZ.Lang.Unit.Shaddoth = KBM.Language:Add("Warmaster Shaddoth")
IZ.Lang.Unit.Shaddoth:SetGerman()
IZ.Lang.Unit.Shaddoth:SetFrench("Maître de guerre Shaddoth") 
IZ.Lang.Unit.ShaddothShort = KBM.Language:Add("Shaddoth")
IZ.Lang.Unit.ShaddothShort:SetGerman()
IZ.Lang.Unit.ShaddothShort:SetFrench("Shaddoth") 
IZ.Lang.Unit.Izkinra = KBM.Language:Add("Izkinra")
IZ.Lang.Unit.Izkinra:SetGerman("Izkinra")
IZ.Lang.Unit.Izkinra:SetFrench("Izkinra")

-- Ability Dictionary
IZ.Lang.Ability = {}


-- Debuff Dictionary
IZ.Lang.Debuff = {}


-- Verbose Dictionary
IZ.Lang.Verbose = {}


-- Description Dictionary
IZ.Lang.Main = {}
IZ.Lang.Main.Descript = KBM.Language:Add("Izkinra")
IZ.Lang.Main.Descript:SetGerman("Izkinra")
IZ.Lang.Main.Descript:SetFrench("Izkinra")
IZ.Descript = IZ.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
IZ.Ilrath = {
	Mod = IZ,
	Level = "??",
	Active = false,
	Name = IZ.Lang.Unit.Ilrath[KBM.Lang],
	NameShort = IZ.Lang.Unit.IlrathShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U1E7F1D3A589DD98B",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
		},
		AlertsRef = {
			Enabled = true,
		},
		MechRef = {
			Enabled = true,
		},
	}
}

IZ.Shaddoth = {
	Mod = IZ,
	Level = "??",
	Active = false,
	Name = IZ.Lang.Unit.Shaddoth[KBM.Lang],
	NameShort = IZ.Lang.Unit.ShaddothShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U6CCFF7963FC160AF",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
		},
		AlertsRef = {
			Enabled = true,
		},
		MechRef = {
			Enabled = true,
		},
	}
}

IZ.Izkinra = {
	Mod = IZ,
	Level = "??",
	Active = false,
	Name = IZ.Lang.Unit.Izkinra[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	Castbar = nil,
	AlertsRef = {},
	Triggers = {},
	Ignore = true,
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
		},
		AlertsRef = {
			Enabled = true,
		},
		MechRef = {
			Enabled = true,
		},
	},
}

function IZ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Ilrath.Name] = self.Ilrath,
		[self.Shaddoth.Name] = self.Shaddoth,
		[self.Izkinra.Name] = self.Izkinra,
	}
end

function IZ:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		Ilrath = {
			CastBar = self.Ilrath.Settings.CastBar,
			AlertsRef = self.Ilrath.Settings.AlertsRef,
			TimersRef = self.Ilrath.Settings.TimersRef,
			MechRef = self.Ilrath.Settings.MechRef,
		},
		Shaddoth = {
			CastBar = self.Shaddoth.Settings.CastBar,
			AlertsRef = self.Shaddoth.Settings.AlertsRef,
			TimersRef = self.Shaddoth.Settings.TImersRef,
			MechRef = self.Shaddoth.Settings.MechRef,
		},
		Izkinra = {
			CastBar = self.Izkinra.Settings.CastBar,
			AlertsRef = self.Izkinra.Settings.AlertsRef,
			TimersRef = self.Izkinra.Settings.TImersRef,
			MechRef = self.Izkinra.Settings.MechRef,
		},
	}
	KBMNTRDMSIZ_Settings = self.Settings
	chKBMNTRDMSIZ_Settings = self.Settings	
end

function IZ:SwapSettings(bool)
	if bool then
		KBMNTRDMSIZ_Settings = self.Settings
		self.Settings = chKBMNTRDMSIZ_Settings
	else
		chKBMNTRDMSIZ_Settings = self.Settings
		self.Settings = KBMNTRDMSIZ_Settings
	end
end

function IZ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSIZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSIZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDMSIZ_Settings = self.Settings
	else
		KBMNTRDMSIZ_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function IZ:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSIZ_Settings = self.Settings
	else
		KBMNTRDMSIZ_Settings = self.Settings
	end	
end

function IZ:Castbar(units)
end

-- function IZ:RemoveUnits(UnitID)
	-- if self.Ilrath.UnitID == UnitID then
		-- self.Ilrath.Available = false
		-- return true
	-- end
	-- return false
-- end

function IZ:Death(UnitID)
	if self.Ilrath.UnitID == UnitID then
		self.Ilrath.Dead = true
		if self.Shaddoth.Dead then
			IZ.PhaseFinal()
		end
	elseif self.Shaddoth.UnitID == UnitID then
		self.Shaddoth.Dead = true
		if self.Ilrath.Dead then
			IZ.PhaseFinal()
		end
	elseif self.Izkinra.Dead then
		return true
	end
	return false
end

function IZ.PhaseFinal()
	if IZ.Phase < 2 then
		IZ.PhaseObj.Objectives:Remove()
		IZ.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		IZ.PhaseObj.Objectives:AddPercent(IZ.Izkinra, 0, 100)
		IZ.Phase = 2
	end
end

function IZ:UnitHPCheck(uDetails, unitID)
	local BossObj = self.Bosses[uDetails.name]
	if uDetails and unitID then
		if uDetails.type then
			local BossObj = self.UTID[uDetails.type]
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
					self.PhaseObj.Objectives:AddPercent(self.Ilrath, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Shaddoth, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.CastBar then
						if BossObj.UnitID ~= unitID then
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
end

function IZ:Reset()
	self.EncounterRunning = false
	self.Shaddoth.UnitID = nil
	self.Ilrath.UnitID = nil
	self.Izkinra.UnitID = nil
	self.Shaddoth.Dead = false
	self.Shaddoth.CastBar:Remove()
	self.Ilrath.Dead = false
	self.Ilrath.CastBar:Remove()
	self.Izkinra.Dead = false
	self.Izkinra.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function IZ:Timer()	
end

function IZ:DefineMenu()
	self.Menu = MS.Menu:CreateEncounter(self.Izkinra, self.Enabled)
end

function IZ:Start()
	-- Create Timers

	KBM.Defaults.TimerObj.Assign(self.Ilrath)

	KBM.Defaults.TimerObj.Assign(self.Shaddoth)
	
	-- Create Alerts
	KBM.Defaults.AlertObj.Assign(self.Ilrath)
	
	KBM.Defaults.AlertObj.Assign(self.Shaddoth)

	-- KBM.Defaults.AlertObj.Assign(self.Izkinra)

	-- Create Spies

	KBM.Defaults.MechObj.Assign(self.Ilrath)

	KBM.Defaults.MechObj.Assign(self.Shaddoth)
	
	-- KBM.Defaults.MechObj.Assign(self.Izkinra)
	
	-- Assign Alerts and Timers to Triggers
	
	-- self.PercentageMon = KBM.PercentageMon:Create(self.Ilrath, self.Shaddoth, 5)
	self.Ilrath.CastBar = KBM.Castbar:Add(self, self.Ilrath)
	self.Shaddoth.CastBar = KBM.Castbar:Add(self, self.Shaddoth)
	self.Izkinra.CastBar = KBM.Castbar:Add(self, self.Izkinra)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end