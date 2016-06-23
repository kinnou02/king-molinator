-- Pagura Ithral Boss PAG for King Boss PAGs
-- Written by Maatang
-- July 2015
--

KBMNTRDMOMPAG_Settings = nil
chKBMNTRDMOMPAG_Settings = nil

-- Link PAGs
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data

if not KBM.BossMod then
	return
end

local MOM = KBM.BossMod["Mind_of_Madness"]

local PAG = {
	Directory = MOM.Directory,
	File = "Pagura.lua",
	Enabled = true,
	Instance = MOM.Name,
	InstanceObj = MOM,
	HasPhases = true,
	Lang = {},
	ID = "Pagura",
	Object = "PAG",
	Enrage = 60 * 8 + 30,
}

-- Main Unit Dictionary
PAG.Lang.Unit = {}
PAG.Lang.Unit.Pagura = KBM.Language:Add("Pagura")
PAG.Lang.Unit.Pagura:SetFrench("Pagura")
PAG.Lang.Unit.Ice = KBM.Language:Add("Ice Soul")
PAG.Lang.Unit.Ice:SetFrench("Âme de glace")
PAG.Lang.Unit.Brachy = KBM.Language:Add("Brachy")
PAG.Lang.Unit.Brachy:SetFrench("Brachy")
PAG.Lang.Unit.Crustok = KBM.Language:Add("Crustok")
PAG.Lang.Unit.Crustok:SetFrench("Crustok")

-- Ability Dictionary
PAG.Lang.Ability = {}
PAG.Lang.Ability.Curse4 = KBM.Language:Add("Curse of Four")
PAG.Lang.Ability.Curse4:SetFrench("Malédiction des quatre")
PAG.Lang.Ability.Curse5 = KBM.Language:Add("Curse of Five")
PAG.Lang.Ability.Curse5:SetFrench("Malédiction des cinq")
PAG.Lang.Ability.Curse6 = KBM.Language:Add("Curse of Six")
PAG.Lang.Ability.Curse6:SetFrench("Malédiction des six")
PAG.Lang.Ability.Contagion = KBM.Language:Add("Rapid Contagion")
PAG.Lang.Ability.Contagion:SetFrench("Contagion bondissante")
PAG.Lang.Ability.Roar = KBM.Language:Add("Shattering Roar")
PAG.Lang.Ability.Roar:SetFrench("Rugissement destructeur")

-- Verbose Dictionary
PAG.Lang.Verbose = {}
PAG.Lang.Verbose.Column = KBM.Language:Add("")
PAG.Lang.Verbose.Column:SetFrench("La Colonne de glace commence à vibrer à une fréaquence élevée.")

-- Buff Dictionary
PAG.Lang.Buff = {}
PAG.Lang.Buff.Fortified = KBM.Language:Add("Fortified Shell")

-- Debuff Dictionary
PAG.Lang.Debuff = {}
PAG.Lang.Debuff.Nerve = KBM.Language:Add("Nerve Pinch")
PAG.Lang.Debuff.Nerve:SetFrench("Pincée nerveuse")
PAG.Lang.Debuff.Pain = KBM.Language:Add("Pain Bringer")
PAG.Lang.Debuff.Pain:SetFrench("Porte-douleur")
PAG.Lang.Debuff.MBrachy = KBM.Language:Add("Curse of Brachy")
PAG.Lang.Debuff.MBrachy:SetFrench("Malédiction de Brachy")
PAG.Lang.Debuff.MCrustok = KBM.Language:Add("Curse of Crustok")
PAG.Lang.Debuff.MCrustok:SetFrench("Malédiction de Crustok")
PAG.Lang.Debuff.Poisoning = KBM.Language:Add("Okadaic Poisoning")
PAG.Lang.Debuff.Poisoning:SetFrench("Empoisonnement de Okadaic")


-- Description Dictionary
PAG.Lang.Main = {}
PAG.Descript = PAG.Lang.Unit.Pagura[KBM.Lang]

PAG.Pagura = {
	Mod = PAG,
	Level = "??",
	Active = false,
	Name = PAG.Lang.Unit.Pagura[KBM.Lang],
	-- NameShort = "Pagura",
	Menu = {},
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U5588CDFC4C08084D",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			Curse4 = KBM.Defaults.AlertObj.Create("red"),
			Curse5 = KBM.Defaults.AlertObj.Create("red"),
			Curse6 = KBM.Defaults.AlertObj.Create("red"),
			Contagion = KBM.Defaults.AlertObj.Create("dark_green"), -- 12 / 20s cd
			Roar = KBM.Defaults.AlertObj.Create("orange"),
			Poisoning = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Poisoning = KBM.Defaults.MechObj.Create("purple"),
		},
		TimersRef = {
			Enabled = true,
			RoarFirst = KBM.Defaults.TimerObj.Create("orange"), -- 1m /1.10 cd
			Roar = KBM.Defaults.TimerObj.Create("orange"),
			Curse4First = KBM.Defaults.TimerObj.Create("red"), -- 8s /35s de cd
			Curse4 = KBM.Defaults.TimerObj.Create("red"),
			Curse5 = KBM.Defaults.TimerObj.Create("red"),
			Curse6First = KBM.Defaults.TimerObj.Create("red"),
			Curse6 = KBM.Defaults.TimerObj.Create("red"),
			ContagionFirst = KBM.Defaults.TimerObj.Create("dark_green"),
			Contagion = KBM.Defaults.TimerObj.Create("dark_green"),
			ContagionP4 = KBM.Defaults.TimerObj.Create("dark_green"),
			PoisoningFirst = KBM.Defaults.TimerObj.Create("purple"),
			Poisoning = KBM.Defaults.TimerObj.Create("purple"),
		},
	},
}

PAG.Ice = {
	Mod = PAG,
	Level = "??",
	Name = PAG.Lang.Unit.Ice[KBM.Lang],
	UnitList = {},
	Menu = {},
	AlertsRef = {},
	UTID = "U604068D24CC22A94",
	Ignore = true,
	Type = "multi",
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
		},
	}
}

PAG.Brachy = {
	Mod = PAG,
	Level = "??",
	Active = false,
	Name = PAG.Lang.Unit.Brachy[KBM.Lang],
	-- NameShort = "Brachy",
	Menu = {},
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U50D54CD171D9D26A",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			BPain = KBM.Defaults.AlertObj.Create("cyan"), -- 7s/ 15s cd
		},
		MechRef = {
			Enabled = true,
			BPain = KBM.Defaults.MechObj.Create("cyan"),
		},
		TimersRef = {
			Enabled = true,
			BPainFirst = KBM.Defaults.TimerObj.Create("cyan"),
			BPain = KBM.Defaults.TimerObj.Create("cyan"),
		},
	},
}

PAG.Crustok = {
	Mod = PAG,
	Level = "??",
	Active = false,
	Name = PAG.Lang.Unit.Crustok[KBM.Lang],
	-- NameShort = "Crustok",
	Menu = {},
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U2B75B2CB73ED8E64",
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			CPain = KBM.Defaults.AlertObj.Create("cyan"),
		},
		MechRef = {
			Enabled = true,
			CPain = KBM.Defaults.MechObj.Create("cyan"),
		},
		TimersRef = {
			Enabled = true,
			CPainFirst = KBM.Defaults.TimerObj.Create("cyan"),
			CPain = KBM.Defaults.TimerObj.Create("cyan"),
		},
	},
}



KBM.RegisterMod(PAG.ID, PAG)

function PAG:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Pagura.Name] = self.Pagura,
		[self.Ice.Name] = self.Ice,
		[self.Brachy.Name] = self.Brachy,
		[self.Crustok.Name] = self.Crustok,
	}
end

function PAG:InitVars()
	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		MechSpy = KBM.Defaults.MechSpy(),
		Alerts = KBM.Defaults.Alerts(),
		Pagura = {
			CastBar = self.Pagura.Settings.CastBar,
			TimersRef = self.Pagura.Settings.TimersRef,
			AlertsRef = self.Pagura.Settings.AlertsRef,
			MechRef = self.Pagura.Settings.MechRef,
		},
		Ice = {
			CastBar = self.Ice.Settings.CastBar,
			TimersRef = self.Ice.Settings.TimersRef,
			AlertsRef = self.Ice.Settings.AlertsRef,
		},
		Brachy = {
			CastBar = self.Brachy.Settings.CastBar,
			TimersRef = self.Brachy.Settings.TimersRef,
			AlertsRef = self.Brachy.Settings.AlertsRef,
			MechRef = self.Brachy.Settings.MechRef,
		},
		Crustok = {
			CastBar = self.Crustok.Settings.CastBar,
			TimersRef = self.Crustok.Settings.TimersRef,
			AlertsRef = self.Crustok.Settings.AlertsRef,
			MechRef = self.Crustok.Settings.MechRef,
		},
	}
	KBMNTRDMOMPAG_Settings = self.Settings
	chKBMNTRDMOMPAG_Settings = self.Settings
	
end

function PAG:SwapSettings(bool)

	if bool then
		KBMNTRDMOMPAG_Settings = self.Settings
		self.Settings = chKBMNTRDMOMPAG_Settings
	else
		chKBMNTRDMOMPAG_Settings = self.Settings
		self.Settings = KBMNTRDMOMPAG_Settings
	end

end

function PAG:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMOMPAG_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMOMPAG_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDMOMPAG_Settings = self.Settings
	else
		KBMNTRDMOMPAG_Settings = self.Settings
	end	
end

function PAG:SaveVars()	
	if KBM.Options.Character then
		chKBMNTRDMOMPAG_Settings = self.Settings
	else
		KBMNTRDMOMPAG_Settings = self.Settings
	end	
end

function PAG:Castbar(units)
end

function PAG:RemoveUnits(UnitID)
	if self.Pagura.UnitID == UnitID then
		self.Pagura.Available = false
		return true
	end
	return false
end

function PAG:Death(UnitID)
	if self.Pagura.UnitID == UnitID then
		self.Pagura.Dead = true
		return true
	elseif self.Crustok.UnitID == UnitID then
		self.Crustok.Dead = true
		if self.Brachy.Dead == true then
			self.PhaseFinal()
		end
		return false
	elseif self.Brachy.UnitID == UnitID then
		self.Brachy.Dead = true
		if self.Crustok.Dead == true then
			self.PhaseFinal()
		end
		return false
	end
	return false
end

function PAG.PhaseTwo()
	PAG.Phase = 3
	PAG.PhaseObj.Objectives:Remove()
	PAG.PhaseObj:SetPhase(3)
	PAG.PhaseObj.Objectives:AddPercent(PAG.Pagura, 40, 75)
	PAG.Pagura.TimersRef.Curse4:Stop()
end

function PAG.PhaseThree()
	KBM.TankSwap:Remove()
	PAG.Phase = 2
	PAG.PhaseObj.Objectives:Remove()
	PAG.PhaseObj:SetPhase(2)
	PAG.PhaseObj.Objectives:AddPercent(PAG.Brachy, 0, 100)
	PAG.PhaseObj.Objectives:AddPercent(PAG.Crustok, 0, 100)
	local DebuffTable = {
		[1] = PAG.Lang.Debuff.MBrachy[KBM.Lang],
		[2] = PAG.Lang.Debuff.MCrustok[KBM.Lang],
	}
	KBM.TankSwap:Start(DebuffTable, unitID)
	PAG.Pagura.TimersRef.Curse5:Stop()
end

function PAG.PhaseFinal()
	PAG.Phase = 4
	PAG.PhaseObj.Objectives:Remove()
	PAG.PhaseObj:SetPhase(4)
	PAG.PhaseObj.Objectives:AddPercent(PAG.Pagura, 0, 40)
	KBM.TankSwap:Remove()
	KBM.TankSwap:Start(self.Lang.Debuff.Nerve[KBM.Lang], unitID)
	KBM.MechTimer:AddStart(self.Pagura.TimersRef.Curse6First)
	KBM.MechTimer:AddStart(self.Pagura.TimersRef.ContagionP4)
end

function PAG:UnitHPCheck(uDetails, unitID)
	-- print("Pagura OK")
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Pagura.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Pagura.Dead = false
					self.Pagura.Casting = false
					self.Pagura.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase(1)
					self.PhaseObj.Objectives:AddPercent(self.Pagura, 75, 100)
					KBM.TankSwap:Start(self.Lang.Debuff.Nerve[KBM.Lang], unitID)
					KBM.MechTimer:AddStart(self.Pagura.TimersRef.Curse4First)
					KBM.MechTimer:AddStart(self.Pagura.TimersRef.ContagionFirst)
					KBM.MechTimer:AddStart(self.Pagura.TimersRef.RoarFirst)
					self.Phase = 1
				end
				self.Pagura.UnitID = unitID
				self.Pagura.Available = true
				return self.Pagura
			end
		end
	end
end

function PAG:Reset()
	self.EncounterRunning = false
	self.Pagura.Available = false
	self.Pagura.UnitID = nil
	self.Pagura.CastBar:Remove()
		
	self.PhaseObj:End(Inspect.Time.Real())
end

function PAG:Timer()	
end




function PAG:Start()
	-- Create Timers
	
	self.Pagura.TimersRef.Curse4First = KBM.MechTimer:Add(self.Lang.Ability.Curse4[KBM.Lang], 8)
	self.Pagura.TimersRef.Curse4First:NoMenu()
	self.Pagura.TimersRef.Curse4 = KBM.MechTimer:Add(self.Lang.Ability.Curse4[KBM.Lang], 35)
	self.Pagura.TimersRef.Curse5 = KBM.MechTimer:Add(self.Lang.Ability.Curse5[KBM.Lang], 35)
	self.Pagura.TimersRef.Curse5:SetPhase(2)
	self.Pagura.TimersRef.Curse6First = KBM.MechTimer:Add(self.Lang.Ability.Curse6[KBM.Lang], 12)
	self.Pagura.TimersRef.Curse6First:SetPhase(4)
	self.Pagura.TimersRef.Curse6First:NoMenu()
	self.Pagura.TimersRef.Curse6 = KBM.MechTimer:Add(self.Lang.Ability.Curse6[KBM.Lang], 40)
	self.Pagura.TimersRef.Curse6:SetPhase(4)
	self.Pagura.TimersRef.ContagionFirst = KBM.MechTimer:Add(self.Lang.Ability.Contagion[KBM.Lang], 12)
	self.Pagura.TimersRef.ContagionFirst:NoMenu()
	self.Pagura.TimersRef.ContagionP4 = KBM.MechTimer:Add(self.Lang.Ability.Contagion[KBM.Lang], 8)
	self.Pagura.TimersRef.ContagionP4:NoMenu()
	self.Pagura.TimersRef.Contagion = KBM.MechTimer:Add(self.Lang.Ability.Contagion[KBM.Lang], 20)
	self.Pagura.TimersRef.PoisoningFirst = KBM.MechTimer:Add(self.Lang.Debuff.Poisoning[KBM.Lang], 58)
	self.Pagura.TimersRef.PoisoningFirst:NoMenu()
	self.Pagura.TimersRef.Poisoning = KBM.MechTimer:Add(self.Lang.Debuff.Poisoning[KBM.Lang], 58)
	self.Pagura.TimersRef.RoarFirst = KBM.MechTimer:Add(self.Lang.Ability.Roar[KBM.Lang], 60)
	self.Pagura.TimersRef.RoarFirst:NoMenu()
	self.Pagura.TimersRef.Roar = KBM.MechTimer:Add(self.Lang.Ability.Roar[KBM.Lang], 70)
	KBM.Defaults.TimerObj.Assign(self.Pagura)
	
	self.Brachy.TimersRef.BPainFirst = KBM.MechTimer:Add("Brachy: First " .. self.Lang.Debuff.Pain[KBM.Lang], 7)
	self.Brachy.TimersRef.BPainFirst:NoMenu()
	self.Brachy.TimersRef.BPain = KBM.MechTimer:Add("Brachy: ".. self.Lang.Debuff.Pain[KBM.Lang], 15)
	KBM.Defaults.TimerObj.Assign(self.Brachy)
	
	self.Crustok.TimersRef.CPainFirst = KBM.MechTimer:Add("Crustok: First " .. self.Lang.Debuff.Pain[KBM.Lang], 7)
	self.Crustok.TimersRef.CPainFirst:NoMenu()
	self.Crustok.TimersRef.CPain = KBM.MechTimer:Add("Crustok: " .. self.Lang.Debuff.Pain[KBM.Lang], 15)
	KBM.Defaults.TimerObj.Assign(self.Crustok)
	
	-- Create Spies
	
	self.Pagura.MechRef.Poisoning = KBM.MechSpy:Add(self.Lang.Debuff.Poisoning[KBM.Lang], nil, "playerDebuff", self.Pagura)
	KBM.Defaults.MechObj.Assign(self.Pagura)
	
	self.Brachy.MechRef.BPain = KBM.MechSpy:Add("Brachy: "..self.Lang.Debuff.Pain[KBM.Lang], 5, "playerDebuff", self.Brachy)
	KBM.Defaults.MechObj.Assign(self.Brachy)
	
	self.Crustok.MechRef.CPain = KBM.MechSpy:Add("Crustok: " .. self.Lang.Debuff.Pain[KBM.Lang], 5, "playerDebuff", self.Crustok)
	KBM.Defaults.MechObj.Assign(self.Crustok)
	
	-- Create Alerts

	self.Pagura.AlertsRef.Curse4 = KBM.Alert:Create(self.Lang.Ability.Curse4[KBM.Lang], nil, false, true, "red")
	self.Pagura.AlertsRef.Curse5 = KBM.Alert:Create(self.Lang.Ability.Curse5[KBM.Lang], nil, false, true, "red")
	self.Pagura.AlertsRef.Curse6 = KBM.Alert:Create(self.Lang.Ability.Curse6[KBM.Lang], nil, false, true, "red")
	self.Pagura.AlertsRef.Contagion = KBM.Alert:Create(self.Lang.Ability.Contagion[KBM.Lang], nil, false, true, "dark_green")
	self.Pagura.AlertsRef.Poisoning = KBM.Alert:Create(self.Lang.Debuff.Poisoning[KBM.Lang], nil, false, true, "purple")
	self.Pagura.AlertsRef.Roar = KBM.Alert:Create(self.Lang.Ability.Roar[KBM.Lang], nil, false, true, "orange")
	KBM.Defaults.AlertObj.Assign(self.Pagura)
	
	self.Brachy.AlertsRef.BPain = KBM.Alert:Create(self.Lang.Debuff.Pain[KBM.Lang], nil, false, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Brachy)
	
	self.Crustok.AlertsRef.CPain = KBM.Alert:Create(self.Lang.Debuff.Pain[KBM.Lang], nil, false, true, "cyan")
	KBM.Defaults.AlertObj.Assign(self.Crustok)
	
	
	-- Assign Alerts and Timers to Triggers

	self.Pagura.Triggers.PhaseTwo = KBM.Trigger:Create(75, "percent", self.Pagura)
	self.Pagura.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Pagura.Triggers.PhaseTwo:AddTimer(self.Pagura.TimersRef.Curse5)
	self.Pagura.Triggers.PhaseThree = KBM.Trigger:Create(40, "percent", self.Pagura)
	self.Pagura.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Pagura.Triggers.PhaseThree:AddTimer(self.Brachy.TimersRef.BPainFirst)
	self.Pagura.Triggers.PhaseThree:AddTimer(self.Crustok.TimersRef.CPainFirst)
	
	self.Pagura.Triggers.Curse4 = KBM.Trigger:Create(self.Lang.Ability.Curse4[KBM.Lang],"cast",self.Pagura)
	self.Pagura.Triggers.Curse4:AddAlert(self.Pagura.AlertsRef.Curse4)
	self.Pagura.Triggers.Curse4:AddTimer(self.Pagura.TimersRef.Curse4)
	
	self.Pagura.Triggers.Curse5 = KBM.Trigger:Create(self.Lang.Ability.Curse5[KBM.Lang],"cast",self.Pagura)
	self.Pagura.Triggers.Curse5:AddAlert(self.Pagura.AlertsRef.Curse5)
	self.Pagura.Triggers.Curse5:AddTimer(self.Pagura.TimersRef.Curse5)
	
	self.Pagura.Triggers.Curse6 = KBM.Trigger:Create(self.Lang.Ability.Curse6[KBM.Lang],"cast",self.Pagura)
	self.Pagura.Triggers.Curse6:AddAlert(self.Pagura.AlertsRef.Curse6)
	self.Pagura.Triggers.Curse6:AddTimer(self.Pagura.TimersRef.Curse6)
	
	self.Pagura.Triggers.Roar = KBM.Trigger:Create(self.Lang.Ability.Roar[KBM.Lang],"cast",self.Pagura)
	self.Pagura.Triggers.Roar:AddAlert(self.Pagura.AlertsRef.Roar)
	self.Pagura.Triggers.Roar:AddTimer(self.Pagura.TimersRef.Roar)
	
	self.Pagura.Triggers.Contagion = KBM.Trigger:Create(self.Lang.Ability.Contagion[KBM.Lang],"cast",self.Pagura)
	self.Pagura.Triggers.Contagion:AddAlert(self.Pagura.AlertsRef.Contagion)
	self.Pagura.Triggers.Contagion:AddTimer(self.Pagura.TimersRef.Contagion)
	
	self.Pagura.Triggers.Poisoning = KBM.Trigger:Create(self.Lang.Debuff.Poisoning[KBM.Lang],"playerDebuff",self.Pagura)
	self.Pagura.Triggers.Poisoning:AddAlert(self.Pagura.AlertsRef.Poisoning,true)
	self.Pagura.Triggers.Poisoning:AddSpy(self.Pagura.MechRef.Poisoning)
	self.Pagura.Triggers.Poisoning:AddTimer(self.Pagura.TimersRef.Poisoning)
	self.Pagura.Triggers.PoisoningRem = KBM.Trigger:Create(self.Lang.Debuff.Poisoning[KBM.Lang],"playerBuffRemove",self.Pagura)
	self.Pagura.Triggers.PoisoningRem:AddStop(self.Pagura.AlertsRef.Poisoning)
	self.Pagura.Triggers.PoisoningRem:AddStop(self.Pagura.MechRef.Poisoning)
	
	self.Brachy.Triggers.BPain = KBM.Trigger:Create(self.Lang.Debuff.Pain[KBM.Lang],"playerDebuff",self.Brachy)
	self.Brachy.Triggers.BPain:AddAlert(self.Brachy.AlertsRef.BPain,true)
	self.Brachy.Triggers.BPain:AddSpy(self.Brachy.MechRef.BPain)
	self.Brachy.Triggers.BPain:AddTimer(self.Brachy.TimersRef.BPain)
	self.Brachy.Triggers.BPainRem = KBM.Trigger:Create(self.Lang.Debuff.Pain[KBM.Lang],"playerBuffRemove",self.Brachy)
	self.Brachy.Triggers.BPain:AddStop(self.Brachy.AlertsRef.BPain)
	
	self.Crustok.Triggers.CPain = KBM.Trigger:Create(self.Lang.Debuff.Pain[KBM.Lang],"playerDebuff",self.Crustok)
	self.Crustok.Triggers.CPain:AddAlert(self.Crustok.AlertsRef.CPain,true)
	self.Crustok.Triggers.CPain:AddSpy(self.Crustok.MechRef.CPain)
	self.Crustok.Triggers.CPain:AddStop(self.Crustok.TimersRef.CPain)
	self.Crustok.Triggers.CPainRem = KBM.Trigger:Create(self.Lang.Debuff.Pain[KBM.Lang],"playerBuffRemove",self.Crustok)
	self.Crustok.Triggers.CPain:AddStop(self.Crustok.AlertsRef.CPain)
	self.Crustok.Triggers.CPain:AddStop(self.Crustok.MechRef.CPain)
	
	self.Pagura.CastBar = KBM.Castbar:Add(self, self.Pagura)
	self.Brachy.CastBar = KBM.Castbar:Add(self, self.Brachy)
	self.Crustok.CastBar = KBM.Castbar:Add(self, self.Crustok)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end