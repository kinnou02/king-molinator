-- Queen Vallnara Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMEXFCQV_Settings = nil
chKBMEXFCQV_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Foul Cascade"]

local MOD = {
	Directory = Instance.Directory,
	File = "Vallnara.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "Vallnara",
	Object = "MOD",
}

MOD.Vallnara = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Queen Vallnara",
	NameShort = "Vallnara",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	UTID = "none",
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
MOD.Lang.Unit.Vallnara = KBM.Language:Add(MOD.Vallnara.Name)
MOD.Lang.Unit.Vallnara:SetGerman("Königin Vallnara")
MOD.Lang.Unit.Vallnara:SetFrench("Reine Vallnara")
MOD.Lang.Unit.Vallnara:SetRussian("Королева Вальнара")
MOD.Lang.Unit.Vallnara:SetKorean("발나라 여왕")
MOD.Vallnara.Name = MOD.Lang.Unit.Vallnara[KBM.Lang]
MOD.Descript = MOD.Vallnara.Name
MOD.Lang.Unit.ValShort = KBM.Language:Add("Vallnara")
MOD.Lang.Unit.ValShort:SetGerman("Vallnara")
MOD.Lang.Unit.ValShort:SetFrench("Vallnara")
MOD.Lang.Unit.ValShort:SetRussian("Вальнара")
MOD.Lang.Unit.ValShort:SetKorean("발나라")
MOD.Vallnara.NameShort = MOD.Lang.Unit.ValShort[KBM.Lang]
MOD.Lang.Unit.CorruptQueen = KBM.Language:Add("Corrupted Queen Vallnara")
MOD.Lang.Unit.CorruptQueen:SetGerman("Verdorbene Königin Vallnara")
MOD.Lang.Unit.CorruptQueen:SetFrench("Reine Corrompue Vallnara")
MOD.Lang.Unit.CorruptQueen:SetRussian("Измененная королева Вальнара")
MOD.Lang.Unit.CorruptQueen:SetKorean("타락한 여왕 발나라")

-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.CorruptQueen = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.CorruptQueen[KBM.Lang],
	NameShort = MOD.Lang.Unit.ValShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "none",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Vallnara.Name] = self.Vallnara,
		[self.CorruptQueen.Name] = self.CorruptQueen,
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Vallnara.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Vallnara.Settings.TimersRef,
		-- AlertsRef = self.Vallnara.Settings.AlertsRef,
	}
	KBMEXFCQV_Settings = self.Settings
	chKBMEXFCQV_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMEXFCQV_Settings = self.Settings
		self.Settings = chKBMEXFCQV_Settings
	else
		chKBMEXFCQV_Settings = self.Settings
		self.Settings = KBMEXFCQV_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMEXFCQV_Settings, self.Settings)
	else
		KBM.LoadTable(KBMEXFCQV_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMEXFCQV_Settings = self.Settings
	else
		KBMEXFCQV_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMEXFCQV_Settings = self.Settings
	else
		KBMEXFCQV_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Vallnara.UnitID == UnitID then
		self.Vallnara.Available = false
		return true
	elseif self.CorruptQueen.UnitID == UnitID then
		self.CorruptQueen.Available = false
		return true
	end
	return false
end

function MOD:Death(UnitID)
	if self.Vallnara.UnitID == UnitID then
		self.Vallnara.Dead = true
		return true
	elseif self.CorruptQueen.UnitID == UnitID then
		self.CorruptQueen.Dead = true
		return true
	end
	return false
end

function MOD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					self.Vallnara.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(BossObj.Name, 0, 100)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					self.Vallnara.CastBar:Create(unitID)
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
	self.Vallnara.Available = false
	self.Vallnara.UnitID = nil
	self.Vallnara.CastBar:Remove()
	self.CorruptQueen.Available = false
	self.CorruptQueen.UnitID = nil
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Vallnara:SetTimers(bool)	
	if bool then
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(self.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function MOD.Vallnara:SetAlerts(bool)
	if bool then
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(self.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Vallnara, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Vallnara)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Vallnara)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Vallnara.CastBar = KBM.CastBar:Add(self, self.Vallnara)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end