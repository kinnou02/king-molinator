-- Oracle Aleria Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGSBOA_Settings = nil
chKBMGSBOA_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local GSB = KBM.BossMod["Greenscales Blight"]

local OA = {
	Enabled = true,
	Directory = GSB.Directory,
	File = "Aleria.lua",
	Instance = GSB.Name,
	HasPhases = true,
	Lang = {},
	ID = "Aleria",
	HasChronicle = true,
	Object = "OA",
}

OA.Aleria = {
	Mod = OA,
	Level = 52,
	Active = false,
	Name = "Oracle Aleria",
	ChronicleID = "U76F49CD858530EEA",
	RaidID = "U6D36D79B7B3CF7B3",
	Menu = {},
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			Necrotic = KBM.Defaults.AlertObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			Necrotic = KBM.Defaults.TimerObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Necrotic = KBM.Defaults.MechObj.Create("purple"),
		},
	},
}

KBM.RegisterMod(OA.ID, OA)

-- Main Unit Dictionary
OA.Lang.Unit = {}
OA.Lang.Unit.Aleria = KBM.Language:Add(OA.Aleria.Name)
OA.Lang.Unit.Aleria:SetGerman("Orakel Aleria")
OA.Lang.Unit.Aleria:SetFrench("Aleria l'Oracle")
OA.Lang.Unit.Aleria:SetRussian("Оракул Алерия")
OA.Lang.Unit.Aleria:SetKorean("제사장 알레리아")
OA.Descript = OA.Lang.Unit.Aleria[KBM.Lang]
-- Additional Unit Dictionary
OA.Lang.Unit.Primal = KBM.Language:Add("Primal Werewolf")
OA.Lang.Unit.Primal:SetGerman("Ur-Werwolf")
OA.Lang.Unit.Primal:SetFrench("Loup-garou primaire")
OA.Lang.Unit.Primal:SetRussian("Первобытный оборотень")
OA.Lang.Unit.Primal:SetKorean("원시 늑대인간")
OA.Lang.Unit.Necrotic = KBM.Language:Add("Necrotic Werewolf")
OA.Lang.Unit.Necrotic:SetGerman("Nekrotischer Werwolf")
OA.Lang.Unit.Necrotic:SetFrench("Loup-garou nécrotique")
OA.Lang.Unit.Necrotic:SetRussian("Разлагающийся оборотень")
OA.Lang.Unit.Necrotic:SetKorean("괴사 늑대인간")

-- Debuff Dictionary
OA.Lang.Debuff = {}
OA.Lang.Debuff.Necrotic = KBM.Language:Add("Necrotic Eruption")
OA.Lang.Debuff.Necrotic:SetGerman("Nekrotischer Ausbruch")
OA.Lang.Debuff.Necrotic:SetFrench("Énergie nécrotique")
OA.Lang.Debuff.Necrotic:SetRussian("Умервщляющий взрыв")
OA.Lang.Debuff.Necrotic:SetKorean("괴사 에너지")

OA.Primal = {
	Mod = OA,
	Level = 52,
	Active = false,
	Name = OA.Lang.Unit.Primal[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	ChronicleID = "U279898FC4D7B39ED",
	RaidID = "U5EC70B376208CAC3",
}

OA.Necrotic = {
	Mod = OA,
	Level = 52,
	Active = false,
	Name = OA.Lang.Unit.Necrotic[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	ChronicleID = "U676937B70D146F9F",
	RaidID = "U2ED1EB3228891BA6",
}

OA.Aleria.Name = OA.Lang.Unit.Aleria[KBM.Lang]

function OA:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Aleria.Name] = self.Aleria,
		[self.Primal.Name] = self.Primal,
		[self.Necrotic.Name] = self.Necrotic,
	}
	KBM_Boss[self.Aleria.Name] = self.Aleria
	KBM.SubBoss[self.Primal.Name] = self.Primal
	KBM.SubBoss[self.Necrotic.Name] = self.Necrotic
end

function OA:InitVars()
	self.Settings = {
		Enabled = true,
		Chronicle = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
	}
	KBMGSBOA_Settings = self.Settings
	chKBMGSBOA_Settings = self.Settings
end

function OA:SwapSettings(bool)
	if bool then
		KBMGSBOA_Settings = self.Settings
		self.Settings = chKBMGSBOA_Settings
	else
		chKBMGSBOA_Settings = self.Settings
		self.Settings = KBMGSBOA_Settings
	end
end

function OA:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGSBOA_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGSBOA_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGSBOA_Settings = self.Settings
	else
		KBMGSBOA_Settings = self.Settings
	end
end

function OA:SaveVars()	
	if KBM.Options.Character then
		chKBMGSBOA_Settings = self.Settings
	else
		KBMGSBOA_Settings = self.Settings
	end	
end

function OA:Castbar(units)
end

function OA:RemoveUnits(UnitID)
	if self.Aleria.UnitID == UnitID then
		self.Aleria.Available = false
		return true
	end
	return false
end

function OA.PhaseTwo()
	OA.PhaseObj.Objectives:Remove()
	OA.Phase = 2
	OA.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
	OA.PhaseObj.Objectives:AddPercent(OA.Aleria.Name, 0, 100)
end

function OA:Death(UnitID)
	if self.Aleria.UnitID == UnitID then
		self.Aleria.Dead = true
		return true
	else
		if self.Primal.UnitID == UnitID then
			self.Primal.Dead = true
		elseif self.Necrotic.UnitID == UnitID then
			self.Necrotic.Dead = true
		end
		if self.Primal.Dead and self.Necrotic.Dead then
			self.PhaseTwo()
		end
	end
	return false
end

function OA:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Primal.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Necrotic.Name, 0, 100)
				end
				if not self.Bosses[uDetails.name].UnitID then
					self.Bosses[uDetails.name].Dead = false
				end
				self.Bosses[uDetails.name].UnitID = unitID
				self.Bosses[uDetails.name].Available = true
				return self.Bosses[uDetails.name]
			end
		end
	end
end

function OA:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.Dead = false
		BossObj.UnitID = nil
	end
	self.PhaseObj:End(Inspect.Time.Real())
end

function OA:Timer()	
end

function OA.Aleria:SetTimers(bool)	
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

function OA.Aleria:SetAlerts(bool)
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

function OA:DefineMenu()
	self.Menu = GSB.Menu:CreateEncounter(self.Aleria, self.Enabled)
end

OA.Custom = {}
OA.Custom.Encounter = {}
function OA.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Chronicle(bool)
		OA.Settings.Chronicle = bool
	end

	Header = Menu:CreateHeader(KBM.Language.Encounter.Chronicle[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(OA.Settings.Chronicle)
	Header:SetHook(Callbacks.Chronicle)
	
end

function OA:Start()
	-- Create Alert
	self.Aleria.AlertsRef.Necrotic = KBM.Alert:Create(self.Lang.Debuff.Necrotic[KBM.Lang], nil, false, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Aleria)
	
	-- Create Timer
	self.Aleria.TimersRef.Necrotic = KBM.MechTimer:Add(self.Lang.Debuff.Necrotic[KBM.Lang], 22, "purple")
	KBM.Defaults.TimerObj.Assign(self.Aleria)

	-- Create Mechanic Spies
	self.Aleria.MechRef.Necrotic = KBM.MechSpy:Add(self.Lang.Debuff.Necrotic[KBM.Lang], nil, "playerDebuff", self.Aleria)
	KBM.Defaults.MechObj.Assign(self.Aleria)
	
	-- Assign Alert to Trigger
	self.Aleria.Triggers.Necrotic = KBM.Trigger:Create(self.Lang.Debuff.Necrotic[KBM.Lang], "playerBuff", self.Aleria)
	self.Aleria.Triggers.Necrotic:AddAlert(self.Aleria.AlertsRef.Necrotic, true)
	self.Aleria.Triggers.Necrotic:AddTimer(self.Aleria.TimersRef.Necrotic)
	self.Aleria.Triggers.Necrotic:AddSpy(self.Aleria.MechRef.Necrotic)
	
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end