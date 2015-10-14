-- Baird Bringhurst Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTRTECBAI_Settings = nil
chKBMNTRTECBAI_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["RTEmpyrean_Core"]

local MOD = {
	Directory = Instance.Directory,
	File = "Baird.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "RTEC_Baird",
	Object = "MOD",
	--Enrage = 5*60,
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Baird = KBM.Language:Add("Baird Bringhurst")
MOD.Lang.Unit.Baird:SetGerman("Baird Bringhurst")
MOD.Lang.Unit.Baird:SetFrench("Baird Lèvecolline")

-- Aditional Unit Dictionary
MOD.Lang.Unit.Sprout = KBM.Language:Add("Tartary Sprout")
MOD.Lang.Unit.Sprout:SetFrench("Pousse de Tartary")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.SpurGrowth = KBM.Language:Add("Spur Growth")
MOD.Lang.Ability.SpurGrowth:SetFrench("Croissance stimulée")
MOD.Lang.Ability.Manic = KBM.Language:Add("Manic Assault")
MOD.Lang.Ability.Manic:SetFrench("Assaut obsessionnel")

-- Verbose Dictionary
MOD.Lang.Verbose = {}
MOD.Lang.Verbose.SpurGrowthWarn = KBM.Language:Add("Kill the plant!")
MOD.Lang.Verbose.SpurGrowthWarn:SetFrench("Tuez la plante!!!")
MOD.Lang.Verbose.HideWarn = KBM.Language:Add("Hide behind the pillar!")
MOD.Lang.Verbose.HideWarn:SetFrench("Cachez vous!!!")

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictioanry
MOD.Lang.Notify = {}
--MOD.Lang.Notify.HideWarn = KBM.Language:Add("Destroy... EVERYTHING!")

-- Say Dictionary
MOD.Lang.Say = {}
MOD.Lang.Say.HideWarn = KBM.Language:Add("Baird Bringhurst: Destroy... EVERYTHING!")
MOD.Lang.Say.HideWarn:SetFrench("Détruisez... TOUT !")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Baird[KBM.Lang]

MOD.Baird = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Baird[KBM.Lang],
	NameShort = "Baird",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U3223DE352757D4E3",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			SpurGrowth = KBM.Defaults.AlertObj.Create("dark_green"),
			Manic = KBM.Defaults.AlertObj.Create("red"),
			HideWarn = KBM.Defaults.AlertObj.Create("blue"),
		},
	},
}

MOD.Sprout = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Sprout[KBM.Lang],
	NameShort = "Sprout",
	Menu = {},
	--Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U63FA047E3D88176C",
	TimeOut = 5,
	--Triggers = {},
	--Settings = {
		--CastBar = KBM.Defaults.Castbar(),
	--}
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Baird.Name] = self.Baird,
		[self.Sprout.Name] = self.Sprout,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Baird.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		AlertsRef = self.Baird.Settings.AlertsRef,
	}
	KBMNTRTECBAI_Settings = self.Settings
	chKBMNTRTECBAI_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTRTECBAI_Settings = self.Settings
		self.Settings = chKBMNTRTECBAI_Settings
	else
		chKBMNTRTECBAI_Settings = self.Settings
		self.Settings = KBMNTRTECBAI_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRTECBAI_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRTECBAI_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRTECBAI_Settings = self.Settings
	else
		KBMNTRTECBAI_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRTECBAI_Settings = self.Settings
	else
		KBMNTRTECBAI_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Baird.UnitID == UnitID then
		self.Baird.Available = false
		return true
	--elseif self.Sprout.UnitID == UnitID then
	--	self.Sprout.Available = false
	--	return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Baird.UnitID == UnitID then
		self.Baird.Dead = true
		return true
	elseif self.Sprout.UnitID == UnitID then
  	self.Sprout.Dead = true
  	self.PhaseObj.Objectives:Remove(2)
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Baird.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Baird.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Baird.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
	end
	self.Baird.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:plantObj()
  self.PhaseObj.Objectives:AddPercent(self.Sprout, 0, 100)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	self.Baird.AlertsRef.HideWarn = KBM.Alert:Create(self.Lang.Verbose.HideWarn[KBM.Lang], nil, true, false, "blue")
	self.Baird.AlertsRef.SpurGrowth = KBM.Alert:Create(self.Lang.Verbose.SpurGrowthWarn[KBM.Lang], nil, true, false, "dark_green")
	self.Baird.AlertsRef.Manic = KBM.Alert:Create(self.Lang.Ability.Manic[KBM.Lang], nil, false, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Baird)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Baird.Triggers.HideWarn = KBM.Trigger:Create(self.Lang.Say.HideWarn[KBM.Lang], "say", self.Baird)
	self.Baird.Triggers.HideWarn:AddAlert(self.Baird.AlertsRef.HideWarn)
	
	self.Baird.Triggers.SpurGrowthWarn = KBM.Trigger:Create(self.Lang.Ability.SpurGrowth[KBM.Lang], "cast", self.Baird)
	self.Baird.Triggers.SpurGrowthWarn:AddAlert(self.Baird.AlertsRef.SpurGrowth)
	-- self.Baird.Triggers.SpurGrowthWarn:AddPhase(self.plantObj)
	
	self.Baird.Triggers.Manic = KBM.Trigger:Create(self.Lang.Ability.Manic[KBM.Lang], "channel", self.Baird)
	self.Baird.Triggers.Manic:AddAlert(self.Baird.AlertsRef.Manic)
	
	
	
	self.Baird.CastBar = KBM.Castbar:Add(self, self.Baird)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end