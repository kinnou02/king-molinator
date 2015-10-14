-- Pumpkin Boss Mod for King Boss Mods

KBMNTRDTFPKN_Settings = nil
chKBMNTRDTFPKN_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
	if not KBM.BossMod then
	return
end
local TF = KBM.BossMod["RTyrants_Forge"]

local PKN = {
	Directory = TF.Directory,
	File = "Pumpkin.lua",
	Enabled = true,
	Instance = TF.Name,
	InstanceObj = TF,
	Lang = {},
	Timers = {},
	Enrage = 7 * 60,
	ID = "Pumpkin",
	Object = "PKN",
	HasPhases = true,
	TankSwap = true,
}

KBM.RegisterMod(PKN.ID, PKN)

-- Main Unit Dictionary
PKN.Lang.Unit = {}
PKN.Lang.Unit.Pumpkin = KBM.Language:Add("P.U.M.P.K.I.N.")
PKN.Lang.Unit.Pumpkin:SetFrench("PATATOR")
PKN.Lang.Unit.Charles = KBM.Language:Add("Lt. Charles")
PKN.Lang.Unit.Charles:SetFrench("Lieutenant Charles")

-- Ability Dictionary
PKN.Lang.Ability = {}
PKN.Lang.Ability.Scrapyard = KBM.Language:Add("Scrapyard Rumble")
PKN.Lang.Ability.Scrapyard:SetFrench("Grondement de débris")
PKN.Lang.Ability.Fervor = KBM.Language:Add("Sovereign Fervor")
PKN.Lang.Ability.Fervor:SetFrench("Ferveur souveraine")

-- Verbose Dictionary
PKN.Lang.Verbose = {}

-- Buff Dictionary
PKN.Lang.Buff = {}

-- Debuff Dictionary
PKN.Lang.Debuff = {}
PKN.Lang.Debuff.Overheating = KBM.Language:Add("Overheating")
PKN.Lang.Debuff.Overheating:SetFrench("Surchauffe")
PKN.Lang.Debuff.Mass = KBM.Language:Add("Mass Beautification")
PKN.Lang.Debuff.Mass:SetFrench("Embellissement de masse")

-- Description Dictionary
PKN.Lang.Main = {}

PKN.Descript = PKN.Lang.Unit.Pumpkin[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
PKN.Pumpkin = {
	Mod = PKN,
	Level = "??",
	Active = false,
	Name = PKN.Lang.Unit.Pumpkin[KBM.Lang],
	Dead = false,	
	Available = false,
	Menu = {},
	UTID = "U79F313C3690909C2",
	UnitID = nil,
	Castbar = nil,
	TimersRef = {},	
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef = {
			Enabled = true,
			FervorFirst = KBM.Defaults.TimerObj.Create("red"),
			Fervor = KBM.Defaults.TimerObj.Create("red"),
			ScrapyardFirst = KBM.Defaults.TimerObj.Create("yellow"),
			Scrapyard = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Scrapyard = KBM.Defaults.AlertObj.Create("yellow"),	
			Fervor = KBM.Defaults.AlertObj.Create("red"),	
			Mass = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Scrapyard = KBM.Defaults.MechObj.Create("yellow"),
			Fervor = KBM.Defaults.MechObj.Create("red"),
		},
	}
}

PKN.Charles = {
	Mod = PKN,
	Level = "??",
	Active = false,
	Name = PKN.Lang.Unit.Charles[KBM.Lang],
	Dead = false,	
	Available = false,
	Menu = {},
	UTID = "U25EA62DD0992A9E1",
	UnitID = nil,
	Castbar = nil,
	--TimersRef = {},	
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		--TimersRef = {
		-- Enabled = false,
		--},
		AlertsRef = {
			Enabled = true,
		},
		MechRef = {
			Enabled = true,
		},
	}
}

function PKN:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Pumpkin.Name] = self.Pumpkin,
		[self.Charles.Name] = self.Charles,
	}
end

function PKN:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Pumpkin.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		TimersRef = self.Pumpkin.Settings.TimersRef,
		AlertsRef = self.Pumpkin.Settings.AlertsRef,
		MechRef = self.Pumpkin.Settings.MechRef,
	}
	KBMNTRDTFPKN_Settings = self.Settings
	chKBMNTRDTHPKN_Settings = self.Settings

end

function PKN:SwapSettings(bool)

	if bool then
		KBMNTRDTFPKN_Settings = self.Settings
		self.Settings = chKBMNTRDTFPKN_Settings
	else
		chKBMNTRDTFPKN_Settings = self.Settings
		self.Settings = KBMNTRDTFPKN_Settings
	end

end

function PKN:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDTFPKN_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDTFPKN_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMNTRDTFPKN_Settings = self.Settings
	else
		KBMNTRDTFPKN_Settings = self.Settings
	end	

	self.Settings.Enabled = true
end

function PKN:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDTFPKN_Settings = self.Settings
	else
		KBMNTRDTFPKN_Settings = self.Settings
	end	
end

function PKN:Castbar(units)
end

function PKN:RemoveUnits(UnitID)
	if self.Pumpkin.UnitID == UnitID then
		self.Pumpkin.Available = false
		return true
	end
	return false
end

function PKN:Death(UnitID)
	if self.Pumpkin.UnitID == UnitID then
		--- self.Pumpkin.Dead = true
		PKN.PhaseThree()
	elseif self.Charles.UnitID == UnitID then
		self.Charles.Dead = true
		return true
	end
	return false
end

function PKN.PhaseTwo()
	PKN.PhaseObj.Objectives:Remove()
	PKN.Phase = 2
	PKN.PhaseObj:SetPhase(2)
	PKN.PhaseObj.Objectives:AddPercent(PKN.Pumpkin, 0, 50)	
	KBM.MechTimer:AddRemove(PKN.Pumpkin.TimersRef.Scrapyard, true)
end

function PKN.PhaseThree()
	PKN.PhaseObj.Objectives:Remove()
	PKN.Phase = 3
	PKN.PhaseObj:SetPhase(3)
	PKN.PhaseObj.Objectives:AddPercent(PKN.Charles, 0, 100)	
end

function PKN:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		local BossObj = self.UTID[uDetails.type]
		if not BossObj then
			BossObj = self.Bosses[uDetails.name]
		end
		if BossObj then
			if not self.EncounterRunning then
				self.EncounterRunning = true
				self.StartTime = Inspect.Time.Real()
				self.HeldTime = self.StartTime
				self.TimeElapsed = 0
				BossObj.Dead = false
				BossObj.Casting = false
				if BossObj.CastBar then
					BossObj.CastBar:Create(unitID)
				end
				self.PhaseObj:Start(self.StartTime)
				self.PhaseObj:SetPhase("1")
				self.PhaseObj.Objectives:AddPercent(self.Pumpkin, 0, 100)
				self.Phase = 1
				KBM.MechTimer:AddStart(self.Pumpkin.TimersRef.FervorFirst)
				KBM.MechTimer:AddStart(self.Pumpkin.TimersRef.ScrapyardFirst)
				local DebuffTable = {
					[1] = self.Lang.Debuff.Overheating[KBM.Lang],
				}
				KBM.TankSwap:Start(DebuffTable, unitID)
			end
		else
			BossObj.Dead = false
			BossObj.Casting = false
			if BossObj.UnitID ~= unitID then
				BossObj.CastBar:Remove()
				BossObj.CastBar:Create(unitID)
			end
		end
		BossObj.UnitID = unitID
		BossObj.Available = true
		return BossObj
	end
end

function PKN:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Pumpkin.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function PKN:Timer()	
end

function PKNefineMenu()
	self.Menu = TF.Menu:CreateEncounter(self.Pumpkin, self.Enabled)
end

function PKN:Start()

	-- Create Timers
	self.Pumpkin.TimersRef.Fervor = KBM.MechTimer:Add(self.Lang.Ability.Fervor[KBM.Lang], 32, true)
	self.Pumpkin.TimersRef.FervorFirst = KBM.MechTimer:Add(self.Lang.Ability.Fervor[KBM.Lang], 11)
	self.Pumpkin.TimersRef.FervorFirst:AddTimer(self.Pumpkin.TimersRef.Fervor, 0)
	self.Pumpkin.TimersRef.Scrapyard = KBM.MechTimer:Add(self.Lang.Ability.Scrapyard[KBM.Lang], 50, true)
	self.Pumpkin.TimersRef.ScrapyardFirst = KBM.MechTimer:Add(self.Lang.Ability.Scrapyard[KBM.Lang], 25)
	self.Pumpkin.TimersRef.ScrapyardFirst:AddTimer(self.Pumpkin.TimersRef.Scrapyard, 0)
	self.Pumpkin.TimersRef.FervorFirst:NoMenu()
	self.Pumpkin.TimersRef.ScrapyardFirst:NoMenu()
	KBM.Defaults.TimerObj.Assign(self.Pumpkin)

	-- Create Alerts
	self.Pumpkin.AlertsRef.Scrapyard = KBM.Alert:Create(self.Lang.Ability.Scrapyard[KBM.Lang], nil, false, true, "cyan")	
	self.Pumpkin.AlertsRef.Fervor = KBM.Alert:Create(self.Lang.Ability.Fervor[KBM.Lang], nil, false, true, "red")
	self.Pumpkin.AlertsRef.Mass = KBM.Alert:Create(self.Lang.Debuff.Mass[KBM.Lang], 10, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.Pumpkin)

	-- Create Spies
	KBM.Defaults.MechObj.Assign(self.Pumpkin)

	-- Assign Alerts and Timers to Triggers
	self.Pumpkin.Triggers.Scrapyard = KBM.Trigger:Create(self.Lang.Ability.Scrapyard[KBM.Lang], "cast", self.Pumpkin)
	self.Pumpkin.Triggers.Scrapyard:AddAlert(self.Pumpkin.AlertsRef.Scrapyard)
	self.Pumpkin.Triggers.Scrapyard:AddTimer(self.Pumpkin.TimersRef.Scrapyard)
	-- self.Pumpkin.Triggers.Scrapyard:AddSpy(self.Pumpkin.MechRef.Scrapyard)
	self.Pumpkin.Triggers.Fervor = KBM.Trigger:Create(self.Lang.Ability.Fervor[KBM.Lang], "cast", self.Pumpkin)
	self.Pumpkin.Triggers.Fervor:AddAlert(self.Pumpkin.AlertsRef.Fervor)
	self.Pumpkin.Triggers.Fervor:AddTimer(self.Pumpkin.TimersRef.Fervor)
	-- self.Pumpkin.Triggers.Fervor:AddSpy(self.Pumpkin.MechRef.Fervor)
	self.Pumpkin.Triggers.Mass = KBM.Trigger:Create(self.Lang.Debuff.Mass[KBM.Lang], "playerDebuff", self.Pumpkin)
	self.Pumpkin.Triggers.Mass:AddAlert(self.Pumpkin.AlertsRef.Mass, true)
	
	self.Pumpkin.Triggers.PhaseTwo = KBM.Trigger:Create(50,"percent",self.Pumpkin)
	self.Pumpkin.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)

	self.Pumpkin.CastBar = KBM.Castbar:Add(self, self.Pumpkin)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end