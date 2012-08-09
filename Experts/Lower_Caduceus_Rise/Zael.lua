-- Ashcaller Zael Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXLCRAZ_Settings = nil
chKBMEXLCRAZ_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Lower_Caduceus_Rise"]

local MOD = {
	Directory = Instance.Directory,
	File = "Zael.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Zael",
	Object = "MOD",
}

MOD.Zael = {
	Mod = MOD,
	Level = "??",
	Active = false,
	Name = "Ashcaller Zael",
	NameShort = "Zael",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	ExpertID = "U40AB35D43F4C1B09",
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
MOD.Lang.Unit.Zael = KBM.Language:Add(MOD.Zael.Name)
MOD.Lang.Unit.Zael:SetGerman("Ascherufer Zael")
MOD.Lang.Unit.Zael:SetFrench("Zael le mande-cendres")
MOD.Lang.Unit.Zael:SetRussian("Заклинатель Пепла Заэль")
MOD.Lang.Unit.Zael:SetKorean("잿빛소환사 질")
MOD.Zael.Name = MOD.Lang.Unit.Zael[KBM.Lang]
MOD.Descript = MOD.Zael.Name
MOD.Lang.Unit.ZaelShort = KBM.Language:Add("Zael")
MOD.Lang.Unit.ZaelShort:SetGerman()
MOD.Lang.Unit.ZaelShort:SetFrench()
MOD.Lang.Unit.ZaelShort:SetRussian("Заэль")
MOD.Lang.Unit.ZaelShort:SetKorean("질")
MOD.Zael.NameShort = MOD.Lang.Unit.ZaelShort[KBM.Lang]

-- Ability Dictionary
MOD.Lang.Ability = {}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Zael.Name] = self.Zael,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Zael.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Zael.Settings.TimersRef,
		-- AlertsRef = self.Zael.Settings.AlertsRef,
	}
	KBMEXLCRAZ_Settings = self.Settings
	chKBMEXLCRAZ_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXLCRAZ_Settings = self.Settings
		self.Settings = chKBMEXLCRAZ_Settings
	else
		chKBMEXLCRAZ_Settings = self.Settings
		self.Settings = KBMEXLCRAZ_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXLCRAZ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXLCRAZ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXLCRAZ_Settings = self.Settings
	else
		KBMEXLCRAZ_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXLCRAZ_Settings = self.Settings
	else
		KBMEXLCRAZ_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Zael.UnitID == UnitID then
		self.Zael.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Zael.UnitID == UnitID then
		self.Zael.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.type == self.Zael.ExpertID then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Zael.Dead = false
					self.Zael.Casting = false
					self.Zael.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Zael.Name, 0, 100)
					self.Phase = 1
				end
				self.Zael.UnitID = unitID
				self.Zael.Available = true
				return self.Zael
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	self.Zael.Available = false
	self.Zael.UnitID = nil
	self.Zael.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Zael, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Zael)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Zael)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Zael.CastBar = KBM.CastBar:Add(self, self.Zael)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end