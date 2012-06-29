-- Alchemist Braxtepel Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMMMDDAB_Settings = nil
chKBMMMDDAB_Settings = nil
-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local Instance = KBM.BossMod["MM_Darkening_Deeps"]

local MOD = {
	Directory = Instance.Directory,
	File = "Braxtepel.lua",
	Enabled = true,
	Instance = Instance.Name,
	InstanceObj = Instance,
	HasPhases = true,
	Lang = {},
	ID = "MM_Braxtepel",
	Object = "MOD",
}

MOD.Braxtepel = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = "Alchemist Braxtepel",
	NameShort = "Braxtepel",
	Menu = {},
	Castbar = nil,
	Dead = false,
	-- TimersRef = {},
	-- AlertsRef = {},
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	MasterID = "U18465FF4097245D2",
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

KBM.RegisterMod(MOD.ID, MOD)

-- Unit Dictionary
MOD.Lang.Unit = {}
MOD.Lang.Unit.Braxtepel = KBM.Language:Add(MOD.Braxtepel.Name)
MOD.Lang.Unit.Braxtepel:SetGerman("Alchemist Braxtepel")
MOD.Lang.Unit.Braxtepel:SetFrench("Alchemiste Braxtepel")
MOD.Lang.Unit.Braxtepel:SetRussian("Алхимик Бракстепль")
MOD.Lang.Unit.Braxtepel:SetKorean("연금술사 브락스테펠")
MOD.Braxtepel.Name = MOD.Lang.Unit.Braxtepel[KBM.Lang]
MOD.Descript = MOD.Braxtepel.Name
MOD.Lang.Unit.BraxShort = KBM.Language:Add("Braxtepel")
MOD.Lang.Unit.BraxShort:SetGerman("Braxtepel")
MOD.Lang.Unit.BraxShort:SetFrench("Braxtepel")
MOD.Lang.Unit.BraxShort:SetRussian("Бракстепль")
MOD.Lang.Unit.BraxShort:SetKorean("브락스테펠")
MOD.Braxtepel.NameShort = MOD.Lang.Unit.BraxShort[KBM.Lang]
MOD.Lang.Unit.Mursh = KBM.Language:Add("Mursh")
MOD.Lang.Unit.Mursh:SetGerman("Mursh")
MOD.Lang.Unit.Mursh:SetFrench("Mursh")
MOD.Lang.Unit.Mursh:SetRussian("Марш")
MOD.Lang.Unit.Mursh:SetKorean("머쉬")
MOD.Lang.Unit.Squersh = KBM.Language:Add("Squersh")
MOD.Lang.Unit.Squersh:SetGerman("Squersh")
MOD.Lang.Unit.Squersh:SetFrench("Squersh")
MOD.Lang.Unit.Squersh:SetRussian("Скварш")
MOD.Lang.Unit.Squersh:SetKorean("스쿼쉬")
-- Ability Dictionary
MOD.Lang.Ability = {}

MOD.Mursh = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Mursh[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	MasterID = "U028EF6F7630FD7C2",
	TimeOut = 5,
}

MOD.Squersh = {
	Mod = MOD,
	Level = 52,
	Active = false,
	Name = MOD.Lang.Unit.Squersh[KBM.Lang],
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	MasterID = "U1DEFC8A4336C527E",
	TimeOut = 5,
}

function MOD:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Braxtepel.Name] = self.Braxtepel,
		[self.Mursh.Name] = self.Mursh,
		[self.Squersh.Name] = self.Squersh
	}
end

function MOD:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Braxtepel.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		-- MechTimer = KBM.Defaults.MechTimer(),
		-- Alerts = KBM.Defaults.Alerts(),
		-- TimersRef = self.Braxtepel.Settings.TimersRef,
		-- AlertsRef = self.Braxtepel.Settings.AlertsRef,
	}
	KBMMMDDAB_Settings = self.Settings
	chKBMMMDDAB_Settings = self.Settings
	
end

function MOD:SwapSettings(bool)

	if bool then
		KBMMMDDAB_Settings = self.Settings
		self.Settings = chKBMMMDDAB_Settings
	else
		chKBMMMDDAB_Settings = self.Settings
		self.Settings = KBMMMDDAB_Settings
	end

end

function MOD:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMMMDDAB_Settings, self.Settings)
	else
		KBM.LoadTable(KBMMMDDAB_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMMMDDAB_Settings = self.Settings
	else
		KBMMMDDAB_Settings = self.Settings
	end	
end

function MOD:SaveVars()	
	if KBM.Options.Character then
		chKBMMMDDAB_Settings = self.Settings
	else
		KBMMMDDAB_Settings = self.Settings
	end	
end

function MOD:Castbar(units)
end

function MOD:RemoveUnits(UnitID)
	if self.Braxtepel.UnitID == UnitID then
		self.Braxtepel.Available = false
		return true
	end
	return false
end

function MOD.PhaseTwo()
	MOD.PhaseObj.Objectives:Remove()
	MOD.PhaseObj:SetPhase("Final")
	MOD.PhaseObj.Objectives:AddPercent(MOD.Braxtepel.Name, 0, 100)
	MOD.Phase = 2
end

function MOD:Death(UnitID)
	if self.Braxtepel.UnitID == UnitID then
		self.Braxtepel.Dead = true
		return true
	else
		if self.Mursh.UnitID == UnitID then
			self.Mursh.Dead = true
		elseif self.Squersh.UnitID == UnitID then
			self.Squersh.Dead = true
		end
		if self.Mursh.Dead == true and self.Squersh.Dead == true then
			self.PhaseTwo()
		end
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
					BossObj.Casting = false
					self.PhaseObj:Start(self.StartTime)
					if BossObj.Name == self.Braxtepel.Name then
						BossObj.CastBar:Create(unitID)
						self.PhaseObj:SetPhase("2")
						self.PhaseObj.Objectives:AddPercent(self.Braxtepel.Name, 0, 100)
						self.Phase = 1
					else
						self.PhaseObj:SetPhase("1")
						self.PhaseObj.Objectives:AddPercent(self.Mursh.Name, 0, 100)
						self.PhaseObj.Objectives:AddPercent(self.Squersh.Name, 0, 100)
						self.Phase = 1
					end
				else
					BossObj.Casting = false
					if BossObj.Name == self.Braxtepel.Name then
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
	self.Braxtepel.CastBar:Remove()	
	self.PhaseObj:End(Inspect.Time.Real())
end

function MOD:Timer()	
end

function MOD.Braxtepel:SetTimers(bool)	
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

function MOD.Braxtepel:SetAlerts(bool)
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

function MOD:DefineMenu()
	self.Menu = Instance.Menu:CreateEncounter(self.Braxtepel, self.Enabled)
end

function MOD:Start()
	-- Create Timers
	--KBM.Defaults.TimerObj.Assign(self.Braxtepel)
	
	-- Create Alerts
	--KBM.Defaults.AlertObj.Assign(self.Braxtepel)
	
	-- Assign Alerts and Timers to Triggers
	
	self.Braxtepel.CastBar = KBM.CastBar:Add(self, self.Braxtepel)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end