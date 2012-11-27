-- Inwar Darktide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMID_Settings = nil
chKBMID_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local ID = {
	Enabled = true,
	Directory = HK.Directory,
	File = "Inwar.lua",
	Counts = {
		Slimes = 0,
		Wranglers = 0,
		Wardens = 0,
	},
	Instance = HK.Name,
	InstanceObj = HK,
	HasPhases = true,
	Phase = 1,
	Lang = {},
	ID = "Inwar",
	Object = "ID",
}

ID.Inwar = {
	Mod = ID,
	Level = "??",
	Active = false,
	Name = "Inwar Darktide",
	Dead = false,
	Available = false,
	TimersRef = {},
	AlertsRef = {},
	Menu = {},
	UnitID = nil,
	UTID = "U1862A1BB7F508F39",
	Primary = true,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Geyser = KBM.Defaults.TimerObj.Create("blue"),
			GeyserFirst = KBM.Defaults.TimerObj.Create("blue"),
			Tide = KBM.Defaults.TimerObj.Create("purple"),
			Surge = KBM.Defaults.TimerObj.Create("red"),
			Storm = KBM.Defaults.TimerObj.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Tide = KBM.Defaults.AlertObj.Create("purple"),
			Surge = KBM.Defaults.AlertObj.Create("red"),
			SurgeWarn = KBM.Defaults.AlertObj.Create("orange"),
			Storm = KBM.Defaults.AlertObj.Create("cyan"),
		}
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
	AlertsRef = {},
	UTID = "U2C3C925A176E8AF2",
	UnitID = nil,
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Freeze = KBM.Defaults.TimerObj.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Freeze = KBM.Defaults.AlertObj.Create("cyan"),
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
	UTID = "U22273FE36BF9E852",
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
	UTID = "U3D29F620115ADD6F",
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
	UTID = "U01F3FBAE2D3E5348",
	Primary = false,
	Required = 1,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

ID.Slime = {
	Mod = ID,
	Level = 50,
	Name = "Fetid Slime",
	UnitList = {},
	UTID = "U26D645C839878645",
	Ignore = true,
	Type = "multi",
}

ID.Wrangler = {
	Mod = ID,
	Level = "??",
	Name = "Scuttle Claw Wrangler",
	UTID = "U7C761A38241B3C98",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

ID.Warden = {
	Mod = ID,
	Level = "??",
	Name = "Tide Warden",
	UTID = "U542EF20217904738",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

KBM.RegisterMod(ID.ID, ID)

-- Initialize Main Unit Dictionary
ID.Lang.Unit = {}
ID.Lang.Unit.Inwar = KBM.Language:Add(ID.Inwar.Name)
ID.Lang.Unit.Inwar:SetGerman("Inwar Dunkelflut")
ID.Lang.Unit.Inwar:SetFrench("Inwar Noirflux")
ID.Lang.Unit.Inwar:SetRussian("Инвар Темная Волна")
ID.Lang.Unit.Denizar = KBM.Language:Add(ID.Denizar.Name)
ID.Lang.Unit.Denizar:SetGerman("Denizar")
ID.Lang.Unit.Denizar:SetFrench("Denizar")
ID.Lang.Unit.Denizar:SetRussian("Денизар")
ID.Lang.Unit.Aqualix = KBM.Language:Add(ID.Aqualix.Name)
ID.Lang.Unit.Aqualix:SetGerman("Aqualix")
ID.Lang.Unit.Aqualix:SetFrench("Aqualix")
ID.Lang.Unit.Aqualix:SetRussian("Акваликс")
ID.Lang.Unit.Undertow = KBM.Language:Add(ID.Undertow.Name)
ID.Lang.Unit.Undertow:SetGerman("Sog")
ID.Lang.Unit.Undertow:SetRussian("Подводное течение")
ID.Lang.Unit.Undertow:SetFrench("Reflux")
ID.Lang.Unit.Rotjaw = KBM.Language:Add(ID.Rotjaw.Name)
ID.Lang.Unit.Rotjaw:SetGerman("Faulkriefer")
ID.Lang.Unit.Rotjaw:SetRussian("Гнилая челюсть")
ID.Lang.Unit.Rotjaw:SetFrench("Mâchoire-pourrie")
-- Sub Unit Dictionary
ID.Lang.Unit.Slime = KBM.Language:Add(ID.Slime.Name)
ID.Lang.Unit.Slime:SetGerman("Stinkender Schleim")
ID.Lang.Unit.Slime:SetRussian("Зловонный слизень")
ID.Lang.Unit.Slime:SetFrench("Limon fétide")
ID.Lang.Unit.Wrangler = KBM.Language:Add(ID.Wrangler.Name)
ID.Lang.Unit.Wrangler:SetGerman("Krabbelklauen-Zänker")
ID.Lang.Unit.Wrangler:SetFrench("Garde d'écrevisses naufrageuses")
ID.Lang.Unit.Wrangler:SetRussian("Наездник юркого когтя")
ID.Lang.Unit.Warden = KBM.Language:Add(ID.Warden.Name)
ID.Lang.Unit.Warden:SetGerman("Gezeitenbewahrer")
ID.Lang.Unit.Warden:SetRussian("Страж прилива")
ID.Lang.Unit.Warden:SetFrench("Garde des marées")

-- Ability Dictionary
ID.Lang.Ability = {}
ID.Lang.Ability.Freeze = KBM.Language:Add("Freezing Wave")
ID.Lang.Ability.Freeze:SetGerman("Frostwelle")
ID.Lang.Ability.Freeze:SetFrench("Vague glaciale")
ID.Lang.Ability.Freeze:SetRussian("Ледяная волна")
ID.Lang.Ability.Tide = KBM.Language:Add("Dark Tide")
ID.Lang.Ability.Tide:SetGerman("Dunkle Flut")
ID.Lang.Ability.Tide:SetFrench("Vague maléfique")
ID.Lang.Ability.Tide:SetRussian("Волна тьмы")
ID.Lang.Ability.Surge = KBM.Language:Add("Surge")
ID.Lang.Ability.Surge:SetGerman("Schub")
ID.Lang.Ability.Surge:SetFrench("Poussée")
ID.Lang.Ability.Surge:SetRussian("Импульс")
ID.Lang.Ability.Storm = KBM.Language:Add("Storm Lash")
ID.Lang.Ability.Storm:SetGerman("Sturmpeitsche")
ID.Lang.Ability.Storm:SetFrench("Déchaînement de la tempête")
ID.Lang.Ability.Storm:SetRussian("Плеть бури")

-- Mechanic Dictionary
ID.Lang.Mechanic = {}
ID.Lang.Mechanic.Geyser = KBM.Language:Add("Geyser")
ID.Lang.Mechanic.Geyser:SetGerman("Geysir")
ID.Lang.Mechanic.Geyser:SetFrench("Zone au sol")
ID.Lang.Mechanic.Geyser:SetRussian("Гейзер")

-- Menu Dictionary
ID.Lang.Menu = {}
ID.Lang.Menu.Surge = KBM.Language:Add("Surge (Duration)")
ID.Lang.Menu.Surge:SetGerman("Schub (Dauer)")
ID.Lang.Menu.Surge:SetFrench("Poussée (Durée)")
ID.Lang.Menu.Surge:SetRussian("Всплекс (длит.)")

-- Adjust Unit Names to match Client
ID.Inwar.Name = ID.Lang.Unit.Inwar[KBM.Lang]
ID.Denizar.Name = ID.Lang.Unit.Denizar[KBM.Lang]
ID.Aqualix.Name = ID.Lang.Unit.Aqualix[KBM.Lang]
ID.Undertow.Name = ID.Lang.Unit.Undertow[KBM.Lang]
ID.Rotjaw.Name = ID.Lang.Unit.Rotjaw[KBM.Lang]
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
			AlertsRef = self.Inwar.Settings.AlertsRef,
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
			TimersRef = self.Denizar.Settings.TimersRef,
			AlertsRef = self.Denizar.Settings.AlertsRef,
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
	ID.PhaseObj.Objectives:AddDeath(ID.Slime.Name, 3, ID.Slime.RaidID)
	ID.PhaseObj.Objectives:AddDeath(ID.Wrangler.Name, 3)
	ID.PhaseObj.Objectives:AddDeath(ID.Warden.Name, 2)
	KBM.MechTimer:AddRemove(ID.Denizar.TimersRef.Freeze)
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
					elseif self.Phase < 4 then
						if uDetails.name == self.Inwar.Name then
							self.PhaseFour()
						end
					end
					return self.Bosses[uDetails.name]
				else
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						local SubBossObj = {
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

function ID:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.Inwar, self.Enabled)
end

function ID:Start()

	-- Create Denizar's Timers
	self.Denizar.TimersRef.Freeze = KBM.MechTimer:Add(self.Lang.Ability.Freeze[KBM.Lang], 70)
	KBM.Defaults.TimerObj.Assign(self.Denizar)
	
	-- Create Denizar's Alerts
	self.Denizar.AlertsRef.Freeze = KBM.Alert:Create(self.Lang.Ability.Freeze[KBM.Lang], nil, true, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Denizar)
	
	-- Create Inwar's Timers
	self.Inwar.TimersRef.GeyserFirst = KBM.MechTimer:Add(self.Lang.Mechanic.Geyser[KBM.Lang], 25)
	self.Inwar.TimersRef.Geyser = KBM.MechTimer:Add(self.Lang.Mechanic.Geyser[KBM.Lang], 15, true)
	self.Inwar.TimersRef.Geyser:NoMenu()
	self.Inwar.TimersRef.Geyser:SetPhase(3)
	self.Inwar.TimersRef.GeyserFirst:AddTimer(self.Inwar.TimersRef.Geyser, 0)
	self.Inwar.TimersRef.Tide = KBM.MechTimer:Add(self.Lang.Ability.Tide[KBM.Lang], 60)
	self.Inwar.TimersRef.Surge = KBM.MechTimer:Add(self.Lang.Ability.Surge[KBM.Lang], 60)
	self.Inwar.TimersRef.Storm = KBM.MechTimer:Add(self.Lang.Ability.Storm[KBM.Lang], 65)
	KBM.Defaults.TimerObj.Assign(self.Inwar)
	
	-- Create Inwars Alerts
	self.Inwar.AlertsRef.Tide = KBM.Alert:Create(self.Lang.Ability.Tide[KBM.Lang], nil, false, true, "purple")
	self.Inwar.AlertsRef.Surge = KBM.Alert:Create(self.Lang.Ability.Surge[KBM.Lang], nil, false, true, "red")
	self.Inwar.AlertsRef.Surge.MenuName = self.Lang.Menu.Surge[KBM.Lang]
	self.Inwar.AlertsRef.SurgeWarn = KBM.Alert:Create(self.Lang.Ability.Surge[KBM.Lang], nil, true, true, "orange")
	self.Inwar.AlertsRef.Storm = KBM.Alert:Create(self.Lang.Ability.Storm[KBM.Lang], nil, true, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Inwar)
	
	-- Create Triggers
	self.Denizar.Triggers.Freeze = KBM.Trigger:Create(self.Lang.Ability.Freeze[KBM.Lang], "cast", self.Denizar)
	self.Denizar.Triggers.Freeze:AddTimer(self.Denizar.TimersRef.Freeze)
	self.Denizar.Triggers.Freeze:AddAlert(self.Denizar.AlertsRef.Freeze)
	self.Inwar.Triggers.Tide = KBM.Trigger:Create(self.Lang.Ability.Tide[KBM.Lang], "cast", self.Inwar)
	self.Inwar.Triggers.Tide:AddAlert(self.Inwar.AlertsRef.Tide)
	self.Inwar.Triggers.Tide:AddTimer(self.Inwar.TimersRef.Tide)
	self.Inwar.Triggers.SurgeWarn = KBM.Trigger:Create(self.Lang.Ability.Surge[KBM.Lang], "cast", self.Inwar)
	self.Inwar.Triggers.SurgeWarn:AddTimer(self.Inwar.TimersRef.Surge)
	self.Inwar.Triggers.SurgeWarn:AddAlert(self.Inwar.AlertsRef.SurgeWarn)
	self.Inwar.Triggers.Surge = KBM.Trigger:Create(self.Lang.Ability.Surge[KBM.Lang], "buff", self.Inwar)
	self.Inwar.Triggers.Surge:AddAlert(self.Inwar.AlertsRef.Surge)
	self.Inwar.Triggers.Storm = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "cast", self.Inwar)
	self.Inwar.Triggers.Storm:AddAlert(self.Inwar.AlertsRef.Storm)
	self.Inwar.Triggers.Storm:AddTimer(self.Inwar.TimersRef.Storm)

	self.Inwar.CastBar = KBM.CastBar:Add(self, self.Inwar, true)
	self.Aqualix.CastBar = KBM.CastBar:Add(self, self.Aqualix, true)
	self.Denizar.CastBar = KBM.CastBar:Add(self, self.Denizar, true)
	self.Undertow.CastBar = KBM.CastBar:Add(self, self.Undertow, true)
	self.Rotjaw.CastBar = KBM.CastBar:Add(self, self.Rotjaw, true)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()

end