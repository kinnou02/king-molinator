-- Grugonim Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMGR_Settings = nil
HK = KBMHK_Register()

local GR = {
	ModEnabled = true,
	Grugonim = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
	},
	Instance = HK.Name,
	HasPhases = true,
	PhaseType = "percentage",
	PhaseList = {},
	Timers = {},
	Lang = {},
	Enrage = 60 * 13,
	ID = "Grugonim",
}

GR.Grugonim = {
	Mod = GR,
	Level = "??",
	Active = false,
	Name = "Grugonim",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	TimersRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
}

local KBM = KBM_RegisterMod(GR.Grugonim.ID, GR)

GR.Lang.Grugonim = KBM.Language:Add(GR.Grugonim.Name)

GR.Grugonim.Name = GR.Lang.Grugonim[KBM.Lang]

function GR:AddBosses(KBM_Boss)
	self.Grugonim.Descript = self.Grugonim.Name
	self.MenuName = self.Grugonim.Descript
	self.Bosses = {
		[self.Grugonim.Name] = true,
	}
	KBM_Boss[self.Grugonim.Name] = self.Grugonim	
end

function GR:InitVars()
	self.Settings = {
		Timers = {
			Enabled = true,
		},
		CastBar = {
			x = false,
			y = false,
			Enabled = true,
		},
	}
	KBMGR_Settings = self.Settings
end

function GR:LoadVars()
	if type(KBMGR_Settings) == "table" then
		for Setting, Value in pairs(KBMGR_Settings) do
			if type(KBMGR_Settings[Setting]) == "table" then
				if self.Settings[Setting] ~= nil then
					for tSetting, tValue in pairs(KBMGR_Settings[Setting]) do
						if self.Settings[Setting][tSetting] ~= nil then
							self.Settings[Setting][tSetting] = tValue
						end
					end
				end
			else
				if self.Settings[Setting] ~= nil then
					self.Settings[Setting] = Value
				end
			end
		end
	end
end

function GR:SaveVars()
	KBMGR_Settings = self.Settings
end

function GR:Castbar(units)
end

function GR:RemoveUnits(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Available = false
		return true
	end
	return false
end

function GR:Death(UnitID)
	if self.Grugonim.UnitID == UnitID then
		self.Grugonim.Dead = true
		return true
	end
	return false
end

function GR:UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		if not unitDetails.player then
			if unitDetails.name == self.Grugonim.Name then
				if not self.Grugonim.UnitID then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.Grugonim.Dead = false
					self.Grugonim.Casting = false
					self.Grugonim.CastBar:Create(unitID)
					KBM.TankSwap:Start("Heart Stopping Toxin")
				end
				self.Grugonim.UnitID = unitID
				self.Grugonim.Available = true
				return self.Grugonim
			end
		end
	end
end

function GR:Reset()
	self.EncounterRunning = false
	self.Grugonim.Available = false
	self.Grugonim.UnitID = nil
	self.Grugonim.CastBar:Remove()
end

function GR:Timer()
	
end

function GR.Grugonim:Options()
	function self:TimersEnabled(bool)
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Timers = Options:AddHeader("Timers Enabled", self.TimersEnabled, GR.Settings.Timers.Enabled)
	--Timers:AddCheck(GR.Lang.Flames[KBM.Lang], self.FlamesEnabled, GR.Settings.Timers.FlamesEnabled)	
	
end

function GR:Start()
	self.Header = KBM.HeaderList[self.Instance]
	self.Grugonim.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.MenuName, self.Grugonim, true, self.Header)
	self.Grugonim.MenuItem.Check:SetEnabled(false)
	--self.Grugonim.TimersRef.Flames = KBM.MechTimer:Add(self.Lang.Flames[KBM.Lang], "cast", 30, self, nil)
	--self.Grugonim.TimersRef.Flames.Enabled = self.Settings.Timers.FlamesEnabled
	
	self.Grugonim.CastBar = KBM.CastBar:Add(self, self.Grugonim, true)
end