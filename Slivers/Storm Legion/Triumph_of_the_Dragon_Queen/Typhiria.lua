-- General Typhiria Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMSLSLTQGT_Settings = nil
chKBMSLSLTQGT_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local TDQ = KBM.BossMod["STriumph_of_the_Dragon_Queen"]

local TPH = {
	Directory = TDQ.Directory,
	File = "Typhiria.lua",
	Enabled = true,
	Instance = TDQ.Name,
	InstanceObj = TDQ,
	Lang = {},
	Enrage = 7 * 60,
	ID = "STyphiria",
	Object = "TPH",
	BlastCount = 0,
}

KBM.RegisterMod(TPH.ID, TPH)

-- Main Unit Dictionary
TPH.Lang.Unit = {}
TPH.Lang.Unit.Typhiria = KBM.Language:Add("General Typhiria")
TPH.Lang.Unit.Typhiria:SetGerman("Generalin Typhiria")
TPH.Lang.Unit.Typhiria:SetFrench("Général Typhiria")
TPH.Lang.Unit.TyphiriaShort = KBM.Language:Add("Typhiria")
TPH.Lang.Unit.TyphiriaShort:SetGerman("Typhiria")
TPH.Lang.Unit.TyphiriaShort:SetFrench("Typhiria")

-- Ability Dictionary
TPH.Lang.Ability = {}
TPH.Lang.Ability.Clouds = KBM.Language:Add("Dark Clouds")
TPH.Lang.Ability.Clouds:SetFrench("Nuages ténébreux")
TPH.Lang.Ability.Tempest = KBM.Language:Add("Tempest of Agony")
TPH.Lang.Ability.Tempest:SetFrench("Tempête d'agonie")
TPH.Lang.Ability.Blast = KBM.Language:Add("Storm Blast")
TPH.Lang.Ability.Blast:SetFrench("Poussée foudroyante")

-- Description Dictionary
TPH.Lang.Main = {}

TPH.Lang.Messages = {}
TPH.Lang.Messages.TempestSoon = KBM.Language:Add("Tempest soon!")
TPH.Lang.Messages.TempestSoon:SetFrench("Tempête bientôt!")

TPH.Descript = TPH.Lang.Unit.Typhiria[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
TPH.Typhiria = {
	Mod = TPH,
	Level = "??",
	Active = false,
	Name = TPH.Lang.Unit.Typhiria[KBM.Lang],
	NameShort = TPH.Lang.Unit.TyphiriaShort[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	Available = false,
	UTID = {
		[1] = "UFF3F6A944C22C40E", -- P1
		[2] = "UFE4A0A54405C6904", -- P2
	},
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Clouds = KBM.Defaults.TimerObj.Create("dark_green"),
			Tempest = KBM.Defaults.TimerObj.Create("purple"),
			Blast = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Blast = KBM.Defaults.AlertObj.Create("yellow"),
			Clouds = KBM.Defaults.AlertObj.Create("dark_green"),
			Tempest = KBM.Defaults.AlertObj.Create("purple"),
			TempestSoon = KBM.Defaults.AlertObj.Create("purple"),
		},
	}
}

function TPH:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Typhiria.Name] = self.Typhiria,
	}
end

function TPH:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Typhiria.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		TimersRef = self.Typhiria.Settings.TimersRef,
		AlertsRef = self.Typhiria.Settings.AlertsRef,
	}
	KBMSLSLTQGT_Settings = self.Settings
	chKBMSLSLTQGT_Settings = self.Settings
	
end

function TPH:SwapSettings(bool)

	if bool then
		KBMSLSLTQGT_Settings = self.Settings
		self.Settings = chKBMSLSLTQGT_Settings
	else
		chKBMSLSLTQGT_Settings = self.Settings
		self.Settings = KBMSLSLTQGT_Settings
	end

end

function TPH:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMSLSLTQGT_Settings, self.Settings)
	else
		KBM.LoadTable(KBMSLSLTQGT_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMSLSLTQGT_Settings = self.Settings
	else
		KBMSLSLTQGT_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function TPH:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMSLSLTQGT_Settings = self.Settings
	else
		KBMSLSLTQGT_Settings = self.Settings
	end	
end

function TPH:Castbar(units)
end

function TPH:RemoveUnits(UnitID)
	if self.Typhiria.UnitID == UnitID then
		self.Typhiria.Available = false
		return true
	end
	return false
end

function TPH.PhaseTwo()
	if TPH.Phase == 1 then
		TPH.Phase = 2
		TPH.PhaseObj.Objectives:Remove()
		TPH.Typhiria.UnitID = nil
		TPH.PhaseObj.Objectives:AddPercent(TPH.Typhiria, 0, 100)
		TPH.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		KBM.MechTimer:AddRemove(TPH.Typhiria.TimersRef.Clouds)
		KBM.MechTimer:AddRemove(TPH.Typhiria.TimersRef.Tempest)
		KBM.MechTimer:AddStart(TPH.Typhiria.TimersRef.Wrath)
	end
end

function TPH:Death(UnitID)
	if self.Typhiria.UnitID == UnitID then
		self.Typhiria.Dead = true
		return true
	end
	return false
end

function TPH:PhaseClouds()
	TPH.BlastCount = 0
	KBM.MechTimer:AddStart(TPH.Typhiria.TimersRef.Blast, 3)
	KBM.MechTimer:AddStart(TPH.Typhiria.TimersRef.Tempest, 30)
end

function TPH:PhaseBlast()
	TPH.BlastCount = TPH.BlastCount + 1
	print("Blast "..TPH.BlastCount.."/6")
	if TPH.BlastCount >= 6 then
		KBM.MechTimer:AddStart(TPH.Typhiria.TimersRef.Clouds, 60)
	end
end

function TPH:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Typhiria then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Typhiria, 15, 100)
				KBM.MechTimer:AddStart(self.Typhiria.TimersRef.Tempest)
				KBM.MechTimer:AddStart(self.Typhiria.TimersRef.Clouds)
				self.Phase = 1
				self.BlastCount = 0
			else
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj == self.Typhiria then
					if BossObj.UnitID ~= unitID then
						BossObj.CastBar:Remove()
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

function TPH:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Typhiria.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function TPH:Timer()	
end

function TPH:DefineMenu()
	self.Menu = TDQ.Menu:CreateEncounter(self.Typhiria, self.Enabled)
end

function TPH:Start()
	-- Create Timers
	self.Typhiria.TimersRef.Clouds = KBM.MechTimer:Add(self.Lang.Ability.Clouds[KBM.Lang], 60, false)
	self.Typhiria.TimersRef.Tempest = KBM.MechTimer:Add(self.Lang.Ability.Tempest[KBM.Lang], 27, false)
	self.Typhiria.TimersRef.Blast = KBM.MechTimer:Add(self.Lang.Ability.Blast[KBM.Lang], 7, false)
	--self.Typhiria.TimersRef.Wrath = KBM.MechTimer:Add(self.Lang.Ability.Wrath[KBM.Lang], 78, false)
	KBM.Defaults.TimerObj.Assign(self.Typhiria)
	
	-- Create Alerts
	self.Typhiria.AlertsRef.Clouds = KBM.Alert:Create(self.Lang.Ability.Clouds[KBM.Lang], 3, false, true, "dark_green")
	self.Typhiria.AlertsRef.Tempest = KBM.Alert:Create(self.Lang.Ability.Tempest[KBM.Lang], 10, false, true, "purple")
	self.Typhiria.AlertsRef.TempestSoon = KBM.Alert:Create(self.Lang.Messages.TempestSoon[KBM.Lang], 5, true, true, "purple")
	self.Typhiria.TimersRef.Tempest:AddAlert(self.Typhiria.AlertsRef.TempestSoon, 5)
	self.Typhiria.AlertsRef.Blast = KBM.Alert:Create(self.Lang.Ability.Blast[KBM.Lang], 2, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Typhiria)
	
	-- Assign Alerts and Timers to Triggers

	self.Typhiria.Triggers.Clouds = KBM.Trigger:Create(self.Lang.Ability.Clouds[KBM.Lang], "cast", self.Typhiria)
	self.Typhiria.Triggers.Clouds:AddAlert(self.Typhiria.AlertsRef.Clouds)
	self.Typhiria.Triggers.Clouds:AddPhase(self.PhaseClouds)

	self.Typhiria.Triggers.Tempest = KBM.Trigger:Create(self.Lang.Ability.Tempest[KBM.Lang], "channel", self.Typhiria)
	self.Typhiria.Triggers.Tempest:AddAlert(self.Typhiria.AlertsRef.Tempest)
	self.Typhiria.Triggers.Tempest:AddTimer(self.Typhiria.TimersRef.Tempest)

	self.Typhiria.Triggers.Blast = KBM.Trigger:Create(self.Lang.Ability.Blast[KBM.Lang], "channel", self.Typhiria)
	self.Typhiria.Triggers.Blast:AddPhase(self.PhaseBlast)
	self.Typhiria.Triggers.Blast:AddAlert(self.Typhiria.AlertsRef.Blast)
	self.Typhiria.Triggers.Blast:AddTimer(self.Typhiria.TimersRef.Blast)

	self.Typhiria.Triggers.PhaseTwo = KBM.Trigger:Create(15, "percent", self.Typhiria)
	self.Typhiria.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	
	self.Typhiria.CastBar = KBM.CastBar:Add(self, self.Typhiria)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end