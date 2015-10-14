-- Corrupted Kondraum Boss Mod for King Boss Mods
-- Written by Maatang
-- July 2015
--

KBMNTCOIKON_Settings = nil
chKBMNTCOIKON_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local Instance = KBM.BossMod["Citadel_of_Insanity"]

local MOD = {
	Directory = Instance.Directory,
	File = "Kondraum.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "COI_Kondraum",
	Object = "MOD",
	--Enrage = 5*60,
	Counts = {
  	Corruption = 0,
  	},
	CountsA = {
	 Corruption = 0,
	 },
}

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Kondraum = KBM.Language:Add("Corrupted Kondraum")
MOD.Lang.Unit.Kondraum:SetFrench("Kondraum corrompu")

-- Aditional Unit Dictionary
MOD.Lang.Unit.Corruption = KBM.Language:Add("Corruption of Kondraum")
MOD.Lang.Unit.Corruption:SetFrench("Corruption de Kondraum")

-- Ability Dictionary
MOD.Lang.Ability = {}
MOD.Lang.Ability.Torrent = KBM.Language:Add("Torrent of Pain")
MOD.Lang.Ability.Torrent:SetFrench("Torrent de Douleur")

-- Verbose Dictionary
MOD.Lang.Verbose = {}

-- Buff Dictionary
MOD.Lang.Buff = {}
MOD.Lang.Buff.Corrupt = KBM.Language:Add("Corruption of Lord Arak")
MOD.Lang.Buff.Corrupt:SetFrench("Corruption du Seigneur Arak")

-- Debuff Dictionary
MOD.Lang.Debuff = {}
MOD.Lang.Debuff.Trail = KBM.Language:Add("Trail of Darkness")
MOD.Lang.Debuff.Trail:SetFrench("Piste des ténèbres")

-- Notify Dictionary
MOD.Lang.Notify = {}
MOD.Lang.Notify.Victory = KBM.Language:Add("Kondraum says, \"*Cough* Oomf...wha'? Progenitor? Were we fighting? Oh it must have been that wicked wine! Whew, I think you beat it out of me, though! Right Liver?\"")
MOD.Lang.Notify.Victory:SetFrench("Kondraum dit : \"*Tousse* Ouille... Hein ? Progéniteur ? On se battait ? C'est la faute de ce vin de cauchemar, ça ! Ouah, vous m'avez mis une bonne raclée, en tout cas ! Pas vrai, Foie ?\"")

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Descript = MOD.Lang.Unit.Kondraum[KBM.Lang]

MOD.Kondraum = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = MOD.Lang.Unit.Kondraum[KBM.Lang],
	NameShort = "Kondraum",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U5746F04C2B692C05",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

MOD.Corruption = {
	Mod = MOD,
	Level = "67",
	Name = MOD.Lang.Unit.Corruption[KBM.Lang],
	--NameShort ="Corruption",
	UnitList = {},
	Ignore = true,
	Type = "multi",
	UTID = "U51F99A3B2D50B985",
}

KBM.RegisterMod(MOD.ID, MOD)

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Kondraum.Name] = self.Kondraum,
		[self.Corruption.Name] = self.Corruption
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Kondraum.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Baird.Settings.TimersRef,
		-- AlertsRef = self.Baird.Settings.AlertsRef,
	}
	KBMNTCOIKON_Settings = self.Settings
	chKBMNTCOIKON_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMNTCOIKON_Settings = self.Settings
		self.Settings = chKBMNTCOIKON_Settings
	else
		chKBMNTCOIKON_Settings = self.Settings
		self.Settings = KBMNTCOIKON_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTCOIKON_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTCOIKON_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTCOIKON_Settings = self.Settings
	else
		KBMNTCOIKON_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMNTCOIKON_Settings = self.Settings
	else
		KBMNTCOIKON_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Kondraum.UnitID == UnitID then
		self.Kondraum.Available = false
		--return true
	elseif self.Corruption.UnitList[UnitID] then
	  self.CountsA.Corruption = self.CountsA.Corruption + 1
	  self.Corruption.UnitList[UnitID].Available = false
	  
	  if self.CountsA.Corruption == 6 then
	     return true
	  end
	  
	end
	return false
end

function MOD:Death(UnitID)
	if self.Corruption.UnitList[UnitID] then
        self.Counts.Corruption = self.Counts.Corruption + 1
        self.Corruption.UnitList[UnitID].Dead = true
		if self.Counts.Corruption == 6 then
			return true
		end
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID) 
  if uDetails and unitID then
    if not uDetails.player then
      if self.Bosses[uDetails.name] then
        if uDetails.name == self.Kondraum.Name then
          if not self.EncounterRunning then
            self.EncounterRunning = true
            self.StartTime = Inspect.Time.Real()
            self.HeldTime = self.StartTime
            self.TimeElapsed = 0
            self.Phase = 1
            self.PhaseObj.Objectives:AddDeath(MOD.Corruption.Name, 6)
            self.PhaseObj:SetPhase(1)
            self.PhaseObj:Start(self.StartTime)
          end
          self.Kondraum.Casting = false
          self.Kondraum.UnitID = unitID
          self.Kondraum.Available = true
          return self.Kondraum
        elseif self.EncounterRunning then
          if not self.Bosses[uDetails.name].UnitList[unitID] then
            local SubBossObj = {
              Mod = MOD,
              Level = "67",
              Name = uDetails.name,
              Dead = false,
              Casting = false,
              UnitID = unitID,
              Available = true,
            }
            self.Bosses[uDetails.name].UnitList[unitID] = SubBossObj
          else
            self.Bosses[uDetails.name].UnitList[unitID].Available = true
            self.Bosses[uDetails.name].UnitList[unitID].UnitID = unitID
          end
          return self.Bosses[uDetails.name].UnitList[unitID]
        end
      end
    end
  end 
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Kondraum.Available = false
	self.Kondraum.UnitID = nil
	self.Kondraum.CastBar:Remove()
	self.Counts.Corruption = 0
	self.CountsA.Corruption = 0
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Baird)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Baird)
	
	-- Assign Alerts and Timers to Triggers
	self.Kondraum.Triggers.Victory = KBM.Trigger:Create(self.Lang.Notify.Victory[KBM.Lang], "notify", self.Kondraum)
	self.Kondraum.Triggers.Victory:SetVictory()
	
	self.Kondraum.CastBar = KBM.Castbar:Add(self, self.Kondraum)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end