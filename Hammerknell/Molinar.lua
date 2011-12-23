-- King Molinar Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KM_Settings = nil
chKM_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
local HK = KBM.BossMod["Hammerknell"]

local KM = {
	Enabled = true,
	Instance = HK.Name,
	HasPhases = true,
	Phase = 1,
	TankSwap = false,
	Lang = {},
	Enrage = 60 * 10,
	ID = "KingMolinar",
}

-- Addon Variables
-- Frames
KM.FrameBase = nil -- Base Frame to attach fancy stuff to
KM.DragFrame = nil -- Used for moving the monitor
KM.KingText = nil -- King Molinar display name
KM.PrinceText = nil -- Prince Dollin display name
KM.PrincePBack = nil
KM.PrincePText = nil
KM.KingPBack = nil
KM.KingPText = nil
KM.StatusForecast = nil
KM.StatusBar = nil
KM.IconSize = nil

-- Frame Defaults
KM.FBWidth = 600
KM.SwingMulti = (KM.FBWidth * 0.5) * 0.25
KM.FBHeight = 100
KM.SafeWidth = KM.FBWidth * 0.5
KM.DangerWidth = KM.FBWidth * 0.125
KM.StopWidth = (KM.FBWidth - KM.SafeWidth - (KM.DangerWidth * 2)) * 0.5
KM.FBDefX = LocX -- Centered
KM.FBDefY = LocY -- Centered
KM.BossHPWidth = nil -- To be filled in later, size of King and Prince individual HP bars

-- Unit Variables
-- King Molinar
KM.KingHPP = "100" -- Visual percentage.
KM.KingPerc = 1 -- Decimal percentage holder.
KM.KingHPMax = 7100000 -- Dummy HP value for testing, will be overridden during encounter start
KM.KingDPSTable = {}
KM.KingLastHP = 0
KM.KingSample = 0 -- Total damage done to King Molinar over {SampleDPS} seconds
KM.KingSampleDPS = 0 -- Average DPS done to King Molinar over {SampleDPS} seconds.
-- Prince Dollin
KM.PrinceHPP = "100" -- Visual percentage
KM.PrincePerc = 1 -- Decimal percentage holder.
KM.PrinceHPMax = 4200000 -- Dummy HP value for testing, will be overridden during encounter start
KM.PrinceDPSTable = {}
KM.PrinceLastHP = 0
KM.PrinceSample = 0 -- Total damage done to Prince Dollin over {SampleDPS} seconds.
KM.PrinceSampleDPS = 0 -- Average DPS done to Prince Dollin over {SampleDPS} seconds.
-- State Variables
KM.EncounterRunning = false
KM.StartTime = Inspect.Time.Real()
KM.HeldTime = KM.StartTime
KM.UpdateTime = KM.StartTime
KM.TimeElapsed = 0
KM.DisplayReady = false
KM.CurrentSwing = 0
KM.ForecastSwing = 0

KM.Prince = {
	Mod = KM,
	Level = "??",
	Active = false,
	Name = "Prince Dollin",
	NameShort = "Dollin",
	CastBar = nil,
	CastFilters = {},
	Casting = false,
	HasCastFilters = true,
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		PinMenu = KBM.Language.Options.Pinned[KBM.Lang].."Percentage Monitor",
		Filters = {
			Enabled = true,
			Rend = KBM.Defaults.CastFilter.Create(),
			Feedback = KBM.Defaults.CastFilter.Create(),
			Essence = KBM.Defaults.CastFilter.Create(),
			Terminate = KBM.Defaults.CastFilter.Create(),
			Blast = KBM.Defaults.CastFilter.Create(),
			Crushing = KBM.Defaults.CastFilter.Create(),
		},
		TimersRef = {
			Enabled = true,
			Terminate = KBM.Defaults.TimerObj.Create(),
			Crushing = KBM.Defaults.TimerObj.Create(),
			Essence = KBM.Defaults.TimerObj.Create(),
			Feedback = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Terminate = KBM.Defaults.AlertObj.Create("orange"),
			Essence = KBM.Defaults.AlertObj.Create("yellow"),
			Feedback = KBM.Defaults.AlertObj.Create("blue"),
			FeedbackWarn = KBM.Defaults.AlertObj.Create("blue"),
		}
	}
}
KM.King = {
	Mod = KM,
	Level = "??",
	Active = false,
	Name = "Rune King Molinar",
	NameShort = "Molinar",
	CastBar = nil,
	CastFilters = {},
	Casting = false,
	HasCastFilters = true,
	Timers = {},
	TimersRef = {},
	AlertsRef = {},
	Dead = false,
	Available = false,
	UnitID = nil,
	TimeOut = 5,
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		PinMenu = KBM.Language.Options.Pinned[KBM.Lang].."Percentage Monitor",
		Filters = {
			Enabled = true,
			Shout = KBM.Defaults.CastFilter.Create(),
			Cursed = KBM.Defaults.CastFilter.Create(),
			Essence = KBM.Defaults.CastFilter.Create(),
			Feedback = KBM.Defaults.CastFilter.Create(),
		},
		TimersRef = {
			Enabled = true,
			Shout = KBM.Defaults.TimerObj.Create(),
			Cursed = KBM.Defaults.TimerObj.Create(),
			Essence = KBM.Defaults.TimerObj.Create(),
			Feedback = KBM.Defaults.TimerObj.Create(),
			Rev = KBM.Defaults.TimerObj.Create(),
		},
		AlertsRef = {
			Enabled = true,
			Cursed = KBM.Defaults.AlertObj.Create("red"),
			Essence = KBM.Defaults.AlertObj.Create("yellow"),
			Feedback = KBM.Defaults.AlertObj.Create("blue"),
			FeedbackWarn = KBM.Defaults.AlertObj.Create("blue"),
			Shout = KBM.Defaults.AlertObj.Create("purple"),
		},
	},
}
KM.King.Settings.CastBar.Pinned = true
KM.Prince.Settings.CastBar.Pinned = true

KBM.RegisterMod(KM.ID, KM)

KM.Lang.Molinar = KBM.Language:Add(KM.King.Name)
KM.Lang.Dollin = KBM.Language:Add(KM.Prince.Name)
KBM.Language[KM.King.Name]:SetGerman("Runenkönig Molinar")
KBM.Language[KM.Prince.Name]:SetGerman("Prinz Dollin")
KBM.Language[KM.King.Name]:SetFrench("Roi runique Molinar")

-- King and Princes Ability Dictionary
KM.Lang.Ability = {}
KM.Lang.Ability.Rend = KBM.Language:Add("Rend Life")
KM.Lang.Ability.Rend.French = "D\195\169chire-Vie"
KM.Lang.Ability.Rend.German = "Leben entreißen"
KM.Lang.Ability.Terminate = KBM.Language:Add("Terminate Life")
KM.Lang.Ability.Terminate.French = "Ach\195\168vement de Vie"
KM.Lang.Ability.Terminate.German = "Leben auslöschen"
KM.Lang.Ability.Essence = KBM.Language:Add("Consuming Essence")
KM.Lang.Ability.Essence.French = "Combustion d'essence"
KM.Lang.Ability.Essence.German = "Verschlingende Essenz"
KM.Lang.Ability.Feedback = KBM.Language:Add("Runic Feedback")
KM.Lang.Ability.Feedback.French = "R\195\169action runique"
KM.Lang.Ability.Feedback.German = "Runen-Resonanz"
KM.Lang.Ability.Crushing = KBM.Language:Add("Crushing Regret")
KM.Lang.Ability.Crushing.French = "Blasph\195\168me infect"
KM.Lang.Ability.Forked = KBM.Language:Add("Forked Blast")
KM.Lang.Ability.Forked.French = "Explosion fourchue"
KM.Lang.Ability.Shout = KBM.Language:Add("Frightening Shout")
KM.Lang.Ability.Shout.French = "Flammes maudites"
KM.Lang.Ability.Shout.German = "Verängstigender Schrei"
KM.Lang.Ability.Cursed = KBM.Language:Add("Cursed Blows")
KM.Lang.Ability.Cursed.French = "Frappes maudites"
KM.Lang.Ability.Cursed.German = "Verfluchte Schläge"

-- Units Dictionary
KM.Lang.Unit = {}
KM.Lang.Unit.Revenant = KBM.Language:Add("Incorporeal Revenant")
KM.Lang.Unit.Revenant.French = "Revenant chim\195\169rique"
KM.Lang.Unit.Revenant.German = "Unkörperlicher Wiedergänger"

-- Notify Trigger Dictionary
KM.Lang.Notify = {}
KM.Lang.Notify.Rev = KBM.Language:Add("Incorporeal Revenant begins to phase into this reality.")
KM.Lang.Notify.Rev.French = "Revenant chim\195\169rique commence \195\160 se mat\195\169rialiser dans cette réalit\195\169."
KM.Lang.Notify.Rev.German = "Unkörperlicher Wiedergänger beginnt, in diese Realität zu gleiten."

-- King's Options page Dictionary
KM.Lang.Options = {}
KM.Lang.Options.Monitor = {}
KM.Lang.Options.Monitor.Enabled = KBM.Language:Add("Enable Percentage Monitor.")
KM.Lang.Options.Monitor.Enabled.French = "Montrer Moniteur Pct."
KM.Lang.Options.Monitor.Enabled.German = "Prozent Monitor anzeigen."
KM.Lang.Options.Monitor.Visible = KBM.Language:Add("Show Monitor (for positioning).")
KM.Lang.Options.Monitor.Visible.French = "Cacher avant d\195\169but du combat."
KM.Lang.Options.Monitor.Visible.German = "Verbergen bis zum Kampfbeginn."
KM.Lang.Options.Monitor.Compact = KBM.Language:Add("Compact Mode.")
KM.Lang.Options.Monitor.Compact.French = "Mode Compact."
KM.Lang.Options.Monitor.Compact.German = "Kompakte Anzeige."

KM.King.Name = KM.Lang.Molinar[KBM.Lang]
KM.Prince.Name = KM.Lang.Dollin[KBM.Lang]

function KM:AddBosses(KBM_Boss)

	self.MenuName = self.King.Name
	self.Prince.Descript = self.King.Name.." & "..self.Prince.Name
	self.King.Descript = self.Prince.Descript
	KBM_Boss[self.Prince.Name] = self.Prince
	KBM_Boss[self.King.Name] = self.King
	self.Bosses = {
		[self.King.Name] = self.King,
		[self.Prince.Name] = self.Prince,
	}
	
end

function KM:InitVars()

	self.Settings = {
		Enabled = true,
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
		CastBar = {
			Multi = true,
			Override = true,
		},
		PercentMonitor = {
			x = false,
			y = false,
			Size = 1,
			Visible = false,
			Unlocked = false,
			Compact = false,
			Enabled = true,
		},
		SampleDPS = 4,
		King = {
			CastBar = KM.King.Settings.CastBar,
			CastFilters = KM.King.Settings.Filters,
			TimersRef = KM.King.Settings.TimersRef,
			AlertsRef = KM.King.Settings.AlertsRef,
		},
		Prince = {
			CastBar = KM.Prince.Settings.CastBar,
			CastFilters = KM.Prince.Settings.Filters,
			TimersRef = KM.Prince.Settings.TimersRef,
			AlertsRef = KM.Prince.Settings.AlertsRef,
		},
	}
	KM_Settings = self.Settings
	chKM_Settings = self.Settings
	
end

function KM:SwapSettings(bool)

	if bool then
		KM_Settings = self.Settings
		self.Settings = chKM_Settings
	else
		chKM_Settings = self.Settings
		self.Settings = KM_Settings
	end

end

function KM:LoadVars()
	if KBM.Options.Character then
		KBM.LoadTable(chKM_Settings, KM.Settings)
	else
		KBM.LoadTable(KM_Settings, KM.Settings)
	end
	
	if KBM.Options.Character then
		chKM_Settings = KM.Settings
	else
		KM_Settings = KM.Settings
	end

	self.King.Settings.CastBar.Override = true
	self.King.Settings.CastBar.Multi = true
	self.Prince.Settings.CastBar.Override = true
	self.Prince.Settings.CastBar.Multi = true
	
	self.King.Settings.AlertsRef.Feedback.Enabled = true
	self.Prince.Settings.AlertsRef.Feedback.Enabled = true
	
	KM.Prince.CastFilters[KM.Lang.Ability.Rend[KBM.Lang]] = self.Settings.Prince.CastFilters.Rend
	KM.Prince.CastFilters[KM.Lang.Ability.Terminate[KBM.Lang]] = self.Settings.Prince.CastFilters.Terminate
	KM.Prince.CastFilters[KM.Lang.Ability.Essence[KBM.Lang]] = self.Settings.Prince.CastFilters.Essence
	KM.Prince.CastFilters[KM.Lang.Ability.Feedback[KBM.Lang]] = self.Settings.Prince.CastFilters.Feedback
	KM.Prince.CastFilters[KM.Lang.Ability.Crushing[KBM.Lang]] = self.Settings.Prince.CastFilters.Crushing
	KM.Prince.CastFilters[KM.Lang.Ability.Forked[KBM.Lang]] = self.Settings.Prince.CastFilters.Blast
	KM.King.CastFilters[KM.Lang.Ability.Shout[KBM.Lang]] = self.Settings.King.CastFilters.Shout
	KM.King.CastFilters[KM.Lang.Ability.Cursed[KBM.Lang]] = self.Settings.King.CastFilters.Cursed
	KM.King.CastFilters[KM.Lang.Ability.Essence[KBM.Lang]] = self.Settings.King.CastFilters.Essence
	KM.King.CastFilters[KM.Lang.Ability.Feedback[KBM.Lang]] = self.Settings.King.CastFilters.Feedback
	
	KBM.Defaults.CastFilter.Assign(self.King)
	KBM.Defaults.CastFilter.Assign(self.Prince)
	
end

function KM:SaveVars()	
	if KBM.Options.Character then
		chKM_Settings = self.Settings
	else
		KM_Settings = self.Settings
	end	
end

function KM:RemoveUnits(UnitID)
	if self.King.UnitID == UnitID then
		self.King.Available = false
	elseif self.Prince.UnitID == UnitID then
		self.Prince.Available = false
	end
	if not self.Prince.Available and not self.King.Available then
		return true
	end
	return false	
end

function KM:Death(UnitID)
	if self.King.UnitID == UnitID then
		self.King.Dead = true
	elseif self.Prince.UnitID == UnitID then
		self.Prince.Dead = true
	end
	if self.King.Dead and self.Prince.Dead then
		return true
	end
	return false	
end

function KM:UnitHPCheck(unitDetails, unitID)
	if unitDetails and unitID then
		if unitDetails.player == nil then
			if unitDetails.name == self.King.Name then
				if not self.King.UnitID then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.PhaseObj:Start(self.StartTime)
						self.Phase = 1
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.King.Name, 90, 100)
						self.PhaseObj.Objectives:AddPercent(self.Prince.Name, 90, 100)
						self.King.Dead = false
					end
					self.King.Casting = false
					self.KingLastHP = unitDetails.healthMax
					self.KingHPMax = unitDetails.healthMax
					self.KingCurrentHP = self.KingLastHP
					if self.Settings.PercentMonitor.Enabled then
						self.FrameBase:SetVisible(true)
					end
					self.King.CastBar:Create(unitID)
				end
				self.King.UnitID = unitID
				self.King.Available = true
				return self.King
			elseif unitDetails.name == self.Prince.Name then
				if not self.Prince.UnitID then
					if not self.EncounterRunning then
						self.EncounterRunning = true
						self.StartTime = Inspect.Time.Real()
						self.HeldTime = self.StartTime
						self.TimeElapsed = 0
						self.PhaseObj:Start(self.StartTime)
						self.Phase = 1
						self.PhaseObj:SetPhase(1)
						self.PhaseObj.Objectives:AddPercent(self.King.Name, 90, 100)
						self.PhaseObj.Objectives:AddPercent(self.Prince.Name, 90, 100)
						self.Prince.Dead = false
					end
					self.PrinceLastHP = unitDetails.healthMax
					self.PrinceHPMax = unitDetails.healthMax
					self.PrinceCurrentHP = self.PrinceLastHP
					self.Prince.Casting = false
					if self.Settings.PercentMonitor.Enabled then
						self.FrameBase:SetVisible(true)
					end
					self.Prince.CastBar:Create(unitID)
				end
				self.Prince.UnitID = unitID
				self.Prince.Available = true
				return self.Prince
			end
		end
	end
end

function KM:Reset()
	self.EncounterRunning = false
	self.Prince.UnitID = nil
	self.King.UnitID = nil
	self.KingDPSTable = {}
	self.PrinceDPSTable = {}
	self.KingHPBar:SetWidth(self.BossHPWidth)
	self.PrinceHPBar:SetWidth(self.BossHPWidth)
	self.StatusBar:SetPoint("CENTER", self.FrameBase, "CENTER")
	self.StatusForecast:SetPoint("CENTER", self.FrameBase, "CENTER")
	self.KingHPP = "100%"
	self.PrinceHPP = "100%"
	self.KingPText:SetText("100%")
	self.KingPText:SetWidth(self.KingPText:GetFullWidth())
	self.PrincePText:SetText("100%")
	self.PrincePText:SetWidth(self.PrincePText:GetFullWidth())
	self.CurrentSwing = 0
	self.KingPerc = 1
	self.PrincePerc = 1
	self.FrameBase:SetVisible(false)
	self.King.CastBar:Remove()
	self.King.Dead = false
	self.King.Available = false
	self.Prince.CastBar:Remove()
	self.Prince.Dead = false
	self.Prince.Available = false
	self.Phase = 1
	self.PhaseObj:End(Inspect.Time.Real())
	print("Monitor reset.")	
end

function KM.PhaseTwo()
	if KM.Phase < 2 then
		KM.PhaseObj.Objectives:Remove()
		KM.Phase = 2
		KM.PhaseObj:SetPhase(2)
		KM.PhaseObj.Objectives:AddPercent(KM.King.Name, 65, 90)
		KM.PhaseObj.Objectives:AddPercent(KM.Prince.Name, 65, 90)
		print("Starting Phase 2!")
	end
end

function KM.PhaseThree()
	if KM.Phase < 3 then
		KM.PhaseObj.Objectives:Remove()
		KM.Phase = 3
		KM.PhaseObj:SetPhase(3)
		KM.PhaseObj.Objectives:AddPercent(KM.King.Name, 40, 65)
		KM.PhaseObj.Objectives:AddPercent(KM.Prince.Name, 40, 65)
		print("Starting Phase 3!")
	end	
end

function KM.PhaseFour()
	if KM.Phase < 4 then
		KM.PhaseObj.Objectives:Remove()
		KM.Phase = 4
		KM.PhaseObj:SetPhase("Final")
		KM.PhaseObj.Objectives:AddPercent(KM.King.Name, 0, 40)
		KM.PhaseObj.Objectives:AddPercent(KM.Prince.Name, 0, 40)
		print("Starting Final Phase!")
	end
end

function KM:CheckTrends()
	-- Adjust the Current and Trend bars accordingly.	
	if self.King.UnitID ~= nil and self.Prince.UnitID ~= nil then
		-- King Calc
		local KingForecastHP = self.KingLastHP-(self.KingSampleDPS * 8)
		local KingForecastP = KingForecastHP / self.KingHPMax
		local KingMulti = self.KingPerc*100
		local stupidKing = math.floor(KingMulti)
		if (KingMulti - stupidKing) > 0.005 then -- Account for lag
			stupidKing = stupidKing + 1
		end
		self.KingHPP = tostring(stupidKing).."%"
		-- Prince Calc
		local PrinceForecastHP = self.PrinceLastHP-(self.PrinceSampleDPS * 8)
		local PrinceForecastP = PrinceForecastHP / self.PrinceHPMax
		local PrinceMulti = self.PrincePerc*100
		local stupidPrince = math.floor(PrinceMulti)
		if (PrinceMulti - stupidPrince) > 0.005 then -- Account for lag
			stupidPrince = stupidPrince + 1
		end
		self.PrinceHPP = tostring(stupidPrince).."%"
		self.CurrentSwing = self.KingPerc - self.PrincePerc
		if self.CurrentSwing > 0.04 then
			self.CurrentSwing = 0.04
		elseif self.CurrentSwing < -0.04 then
			self.CurrentSwing = -0.04
		end
		self.ForecastSwing = KingForecastP - PrinceForecastP
		if self.ForecastSwing > 0.04 then
			self.ForecastSwing = 0.04
		elseif self.ForecastSwing < -0.04 then
			self.ForecastSwing = -0.04
		end
		self.StatusBar:SetPoint("CENTER", self.FrameBase, "CENTER", (self.CurrentSwing * self.SwingMulti) * 100, 0)
		self.StatusForecast:SetPoint("CENTER", self.FrameBase, "CENTER", (self.ForecastSwing * self.SwingMulti) * 100, 0)
		self.KingPText:SetText(self.KingHPP)
		self.KingPText:SetWidth(self.KingPText:GetFullWidth())
		self.KingHPBar:SetWidth(self.BossHPWidth * self.KingPerc)
		self.PrincePText:SetText(self.PrinceHPP)
		self.PrincePText:SetWidth(self.PrincePText:GetFullWidth())
		self.PrinceHPBar:SetWidth(self.BossHPWidth * self.PrincePerc)
	end	
end

function KM:DPSUpdate()
	if self.King.UnitID ~= nil and self.Prince.UnitID ~= nil then
		local DumpDPS = 0
		local KingDetails = Inspect.Unit.Detail(self.King.UnitID)
		local PrinceDetails = Inspect.Unit.Detail(self.Prince.UnitID)
		if KingDetails and PrinceDetails then
			local KingCurrentHP = self.KingLastHP
			local KingDPS = 0
			if KingDetails then
				if KingDetails.health then
					KingCurrentHP = KingDetails.health
					KingDPS = self.KingLastHP - KingCurrentHP
					self.KingLastHP = KingCurrentHP
				else
					KingCurrentHP = 0
				end
			end
			self.KingPerc = KingCurrentHP / self.KingHPMax
			dpsheld = #self.KingDPSTable
			if dpsheld >= self.Settings.SampleDPS then
				DumpDPS = table.remove(self.KingDPSTable, 1)
				table.insert(self.KingDPSTable, KingDPS)
				if not DumpDPS then DumpDPS = 0 end
				self.KingSample = self.KingSample - DumpDPS + KingDPS
				self.KingSampleDPS = self.KingSample / self.Settings.SampleDPS
			else
				if dpsheld == 0 then dpsheld = 1 end
				self.KingSampleDPS = self.PrinceSample / dpsheld
				table.insert(self.KingDPSTable, KingDPS)
			end
			local PrinceCurrentHP = self.PrinceLastHP
			local PrinceDPS = 0
			if PrinceDetails then
				if PrinceDetails.health then
					PrinceCurrentHP = PrinceDetails.health
					PrinceDPS = self.PrinceLastHP - PrinceCurrentHP
					self.PrinceLastHP = PrinceCurrentHP
				else
					PrinceCurrentHP = 0
				end
			end
			self.PrincePerc = PrinceCurrentHP / self.PrinceHPMax
			dpsheld = #self.PrinceDPSTable
			if dpsheld > self.Settings.SampleDPS then
				DumpDPS = table.remove(self.PrinceDPSTable, 1)
				table.insert(self.PrinceDPSTable, PrinceDPS)
				if not DumpDPS then DumpDPS = 0 end
				self.PrinceSample = self.PrinceSample - DumpDPS + PrinceDPS
				self.PrinceSampleDPS = self.PrinceSample / self.Settings.SampleDPS
			else
				if dpsheld == 0 then dpsheld = 1 end
				self.PrinceSampleDPS = self.PrinceSample / dpsheld
				table.insert(self.PrinceDPSTable, PrinceDPS)
			end
		end
		self:CheckTrends()
	end	
end

function KM.HPChangeCheck(units)
end

function KM:SetNormal()
	self.FrameBase:SetHeight(self.FBHeight)
	self.FrameBase:SetWidth(self.FBWidth)	
	self.IconSize = 36	
	
	self.KingPText:SetFontSize(16)
	self.KingPBack:SetWidth(self.KingPText:GetWidth() + 6)
	self.KingPBack:SetHeight(self.KingPText:GetHeight() + 4)

	self.PrincePText:SetFontSize(16)
	self.PrincePBack:SetWidth(self.PrincePText:GetWidth() + 6)
	self.PrincePBack:SetHeight(self.PrincePText:GetHeight() + 4)

	self.SafeZone:SetWidth(self.SafeWidth)
	self.KingDanger:SetWidth(self.DangerWidth)
	self.KingStop:SetWidth(self.StopWidth)

	self.BossHPWidth = (self.FrameBase:GetWidth() * 0.5) - (self.KingPBack:GetWidth() * 0.5) - 2
	self.KingHPBar:SetWidth(self.BossHPWidth)
	self.KingHPBar:SetHeight(10)

	self.PrinceStop:SetWidth(self.StopWidth)
	self.PrinceDanger:SetWidth(self.DangerWidth)
	self.PrinceHPBar:SetWidth(self.BossHPWidth)
	self.PrinceHPBar:SetHeight(10)
	
	self.StatusBar:SetWidth(11)
	self.StatusBar:SetHeight(self.PrinceStop:GetHeight() + 10)
	self.StatusForecast:SetWidth(11)
	self.StatusForecast:SetHeight(self.PrinceStop:GetHeight() + 10)
	
	self.SwingMulti = (self.FBWidth * 0.5) * 0.25
end

function KM:SetCompact()
	self.FrameBase:SetHeight(self.FBHeight * 0.75)
	self.FrameBase:SetWidth(self.FBWidth * 0.75)
	
	self.IconSize = 36 * 0.75	
	
	self.KingPText:SetFontSize(12)
	self.KingPBack:SetWidth(self.KingPText:GetWidth() + 2)
	self.KingPBack:SetHeight(self.KingPText:GetHeight() + 1)

	self.PrincePText:SetFontSize(12)
	self.PrincePBack:SetWidth(self.PrincePText:GetWidth())
	self.PrincePBack:SetHeight(self.PrincePText:GetHeight())

	self.SafeZone:SetWidth(self.SafeWidth*0.75)
	self.SafeZone:SetHeight(35)
	self.KingDanger:SetWidth(self.DangerWidth*0.75)
	self.KingDanger:SetHeight(35)
	self.KingStop:SetWidth(self.StopWidth*0.75)
	self.KingStop:SetHeight(35)

	self.BossHPWidth = (self.FrameBase:GetWidth() * 0.5) - (self.KingPBack:GetWidth() * 0.5) - 2
	self.KingHPBar:SetWidth(self.BossHPWidth)
	self.KingHPBar:SetHeight(7)

	self.PrinceStop:SetWidth(self.StopWidth * 0.75)
	self.PrinceStop:SetHeight(35)
	self.PrinceDanger:SetWidth(self.DangerWidth * 0.75)
	self.PrinceDanger:SetHeight(35)
	self.PrinceHPBar:SetWidth(self.BossHPWidth)
	self.PrinceHPBar:SetHeight(7)
	
	self.StatusBar:SetWidth(7)
	self.StatusBar:SetHeight(self.PrinceStop:GetHeight() + 4)
	self.StatusForecast:SetWidth(7)
	self.StatusForecast:SetHeight(self.PrinceStop:GetHeight() + 4)
	
	self.SwingMulti = ((self.FBWidth * 0.75) * 0.5) * 0.25
end

function KM:BuildDisplay()
	self.FrameBase = UI.CreateFrame("Frame", "FrameBase", KBM.Context)
	self.FrameBase:SetVisible(false)
	self.FrameBase:SetLayer(2)
	if not self.Settings.PercentMonitor.x then
		self.FrameBase:SetPoint("CENTER", UIParent, "CENTER")
	else
		self.FrameBase:SetPoint("TOPLEFT", UIParent, "TOPLEFT", self.Settings.PercentMonitor.x, self.Settings.PercentMonitor.y)
	end
	self.FrameBase:SetBackgroundColor(0,0,0,0.4)
	self.FBLayer = self.FrameBase:GetLayer()

	self.KingText = UI.CreateFrame("Text", "KingText", self.FrameBase)
	self.KingText:SetText(self.King.Name)
	self.KingText:SetPoint("TOPLEFT", self.FrameBase, "TOPLEFT", 1, 0)
	
	self.PrinceText = UI.CreateFrame("Text", "PrinceText", self.FrameBase)
	self.PrinceText:SetText(self.Prince.Name)
	self.PrinceText:SetPoint("BOTTOMRIGHT", self.FrameBase, "BOTTOMRIGHT", -1, 0)
		
	self.KingPBack = UI.CreateFrame("Frame", "KingPBack", self.FrameBase)
	self.KingPText = UI.CreateFrame("Text", "KingPText", self.KingPBack)
	self.KingPText:SetText("100%")
	self.KingPBack:SetBackgroundColor(0,0,0,0.4)
	self.KingPBack:SetPoint("TOPCENTER", self.FrameBase, "TOPCENTER")
	self.KingPText:SetPoint("CENTER", self.KingPBack, "CENTER")
	self.KingPBack:SetLayer(1)
	self.KingPText:SetLayer(2)
	
	self.PrincePBack = UI.CreateFrame("Frame", "PrincePBack", self.FrameBase)
	self.PrincePText = UI.CreateFrame("Text", "PrincePText", self.PrincePBack)
	self.PrincePText:SetText("100%")
	self.PrincePBack:SetBackgroundColor(0,0,0,0.4)
	self.PrincePBack:SetPoint("BOTTOMCENTER", self.FrameBase, "BOTTOMCENTER")
	self.PrincePText:SetPoint("CENTER", self.PrincePBack, "CENTER")
	self.PrincePBack:SetLayer(1)
	self.PrincePText:SetLayer(2)
		
	self.SafeZone = UI.CreateFrame("Frame", "SafeZone", self.FrameBase)
	self.SafeZone:SetBackgroundColor(0,0.8,0,0.6)
	self.SafeZone:SetPoint("CENTER", self.FrameBase, "CENTER")
	
	self.KingDanger = UI.CreateFrame("Frame", "KingDanger", self.FrameBase)
	self.KingDanger:SetBackgroundColor(0.8,0.5,0,0.6)
	self.KingDanger:SetPoint("TOPRIGHT", self.SafeZone, "TOPLEFT")
	
	self.PrinceDanger = UI.CreateFrame("Frame", "PrinceDanger", self.FrameBase)
	self.PrinceDanger:SetBackgroundColor(0.8,0.5,0,0.6)
	self.PrinceDanger:SetPoint("TOPLEFT", self.SafeZone, "TOPRIGHT")
	
	self.KingStop = UI.CreateFrame("Frame", "KingStop", self.FrameBase)
	self.KingStop:SetBackgroundColor(0.8,0,0,0.6)
	self.KingStop:SetPoint("TOPRIGHT", self.KingDanger, "TOPLEFT")

	self.KingHPBar = UI.CreateFrame("Frame", "KingHPBar", self.FrameBase)
	self.KingHPBar:SetPoint("BOTTOMLEFT", self.KingStop, "TOPLEFT", 0, -1)
	self.KingHPBar:SetBackgroundColor(0,0.7,0,0.4)
	
	self.PrinceStop = UI.CreateFrame("Frame", "PrinceStop", self.FrameBase)
	self.PrinceStop:SetBackgroundColor(0.8,0,0,0.6)
	self.PrinceStop:SetPoint("TOPLEFT", self.PrinceDanger, "TOPRIGHT")

	self.PrinceHPBar = UI.CreateFrame("Frame", "PrinceHPBar", self.FrameBase)
	self.PrinceHPBar:SetPoint("TOPRIGHT", self.PrinceStop, "BOTTOMRIGHT", 0, 1)
	self.PrinceHPBar:SetBackgroundColor(0,0.7,0,0.4)
	
	self.StatusBar = UI.CreateFrame("Frame", "StatusBar", self.FrameBase)
	self.StatusBar:SetPoint("CENTER", self.FrameBase, "CENTER")
	self.StatusBar:SetBackgroundColor(0.9,0.9,0.9,0.9)
	self.StatusBar:SetLayer(3)

	self.StatusForecast = UI.CreateFrame("Frame", "StatusForecast", self.FrameBase)
	self.StatusForecast:SetPoint("CENTER", self.FrameBase, "CENTER")
	self.StatusForecast:SetBackgroundColor(0.9,0.9,0.9,0.3)
	self.StatusForecast:SetLayer(4)
		
	self.FrameBase:SetVisible(false)
	self.DragFrame = KBM.AttachDragFrame(self.FrameBase, KM.UpdateBaseVars, "FrameBase", 4)
	
	if not self.Settings.PercentMonitor.Compact then
		self:SetNormal()
	else
		self:SetCompact()
	end		
end

function KM:CastBars(units)
end

function KM.UpdateBaseVars(callType)
	if callType == "end" then
		KM.Settings.PercentMonitor.x = KM.FrameBase:GetLeft()
		KM.Settings.PercentMonitor.y = KM.FrameBase:GetTop()
	end	
end

function KM.Prince:PinCastBar()
	self.CastBar.GUI.Frame:ClearAll()
	self.CastBar.GUI.Frame:SetPoint("TOPLEFT", KM.FrameBase, "BOTTOMLEFT")
	self.CastBar.GUI.Frame:SetPoint("TOPRIGHT", KM.FrameBase, "BOTTOMRIGHT")
	self.CastBar.GUI.Frame:SetHeight(KM.IconSize)
	if KM.Settings.Compact then
		self.CastBar.GUI.Text:SetFontSize(16)
		self.CastBar.GUI.Shadow:SetFontSize(16)
	else
		self.CastBar.GUI.Text:SetFontSize(20)
		self.CastBar.GUI.Shadow:SetFontSize(20)
	end	
end

function KM.King:PinCastBar()
	self.CastBar.GUI.Frame:ClearAll()
	self.CastBar.GUI.Frame:SetPoint("BOTTOMLEFT", KM.FrameBase, "TOPLEFT")
	self.CastBar.GUI.Frame:SetPoint("BOTTOMRIGHT", KM.FrameBase, "TOPRIGHT")
	self.CastBar.GUI.Frame:SetHeight(KM.IconSize)
	if KM.Settings.Compact then
		self.CastBar.GUI.Text:SetFontSize(16)
		self.CastBar.GUI.Shadow:SetFontSize(16)
	else
		self.CastBar.GUI.Text:SetFontSize(20)
		self.CastBar.GUI.Shadow:SetFontSize(20)
	end		
end

function KM:Timer(current, diff)
	if self.EncounterRunning then
		local udiff = current - self.UpdateTime
		if diff >= 1 then
			self:DPSUpdate()
		elseif udiff > 0.05 then
			self:CheckTrends()
			self.UpdateTime = current
		end
	end
end

function KM:OptionsClose()
end

function KM.King:SetTimers(bool)	
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

function KM.King:SetAlerts(bool)
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

function KM.Prince:SetTimers(bool)
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

function KM.Prince:SetAlerts(bool)
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

KM.Custom = {}
KM.Custom.Encounter = {}
function KM.Custom.Encounter.Menu(Menu)

	local Callbacks = {}

	function Callbacks:Enabled(bool)
		KM.Settings.PercentMonitor.Enabled = bool
	end
	function Callbacks:Visible(bool)
		KM.Settings.PercentMonitor.Visible = bool
		KM.Settings.PercentMonitor.Unlocked = bool
		KM.FrameBase:SetVisible(bool)
		KM.DragFrame:SetVisible(bool)
	end
	function Callbacks:Compact(bool)
		KM.Settings.PercentMonitor.Compact = bool
		KM.King.CastBar:Hide()
		KM.Prince.CastBar:Hide()
		if bool then
			KM:SetCompact()
		else
			KM:SetNormal()
		end
		KM.King.CastBar:Display()
		KM.Prince.CastBar:Display()
	end

	local Settings = KM.Settings.PercentMonitor
	Header = Menu:CreateHeader(KM.Lang.Options.Monitor.Enabled[KBM.Lang], "check", "Encounter", "Main")
	Header:SetChecked(Settings.Enabled)
	Header:SetHook(Callbacks.Enabled)
	Child = Header:CreateOption(KM.Lang.Options.Monitor.Visible[KBM.Lang], "check", Callbacks.Visible)
	Child:SetChecked(Settings.Visible)
	Child = Header:CreateOption(KM.Lang.Options.Monitor.Compact[KBM.Lang], "check", Callbacks.Compact)
	Child:SetChecked(Settings.Compact)
	
end

function KM.Custom.SetPage()
	if KM.Settings.PercentMonitor.Enabled then
		if KM.Settings.PercentMonitor.Visible then
			KM.FrameBase:SetVisible(true)
		end
	end
end

function KM.Custom.ClearPage()
	if not KM.EncounterRunning then
		KM.FrameBase:SetVisible(false)
	end
end

function KM.Custom.Encounter.SetPage()
end

function KM.Custom.Encounter.ClearPage()
end

function KM:DefineMenu()
	self.Menu = HK.Menu:CreateEncounter(self.King, self.Enabled)
end

function KM:Start()

	self.FBDefX = self.Settings.LocX
	self.FBDefY = self.Settings.LocY
		
	-- Add King's Timers
	self.King.TimersRef.Cursed = KBM.MechTimer:Add(KM.Lang.Ability.Cursed[KBM.Lang], 55)
	self.King.TimersRef.Essence = KBM.MechTimer:Add("(King) "..KM.Lang.Ability.Essence[KBM.Lang], 22)
	self.King.TimersRef.Rev = KBM.MechTimer:Add(self.Lang.Unit.Revenant[KBM.Lang], 82)
	self.King.TimersRef.Shout = KBM.MechTimer:Add(KM.Lang.Ability.Shout[KBM.Lang], 30)
	self.King.TimersRef.Feedback = KBM.MechTimer:Add(KM.Lang.Ability.Feedback[KBM.Lang], 48)
	KBM.Defaults.TimerObj.Assign(self.King)
	
	-- Add King's Alerts
	self.King.AlertsRef.Cursed = KBM.Alert:Create(KM.Lang.Ability.Cursed[KBM.Lang], 9, true, nil, "red")
	self.King.AlertsRef.Essence = KBM.Alert:Create(KM.Lang.Ability.Essence[KBM.Lang], 2, true, nil, "yellow")
	self.King.AlertsRef.FeedbackWarn = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], nil, false, "blue")
	self.King.AlertsRef.Feedback = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], 5, true, true, "blue")
	self.King.AlertsRef.Feedback:NoMenu()
	self.King.AlertsRef.Shout = KBM.Alert:Create(KM.Lang.Ability.Shout[KBM.Lang], 2, true, true, "purple")
	KBM.Defaults.AlertObj.Assign(self.King)
	
	-- Assign King's Mechanics to Triggers
	self.King.Triggers.Cursed = KBM.Trigger:Create(KM.Lang.Ability.Cursed[KBM.Lang], "cast", self.King)
	self.King.Triggers.Cursed:AddTimer(self.King.TimersRef.Cursed)
	self.King.Triggers.Cursed:AddAlert(self.King.AlertsRef.Cursed)
	self.King.Triggers.Shout = KBM.Trigger:Create(KM.Lang.Ability.Shout[KBM.Lang], "cast", self.King)
	self.King.Triggers.Shout:AddTimer(self.King.TimersRef.Shout)
	self.King.Triggers.Shout:AddAlert(self.King.AlertsRef.Shout)
	self.King.Triggers.Essence = KBM.Trigger:Create(KM.Lang.Ability.Essence[KBM.Lang], "cast", self.King)
	self.King.Triggers.Essence:AddTimer(self.King.TimersRef.Essence)
	self.King.Triggers.Essence:AddAlert(self.King.AlertsRef.Essence)
	self.King.AlertsRef.Essence:Important()
	self.King.Triggers.Feedback = KBM.Trigger:Create(KM.Lang.Ability.Feedback[KBM.Lang], "cast", self.King)
	self.King.Triggers.Feedback:AddTimer(self.King.TimersRef.Feedback)
	self.King.Triggers.Feedback:AddAlert(self.King.AlertsRef.FeedbackWarn)
	self.King.AlertsRef.Feedback:AlertEnd(self.King.AlertsRef.Feedback)
	self.King.Triggers.Rev = KBM.Trigger:Create(self.Lang.Notify.Rev[KBM.Lang], "notify", self.King)
	self.King.Triggers.Rev:AddTimer(self.King.TimersRef.Rev)
	self.King.Triggers.PhaseTwo = KBM.Trigger:Create(90, "percent", self.King)
	self.King.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.King.Triggers.PhaseThree = KBM.Trigger:Create(65, "percent", self.King)
	self.King.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.King.Triggers.PhaseFour = KBM.Trigger:Create(40, "percent", self.King)
	self.King.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	-- Add Prince's Timers
	self.Prince.TimersRef.Terminate = KBM.MechTimer:Add(KM.Lang.Ability.Terminate[KBM.Lang], 21)
	self.Prince.TimersRef.Essence = KBM.MechTimer:Add("(Prince) "..KM.Lang.Ability.Essence[KBM.Lang], 22)
	self.Prince.TimersRef.Feedback = KBM.MechTimer:Add(KM.Lang.Ability.Feedback[KBM.Lang], 48)
	KBM.Defaults.TimerObj.Assign(self.Prince)
	
	-- Add Prince's Alerts
	self.Prince.AlertsRef.Terminate = KBM.Alert:Create(KM.Lang.Ability.Terminate[KBM.Lang], 3, true, nil, "orange")
	self.Prince.AlertsRef.Essence = KBM.Alert:Create(KM.Lang.Ability.Essence[KBM.Lang], 2, true, nil, "yellow")
	self.Prince.AlertsRef.FeedbackWarn = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], nil, false, true, "blue")
	self.Prince.AlertsRef.Feedback = KBM.Alert:Create(KM.Lang.Ability.Feedback[KBM.Lang], 5, true, true, "blue")
	self.Prince.AlertsRef.Feedback:NoMenu()
	KBM.Defaults.AlertObj.Assign(self.Prince)
	
	-- Assign Prince's Mechanics to Triggers
	self.Prince.Triggers.Terminate = KBM.Trigger:Create(KM.Lang.Ability.Terminate[KBM.Lang], "cast", self.Prince)
	self.Prince.Triggers.Terminate:AddTimer(self.Prince.TimersRef.Terminate)
	self.Prince.Triggers.Terminate:AddAlert(self.Prince.AlertsRef.Terminate)
	self.Prince.Triggers.Essence = KBM.Trigger:Create(KM.Lang.Ability.Essence[KBM.Lang], "cast", self.Prince)
	self.Prince.Triggers.Essence:AddTimer(self.Prince.TimersRef.Essence)
	self.Prince.Triggers.Essence:AddAlert(self.Prince.AlertsRef.Essence)
	self.Prince.AlertsRef.Essence:Important()
	self.Prince.Triggers.Feedback = KBM.Trigger:Create(KM.Lang.Ability.Feedback[KBM.Lang], "cast", self.Prince)
	self.Prince.Triggers.Feedback:AddTimer(self.Prince.TimersRef.Feedback)
	self.Prince.Triggers.Feedback:AddAlert(self.Prince.AlertsRef.FeedbackWarn)
	self.Prince.AlertsRef.Feedback:AlertEnd(self.Prince.AlertsRef.Feedback)
	self.Prince.Triggers.PhaseTwo = KBM.Trigger:Create(90, "percent", self.Prince)
	self.Prince.Triggers.PhaseTwo:AddPhase(self.PhaseTwo)
	self.Prince.Triggers.PhaseThree = KBM.Trigger:Create(65, "percent", self.Prince)
	self.Prince.Triggers.PhaseThree:AddPhase(self.PhaseThree)
	self.Prince.Triggers.PhaseFour = KBM.Trigger:Create(40, "percent", self.Prince)
	self.Prince.Triggers.PhaseFour:AddPhase(self.PhaseFour)
	
	self.King.CastBar = KBM.CastBar:Add(self, self.King)
	self.Prince.CastBar = KBM.CastBar:Add(self, self.Prince)
	
	--self.KingMolinar:Options()
	if not self.DisplayReady then
		self.DisplayReady = true
		self:BuildDisplay()
	end
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
	
end
