-- Vellion the Pestilent Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2012
--

KBMSLEXSBPVTP_Settings = nil
chKBMSLEXSBPVTP_Settings = nil

-- Link Mods
local AddonData, KBM = ...
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["EStorm_Breaker_Protocol"]

local MOD = {
	Directory = Instance.Directory,
	File = "Vellion.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Ex_Vellion",
	Object = "MOD",
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Vellion = KBM.Language:Add("Vellion the Pestilent")
MOD.Lang.Unit.Vellion:SetGerman("Vellion der Pestilente")
MOD.Lang.Unit.Vellion:SetFrench("Vellion la Pestilente")
MOD.Lang.Unit.VellionLT = KBM.Language:Add("Vellion's Left Trunk")
MOD.Lang.Unit.VellionLT:SetGerman("Vellions linker Rumpfschutz")
MOD.Lang.Unit.VellionLT:SetFrench("Tronc gauche de Vellion")
MOD.Lang.Unit.VellionRT = KBM.Language:Add("Vellion's Right Trunk")
MOD.Lang.Unit.VellionRT:SetGerman("Vellions rechter Brustschutz")
MOD.Lang.Unit.VellionRT:SetFrench("Tronc droit de Vellion")
MOD.Lang.Unit.VellionPS = KBM.Language:Add("Pestilence Spewer")
MOD.Lang.Unit.VellionPS:SetGerman("Pestilenz-Speier")
MOD.Lang.Unit.VellionPS:SetFrench("Régurgiteur de pestilence")
MOD.Lang.Unit.VellionEV = KBM.Language:Add("Vellion's Exposed Viscera")
MOD.Lang.Unit.VellionEV:SetGerman("Vellions Entblößte Eingeweide")
MOD.Lang.Unit.VellionEV:SetFrench("Entrailles exposées de Vellion")
MOD.Lang.Unit.AndShort = KBM.Language:Add("Vellion")
MOD.Lang.Unit.AndShort:SetGerman()
MOD.Lang.Unit.AndShort:SetFrench()
MOD.Lang.Unit.PSShort = KBM.Language:Add("Spewer")
MOD.Lang.Unit.PSShort:SetGerman("Speier")
MOD.Lang.Unit.PSShort:SetFrench("Régurgiteur")

-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.Vellion = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = MOD.Lang.Unit.Vellion[KBM.Lang],
	NameShort = MOD.Lang.Unit.AndShort[KBM.Lang],
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFED0887768D8CF74",
	TimeOut = 5,
	Triggers = {},
}

MOD.VellionEV = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = MOD.Lang.Unit.VellionEV[KBM.Lang],
	NameShort = MOD.Lang.Unit.AndShort[KBM.Lang],
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
	Triggers = {},
}

MOD.VellionPS = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = MOD.Lang.Unit.VellionPS[KBM.Lang],
	NameShort = MOD.Lang.Unit.PSShort[KBM.Lang],
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFB64832C19D102E7",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.VellionLT = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = MOD.Lang.Unit.VellionLT[KBM.Lang],
	NameShort = MOD.Lang.Unit.VellionLT[KBM.Lang],
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFE0D344F1E45C44C",
	TimeOut = 5,
	Triggers = {},
}

MOD.VellionRT = {
	Mod = MOD,
	Level = "62",
	Active = false,
	Name = MOD.Lang.Unit.VellionRT[KBM.Lang],
	NameShort = MOD.Lang.Unit.VellionRT[KBM.Lang],
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFD30EDED68E25407",
	TimeOut = 5,
	Triggers = {},
}

MOD.Descript = MOD.Vellion.Name

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Vellion.Name] = self.Vellion,
		[self.VellionEV.Name] = self.VellionEV,
		[self.VellionLT.Name] = self.VellionLT,
		[self.VellionRT.Name] = self.VellionRT,
		[self.VellionPS.Name] = self.VellionPS,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.VellionPS.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Vellion.Settings.TimersRef,
		-- AlertsRef = self.Vellion.Settings.AlertsRef,
	}
	KBMSLEXSBPVTP_Settings = self.Settings
	chKBMSLEXSBPVTP_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMSLEXSBPVTP_Settings = self.Settings
		self.Settings = chKBMSLEXSBPVTP_Settings
	else
		chKBMSLEXSBPVTP_Settings = self.Settings
		self.Settings = KBMSLEXSBPVTP_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLEXSBPVTP_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLEXSBPVTP_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLEXSBPVTP_Settings = self.Settings
	else
		KBMSLEXSBPVTP_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMSLEXSBPVTP_Settings = self.Settings
	else
		KBMSLEXSBPVTP_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Vellion.UnitID == UnitID then
		self.Vellion.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.VellionEV.UnitID == UnitID then
		self.VellionEV.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.Bosses[uDetails.name]
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
				self.PhaseObj.Objectives:AddPercent(self.VellionEV, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VellionLT, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VellionRT, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.VellionPS, 0, 100)
				self.Phase = 1
			end
			if BossObj == self.VellionPS then
				if BossObj.UnitID ~= unitID then
					if BossObj.CastBar.Active then
						BossObj.CastBar:Remove()
					end
					BossObj.CastBar:Create(unitID)
				end
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
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Vellion)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Vellion)
	
	-- Assign Alerts and Timers to Triggers
	
	self.VellionPS.CastBar = KBM.Castbar:Add(self, self.VellionPS)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end