-- Izkinra Boss Mod for King Boss Mods
-- Written by Llien
--

KBMNTRDMSIZK_Settings = nil
chKBMNTRDMSIZK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local MS = KBM.BossMod["RMount_Sharax"]

local IZK = {
	Directory = MS.Directory,
	File = "Izkinra.lua",
	Enabled = true,
	Instance = MS.Name,
	InstanceObj = MS,
	Lang = {},
	Enrage = (4 * 60)+35,
	ID = "Izkinra",
	Object = "IZK",
	CycloneCount = 0;
	TankSwap = true
}

KBM.RegisterMod(IZK.ID, IZK)

-- Main Unit Dictionary
IZK.Lang.Unit = {}
IZK.Lang.Unit.Izkinra = KBM.Language:Add("Izkinra")
IZK.Lang.Unit.Ilrath = KBM.Language:Add("Warmaster Ilrath")
IZK.Lang.Unit.Ilrath:SetFrench("Maître de guerre Ilrath") 
IZK.Lang.Unit.Shaddoth = KBM.Language:Add("Warmaster Shaddoth")
IZK.Lang.Unit.Shaddoth:SetFrench("Maître de guerre Shaddoth") 
IZK.Lang.Unit.Cyclone = KBM.Language:Add("Living Storm")
IZK.Lang.Unit.Cyclone:SetFrench("Tempête Vivante")


-- Ability Dictionary
IZK.Lang.Ability = {}
IZK.Lang.Ability.SharaxRoar = KBM.Language:Add("Roar of the Sharax")
IZK.Lang.Ability.SharaxRoar:SetFrench("Hurlement des Sharax")
IZK.Lang.Ability.ArmorSheer = KBM.Language:Add("Armor Sheer")
IZK.Lang.Ability.ArmorSheer:SetFrench("Déchiquetage d'armure")
IZK.Lang.Ability.VorpalStrike = KBM.Language:Add("Vorpal Strike")
IZK.Lang.Ability.VorpalStrike:SetFrench("Frappe vorpale")
IZK.Lang.Ability.RazorStorm = KBM.Language:Add("Razor Storm")
IZK.Lang.Ability.RazorStorm:SetFrench("Gel éclair")
IZK.Lang.Ability.HeartStorm = KBM.Language:Add("Heart of the Storm")
IZK.Lang.Ability.HeartStorm:SetFrench("Cœur de la Tempête")

-- Verbose Dictionary
IZK.Lang.Verbose = {}
IZK.Lang.Verbose.Shriek = KBM.Language:Add("*DISTANT SHRIEK*")
IZK.Lang.Verbose.Shriek:SetFrench("*CRI LOINTAIN*")
IZK.Lang.Verbose.Wounded = KBM.Language:Add("*WOUNDED SCREAM*")
IZK.Lang.Verbose.Wounded:SetFrench("*HURLEMENT DE DOULEUR*")
IZK.Lang.Verbose.Victory = KBM.Language:Add("The avalanche has released a path...")
IZK.Lang.Verbose.Victory:SetFrench("L'avalanche a dégagé un chemin...")


-- Buff Dictionary
IZK.Lang.Buff = {}
IZK.Lang.Buff.Armor = KBM.Language:Add("Armor of the Sharax")
IZK.Lang.Buff.Armor:SetFrench("Armure des Sharax")
IZK.Lang.Buff.Will = KBM.Language:Add("Unbreakable Will") -- reduced damage by 90%
IZK.Lang.Buff.Will:SetFrench("Volonté de fer")
IZK.Lang.Buff.Storm = KBM.Language:Add("Surging Storm")
IZK.Lang.Buff.Storm:SetFrench("Tempête imminente")
IZK.Lang.Buff.Ammo = KBM.Language:Add("Carrying Ammunition")
IZK.Lang.Buff.Ammo:SetFrench("Transport de munitions")

-- Debuff Dictionary
IZK.Lang.Debuff = {}
IZK.Lang.Debuff.Bite = KBM.Language:Add("Biting Cold")  -- Tank swap on Izkinra
IZK.Lang.Debuff.Bite:SetFrench("Froid engourdissant")
IZK.Lang.Debuff.BiteID = "B546565BDEE5A72E5"
IZK.Lang.Debuff.Bleed = KBM.Language:Add("Rending Ice") -- Tank swap on Shaddoth
IZK.Lang.Debuff.Bleed:SetFrench("Déchirure de la glace")
IZK.Lang.Debuff.BleedID = "B197941B8E90C89E8"
IZK.Lang.Debuff.ArmorSheer = KBM.Language:Add("Armor Sheer")
IZK.Lang.Debuff.ArmorSheer:SetFrench("Déchiquetage d'armure")

-- Description Dictionary
IZK.Lang.Main = {}

IZK.Lang.Mechanic = {}
IZK.Lang.Mechanic.Warmasters = KBM.Language:Add("Warmasters")
IZK.Lang.Mechanic.Warmasters:SetFrench("Maitres de Guerres")
IZK.Lang.Mechanic.Cyclones = KBM.Language:Add("Harpoon")
IZK.Lang.Mechanic.Cyclones:SetFrench("Harpons")
IZK.Lang.Mechanic.Landed = KBM.Language:Add("Landed")
IZK.Lang.Mechanic.Landed:SetFrench("Atterrissage")

IZK.Descript = IZK.Lang.Unit.Izkinra[KBM.Lang]

-- Assign Boss to Language Specific Dictionary
IZK.Izkinra = {
	Mod = IZK,
	Level = "??",
	Active = false,
	Name = IZK.Lang.Unit.Izkinra[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef = {},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U372BE8676C0DBE8E",
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
		AlertsRef = {
			Enabled = true,
			RazorStorm = KBM.Defaults.AlertObj.Create("red"),
			HeartStorm = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			CarryingAmmo = KBM.Defaults.MechObj.Create("cyan"),
			Armored = KBM.Defaults.MechObj.Create("blue"),
			Bite = KBM.Defaults.MechObj.Create("dark_green"),
		},
		TimersRef = {
			Enabled = true,
			Bite = KBM.Defaults.TimerObj.Create("dark_green"),
		},
	}
}
IZK.Ilrath = {
	Mod = IZK,
	Level = "??",
	Active = false,
	Name = IZK.Lang.Unit.Ilrath[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef ={},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U1E7F1D3A589DD98B",
	UnitID = nil,
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			VorpalStrike = KBM.Defaults.AlertObj.Create("blue")
		},
	},
}

IZK.Shaddoth = {
	Mod = IZK,
	Level = "??",
	Active = false,
	Name = IZK.Lang.Unit.Shaddoth[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef ={},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "U6CCFF7963FC160AF",
	UnitID = nil,
	Triggers = {},
	Settings = {
		AlertsRef = {
			Enabled = true,
			SharaxRoar = KBM.Defaults.AlertObj.Create("red")
		},
		TimersRef = {
			Enabled = true,
			Bleed = KBM.Defaults.TimerObj.Create("dark_green"),
		},
		MechRef = {
			Enabled = true,
			SharaxRoar = KBM.Defaults.MechObj.Create("red"),
			Bleed = KBM.Defaults.MechObj.Create("dark_green"),
		},
	}
}

IZK.Cyclone = {
	Mod = IZK,
	Level = "??",
	Active = false,
	Name = IZK.Lang.Unit.Cyclone[KBM.Lang],
	Menu = {},
	Dead = false,
	AlertsRef ={},
	TimersRef = {},
	MechRef = {},
	Available = false,
	UTID = "UFF2531E23E752D92",
	UnitID = nil,
	Triggers = {},
	Settings = {},
	UnitList = {},
	Castbar = nil,
}

function IZK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Izkinra.Name] = self.Izkinra,
		[self.Ilrath.Name] = self.Ilrath,
		[self.Shaddoth.Name] = self.Shaddoth,
	}
end

function IZK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Izkinra.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		MechSpy = KBM.Defaults.MechSpy(),
		Izkinra = {
			TimersRef = self.Izkinra.Settings.TimersRef,
			AlertsRef = self.Izkinra.Settings.AlertsRef,
			MechRef = self.Izkinra.Settings.MechRef,
		},
		Ilrath = {
			TimersRef = self.Ilrath.Settings.TimersRef,
			AlertsRef = self.Ilrath.Settings.AlertsRef,
			MechRef = self.Ilrath.Settings.MechRef,
		},
		Shaddoth = {
			TimersRef = self.Shaddoth.Settings.TimersRef,
			AlertsRef = self.Shaddoth.Settings.AlertsRef,
			MechRef = self.Shaddoth.Settings.MechRef,
		},
	}
	KBMNTRDMSIZK_Settings = self.Settings
	chKBMNTRDMSIZK_Settings = self.Settings
	
end

function IZK:SwapSettings(bool)

	if bool then
		KBMNTRDMSIZK_Settings = self.Settings
		self.Settings = chKBMNTRDMSIZK_Settings
	else
		chKBMNTRDMSIZK_Settings = self.Settings
		self.Settings = KBMNTRDMSIZK_Settings
	end

end

function IZK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMNTRDMSIZK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMNTRDMSIZK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMNTRDMSIZK_Settings = self.Settings
	else
		KBMNTRDMSIZK_Settings = self.Settings
	end	
	
	self.Settings.Enabled = true
end

function IZK:SaveVars()	
	self.Enabled = true
	if KBM.Options.Character then
		chKBMNTRDMSIZK_Settings = self.Settings
	else
		KBMNTRDMSIZK_Settings = self.Settings
	end	
end

function IZK:Castbar(units)
end

function IZK.CycloneStart()
	if KBM.TankSwap.Active then
		KBM.TankSwap:Remove()
	end
	--IZK.PercentageMon:End()
	KBM.PercentageMon:End()
	IZK.PhaseObj.Objectives:Remove()
	IZK.Phase = 2
	IZK.PhaseObj:SetPhase(IZK.Lang.Mechanic.Cyclones[KBM.Lang])
end

function IZK.LandedStart()
	if KBM.TankSwap.Active then
		KBM.TankSwap:Remove()
	end	
	IZK.PhaseObj.Objectives:Remove()
	IZK.PhaseObj:SetPhase(IZK.Lang.Mechanic.Landed[KBM.Lang])
	IZK.Phase = 3
	IZK.PhaseObj.Objectives:AddPercent(IZK.Izkinra, 0, 100)
	-- start enrage timer
end

function IZK:RemoveUnits(UnitID)
	if self.Izkinra.UnitID == UnitID then
		self.Izkinra.Available = false
		return true
	end
	return false
end

function IZK:Death(UnitID)
	
	if self.Izkinra.UnitID == UnitID then
		self.Izkinra.Dead = true
		return true
	elseif self.Shaddoth.UnitID == UnitID then
		self.Shaddoth.Dead = true
		if self.Ilrath.Dead == true then
			self.CycloneStart()
		end
		return false
	elseif self.Ilrath.UnitID == UnitID then
		self.Ilrath.Dead = true
		if self.Shaddoth.Dead == true then
			self.CycloneStart()
		end
		return false
	elseif self.Cyclone.UnitList[UnitID] then
		if not self.Cyclone.UnitList[UnitID].Dead then
			self.Cyclone.UnitList[UnitID].Dead = true
			self.CycloneCount = self.CycloneCount +1
			return false
		end
	end
	return false
end

function IZK:UnitHPCheck(uDetails, unitID)	
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
				self.PhaseObj:Start(self.StartTime)
				IZK.PhaseObj:SetPhase(IZK.Lang.Mechanic.Warmasters[KBM.Lang])			
				self.PhaseObj.Objectives:AddPercent(self.Shaddoth, 0, 100)
				self.PhaseObj.Objectives:AddPercent(self.Ilrath, 0, 100)
				if BossObj == self.Shaddoth then
					self.Phase = 1
					KBM.TankSwap:Start(self.Lang.Debuff.BleedID, unitID)
				end
			else 
				if BossObj == self.Shaddoth then
					if not KBM.TankSwap.Active then
						KBM.TankSwap:Start(self.Lang.Debuff.BleedID, unitID)
					end
				elseif BossObj == self.Izkinra then 
					if not self.Phase == 3 then
						IZK.LandedStart()
					end
					if not KBM.TankSwap.Active then 
						KBM.TankSwap:Start(self.Lang.Debuff.BiteID, unitID)
					end
				end
			end
			BossObj.UnitID = unitID
			BossObj.Available = true
			return BossObj
		end
	end
end

function IZK:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
		if BossObj.CastBar then
			BossObj.CastBar:Remove()
		end
	end
	self.Cyclone.UnitList = {}
	self.PhaseObj:End(Inspect.Time.Real())
	self.Phase=1
end

function IZK:Timer()	
end

function IZK:Start()
	-- Create Timers
	IZK.Shaddoth.TimersRef.Bleed = KBM.MechTimer:Add(IZK.Lang.Debuff.Bleed[KBM.Lang], 3)
	KBM.Defaults.TimerObj.Assign(IZK.Shaddoth)
	IZK.Izkinra.TimersRef.Bite = KBM.MechTimer:Add(IZK.Lang.Debuff.Bite[KBM.Lang], 3)
	KBM.Defaults.TimerObj.Assign(IZK.Izkinra)
	
	IZK.Shaddoth.MechRef.Bleed = KBM.MechSpy:Add(IZK.Lang.Debuff.Bleed[KBM.Lang], nil, "playerDebuff", IZK.Shaddoth)
	KBM.Defaults.MechObj.Assign(IZK.Shaddoth)
	IZK.Izkinra.MechRef.Bite = KBM.MechSpy:Add(IZK.Lang.Debuff.Bite[KBM.Lang], nil, "playerDebuff", IZK.Izkinra)
	KBM.Defaults.MechObj.Assign(IZK.Izkinra)
	
	-- Create Alerts	
	IZK.Izkinra.Triggers.Landed = KBM.Trigger:Create(IZK.Lang.Verbose.Wounded[KBM.Lang], "notify", IZK.Izkinra )
	IZK.Izkinra.Triggers.Landed:AddPhase(IZK.LandedStart)
	
	IZK.Izkinra.AlertsRef.RazorStorm = KBM.Alert:Create(IZK.Lang.Ability.RazorStorm[KBM.Lang], 10, true, true, "red" )
	IZK.Izkinra.AlertsRef.HeartStorm = KBM.Alert:Create(IZK.Lang.Ability.HeartStorm[KBM.Lang], 10, true, true, "purple" )
	KBM.Defaults.AlertObj.Assign(IZK.Izkinra)
	
	IZK.Shaddoth.AlertsRef.SharaxRoar = KBM.Alert:Create(IZK.Lang.Ability.SharaxRoar[KBM.Lang], 10 , true, true, "red" )
	KBM.Defaults.AlertObj.Assign(IZK.Shaddoth)
	
	IZK.Ilrath.AlertsRef.VorpalStrike = KBM.Alert:Create(IZK.Lang.Ability.VorpalStrike[KBM.Lang], 3, true, true, "blue")
	KBM.Defaults.AlertObj.Assign(IZK.Ilrath)
	
	-- Create Spies	
	IZK.Shaddoth.Triggers.Bleed = KBM.Trigger:Create(IZK.Lang.Debuff.Bleed[KBM.Lang], "playerDebuff", IZK.Shaddoth)
	IZK.Shaddoth.Triggers.Bleed:AddTimer(IZK.Shaddoth.TimersRef.Bleed)
	IZK.Shaddoth.Triggers.Bleed:AddSpy(IZK.Shaddoth.MechRef.Bleed)
	IZK.Shaddoth.Triggers.BleedRemove = KBM.Trigger:Create(IZK.Lang.Debuff.Bleed[KBM.Lang], "playerBuffRemove", IZK.Shaddoth)
	IZK.Shaddoth.Triggers.BleedRemove:AddStop(IZK.Shaddoth.MechRef.Bleed)	

	IZK.Izkinra.Triggers.Bite = KBM.Trigger:Create(IZK.Lang.Debuff.Bite[KBM.Lang], "playerDebuff", IZK.Izkinra)
	IZK.Izkinra.Triggers.Bite:AddTimer(IZK.Izkinra.TimersRef.Bite)
	IZK.Izkinra.Triggers.Bite:AddSpy(IZK.Izkinra.MechRef.Bite)
	IZK.Izkinra.Triggers.BiteRemove = KBM.Trigger:Create(IZK.Lang.Debuff.Bite[KBM.Lang], "playerBuffRemove", IZK.Izkinra)
	IZK.Izkinra.Triggers.BiteRemove:AddStop(IZK.Izkinra.MechRef.Bite)	
	
	
	IZK.Ilrath.Triggers.VorpalStrike = KBM.Trigger:Create(IZK.Lang.Ability.VorpalStrike[KBM.Lang], "cast", IZK.Ilrath)
	IZK.Ilrath.Triggers.VorpalStrike:AddAlert(IZK.Ilrath.AlertsRef.VorpalStrike)
	
	IZK.Izkinra.Triggers.Victory = KBM.Trigger:Create(IZK.Lang.Verbose.Victory[KBM.Lang], "notify", IZK.Izkinra)
	IZK.Izkinra.Triggers.Victory:SetVictory()
	
	IZK.Shaddoth.CastBar = KBM.Castbar:Add(IZK, IZK.Shaddoth)
	IZK.Ilrath.CastBar = KBM.Castbar:Add(IZK, IZK.Ilrath)
	IZK.Izkinra.CastBar = KBM.Castbar:Add(IZK, IZK.Izkinra)
	
	-- Assign Alerts and Timers to Triggers
	self.PercentageMon = KBM.PercentageMon:Create(self.Shaddoth, self.Ilrath, 7)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)	
end