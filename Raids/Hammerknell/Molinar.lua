-- King Molinar Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KM_Settings = nil
chKM_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local HK = KBM.BossMod["Hammerknell"]

local KM = {
	Enabled = true,
	Instance = HK.Name,
	InstanceObj = HK,
	Directory = HK.Directory,
	File = "Molinar.lua",
	HasPhases = true,
	Phase = 1,
	TankSwap = false,
	Lang = {},
	Enrage = 60 * 10,
	HasChronicle = true,
	ID = "KingMolinar",
	Object = "KM",
}

KM.Prince = {
	Mod = KM,
	Level = "??",
	Active = false,
	Name = "Prince Dollin",
	NameShort = "Dollin",
	ChronicleID = "U618202936FFA60A2",
	UTID = "U6248E23D499F248B",
	CastBar = nil,
	CastFilters = {},
	Casting = false,
	HasCastFilters = true,
	TimersRef = {},
	AlertsRef = {},
	-- MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		Filters = {
			Enabled = true,
			Rend = KBM.Defaults.CastFilter.Create(),
			Feedback = KBM.Defaults.CastFilter.Create(),
			Essence = KBM.Defaults.CastFilter.Create(),
			Terminate = KBM.Defaults.CastFilter.Create(),
			Blast = KBM.Defaults.CastFilter.Create(),
			Crushing = KBM.Defaults.CastFilter.Create(),
		},
		TimersRef = {
			Enabled = true,
			Terminate = KBM.Defaults.TimerObj.Create("orange"),
			Crushing = KBM.Defaults.TimerObj.Create("purple"),
			Essence = KBM.Defaults.TimerObj.Create("yellow"),
			Feedback = KBM.Defaults.TimerObj.Create("cyan"),
		},
		AlertsRef = {
			Enabled = true,
			Terminate = KBM.Defaults.AlertObj.Create("orange"),
			Essence = KBM.Defaults.AlertObj.Create("yellow"),
			Feedback = KBM.Defaults.AlertObj.Create("blue"),
			FeedbackWarn = KBM.Defaults.AlertObj.Create("cyan"),
		},
		-- MechRef = {
			-- Enabled = true,
			-- Crushing = KBM.Defaults.MechObj.Create("cyan"),
			-- Rend = KBM.Defaults.MechObj.Create("dark_green"),
		-- }
	}
}
KM.King = {
	Mod = KM,
	Level = "??",
	Active = false,
	Name = "Rune King Molinar",
	NameShort = "Molinar",
	ChronicleID = "U4B987C125BF33A69",
	UTID = "U3E41C64554E0F83A",
	CastBar = nil,
	CastFilters = {},
	Casting = false,
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	-- MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		Filters = {
			Enabled = true,
			Shout = KBM.Defaults.CastFilter.Create(),
			Cursed = KBM.Defaults.CastFilter.Create(),
			Essence = KBM.Defaults.CastFilter.Create(),
			Feedback = KBM.Defaults.CastFilter.Create(),
		},
		TimersRef = {
			Enabled = true,
			Shout = KBM.Defaults.TimerObj.Create("purple"),
			Cursed = KBM.Defaults.TimerObj.Create("red"),
			Essence = KBM.Defaults.TimerObj.Create("yellow"),
			Feedback = KBM.Defaults.TimerObj.Create("blue"),
			Rev = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = {
			Enabled = true,
			Cursed = KBM.Defaults.AlertObj.Create("red"),
			CursedDuration = KBM.Defaults.AlertObj.Create("red"),
			Essence = KBM.Defaults.AlertObj.Create("yellow"),
			Feedback = KBM.Defaults.AlertObj.Create("blue"),
			FeedbackWarn = KBM.Defaults.AlertObj.Create("cyan"),
			Shout = KBM.Defaults.AlertObj.Create("purple"),
		},
		-- MechRef = {
			-- Enabled = true,
			-- Cursed = KBM.Defaults.MechObj.Create("red"),
			-- CursedDuration = KBM.Defaults.MechObj.Create("blue"),
		-- }
	},
}
KBM.RegisterMod(KM.ID, KM)

-- Main Unit List
KM.Lang.Unit = {}
KM.Lang.Unit.Molinar = KBM.Language:Add(KM.King.Name)
KM.Lang.Unit.Molinar:SetGerman("Runenkönig Molinar")
KM.Lang.Unit.Molinar:SetFrench("Roi runique Molinar")
KM.Lang.Unit.Molinar:SetRussian("Рунный король Молинар")
KM.Lang.Unit.Molinar:SetKorean("룬 제왕 몰리나")
KM.Lang.Unit.MolinarShort = KBM.Language:Add("Molinar")
KM.Lang.Unit.MolinarShort:SetGerman("Molinar")
KM.Lang.Unit.MolinarShort:SetFrench("Molinar")
KM.Lang.Unit.MolinarShort:SetRussian("Король")
KM.Lang.Unit.MolinarShort:SetKorean("몰리나")
KM.Lang.Unit.Dollin = KBM.Language:Add(KM.Prince.Name)
KM.Lang.Unit.Dollin:SetGerman("Prinz Dollin")
KM.Lang.Unit.Dollin:SetFrench("Prince Dollin")
KM.Lang.Unit.Dollin:SetRussian("Принц Доллин")
KM.Lang.Unit.Dollin:SetKorean("돌린 왕자")
KM.Lang.Unit.DollinShort = KBM.Language:Add("Dollin")
KM.Lang.Unit.DollinShort:SetGerman("Dollin")
KM.Lang.Unit.DollinShort:SetFrench("Dollin")
KM.Lang.Unit.DollinShort:SetRussian("Принц")
KM.Lang.Unit.DollinShort:SetKorean("돌린")
-- Additional Units Dictionary
KM.Lang.Unit.Revenant = KBM.Language:Add("Incorporeal Revenant")
KM.Lang.Unit.Revenant:SetFrench("Revenant chimérique")
KM.Lang.Unit.Revenant:SetGerman("Unkörperlicher Wiedergänger")
KM.Lang.Unit.Revenant:SetRussian("Бестелесный восставший")
KM.Lang.Unit.Revenant:SetKorean("형태없는 망령")

-- Ability Dictionary
KM.Lang.Ability = {}
KM.Lang.Ability.Rend = KBM.Language:Add("Rend Life")
KM.Lang.Ability.Rend:SetFrench("Déchire-Vie")
KM.Lang.Ability.Rend:SetGerman("Leben entreißen")
KM.Lang.Ability.Rend:SetRussian("Расколотая жизнь")
KM.Lang.Ability.Rend:SetKorean("생명 분쇄")
KM.Lang.Ability.Terminate = KBM.Language:Add("Terminate Life")
KM.Lang.Ability.Terminate:SetFrench("Achèvement de Vie")
KM.Lang.Ability.Terminate:SetGerman("Leben auslöschen")
KM.Lang.Ability.Terminate:SetRussian("Прервать жизнь")
KM.Lang.Ability.Terminate:SetKorean("생명 박탈")
KM.Lang.Ability.Essence = KBM.Language:Add("Consuming Essence")
KM.Lang.Ability.Essence:SetFrench("Combustion d'essence")
KM.Lang.Ability.Essence:SetGerman("Verschlingende Essenz")
KM.Lang.Ability.Essence:SetRussian("Поглощающая сущность")
KM.Lang.Ability.Essence:SetKorean("정수 흡수")
KM.Lang.Ability.Feedback = KBM.Language:Add("Runic Feedback")
KM.Lang.Ability.Feedback:SetFrench("Réaction runique")
KM.Lang.Ability.Feedback:SetGerman("Runen-Resonanz")
KM.Lang.Ability.Feedback:SetRussian("Рунический отзыв")
KM.Lang.Ability.Feedback:SetKorean("주문술 반응")
KM.Lang.Ability.Crushing = KBM.Language:Add("Crushing Regret")
KM.Lang.Ability.Crushing:SetGerman("Erdrückendes Bedauern")
KM.Lang.Ability.Crushing:SetFrench("Blasphème infect")
KM.Lang.Ability.Crushing:SetRussian("Давящее сожаление")
KM.Lang.Ability.Crushing:SetKorean("Crushing Regret")
KM.Lang.Ability.Forked = KBM.Language:Add("Forked Blast")
KM.Lang.Ability.Forked:SetGerman("Gabelstoß")
KM.Lang.Ability.Forked:SetFrench("Explosion fourchue")
KM.Lang.Ability.Forked:SetRussian("Раздвоенный взрыв")
KM.Lang.Ability.Forked:SetKorean("갈래 폭발")
KM.Lang.Ability.Shout = KBM.Language:Add("Frightening Shout")
KM.Lang.Ability.Shout:SetFrench("Flammes maudites")
KM.Lang.Ability.Shout:SetGerman("Verängstigender Schrei")
KM.Lang.Ability.Shout:SetRussian("Пугающий крик")
KM.Lang.Ability.Shout:SetKorean("위협의 외침")
KM.Lang.Ability.Cursed = KBM.Language:Add("Cursed Blows")
KM.Lang.Ability.Cursed:SetFrench("Frappes maudites")
KM.Lang.Ability.Cursed:SetGerman("Verfluchte Schläge")
KM.Lang.Ability.Cursed:SetRussian("Проклятые удары")
KM.Lang.Ability.Cursed:SetKorean("저주받은 강타")

-- Notify Dictionary
KM.Lang.Notify = {}
KM.Lang.Notify.Rev = KBM.Language:Add("Incorporeal Revenant begins to phase into this reality.")
KM.Lang.Notify.Rev:SetFrench("Revenant chimérique commence à se matérialiser dans cette réalité.")
KM.Lang.Notify.Rev:SetGerman("Unkörperlicher Wiedergänger beginnt, in diese Realität zu gleiten.")
KM.Lang.Notify.Rev:SetRussian("Бестелесный восставший начинает переноситься в эту реальность.")

-- Menu Dictionary
KM.Lang.Menu = {}
KM.Lang.Menu.Cursed = KBM.Language:Add(KM.Lang.Ability.Cursed[KBM.Lang].." duration.")
KM.Lang.Menu.Cursed:SetGerman(KM.Lang.Ability.Cursed[KBM.Lang].." Dauer.")
KM.Lang.Menu.Cursed:SetRussian(KM.Lang.Ability.Cursed[KBM.Lang].." длительность.")
KM.Lang.Menu.Cursed:SetFrench(KM.Lang.Ability.Cursed[KBM.Lang].." durée.")
KM.Lang.Menu.Cursed:SetKorean("저주받은 강타 지속시간.")
KM.Lang.Menu.Feedback = KBM.Language:Add(KM.Lang.Ability.Feedback[KBM.Lang].." duration.")
KM.Lang.Menu.Feedback:SetGerman(KM.Lang.Ability.Feedback[KBM.Lang].." Dauer.")
KM.Lang.Menu.Feedback:SetRussian(KM.Lang.Ability.Feedback[KBM.Lang].." длительность.")
KM.Lang.Menu.Feedback:SetFrench(KM.Lang.Ability.Feedback[KBM.Lang].." durée.")
KM.Lang.Menu.Feedback:SetKorean("룬 반응 지속시간.")

-- King's Options page Dictionary
KM.Lang.Options = {}
KM.Lang.Options.Enabled = KBM.Language:Add("Enable Percentage Monitor.")
KM.Lang.Options.Enabled:SetFrench("Montrer Moniteur Pct.")
KM.Lang.Options.Enabled:SetGerman("Prozent Monitor anzeigen.")
KM.Lang.Options.Enabled:SetRussian("Включить монитор хп боссов в процентах.")
KM.Lang.Options.Enabled:SetKorean("퍼센트 보니터링 활성.")
KM.Lang.Options.Visible = KBM.Language:Add("Show Monitor (for positioning).")
KM.Lang.Options.Visible:SetFrench("Cacher avant début du combat.")
KM.Lang.Options.Visible:SetGerman("Verbergen bis zum Kampfbeginn.")
KM.Lang.Options.Visible:SetRussian("Показать монитор (для смены позици).")
KM.Lang.Options.Visible:SetKorean("모니터링 보기 (위치선정용).")
KM.Lang.Options.Compact = KBM.Language:Add("Compact Mode.")
KM.Lang.Options.Compact:SetFrench("Mode Compact.")
KM.Lang.Options.Compact:SetGerman("Kompakte Anzeige.")
KM.Lang.Options.Compact:SetRussian("Сделать компактным.")
KM.Lang.Options.Compact:SetKorean("미니 모드.")

-- Verbose Dictionary
KM.Lang.Verbose = {}
KM.Lang.Verbose.King = KBM.Language:Add("King")
KM.Lang.Verbose.King:SetRussian("Король")
KM.Lang.Verbose.King:SetFrench("Roi")
KM.Lang.Verbose.King:SetGerman("König")
KM.Lang.Verbose.King:SetKorean("왕")
KM.Lang.Verbose.Prince = KBM.Language:Add("Prince")
KM.Lang.Verbose.Prince:SetGerman("Prinz")
KM.Lang.Verbose.Prince:SetFrench("Prince")
KM.Lang.Verbose.Prince:SetRussian("Принц")
KM.Lang.Verbose.Prince:SetKorean("왕자")

-- Assign Translations to Units
KM.King.Name = KM.Lang.Unit.Molinar[KBM.Lang]
KM.King.NameShort = KM.Lang.Unit.MolinarShort[KBM.Lang]
KM.Prince.Name = KM.Lang.Unit.Dollin[KBM.Lang]
KM.Prince.NameShort = KM.Lang.Unit.DollinShort[KBM.Lang]

KM.Descript = KM.King.Name.." & "..KM.Prince.Name

function KM:AddBosses(KBM_Boss)

	self.MenuName = self.King.Name
	self.Bosses = {
		[self.King.Name] = self.King,
		[self.Prince.Name] = self.Prince,
	}	
end

function KM:InitVars()

	self.Settings = {
		Enabled = true,
		Chronicle = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		-- MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = {
			Multi = true,
			Override = true,
		},
		King = {
			CastBar = KM.King.Settings.CastBar,
			CastFilters = KM.King.Settings.Filters,
			TimersRef = KM.King.Settings.TimersRef,
			AlertsRef = KM.King.Settings.AlertsRef,
			-- MechRef = KM.King.Settings.MechRef,
		},
		Prince = {
			CastBar = KM.Prince.Settings.CastBar,
			CastFilters = KM.Prince.Settings.Filters,
			TimersRef = KM.Prince.Settings.TimersRef,
			AlertsRef = KM.Prince.Settings.AlertsRef,
			-- MechRef = KM.Prince.Settings.MechRef,
		},
	}
	KM_Settings = self.Settings
	chKM_Settings = self.Settings
	
end

function KM:SwapSettings(bool)
	if bool then
		KM_Settings = self.Settings
		self.Settings = chKM_Settings
	else
		chKM_Settings = self.Settings
		self.Settings = KM_Settings
	end
end

function KM:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKM_Settings, KM.Settings)
	else
		KBM.LoadTable(KM_Settings, KM.Settings)
	end
	
	if KBM.Options.Character then
		chKM_Settings = KM.Settings
	else
		KM_Settings = KM.Settings
	end

	self.King.Settings.CastBar.Override = true
	self.King.Settings.CastBar.Multi = true
	self.King.Settings.CastBar.Pinned = false
	self.Prince.Settings.CastBar.Override = true
	self.Prince.Settings.CastBar.Multi = true
	self.Prince.Settings.CastBar.Pinned = false
	
	self.King.Settings.AlertsRef.Feedback.Enabled = true
	self.Prince.Settings.AlertsRef.Feedback.Enabled = true
	
	KM.Prince.CastFilters[KM.Lang.Ability.Rend[KBM.Lang]] = {ID = "Rend"}
	KM.Prince.CastFilters[KM.Lang.Ability.Terminate[KBM.Lang]] = {ID = "Terminate"}
	KM.Prince.CastFilters[KM.Lang.Ability.Essence[KBM.Lang]] = {ID = "Essence"}
	KM.Prince.CastFilters[KM.Lang.Ability.Feedback[KBM.Lang]] = {ID = "Feedback"}
	KM.Prince.CastFilters[KM.Lang.Ability.Crushing[KBM.Lang]] = {ID = "Crushing"}
	KM.Prince.CastFilters[KM.Lang.Ability.Forked[KBM.Lang]] = {ID = "Blast"}
	KM.King.CastFilters[KM.Lang.Ability.Shout[KBM.Lang]] = {ID = "Shout"}
	KM.King.CastFilters[KM.Lang.Ability.Cursed[KBM.Lang]] = {ID = "Cursed"}
	KM.King.CastFilters[KM.Lang.Ability.Essence[KBM.Lang]] = {ID = "Essence"}
	KM.King.CastFilters[KM.Lang.Ability.Feedback[KBM.Lang]] = {ID = "Feedback"}
	
	KBM.Defaults.CastFilter.Assign(self.King)
	KBM.Defaults.CastFilter.Assign(self.Prince)	
end

function KM:SaveVars()	
	if KBM.Options.Character then
		chKM_Settings = self.Settings
	else
		KM_Settings = self.Settings
	end	
end

function KM:RemoveUnits(UnitID)
	if self.King.UnitID == UnitID then
		self.King.Available = false
	elseif self.Prince.UnitID == UnitID then
		self.Prince.Available = false
	end
	if not self.Prince.Available and not self.King.Available then
		return true
	end
	return false	
end

function KM:Death(UnitID)
	if self.King.UnitID == UnitID then
		self.King.Dead = true
	elseif self.Prince.UnitID == UnitID then
		self.Prince.Dead = true
	end
	if self.King.Dead and self.Prince.Dead then
		return true
	end
	return false	
end

function KM:UnitHPCheck(uDetails, unitID)
	if uDetails and unitID then
		if uDetails.player == nil then
			if uDetails.name == self.King.Name then
				if not self.King.UnitID then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.PhaseObj:Start(self.StartTime)
						self.Phase = 1
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.King, 90, 100)
						self.PhaseObj.Objectives:AddPercent(self.Prince, 90, 100)
						self.King.Dead = false
					end
					self.King.Casting = false
					self.King.CastBar:Create(unitID)
				end
				self.King.UnitID = unitID
				self.King.Available = true
				return self.King
			elseif uDetails.name == self.Prince.Name then
				if not self.Prince.UnitID then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.PhaseObj:Start(self.StartTime)
						self.Phase = 1
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.King, 90, 100)
						self.PhaseObj.Objectives:AddPercent(self.Prince, 90, 100)
						self.Prince.Dead = false
					end
					self.Prince.Casting = false
					self.Prince.CastBar:Create(unitID)
				end
				self.Prince.UnitID = unitID
				self.Prince.Available = true
				return self.Prince
			end
		end
	end
end

function KM:Reset()
	self.EncounterRunning = false
	self.Prince.UnitID = nil
	self.King.UnitID = nil
	self.King.CastBar:Remove()
	self.King.Dead = false
	self.King.Available = false
	self.Prince.CastBar:Remove()
	self.Prince.Dead = false
	self.Prince.Available = false
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())
end

function KM.PhaseTwo()
	if KM.Phase < 2 then
		KM.PhaseObj.Objectives:Remove()
		KM.Phase = 2
		KM.PhaseObj:SetPhase(2)
		KM.PhaseObj.Objectives:AddPercent(KM.King, 65, 90)
		KM.PhaseObj.Objectives:AddPercent(KM.Prince, 65, 90)
	end
end

function KM.PhaseThree()
	if KM.Phase < 3 then
		KM.PhaseObj.Objectives:Remove()
		KM.Phase = 3
		KM.PhaseObj:SetPhase(3)
		KM.PhaseObj.Objectives:AddPercent(KM.King, 40, 65)
		KM.PhaseObj.Objectives:AddPercent(KM.Prince, 40, 65)
	end	
end

function KM.PhaseFour()
	if KM.Phase < 4 then
		KM.PhaseObj.Objectives:Remove()
		KM.Phase = 4
		KM.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		KM.PhaseObj.Objectives:AddPercent(KM.King, 0, 40)
		KM.PhaseObj.Objectives:AddPercent(KM.Prince, 0, 40)
	end
end

function KM:Timer(current, diff)
end

function KM:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.King, self.Enabled)
end

function KM:Start()

	self.FBDefX = self.Settings.LocX
	self.FBDefY = self.Settings.LocY
		
	-- Add King's Timers
	self.King.TimersRef.Cursed = KBM.MechTimer:Add(KM.Lang.Ability.Cursed[KBM.Lang], 55)
	self.King.TimersRef.Essence = KBM.MechTimer:Add("("..KM.Lang.Verbose.King[KBM.Lang]..") "..KM.Lang.Ability.Essence[KBM.Lang], 20)
	self.King.TimersRef.Rev = KBM.MechTimer:Add(self.Lang.Unit.Revenant[KBM.Lang], 82)
	self.King.TimersRef.Shout = KBM.MechTimer:Add(KM.Lang.Ability.Shout[KBM.Lang], 30)
	self.King.TimersRef.Feedback = KBM.MechTimer:Add(KM.Lang.Ability.Feedback[KBM.Lang], 48)
	KBM.Defaults.TimerObj.Assign(self.King)
	
	-- Add King's MechSpy
	-- self.King.MechRef.Cursed = KBM.MechSpy:Add(KM.Lang.Ability.Cursed[KBM.Lang], 10, "cast", self.King)
	-- self.King.MechRef.CursedDuration = KBM.MechSpy:Add(KM.Lang.Ability.Cursed[KBM.Lang], 10, "channel", self.King)
	-- self.King.MechRef.CursedDuration:NoMenu()
	-- self.King.MechRef.Cursed:SpyAfter(self.King.MechRef.CursedDuration)
	-- KBM.Defaults.MechObj.Assign(self.King)
	
	-- Add King's Alerts
	self.King.AlertsRef.Cursed = KBM.Alert:Create(KM.Lang.Ability.Cursed[KBM.Lang], nil, false, true, "red")
	self.King.AlertsRef.CursedDuration = KBM.Alert:Create(KM.Lang.Ability.Cursed[KBM.Lang], nil, true, true, "red")
	self.King.AlertsRef.CursedDuration.MenuName = KM.Lang.Menu.Cursed[KBM.Lang]
	self.King.AlertsRef.Essence = KBM.Alert:Create(KM.Lang.Ability.Essence[KBM.Lang], nil, false, true, "yellow")
	self.King.AlertsRef.Essence:Important()
	self.King.AlertsRef.FeedbackWarn = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], nil, false, "blue")
	self.King.AlertsRef.Feedback = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], nil, true, true, "blue")
	self.King.AlertsRef.Feedback.MenuName = self.Lang.Menu.Feedback[KBM.Lang]
	self.King.AlertsRef.Shout = KBM.Alert:Create(KM.Lang.Ability.Shout[KBM.Lang], nil, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.King)
	
	-- Assign King's Mechanics to Triggers
	self.King.Triggers.Cursed = KBM.Trigger:Create(KM.Lang.Ability.Cursed[KBM.Lang], "cast", self.King)
	self.King.Triggers.Cursed:AddTimer(self.King.TimersRef.Cursed)
	self.King.Triggers.Cursed:AddAlert(self.King.AlertsRef.Cursed)
	self.King.Triggers.CursedDuration = KBM.Trigger:Create(KM.Lang.Ability.Cursed[KBM.Lang], "channel", self.King)
	self.King.Triggers.CursedDuration:AddAlert(self.King.AlertsRef.CursedDuration)
	self.King.Triggers.Shout = KBM.Trigger:Create(KM.Lang.Ability.Shout[KBM.Lang], "cast", self.King)
	self.King.Triggers.Shout:AddTimer(self.King.TimersRef.Shout)
	self.King.Triggers.Shout:AddAlert(self.King.AlertsRef.Shout)
	-- self.King.Triggers.ShoutBuff = KBM.Trigger:Create(KM.Lang.Ability.Shout[KBM.Lang], "playerBuff", self.King)
	-- self.King.Triggers.ShoutBuff:AddSpy(self.King.MechRef.Shout)
	-- self.King.Triggers.ShoutRemove = KBM.Trigger:Create(KM.Lang.Ability.Shout[KBM.Lang], "playerBuffRemove", self.King)
	-- self.King.Triggers.ShoutRemove:AddStop(self.King.MechRef.Shout)
	self.King.Triggers.Essence = KBM.Trigger:Create(KM.Lang.Ability.Essence[KBM.Lang], "cast", self.King)
	self.King.Triggers.Essence:AddTimer(self.King.TimersRef.Essence)
	self.King.Triggers.Essence:AddAlert(self.King.AlertsRef.Essence)
	self.King.Triggers.EssenceInt = KBM.Trigger:Create(KM.Lang.Ability.Essence[KBM.Lang], "interrupt", self.King)
	self.King.Triggers.EssenceInt:AddStop(self.King.AlertsRef.Essence)
	self.King.Triggers.FeedbackWarn = KBM.Trigger:Create(KM.Lang.Ability.Feedback[KBM.Lang], "cast", self.King)
	self.King.Triggers.FeedbackWarn:AddTimer(self.King.TimersRef.Feedback)
	self.King.Triggers.FeedbackWarn:AddAlert(self.King.AlertsRef.FeedbackWarn)
	self.King.Triggers.Feedback = KBM.Trigger:Create(KM.Lang.Ability.Feedback[KBM.Lang], "channel", self.King)
	self.King.Triggers.Feedback:AddAlert(self.King.AlertsRef.Feedback)
	self.King.Triggers.Rev = KBM.Trigger:Create(self.Lang.Notify.Rev[KBM.Lang], "notify", self.King)
	self.King.Triggers.Rev:AddTimer(self.King.TimersRef.Rev)
	self.King.Triggers.PhaseTwo = KBM.Trigger:Create(90, "percent", self.King)
	self.King.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.King.Triggers.PhaseThree = KBM.Trigger:Create(65, "percent", self.King)
	self.King.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.King.Triggers.PhaseFour = KBM.Trigger:Create(40, "percent", self.King)
	self.King.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	-- Add Prince's Timers
	self.Prince.TimersRef.Terminate = KBM.MechTimer:Add(KM.Lang.Ability.Terminate[KBM.Lang], 21)
	self.Prince.TimersRef.Essence = KBM.MechTimer:Add("("..KM.Lang.Verbose.Prince[KBM.Lang]..") "..KM.Lang.Ability.Essence[KBM.Lang], 22)
	self.Prince.TimersRef.Feedback = KBM.MechTimer:Add(KM.Lang.Ability.Feedback[KBM.Lang], 48)
	KBM.Defaults.TimerObj.Assign(self.Prince)
	
	-- Add Prince's Alerts
	self.Prince.AlertsRef.Terminate = KBM.Alert:Create(KM.Lang.Ability.Terminate[KBM.Lang], nil, true, nil, "orange")
	self.Prince.AlertsRef.Essence = KBM.Alert:Create(KM.Lang.Ability.Essence[KBM.Lang], nil, false, true, "yellow")
	self.Prince.AlertsRef.Essence:Important()
	self.Prince.AlertsRef.FeedbackWarn = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], nil, false, true, "blue")
	self.Prince.AlertsRef.Feedback = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], nil, true, true, "blue")
	self.Prince.AlertsRef.Feedback.MenuName = self.Lang.Menu.Feedback[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Prince)

	-- Add Prince's MechSpy
	-- self.Prince.MechRef.Crushing = KBM.MechSpy:Add(KM.Lang.Ability.Crushing[KBM.Lang], nil, "playerBuff", self.Prince)
	-- self.Prince.MechRef.Rend = KBM.MechSpy:Add(KM.Lang.Ability.Rend[KBM.Lang], 5, "cast", self.Prince)
	-- KBM.Defaults.MechObj.Assign(self.Prince)
	
	-- Assign Prince's Mechanics to Triggers
	self.Prince.Triggers.Terminate = KBM.Trigger:Create(KM.Lang.Ability.Terminate[KBM.Lang], "cast", self.Prince)
	self.Prince.Triggers.Terminate:AddTimer(self.Prince.TimersRef.Terminate)
	self.Prince.Triggers.Terminate:AddAlert(self.Prince.AlertsRef.Terminate)
	-- self.Prince.Triggers.Rend = KBM.Trigger:Create(KM.Lang.Ability.Rend[KBM.Lang], "cast", self.Prince)
	-- self.Prince.Triggers.Rend:AddSpy(self.Prince.MechRef.Rend)
	-- self.Prince.Triggers.Crushing = KBM.Trigger:Create(KM.Lang.Ability.Crushing[KBM.Lang], "playerBuff", self.Prince)
	-- self.Prince.Triggers.Crushing:AddSpy(self.Prince.MechRef.Crushing)
	-- self.Prince.Triggers.CrushingRemove = KBM.Trigger:Create(KM.Lang.Ability.Crushing[KBM.Lang], "playerBuffRemove", self.Prince)
	-- self.Prince.Triggers.CrushingRemove:AddStop(self.Prince.MechRef.Crushing)
	self.Prince.Triggers.Essence = KBM.Trigger:Create(KM.Lang.Ability.Essence[KBM.Lang], "cast", self.Prince)
	self.Prince.Triggers.Essence:AddTimer(self.Prince.TimersRef.Essence)
	self.Prince.Triggers.Essence:AddAlert(self.Prince.AlertsRef.Essence)
	self.Prince.Triggers.EssenceInt = KBM.Trigger:Create(KM.Lang.Ability.Essence[KBM.Lang], "interrupt", self.Prince)
	self.Prince.Triggers.EssenceInt:AddStop(self.Prince.AlertsRef.Essence)
	self.Prince.Triggers.FeedbackWarn = KBM.Trigger:Create(KM.Lang.Ability.Feedback[KBM.Lang], "cast", self.Prince)
	self.Prince.Triggers.FeedbackWarn:AddTimer(self.Prince.TimersRef.Feedback)
	self.Prince.Triggers.FeedbackWarn:AddAlert(self.Prince.AlertsRef.FeedbackWarn)
	self.Prince.Triggers.Feedback = KBM.Trigger:Create(KM.Lang.Ability.Feedback[KBM.Lang], "channel", self.Prince)
	self.Prince.Triggers.Feedback:AddAlert(self.Prince.AlertsRef.Feedback)
	self.Prince.Triggers.PhaseTwo = KBM.Trigger:Create(90, "percent", self.Prince)
	self.Prince.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Prince.Triggers.PhaseThree = KBM.Trigger:Create(65, "percent", self.Prince)
	self.Prince.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Prince.Triggers.PhaseFour = KBM.Trigger:Create(40, "percent", self.Prince)
	self.Prince.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	self.King.CastBar = KBM.Castbar:Add(self, self.King)
	self.Prince.CastBar = KBM.Castbar:Add(self, self.Prince)
	
	self.PercentageMon = KBM.PercentageMon:Create(self.King, self.Prince, 7)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end
