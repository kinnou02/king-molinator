-- High Priest Arakhurn Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMIROTPHA_Settings = nil
chKBMIROTPHA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local ROTP = KBM.BossMod["Intrepid Rise of the Phoenix"]

local HA = {
	Directory = ROTP.Directory,
	File = "Arakhurn.lua",
	Enabled = true,
	Instance = ROTP.Name,
	InstanceObj = ROTP,
	HasPhases = true,
	Lang = {},
	TimeoutOverride = false,
	Timeout = 60,
	Phase = 1,
	Enrage = 14.5 * 60,
	ID = "Intrepid Arakhurn",
	Object = "HA",
}

HA.Arakhurn = {
	Mod = HA,
	Level = "??",
	Active = false,
	Name = "High Priest Arakhurn",
	NameShort = "Arakhurn",
	UTID = {
		[1] = "UFE3404FE6864F1B8",
		[2] = "U2D48EA697C2E12B2",
	},
	Menu = {},
	Castbar = nil,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
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
		MechRef = {
			Enabled = true,
			Ignited = KBM.Defaults.MechObj.Create("red"),
			Fiery = KBM.Defaults.MechObj.Create("orange"),
		}
	}
}

KBM.RegisterMod(HA.ID, HA)

-- Main Unit Dictionary
HA.Lang.Unit = {}
HA.Lang.Unit.Arakhurn = KBM.Language:Add(HA.Arakhurn.Name)
HA.Lang.Unit.Arakhurn:SetGerman("Hohepriester Arakhurn")
HA.Lang.Unit.Arakhurn:SetFrench("Grand-prêtre Arakhurn")
HA.Lang.Unit.Arakhurn:SetRussian("Первосвященник Аракурн")
HA.Lang.Unit.Arakhurn:SetKorean("상급 성직자 아라쿠른")
HA.Arakhurn.Name = HA.Lang.Unit.Arakhurn[KBM.Lang]
HA.Descript = HA.Arakhurn.Name
HA.Lang.Unit.ArakhurnShort = KBM.Language:Add("Arakhurn")
HA.Lang.Unit.ArakhurnShort:SetGerman("Arakhurn")
HA.Lang.Unit.ArakhurnShort:SetFrench("Arakhurn")
HA.Lang.Unit.ArakhurnShort:SetRussian("Аракурн")
HA.Lang.Unit.ArakhurnShort:SetKorean("아라쿠른")
HA.Arakhurn.NameShort = HA.Lang.Unit.ArakhurnShort[KBM.Lang]
-- Additional Unit Dictionary
HA.Lang.Unit.Spawn = KBM.Language:Add("Spawn of Arakhurn")
HA.Lang.Unit.Spawn:SetGerman("Brut von Arakhurn")
HA.Lang.Unit.Spawn:SetFrench("Rejeton d'Arakhurn")
HA.Lang.Unit.Spawn:SetRussian("Отродье Арахурна")
HA.Lang.Unit.Spawn:SetKorean("아라쿠른 혈족")
HA.Lang.Unit.Enraged = KBM.Language:Add("Enraged Spawn of Arakhurn")
HA.Lang.Unit.Enraged:SetGerman("Zornige Brut von Arakhurn")
HA.Lang.Unit.Enraged:SetFrench("Rejeton enragé d'Arakhurn")
HA.Lang.Unit.Enraged:SetRussian("Взбесившееся порождение Арахурна")
HA.Lang.Unit.Enraged:SetKorean("격분한 아라쿠른 혈족")

-- Ability Dictionary
HA.Lang.Ability = {}
HA.Lang.Ability.Nova = KBM.Language:Add("Fire Nova")
HA.Lang.Ability.Nova:SetGerman("Feuernova")
HA.Lang.Ability.Nova:SetRussian("Огненная сверхновая")
HA.Lang.Ability.Nova:SetFrench("Nova de flammes")
HA.Lang.Ability.Nova:SetKorean("화염 신성")

-- Notify Dictionary
HA.Lang.Notify = {}
HA.Lang.Notify.Nova = KBM.Language:Add("High Priest Arakhurn releases the fiery energy within")
HA.Lang.Notify.Nova:SetGerman("Hohepriester Arakhurn lässt die feurige Energie seines Inneren frei.")
HA.Lang.Notify.Nova:SetFrench("Grand-prêtre Arakhurn commence à libèrer l'énergie ardente qui réside en lui")
HA.Lang.Notify.Nova:SetRussian("Первосвященник Аракурн высвобождает скрытую внутри яростную энергию.")
HA.Lang.Notify.Nova:SetKorean("상급 성직자 아라쿠른이(가) 자신 내부의 화염 에너지를 쏟아 냅니다.")
HA.Lang.Notify.Respawn = KBM.Language:Add("The lava churns violently as a large shadow moves beneath it and then rushes to the surface")
HA.Lang.Notify.Respawn:SetGerman("Die Lava brodelt gewaltig, während sich ein großer Schatten unter ihr bewegt und dann an die Oberfläche schnellt.")
HA.Lang.Notify.Respawn:SetRussian("Лава бурлит; под ней движется огромная тень, стремительно всплывая к поверхности.")
HA.Lang.Notify.Respawn:SetFrench("La lave s'agite violemment, tandis qu'une grande ombre bouge dans ses profondeurs et se précipite ensuite vers la surface.")
HA.Lang.Notify.Respawn:SetKorean("미친 듯이 들끓는 용암 아래에서 거대한 그림자가 움직이더니 갑자기 용암 표면 위로 솟아오릅니다.")
HA.Lang.Notify.Death = KBM.Language:Add("As Arakhurn turns to ash, something stirs beneath the molten lava.")
HA.Lang.Notify.Death:SetGerman("Als Arakhurn zu Asche zerfällt, regt sich etwas unter der schwelenden Lava.")
HA.Lang.Notify.Death:SetRussian("По мере того, как Аракурн превращается в пепел, что-то пробуждается под раскаленной лавой.")
HA.Lang.Notify.Death:SetFrench("Tandis qu'Arakhurn se consume, on distingue un mouvement sous la lave en fusion.")
HA.Lang.Notify.Death:SetKorean("아라크룬이 잿더미가 되자 고온용암 용암 아래에서 무언가 꿈틀거립니다.")

-- Chat Dictionary
HA.Lang.Chat = {}
HA.Lang.Chat.Respawn = KBM.Language:Add("Come to me, my children.")
HA.Lang.Chat.Respawn:SetGerman("Kommt zu mir, meine Kinder.")
HA.Lang.Chat.Respawn:SetFrench("Venez à moi, mes enfants.")
HA.Lang.Chat.Respawn:SetRussian("Ко мне, дети мои.")
HA.Lang.Chat.Respawn:SetKorean("이리 와라, 나의 아이들아.")
HA.Lang.Chat.Death = KBM.Language:Add("The fire within me weakens. I must regain the power of the flame.")
HA.Lang.Chat.Death:SetGerman("Das Feuer in mir wird schwächer. Ich muss die Kraft der Flamme zurückgewinnen.")
HA.Lang.Chat.Death:SetFrench("Le feu faiblit en moi. Je dois retrouver le pouvoir de la flamme.")
HA.Lang.Chat.Death:SetRussian("Огонь во мне ослабевает. Я должен восполнить силу пламени.")

-- Buff Dictionary
HA.Lang.Buff = {}
HA.Lang.Buff.Fiery = KBM.Language:Add("Fiery Metamorphosis")
HA.Lang.Buff.Fiery:SetGerman("Feurige Metamorphose")
HA.Lang.Buff.Fiery:SetFrench("Métamorphose ardente")
HA.Lang.Buff.Fiery:SetRussian("Огненное превращение")
HA.Lang.Buff.Fiery:SetKorean("화염 변형")

-- Debuff Dictionary
HA.Lang.Debuff = {}
HA.Lang.Debuff.Armor = KBM.Language:Add("Armor Rip")
HA.Lang.Debuff.Armor:SetGerman("Rüstung aufreißen")
HA.Lang.Debuff.Armor:SetFrench("Déchirure d'armure")
HA.Lang.Debuff.Armor:SetRussian("Раздиратель доспехов")
HA.Lang.Debuff.Armor:SetKorean("방어구 찢기")
HA.Lang.Debuff.Ignited = KBM.Language:Add("Ignited")
HA.Lang.Debuff.Ignited:SetGerman("Entflammt")
HA.Lang.Debuff.Ignited:SetFrench("Enflammé")
HA.Lang.Debuff.Ignited:SetKorean("점화")

-- Verbose Dictionary
HA.Lang.Verbose = {}
HA.Lang.Verbose.Nova = KBM.Language:Add("until "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Verbose.Nova:SetGerman("bis "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Verbose.Nova:SetFrench("jusqu'à Nova de flammes")
HA.Lang.Verbose.Nova:SetRussian("до "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Verbose.Nova:SetKorean("화염 신성까지")
HA.Lang.Verbose.Rise = KBM.Language:Add(HA.Lang.Unit.Arakhurn[KBM.Lang].." rises")
HA.Lang.Verbose.Rise:SetGerman(HA.Lang.Unit.Arakhurn[KBM.Lang].." erscheint")
HA.Lang.Verbose.Rise:SetFrench("Grand-Prêtre Arakhurn revit")
HA.Lang.Verbose.Rise:SetRussian(HA.Lang.Unit.Arakhurn[KBM.Lang].." оживает")
HA.Lang.Verbose.Rise:SetKorean("고위 성직자 아라쿠른 비상")

-- Phase Monitor Dictionary
HA.Lang.Phase = {}
HA.Lang.Phase.Adds = KBM.Language:Add("Adds")
HA.Lang.Phase.Adds:SetGerman()
HA.Lang.Phase.Adds:SetFrench()
HA.Lang.Phase.Adds:SetRussian("Адды")
HA.Lang.Phase.Adds:SetKorean("쫄들")

-- Menu Dictionary
HA.Lang.Menu = {}
HA.Lang.Menu.FieryFirst = KBM.Language:Add("First "..HA.Lang.Buff.Fiery[KBM.Lang])
HA.Lang.Menu.FieryFirst:SetGerman("Erste "..HA.Lang.Buff.Fiery[KBM.Lang])
HA.Lang.Menu.FieryFirst:SetFrench("Première Métamorphose ardente")
HA.Lang.Menu.FieryFirst:SetRussian("Первое "..HA.Lang.Buff.Fiery[KBM.Lang])
HA.Lang.Menu.FieryFirst:SetKorean("첫번째 화염 변형")
HA.Lang.Menu.FieryPThree = KBM.Language:Add("First "..HA.Lang.Buff.Fiery[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.FieryPThree:SetGerman("Erste "..HA.Lang.Buff.Fiery[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.FieryPThree:SetFrench("Première Métamorphose ardente (Phase 3)")
HA.Lang.Menu.FieryPThree:SetRussian("Первое "..HA.Lang.Buff.Fiery[KBM.Lang].." (Фаза 3)")
HA.Lang.Menu.FieryPThree:SetKorean("첫번째 화염 변형 (Phase 3)")
HA.Lang.Menu.NovaFirst = KBM.Language:Add("First "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaFirst:SetGerman("Erste "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaFirst:SetFrench("Premier Nova de flammes")
HA.Lang.Menu.NovaFirst:SetRussian("Первая "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaFirst:SetKorean("첫번째 화염 신성")
HA.Lang.Menu.NovaPThree = KBM.Language:Add("First "..HA.Lang.Ability.Nova[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.NovaPThree:SetGerman("Erste "..HA.Lang.Ability.Nova[KBM.Lang].." (Phase 3)")
HA.Lang.Menu.NovaPThree:SetFrench("Premier Nova de flammes (Phase 3)")
HA.Lang.Menu.NovaPThree:SetRussian("Первая "..HA.Lang.Ability.Nova[KBM.Lang].." (Фаза 3)")
HA.Lang.Menu.NovaPThree:SetKorean("첫번째 화염 신성 (Phase 3)")
HA.Lang.Menu.AddFirst = KBM.Language:Add("First "..HA.Lang.Unit.Enraged[KBM.Lang])
HA.Lang.Menu.AddFirst:SetGerman("Erste "..HA.Lang.Unit.Enraged[KBM.Lang])
HA.Lang.Menu.AddFirst:SetFrench("Premier Rejeton enragé d'Arakhurn")
HA.Lang.Menu.AddFirst:SetRussian("Первое "..HA.Lang.Unit.Enraged[KBM.Lang])
HA.Lang.Menu.AddFirst:SetKorean("첫번째 격분한 아라쿠른 혈족")
HA.Lang.Menu.NovaWarn = KBM.Language:Add("5 second warning for "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaWarn:SetGerman("5 Sekunden bis "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaWarn:SetFrench("5 secondes avertissement pour Nova de flammes")
HA.Lang.Menu.NovaWarn:SetRussian("5 Секунд до "..HA.Lang.Ability.Nova[KBM.Lang])
HA.Lang.Menu.NovaWarn:SetKorean("화염 신성까지 5초전")

HA.Enraged = {
	Mod = HA,
	Level = "??",
	Name = HA.Lang.Unit.Enraged[KBM.Lang],
	NameShort = "Enraged Spawn",
	UTID = "U340ED24C23AF60CF",
	UnitList = {},
	Ignore = true,
	Type = "multi",
}

HA.Spawn = {
	Mod = HA,
	Level = "??",
	Name = HA.Lang.Unit.Spawn[KBM.Lang],
	NameShort = "Spawn",
	UTID = "U43B6C2A358051AD9",
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
end

function HA:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Arakhurn.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		MechTimer = KBM.Defaults.MechTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Arakhurn.Settings.AlertsRef,
		TimersRef = self.Arakhurn.Settings.TimersRef,
		MechRef = self.Arakhurn.Settings.Ignited,
	}
	KBMIROTPHA_Settings = self.Settings
	chKBMIROTPHA_Settings = self.Settings
	
end

function HA:SwapSettings(bool)
	if bool then
		KBMIROTPHA_Settings = self.Settings
		self.Settings = chKBMIROTPHA_Settings
	else
		chKBMROTPGS_Settings = self.Settings
		self.Settings = KBMIROTPHA_Settings
	end
end

function HA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMIROTPHA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMIROTPHA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMIROTPHA_Settings = self.Settings
	else
		KBMIROTPHA_Settings = self.Settings
	end	
end

function HA:SaveVars()	
	if KBM.Options.Character then
		chKBMIROTPHA_Settings = self.Settings
	else
		KBMIROTPHA_Settings = self.Settings
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
	HA.PhaseObj:SetPhase(HA.Lang.Phase.Adds[KBM.Lang])
	HA.PhaseObj.Objectives:AddDeath(HA.Lang.Unit.Spawn[KBM.Lang], 6)
	HA.Arakhurn.UnitID = nil
end

function HA.PhaseThree()
	if HA.Phase < 3 then
		HA.Phase = 3
		HA.TimeoutOverride = false
		HA.PhaseObj.Objectives:Remove()
		HA.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		HA.PhaseObj.Objectives:AddPercent(HA.Arakhurn, 0, 100)
		KBM.MechTimer:AddStart(HA.Arakhurn.TimersRef.AddFirst)
		KBM.MechTimer:AddStart(HA.Arakhurn.TimersRef.NovaPThree)
		KBM.MechTimer:AddStart(HA.Arakhurn.TimersRef.FieryPThree)
	end
end

function HA:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossOBj then
			if BossObj == self.Arakhurn then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Arakhurn.Dead = false
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
					if self.Arakhurn.UTID[2] == uDetails.type then
						self.PhaseObj:Start(self.StartTime)
						KBM.ValidTime = false
						self.PhaseThree()
					else
						self.Phase = 1
						self.PhaseObj:Start(self.StartTime)
						self.PhaseObj.Objectives:AddPercent(self.Arakhurn, 0, 100)
						self.PhaseObj:SetPhase(1)
						KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.NovaFirst)
						KBM.MechTimer:AddStart(self.Arakhurn.TimersRef.FieryFirst)
					end
					KBM.TankSwap:Start(self.Lang.Debuff.Armor[KBM.Lang], unitID)
				elseif self.Arakhurn.UnitID ~= unitID then
					self.Arakhurn.Casting = false
					self.Arakhurn.CastBar:Create(unitID)
					if KBM.TankSwap.Active then
						KBM.TankSwap:Remove()
						KBM.TankSwap:Start(self.Lang.Debuff.Armor[KBM.Lang], unitID)
					end
					if self.Arakhurn.UTID[2] == uDetails.type then
						self.PhaseThree()
					end
				end
				self.Arakhurn.UnitID = unitID
				self.Arakhurn.Available = true
				return BossObj
			else
				if BossObj.UnitList then
					if not BossObj.UnitList[unitID] then
						local SubBossObj = {
							Mod = HA,
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
						BossObj.UnitList[unitID].UnitID = UnitID
					end
					return BossObj.UnitList[unitID]
				end
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

function HA:DefineMenu()
	self.Menu = ROTP.Menu:CreateEncounter(self.Arakhurn, self.Enabled)
end

function HA:Start()
	-- Create Timers
	self.Arakhurn.TimersRef.NovaFirst = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 46)
	self.Arakhurn.TimersRef.NovaFirst.MenuName = self.Lang.Menu.NovaFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Nova = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 60)
	self.Arakhurn.TimersRef.NovaPThree = KBM.MechTimer:Add(self.Lang.Ability.Nova[KBM.Lang], 51)
	self.Arakhurn.TimersRef.NovaPThree.MenuName = self.Lang.Menu.NovaPThree[KBM.Lang]
	self.Arakhurn.TimersRef.FieryFirst = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 75)
	self.Arakhurn.TimersRef.FieryFirst.MenuName = self.Lang.Menu.FieryFirst[KBM.Lang]
	self.Arakhurn.TimersRef.Fiery = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 60)
	self.Arakhurn.TimersRef.FieryPThree = KBM.MechTimer:Add(self.Lang.Buff.Fiery[KBM.Lang], 81)
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
	
	-- Create Mechanic Spies
	self.Arakhurn.MechRef.Ignited = KBM.MechSpy:Add(self.Lang.Debuff.Ignited[KBM.Lang], nil, "playerDebuff", self.Arakhurn)
	self.Arakhurn.MechRef.Fiery = KBM.MechSpy:Add(self.Lang.Buff.Fiery[KBM.Lang], nil, "playerBuff", self.Arakhurn)
	KBM.Defaults.MechObj.Assign(self.Arakhurn)
	
	-- Assign Timers and Alerts to Triggers
	self.Arakhurn.Triggers.Stall = KBM.Trigger:Create(1, "percent", self.Arakhurn)
	self.Arakhurn.Triggers.Stall:AddPhase(self.Stall)
	self.Arakhurn.Triggers.Nova = KBM.Trigger:Create(self.Lang.Ability.Nova[KBM.Lang], "channel", self.Arakhurn)
	self.Arakhurn.Triggers.Nova:AddTimer(self.Arakhurn.TimersRef.Nova)
	self.Arakhurn.Triggers.Nova:AddAlert(self.Arakhurn.AlertsRef.Nova)
	self.Arakhurn.Triggers.Fiery = KBM.Trigger:Create(self.Lang.Buff.Fiery[KBM.Lang], "playerBuff", self.Arakhurn)
	self.Arakhurn.Triggers.Fiery:AddTimer(self.Arakhurn.TimersRef.Fiery)
	self.Arakhurn.Triggers.Fiery:AddAlert(self.Arakhurn.AlertsRef.Fiery, true)
	self.Arakhurn.Triggers.Fiery:AddSpy(self.Arakhurn.MechRef.Fiery)
	self.Arakhurn.Triggers.PhaseTwo = KBM.Trigger:Create(self.Lang.Chat.Death[KBM.Lang], "say", self.Arakhurn)
	self.Arakhurn.Triggers.PhaseTwo:AddTimer(self.Arakhurn.TimersRef.Rise)
	self.Arakhurn.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Arakhurn.Triggers.PhaseThree = KBM.Trigger:Create(self.Lang.Notify.Respawn[KBM.Lang], "notify", self.Arakhurn)
	self.Arakhurn.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Arakhurn.Triggers.Ignited = KBM.Trigger:Create(self.Lang.Debuff.Ignited[KBM.Lang], "playerDebuff", self.Arakhurn)
	self.Arakhurn.Triggers.Ignited:AddSpy(self.Arakhurn.MechRef.Ignited)
	self.Arakhurn.Triggers.IgnitedRemoved = KBM.Trigger:Create(self.Lang.Debuff.Ignited[KBM.Lang], "playerBuffRemove", self.Arakhurn)
	self.Arakhurn.Triggers.IgnitedRemoved:AddStop(self.Arakhurn.MechRef.Ignited)
	
	self.Arakhurn.CastBar = KBM.Castbar:Add(self, self.Arakhurn)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end