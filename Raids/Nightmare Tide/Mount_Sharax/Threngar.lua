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
	PlatformHealth = 0,
	PlatformCounter = 0,
	PlatformCountObj = nil,
	ThrengarCurrentHealth = 0,
}

KBM.RegisterMod(TGR.ID, TGR)

-- Main Unit Dictionary
TGR.Lang.Unit = {}
TGR.Lang.Unit.Threngar = KBM.Language:Add("Threngar")
TGR.Lang.Unit.Akvan = KBM.Language:Add("Akvan Monstrosity")
TGR.Lang.Unit.Akvan:SetFrench("Monstruosité akvan")

-- Ability Dictionary
TGR.Lang.Ability = {}
TGR.Lang.Ability.Offering = KBM.Language:Add("Sacrificial Offering") 	-- kick threngar
TGR.Lang.Ability.Offering:SetFrench("Offrandes sacrificielles")
TGR.Lang.Ability.Binding = KBM.Language:Add("Dark Binding")				-- Meteor stack
TGR.Lang.Ability.Binding:SetFrench("Lien sombre")
TGR.Lang.Ability.Untold = KBM.Language:Add("Untold Horror")				-- kick akvan
TGR.Lang.Ability.Untold:SetFrench("Horreur indicible")
TGR.Lang.Ability.Condemn = KBM.Language:Add("Condemn") 					-- reflect - cast
TGR.Lang.Ability.Condemn:SetFrench("Condamnation")
TGR.Lang.Ability.Left = KBM.Language:Add("Left Claw")
TGR.Lang.Ability.Left:SetFrench("Griffe gauche")
TGR.Lang.Ability.Right = KBM.Language:Add("Right Claw")
TGR.Lang.Ability.Right:SetFrench("Griffe droite")
TGR.Lang.Ability.Gaze = KBM.Language:Add("Gaze of Martrodraum")


-- Verbose Dictionary
TGR.Lang.Verbose = {}
TGR.Lang.Verbose.KilledPlatform = KBM.Language:Add("Platform:")
TGR.Lang.Verbose.KilledPlatform:SetFrench("Platforme:")

-- Buff Dictionary
TGR.Lang.Buff = {}

-- Debuff Dictionary
TGR.Lang.Debuff = {}
TGR.Lang.Debuff.Conduit = KBM.Language:Add("Conduit of Martrodraum")	-- dispell
TGR.Lang.Debuff.Conduit:SetFrench("Conduit de Martrodraum")
TGR.Lang.Debuff.Glaive = KBM.Language:Add("Shadow Glaive")				-- debuff stack tank
TGR.Lang.Debuff.Glaive:SetFrench("Guisarme de l'Ombre")
--TGR.Lang.Debuff.GlaiveID = ""
TGR.Lang.Debuff.Convinction = KBM.Language:Add("Nightmare Convinction")	-- purge
TGR.Lang.Debuff.Convinction:SetFrench("Conviction cauchemardesque")
TGR.Lang.Debuff.Binding = KBM.Language:Add("Dark Binding")
TGR.Lang.Debuff.Binding:SetFrench("Lien sombre")
TGR.Lang.Debuff.BindingID = "b800000001740DAD7"
TGR.Lang.Debuff.Seed = KBM.Language:Add("Seed of Madness")
TGR.Lang.Debuff.Seed:SetFrench("Germe de folie")
TGR.Lang.Debuff.Sphere = KBM.Language:Add("Event Horizon") 		-- debuff platforms
TGR.Lang.Debuff.Sphere:SetFrench("Horizon des événements") 
TGR.Lang.Debuff.AuraHorro = KBM.Language:Add("Aura of Horror")
TGR.Lang.Debuff.Bubbles = KBM.Language:Add("Freezing Void") 			-- debuff zone p2 -- "playerDebuff"


-- Say dictionnary

TGR.Lang.Say ={}
TGR.Lang.Say.Martrodraum = KBM.Language:Add("Martrodraum flies into a rage!")
TGR.Lang.Say.Martrodraum:SetFrench("Martrodraum est fou de rage !")

-- Description Dictionary
TGR.Lang.Main = {}

TGR.Lang.Messages = {}
TGR.Lang.Messages.Sphere = KBM.Language:Add("MOVE!!!!")
TGR.Lang.Messages.Sphere:SetFrench("BOUGEZ!!!!")
TGR.Lang.Messages.Out = KBM.Language:Add("Out of Green!")
TGR.Lang.Messages.Out:SetFrench("Sortez!!")

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
	TimersRef = {},	
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		TimersRef =
		{
			Enabled = true,
			Condemn = KBM.Defaults.TimerObj.Create("dark_green"),
			Condemn2 = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		AlertsRef = 
		{
			Enabled = true,
			Conduit = KBM.Defaults.AlertObj.Create("red"),	
			Offering = KBM.Defaults.AlertObj.Create("orange"),
			Binding = KBM.Defaults.AlertObj.Create("blue"),
			Convinction = KBM.Defaults.AlertObj.Create("pink"),
			--Sphere = KBM.Defaults.AlertObj.Create("dark_green"),
			Condemn = KBM.Defaults.AlertObj.Create("dark_green"),
			Bubbles = KBM.Defaults.AlertObj.Create("cyan"),
			Out = KBM.Defaults.AlertObj.Create("red"),
		},
		MechRef = 
		{
			Enabled = true,
			Bubbles = KBM.Defaults.MechObj.Create("cyan"),
			Conduit = KBM.Defaults.MechObj.Create("red"),
			Offering = KBM.Defaults.MechObj.Create("orange"),
			Binding = KBM.Defaults.MechObj.Create("blue"),
			-- Glaive = KBM.Defaults.MechObj.Create("cyan"),
		},
	},
}

TGR.Akvan = {
	Mod = TGR,
	Level = "??",
	Active = false,
	Name = TGR.Lang.Unit.Akvan[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U7D7E31EB7A454767",
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

TGR.Martrodraum = {
	Mod = TGR,
	Level = "??",
	Active = false,
	Name = "Martrodraum",
	Dead = false,
	Available = false,
	Menu = {},
	UTID = "U6A5DA1D422505609",
	UnitID = nil,
	Triggers = {},
	AlertsRef = {},
	MechRef = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
		},
		MechRef = {
			Enabled = true,
		},
	},
}


function TGR:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Threngar.Name] = self.Threngar,
		[self.Akvan.Name] = self.Akvan,
		[self.Martrodraum.Name] = self.Martrodraum,
	}
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end	
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
			CastBar = self.Threngar.Settings.CastBar,
		},
		Akvan =
		{
			TimersRef = self.Akvan.Settings.TimersRef,
			AlertsRef = self.Akvan.Settings.AlertsRef,
			MechRef = self.Akvan.Settings.MechRef,
			CastBar = self.Akvan.Settings.CastBar,
		},
		Martrodraum = 
		{
			CastBar = self.Martrodraum.Settings.CastBar,
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
		if TGR.PlatformCountObj == nil then
			TGR.PlatformCountObj = TGR.PhaseObj.Objectives:AddMeta(TGR.Lang.Say.Martrodraum[KBM.Lang], 7,0 )
		else
			TGR.PlatformCountObj:Update(TGR.PlatformCount)
		end
	end
end

function TGR.PhaseFinal()
	if TGR.Phase == 3 then
		TGR.PhaseObj.Objectives:Remove()
		TGR.Phase = 4
		TGR.PhaseObj:SetPhase(KBM.Language.Options.Final[KBM.Lang])
		--TGR.ThrengarCurrentHealth = math.ceil((Inspect.Unit.Detail('u800000037306E4C5').health * 100) / Inspect.Unit.Detail('u800000037306E4C5').healthMax)
		-- print (self.ThrengarCurrentHealth)
		TGR.PhaseObj.Objectives:AddPercent(TGR.Threngar,0, TGR.Threngar.UnitObj.PercentFlat)
	end
end

function TGR.PlatformCount()
	TGR.PlatformCounter = TGR.PlatformCounter + 1
	TGR.PlatformCountObj:Update(TGR.PlatformCounter)
	if TGR.PlatformCounter == 7 then
		TGR.PhaseFinal()
	end
end

function TGR:LeftClaw()
	TGR.PlatformHealth = TGR.PlatformHealth + 1
	print("Left Claw | " .. TGR.PlatformHealth)
	if TGR.PlatformHealth == 8 then
		print("Resetting PlatformHealth...")
		TGR.PlatformCount = 0
	end
end

function TGR:RightClaw()
	TGR.PlatformHealth = TGR.PlatformHealth + 1
	print("Right Claw | " .. TGR.PlatformHealth)
	if TGR.PlatformHealth == 8 then
		print("Resetting PlatformHealth...")
		TGR.PlatformHealth = 0
	end
end

 function TGR:Gaze()
	--TGR.PlatformCount = TGR.PlatformCount + 1
	print("Gaze of Martrodraum") --.. TGR.PlatformCount)
	--print("PlatformCount = 8 | " .. TGR.PlatformCount == 8)
	--if TGR.PlatformCount == 8 then
	--	print("Resetting PlatformCount...")
	--	TGR.PlatformCount = TGR.PlatformCount - 8
	--end
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
					[1] = self.Lang.Debuff.Glaive[KBM.Lang],
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
	TGR.PlatformCountObj = nil
	TGR.PlatformCounter = 0
end

function TGR:Timer()	
end

function TGRefineMenu()
	self.Menu = MS.Menu:CreateEncounter(self.Threngar, self.Enabled)
end

function TGR:Start()
	-- Create Timers
	-- self.Threngar.TimersRef.Condemn = KBM.MechTimer:Add(self.Lang.Ability.Condemn[KBM.Lang], 37)
	-- self.Threngar.TimersRef.Condemn2 = KBM.MechTimer:Add(self.Lang.Ability.Condemn[KBM.Lang], 19)
	-- KBM.Defaults.TimerObj.Assign(self.Threngar)

	-- Create Alerts
	self.Threngar.AlertsRef.Conduit = KBM.Alert:Create(self.Lang.Debuff.Conduit[KBM.Lang], nil, false, true, "red")
	self.Threngar.AlertsRef.Binding = KBM.Alert:Create(self.Lang.Debuff.Binding[KBM.Lang], nil, false, true, "blue")
	self.Threngar.AlertsRef.Offering = KBM.Alert:Create(self.Lang.Ability.Offering[KBM.Lang], nil, true, true, "orange")
	-- self.Threngar.AlertsRef.Sphere = KBM.Alert:Create(self.Lang.Messages.Sphere[KBM.Lang], nil, true, false, "dark_green")
	self.Threngar.AlertsRef.Condemn = KBM.Alert:Create(self.Lang.Ability.Condemn[KBM.Lang], nil, true, true, "dark_green")
	self.Threngar.AlertsRef.Bubbles = KBM.Alert:Create(self.Lang.Debuff.Bubbles[KBM.Lang], 2, true, false, "cyan")	
	self.Threngar.AlertsRef.Convinction = KBM.Alert:Create(TGR.Lang.Debuff.Convinction[KBM.Lang], nil, true, true, "pink")
	self.Akvan.AlertsRef.Seed = KBM.Alert:Create(self.Lang.Debuff.Seed[KBM.Lang], nil, false, true, "purple")
	self.Akvan.AlertsRef.Untold = KBM.Alert:Create(self.Lang.Ability.Untold[KBM.Lang], nil, true, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Threngar)
	KBM.Defaults.AlertObj.Assign(self.Akvan)
	-- Create Spies
	
	self.Threngar.MechRef.Conduit = KBM.MechSpy:Add(self.Lang.Debuff.Conduit[KBM.Lang], nil, "playerDebuff", self.Threngar)
	self.Threngar.MechRef.Binding = KBM.MechSpy:Add(self.Lang.Debuff.Binding[KBM.Lang], nil, "playerDebuff", self.Threngar)
	self.Threngar.MechRef.Bubbles = KBM.MechSpy:Add(self.Lang.Debuff.Bubbles[KBM.Lang], nil, "playerDebuff", self.Threngar)
	self.Akvan.MechRef.Seed = KBM.MechSpy:Add(self.Lang.Debuff.Seed[KBM.Lang], nil, "playerDebuff", self.Akvan)
	KBM.Defaults.MechObj.Assign(self.Threngar)
	KBM.Defaults.MechObj.Assign(self.Akvan)
	
	-- Create Mechanics Spies


	-- Assign Alerts and Timers to Triggers
		-- Phase Two Warning
			-- self.Threngar.Triggers.Out = KBM.Trigger:Create(76, "percent", self.Threngar)
			-- self.Threngar.Triggers.Out:AddAlert(self.Threngar.AlertsRef.Out)
		
		-- Conduit of Martrodraum
			self.Threngar.Triggers.Conduit = KBM.Trigger:Create(self.Lang.Debuff.Conduit[KBM.Lang], "playerDebuff", self.Threngar)
			self.Threngar.Triggers.Conduit:AddAlert(self.Threngar.AlertsRef.Conduit, true)
			self.Threngar.Triggers.Conduit:AddSpy(self.Threngar.MechRef.Conduit)
			self.Threngar.Triggers.ConduitRem = KBM.Trigger:Create(self.Lang.Debuff.Conduit[KBM.Lang], "playerBuffRemove", self.Threngar)
			self.Threngar.Triggers.ConduitRem:AddStop(self.Threngar.AlertsRef.Conduit)
			self.Threngar.Triggers.ConduitRem:AddStop(self.Threngar.MechRef.Conduit)
		
		-- Dark Binding
			self.Threngar.Triggers.Binding = KBM.Trigger:Create(self.Lang.Debuff.BindingID, "playerDebuff", self.Threngar)
			self.Threngar.Triggers.Binding:AddAlert(self.Threngar.AlertsRef.Binding, true)
			self.Threngar.Triggers.Binding:AddSpy(self.Threngar.MechRef.Binding)
			self.Threngar.Triggers.BindingRem = KBM.Trigger:Create(self.Lang.Debuff.BindingID, "playerBuffRemove", self.Threngar)
			self.Threngar.Triggers.BindingRem:AddStop(self.Threngar.AlertsRef.Binding)
			self.Threngar.Triggers.BindingRem:AddStop(self.Threngar.MechRef.Binding)
			
		-- Seed of Madness
			self.Akvan.Triggers.Seed = KBM.Trigger:Create(self.Lang.Debuff.Seed[KBM.Lang], "playerDebuff", self.Akvan)
			self.Akvan.Triggers.Seed:AddAlert(self.Akvan.AlertsRef.Seed, true)
			self.Akvan.Triggers.Seed:AddSpy(self.Akvan.MechRef.Seed)
			self.Akvan.Triggers.SeedRem = KBM.Trigger:Create(self.Lang.Debuff.Seed[KBM.Lang], "playerBuffRemove", self.Akvan)
			self.Akvan.Triggers.SeedRem:AddStop(self.Akvan.AlertsRef.Seed)
			self.Akvan.Triggers.SeedRem:AddStop(self.Akvan.MechRef.Seed)
			
		-- Sacrificial Offering
			self.Threngar.Triggers.Offering = KBM.Trigger:Create(self.Lang.Ability.Offering[KBM.Lang], "channel", self.Threngar)
			self.Threngar.Triggers.Offering:AddAlert(self.Threngar.AlertsRef.Offering)
			self.Threngar.Triggers.OfferingInt = KBM.Trigger:Create(self.Lang.Ability.Offering[KBM.Lang], "interrupt", self.Threngar)
			self.Threngar.Triggers.OfferingInt:AddStop(self.Threngar.AlertsRef.Offering)
			
		-- Untold Horror (not working in french client)
			self.Akvan.Triggers.Untold = KBM.Trigger:Create(self.Lang.Ability.Untold[KBM.Lang], "cast", self.Threngar)
			self.Akvan.Triggers.Untold:AddAlert(self.Akvan.AlertsRef.Untold)
			self.Akvan.Triggers.UntoldInt = KBM.Trigger:Create(self.Lang.Ability.Untold[KBM.Lang], "interrupt", self.Threngar)
			self.Akvan.Triggers.UntoldInt:AddStop(self.Akvan.AlertsRef.Untold)
			
		-- Event Horizon
			-- self.Threngar.Triggers.Sphere = KBM.Trigger:Create(self.Lang.Debuff.Sphere[KBM.Lang], "playerBuffRemove", self.Threngar)
			-- self.Threngar.Triggers.Sphere:AddAlert(self.Threngar.AlertsRef.Sphere, true)
			
		-- Condemn
			self.Threngar.Triggers.Condemn = KBM.Trigger:Create(self.Lang.Ability.Condemn[KBM.Lang], "cast", self.Threngar)
			self.Threngar.Triggers.Condemn:AddAlert(self.Threngar.AlertsRef.Condemn)
			
		-- Convinction
			self.Threngar.Triggers.Convinction = KBM.Trigger:Create(self.Lang.Debuff.Convinction[KBM.Lang], "buff", self.Threngar)
			self.Threngar.Triggers.Convinction:AddAlert(self.Threngar.AlertsRef.Convinction)
			self.Threngar.Triggers.ConvinctionRem = KBM.Trigger:Create(self.Lang.Debuff.Convinction[KBM.Lang], "buffRemove", self.Threngar)
			self.Threngar.Triggers.ConvinctionRem:AddStop(self.Threngar.AlertsRef.Convinction)
			
		-- Phases triggers
			self.Threngar.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Threngar)
			self.Threngar.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
			self.Threngar.Triggers.PhaseFinal = KBM.Trigger:Create(20, "percent", self.Threngar)
			self.Threngar.Triggers.PhaseFinal:AddPhase(self.PhaseFinal)

		-- Left Claw Debuff Trigger
			self.Threngar.Triggers.Left = KBM.Trigger:Create(self.Lang.Ability.Left[KBM.Lang], "channel", self.Martrodraum)
			self.Threngar.Triggers.Left:AddPhase(self.LeftClaw)
			
		-- Right Claw Debuff Trigger
			self.Threngar.Triggers.Right = KBM.Trigger:Create(self.Lang.Ability.Right[KBM.Lang], "channel", self.Martrodraum)
			self.Threngar.Triggers.Right:AddPhase(self.RightClaw)
			
		-- Gaze of Martrodraum Trigger
			self.Martrodraum.Triggers.Gaze = KBM.Trigger:Create(self.Lang.Ability.Gaze[KBM.Lang], "cast", self.Martrodraum)
			self.Martrodraum.Triggers.Gaze:AddPhase(self.Gaze)
			
		-- Platform out
			self.Threngar.Triggers.Move = KBM.Trigger:Create(self.Lang.Say.Martrodraum[KBM.Lang], "notify", self.Martrodraum)
			self.Threngar.Triggers.Move:AddPhase(self.PlatformCount)
		


	self.Threngar.CastBar = KBM.Castbar:Add(self, self.Threngar)
	self.Akvan.CastBar = KBM.Castbar:Add(self, self.Akvan)
	self.Martrodraum.CastBar = KBM.Castbar:Add(self, self.Martrodraum)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end