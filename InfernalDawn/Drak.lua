-- Warboss Drak Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDWD_Settings = nil
chKBMINDWD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local WD = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Drak.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Warboss Drak",
	Object = "WD",
}

WD.Drak = {
	Mod = WD,
	Level = "??",
	Active = false,
	Name = "Warboss Drak",
	NameShort = "Drak",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			BlazingFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Blazing = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Blazing = KBM.Defaults.AlertObj.Create("dark_green"),
		},
	}
}

KBM.RegisterMod(WD.ID, WD)

-- Main Unit Dictionary
WD.Lang.Unit = {}
WD.Lang.Unit.Drak = KBM.Language:Add(WD.Drak.Name)
WD.Lang.Unit.Drak:SetFrench("Chef de guerre Drak")
WD.Lang.Unit.Drak:SetGerman("Kriegsboss Drak")
WD.Lang.Unit.Azul = KBM.Language:Add("Azul Searbone")
WD.Lang.Unit.Stalwart = KBM.Language:Add("Warforged Stalwart")
WD.Lang.Unit.Natung = KBM.Language:Add("Natung Charstorm")
WD.Lang.Unit.Blazing = KBM.Language:Add("Blazing Thrall")

-- Notify Dictionary
WD.Lang.Notify = {}
WD.Lang.Notify.Blazing = KBM.Language:Add('Warboss Drak commands, "Give yourself to the flame and burn for Maelforge!"')

-- Ability Dictionary
WD.Lang.Ability = {}
WD.Lang.Ability.Molten = KBM.Language:Add("Molten Rejuvenation")
WD.Lang.Ability.Torment = KBM.Language:Add("Scorching Torment")

-- Menu Dictionary
WD.Lang.Menu = {}
WD.Lang.Menu.Molten = KBM.Language:Add("Molten Rejuventation duration")
WD.Lang.Menu.BlazingFirst = KBM.Language:Add("First Blazing Thrall")

WD.Drak.Name = WD.Lang.Unit.Drak[KBM.Lang]
WD.Descript = WD.Drak.Name

-- Add Unit Creation
WD.Azul = {
	Mod = WD,
	Level = "??",
	Active = false,
	Name = WD.Lang.Unit.Azul[KBM.Lang],
	NameShort = "Azul",
	Dead = false,
	Available = false,
	Menu = {},
	RaidID = "U5F1E7D71214DFF8F",
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Molten = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Molten = KBM.Defaults.AlertObj.Create("orange"),
			MoltenDuration = KBM.Defaults.AlertObj.Create("orange"),
		},
	}
}

WD.Natung = {
	Mod = WD,
	Level = "??",
	Active = false,
	Name = WD.Lang.Unit.Natung[KBM.Lang],
	NameShort = "Natung",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		AlertsRef = {
			Enabled = true,
			Torment = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

WD.Blazing = {
	Mod = WD,
	Level = "??",
	Name = WD.Lang.Unit.Blazing[KBM.Lang],
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

function WD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Drak.Name] = self.Drak,
		[self.Azul.Name] = self.Azul,
		[self.Natung.Name] = self.Natung,
		[self.Blazing.Name] = self.Blazing,
	}
	KBM_Boss[self.Drak.Name] = self.Drak
	KBM.SubBoss[self.Azul.Name] = self.Azul
	KBM.SubBoss[self.Natung.Name] = self.Natung
	KBM.SubBoss[self.Blazing.Name] = self.Blazing
	
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end
	
end

function WD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Drak = {
			CastBar = self.Drak.Settings.CastBar,
			AlertsRef = self.Drak.Settings.AlertsRef,
			TimersRef = self.Drak.Settings.TimersRef,
		},
		Natung = {
			CastBar = self.Natung.Settings.CastBar,
			AlertsRef = self.Natung.Settings.AlertsRef,
		},
		Azul = {
			CastBar = self.Azul.Settings.CastBar,
			AlertsRef = self.Azul.Settings.AlertsRef,
			TimersRef = self.Azul.Settings.TimersRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMINDWD_Settings = self.Settings
	chKBMINDWD_Settings = self.Settings
	
end

function WD:SwapSettings(bool)

	if bool then
		KBMINDWD_Settings = self.Settings
		self.Settings = chKBMINDWD_Settings
	else
		chKBMINDWD_Settings = self.Settings
		self.Settings = KBMINDWD_Settings
	end

end

function WD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDWD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDWD_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDWD_Settings = self.Settings
	else
		KBMINDWD_Settings = self.Settings
	end	
end

function WD:SaveVars()	
	if KBM.Options.Character then
		chKBMINDWD_Settings = self.Settings
	else
		KBMINDWD_Settings = self.Settings
	end	
end

function WD:Castbar(units)
end

function WD:RemoveUnits(UnitID)
	if self.Drak.UnitID == UnitID then
		self.Drak.Available = false
		return true
	end
	return false
end

function WD.PhaseTwo()
	WD.PhaseObj.Objectives:Remove()
	WD.PhaseObj:SetPhase("2")
	WD.PhaseObj.Objectives:AddPercent(WD.Natung.Name, 0, 100)
	WD.Phase = 2
end

function WD.PhaseFinal()
	WD.PhaseObj.Objectives:Remove()
	WD.PhaseObj:SetPhase("Final")
	WD.PhaseObj.Objectives:AddPercent(WD.Drak.Name, 0, 100)
	WD.Phase = 3
end

function WD:Death(UnitID)
	if self.Drak.UnitID == UnitID then
		self.Drak.Dead = true
		return true
	elseif self.Azul.UnitID == UnitID then
		self.Azul.Dead = true
		self.PhaseTwo()
	elseif self.Natung.UnitID == UnitID then
		self.Natung.Dead = true
		self.PhaseFinal()
	end
	return false
end

function WD:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if BossObj then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						BossObj.Dead = false
						BossObj.Casting = false
						BossObj.CastBar:Create(unitID)
						self.PhaseObj:Start(self.StartTime)
						if BossObj == self.Azul then
							self.PhaseObj:SetPhase("1")
							self.PhaseObj.Objectives:AddPercent(self.Azul.Name, 0, 100)
							self.Phase = 1
							KBM.MechTimer:AddStart(self.Drak.TimersRef.BlazingFirst)
						elseif BossObj == self.Drak then
							self.PhaseObj:SetPhase("Final")
							self.PhaseObj.Objectives:AddPercent(self.Drak.Name, 0, 100)
							self.Phase = 3
						elseif BossObj == self.Natung then
							self.PhaseObj:SetPhase("2")
							self.PhaseObj.Objectives:AddPercent(self.Natung.Name, 0, 100)
							self.Phase = 2
						end
					elseif BossObj.Type == "multi" then
						if not self.Bosses[uDetails.name].UnitList[unitID] then
							SubBossObj = {
								Mod = WD,
								Level = "??",
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
					BossObj.UnitID = unitID
					BossObj.Available = true
					return BossObj
				end
			end
		end
	end
end

function WD:Reset()
	self.EncounterRunning = false
	self.PhaseObj:End(Inspect.Time.Real())
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.CastBar:Remove()
	end
end

function WD:Timer()	
end

function WD:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Drak, self.Enabled)
end

function WD:Start()
	-- Create Timers
	-- Drak
	self.Drak.TimersRef.BlazingFirst = KBM.MechTimer:Add(self.Lang.Unit.Blazing[KBM.Lang], 30)
	self.Drak.TimersRef.BlazingFirst.MenuName = self.Lang.Menu.BlazingFirst[KBM.Lang]
	self.Drak.TimersRef.Blazing = KBM.MechTimer:Add(self.Lang.Unit.Blazing[KBM.Lang], 45)
	KBM.Defaults.TimerObj.Assign(self.Drak)
	-- Azul
	self.Azul.TimersRef.Molten = KBM.MechTimer:Add(self.Lang.Ability.Molten[KBM.Lang], 25)
	KBM.Defaults.TimerObj.Assign(self.Azul)
	-- Natung
	
	-- Create Alerts
	self.Drak.AlertsRef.Blazing = KBM.Alert:Create(self.Lang.Unit.Blazing[KBM.Lang], 2, true, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Drak)
	-- Azul
	self.Azul.AlertsRef.Molten = KBM.Alert:Create(self.Lang.Ability.Molten[KBM.Lang], nil, true, true, "orange")
	self.Azul.AlertsRef.MoltenDuration = KBM.Alert:Create(self.Lang.Ability.Molten[KBM.Lang], nil, false, true, "orange")
	self.Azul.AlertsRef.MoltenDuration.MenuName = self.Lang.Menu.Molten[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Azul)
	-- Natung
	self.Natung.AlertsRef.Torment = KBM.Alert:Create(self.Lang.Ability.Torment[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Natung)
	
	-- Assign Alerts and Timers to Triggers
	self.Azul.Triggers.Molten = KBM.Trigger:Create(self.Lang.Ability.Molten[KBM.Lang], "cast", self.Azul)
	self.Azul.Triggers.Molten:AddAlert(self.Azul.AlertsRef.Molten)
	self.Azul.Triggers.Molten:AddTimer(self.Azul.TimersRef.Molten)
	self.Azul.Triggers.MoltenDuration = KBM.Trigger:Create(self.Lang.Ability.Molten[KBM.Lang], "buff", self.Azul)
	self.Azul.Triggers.MoltenDuration:AddAlert(self.Azul.AlertsRef.MoltenDuration)
	self.Natung.Triggers.Torment = KBM.Trigger:Create(self.Lang.Ability.Torment[KBM.Lang], "cast", self.Natung)
	self.Natung.Triggers.Torment:AddAlert(self.Natung.AlertsRef.Torment)
	self.Drak.Triggers.Blazing = KBM.Trigger:Create(self.Lang.Notify.Blazing[KBM.Lang], "notify", self.Drak)
	self.Drak.Triggers.Blazing:AddTimer(self.Drak.TimersRef.Blazing)
	self.Drak.Triggers.Blazing:AddAlert(self.Drak.AlertsRef.Blazing)
	
	self.Drak.CastBar = KBM.CastBar:Add(self, self.Drak)
	self.Natung.CastBar = KBM.CastBar:Add(self, self.Natung)
	self.Azul.CastBar = KBM.CastBar:Add(self, self.Azul)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end