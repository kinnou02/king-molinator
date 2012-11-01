-- Rusila Dreadblade Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDRS_Settings = nil
chKBMINDRS_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local RS = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Rusila.lua",
	Instance = IND.Name,
	InstanceObj = IND,
	Enrage = 4 * 60,
	EnragePaused = true,
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
	RaidID = "U175A020043177B26",
	TimeOut = 5,
	Castbar = nil,
	Ignore = true,
	TimersRef = {},
	AlertsRef = {},
	ChatRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			LeftLongshot = KBM.Defaults.TimerObj.Create("pink"),
			RightLongshot = KBM.Defaults.TimerObj.Create("pink"),
			Chains = KBM.Defaults.TimerObj.Create("red"),
			Fists = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Dread = KBM.Defaults.AlertObj.Create("purple"),
			DreadDur = KBM.Defaults.AlertObj.Create("yellow"),
			LeftLongshot = KBM.Defaults.AlertObj.Create("pink"),
			RightLongshot = KBM.Defaults.AlertObj.Create("pink"),
		},
		ChatRef = {
			Enabled = true,
			LeftLSSpawn = KBM.Defaults.ChatObj.Create("yellow"),
			LeftLSDied = KBM.Defaults.ChatObj.Create("yellow"),
			RightLSSpawn = KBM.Defaults.ChatObj.Create("yellow"),
			RightLSDied = KBM.Defaults.ChatObj.Create("yellow"),
		},
	}
}

KBM.RegisterMod(RS.ID, RS)

-- Main Unit Dictionary
RS.Lang.Unit = {}
RS.Lang.Unit.Rusila = KBM.Language:Add(RS.Rusila.Name)
RS.Lang.Unit.Rusila:SetGerman("Rusila Schreckensklinge")
RS.Lang.Unit.Rusila:SetFrench("Rusila Lame-lugubre")
RS.Lang.Unit.Rusila:SetRussian("Русила Жуткий Клинок")
RS.Lang.Unit.Rusila:SetKorean("루실라 드레드블레이드")
RS.Lang.Unit.RusShort = KBM.Language:Add("Rusila")
RS.Lang.Unit.RusShort:SetGerman()
RS.Lang.Unit.RusShort:SetFrench()
RS.Lang.Unit.RusShort:SetRussian("Русила")
RS.Lang.Unit.RusShort:SetKorean("루실라")
RS.Lang.Unit.Long = KBM.Language:Add("Dreaded Longshot")
RS.Lang.Unit.Long:SetFrench("Tireur d'élite terrifiant")
RS.Lang.Unit.Long:SetGerman("Gefürchtete Distanzschützin")
RS.Lang.Unit.Long:SetRussian("Жуткий стрелок")
RS.Lang.Unit.LongShort = KBM.Language:Add("Longshot")
RS.Lang.Unit.LongShort:SetFrench("Tireur d'élite")
RS.Lang.Unit.LongShort:SetGerman("Schütze")
RS.Lang.Unit.LongShort:SetRussian("Стрелок")
RS.Lang.Unit.Heart = KBM.Language:Add("Heart of the Dread Fortune")
RS.Lang.Unit.Heart:SetFrench("Cœur de la Fortune funeste")
RS.Lang.Unit.Heart:SetGerman("Herz der Fortuna Fatalis")
RS.Lang.Unit.Heart:SetRussian("Сердце «Жуткого Богатства»")
RS.Lang.Unit.HeartShort = KBM.Language:Add("Heart")
RS.Lang.Unit.HeartShort:SetGerman("Herz")
RS.Lang.Unit.HeartShort:SetFrench("Cœur")
RS.Lang.Unit.HeartShort:SetRussian("Сердце")
RS.Lang.Unit.LeftLong = KBM.Language:Add("Left Longshot")
RS.Lang.Unit.LeftLong:SetRussian("Левый Стрелок")
RS.Lang.Unit.LeftLong:SetGerman("Linker Schütze")
RS.Lang.Unit.LeftLong:SetFrench("Tireur d'élite Gauche")
RS.Lang.Unit.RightLong = KBM.Language:Add("Right Longshot")
RS.Lang.Unit.RightLong:SetRussian("Правый Стрелок")
RS.Lang.Unit.RightLong:SetGerman("Rechter Schütze")
RS.Lang.Unit.RightLong:SetFrench("Tireur d'élite Droite")

-- Ability Dictionary
RS.Lang.Ability = {}
RS.Lang.Ability.Saw = KBM.Language:Add("Buzz Saw")
RS.Lang.Ability.Saw:SetGerman("Kreissäge")
RS.Lang.Ability.Saw:SetFrench("Scie circulaire")
RS.Lang.Ability.Saw:SetKorean("둥근 톱")
RS.Lang.Ability.Saw:SetRussian("Циркулярная пила")
RS.Lang.Ability.Dread = KBM.Language:Add("Dread Shot")
RS.Lang.Ability.Dread:SetGerman("Schreckangriff")
RS.Lang.Ability.Dread:SetFrench("Tir terrifiant")
RS.Lang.Ability.Dread:SetKorean("공포의 사격")
RS.Lang.Ability.Dread:SetRussian("Жуткий выстрел")
RS.Lang.Ability.Fist = KBM.Language:Add("Fist")
RS.Lang.Ability.Fist:SetGerman("Faust")
RS.Lang.Ability.Fist:SetFrench("Poing")
RS.Lang.Ability.Fist:SetKorean("주먹")
RS.Lang.Ability.Fist:SetRussian("Сдавливание")
RS.Lang.Ability.Wrath = KBM.Language:Add("Iron Wrath")
RS.Lang.Ability.Wrath:SetGerman("Eisenzorn")
RS.Lang.Ability.Wrath:SetFrench("Courroux de fer")
RS.Lang.Ability.Wrath:SetKorean("무쇠 진노")
RS.Lang.Ability.Wrath:SetRussian("Железный гнев")
RS.Lang.Ability.Chain = KBM.Language:Add("Barbed Chain")
RS.Lang.Ability.Chain:SetGerman("Stacheldrahtkette")
RS.Lang.Ability.Chain:SetFrench("Chaîne barbelée")
RS.Lang.Ability.Chain:SetKorean("갈고리 사슬")
RS.Lang.Ability.Chain:SetRussian("Шипастая цепь")

-- Notify Dictionary
RS.Lang.Notify = {}
RS.Lang.Notify.Fall = KBM.Language:Add("If The Dread Fortune falls, you'll be joining her.")
RS.Lang.Notify.Fall:SetFrench("Si le Fortune funeste venait à couler, vous sombreriez avec lui.")
RS.Lang.Notify.Fall:SetGerman("Wenn die Fortuna Fatalis untergeht, ist das auch Euer Untergang.")
RS.Lang.Notify.Fall:SetRussian("«Если «Жуткое Богатство» падет, вы %- вместе с ним».")
RS.Lang.Notify.Chain = KBM.Language:Add("Rusila Dreadblade says, \"Punishment for mutiny aboard my vessel, Ascended, is to have your flesh peeled from your bones.\"")
RS.Lang.Notify.Chain:SetGerman("Rusila Schreckensklinge sagt: \"Auserwählte, an Bord meines Schiffes steht auf Meuterei: Das Fleisch wird Meuterern von den Knochen geschält.\"")
RS.Lang.Notify.Fist = KBM.Language:Add("Rusila Dreadblade grins, \"Careful not to fall overboard, Ascended!\"")
RS.Lang.Notify.Fist:SetGerman("Rusila Schreckensklinge grinst und sagt: \"Vorsicht, fallt nicht über Bord, Auserwählter!\"")
RS.Lang.Notify.Fist:SetRussian("Русила Жуткий Клинок, ухмыляясь: «Не свалитесь за борт, Вознесенные!»")
RS.Lang.Notify.Fist:SetFrench('Rusila Lame%-lugubre dit avec un sourire : "Attention à ne pas basculer par%-dessus bord, êtres Élus !"')

-- Buff Dictionary
RS.Lang.Buff = {}
RS.Lang.Buff.Barrel = KBM.Language:Add("Barrel of Dragon's Breath")
RS.Lang.Buff.Barrel:SetFrench("Baril de Souffle de dragon")
RS.Lang.Buff.Barrel:SetGerman("Fass mit Drachenatem")
RS.Lang.Buff.Barrel:SetRussian("Бочонок «Дыхания дракона»")

-- Menu Dictionary
RS.Lang.Menu = {}
RS.Lang.Menu.Dread = KBM.Language:Add("Dread Shot duration")
RS.Lang.Menu.Dread:SetGerman("Schreckangriff Dauer")
RS.Lang.Menu.Dread:SetFrench("Durée Tir terrifiant")
RS.Lang.Menu.Dread:SetKorean("공포의 사격 지소깃간")
RS.Lang.Menu.Dread:SetRussian("Длительность Жуткого выстрела")

-- Verbose Dictionary
RS.Lang.Verbose = {}
RS.Lang.Verbose.LeftLSSpawn = KBM.Language:Add("Left Longshot joins the battle!")
RS.Lang.Verbose.LeftLSSpawn:SetRussian("Левый Стрелок вступает в бой!")
RS.Lang.Verbose.LeftLSSpawn:SetGerman("Linker Schütze ... greift ein!")
RS.Lang.Verbose.LeftLSSpawn:SetFrench("Tireur d'élite Gauche joint la bataille!")
RS.Lang.Verbose.LeftLSDied = KBM.Language:Add("Left Longshot died.")
RS.Lang.Verbose.LeftLSDied:SetRussian("Левый Стрелок умирает.")
RS.Lang.Verbose.LeftLSDied:SetGerman("Linker Schütze ... tot.")
RS.Lang.Verbose.LeftLSDied:SetFrench("Tireur d'élite Gauche mort.")
RS.Lang.Verbose.RightLSSpawn = KBM.Language:Add("Right Longshot joins the battle!")
RS.Lang.Verbose.RightLSSpawn:SetRussian("Правый Стрелок вступает в бой!")
RS.Lang.Verbose.RightLSSpawn:SetGerman("Rechter Schütze ... greift ein!")
RS.Lang.Verbose.RightLSSpawn:SetFrench("Tireur d'élite Droite joint la bataille!")
RS.Lang.Verbose.RightLSDied = KBM.Language:Add("Right Longshot died.")
RS.Lang.Verbose.RightLSDied:SetRussian("Правый Стрелок умирает.")
RS.Lang.Verbose.RightLSDied:SetGerman("Rechter Schütze ... tot.")
RS.Lang.Verbose.RightLSDied:SetFrench("Tireur d'élite Droite mort.")
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
	RaidID = "U15AF32C402742F9B",
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
	RaidID = "U6AA84B235AEB7988",
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
	RaidID = "URusila_DummyIDXX",
	Details = {
		name = "Dummy Start",
		combat = true,
		level = "??",
		tier = "raid",
		location = "The Dread Fortune",
		health = 10,
		healthMax = 10,
		["type"] = "URusila_DummyIDXX",
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
end

function RS:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Rusila.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		Rusila = {
			AlertsRef = self.Rusila.Settings.AlertsRef,
			TimersRef = self.Rusila.Settings.TimersRef,
			ChatRef = self.Rusila.Settings.ChatRef,
		},
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

function RS.PhaseTwo()
	if RS.Phase < 2 then
		RS.PhaseObj.Objectives:Remove()
		RS.PhaseObj.Objectives:AddPercent(RS.Rusila.Name, 0, 100)
		RS.PhaseObj:SetPhase("Final")
		RS.Phase = 2
		KBM.EncTimer:Unpause()
		KBM.MechTimer:AddRemove(RS.Rusila.TimersRef.Fists)
		KBM.MechTimer:AddRemove(RS.Rusila.TimersRef.Chains)
	end
end

function RS:Death(UnitID)
	if self.Rusila.UnitID == UnitID then
		self.Rusila.Dead = true
		return true
	elseif self.Heart.UnitID == UnitID then
		RS.PhaseTwo()
	elseif self.Long.UnitList[UnitID] then
		if self.Long.UnitList[UnitID].Side then
			if self.Long.UnitList[UnitID].Side == "Left" then
				KBM.MechTimer:AddStart(self.Rusila.TimersRef.LeftLongshot)
				KBM.Chat:Display(self.Rusila.ChatRef.LeftLSDied)
			else
				KBM.MechTimer:AddStart(self.Rusila.TimersRef.RightLongshot)
				KBM.Chat:Display(self.Rusila.ChatRef.RightLSDied)
			end			
		else
			--print("Longshot died.")
		end
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
								if uDetails.coordZ < 1573 then
									SubBossObj.Side = "Left"
									if self.Rusila.AlertsRef.LeftLongshot.Enabled then
										KBM.Alert:Start(self.Rusila.AlertsRef.LeftLongshot)
									end
									KBM.Chat:Display(self.Rusila.ChatRef.LeftLSSpawn)
								else
									SubBossObj.Side = "Right"
									if self.Rusila.AlertsRef.RightLongshot.Enabled then
										KBM.Alert:Start(self.Rusila.AlertsRef.RightLongshot)
									end
									KBM.Chat:Display(self.Rusila.ChatRef.RightLSSpawn)
								end
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
	self.Phase = 1
end

function RS:Timer()	
end

function RS:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Rusila, self.Enabled)
end

function RS:Start()
	-- Create Timers
	self.Rusila.TimersRef.LeftLongshot = KBM.MechTimer:Add(self.Lang.Unit.LeftLong[KBM.Lang], 30)
	self.Rusila.TimersRef.RightLongshot = KBM.MechTimer:Add(self.Lang.Unit.RightLong[KBM.Lang], 30)
	self.Rusila.TimersRef.Chains = KBM.MechTimer:Add(self.Lang.Ability.Chain[KBM.Lang], 46)
	self.Rusila.TimersRef.Fists = KBM.MechTimer:Add(self.Lang.Ability.Fist[KBM.Lang], 46)
	KBM.Defaults.TimerObj.Assign(self.Rusila)
	
	-- Create Alerts
	self.Rusila.AlertsRef.Dread = KBM.Alert:Create(self.Lang.Ability.Dread[KBM.Lang], nil, true, true, "purple")
	self.Rusila.AlertsRef.DreadDur = KBM.Alert:Create(self.Lang.Ability.Dread[KBM.Lang], nil, false, true, "yellow")
	self.Rusila.AlertsRef.DreadDur.MenuName = self.Lang.Menu.Dread[KBM.Lang]
	self.Rusila.AlertsRef.LeftLongshot = KBM.Alert:Create(self.Lang.Verbose.LeftLSSpawn[KBM.Lang], 3, false, false, "pink")
	self.Rusila.AlertsRef.RightLongshot = KBM.Alert:Create(self.Lang.Verbose.RightLSSpawn[KBM.Lang], 3, false, false, "pink")
	KBM.Defaults.AlertObj.Assign(self.Rusila)
	
	-- Create Chat Objects
	self.Rusila.ChatRef.LeftLSSpawn = KBM.Chat:Create(self.Lang.Verbose.LeftLSSpawn[KBM.Lang])
	self.Rusila.ChatRef.LeftLSDied = KBM.Chat:Create(self.Lang.Verbose.LeftLSDied[KBM.Lang])
	self.Rusila.ChatRef.RightLSSpawn = KBM.Chat:Create(self.Lang.Verbose.RightLSSpawn[KBM.Lang])
	self.Rusila.ChatRef.RightLSDied = KBM.Chat:Create(self.Lang.Verbose.RightLSDied[KBM.Lang])
	KBM.Defaults.ChatObj.Assign(self.Rusila)
	
	-- Assign Alerts and Timers to Triggers
	self.Rusila.Triggers.Barrel = KBM.Trigger:Create(self.Lang.Buff.Barrel[KBM.Lang], "playerBuff", self.Dummy, nil, "EncStart")
	self.Rusila.Triggers.Dread = KBM.Trigger:Create(self.Lang.Ability.Dread[KBM.Lang], "cast", self.Rusila)
	self.Rusila.Triggers.Dread:AddAlert(self.Rusila.AlertsRef.Dread, true)
	self.Rusila.Triggers.DreadDur = KBM.Trigger:Create(self.Lang.Ability.Dread[KBM.Lang], "channel", self.Rusila)
	self.Rusila.Triggers.DreadDur:AddAlert(self.Rusila.AlertsRef.DreadDur, true)
	self.Rusila.Triggers.Fall = KBM.Trigger:Create(self.Lang.Notify.Fall[KBM.Lang], "notify", self.Rusila)
	self.Rusila.Triggers.Fall:AddPhase(self.PhaseTwo)
	self.Rusila.Triggers.Chains = KBM.Trigger:Create(self.Lang.Notify.Chain[KBM.Lang], "notify", self.Rusila)
	self.Rusila.Triggers.Chains:AddTimer(self.Rusila.TimersRef.Chains)
	self.Rusila.Triggers.Fists = KBM.Trigger:Create(self.Lang.Notify.Fist[KBM.Lang], "notify", self.Rusila)
	self.Rusila.Triggers.Fists:AddTimer(self.Rusila.TimersRef.Fists)
	
	self.Rusila.CastBar = KBM.CastBar:Add(self, self.Rusila)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end