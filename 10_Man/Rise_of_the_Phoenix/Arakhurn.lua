-- High Priest Arakhurn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROTPHA_Settings = nil
chKBMROTPHA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local ROTP = KBM.BossMod["Rise of the Phoenix"]

local HA = {
	Directory = ROTP.Directory,
	File = "Arakhurn.lua",
	Enabled = true,
	Instance = ROTP.Name,
	HasPhases = true,
	Lang = {},
	TimeoutOverride = false,
	Timeout = 30,
	Phase = 1,
	Enrage = 14.5 * 60,
	ID = "Arakhurn",
}

HA.Arakhurn = {
	Mod = HA,
	Level = "??",
	Active = false,
	Name = "High Priest Arakhurn",
	NameShort = "Arakhurn",
	Menu = {},
	Castbar = nil,
	AlertsRef = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			NovaFirst = KBM.Defaults.TimerObj.Create("red"),
			Nova = KBM.Defaults.TimerObj.Create("red"),
			NovaPThree = KBM.Defaults.TimerObj.Create("red"),
			FieryFirst = KBM.Defaults.TimerObj.Create("orange"),
			Fiery = KBM.Defaults.TimerObj.Create("orange"),
			FieryPThree = KBM.Defaults.TimerObj.Create("orange"),
			AddFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Add = KBM.Defaults.TimerObj.Create("dark_green"),
			Rise = KBM.Defaults.TimerObj.Create("orange"),
		},
		AlertsRef = {
			Enabled = true,
			Nova = KBM.Defaults.AlertObj.Create("red"),
			Fiery = KBM.Defaults.AlertObj.Create("orange"),
			NovaWarn = KBM.Defaults.AlertObj.Create("red"),
		},
	}
}

KBM.RegisterMod(HA.ID, HA)

-- Define Name
HA.Lang.Arakhurn = KBM.Language:Add(HA.Arakhurn.Name)
HA.Lang.Arakhurn.German = "Hohepriester Arakhurn"
HA.Lang.Arakhurn.French = "Grand Pr\195\170tre Arakhurn"
HA.Lang.Arakhurn.Russian = "Первосвященник Аракурн"
HA.Arakhurn.Name = HA.Lang.Arakhurn[KBM.Lang]
HA.Descript = HA.Arakhurn.Name

-- Ability Dictionary
HA.Lang.Ability = {}
HA.Lang.Ability.Nova = KBM.Language:Add("Fire Nova")
HA.Lang.Ability.Nova.German = "Feuernova"
HA.Lang.Ability.Nova.Russian = "Огненная сверхновая"

-- Notify Dictionary
HA.Lang.Notify = {}
HA.Lang.Notify.Nova = KBM.Language:Add("High Priest Arakhurn releases the fiery energy within")
HA.Lang.Notify.Nova.German = "Hohepriester Arakhurn lässt die feurige Energie seines Inneren frei."
HA.Lang.Notify.Nova.Russian = "Первосвященник Аракурн высвобождает скрытую внутри яростную энергию."
HA.Lang.Notify.Respawn = KBM.Language:Add("The lava churns violently as a large shadow moves beneath it and then rushes to the surface")
HA.Lang.Notify.Respawn.German = "Die Lava brodelt gewaltig, während sich ein großer Schatten unter ihr bewegt und dann an die Oberfläche schnellt."
HA.Lang.Notify.Respawn.Russian = "Лава бурлит; под ней движеться огромная тень, стремительно всплывая к поверхности."
HA.Lang.Notify.Death = KBM.Language:Add("As Arakhurn turns to ash, something stirs beneath the molten lava.")
HA.Lang.Notify.Death.German = "Als Arakhurn zu Asche zerfällt, regt sich etwas unter der schwelenden Lava."
HA.Lang.Notify.Death.Russian = "По мере того, как Аракурн превращается в пепел, что-то пробуждаеться под раскаленной лавой."

-- Chat Dictionary
HA.Lang.Chat = {}
HA.Lang.Chat.Respawn = KBM.Language:Add("Come to me, my children.")
HA.Lang.Chat.Respawn.German = "Kommt zu mir, meine Kinder."
HA.Lang.Chat.Respawn.Russian = "Ко мне, дети мои."
HA.Lang.Chat.Death = KBM.Language:Add("The fire within me weakens. I must regain the power of the flame.")
HA.Lang.Chat.Death.Russian = "Огонь во мне ослабевает. Я должен восполнить силу пламени."

-- Buff Dictionary
HA.Lang.Buff = {}
HA.Lang.Buff.Fiery = KBM.Language:Add("Fiery Metamorphosis")
HA.Lang.Buff.Fiery.German = "Feurige Metamorphose"
HA.Lang.Buff.Fiery.Russian = "Огненное превращение"

-- Debuff Dictionary
HA.Lang.Debuff = {}
HA.Lang.Debuff.Armor = KBM.Language:Add("Armor Rip")
HA.Lang.Debuff.Armor.German = "Rüstung aufreißen"
HA.Lang.Debuff.Armor.Russian = "Раздиратель доспехов"

-- Unit Dictionary
HA.Lang.Unit = {}
HA.Lang.Unit.Spawn = KBM.Language:Add("Spawn of Arakhurn")
HA.Lang.Unit.Spawn.German = "Brut von Arakhurn"
HA.Lang.Unit.Spawn.Russian = "Отродье Арахурна"
HA.Lang.Unit.Enraged = KBM.Language:Add("Enraged Spawn of Arakhurn")
HA.Lang.Unit.Enraged.German = "Zornige Brut von Arakhurn"
HA.Lang.Unit.Enraged.Russian = "Взбесившееся порождение Арахурна"

-- Verbose Dictionary
HA.Lang.Verbose = {}
HA.Lang.Verbose.Nova = KBM.Language:Add("until "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Verbose.Nova.German = "bis "..HA.Lang.Ability.Nova[KBM.Lang]
HA.Lang.Verbose.Nova.Russian = "до "..HA.Lang.Ability.Nova[KBM.Lang]
HA.Lang.Verbose.Rise = KBM.Language:Add(HA.Lang.Arakhurn[KBM.Lang].." rises")

-- Menu Dictionary
HA.Lang.Menu = {}
HA.Lang.Menu.FieryFirst = KBM.Language:Add("First "..HA.Lang.Buff.Fiery[KBM.Lang])
HA.Lang.Menu.FieryFirst.German = "Erste "..HA.Lang.Buff.Fiery[KBM.Lang]
HA.Lang.Menu.FieryFirst.Russian = "Первое "..HA.Lang.Buff.Fiery[KBM.Lang]
HA.Lang.Menu.FieryPThree = KBM.Language:Add("First "..HA.Lang.Buff.Fiery[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.FieryPThree.German = "Erste "..HA.Lang.Buff.Fiery[KBM.Lang].." (Phase 3)"
HA.Lang.Menu.FieryPThree.Russian = "Первое "..HA.Lang.Buff.Fiery[KBM.Lang].." (Фаза 3)"
HA.Lang.Menu.NovaFirst = KBM.Language:Add("First "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaFirst.German = "Erste "..HA.Lang.Ability.Nova[KBM.Lang]
HA.Lang.Menu.NovaFirst.Russian = "Первая "..HA.Lang.Ability.Nova[KBM.Lang]
HA.Lang.Menu.NovaPThree = KBM.Language:Add("First "..HA.Lang.Ability.Nova[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.NovaPThree.German = "Erste "..HA.Lang.Ability.Nova[KBM.Lang].." (Phase 3)"
HA.Lang.Menu.NovaPThree.Russian = "Первая "..HA.Lang.Ability.Nova[KBM.Lang].." (Фаза 3)"
HA.Lang.Menu.AddFirst = KBM.Language:Add("First "..HA.Lang.Unit.Enraged[KBM.Lang])
HA.Lang.Menu.AddFirst.German = "Erste "..HA.Lang.Unit.Enraged[KBM.Lang]
HA.Lang.Menu.AddFirst.Russian = "Первое "..HA.Lang.Unit.Enraged[KBM.Lang]
HA.Lang.Menu.NovaWarn = KBM.Language:Add("5 second warning for "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaWarn.German = "5 Sekunden bis "..HA.Lang.Ability.Nova[KBM.Lang]
HA.Lang.Menu.NovaWarn.Russian = "5 Секунд до "..HA.Lang.Ability.Nova[KBM.Lang]

HA.Enraged = {
	Mod = HA,
	Level = "??",
	Name = HA.Lang.Unit.Enraged[KBM.Lang],
	NameShort = "Enraged Spawn",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

HA.Spawn = {
	Mod = HA,
	Level = "??",
	Name = HA.Lang.Unit.Spawn[KBM.Lang],
	NameShort = "Spawn",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

function HA:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Arakhurn.Name] = self.Arakhurn,
		[self.Enraged.Name] = self.Enraged,
		[self.Spawn.Name] = self.Spawn,
	}
	KBM_Boss[self.Arakhurn.Name] = self.Arakhurn
	KBM.SubBoss[self.Enraged.Name] = self.Enraged
	KBM.SubBoss[self.Spawn.Name] = self.Spawn
end

function HA:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arakhurn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Arakhurn.Settings.AlertsRef,
		TimersRef = self.Arakhurn.Settings.TimersRef,
	}
	KBMROTPHA_Settings = self.Settings
	chKBMROTPHA_Settings = self.Settings
	
end

function HA:SwapSettings(bool)
	if bool then
		KBMROTPHA_Settings = self.Settings
		self.Settings = chKBMROTPHA_Settings
	else
		chKBMROTPGS_Settings = self.Settings
		self.Settings = KBMROTPHA_Settings
	end
end

function HA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROTPHA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROTPHA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMROTPHA_Settings = self.Settings
	else
		KBMROTPHA_Settings = self.Settings
	end	
end

function HA:SaveVars()	
	if KBM.Options.Character then
		chKBMROTPHA_Settings = self.Settings
	else
		KBMROTPHA_Settings = self.Settings
	end	
end

function HA:Castbar(units)
end

function HA:RemoveUnits(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		self.Arakhurn.Available = false
		return true
	end
	return false
end

function HA:Death(UnitID)
	if self.Arakhurn.UnitID == UnitID then
		if self.Phase == 3 then
			self.Arakhurn.Dead = true
			return true
		end
	elseif self.Enraged.UnitList[UnitID] then
		if not self.Enraged.UnitList[UnitID].Dead then
			KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.Add)
			self.Enraged.UnitList[UnitID].Dead = true
		end
	end
	return false
end

function HA.Stall()
	if HA.Phase == 1 then
		HA.TimeoutOverride = true
		KBM.MechTimer:AddRemove(HA.Arakhurn.TimersRef.Nova)
		KBM.MechTimer:AddRemove(HA.Arakhurn.TimersRef.Fiery)
		HA.Arakhurn.CastBar:Remove()
		HA.Phase = 2
	end
end

function HA.PhaseTwo()
	HA.PhaseObj.Objectives:Remove()
	HA.PhaseObj:SetPhase("Adds")
	HA.PhaseObj.Objectives:AddDeath(HA.Lang.Unit.Spawn[KBM.Lang], 6)
	HA.Arakhurn.UnitID = nil
end

function HA.PhaseThree()
	if HA.Phase < 3 then
		HA.Phase = 3
		HA.TimeoutOverride = false
		HA.PhaseObj.Objectives:Remove()
		HA.PhaseObj:SetPhase("Final")
		HA.PhaseObj.Objectives:AddPercent(HA.Arakhurn.Name, 0, 100)
	end
end

function HA:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Arakhurn.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arakhurn.Dead = false
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Arakhurn.Name, 0, 100)
					self.PhaseObj:SetPhase(1)
					KBM.TankSwap:Start(self.Lang.Debuff.Armor[KBM.Lang])
					KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.NovaFirst)
					KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.FieryFirst)
				elseif self.Arakhurn.UnitID ~= unitID then
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
					self.PhaseThree()
				end
				self.Arakhurn.UnitID = unitID
				self.Arakhurn.Available = true
				return self.Arakhurn
			else
				if not self.Bosses[uDetails.name].UnitList[unitID] then
					SubBossObj = {
						Mod = HA,
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
					self.Bosses[uDetails.name].UnitList[unitID].UnitID = UnitID
				end
				return self.Bosses[uDetails.name].UnitList[unitID]
			end
		end
	end
end

function HA:Reset()
	self.EncounterRunning = false
	self.Arakhurn.Available = false
	self.Arakhurn.UnitID = nil
	self.PhaseObj:End(Inspect.Time.Real())
	self.Arakhurn.CastBar:Remove()
	self.TimeoutOverride = false
	self.Enraged.UnitList = {}
	self.Spawn.UnitList = {}
end

function HA:Timer()	
end

function HA.Arakhurn:SetTimers(bool)	
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

function HA.Arakhurn:SetAlerts(bool)
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

function HA:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Arakhurn, self.Enabled)
end

function HA:Start()
	-- Create Timers
	self.Arakhurn.TimersRef.NovaFirst = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 46)
	self.Arakhurn.TimersRef.NovaFirst.MenuName = self.Lang.Menu.NovaFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Nova = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 60)
	self.Arakhurn.TimersRef.NovaPThree = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 52)
	self.Arakhurn.TimersRef.NovaPThree.MenuName = self.Lang.Menu.NovaPThree[KBM.Lang]
	self.Arakhurn.TimersRef.FieryFirst = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 75)
	self.Arakhurn.TimersRef.FieryFirst.MenuName = self.Lang.Menu.FieryFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Fiery = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 60)
	self.Arakhurn.TimersRef.FieryPThree = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 84)
	self.Arakhurn.TimersRef.FieryPThree.MenuName = self.Lang.Menu.FieryPThree[KBM.Lang]
	self.Arakhurn.TimersRef.AddFirst = KBM.MechTimer:Add(self.Lang.Unit.Enraged[KBM.Lang], 36)
	self.Arakhurn.TimersRef.AddFirst.MenuName = self.Lang.Menu.AddFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Add = KBM.MechTimer:Add(self.Lang.Unit.Enraged[KBM.Lang], 60)
	self.Arakhurn.TimersRef.Rise = KBM.MechTimer:Add(self.Lang.Verbose.Rise[KBM.Lang], 48)
	KBM.Defaults.TimerObj.Assign(self.Arakhurn)
	
	-- Create Alerts
	self.Arakhurn.AlertsRef.Nova = KBM.Alert:Create(self.Lang.Ability.Nova[KBM.Lang], nil, false, true, "red")
	self.Arakhurn.AlertsRef.NovaWarn = KBM.Alert:Create(self.Lang.Verbose.Nova[KBM.Lang], 5, true, true, "red")
	self.Arakhurn.AlertsRef.NovaWarn.MenuName = self.Lang.Menu.NovaWarn[KBM.Lang]
	self.Arakhurn.AlertsRef.Fiery = KBM.Alert:Create(self.Lang.Buff.Fiery[KBM.Lang], nil, true, true, "orange")
	self.Arakhurn.TimersRef.NovaFirst:AddAlert(self.Arakhurn.AlertsRef.NovaWarn, 5)
	self.Arakhurn.TimersRef.Nova:AddAlert(self.Arakhurn.AlertsRef.NovaWarn, 5)
	self.Arakhurn.TimersRef.NovaPThree:AddAlert(self.Arakhurn.AlertsRef.NovaWarn, 5)
	KBM.Defaults.AlertObj.Assign(self.Arakhurn)
	
	-- Assign Timers and Alerts to Triggers
	self.Arakhurn.Triggers.Stall = KBM.Trigger:Create(1, "percent", self.Arakhurn)
	self.Arakhurn.Triggers.Stall:AddPhase(self.Stall)
	self.Arakhurn.Triggers.Nova = KBM.Trigger:Create(self.Lang.Ability.Nova[KBM.Lang], "channel", self.Arakhurn)
	self.Arakhurn.Triggers.Nova:AddTimer(self.Arakhurn.TimersRef.Nova)
	self.Arakhurn.Triggers.Nova:AddAlert(self.Arakhurn.AlertsRef.Nova)
	self.Arakhurn.Triggers.Fiery = KBM.Trigger:Create(self.Lang.Buff.Fiery[KBM.Lang], "playerBuff", self.Arakhurn)
	self.Arakhurn.Triggers.Fiery:AddTimer(self.Arakhurn.TimersRef.Fiery)
	self.Arakhurn.Triggers.Fiery:AddAlert(self.Arakhurn.AlertsRef.Fiery, true)
	self.Arakhurn.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Chat.Death[KBM.Lang], "say", self.Arakhurn)
	self.Arakhurn.Triggers.PhaseTwo:AddTimer(self.Arakhurn.TimersRef.Rise)
	self.Arakhurn.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Arakhurn.Triggers.PhaseThree = KBM.Trigger:Create(self.Lang.Notify.Respawn[KBM.Lang], "notify", self.Arakhurn)
	self.Arakhurn.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Arakhurn.Triggers.PhaseThree:AddTimer(self.Arakhurn.TimersRef.AddFirst)
	self.Arakhurn.Triggers.PhaseThree:AddTimer(self.Arakhurn.TimersRef.NovaPThree)
	self.Arakhurn.Triggers.PhaseThree:AddTimer(self.Arakhurn.TimersRef.FieryPThree)
	
	self.Arakhurn.CastBar = KBM.CastBar:Add(self, self.Arakhurn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end