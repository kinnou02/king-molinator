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
}

KBM.RegisterMod(TPH.ID, TPH)

-- Main Unit Dictionary
TPH.Lang.Unit = {}
TPH.Lang.Unit.Typhiria = KBM.Language:Add("General Typhiria")
TPH.Lang.Unit.Typhiria:SetGerman("Generalin Typhiria")
TPH.Lang.Unit.TyphiriaShort = KBM.Language:Add("Typhiria")
TPH.Lang.Unit.TyphiriaShort:SetGerman("Typhiria")

-- Ability Dictionary
TPH.Lang.Ability = {}

-- Description Dictionary
TPH.Lang.Main = {}

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
	-- AlertsRef = {},
	-- TimersRef = {},
	Available = false,
	UTID = {
		[1] = "UFF3F6A944C22C40E", -- P1
		[2] = "UFE4A0A54405C6904", -- P2
	},
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
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
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Typhiria.Settings.TimersRef,
		-- AlertsRef = self.Typhiria.Settings.AlertsRef,
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
	end
end

function TPH:Death(UnitID)
	if self.Typhiria.UnitID == UnitID then
		self.Typhiria.Dead = true
		return true
	end
	return false
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
				self.Phase = 1
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
	-- KBM.Defaults.TimerObj.Assign(self.Typhiria)
	
	-- Create Alerts
	-- KBM.Defaults.AlertObj.Assign(self.Typhiria)
	
	-- Assign Alerts and Timers to Triggers
	self.Typhiria.Triggers.PhaseTwo = KBM.Trigger:Create(15, "percent", self.Typhiria)
	self.Typhiria.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	
	self.Typhiria.CastBar = KBM.CastBar:Add(self, self.Typhiria)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end