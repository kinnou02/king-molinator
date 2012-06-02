-- Rusila Dreadblade Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDRS_Settings = nil
chKBMINDRS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local IND = KBM.BossMod["Infernal Dawn"]

local RS = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Rusila.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "Rusila Dreadblade",
	Object = "RS",
}

RS.Rusila = {
	Mod = RS,
	Level = "??",
	Active = false,
	Name = "Rusila Dreadblade",
	NameShort = "Rusila",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	Ignore = true,
	-- TimersRef = {},
	-- AlertsRef = {},
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

KBM.RegisterMod(RS.ID, RS)

-- Main Unit Dictionary
RS.Lang.Unit = {}
RS.Lang.Unit.Rusila = KBM.Language:Add(RS.Rusila.Name)
RS.Lang.Unit.Rusila:SetGerman("Rusila Schreckensklinge")
RS.Lang.Unit.Rusila:SetFrench("Rusila Lame-lugubre")
RS.Lang.Unit.Rusila:SetRussian("Русила Жуткий Клинок")
RS.Lang.Unit.RusShort = KBM.Language:Add("Rusila")
RS.Lang.Unit.RusShort:SetGerman()
RS.Lang.Unit.RusShort:SetFrench()
RS.Lang.Unit.RusShort:SetRussian("Русила")
RS.Lang.Unit.Long = KBM.Language:Add("Dreaded Longshot")
RS.Lang.Unit.LongShort = KBM.Language:Add("Longshot")
RS.Lang.Unit.Heart = KBM.Language:Add("Heart of the Dread Fortune")
RS.Lang.Unit.HeartShort = KBM.Language:Add("Heart")

-- Ability Dictionary
RS.Lang.Ability = {}
RS.Lang.Ability.Saw = KBM.Language:Add("Buzz Saw")
RS.Lang.Ability.Saw:SetGerman("Kreissäge")
RS.Lang.Ability.Saw:SetFrench("Scie circulaire")
RS.Lang.Ability.DreadShot = KBM.Language:Add("Dread Shot")
RS.Lang.Ability.DreadShot:SetGerman("Schreckangriff")
RS.Lang.Ability.DreadShot:SetFrench("Tir terrifiant")
RS.Lang.Ability.Fist = KBM.Language:Add("Fist")
RS.Lang.Ability.Fist:SetGerman("Faust")
RS.Lang.Ability.Fist:SetFrench("Poing")
RS.Lang.Ability.Wrath = KBM.Language:Add("Iron Wrath")
RS.Lang.Ability.Wrath:SetGerman("Eisenzorn")
RS.Lang.Ability.Wrath:SetFrench("Courroux de fer")
RS.Lang.Ability.Chain = KBM.Language:Add("Barbed Chain")
RS.Lang.Ability.Chain:SetGerman("Stacheldrahtkette")
RS.Lang.Ability.Chain:SetFrench("Chaîne barbelée")

-- Buff Dictionary
RS.Lang.Buff = {}
RS.Lang.Buff.Barrel = KBM.Language:Add("Barrel of Dragon's Breath")

RS.Rusila.Name = RS.Lang.Unit.Rusila[KBM.Lang]
RS.Rusila.NameShort = RS.Lang.Unit.RusShort[KBM.Lang]
RS.Descript = RS.Rusila.Name

RS.Long = {
	Mod = RS,
	Level = "??",
	Name = RS.Lang.Unit.Long[KBM.Lang],
	NameShort = RS.Lang.Unit.Long[KBM.Lang],
	Location = "The Dread Fortune",
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
}

RS.Heart = {
	Mod = RS,
	Level = "??",
	Name = RS.Lang.Unit.Heart[KBM.Lang],
	NameShort = RS.Lang.Unit.HeartShort[KBM.Lang],
	Location = "The Dread Fortune",
	Menu = {},
	Ignore = true,
}

RS.Dummy = {
	Mod = RS,
	Active = false,
	Level = "??",
	Name = "Dummy Start",
	NameShort = "Start",
	Location = "The Dread Fortune",
	UnitList = {},
	Menu = {},
	Type = "multi",
	RaidID = "Rusila_DummyID",
	Details = {
		name = "Dummy Start",
		combat = true,
		level = "??",
		tier = "raid",
		location = "The Dread Fortune",
		health = 10,
		healthMax = 10,
		["type"] = "Rusila_DummyID",
	},
}


function RS:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Rusila.Name] = self.Rusila,
		[self.Long.Name] = self.Long,
		[self.Dummy.Name] = self.Dummy,
		[self.Heart.Name] = self.Heart,
	}
	KBM_Boss[self.Rusila.Name] = self.Rusila
	KBM_Boss[self.Dummy.Name] = self.Dummy
	KBM.SubBoss[self.Long.Name] = self.Long
	KBM.SubBoss[self.Heart.Name] = self.Heart
end

function RS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rusila.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Rusila.Settings.TimersRef,
		-- AlertsRef = self.Rusila.Settings.AlertsRef,
	}
	KBMINDRS_Settings = self.Settings
	chKBMINDRS_Settings = self.Settings
	
end

function RS:SwapSettings(bool)

	if bool then
		KBMINDRS_Settings = self.Settings
		self.Settings = chKBMINDRS_Settings
	else
		chKBMINDRS_Settings = self.Settings
		self.Settings = KBMINDRS_Settings
	end

end

function RS:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDRS_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDRS_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDRS_Settings = self.Settings
	else
		KBMINDRS_Settings = self.Settings
	end	
end

function RS:SaveVars()	
	if KBM.Options.Character then
		chKBMINDRS_Settings = self.Settings
	else
		KBMINDRS_Settings = self.Settings
	end	
end

function RS:Castbar(units)
end

function RS:RemoveUnits(UnitID)
	if self.Rusila.UnitID == UnitID then
		self.Rusila.Available = false
		return true
	end
	return false
end

function RS:Death(UnitID)
	if self.Rusila.UnitID == UnitID then
		self.Rusila.Dead = true
		return true
	elseif self.Heart.UnitID == UnitID then
		self.PhaseObj.Objectives:Remove()
		self.PhaseObj.Objectives:AddPercent(self.Rusila.Name, 0, 100)
		self.PhaseObj:SetPhase("Final")
		self.Phase = 2
	end
	return false
end

function RS:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if BossObj then
					if not self.EncounterRunning and BossObj == self.Dummy then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						BossObj.Dead = false
						self.PhaseObj:Start(self.StartTime)
						if BossObj == self.Dummy then
							self.PhaseObj:SetPhase("Heart")
							self.PhaseObj.Objectives:AddPercent(self.Lang.Unit.Heart[KBM.Lang], 0, 100)
							self.Phase = 1
						end
					elseif BossObj.Type == "multi" then
						if BossObj.UnitList then
							if not BossObj.UnitList[unitID] then
								SubBossObj = {
									Mod = RS,
									Level = "??",
									Name = uDetails.name,
									Dead = false,
									Casting = false,
									UnitID = unitID,
									Available = true,
								}
								BossObj.UnitList[unitID] = SubBossObj
							else
								BossObj.UnitList[unitID].Available = true
								BossObj.UnitList[unitID].UnitID = unitID
							end
							return BossObj.UnitList[unitID]
						end
					end
					if BossObj == self.Rusila then
						self.Rusila.CastBar:Create(unitID)
					end
					BossObj.UnitID = unitID
					BossObj.Available = true
					return BossObj
				end
			end
		end
	end
end

function RS:Reset()
	self.EncounterRunning = false
	self.Rusila.Available = false
	self.Rusila.UnitID = nil
	self.Rusila.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function RS:Timer()	
end

function RS.Rusila:SetTimers(bool)	
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

function RS.Rusila:SetAlerts(bool)
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

function RS:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Rusila, self.Enabled)
end

function RS:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Rusila)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Rusila)
	
	-- Assign Alerts and Timers to Triggers
	self.Rusila.Triggers.Barrel = KBM.Trigger:Create(self.Lang.Buff.Barrel[KBM.Lang], "playerBuff", self.Dummy, nil, true)
	
	self.Rusila.CastBar = KBM.CastBar:Add(self, self.Rusila)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end