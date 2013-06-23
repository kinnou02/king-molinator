-- Joloral Ragetide Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMDHRT_Settings = nil
chKBMDHRT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local DH = KBM.BossMod["Drowned Halls"]

local JR = {
	Directory = DH.Directory,
	File = "Joloral.lua",
	Enabled = true,
	Instance = DH.Name,
	InstanceObj = DH,
	Lang = {},
	ID = "Joloral",
	Object = "JR",
}

JR.Joloral = {
	Mod = JR,
	Level = "??",
	Active = false,
	Name = "Joloral Ragetide",
	NameShort = "Joloral",
	Menu = {},
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UTID = "U4EEBB06F655086B5",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		AlertsRef = {
			Enabled = true,
			Panic = KBM.Defaults.AlertObj.Create("purple"),
			PanicDuration = KBM.Defaults.AlertObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			Panic = KBM.Defaults.TimerObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Panic = KBM.Defaults.TimerObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(JR.ID, JR)

-- Unit Dictionary
JR.Lang.Unit = {}
JR.Lang.Unit.Joloral = KBM.Language:Add(JR.Joloral.Name)
JR.Lang.Unit.Joloral:SetGerman("Joloral Wutflut")
JR.Lang.Unit.Joloral:SetFrench("Joloral Ragemar\195\169e")
JR.Lang.Unit.Joloral:SetRussian("Йолорал Яролив")
JR.Lang.Unit.Joloral:SetKorean("폭풍분노 졸로랄")
-- Additional Unit Dictionary
JR.Lang.Unit.Crippler = KBM.Language:Add("Plated Crippler")
JR.Lang.Unit.Crippler:SetGerman("Plattenverkrüppler")
JR.Lang.Unit.Crippler:SetFrench("Mutilateur cuirassé")
JR.Lang.Unit.Crippler:SetRussian("Палач в латах")
JR.Lang.Unit.Crippler:SetKorean("판금 절름발이")

-- Ability Dictionary
JR.Lang.Ability = {}
JR.Lang.Ability.Panic = KBM.Language:Add("Panic Attack")
JR.Lang.Ability.Panic:SetGerman("Panikattacke")
JR.Lang.Ability.Panic:SetFrench("Crise de panique")
JR.Lang.Ability.Panic:SetRussian("Приступ паники")
JR.Lang.Ability.Panic:SetKorean("공황 공격")

-- Notify Dictionary
JR.Lang.Notify = {}
JR.Lang.Notify.Panic = KBM.Language:Add("Joloral Ragetide glares at (%a*)")
JR.Lang.Notify.Panic:SetGerman("Joloral Wutflut starrt (%a*) an!")
JR.Lang.Notify.Panic:SetFrench("Joloral Ragemarée lance un regard furieux à (%a*)")
JR.Lang.Notify.Panic:SetKorean("폭풍분노 졸로랄이(가) (%a*)을(를) 노려봅니다!")

-- Verbose Dictionary
JR.Lang.Verbose = {}
JR.Lang.Verbose.Crippler = KBM.Language:Add(JR.Lang.Unit.Crippler[KBM.Lang].." enters the battle")
JR.Lang.Verbose.Crippler:SetGerman(JR.Lang.Unit.Crippler[KBM.Lang].." greift in den Kampf ein!")
JR.Lang.Verbose.Crippler:SetFrench("Mutilateur cuirassé entre en combat")
JR.Lang.Verbose.Crippler:SetKorean("판금 절름발이가 전투에 참여합니다.")

-- Menu Dictionary
JR.Lang.Menu = {}
JR.Lang.Menu.Panic = KBM.Language:Add(JR.Lang.Ability.Panic[KBM.Lang].." duration.")
JR.Lang.Menu.Panic:SetGerman(JR.Lang.Ability.Panic[KBM.Lang].." Dauer.")
JR.Lang.Menu.Panic:SetFrench("Durée des Crise de panique.")
JR.Lang.Menu.Panic:SetRussian("Длительность "..JR.Lang.Ability.Panic[KBM.Lang])
JR.Lang.Menu.Panic:SetKorean("공황 공격 지속시간.")

JR.Joloral.Name = JR.Lang.Unit.Joloral[KBM.Lang]
JR.Descript = JR.Joloral.Name

function JR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Joloral.Name] = self.Joloral,
	}
end

function JR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Joloral.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		AlertsRef = self.Joloral.Settings.AlertsRef,
		TimersRef = self.Joloral.Settings.TimersRef,
		MechRef = self.Joloral.Settings.MechRef,
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alert = KBM.Defaults.Alerts(),
		MechTimer = KBM.Defaults.MechTimer(),
	}
	KBMDHJR_Settings = self.Settings
	chKBMDHJR_Settings = self.Settings
end

function JR:SwapSettings(bool)

	if bool then
		KBMDHJR_Settings = self.Settings
		self.Settings = chKBMDHJR_Settings
	else
		chKBMDHJR_Settings = self.Settings
		self.Settings = KBMDHJR_Settings
	end

end

function JR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMDHJR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMDHJR_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMDHJR_Settings = self.Settings
	else
		KBMDHJR_Settings = self.Settings
	end	
end

function JR:SaveVars()	
	if KBM.Options.Character then
		chKBMDHJR_Settings = self.Settings
	else
		KBMDHJR_Settings = self.Settings
	end	
end

function JR:Castbar(units)
end

function JR:RemoveUnits(UnitID)
	if self.Joloral.UnitID == UnitID then
		self.Joloral.Available = false
		return true
	end
	return false
end

function JR:Death(UnitID)
	if self.Joloral.UnitID == UnitID then
		self.Joloral.Dead = true
		return true
	end
	return false
end

function JR:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Joloral.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Joloral.Dead = false
					self.Joloral.Casting = false
					self.Joloral.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(KBM.Language.Options.Single[KBM.Lang])
					self.PhaseObj.Objectives:AddPercent(self.Joloral.Name, 0, 100)
					self.Phase = 1					
				end
				self.Joloral.UnitID = unitID
				self.Joloral.Available = true
				return self.Joloral
			end
		end
	end
end

function JR:Reset()
	self.EncounterRunning = false
	self.Joloral.Available = false
	self.Joloral.UnitID = nil
	self.Joloral.Dead = false
	self.Joloral.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function JR:Timer()
	
end

function JR:DefineMenu()
	self.Menu = DH.Menu:CreateEncounter(self.Joloral, self.Enabled)
end

function JR:Start()
	-- Create Timers
	self.Joloral.TimersRef.Panic = KBM.MechTimer:Add(self.Lang.Ability.Panic[KBM.Lang], 37)
	KBM.Defaults.TimerObj.Assign(self.Joloral)
	
	-- Create Alerts
	self.Joloral.AlertsRef.Panic = KBM.Alert:Create(self.Lang.Ability.Panic[KBM.Lang], nil, true, true, "purple")
	self.Joloral.AlertsRef.PanicDuration = KBM.Alert:Create(self.Lang.Ability.Panic[KBM.Lang], nil, false, true, "purple")
	self.Joloral.AlertsRef.PanicDuration.MenuName = self.Lang.Menu.Panic[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Joloral)
	
	-- Create Mechanic Spies
	self.Joloral.MechRef.Panic = KBM.MechSpy:Add(self.Lang.Ability.Panic[KBM.Lang], nil, "playerDebuff", self.Joloral)
	KBM.Defaults.MechObj.Assign(self.Joloral)
	
	-- Assign Timers and Alerts to Triggers
	self.Joloral.Triggers.Panic = KBM.Trigger:Create(self.Lang.Ability.Panic[KBM.Lang], "cast", self.Joloral)
	self.Joloral.Triggers.Panic:AddTimer(self.Joloral.TimersRef.Panic)
	self.Joloral.Triggers.Panic:AddAlert(self.Joloral.AlertsRef.Panic)
	self.Joloral.Triggers.PanicDuration = KBM.Trigger:Create(self.Lang.Ability.Panic[KBM.Lang], "playerDebuff", self.Joloral)
	self.Joloral.Triggers.PanicDuration:AddAlert(self.Joloral.AlertsRef.PanicDuration)
	self.Joloral.Triggers.PanicDuration:AddSpy(self.Joloral.MechRef.Panic)
	self.Joloral.Triggers.PanicRemove = KBM.Trigger:Create(self.Lang.Ability.Panic[KBM.Lang], "playerBuffRemove", self.Joloral)
	self.Joloral.Triggers.PanicRemove:AddStop(self.Joloral.MechRef.Panic)
	
	self.Joloral.CastBar = KBM.CastBar:Add(self, self.Joloral, true)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end