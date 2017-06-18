-- The Gedlo Council Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMPOAIDDTC_Settings = nil
chKBMPOAIDDTC_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["Intrepid: Darkening Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Council.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "ICouncil",
	Object = "MOD",
}

MOD.Nuggo = {
	Mod = MOD,
	Level = 72,
	Active = false,
	Name = "High Shaman Nuggo",
	NameShort = "Nuggo",
	Menu = {},
	Castbar = nil,
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	UTID = "U6C3F8BEC5F5E029A",
	Settings = {
		CastBar = KBM.Defaults.Castbar(),
	}
}

KBM.RegisterMod(MOD.ID, MOD)

-- Main Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Nuggo = KBM.Language:Add(MOD.Nuggo.Name)
MOD.Lang.Unit.Nuggo:SetGerman("Oberschamane Nuggo")
MOD.Lang.Unit.Nuggo:SetFrench("Grand Chamane Nuggo")
MOD.Lang.Unit.Nuggo:SetRussian("Старший шаман Нугго")
MOD.Lang.Unit.Nuggo:SetKorean("고위 샤먼 누고")
MOD.Lang.Unit.NuggoShort = KBM.Language:Add(MOD.Nuggo.NameShort)
MOD.Lang.Unit.NuggoShort:SetGerman("Nuggo")
MOD.Lang.Unit.NuggoShort:SetFrench("Nuggo")
MOD.Lang.Unit.NuggoShort:SetRussian("Шаман")
MOD.Lang.Unit.NuggoShort:SetKorean("누고")
MOD.Nuggo.Name = MOD.Lang.Unit.Nuggo[KBM.Lang]
MOD.Lang.Unit.Swedge = KBM.Language:Add("Warlord Swedge")
MOD.Lang.Unit.Swedge:SetGerman("Kriegsherr Swedge")
MOD.Lang.Unit.Swedge:SetFrench("Swedge le Maître de guerre")
MOD.Lang.Unit.Swedge:SetRussian("Полководец Сведж")
MOD.Lang.Unit.Swedge:SetKorean("워로드 스웨지")
MOD.Lang.Unit.SwedgeShort = KBM.Language:Add("Swedge")
MOD.Lang.Unit.SwedgeShort:SetGerman("Swedge")
MOD.Lang.Unit.SwedgeShort:SetFrench("Swedge")
MOD.Lang.Unit.SwedgeShort:SetRussian("Полководец")
MOD.Lang.Unit.SwedgeShort:SetKorean("스웨지")
MOD.Lang.Unit.Gerbik = KBM.Language:Add("Incinerator Gerbik")
MOD.Lang.Unit.Gerbik:SetGerman("Entflammer Gerbik")
MOD.Lang.Unit.Gerbik:SetFrench("Incinérateur Gerbik")
MOD.Lang.Unit.Gerbik:SetRussian("Поджигатель Гербик")
MOD.Lang.Unit.Gerbik:SetKorean("소각자 게르빅")
MOD.Lang.Unit.GerbikShort = KBM.Language:Add("Gerbik")
MOD.Lang.Unit.GerbikShort:SetGerman("Gerbik")
MOD.Lang.Unit.GerbikShort:SetFrench("Gerbik")
MOD.Lang.Unit.GerbikShort:SetRussian("Поджигатель")
MOD.Lang.Unit.GerbikShort:SetKorean("게르빅")

-- Ability Dictionary
MOD.Lang.Ability = {}

-- Description Dictionary
MOD.Lang.Main = {}
MOD.Lang.Main.Descript = KBM.Language:Add("The Gedlo Council")
MOD.Lang.Main.Descript:SetGerman("Gedlo-Rat")
MOD.Lang.Main.Descript:SetFrench("Le Conclave des Gedlos")
MOD.Lang.Main.Descript:SetRussian("Конклав Гедло")
MOD.Lang.Main.Descript:SetKorean("제들로 결사단")
MOD.Descript = MOD.Lang.Main.Descript[KBM.Lang]

MOD.Swedge = {
	Mod = MOD,
	Level = 72,
	Active = false,
	Name = MOD.Lang.Unit.Swedge[KBM.Lang],
	NameShort = MOD.Lang.Unit.SwedgeShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U431F59A11C69514D",
	TimeOut = 5,
}

MOD.Gerbik = {
	Mod = MOD,
	Level = 72,
	Active = false,
	Name = MOD.Lang.Unit.Gerbik[KBM.Lang],
	NameShort = MOD.Lang.Unit.GerbikShort[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	UTID = "U7F94FCED6720B8CB",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Nuggo.Name] = self.Nuggo,
		[self.Swedge.Name] = self.Swedge,
		[self.Gerbik.Name] = self.Gerbik
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Nuggo.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Nuggo.Settings.TimersRef,
		-- AlertsRef = self.Nuggo.Settings.AlertsRef,
	}
	KBMPOAIDDTC_Settings = self.Settings
	chKBMPOAIDDTC_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMPOAIDDTC_Settings = self.Settings
		self.Settings = chKBMPOAIDDTC_Settings
	else
		chKBMPOAIDDTC_Settings = self.Settings
		self.Settings = KBMPOAIDDTC_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMPOAIDDTC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMPOAIDDTC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMPOAIDDTC_Settings = self.Settings
	else
		KBMPOAIDDTC_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMPOAIDDTC_Settings = self.Settings
	else
		KBMPOAIDDTC_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Nuggo.UnitID == UnitID then
		self.Nuggo.Available = false
		return true
	end
	return false
end

function MOD.SetObjectives()
	MOD.PhaseObj.Objectives:Remove()
	if not MOD.Nuggo.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Nuggo.Name, 0, 100)
	end
	if not MOD.Swedge.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Swedge.Name, 0, 100)	
	end
	if not MOD.Gerbik.Dead then
		MOD.PhaseObj.Objectives:AddPercent(MOD.Gerbik.Name, 0, 100)
	end
end

function MOD:Death(UnitID)
	if self.Nuggo.UnitID == UnitID then
		self.Nuggo.Dead = true
		self.SetObjectives()
		self.Nuggo.CastBar:Remove()
	elseif self.Swedge.UnitID == UnitID then
		self.Swedge.Dead = true
		self.SetObjectives()
	elseif self.Gerbik.UnitID == UnitID then
		self.Gerbik.Dead = true
		self.SetObjectives()
	end
	if self.Nuggo.Dead and self.Swedge.Dead and self.Gerbik.Dead then
		return true
	end
	return false
end

function MOD:UnitHPCheck(uDetails, unitID)	
	if uDetails and unitID then
		if not uDetails.player then
			if self.Bosses[uDetails.name] then
				local BossObj = self.Bosses[uDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Nuggo.Name then
						BossObj.CastBar:Create(unitID)
					end
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1")
					self.SetObjectives()
					self.Phase = 1
				else
					BossObj.Dead = false
					BossObj.Casting = false
					if BossObj.Name == self.Nuggo.Name then
						BossObj.CastBar:Create(unitID)
					end
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function MOD:Reset()
	self.EncounterRunning = false
	for BossName, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		BossObj.Casting = false
	end
	self.Nuggo.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end




function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Nuggo)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Nuggo)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Nuggo.CastBar = KBM.Castbar:Add(self, self.Nuggo)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	
end