-- Gorlach Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDGL_Settings = nil
chKBMINDGL_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local GL = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Gorlach.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Gorlach",
	Object = "GL",
}

GL.Gorlach = {
	Mod = GL,
	Level = "??",
	Active = false,
	Name = "Gorlach",
	NameShort = "Gorlach",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Fire = KBM.Defaults.TimerObj.Create("red"),
		},
		AlertsRef = {
			Enabled = true,
			Hot = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Hot = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

KBM.RegisterMod(GL.ID, GL)

-- Main Unit Dictionary
GL.Lang.Unit = {}
GL.Lang.Unit.Gorlach = KBM.Language:Add(GL.Gorlach.Name)
GL.Lang.Unit.Gorlach:SetFrench()
GL.Lang.Unit.Gorlach:SetGerman()
GL.Lang.Unit.Gorlach:SetRussian("Горлах")
GL.Lang.Unit.Gorlach:SetKorean("골라크")
GL.Lang.Unit.GorlachShort = KBM.Language:Add("Gorlach")
GL.Lang.Unit.GorlachShort:SetFrench()
GL.Lang.Unit.GorlachShort:SetGerman()
GL.Lang.Unit.GorlachShort:SetRussian("Горлах")
GL.Lang.Unit.GorlachShort:SetKorean("골라크")

-- Ability Dictionary
GL.Lang.Ability = {}

-- Debuff Dictionary
GL.Lang.Debuff = {}
GL.Lang.Debuff.Hot = KBM.Language:Add("Hot Foot")
GL.Lang.Debuff.Hot:SetGerman("Heißfuß")
GL.Lang.Debuff.Hot:SetFrench("À toute vitesse")
GL.Lang.Debuff.Hot:SetRussian("Горящие ноги")
GL.Lang.Debuff.Fire = KBM.Language:Add("Fire Infusion")
GL.Lang.Debuff.Fire:SetGerman("Feuer-Infusion")
GL.Lang.Debuff.Fire:SetFrench("Infusion de Feu")
GL.Lang.Debuff.Fire:SetRussian("Вливание огня")
GL.Lang.Debuff.Flame = KBM.Language:Add("Flame Catapult")
GL.Lang.Debuff.Flame:SetGerman("Flammenkatapult")
GL.Lang.Debuff.Flame:SetFrench("Catapulte de flammes")
GL.Lang.Debuff.Flame:SetRussian("Пламенная катапульта")

-- Description Dictionary
GL.Lang.Main = {}
GL.Lang.Main.Descript = KBM.Language:Add("Gorlach")
GL.Lang.Main.Descript:SetFrench("Gorlach")
GL.Lang.Main.Descript:SetGerman("Gorlach")
GL.Lang.Main.Descript:SetRussian("Горлах")
GL.Lang.Main.Descript:SetKorean("골라크")
GL.Descript = GL.Lang.Main.Descript[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
GL.Gorlach.Name = GL.Lang.Unit.Gorlach[KBM.Lang]
GL.Gorlach.NameShort = GL.Lang.Unit.GorlachShort[KBM.Lang]

function GL:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Gorlach.Name] = self.Gorlach,
	}
	KBM_Boss[self.Gorlach.Name] = self.Gorlach
end

function GL:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Gorlach.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Gorlach.Settings.TimersRef,
		AlertsRef = self.Gorlach.Settings.AlertsRef,
		MechRef = self.Gorlach.Settings.MechRef,
		MechSpy = KBM.Defaults.MechSpy(),
	}
	KBMINDGL_Settings = self.Settings
	chKBMINDGL_Settings = self.Settings
	
end

function GL:SwapSettings(bool)

	if bool then
		KBMINDGL_Settings = self.Settings
		self.Settings = chKBMINDGL_Settings
	else
		chKBMINDGL_Settings = self.Settings
		self.Settings = KBMINDGL_Settings
	end

end

function GL:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDGL_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDGL_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDGL_Settings = self.Settings
	else
		KBMINDGL_Settings = self.Settings
	end	
end

function GL:SaveVars()	
	if KBM.Options.Character then
		chKBMINDGL_Settings = self.Settings
	else
		KBMINDGL_Settings = self.Settings
	end	
end

function GL:Castbar(units)
end

function GL:RemoveUnits(UnitID)
	if self.Gorlach.UnitID == UnitID then
		self.Gorlach.Available = false
		return true
	end
	return false
end

function GL:Death(UnitID)
	if self.Gorlach.UnitID == UnitID then
		self.Gorlach.Dead = true
		self.Gorlach.CastBar:Remove()
		return true
	end
	return false
end

function GL:UnitHPCheck(uDetails, unitID)	
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
					if BossObj.Name == self.Gorlach.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.PhaseObj.Objectives:AddPercent(self.Gorlach.Name, 0, 100)
					KBM.TankSwap:Start(self.Lang.Debuff.Fire[KBM.Lang], unitID)
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Gorlach.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return self.Gorlach
			end
		end
	end
end

function GL:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Gorlach.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function GL:Timer()	
end

function GL:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Gorlach, self.Enabled)
end

function GL:Start()
	-- Create Timers
	self.Gorlach.TimersRef.Fire = KBM.MechTimer:Add(self.Lang.Debuff.Fire[KBM.Lang], 10)
	KBM.Defaults.TimerObj.Assign(self.Gorlach)
	
	-- Create Alerts
	self.Gorlach.AlertsRef.Hot = KBM.Alert:Create(self.Lang.Debuff.Hot[KBM.Lang], nil, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Gorlach)
	
	-- Create Spies
	self.Gorlach.MechRef.Hot = KBM.MechSpy:Add(self.Lang.Debuff.Hot[KBM.Lang], nil, "playerDebuff", self.Gorlach)
	KBM.Defaults.MechObj.Assign(self.Gorlach)
	
	-- Assign Alerts and Timers to Triggers
	self.Gorlach.Triggers.Hot = KBM.Trigger:Create(self.Lang.Debuff.Hot[KBM.Lang], "playerBuff", self.Gorlach)
	self.Gorlach.Triggers.Hot:AddAlert(self.Gorlach.AlertsRef.Hot, true)
	self.Gorlach.Triggers.Hot:AddSpy(self.Gorlach.MechRef.Hot)
	self.Gorlach.Triggers.Fire = KBM.Trigger:Create(self.Lang.Debuff.Fire[KBM.Lang], "playerBuff", self.Gorlach)
	self.Gorlach.Triggers.Fire:AddTimer(self.Gorlach.TimersRef.Fire)
	
	self.Gorlach.CastBar = KBM.CastBar:Add(self, self.Gorlach)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end