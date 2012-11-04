-- Warboss Drak Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDWD_Settings = nil
chKBMINDWD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local WD = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Drak.lua",
	Instance = IND.Name,
	InstanceObj = IND,
	HasPhases = true,
	Lang = {},
	ID = "Warboss Drak",
	Object = "WD",
	Enrage = 60 * 12,
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
	UTID = "U00BF999D1AD12EF7",
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
			BlazingFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Blazing = KBM.Defaults.TimerObj.Create("dark_green"),
			Burning = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Blazing = KBM.Defaults.AlertObj.Create("dark_green"),
			Will = KBM.Defaults.AlertObj.Create("orange"),
			Burning = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Burning = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

KBM.RegisterMod(WD.ID, WD)

-- Main Unit Dictionary
WD.Lang.Unit = {}
WD.Lang.Unit.Drak = KBM.Language:Add(WD.Drak.Name)
WD.Lang.Unit.Drak:SetFrench("Chef de guerre Drak")
WD.Lang.Unit.Drak:SetGerman("Kriegsboss Drak")
WD.Lang.Unit.Drak:SetRussian("Полководец Драк")
WD.Lang.Unit.Drak:SetKorean("전쟁우두머리 드락")
WD.Lang.Unit.DrakShort = KBM.Language:Add("Drak")
WD.Lang.Unit.DrakShort:SetGerman()
WD.Lang.Unit.DrakShort:SetFrench()
WD.Lang.Unit.DrakShort:SetRussian("Драк")
WD.Lang.Unit.DrakShort:SetKorean("드락")
WD.Lang.Unit.Azul = KBM.Language:Add("Azul Searbone")
WD.Lang.Unit.Azul:SetFrench("Azul Flambos")
WD.Lang.Unit.Azul:SetGerman("Azul Sengknochen")
WD.Lang.Unit.Azul:SetRussian("Азул Костежог")
WD.Lang.Unit.AzShort = KBM.Language:Add("Azul")
WD.Lang.Unit.AzShort:SetFrench()
WD.Lang.Unit.AzShort:SetGerman()
WD.Lang.Unit.AzShort:SetRussian("Азул")
WD.Lang.Unit.Stalwart = KBM.Language:Add("Warforged Stalwart")
WD.Lang.Unit.Stalwart:SetFrench("Fidèle des Forges de guerre")
WD.Lang.Unit.Stalwart:SetGerman("Kriegsgeschmiedeter Getreuer")
WD.Lang.Unit.Stalwart:SetRussian("Закаленный войной верзила")
WD.Lang.Unit.StShort = KBM.Language:Add("Stalwart")
WD.Lang.Unit.StShort:SetGerman("Getreuer")
WD.Lang.Unit.StShort:SetFrench("Fidèle")
WD.Lang.Unit.StShort:SetRussian("Верзила")
WD.Lang.Unit.Natung = KBM.Language:Add("Natung Charstorm")
WD.Lang.Unit.Natung:SetFrench("Natung Charstorm")
WD.Lang.Unit.Natung:SetGerman("Natung Schwärzsturm")
WD.Lang.Unit.Natung:SetRussian("Натунг Жгучая Буря")
WD.Lang.Unit.NatShort = KBM.Language:Add("Natung")
WD.Lang.Unit.NatShort:SetGerman()
WD.Lang.Unit.NatShort:SetFrench()
WD.Lang.Unit.NatShort:SetRussian("Натунг")
WD.Lang.Unit.Blazing = KBM.Language:Add("Blazing Thrall")
WD.Lang.Unit.Blazing:SetFrench("Serf flamboyant")
WD.Lang.Unit.Blazing:SetGerman("Flammender Knecht")
WD.Lang.Unit.Blazing:SetRussian("Пылающий раб")
WD.Lang.Unit.Blazing:SetKorean("불타는 노예")
WD.Lang.Unit.BlaShort = KBM.Language:Add("B.Thrall")
WD.Lang.Unit.BlaShort:SetGerman("F.Knecht")
WD.Lang.Unit.BlaShort:SetFrench("Serf.Fl")
WD.Lang.Unit.BlaShort:SetRussian("Пыл.Раб")
WD.Lang.Unit.Thrall = KBM.Language:Add("Warforged Thrall")
WD.Lang.Unit.Thrall:SetGerman("Kriegsgeschmiedeter Knecht")
WD.Lang.Unit.Thrall:SetFrench("Serf des Forges de guerre")
WD.Lang.Unit.Thrall:SetRussian("Закаленный войной раб")
WD.Lang.Unit.ThrShort = KBM.Language:Add("W.Thrall")
WD.Lang.Unit.ThrShort:SetFrench("Serf.F")
WD.Lang.Unit.ThrShort:SetGerman("K.Knecht")
WD.Lang.Unit.ThrShort:SetRussian("З.Раб")

-- Notify Dictionary
WD.Lang.Notify = {}
WD.Lang.Notify.Blazing = KBM.Language:Add('Warboss Drak commands, "Give yourself to the flame and burn for Maelforge!"')
WD.Lang.Notify.Blazing:SetFrench('Le Chef de guerre Drak ordonne : "Jetez%-vous dans ces flammes et brûlez pour Maelforge !"')
WD.Lang.Notify.Blazing:SetGerman('Kriegsboss Drak befiehlt: "Ergebt Euch dem Feuer und brennt für Flammenmaul!"')
WD.Lang.Notify.Blazing:SetRussian('Предводитель Драк приказывает: «Отдайтесь пламени и сгорите во славу Маэлфорджа!»')

-- Ability Dictionary
WD.Lang.Ability = {}
WD.Lang.Ability.Molten = KBM.Language:Add("Molten Rejuvenation")
WD.Lang.Ability.Molten:SetFrench("Rajeunissement en fusion")
WD.Lang.Ability.Molten:SetGerman("Geschmolzene Verjüngung")
WD.Lang.Ability.Molten:SetRussian("Расплавленное обновление")
WD.Lang.Ability.Torment = KBM.Language:Add("Scorching Torment")
WD.Lang.Ability.Torment:SetFrench("Tourment brûlant")
WD.Lang.Ability.Torment:SetGerman("Sengende Pein")
WD.Lang.Ability.Torment:SetRussian("Обжигающая пытка")
WD.Lang.Ability.Blow = KBM.Language:Add("Death Blow")
WD.Lang.Ability.Blow:SetGerman("Tödlicher Schlag")
WD.Lang.Ability.Blow:SetFrench("Frappe de la Mort")
WD.Lang.Ability.Blow:SetRussian("Смертельный удар")

-- Buff Dictionary
WD.Lang.Buff = {}
WD.Lang.Buff.Sacrifice = KBM.Language:Add("Wanton Sacrifice")
WD.Lang.Buff.Sacrifice:SetFrench("Sacrifice incandescent")
WD.Lang.Buff.Sacrifice:SetGerman("Frevler%-Opfer")
WD.Lang.Buff.Sacrifice:SetRussian("Жертва Буйных")
WD.Lang.Buff.Sacrifice:SetKorean("완톤의 희생")
WD.Lang.Buff.Burning = KBM.Language:Add("Burning Sacrifice")
WD.Lang.Buff.Burning:SetGerman("Brennendes Opfer")
WD.Lang.Buff.Burning:SetFrench("Sacrifice incandescent")
WD.Lang.Buff.Burning:SetRussian("Пламенная жертва")
WD.Lang.Buff.Burning:SetKorean("불타는 희생")
WD.Lang.Buff.Will = KBM.Language:Add("Burning Will")
WD.Lang.Buff.Will:SetFrench("Volonté brûlante")
WD.Lang.Buff.Will:SetGerman("Brennender Wille")
WD.Lang.Buff.Will:SetRussian("Пылающая воля")
WD.Lang.Buff.Will:SetKorean("불타는 의지")

-- Menu Dictionary
WD.Lang.Menu = {}
WD.Lang.Menu.Molten = KBM.Language:Add("Molten Rejuventation duration")
WD.Lang.Menu.Molten:SetFrench("Durée Rajeunissement en fusion")
WD.Lang.Menu.Molten:SetGerman("Geschmolzene Verjüngung Dauer")
WD.Lang.Menu.Molten:SetRussian("Длительность Расплавленного обновления")
WD.Lang.Menu.BlazingFirst = KBM.Language:Add("First Blazing Thrall")
WD.Lang.Menu.BlazingFirst:SetFrench("Premier Serf flamboyant")
WD.Lang.Menu.BlazingFirst:SetGerman("Erster Flammender Knecht")
WD.Lang.Menu.BlazingFirst:SetRussian("Первый пылающий раб")

WD.Drak.Name = WD.Lang.Unit.Drak[KBM.Lang]
WD.Drak.NameShort = WD.Lang.Unit.DrakShort[KBM.Lang]
WD.Descript = WD.Drak.Name

-- Add Unit Creation
WD.Azul = {
	Mod = WD,
	Level = "??",
	Active = false,
	Name = WD.Lang.Unit.Azul[KBM.Lang],
	NameShort = WD.Lang.Unit.AzShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U5F1E7D71214DFF8F",
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
	NameShort = WD.Lang.Unit.NatShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U0570D41A51ED8A7B",
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
	NameShort = WD.Lang.Unit.BlaShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	UTID = "none",
	Type = "multi",
}

WD.Thrall = {
	Mod = WD,
	Level = "??",
	Name = WD.Lang.Unit.Thrall[KBM.Lang],
	NameShort = WD.Lang.Unit.ThrShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
	UTID = "U56D75D2F20C4EEAB",
	AlertsRef = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Sacrifice = KBM.Defaults.AlertObj.Create("dark_green")
		},
	},
	Triggers = {},
}

WD.Stalwart = {
	Mod = WD,
	Level = "??",
	Name = WD.Lang.Unit.Stalwart[KBM.Lang],
	NameShort = WD.Lang.Unit.StShort[KBM.Lang],
	UnitList = {},
	Menu = {},
	Ignore = true,
	Type = "multi",
	UTID = "U7FE56E6902CC3B45",
	AlertsRef = {},
	TimersRef = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Blow = KBM.Defaults.AlertObj.Create("yellow")
		},
		TimersRef = {
			Enabled = true,
			Blow = KBM.Defaults.TimerObj.Create("yellow")
		},
	},
	Triggers = {},
}

function WD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Drak.Name] = self.Drak,
		[self.Azul.Name] = self.Azul,
		[self.Natung.Name] = self.Natung,
		[self.Blazing.Name] = self.Blazing,
		[self.Thrall.Name] = self.Thrall,
		[self.Stalwart.Name] = self.Stalwart,
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
			MechRef = self.Drak.Settings.MechRef,
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
		Thrall = {
			AlertsRef = self.Thrall.Settings.AlertsRef,
		},
		Stalwart = {
			AlertsRef = self.Stalwart.Settings.AlertsRef,
			TimersRef = self.Stalwart.Settings.TimersRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
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
	elseif self.Stalwart.UnitList[UnitID] then
		self.Stalwart.UnitList[UnitID].CastBar:Remove()
		self.Stalwart.UnitList[UnitID].Dead = true
		self.Stalwart.UnitList[UnitID].CastBar = nil
		self.Stalwart.UnitList[UnitID] = nil
	end
	return false
end

function WD.PhaseTwo()
	if WD.Phase < 2 then
		WD.PhaseObj.Objectives:Remove()
		WD.PhaseObj:SetPhase("2")
		WD.PhaseObj.Objectives:AddPercent(WD.Natung.Name, 0, 100)
		WD.Phase = 2
	end
end

function WD.PhaseFinal()
	if WD.Phase < 3 then
		WD.PhaseObj.Objectives:Remove()
		WD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		WD.PhaseObj.Objectives:AddPercent(WD.Drak.Name, 0, 100)
		WD.Phase = 3
	end
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
	elseif self.Blazing.UnitID == UnitID then
		KBM.Alert:Stop(self.Thrall.AlertsRef.Sacrifice)
	elseif self.Stalwart.UnitList[UnitID] then
		if self.Stalwart.UnitList[UnitID].CastBar then
			self.Stalwart.UnitList[UnitID].CastBar:Remove()
		end
		self.Stalwart.UnitList[UnitID].Dead = true
		self.Stalwart.UnitList[UnitID].CastBar = nil
	end
	return false
end

function WD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
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
						if BossObj.UnitList then
							if not BossObj.UnitList[unitID] then
								SubBossObj = {
									Mod = WD,
									Level = "??",
									Name = uDetails.name,
									Dead = false,
									Casting = false,
									UnitID = unitID,
									Available = true,
								}
								BossObj.UnitList[unitID] = SubBossObj
								if uDetails.name == self.Stalwart.Name then
									SubBossObj.CastBar = KBM.CastBar:Add(self, self.Stalwart, false, true)
									SubBossObj.CastBar:Create(unitID)
								end
							else
								BossObj.UnitList[unitID].Available = true
								BossObj.UnitList[unitID].UnitID = unitID
							end
							return BossObj.UnitList[unitID]
						end
					else
						if BossObj == self.Azul then
							if not BossObj.CastBar.Active then
								BossObj.CastBar:Create(unitID)
							end
						elseif BossObj == self.Drak then
							if not BossObj.CastBar.Active then
								BossObj.CastBar:Create(unitID)
							end
						elseif BossObj == self.Natung then
							if not BossObj.CastBar.Active then
								BossObj.CastBar:Create(unitID)
							end
						end						
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
	for UnitID, BossObj in pairs(self.Stalwart.UnitList) do
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
			BossObj.CastBar = nil
		end
	end
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
		if BossObj.UnitList then
			BossObj.UnitList = {}
		end		
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
	self.Drak.TimersRef.Burning = KBM.MechTimer:Add(self.Lang.Buff.Burning[KBM.Lang], 45)
	KBM.Defaults.TimerObj.Assign(self.Drak)
	-- Azul
	self.Azul.TimersRef.Molten = KBM.MechTimer:Add(self.Lang.Ability.Molten[KBM.Lang], 25)
	KBM.Defaults.TimerObj.Assign(self.Azul)
	-- Natung
	
	-- Warforged Stalwart
	self.Stalwart.TimersRef.Blow = KBM.MechTimer:Add(self.Lang.Ability.Blow[KBM.Lang], 35)
	KBM.Defaults.TimerObj.Assign(self.Stalwart)
	
	-- Create Alerts
	-- Drak
	self.Drak.AlertsRef.Blazing = KBM.Alert:Create(self.Lang.Unit.Blazing[KBM.Lang], 2, true, true, "dark_green")
	self.Drak.AlertsRef.Will = KBM.Alert:Create(self.Lang.Buff.Will[KBM.Lang], nil, false, true, "orange")
	self.Drak.AlertsRef.Burning = KBM.Alert:Create(self.Lang.Buff.Burning[KBM.Lang], nil, false, false, "purple")
	KBM.Defaults.AlertObj.Assign(self.Drak)
	-- Azul
	self.Azul.AlertsRef.Molten = KBM.Alert:Create(self.Lang.Ability.Molten[KBM.Lang], nil, true, true, "orange")
	self.Azul.AlertsRef.MoltenDuration = KBM.Alert:Create(self.Lang.Ability.Molten[KBM.Lang], nil, false, true, "orange")
	self.Azul.AlertsRef.MoltenDuration.MenuName = self.Lang.Menu.Molten[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Azul)
	-- Natung
	self.Natung.AlertsRef.Torment = KBM.Alert:Create(self.Lang.Ability.Torment[KBM.Lang], nil, true, true, "red")
	KBM.Defaults.AlertObj.Assign(self.Natung)
	-- Warforged Thrall
	self.Thrall.AlertsRef.Sacrifice = KBM.Alert:Create(self.Lang.Buff.Sacrifice[KBM.Lang], nil, false, true, "dark_green")
	KBM.Defaults.AlertObj.Assign(self.Thrall)
	-- Warforged Stalwart
	self.Stalwart.AlertsRef.Blow = KBM.Alert:Create(self.Lang.Ability.Blow[KBM.Lang], nil, false, true, "yellow")
	self.Stalwart.AlertsRef.Blow:Important()
	KBM.Defaults.AlertObj.Assign(self.Stalwart)
	
	-- Create Spies
	-- Drak
	self.Drak.MechRef.Burning = KBM.MechSpy:Add(self.Lang.Buff.Burning[KBM.Lang], nil, "playerBuff", self.Drak)
	KBM.Defaults.MechObj.Assign(self.Drak)
	
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
	self.Drak.Triggers.Will = KBM.Trigger:Create(self.Lang.Buff.Will[KBM.Lang], "buff", self.Drak)
	self.Drak.Triggers.Will:AddAlert(self.Drak.AlertsRef.Will)
	self.Drak.Triggers.WillRemove = KBM.Trigger:Create(self.Lang.Buff.Will[KBM.Lang], "buffRemove", self.Drak)
	self.Drak.Triggers.WillRemove:AddStop(self.Drak.AlertsRef.Will)
	self.Drak.Triggers.Burning = KBM.Trigger:Create(self.Lang.Buff.Burning[KBM.Lang], "cast", self.Drak)
	self.Drak.Triggers.Burning:AddTimer(self.Drak.TimersRef.Burning)
	self.Drak.Triggers.BurningDebuff = KBM.Trigger:Create(self.Lang.Buff.Burning[KBM.Lang], "playerBuff", self.Drak)
	self.Drak.Triggers.BurningDebuff:AddAlert(self.Drak.AlertsRef.Burning, true)
	self.Drak.Triggers.BurningDebuff:AddSpy(self.Drak.MechRef.Burning)
	self.Drak.Triggers.BurningRemove = KBM.Trigger:Create(self.Lang.Buff.Burning[KBM.Lang], "playerBuffRemove", self.Drak)
	self.Drak.Triggers.BurningRemove:AddStop(self.Drak.AlertsRef.Burning)
	self.Drak.Triggers.BurningRemove:AddStop(self.Drak.MechRef.Burning)
	self.Thrall.Triggers.Sacrifice = KBM.Trigger:Create(self.Lang.Buff.Sacrifice[KBM.Lang], "buff", self.Thrall)
	self.Thrall.Triggers.Sacrifice:AddAlert(self.Thrall.AlertsRef.Sacrifice)
	self.Stalwart.Triggers.Blow = KBM.Trigger:Create(self.Lang.Ability.Blow[KBM.Lang], "personalCast", self.Stalwart)
	self.Stalwart.Triggers.Blow:AddAlert(self.Stalwart.AlertsRef.Blow)
	self.Stalwart.Triggers.Blow:AddTimer(self.Stalwart.TimersRef.Blow)
	self.Stalwart.Triggers.BlowInt = KBM.Trigger:Create(self.Lang.Ability.Blow[KBM.Lang], "personalInterrupt", self.Stalwart)
	self.Stalwart.Triggers.BlowInt:AddStop(self.Stalwart.AlertsRef.Blow)
	
	self.Drak.CastBar = KBM.CastBar:Add(self, self.Drak)
	self.Natung.CastBar = KBM.CastBar:Add(self, self.Natung)
	self.Azul.CastBar = KBM.CastBar:Add(self, self.Azul)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end