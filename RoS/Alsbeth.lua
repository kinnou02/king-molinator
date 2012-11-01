-- Alsbeth the Discordant Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMROSAD_Settings = nil
chKBMROSAD_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROS = KBM.BossMod["River of Souls"]

local AD = {
	Enabled = true,
	Directory = ROS.Directory,
	File = "Alsbeth.lua",
	Instance = ROS.Name,
	InstanceObj = ROS,
	HasPhases = true,
	Lang = {},
	Enrage = 60 * 18,
	GhostCount = 0,
	PillarDeaths = 0,
	ID = "Alsbeth",
	Object = "AD",
}

AD.Alsbeth = {
	Mod = AD,
	Level = "??",
	Active = false,
	Name = "Alsbeth the Discordant",
	NameShort = "Alsbeth",
	RaidID = "U54832B5406F7E5EF",
	IgnoreID = "U210226B462CFF74C",
	Dead = false,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Phase = KBM.Defaults.TimerObj.Create(),
			Blast = KBM.Defaults.TimerObj.Create("red"),
			Meteor = KBM.Defaults.TimerObj.Create("orange"),
			MeteorFirst = KBM.Defaults.TimerObj.Create("orange"),
			Shield = KBM.Defaults.TimerObj.Create("blue"),
		},
		AlertsRef = {
			Enabled = true,
			PunishWarn = KBM.Defaults.AlertObj.Create("purple"),
			Punish = KBM.Defaults.AlertObj.Create("purple"),
			Blast = KBM.Defaults.AlertObj.Create("red"),
			Ground = KBM.Defaults.AlertObj.Create("yellow"),
			Meteor = KBM.Defaults.AlertObj.Create("orange"),
			Shield = KBM.Defaults.AlertObj.Create("blue"),
		},
		MechRef = {
			Enabled = true,
			Punish = KBM.Defaults.MechObj.Create("purple"),
			Meteor = KBM.Defaults.MechObj.Create("orange"),
		},
	},
}

KBM.RegisterMod(AD.ID, AD)

-- Main Unit Dictionary
AD.Lang.Unit = {}
AD.Lang.Unit.Alsbeth = KBM.Language:Add(AD.Alsbeth.Name)
AD.Lang.Unit.Alsbeth:SetGerman("Alsbeth die Streitsuchende")
AD.Lang.Unit.Alsbeth:SetFrench("Alsbeth la Discordante")
AD.Lang.Unit.Alsbeth:SetRussian("Альсбет Раздорная")
AD.Lang.Unit.Alsbeth:SetKorean("부조화의 알스베스")
-- Additional Unit Dictionary
AD.Lang.Unit.Pillar = KBM.Language:Add("Discordant Pillar")
AD.Lang.Unit.Pillar:SetGerman("Zwietracht-Säule")
AD.Lang.Unit.Pillar:SetFrench("Pilier discordant")
AD.Lang.Unit.Pillar:SetRussian("Столб раздора")
AD.Lang.Unit.Pillar:SetKorean("부조화의 기둥")
AD.Lang.Unit.PillarShort = KBM.Language:Add("Pillar")
AD.Lang.Unit.PillarShort:SetGerman("Säule")
AD.Lang.Unit.PillarShort:SetFrench("Pilier")
AD.Lang.Unit.PillarShort:SetRussian("Столб")
AD.Lang.Unit.PillarShort:SetKorean("기둥")
AD.Lang.Unit.Harbinger = KBM.Language:Add("Soul Harbinger")
AD.Lang.Unit.Harbinger:SetGerman("Seelen-Vorbote")
AD.Lang.Unit.Harbinger:SetFrench("Héraut des âmes")
AD.Lang.Unit.Harbinger:SetRussian("Духовный вестник")
AD.Lang.Unit.Harbinger:SetKorean("영혼 선구자")
AD.Lang.Unit.HarbingerShort = KBM.Language:Add("Harbinger")
AD.Lang.Unit.HarbingerShort:SetGerman("Vorbote")
AD.Lang.Unit.HarbingerShort:SetFrench("Héraut")
AD.Lang.Unit.HarbingerShort:SetRussian("Вестник")
AD.Lang.Unit.HarbingerShort:SetKorean("선구자")
AD.Lang.Unit.Thief = KBM.Language:Add("Soul Thief")
AD.Lang.Unit.Thief:SetGerman("Seelen-Dieb")
AD.Lang.Unit.Thief:SetFrench("Voleur d'âmes")
AD.Lang.Unit.Thief:SetRussian("Вор душ")
AD.Lang.Unit.ThiefShort = KBM.Language:Add("Thief")
AD.Lang.Unit.ThiefShort:SetGerman("Dieb")
AD.Lang.Unit.ThiefShort:SetFrench("Voleur")
AD.Lang.Unit.ThiefShort:SetRussian("Вор")
AD.Lang.Unit.ThiefShort:SetKorean("도둑")
AD.Lang.Unit.Thief:SetKorean("영혼 도둑")
AD.Lang.Unit.Magus = KBM.Language:Add("Soul Magus")
AD.Lang.Unit.Magus:SetGerman("Seelen-Magus")
AD.Lang.Unit.Magus:SetFrench("Animancien")
AD.Lang.Unit.Magus:SetRussian("Маг души")
AD.Lang.Unit.Magus:SetKorean("영혼 점성술사")
AD.Lang.Unit.MagusShort = KBM.Language:Add("Magi")
AD.Lang.Unit.MagusShort:SetGerman("Magus")
AD.Lang.Unit.MagusShort:SetFrench("Ani")
AD.Lang.Unit.MagusShort:SetRussian("Маг")
AD.Lang.Unit.MagusShort:SetKorean("점성술사")
-- Ability Dictionary
AD.Lang.Ability = {}
AD.Lang.Ability.Punish = KBM.Language:Add("Punish Soul")
AD.Lang.Ability.Punish:SetGerman("Seelenbestrafung")
AD.Lang.Ability.Punish:SetFrench("Punir l'Âme")
AD.Lang.Ability.Punish:SetRussian("Покарать душу")
AD.Lang.Ability.Punish:SetKorean("영혼 형벌")
AD.Lang.Ability.Ground = KBM.Language:Add("Discordant Ground")
AD.Lang.Ability.Ground:SetGerman("Boden der Zwietracht")
AD.Lang.Ability.Ground:SetFrench("Discordance tellurique")
AD.Lang.Ability.Ground:SetRussian("Земля раздора")
AD.Lang.Ability.Ground:SetKorean("부조화의 지면")
AD.Lang.Ability.Blast = KBM.Language:Add("Discordant Blast")
AD.Lang.Ability.Blast:SetGerman("Zwietracht-Explosion")
AD.Lang.Ability.Blast:SetFrench("Explosion discordante")
AD.Lang.Ability.Blast:SetRussian("Взрыв раздора")
AD.Lang.Ability.Blast:SetKorean("부조화의 폭발")
AD.Lang.Ability.Soul = KBM.Language:Add("Soul Destruction")
AD.Lang.Ability.Soul:SetGerman("Seelenzerstörung")
AD.Lang.Ability.Soul:SetFrench("Destruction de l'Âme")
AD.Lang.Ability.Soul:SetRussian("Разрушение души")
AD.Lang.Ability.Soul:SetKorean("영혼 파괴")
AD.Lang.Ability.Meteor = KBM.Language:Add("Discordant Meteor")
AD.Lang.Ability.Meteor:SetGerman("Zwietracht-Meteor")
AD.Lang.Ability.Meteor:SetFrench("Météore discordant")
AD.Lang.Ability.Meteor:SetRussian("Метеор раздора")
AD.Lang.Ability.Meteor:SetKorean("부조화의 운석")
-- Notify Dictionary
AD.Lang.Notify = {}
AD.Lang.Notify.Punish = KBM.Language:Add("(%a*)'s soul is wracked with energy!")
AD.Lang.Notify.Punish:SetFrench("L'âme de (%a*) est ravagée par l'énergie !")
AD.Lang.Notify.Punish:SetGerman("Die Seele von (%a*) wird mit Energie überladen!")
AD.Lang.Notify.Punish:SetRussian("(%a*) чувствует, что его душа изувечена энергией!")
AD.Lang.Notify.Punish:SetKorean("(%a*)의 영혼이 에너지로 고통을 받습니다!")
AD.Lang.Notify.Meteor = KBM.Language:Add("Alsbeth the Discordant points at (%a*).")
AD.Lang.Notify.Meteor:SetGerman("Alsbeth die Streitsuchende zeigt auf (%a*).")
AD.Lang.Notify.Meteor:SetFrench("Alsbeth la Discordante pointe vers (%a*) !")
AD.Lang.Notify.Meteor:SetKorean("부조화의 알스베스이(가) (%a*)을(를) 가리킵니다.")
-- Buff Dictionary
AD.Lang.Buff = {}
AD.Lang.Buff.Shield = KBM.Language:Add("Shield of Darkness")
AD.Lang.Buff.Shield:SetGerman("Schild der Dunkelheit")
AD.Lang.Buff.Shield:SetFrench("Bouclier discordant")
AD.Lang.Buff.Shield:SetRussian("Щит тьмы")
AD.Lang.Buff.Shield:SetKorean("암흑의 보호막")
-- Verbose Dictionary
AD.Lang.Verbose = {}
AD.Lang.Verbose.Phase = KBM.Language:Add("Until air phase")
AD.Lang.Verbose.Phase:SetGerman("bis zur Flugphase")
AD.Lang.Verbose.Phase:SetFrench("Jusqu'à la phase de l'air")
AD.Lang.Verbose.Phase:SetRussian("Воздушная фаза")
AD.Lang.Verbose.Phase:SetKorean("공중 단계까지")
AD.Lang.Verbose.PunishWarn = KBM.Language:Add(AD.Lang.Ability.Punish[KBM.Lang].." (Personal Alert, Warning)")
AD.Lang.Verbose.PunishWarn:SetGerman(AD.Lang.Ability.Punish[KBM.Lang].." (Eigene Warnung)")
AD.Lang.Verbose.PunishWarn:SetFrench("Punir l'Âme (Alerte Personelle, Avertissement)")
AD.Lang.Verbose.PunishWarn:SetRussian(AD.Lang.Ability.Punish[KBM.Lang].." (предупреждение)")
AD.Lang.Verbose.PunishWarn:SetKorean("영혼 형벌 (개인적인 경고)")
AD.Lang.Verbose.Punish = KBM.Language:Add(AD.Lang.Ability.Punish[KBM.Lang].." (Personal Alert, Duration)")
AD.Lang.Verbose.Punish:SetGerman(AD.Lang.Ability.Punish[KBM.Lang].." (Eigene Warnung, Dauer)")
AD.Lang.Verbose.Punish:SetFrench("Punir l'Âme (Alerte Personelle, Durée)")
AD.Lang.Verbose.Punish:SetRussian(AD.Lang.Ability.Punish[KBM.Lang].." (длительность)")
AD.Lang.Verbose.Punish:SetKorean("영혼 형벌 (개인적인 경고, 지속시간)")
AD.Lang.Verbose.Meteor = KBM.Language:Add(AD.Lang.Ability.Meteor[KBM.Lang].." (First in phase 2)")
AD.Lang.Verbose.Meteor:SetGerman(AD.Lang.Ability.Meteor[KBM.Lang].." (Erste in Phase 2)")
AD.Lang.Verbose.Meteor:SetFrench("Météore discordant (Premier en phase 2)")
AD.Lang.Verbose.Meteor:SetRussian(AD.Lang.Ability.Meteor[KBM.Lang].." (первый на фазе 2)")
AD.Lang.Verbose.Meteor:SetKorean("부조화의 운석 (2단계 초기)")
AD.Harbinger = {
	Mod = AD,
	Level = "??",
	Active = false,
	Name = AD.Lang.Unit.Harbinger[KBM.Lang],
	NameShort = AD.Lang.Unit.HarbingerShort[KBM.Lang],
	Dead = false,
	Available = false,
	UnitID = nil,
	Ignore = true,
	Triggers = {},
	RaidID = "Raid",
}

AD.Thief = {
	Mod = AD,
	Level = "??",
	Active = false,
	Name = AD.Lang.Unit.Thief[KBM.Lang],
	NameShort = AD.Lang.Unit.ThiefShort[KBM.Lang],
	Dead = false,
	Available = false,
	UnitID = nil,
	Ignore = true,
	Triggers = {},
	RaidID = "Raid",
}

AD.Magus = {
	Mod = AD,
	Level = "??",
	Active = false,
	Name = AD.Lang.Unit.Magus[KBM.Lang],
	NameShort = AD.Lang.Unit.MagusShort[KBM.Lang],
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	RaidID = "U37D4CCEA74E0BB39",
	UnitID = nil,
	Ignore = true,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Soul = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Soul = KBM.Defaults.AlertObj.Create("yellow"),
		},
	},
}

AD.Pillar = {
	Mod = AD,
	Level = "??",
	Name = AD.Lang.Unit.Pillar[KBM.Lang],
	NameShort = AD.Lang.Unit.PillarShort[KBM.Lang],
	UnitList = {},
	Ignore = true,
	Type = "multi",
	RaidID = "U76026D384D081D9F",
}

AD.Alsbeth.Name = AD.Lang.Unit.Alsbeth[KBM.Lang]
AD.Descript = AD.Alsbeth.Name

function AD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Alsbeth.Name] = self.Alsbeth,
		[self.Harbinger.Name] = self.Harbinger,
		[self.Thief.Name] = self.Thief,
		[self.Magus.Name] = self.Magus,
		[self.Pillar.Name] = self.Pillar,
	}
	KBM.SubBoss[self.Harbinger.Name] = self.Harbinger
	KBM.SubBoss[self.Thief.Name] = self.Thief
end

function AD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Multi = true,
			Override = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alsbeth = {
			CastBar = self.Alsbeth.Settings.CastBar,
			TimersRef = self.Alsbeth.Settings.TimersRef,
			AlertsRef = self.Alsbeth.Settings.AlertsRef,
			MechRef = self.Alsbeth.Settings.MechRef,
		},
		Magus = {
			CastBar = self.Magus.Settings.CastBar,
			TimersRef = self.Magus.Settings.TimersRef,
			AlertsRef = self.Magus.Settings.AlertsRef,
		},
	}
	KBMROSAD_Settings = self.Settings
	chKBMROSAD_Settings = self.Settings
end

function AD:SwapSettings(bool)
	if bool then
		KBMROSAD_Settings = self.Settings
		self.Settings = chKBMROSAD_Settings
	else
		chKBMROSAD_Settings = self.Settings
		self.Settings = KBMROSAD_Settings
	end
end

function AD:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKBMROSAD_Settings, self.Settings)
	else
		KBM.LoadTable(KBMROSAD_Settings, self.Settings)
	end
		
	if KBM.Options.Character then
		chKBMROSAD_Settings = self.Settings
	else
		KBMROSAD_Settings = self.Settings
	end
	
	self.Settings.CastBar.Multi = true
	self.Settings.CastBar.Override = true
	
	self.Settings.Alsbeth.CastBar.Multi = true
	self.Settings.Alsbeth.CastBar.Override = true
	self.Settings.Magus.CastBar.Multi = true
	self.Settings.Magus.CastBar.Override = true
	
end

function AD:SaveVars()
	if KBM.Options.Character then
		chKBMROSAD_Settings = self.Settings
	else
		KBMROSAD_Settings = self.Settings
	end	
end

function AD:Castbar(units)
end

function AD:RemoveUnits(UnitID)
	if self.Alsbeth.UnitID == UnitID then
		self.Alsbeth.Available = false
		return true
	end
	return false
end

function AD.AirPhase()
	AD.Phase = 2
	AD.GhostCount = AD.GhostCount + 1
	AD.PillarDeaths = 0
	if AD.GhostCount > 3 then
		AD.GhostCount = 3
	end
	AD.PhaseObj:SetPhase(KBM.Language.Options.Air[KBM.Lang])
	AD.PhaseObj.Objectives:AddDeath(AD.Pillar.Name, AD.GhostCount, 0)
	KBM.MechTimer:AddStart(AD.Alsbeth.TimersRef.MeteorFirst)
end

function AD.GroundPhase()
	AD.Phase = 1
	AD.PhaseObj.Objectives:Remove()
	AD.PhaseObj:SetPhase(KBM.Language.Options.Ground[KBM.Lang])
	AD.PhaseObj.Objectives:AddPercent(AD.Alsbeth.Name, 20, 100)
	KBM.MechTimer:AddRemove(AD.Alsbeth.TimersRef.Meteor)
	KBM.MechTimer:AddStart(AD.Alsbeth.TimersRef.Phase)
end

function AD.FinalPhase()
	AD.Phase = 3
	AD.PhaseObj.Objectives:Remove()
	AD.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	AD.PhaseObj.Objectives:AddPercent(AD.Alsbeth.Name, 0, 20)
end

function AD:Death(UnitID)
	if self.Alsbeth.UnitID == UnitID then
		self.Alsbeth.Dead = true
		return true
	end
	if self.Phase == 2 then
		if self.Magus.UnitID == UnitID then
			self.Magus.Dead = true
			self.Magus.CastBar:Remove()
			self.Magus.UnitID = nil
		elseif self.Thief.UnitID == UnitID then
			self.Thief.Dead = true
			self.Thief.UnitID = nil
		elseif self.Harbinger.UnitID == UnitID then
			self.Harbinger.Dead = true
			self.Harbinger.UnitID = nil
		else
			if self.Phase == 2 then
				if self.Pillar.UnitList[UnitID] then
					if not self.Pillar.UnitList[UnitID].Dead then
						self.PillarDeaths = self.PillarDeaths + 1
						if self.PillarDeaths == self.GhostCount then
							self.GroundPhase()
						end
					end
				end
			end
		end
	end	
	return false
end

function AD:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Alsbeth.Name then
				if not self.Alsbeth.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Alsbeth.Dead = false
					self.Alsbeth.Casting = false
					self.Alsbeth.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Alsbeth.Name, 20, 100)
					self.PhaseObj:SetPhase(KBM.Language.Options.Ground[KBM.Lang])
					self.GhostCount = 0
					self.Phase = 1
					KBM.MechTimer:AddStart(self.Alsbeth.TimersRef.Phase)
				end
				self.Alsbeth.UnitID = unitID
				self.Alsbeth.Available = true
				return self.Alsbeth
			elseif uDetails.name == self.Pillar.Name then
				if self.Phase < 3 then
					if not self.Bosses[uDetails.name].UnitList[unitID] then
						SubBossObj = {
							Mod = AD,
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
			else
				if self.Phase < 3 then
					if not self.Bosses[uDetails.name].UnitID then
						self.Bosses[uDetails.name].UnitID = unitID
						self.Bosses[uDetails.name].Available = true
						self.Bosses[uDetails.name].Dead = false
						if uDetails.name == self.Magus.Name then
							self.Magus.CastBar:Create(unitID)
						end
						if self.Phase ~= 2 then
							self.AirPhase()
						end
						self.PhaseObj.Objectives:AddPercent(uDetails.name, 0, 100)
					else
						self.Bosses[uDetails.name].Available = true
						self.Bosses[uDetails.name].UnitID = unitID
					end
					return self.Bosses[uDetails.name]
				end
			end
		end
	end
end

function AD:Reset()
	self.EncounterRunning = false
	self.Alsbeth.Available = false
	self.Alsbeth.UnitID = nil
	self.Alsbeth.CastBar:Remove()
	self.Alsbeth.Dead = false
	self.PhaseObj:End(Inspect.Time.Real())
	self.GhostCount = 0
	self.PillarCount = 0
	self.Pillar.UnitList = {}
	self.Magus.UnitID = nil
	self.Magus.Dead = false
	self.Harbinger.UnitID = nil
	self.Harbinger.Dead = false
	self.Thief.UnitID = nil
	self.Thief.Dead = false
end

function AD:Timer()	
end

function AD:DefineMenu()
	self.Menu = ROS.Menu:CreateEncounter(self.Alsbeth, self.Enabled)
end

function AD:Start()
	-- Create Timers
	self.Alsbeth.TimersRef.Phase = KBM.MechTimer:Add(self.Lang.Verbose.Phase[KBM.Lang], 45)
	self.Alsbeth.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Ability.Blast[KBM.Lang], 38)
	self.Alsbeth.TimersRef.Meteor = KBM.MechTimer:Add(self.Lang.Ability.Meteor[KBM.Lang], 36)
	self.Alsbeth.TimersRef.MeteorFirst = KBM.MechTimer:Add(self.Lang.Ability.Meteor[KBM.Lang], 10)
	self.Alsbeth.TimersRef.MeteorFirst.MenuName = self.Lang.Verbose.Meteor[KBM.Lang]
	self.Alsbeth.TimersRef.Shield = KBM.MechTimer:Add(self.Lang.Buff.Shield[KBM.Lang], 32)
	self.Magus.TimersRef.Soul = KBM.MechTimer:Add(self.Lang.Ability.Soul[KBM.Lang], 10)
	KBM.Defaults.TimerObj.Assign(self.Alsbeth)
	KBM.Defaults.TimerObj.Assign(self.Magus)
	
	-- Create Alerts
	self.Alsbeth.AlertsRef.PunishWarn = KBM.Alert:Create(self.Lang.Ability.Punish[KBM.Lang], 1.5, true, true, "purple")
	self.Alsbeth.AlertsRef.PunishWarn.MenuName = self.Lang.Verbose.PunishWarn[KBM.Lang]
	self.Alsbeth.AlertsRef.Punish = KBM.Alert:Create(self.Lang.Ability.Punish[KBM.Lang], nil, false, true, "purple")
	self.Alsbeth.AlertsRef.Punish:Important()
	self.Alsbeth.AlertsRef.Punish.MenuName = self.Lang.Verbose.Punish[KBM.Lang]
	self.Alsbeth.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], nil, true, true, "red")
	self.Alsbeth.AlertsRef.Ground = KBM.Alert:Create(self.Lang.Ability.Ground[KBM.Lang], nil, true, true, "yellow")
	self.Alsbeth.AlertsRef.Meteor = KBM.Alert:Create(self.Lang.Ability.Meteor[KBM.Lang], 12, false, true, "orange")
	self.Alsbeth.AlertsRef.Shield = KBM.Alert:Create(self.Lang.Buff.Shield[KBM.Lang], nil, false, true, "blue")
	self.Magus.AlertsRef.Soul = KBM.Alert:Create(self.Lang.Ability.Soul[KBM.Lang], nil, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Alsbeth)
	KBM.Defaults.AlertObj.Assign(self.Magus)
	
	-- Create Mechanic Spies
	self.Alsbeth.MechRef.Punish = KBM.MechSpy:Add(self.Lang.Ability.Punish[KBM.Lang], nil, "dynamic", self.Alsbeth)
	self.Alsbeth.MechRef.Punish.Duration = 1.5
	self.Alsbeth.MechRef.Meteor = KBM.MechSpy:Add(self.Lang.Ability.Meteor[KBM.Lang], 12, "notify", self.Alsbeth)
	KBM.Defaults.MechObj.Assign(self.Alsbeth)
	
	-- Assign Timers and Alerts to triggers.
	self.Alsbeth.Triggers.PunishWarn = KBM.Trigger:Create(self.Lang.Notify.Punish[KBM.Lang], "notify", self.Alsbeth)
	self.Alsbeth.Triggers.PunishWarn:AddAlert(self.Alsbeth.AlertsRef.PunishWarn, true)
	self.Alsbeth.Triggers.PunishWarn:AddSpy(self.Alsbeth.MechRef.Punish)
	self.Alsbeth.Triggers.Punish = KBM.Trigger:Create(self.Lang.Ability.Punish[KBM.Lang], "playerBuff", self.Alsbeth)
	self.Alsbeth.Triggers.Punish:AddAlert(self.Alsbeth.AlertsRef.Punish, true)
	self.Alsbeth.Triggers.Punish:AddSpy(self.Alsbeth.MechRef.Punish)
	self.Alsbeth.Triggers.Final = KBM.Trigger:Create(20, "percent", self.Alsbeth)
	self.Alsbeth.Triggers.Final:AddPhase(self.FinalPhase)
	self.Alsbeth.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "cast", self.Alsbeth)
	self.Alsbeth.Triggers.Blast:AddTimer(self.Alsbeth.TimersRef.Blast)
	self.Alsbeth.Triggers.Blast:AddAlert(self.Alsbeth.AlertsRef.Blast)
	self.Alsbeth.Triggers.Ground = KBM.Trigger:Create(self.Lang.Ability.Ground[KBM.Lang], "cast", self.Alsbeth)
	self.Alsbeth.Triggers.Ground:AddAlert(self.Alsbeth.AlertsRef.Ground)
	self.Alsbeth.Triggers.Meteor = KBM.Trigger:Create(self.Lang.Notify.Meteor[KBM.Lang], "notify", self.Alsbeth)
	self.Alsbeth.Triggers.Meteor:AddTimer(self.Alsbeth.TimersRef.Meteor)
	self.Alsbeth.Triggers.Meteor:AddAlert(self.Alsbeth.AlertsRef.Meteor)
	self.Alsbeth.Triggers.Meteor:AddSpy(self.Alsbeth.MechRef.Meteor)
	self.Alsbeth.Triggers.Shield = KBM.Trigger:Create(self.Lang.Buff.Shield[KBM.Lang], "buff", self.Alsbeth)
	self.Alsbeth.Triggers.Shield:AddTimer(self.Alsbeth.TimersRef.Shield)
	self.Alsbeth.Triggers.Shield:AddAlert(self.Alsbeth.AlertsRef.Shield)
	self.Alsbeth.Triggers.ShieldEnd = KBM.Trigger:Create(self.Lang.Buff.Shield[KBM.Lang], "buffRemove", self.Alsbeth)
	self.Alsbeth.Triggers.ShieldEnd:AddStop(self.Alsbeth.AlertsRef.Shield)
	self.Magus.Triggers.Soul = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "cast", self.Magus)
	self.Magus.Triggers.Soul:AddTimer(self.Magus.TimersRef.Soul)
	self.Magus.Triggers.Soul:AddAlert(self.Magus.AlertsRef.Soul)
	self.Magus.Triggers.SoulInt = KBM.Trigger:Create(self.Lang.Ability.Soul[KBM.Lang], "interrupt", self.Magus)
	self.Magus.Triggers.SoulInt:AddStop(self.Magus.AlertsRef.Soul)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self.Alsbeth.CastBar = KBM.CastBar:Add(self, self.Alsbeth)
	self.Magus.CastBar = KBM.CastBar:Add(self, self.Magus)
	self:DefineMenu()
end