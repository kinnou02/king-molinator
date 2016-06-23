-- Manifestation of Lord Arak Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTNCARK_Settings = nil
chKBMNTNCARK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Nightmare_Coast"]

local MOD = {
	Directory = Instance.Directory,
	File = "Arak.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "NC_Arak",
	Object = "MOD",
	--Enrage = 5*60,
	Counts = {
		Terror = 0,
  	},
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Arak = KBM.Language:Add("Manifestation of Lord Arak")
MOD.Lang.Unit.Arak:SetFrench("Manifestation du Seigneur Arak")

-- Aditional Unit Dictionary
MOD.Lang.Unit.Terror = KBM.Language:Add("Manifest Terror")
MOD.Lang.Unit.Terror:SetFrench("Terreur manifeste")

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}

-- Debuff Dictionary
MOD.Lang.Debuff = {}

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Energy = KBM.Language:Add("The air crackles with a terrifying energy...")
MOD.Lang.Notify.Energy:SetFrench("L'air crépite d'une énergie terrifiante!")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Arak[KBM.Lang]

MOD.Arak = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Arak[KBM.Lang],
	NameShort = "Arak",
	Menu = {},
	AlertsRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFFFD53764B52B851",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Energy = KBM.Defaults.AlertObj.Create("red"),
		},
	},
}

MOD.Terror1 = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Terror[KBM.Lang],
	--NameShort = "Terror",
	Menu = {},
	-- Type = "multi",
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "UFFEC578273AE7331",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Terror2 = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Terror[KBM.Lang],
	--NameShort = "Terror",
	Menu = {},
	-- Type = "multi",
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U11C9BE4D16EBD99B",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Terror3 = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Terror[KBM.Lang],
	--NameShort = "Terror",
	Menu = {},
	-- Type = "multi",
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U1BC3D0C514AC51ED",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Terror4 = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Terror[KBM.Lang],
	--NameShort = "Terror",
	Menu = {},
	-- Type = "multi",
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U23EDA12C64EFC43C",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
	[self.Arak.Name] = self.Arak,
	--[self.Terror.Name] = self.Terror,
	[self.Terror1.Name] = self.Terror1,
    [self.Terror2.Name] = self.Terror2,
    [self.Terror3.Name] = self.Terror3,
    [self.Terror4.Name] = self.Terror4,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arak.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		Arak = {
			CastBar = self.Arak.Settings.CastBar,
			AlertsRef = self.Arak.Settings.AlertsRef,
		},
		Terror1 = {
			CastBar = self.Terror1.Settings.CastBar,
			AlertsRef = self.Terror1.Settings.AlertsRef,
		},
		Terror2 = {
			CastBar = self.Terror2.Settings.CastBar,
			AlertsRef = self.Terror2.Settings.AlertsRef,
		},
		Terror3 = {
			CastBar = self.Terror3.Settings.CastBar,
			AlertsRef = self.Terror3.Settings.AlertsRef,
		},
		Terror4 = {
			CastBar = self.Terror4.Settings.CastBar,
			AlertsRef = self.Terror4.Settings.AlertsRef,
		},
	}
	KBMNTNCARK_Settings = self.Settings
	chKBMNTNCARK_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTNCARK_Settings = self.Settings
		self.Settings = chKBMNTNCARK_Settings
	else
		chKBMNTNCARK_Settings = self.Settings
		self.Settings = KBMNTNCARK_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTNCARK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTNCARK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTNCARK_Settings = self.Settings
	else
		KBMNTNCARK_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTNCARK_Settings = self.Settings
	else
		KBMNTNCARK_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD.SetObjectives(uDetails, unitID)
	if uDetails.Type == MOD.Terror1.UTID then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Terror1.Name, 0, 100)
	elseif uDetails.Type == MOD.Terror2.UTID then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Terror2.Name, 0, 100)
	elseif uDetails.Type == MOD.Terror3.UTID then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Terror3.Name, 0, 100)
	elseif uDetails.Type == MOD.Terror4.UTID then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Terror4.Name, 0, 100)
	end
 end

function MOD:RemoveUnits(UnitID)
	if self.Arak.UnitID == UnitID then
		self.Arak.Available = false
		return true
	end
	-- if self.Terror1.UnitID == UnitID then
		-- self.Terror1.Available = false
	-- elseif self.Terror2.UnitID == UnitID then
		-- self.Terror2.Available = false
	-- elseif self.Terror3.UnitID == UnitID then
		-- self.Terror3.Available = false
	-- elseif self.Terror4.UnitID == UnitID then
		-- self.Terror4.Available = false
	-- end
	
	-- if not self.Terror1.Available and not self.Terror2.Available and not self.Terror1.Available and not self.Terror4.Available then
		-- return true
	-- end
	
	return false
end

function MOD:Death(UnitID)
	-- if self.Arak.UnitID == UnitID then
		-- self.Arak.Dead = true
		-- return true
	if self.Terror1.UnitID == UnitID then
		self.Terror1.Dead = true
	elseif self.Terror2.UnitID == UnitID then
		self.Terror2.Dead = true
	elseif self.Terror3.UnitID == UnitID then
		self.Terror3.Dead = true
	elseif self.Terror4.UnitID == UnitID then
		self.Terror4.Dead = true
	end
	
	if self.Terror1.Dead and self.Terror2.Dead and self.Terror3.Dead and self.Terror4.Dead then
	  return true
	end
	-- if self.Terror.UnitList[UnitID] then
        -- self.Counts.Terror = self.Counts.Terror + 1
        -- self.Terror.UnitList[UnitID].Dead = true
		-- if self.Counts.Terror == 4 then
			-- return true
		-- end
	-- end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)
	print("arak ok")
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Terror1.Name then
			-- print (uDetails)
			--if uDetails.type == MOD.Terror1.UTID or uDetails.type == MOD.Terror2.UTID or uDetails.type == MOD.Terror3.UTID or uDetails.type == MOD.Terror4.UTID then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.SetObjectives(uDetails, unitID)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Arak.Name then
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
    BossObj.Casting = false
  end
  self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Arak)
	
	-- Create Alerts
	self.Arak.AlertsRef.Energy = KBM.Alert:Create(self.Lang.Notify.Energy[KBM.Lang], nil, true, false, "red")
	KBM.Defaults.AlertObj.Assign(self.Arak)
	
	-- Assign Alerts and Timers to Triggers
	self.Arak.Triggers.Energy = KBM.Trigger:Create(self.Lang.Notify.Energy[KBM.Lang], "notify", self.Arak)
	self.Arak.Triggers.Energy:AddAlert(self.Arak.AlertsRef.Energy)
	
	self.Arak.CastBar = KBM.Castbar:Add(self, self.Arak)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end