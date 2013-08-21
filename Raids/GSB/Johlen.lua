-- Infiltrator Johlen Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBIJ_Settings = nil
chKBMGSBIJ_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GSB = KBM.BossMod["Greenscales Blight"]

local IJ = {
	Enabled = true,
	Directory = GSB.Directory,
	File = "Johlen.lua",
	Instance = GSB.Name,
	InstanceObj = GSB,
	HasPhases = true,
	Lang = {},
	ID = "Johlen",
	HasChronicle = true,
	Object = "IJ",
}

IJ.Johlen = {
	Mod = IJ,
	Level = 52,
	Active = false,
	Name = "Infiltrator Johlen",
	NameShort = "Johlen",
	ChronicleID = "U24253CDD6002C8D5",
	UTID = "U11DFBF8C2A3FA156",
	Menu = {},
	AlertsRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Blinding = KBM.Defaults.AlertObj.Create("yellow"),
			Bomb = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = {
			Enabled = true,
			Arm = KBM.Defaults.MechObj.Create("blue"),
		},
	},
}

KBM.RegisterMod(IJ.ID, IJ)

-- Main Unit Dictionary
IJ.Lang.Unit = {}
IJ.Lang.Unit.Johlen = KBM.Language:Add(IJ.Johlen.Name)
IJ.Lang.Unit.Johlen:SetFrench("Infiltrateur Johlen")
IJ.Lang.Unit.Johlen:SetGerman("Infiltrator Johlen")
IJ.Lang.Unit.Johlen:SetRussian("Лазутчик Джохлен")
IJ.Lang.Unit.Johlen:SetKorean("인필트레이터 졸렌")
IJ.Lang.Unit.JohlenShort = KBM.Language:Add("Johlen")
IJ.Lang.Unit.JohlenShort:SetFrench("Johlen")
IJ.Lang.Unit.JohlenShort:SetGerman("Johlen")
IJ.Lang.Unit.JohlenShort:SetRussian("Джохлен")
IJ.Lang.Unit.JohlenShort:SetKorean("졸렌")
-- Addtional Unit Dictionary
IJ.Lang.Unit.Bomb = KBM.Language:Add("Devastating Bomb")
--IJ.Lang.Unit.Bomb = KBM.Language:Add("Concussion Bomb")
IJ.Lang.Unit.Bomb:SetGerman("Vernichtende Bombe")
IJ.Lang.Unit.Bomb:SetFrench("Bombe dévastatrice")
IJ.Lang.Unit.Bomb:SetRussian("Разрушительная бомба")
IJ.Lang.Unit.Bomb:SetKorean("위력적인 폭탄")

-- Ability Dictionary
IJ.Lang.Ability = {}
IJ.Lang.Ability.Blinding = KBM.Language:Add("Blinding Bomb")
IJ.Lang.Ability.Blinding:SetGerman("Blendbombe")
IJ.Lang.Ability.Blinding:SetFrench("Bombe aveuglante")
IJ.Lang.Ability.Blinding:SetRussian("Ослепляющая бомба")
IJ.Lang.Ability.Blinding:SetKorean("실명 폭탄")
IJ.Lang.Ability.Arm = KBM.Language:Add("Arm Bomb")

-- Verbose Dictionary 
IJ.Lang.Verbose = {}
IJ.Lang.Verbose.Bomb = KBM.Language:Add("Devastation")
IJ.Lang.Verbose.Bomb:SetGerman("Vernichtung")
IJ.Lang.Verbose.Bomb:SetFrench("Dévastation")
IJ.Lang.Verbose.Bomb:SetRussian("Разрушение")
IJ.Lang.Verbose.Bomb:SetKorean("위력폭탄")

-- Phase Monitor Dictionary
IJ.Lang.Phase = {}
IJ.Lang.Phase.Bomb = KBM.Language:Add("Bomb")
IJ.Lang.Phase.Bomb:SetGerman("Bombe")
IJ.Lang.Phase.Bomb:SetFrench("Bombe")
IJ.Lang.Phase.Bomb:SetRussian("бомба")
IJ.Lang.Phase.Bomb:SetKorean("폭탄")

IJ.Johlen.Name = IJ.Lang.Unit.Johlen[KBM.Lang]
IJ.Descript = IJ.Johlen.Name

IJ.Bomb = {
	Mod = IJ,
	Level = 52,
	Name = IJ.Lang.Unit.Bomb[KBM.Lang],
	Ignore = true,
	UTID = "U3F7C52390EFF515F",
	Dead = false,
}

function IJ:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Johlen.Name] = self.Johlen,
		[self.Bomb.Name] = self.Bomb,
	}
end

function IJ:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = true,
		CastBar = self.Johlen.Settings.CastBar,
		AlertsRef = self.Johlen.Settings.AlertsRef,
		MechRef = self.Johlen.Settings.MechRef,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMGSBIJ_Settings = self.Settings
	chKBMGSBIJ_Settings = self.Settings
end

function IJ:SwapSettings(bool)
	if bool then
		KBMGSBIJ_Settings = self.Settings
		self.Settings = chKBMGSBIJ_Settings
	else
		chKBMGSBIJ_Settings = self.Settings
		self.Settings = KBMGSBIJ_Settings
	end
end

function IJ:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBIJ_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBIJ_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBIJ_Settings = self.Settings
	else
		KBMGSBIJ_Settings = self.Settings
	end	
end

function IJ:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBIJ_Settings = self.Settings
	else
		KBMGSBIJ_Settings = self.Settings
	end	
end

function IJ:Castbar(units)
end

function IJ:RemoveUnits(UnitID)
	if self.Johlen.UnitID == UnitID then
		self.Johlen.Available = false
		return true
	end
	return false
end

function IJ:Death(UnitID)
	if self.Johlen.UnitID == UnitID then
		self.Johlen.Dead = true
		return true
	elseif self.Bomb then
		self.Bomb.Dead = true
		self.Bomb.UnitID = nil
		if self.Bomb.PhaseObj then
			self.Bomb.PhaseObj:Remove()
			if self.Phase < 4 then
				self.PhaseObj:SetPhase(self.Phase)
			else
				self.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
			end
			KBM.Alert:Stop(self.Johlen.AlertsRef.Bomb)
		end
	end
	return false
end

function IJ:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				if BossObj == self.Johlen then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.UnitID = unitID
					BossObj.Dead = false
					BossObj.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objectives:AddPercent(self.Johlen, 75, 100)
					self.PhaseObj:SetPhase(1)
				else
					return
				end
			else
				if BossObj.CastBar then
					if BossObj.UnitID ~= unitID then
						BossObj.CastBar:Remove()
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
			end
			return BossObj
		end
	end
end

function IJ.PhaseTwo()
	IJ.PhaseObj.Objectives:Remove()
	IJ.Phase = 2
	IJ.PhaseObj:SetPhase(IJ.Lang.Phase.Bomb[KBM.Lang].." 1/3")
	IJ.PhaseObj.Objectives:AddPercent(IJ.Johlen, 50, 75)
	IJ.PhaseObj.Objectives:AddPercent(IJ.Bomb, 0, 100)	
end

function IJ.PhaseThree()
	IJ.PhaseObj.Objectives:Remove()
	IJ.Phase = 3
	IJ.PhaseObj:SetPhase(IJ.Lang.Phase.Bomb[KBM.Lang].." 2/3")
	IJ.PhaseObj.Objectives:AddPercent(IJ.Johlen, 25, 50)
	IJ.PhaseObj.Objectives:AddPercent(IJ.Bomb, 0, 100)	
end

function IJ.PhaseFour()
	IJ.PhaseObj.Objectives:Remove()
	IJ.Phase = 4
	IJ.PhaseObj:SetPhase(IJ.Lang.Phase.Bomb[KBM.Lang].." 3/3")
	IJ.PhaseObj.Objectives:AddPercent(IJ.Johlen, 0, 25)
	IJ.PhaseObj.Objectives:AddPercent(IJ.Bomb, 0, 100)		
end

function IJ:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
		BossObj.Dead = false
	end
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())
end

function IJ:Timer()	
end

function IJ:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Johlen, self.Enabled)
end

IJ.Custom = {}
IJ.Custom.Encounter = {}
function IJ.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Chronicle(bool)
		IJ.Settings.Chronicle = bool
	end

	Header = Menu:CreateHeader(KBM.Language.Encounter.Chronicle[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(IJ.Settings.Chronicle)
	Header:SetHook(Callbacks.Chronicle)
	
end

function IJ:Start()
	-- Create Alerts
	self.Johlen.AlertsRef.Blinding = KBM.Alert:Create(self.Lang.Ability.Blinding[KBM.Lang], 6, true, true, "yellow")
	self.Johlen.AlertsRef.Bomb = KBM.Alert:Create(self.Lang.Verbose.Bomb[KBM.Lang], 25, false, true, "red")
	self.Johlen.AlertsRef.Bomb.MenuName = self.Lang.Unit.Bomb[KBM.Lang]
	KBM.Defaults.AlertObj.Assign(self.Johlen)
	
	-- Test Mech Spy
	self.Johlen.MechRef.Arm = KBM.MechSpy:Add(self.Lang.Ability.Arm[KBM.Lang], 5, "castTarget", self.Johlen)
	KBM.Defaults.MechObj.Assign(self.Johlen)
	
	-- Assign and Create Triggers
	self.Johlen.Triggers.Bomb = KBM.Trigger:Create(self.Lang.Unit.Bomb[KBM.Lang], "notify", self.Johlen)
	self.Johlen.Triggers.Bomb:AddAlert(self.Johlen.AlertsRef.Bomb)
	self.Johlen.Triggers.Blinding = KBM.Trigger:Create(self.Lang.Ability.Blinding[KBM.Lang], "cast", self.Johlen)
	self.Johlen.Triggers.Blinding:AddAlert(self.Johlen.AlertsRef.Blinding)
	self.Johlen.Triggers.PhaseTwo = KBM.Trigger:Create(76, "percent", self.Johlen)
	self.Johlen.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Johlen.Triggers.PhaseThree = KBM.Trigger:Create(51, "percent", self.Johlen)
	self.Johlen.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Johlen.Triggers.PhaseFour = KBM.Trigger:Create(26, "percent", self.Johlen)
	self.Johlen.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	self.Johlen.Triggers.Arm = KBM.Trigger:Create(self.Lang.Ability.Arm[KBM.Lang], "cast", self.Johlen)
	self.Johlen.Triggers.Arm:AddSpy(self.Johlen.MechRef.Arm)
	
	self.Johlen.CastBar = KBM.Castbar:Add(self, self.Johlen)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end