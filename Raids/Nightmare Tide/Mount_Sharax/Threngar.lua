-- Threngar Boss Mod for King Boss Mods

KBMNTRDMSTGR_Settings = nil
chKBMNTRDMSTGR_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
return
end
local MS = KBM.BossMod["RMount_Sharax"]

local TGR = {
	Directory = MS.Directory,
	File = "Threngar.lua",
	Enabled = true,
	Instance = MS.Name,
	InstanceObj = MS,
	Lang = {},
	Enrage = 12 * 60,
	ID = "Threngar",
	Object = "TGR",
	HasPhases = true,
	TankSwap = true,
}

KBM.RegisterMod(TGR.ID, TGR)

-- Main Unit Dictionary
TGR.Lang.Unit = {}
TGR.Lang.Unit.Threngar = KBM.Language:Add("Threngar")
TGR.Lang.Unit.Akvan = KBM.Language:Add("Akvan Monstrosity")
TGR.Lang.Unit.Akvan:SetFrench("Monstruosité akvan")

-- Ability Dictionary
TGR.Lang.Ability = {}
TGR.Lang.Ability.Offering = KBM.Language:Add("Sacrificial Offering")
TGR.Lang.Ability.Offering:SetFrench("Offrandes sacrificielles")
TGR.Lang.Ability.Binding = KBM.Language:Add("Dark Binding")
TGR.Lang.Ability.Binding:SetFrench("Lien sombre")
TGR.Lang.Ability.Untold = KBM.Language:Add("Untold Horror")
TGR.Lang.Ability.Untold:SetFrench("Horreur indicible")


-- Verbose Dictionary
TGR.Lang.Verbose = {}

-- Buff Dictionary
TGR.Lang.Buff = {}

-- Debuff Dictionary
TGR.Lang.Debuff = {}
TGR.Lang.Debuff.Conduit = KBM.Language:Add("Conduit of Martrodraum")
TGR.Lang.Debuff.Conduit:SetFrench("Conduit de Martrodraum")
TGR.Lang.Debuff.Glaive = KBM.Language:Add("Shadow Glaive")
TGR.Lang.Debuff.Glaive:SetFrench("Glaive de l'ombre")
--TGR.Lang.Debuff.GlaiveID = ""
TGR.Lang.Debuff.Convinction = KBM.Language:Add("Nightmare Convinction")
TGR.Lang.Debuff.Convinction:SetFrench("Conviction cauchemardesque")
TGR.Lang.Debuff.Binding = KBM.Language:Add("Dark Binding")
TGR.Lang.Debuff.Binding:SetFrench("Lien sombre")
TGR.Lang.Debuff.BindingID = "b800000001740DAD7"
TGR.Lang.Debuff.Seed = KBM.Language:Add("Seed of Madness")
TGR.Lang.Debuff.Seed:SetFrench("Germe de folie")
-- TGR.Lang.Debuff.Convinction = KBM.Language:Add("Nightmare Convinction")
-- TGR.Lang.Debuff.Convinction:SetFrench("Conviction cauchemardesque")


-- Description Dictionary
TGR.Lang.Main = {}

TGR.Descript = TGR.Lang.Unit.Threngar[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
TGR.Threngar = {
	Mod = TGR,
	Level = "??",
	Active = false,
	Name = TGR.Lang.Unit.Threngar[KBM.Lang],
	Dead = false,	
	Available = false,
	Menu = {},
	UTID = "U41F3C58835CFD3FF",
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
		Conduit = KBM.Defaults.AlertObj.Create("red"),	
		Offering = KBM.Defaults.AlertObj.Create("orange"),
		Binding = KBM.Defaults.AlertObj.Create("blue"),
		Convinction = KBM.Defaults.AlertObj.Create("red"),
		},
	MechRef = {
		Enabled = true,
		Conduit = KBM.Defaults.MechObj.Create("red"),
		Offering = KBM.Defaults.MechObj.Create("orange"),
		Binding = KBM.Defaults.AlertObj.Create("blue"),
		-- Glaive = KBM.Defaults.MechObj.Create("cyan"),
		},
	}
}

TGR.Akvan = {
	Mod = TGR,
	Level = "??",
	Active = false,
	Name = TGR.Lang.Unit.Akvan[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "none",
	UnitID = nil,
	Triggers = {},
	AlertsRef = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Seed = KBM.Defaults.AlertObj.Create("purple"),
			Untold = KBM.Defaults.AlertObj.Create("yellow"),
		},
		MechRef = {
			Enabled = true,
			Seed = KBM.Defaults.MechObj.Create("purple"),
			Untold = KBM.Defaults.MechObj.Create("yellow"),
		},
	},
}

function TGR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Threngar.Name] = self.Threngar,
		[self.Akvan.Name] = self.Akvan,
	}
end

function TGR:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Threngar.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		Threngar =
		{
			TimersRef = self.Threngar.Settings.TimersRef,
			AlertsRef = self.Threngar.Settings.AlertsRef,
			MechRef = self.Threngar.Settings.MechRef,
		},
		Akvan =
		{
			TimersRef = self.Akvan.Settings.TimersRef,
			AlertsRef = self.Akvan.Settings.AlertsRef,
			MechRef = self.Akvan.Settings.MechRef,
		},
	}
	KBMNTRDMSTGR_Settings = self.Settings
	chKBMNTRDMSTGR_Settings = self.Settings

end

function TGR:SwapSettings(bool)

	if bool then
		KBMNTRDMSTGR_Settings = self.Settings
		self.Settings = chKBMNTRDMSTGR_Settings
	else
		chKBMNTRDMSTGR_Settings = self.Settings
		self.Settings = KBMNTRDMSTGR_Settings
	end

end

function TGR:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSTGR_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSTGR_Settings, self.Settings)
	end

	if KBM.Options.Character then
		chKBMNTRDMSTGR_Settings = self.Settings
	else
		KBMNTRDMSTGR_Settings = self.Settings
	end	

	self.Settings.Enabled = true
end

function TGR:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSTGR_Settings = self.Settings
	else
		KBMNTRDMSTGR_Settings = self.Settings
	end	
end

function TGR:Castbar(units)
end

function TGR:RemoveUnits(UnitID)
	if self.Threngar.UnitID == UnitID then
		self.Threngar.Available = false
		return true
	end
	return false
end

function TGR:Death(UnitID)
	if self.Akvan.UnitID == UnitID then
		TGR.PhaseThree()
	elseif self.Threngar.UnitID == UnitID then
		self.Threngar.Dead = true
		return true
	end
	return false
end

function TGR.PhaseTwo()
	if TGR.Phase == 1 then
		-- TGR.PhaseObj.Objectives:Remove()
		TGR.Phase = 2
		TGR.PhaseObj:SetPhase(2)
		TGR.PhaseObj.Objectives:AddPercent(TGR.Akvan,0,100)
	end
end

function TGR.PhaseThree()
	if TGR.Phase == 2 then
		TGR.PhaseObj.Objectives:Remove()
		TGR.Phase = 3
		TGR.PhaseObj:SetPhase(3)
		TGR.PhaseObj.Objectives:AddPercent(TGR.Threngar,20,75)
	end
end

function TGR.PhaseFinal()
	if TGR.Phase == 3 then
		TGR.PhaseObj.Objectives:Remove()
		TGR.Phase = 4
		TGR.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		TGR.PhaseObj.Objectives:AddPercent(TGR.Threngar,0,20)
	end
end

function TGR:UnitHPCheck(uDetails, unitID)
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
				self.PhaseObj.Objectives:AddPercent(self.Threngar, 75, 100)
				self.Phase = 1
				local DebuffTable = {
					[1] = self.Lang.Debuff.Glaive,
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

function TGR:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Akvan.CastBar:Remove()
	self.Threngar.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function TGR:Timer()	
end

function TGRefineMenu()
	self.Menu = MS.Menu:CreateEncounter(self.Threngar, self.Enabled)
end

function TGR:Start()
	-- Create Timers
	-- KBM.Defaults.TimerObj.Assign(self.Threngar)

	-- Create Alerts
	self.Threngar.AlertsRef.Conduit = KBM.Alert:Create(self.Lang.Debuff.Conduit[KBM.Lang], nil, false, true, "red")
	self.Threngar.AlertsRef.Binding = KBM.Alert:Create(self.Lang.Debuff.Binding[KBM.Lang], nil, false, true, "blue")
	self.Threngar.AlertsRef.Offering = KBM.Alert:Create(self.Lang.Ability.Offering[KBM.Lang], nil, true, true, "orange")
	self.Akvan.AlertsRef.Seed = KBM.Alert:Create(self.Lang.Debuff.Seed[KBM.Lang], nil, false, true, "purple")
	self.Akvan.AlertsRef.Untold = KBM.Alert:Create(self.Lang.Ability.Untold[KBM.Lang], nil, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Threngar)
	KBM.Defaults.AlertObj.Assign(self.Akvan)
	-- Create Spies
	self.Threngar.MechRef.Conduit = KBM.MechSpy:Add(self.Lang.Debuff.Conduit[KBM.Lang], nil, "playerDebuff", self.Threngar)
	self.Threngar.MechRef.Binding = KBM.MechSpy:Add(self.Lang.Debuff.Binding[KBM.Lang], nil, "playerDebuff", self.Threngar)
	self.Akvan.MechRef.Seed = KBM.MechSpy:Add(self.Lang.Debuff.Seed[KBM.Lang], nil, "playerDebuff", self.Akvan)
	-- KBM.Defaults.MechObj.Assign(self.Threngar)
	KBM.Defaults.MechObj.Assign(self.Akvan)
	
	-- Create Mechanics Spies
	
	--self.Threngar.MechRef.Glaive = KBM.MechSpy:Add(self.Lang.Debuff.Glaive[KBM.Lang], 60, "playerIDDebuff", self.Threngar)
	KBM.Defaults.MechObj.Assign(self.Threngar)

	-- Assign Alerts and Timers to Triggers
	self.Threngar.Triggers.Conduit = KBM.Trigger:Create(self.Lang.Debuff.Conduit[KBM.Lang], "playerDebuff", self.Threngar)
	self.Threngar.Triggers.Conduit:AddAlert(self.Threngar.AlertsRef.Conduit, true)
	self.Threngar.Triggers.Conduit:AddSpy(self.Threngar.MechRef.Conduit)
	self.Threngar.Triggers.ConduitRem = KBM.Trigger:Create(self.Lang.Debuff.Conduit[KBM.Lang], "playerBuffRemove", self.Threngar)
	self.Threngar.Triggers.ConduitRem:AddStop(self.Threngar.AlertsRef.Conduit)
	self.Threngar.Triggers.ConduitRem:AddStop(self.Threngar.MechRef.Conduit)
	self.Threngar.Triggers.Binding = KBM.Trigger:Create(self.Lang.Debuff.BindingID, "playerDebuff", self.Threngar)
	self.Threngar.Triggers.Binding:AddAlert(self.Threngar.AlertsRef.Binding, true)
	self.Threngar.Triggers.Binding:AddSpy(self.Threngar.MechRef.Binding)
	self.Threngar.Triggers.BindingRem = KBM.Trigger:Create(self.Lang.Debuff.BindingID, "playerBuffRemove", self.Threngar)
	self.Threngar.Triggers.BindingRem:AddStop(self.Threngar.AlertsRef.Binding)
	self.Threngar.Triggers.BindingRem:AddStop(self.Threngar.MechRef.Binding)
	self.Akvan.Triggers.Seed = KBM.Trigger:Create(self.Lang.Debuff.Seed[KBM.Lang], "playerDebuff", self.Akvan)
	self.Akvan.Triggers.Seed:AddAlert(self.Akvan.AlertsRef.Seed, true)
	self.Akvan.Triggers.Seed:AddSpy(self.Akvan.MechRef.Seed)
	self.Akvan.Triggers.SeedRem = KBM.Trigger:Create(self.Lang.Debuff.Seed[KBM.Lang], "playerBuffRemove", self.Akvan)
	self.Akvan.Triggers.SeedRem:AddStop(self.Akvan.AlertsRef.Seed)
	self.Akvan.Triggers.SeedRem:AddStop(self.Akvan.MechRef.Seed)
	self.Threngar.Triggers.Offering = KBM.Trigger:Create(self.Lang.Ability.Offering[KBM.Lang], "channel", self.Threngar)
	self.Threngar.Triggers.Offering:AddAlert(self.Threngar.AlertsRef.Offering)
	-- self.Threngar.Triggers.Offering:AddStop(self.Threngar.AlertsRef.Offering)
	-- self.Threngar.Triggers.Glaive = KBM.Trigger:Create(self.Lang.Debuff.Glaive[KBM.Lang], "playerBuff", self.Threngar)
	-- self.Threngar.Triggers.Glaive:AddSpy(self.Threngar.MechRef.Glaive)
	-- self.Threngar.Triggers.GlaiveRem = KBM.Trigger:Create(self.Lang.Debuff.Glaive[KBM.Lang], "playerBuffRemove", self.Threngar)
	-- self.Threngar.Triggers.GlaiveRem:AddStop(self.Threngar.MechRef.Glaive)
	self.Akvan.Triggers.Untold = KBM.Trigger:Create(self.Lang.Ability.Untold[KBM.Lang], "cast", self.Akvan)
	self.Akvan.Triggers.Untold:AddAlert(self.Akvan.AlertsRef.Untold)
	self.Threngar.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Threngar)
	self.Threngar.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Threngar.Triggers.PhaseFinal = KBM.Trigger:Create(20, "percent", self.Threngar)
	self.Threngar.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)


	self.Threngar.CastBar = KBM.Castbar:Add(self, self.Threngar)
	self.Akvan.CastBar = KBM.Castbar:Add(self, self.Akvan)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end