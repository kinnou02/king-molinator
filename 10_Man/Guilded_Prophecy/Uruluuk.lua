-- Uruluuk Boss Mod for King Boss Mods
-- Written by Paul Snart
-- CopyriUKt 2011
--

KBMGPUK_Settings = nil
chKBMGPUK_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local GP = KBM.BossMod["Guilded Prophecy"]

local UK = {
	Enabled = true,
	Instance = GP.Name,
	Lang = {},
	ID = "Uruluuk",
	}

UK.Uruluuk = {
	Mod = UK,
	Level = "??",
	Active = false,
	Name = "Uruluuk",
	NameShort = "Uruluuk",
	Menu = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
	},
}

KBM.RegisterMod(UK.ID, UK)

UK.Lang.Uruluuk = KBM.Language:Add(UK.Uruluuk.Name)

UK.Uruluuk.Name = UK.Lang.Uruluuk[KBM.Lang]
UK.Descript = UK.Uruluuk.Name

function UK:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Uruluuk.Name] = self.Uruluuk,
	}
	KBM_Boss[self.Uruluuk.Name] = self.Uruluuk	
end

function UK:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = self.Uruluuk.Settings.CastBar,
		EncTimer = KBM.Defaults.EncTimer(),
	}
	KBMGPUK_Settings = self.Settings
	chKBMGPUK_Settings = self.Settings
end

function UK:SwapSettings(bool)

	if bool then
		KBMGPUK_Settings = self.Settings
		self.Settings = chKBMGPUK_Settings
	else
		chKBMGPUK_Settings = self.Settings
		self.Settings = KBMGPUK_Settings
	end

end

function UK:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMGPUK_Settings, self.Settings)
	else
		KBM.LoadTable(KBMGPUK_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMGPUK_Settings = self.Settings
	else
		KBMGPUK_Settings = self.Settings
	end	
end

function UK:SaveVars()	
	if KBM.Options.Character then
		chKBMGPUK_Settings = self.Settings
	else
		KBMGPUK_Settings = self.Settings
	end	
end

function UK:Castbar(units)
end

function UK:RemoveUnits(UnitID)
	if self.Uruluuk.UnitID == UnitID then
		self.Uruluuk.Available = false
		return true
	end
	return false
end

function UK:Death(UnitID)
	if self.Uruluuk.UnitID == UnitID then
		self.Uruluuk.Dead = true
		return true
	end
	return false
end

function UK:UnitHPCheck(uDetails, unitID)
	
	if uDetails and unitID then
		if not uDetails.player then
			if uDetails.name == self.Uruluuk.Name then
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Uruluuk.Dead = false
					self.Uruluuk.Casting = false
					self.Uruluuk.CastBar:Create(unitID)
					self.Phase = 1
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj.Objective:AddPercent(self.Uruluuk.Name, 0, 100)
				end
				self.Uruluuk.UnitID = unitID
				self.Uruluuk.Available = true
				return self.Uruluuk
			end
		end
	end
end

function UK:Reset()
	self.EncounterRunning = false
	self.Uruluuk.Available = false
	self.Uruluuk.UnitID = nil
	self.Uruluuk.Dead = false
	self.Uruluuk.CastBar:Remove()
	self.PhaseObj:End(Inspect.Time.Real())
end

function UK:Timer()
	
end

function UK.Uruluuk:SetTimers(bool)	
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

function UK.Uruluuk:SetAlerts(bool)
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

function UK:DefineMenu()
	self.Menu = GP.Menu:CreateEncounter(self.Uruluuk, self.Enabled)
end

function UK:Start()
	-- Create Timers
	
	-- Create Alerts
	
	-- Assign Timers and Alerts to Triggers
	
	self.Uruluuk.CastBar = KBM.CastBar:Add(self, self.Uruluuk)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end