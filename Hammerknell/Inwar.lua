-- Inwar Darktide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMID_Settings = nil
chKBMID_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local ID = {
	Enabled = true,
	Counts = {
		Slimes = 0,
		Wranglers = 0,
		Wardens = 0,
	},
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	Lang = {},
	ID = "Inwar",
}

ID.Inwar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Inwar Darktide",
	Dead = false,
	Available = false,
	TimersRef = {},
	Menu = {},
	UnitID = nil,
	Primary = true,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Geyser = KBM.Defaults.TimerObj.Create("blue"),
			GeyserFirst = KBM.Defaults.TimerObj.Create("blue"),
		},
	}
}

ID.Denizar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Denizar",
	Dead = false, 
	Available = false,
	TimersRef = {},
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			FreezeFirst = KBM.Defaults.TimerObj.Create("cyan"),
			Freeze = KBM.Defaults.TimerObj.Create("cyan"),
		},
	}
}

ID.Aqualix = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Aqualix",
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	}
}

ID.Undertow = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Undertow",
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

ID.Rotjaw = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Rot Jaw",
	Dead = false, 
	Available = false,
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

ID.Slime = {
	Mod = ID,
	Level = "??",
	Name = "Fetid Slime",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

ID.Wrangler = {
	Mod = ID,
	Level = "??",
	Name = "Scuttle Claw Wrangler",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

ID.Warden = {
	Mod = ID,
	Level = "??",
	Name = "Tide Warden",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

KBM.RegisterMod(ID.ID, ID)

-- Initialize Main Unit Dictionary
ID.Lang.Inwar = KBM.Language:Add(ID.Inwar.Name)
ID.Lang.Inwar.German = "Inwar Dunkelflut"
ID.Lang.Inwar.French = "Inwar Noirflux"
ID.Lang.Inwar.Russian = "Инвар Темная Волна"
ID.Lang.Denizar = KBM.Language:Add(ID.Denizar.Name)
ID.Lang.Denizar.Russian = "Денизар"
ID.Lang.Aqualix = KBM.Language:Add(ID.Aqualix.Name)
ID.Lang.Aqualix.Russian = "Акваликс"
ID.Lang.Undertow = KBM.Language:Add(ID.Undertow.Name)
ID.Lang.Undertow.German = "Sog"
ID.Lang.Undertow.Russian = "Подводное течение"
ID.Lang.Rotjaw = KBM.Language:Add(ID.Rotjaw.Name)
ID.Lang.Rotjaw.German = "Faulkriefer"
ID.Lang.Rotjaw.Russian = "Гнилая челюсть"

-- Unit Dictionary
ID.Lang.Unit = {}
ID.Lang.Unit.Slime = KBM.Language:Add(ID.Slime.Name)
ID.Lang.Unit.Slime.German = "Stinkender Schleim"
ID.Lang.Unit.Slime.Russian = "Зловонный слизень"
ID.Lang.Unit.Wrangler = KBM.Language:Add(ID.Wrangler.Name)
ID.Lang.Unit.Wrangler.German = "Krabbelklauen-Zämker"
--ID.Lang.Unit.Wrangler.Russian = "Scuttle Claw Wrangler"
ID.Lang.Unit.Warden = KBM.Language:Add(ID.Warden.Name)
ID.Lang.Unit.Warden.German = "Gezeitenbewahrer"
ID.Lang.Unit.Warden.Russian = "Страж прилива"

-- Ability Dictionary
ID.Lang.Ability = {}
ID.Lang.Ability.Freeze = KBM.Language:Add("Freezing Wave")

-- Mechanic Dictionary
ID.Lang.Mechanic = {}
ID.Lang.Mechanic.Geyser = KBM.Language:Add("Geyser")

-- Adjust Unit Names to match Client
ID.Inwar.Name = ID.Lang.Inwar[KBM.Lang]
ID.Denizar.Name = ID.Lang.Denizar[KBM.Lang]
ID.Aqualix.Name = ID.Lang.Aqualix[KBM.Lang]
ID.Undertow.Name = ID.Lang.Undertow[KBM.Lang]
ID.Rotjaw.Name = ID.Lang.Rotjaw[KBM.Lang]
ID.Slime.Name = ID.Lang.Unit.Slime[KBM.Lang]
ID.Wrangler.Name = ID.Lang.Unit.Wrangler[KBM.Lang]
ID.Warden.Name = ID.Lang.Unit.Warden[KBM.Lang]
ID.Descript = ID.Inwar.Name

function ID:AddBosses(KBM_Boss)

	self.MenuName = self.Descript
	self.Bosses = {
		[self.Inwar.Name] = self.Inwar,
		[self.Denizar.Name] = self.Denizar,
		[self.Aqualix.Name] = self.Aqualix,
		[self.Undertow.Name] = self.Undertow,
		[self.Rotjaw.Name] = self.Rotjaw,
		[self.Slime.Name] = self.Slime,
		[self.Wrangler.Name] = self.Wrangler,
		[self.Warden.Name] = self.Warden,
	}
	KBM_Boss[self.Inwar.Name] = self.Inwar
	KBM.SubBoss[self.Denizar.Name] = self.Denizar
	KBM.SubBoss[self.Aqualix.Name] = self.Aqualix
	KBM.SubBoss[self.Undertow.Name] = self.Undertow
	KBM.SubBoss[self.Rotjaw.Name] = self.Rotjaw
	KBM.SubBoss[self.Slime.Name] = self.Slime
	KBM.SubBoss[self.Wrangler.Name] = self.Wrangler
	KBM.SubBoss[self.Warden.Name] = self.Warden
	
	self.Inwar.Settings.CastBar.Override = true
	self.Inwar.Settings.CastBar.Multi = true

	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end
	
end

function ID:InitVars()

	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		CastBar = {
			Override = true,
			Multi = true,
		},
		Inwar = {
			CastBar = self.Inwar.Settings.CastBar,
			TimersRef = self.Inwar.Settings.TimersRef,
		},
		Rotjaw = {
			CastBar = self.Rotjaw.Settings.CastBar,
		},
		Undertow = {
			CastBar = self.Undertow.Settings.CastBar,
		},
		Aqualix = {
			CastBar = self.Aqualix.Settings.CastBar,
		},
		Denizar = {
			CastBar = self.Denizar.Settings.CastBar,
		},
	}
	KBMID_Settings = self.Settings
	chKBMID_Settings = self.Settings
	
end

function ID:SwapSettings(bool)

	if bool then
		KBMID_Settings = self.Settings
		self.Settings = chKBMID_Settings
	else
		chKBMID_Settings = self.Settings
		self.Settings = KBMID_Settings
	end

end

function ID:LoadVars()
	
	local TargetLoad = nil
	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMID_Settings, self.Settings)
	else
		KBM.LoadTable(KBMID_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMID_Settings = self.Settings
	else
		KBMID_Settings = self.Settings
	end
	
end

function ID:SaveVars()

	if KBM.Options.Character then
		chKBMID_Settings = self.Settings
	else
		KBMID_Settings = self.Settings
	end
	
end

function ID:Castbar(units)
end

function ID:RemoveUnits(UnitID)
	if self.Inwar.UnitID == UnitID then
		self.Inwar.Available = false
		return true
	end
	return false
end

function ID.PhaseTwo()	
	ID.Phase = 2
	ID.PhaseObj.Objectives:Remove()
	ID.PhaseObj:SetPhase(2)
	ID.PhaseObj.Objectives:AddDeath(ID.Slime.Name, 15)
	ID.PhaseObj.Objectives:AddDeath(ID.Wrangler.Name, 3)	
	ID.PhaseObj.Objectives:AddDeath(ID.Warden.Name, 2)
	KBM.MechTimer:AddStart(ID.Inwar.TimersRef.GeyserFirst)
end

function ID.PhaseThree()
	ID.Phase = 3
	ID.PhaseObj.Objectives:Remove()
	ID.PhaseObj:SetPhase(3)
	ID.PhaseObj.Objectives:AddPercent(ID.Undertow.Name, 0, 100)
	ID.PhaseObj.Objectives:AddPercent(ID.Rotjaw.Name, 0, 100)
end

function ID.PhaseFour()
	ID.Phase = 4
	KBM.MechTimer:AddRemove(ID.Inwar.TimersRef.Geyser)
	ID.PhaseObj.Objectives:Remove()
	ID.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	ID.PhaseObj.Objectives:AddPercent(ID.Inwar.Name, 0, 100)
end

function ID:Death(UnitID)
	if self.Inwar.UnitID == UnitID then
		self.Inwar.Dead = true
		return true
	else
		if self.Phase == 1 then
			-- First Pair
			if self.Aqualix.UnitID == UnitID then
				self.Aqualix.Dead = true
				self.Aqualix.CastBar:Remove()
			elseif self.Denizar.UnitID == UnitID then
				self.Denizar.Dead = true
				self.Denizar.CastBar:Remove()
			end
			if self.Aqualix.Dead and self.Denizar.Dead then
				ID.PhaseTwo()
			end
		elseif self.Phase == 2 then
			-- Adds (Slimes and Wranglers)
			if self.Slime.UnitList[UnitID] then
				self.Counts.Slimes = self.Counts.Slimes + 1
				self.Slime.UnitList[UnitID].Dead = true
			elseif self.Wrangler.UnitList[UnitID] then
				self.Counts.Wranglers = self.Counts.Wranglers + 1
				self.Wrangler.UnitList[UnitID].Dead = true
			elseif self.Warden.UnitList[UnitID] then
				self.Counts.Wardens = self.Counts.Wardens + 1
				self.Warden.UnitList[UnitID].Dead = true
			end
			if self.Counts.Wardens == 2 then
				ID.PhaseThree()
			end
		elseif self.Phase == 3 then
			-- Last Minibosses before Inwar
			if self.Undertow.UnitID == UnitID then
				self.Undertow.Dead = true
				self.Undertow.CastBar:Remove()
			elseif self.Rotjaw.UnitID == UnitID then
				self.Rotjaw.Dead = true
				self.Rotjaw.CastBar:Remove()
			end
			if self.Undertow.Dead and self.Rotjaw.Dead then
				ID.PhaseFour()
			end
		end
	end
	return false
end

function ID:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.Counts.Wardens = 0
					self.Counts.Slimes = 0
					self.Counts.Wranglers = 0
					self.PhaseObj.Objectives:AddPercent(self.Aqualix.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Denizar.Name, 0, 100)
					self.PhaseObj:Start(self.StartTime)
				end
				if self.Type ~= "multi" then
					if self.Bosses[uDetails.name].CastBar then
						if not self.Bosses[uDetails.name].CastBar.Active then
							self.Bosses[uDetails.name].CastBar:Create(unitID)			
						end
					end
					self.Bosses[uDetails.name].Casting = false
					self.Bosses[uDetails.name].UnitID = unitID
					self.Bosses[uDetails.name].Available = true
					if self.Phase > 1 then
						if uDetails.name == self.Rotjaw.Name or uDetails.name == self.Undertow.Name then
							self.PhaseThree()
						end
					elseif Phase == 3 then
						if uDetails.name == self.Inwar.Name then
							self.PhaseFour()
						end
					end
					return self.Bosses[uDetails.name]
				else
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						SubBossObj = {
							Mod = ID,
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
			end
		end
	end
end

function ID:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Type == "multi" then
			BossObj.UnitList = {}
		else
			BossObj.Available = false
			BossObj.UnitID = nil
			BossObj.Dead = false
			if BossObj.CastBar then
				if BossObj.CastBar.Active then
					BossObj.CastBar:Remove()
				end
			end
		end
	end
	self.Counts.Slimes = 0
	self.Counts.Wardens = 0
	self.Counts.Wranglers = 0
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase = 1
end

function ID:Timer()	
end

function ID.Inwar:SetTimers(bool)
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

function ID.Inwar:SetAlerts(bool)
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

function ID:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Inwar, self.Enabled)
end

function ID:Start()

	-- Creaye Denizar's Timers
	self.Denizar.TimersRef.FreezeFirst = KBM.MechTimer:Add(self.Lang.Ability.Freeze[KBM.Lang], 15)
	
	KBM.Defaults.TimerObj.Assign(self.Denizar)

	-- Create Inwar's Timers
	self.Inwar.TimersRef.GeyserFirst = KBM.MechTimer:Add(self.Lang.Mechanic.Geyser[KBM.Lang], 25)
	self.Inwar.TimersRef.Geyser = KBM.MechTimer:Add(self.Lang.Mechanic.Geyser[KBM.Lang], 15, true)
	self.Inwar.TimersRef.Geyser:NoMenu()
	self.Inwar.TimersRef.Geyser:SetPhase(3)
	
	KBM.Defaults.TimerObj.Assign(self.Inwar)
	
	-- Create Triggers

	self.Inwar.CastBar = KBM.CastBar:Add(self, self.Inwar, true)
	self.Aqualix.CastBar = KBM.CastBar:Add(self, self.Aqualix, true)
	self.Denizar.CastBar = KBM.CastBar:Add(self, self.Denizar, true)
	self.Undertow.CastBar = KBM.CastBar:Add(self, self.Undertow, true)
	self.Rotjaw.CastBar = KBM.CastBar:Add(self, self.Rotjaw, true)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()

end