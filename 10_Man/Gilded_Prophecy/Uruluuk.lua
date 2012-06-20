-- Uruluuk Boss Mod for King Boss Mods
-- Written by Paul Snart
-- CopyriUKt 2011
--

KBMGPUK_Settings = nil
chKBMGPUK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Gilded Prophecy"]

local UK = {
	Directory = GP.Directory,
	File = "Uruluuk.lua",
	Enabled = true,
	Instance = GP.Name,
	Lang = {},
	ID = "Uruluuk",
	Object = "UK",
}

UK.Uruluuk = {
	Mod = UK,
	Level = "??",
	Active = false,
	Name = "Uruluuk",
	NameShort = "Uruluuk",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Fist = KBM.Defaults.AlertObj.Create("yellow"),
			Storm = KBM.Defaults.AlertObj.Create("red"),
			Crystal = KBM.Defaults.AlertObj.Create("cyan"),	
		},
		MechRef = {
			Enabled = true,
			Crystal = KBM.Defaults.MechObj.Create("cyan"),
		},
	},
}

KBM.RegisterMod(UK.ID, UK)

-- Main Unit Dictionary
UK.Lang.Unit = {}
UK.Lang.Unit.Uruluuk = KBM.Language:Add(UK.Uruluuk.Name)
UK.Lang.Unit.Uruluuk:SetGerman()
UK.Lang.Unit.Uruluuk:SetFrench()
UK.Lang.Unit.Uruluuk:SetRussian("Улуруук")
UK.Lang.Unit.Uruluuk:SetKorean("우룰루크")
UK.Uruluuk.Name = UK.Lang.Unit.Uruluuk[KBM.Lang]

-- Ability Dictionary
UK.Lang.Ability = {}
UK.Lang.Ability.Fist = KBM.Language:Add("Fist of Laethys")
UK.Lang.Ability.Fist:SetGerman("Faust von Laethys")
UK.Lang.Ability.Fist:SetFrench("Poing de Laethys")
UK.Lang.Ability.Fist:SetRussian("Кулак Лэтис")
UK.Lang.Ability.Fist:SetKorean("레시스의 주먹")
UK.Lang.Ability.Storm = KBM.Language:Add("Storm of Force")
UK.Lang.Ability.Storm:SetGerman("Sturm der Stärke")
UK.Lang.Ability.Storm:SetFrench("Tempête de Force")
UK.Lang.Ability.Storm:SetRussian("Буря силы")
UK.Lang.Ability.Storm:SetKorean("힘의 폭풍")
UK.Lang.Ability.Crystal = KBM.Language:Add("Crystal Imprisonment")
UK.Lang.Ability.Crystal:SetGerman("Kristallgefängnis")
UK.Lang.Ability.Crystal:SetFrench("Prison de cristal")
UK.Lang.Ability.Crystal:SetRussian("Заключение в кристалл")
UK.Lang.Ability.Crystal:SetKorean("수정 감금")

-- Verbose Dictionary
UK.Lang.Verbose = {}
UK.Lang.Verbose.Crystal = KBM.Language:Add("Crystal on YOU soon!")
UK.Lang.Verbose.Crystal:SetGerman("Achtung, du wirst zum Kristall")
UK.Lang.Verbose.Crystal:SetFrench("Emprisonnement de cristal sur vous bientôt!")
UK.Lang.Verbose.Crystal:SetRussian("Вы скоро превратитесь в кристалл!")
UK.Lang.Verbose.Crystal:SetKorean("당신에게 크리스탈!")

-- Notify Dictionary
UK.Lang.Notify = {}
UK.Lang.Notify.Crystal = KBM.Language:Add("Uruluuk points at (%a*)!")
UK.Lang.Notify.Crystal:SetGerman("Uruluuk zeigt auf (%a*)!")
UK.Lang.Notify.Crystal:SetFrench("Uruluuk montre (%a*) du doigt !")
UK.Lang.Notify.Crystal:SetRussian("Улуруук указывает туда, где стоит (%a*)!")
UK.Lang.Notify.Crystal:SetKorean("우룰루크가 (%a*)를 가리킵니다!")

UK.Descript = UK.Uruluuk.Name

function UK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Uruluuk.Name] = self.Uruluuk,
	}
	KBM_Boss[self.Uruluuk.Name] = self.Uruluuk	
end

function UK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Uruluuk.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		AlertsRef = self.Uruluuk.Settings.AlertsRef,
		MechRef = self.Uruluuk.Settings.MechRef,
	}
	KBMGPUK_Settings = self.Settings
	chKBMGPUK_Settings = self.Settings
end

function UK:SwapSettings(bool)

	if bool then
		KBMGPUK_Settings = self.Settings
		self.Settings = chKBMGPUK_Settings
	else
		chKBMGPUK_Settings = self.Settings
		self.Settings = KBMGPUK_Settings
	end

end

function UK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPUK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPUK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPUK_Settings = self.Settings
	else
		KBMGPUK_Settings = self.Settings
	end	
end

function UK:SaveVars()	
	if KBM.Options.Character then
		chKBMGPUK_Settings = self.Settings
	else
		KBMGPUK_Settings = self.Settings
	end	
end

function UK:Castbar(units)
end

function UK:RemoveUnits(UnitID)
	if self.Uruluuk.UnitID == UnitID then
		self.Uruluuk.Available = false
		return true
	end
	return false
end

function UK:Death(UnitID)
	if self.Uruluuk.UnitID == UnitID then
		self.Uruluuk.Dead = true
		return true
	end
	return false
end

function UK.PhaseFinal()
	UK.PhaseObj.Objectives:Remove()
	UK.Phase = 4
	UK.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	UK.PhaseObj.Objectives:AddPercent(UK.Uruluuk.Name, 0, 30)
end

function UK:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Uruluuk.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Uruluuk.Dead = false
					self.Uruluuk.Casting = false
					self.Uruluuk.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Uruluuk.Name, 30, 100)
					self.PhaseObj:SetPhase(1)
				end
				self.Uruluuk.UnitID = unitID
				self.Uruluuk.Available = true
				return self.Uruluuk
			end
		end
	end
end

function UK:Reset()
	self.EncounterRunning = false
	self.Uruluuk.Available = false
	self.Uruluuk.UnitID = nil
	self.Uruluuk.Dead = false
	self.Uruluuk.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function UK:Timer()
	
end

function UK.Uruluuk:SetTimers(bool)	
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

function UK.Uruluuk:SetAlerts(bool)
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

function UK:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Uruluuk, self.Enabled)
end

function UK:Start()
	-- Create Timers
	
	-- Create Mechanic Spies
	self.Uruluuk.MechRef.Crystal = KBM.MechSpy:Add(self.Lang.Verbose.Crystal[KBM.Lang], 3, "playerEmote", self.Uruluuk)
	KBM.Defaults.MechObj.Assign(self.Uruluuk)
	
	-- Create Alerts
	self.Uruluuk.AlertsRef.Fist = KBM.Alert:Create(self.Lang.Ability.Fist[KBM.Lang], nil, false, true, "yellow")
	self.Uruluuk.AlertsRef.Storm = KBM.Alert:Create(self.Lang.Ability.Storm[KBM.Lang], nil, true, true, "red")
	self.Uruluuk.AlertsRef.Crystal = KBM.Alert:Create(self.Lang.Verbose.Crystal[KBM.Lang], 3, true, false, "blue")
	KBM.Defaults.AlertObj.Assign(self.Uruluuk)
	
	-- Assign Timers and Alerts to Triggers
	self.Uruluuk.Triggers.Fist = KBM.Trigger:Create(self.Lang.Ability.Fist[KBM.Lang], "cast", self.Uruluuk)
	self.Uruluuk.Triggers.Fist:AddAlert(self.Uruluuk.AlertsRef.Fist)
	self.Uruluuk.Triggers.PhaseFinal = KBM.Trigger:Create(30, "percent", self.Uruluuk)
	self.Uruluuk.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)
	self.Uruluuk.Triggers.Storm = KBM.Trigger:Create(self.Lang.Ability.Storm[KBM.Lang], "cast", self.Uruluuk)
	self.Uruluuk.Triggers.Storm:AddAlert(self.Uruluuk.AlertsRef.Storm)
	self.Uruluuk.Triggers.Crystal = KBM.Trigger:Create(self.Lang.Notify.Crystal[KBM.Lang], "notify", self.Uruluuk)
	self.Uruluuk.Triggers.Crystal:AddAlert(self.Uruluuk.AlertsRef.Crystal, true)
	self.Uruluuk.Triggers.Crystal:AddSpy(self.Uruluuk.MechRef.Crystal)
	
	self.Uruluuk.CastBar = KBM.CastBar:Add(self, self.Uruluuk)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end