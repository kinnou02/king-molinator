-- King Molinar Boss Mod for KM:Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--
KM_Settings = nil

local KM = {
	ModEnabled = true,
	MenuName = "King Molinar",
	Bosses = {
		["Rune King Molinar"] = true,
		["Prince Dollin"] = true,
	},
	ID = nil,
	KingMolinar = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		Name = "King Molinar",
		ID = "KingMolinar",
	},
	Instance = "Hammerknell",
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
KM.KingCastbar = nil
KM.PrinceCastbar = nil
KM.IconSize = nil
KM.PrinceCastIcon = nil
KM.KingCastIcon = nil
KM.AbilityWatch = {}
KM.KingCastText = nil
KM.PrinceCastText = nil

KM.Abilities = {}

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
KM.KingName = "Rune King Molinar"
KM.KingSearchName = "Molinar"
KM.KingDead = false
KM.KingUnavail = false
KM.KingCasting = false
KM.KingLastCast = ""
-- Prince Dollin
KM.PrinceHPP = "100" -- Visual percentage
KM.PrincePerc = 1 -- Decimal percentage holder.
KM.PrinceHPMax = 4200000 -- Dummy HP value for testing, will be overridden during encounter start
KM.PrinceDPSTable = {}
KM.PrinceLastHP = 0
KM.PrinceSample = 0 -- Total damage done to Prince Dollin over {SampleDPS} seconds.
KM.PrinceSampleDPS = 0 -- Average DPS done to Prince Dollin over {SampleDPS} seconds.
KM.PrinceName = "Prince Dollin"
KM.PrinceSearchName = "Dollin"
KM.PrinceDead = false
KM.PrinceUnavail = false
KM.PrinceCasting = false
KM.PrinceLastCast = ""
-- State Variables
KM.EncounterRunning = false
KM.KingID = nil
KM.PrinceID = nil
KM.StartTime = Inspect.Time.Real()
KM.HeldTime = KM.StartTime
KM.UpdateTime = KM.StartTime
KM.TimeElapsed = 0
KM.DisplayReady = false
KM.CurrentSwing = 0
KM.ForecastSwing = 0

local KBM = KBM_RegisterMod("Molinar", KM)

KM.Prince = {
	Mod = KM,
	Level = "??",
	Active = false,
	Name = "Prince Dollin",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}
KM.King = {
	Mod = KM,
	Level = "??",
	Active = false,
	Name = "Rune King Molinar",
	Castbar = nil,
	CastFilters = {},
	Timers = {},
	Dead = false,
	Available = false,
	UnitID = nil,
}

function KM:AddBosses(KBM_Boss)
	if KBM.Lang == "German" then
		self.King.Name = "Runenkönig Molinar"
		self.Prince.Name = "Prinz Dollin"
	elseif KBM.Lang == "French" then
		self.King.Name = "Roi runique Molinar"
	end
	self.Prince.Descript = self.King.Name.." & "..self.Prince.Name
	self.King.Descript = self.Prince.Descript
	KBM_Boss[self.Prince.Name] = self.Prince
	KBM_Boss[self.King.Name] = self.King
end

function KM:InitVars()
	self.Settings = {
		LocX = nil,
		LocY = nil,
		Size = 1,
		SampleDPS = 4,
		Hidden = false,
		Locked = false,
		Compact = false,
		AutoReset = true,
		PrinceBar = true,
		KingBar = true,
		Enabled = true,
		RendEnabled = true,
		TerminateEnabled = true,
		PCEssenceEnabled = true,
		KCEssenceEnabled = true,
		CursedEnabled = true,
		FShoutEnabled = true,
		RFeedbackEnabled = true,
		CrushingEnabled = true,
		FBlastEnabled = true,
	}
	KM_Settings = self.Settings
end

function KM:LoadVars()
	for Setting, Value in pairs(KM_Settings) do
		if type(KM_Settings[Setting]) == "table" then
			if #KM_Settings[Setting] then
				for tSetting, tValue in pairs(KM_Settings[Setting]) do
					self.Settings[Setting][tSetting] = tValue
				end
			end
		else
			self.Settings[Setting] = Value	
		end
	end
	KM.Prince.CastFilters["Rend Life"] = {Enabled = self.Settings.RendEnabled}
	KM.Prince.CastFilters["Terminate Life"] = {Enabled = self.Settings.TerminateEnabled}
	KM.Prince.CastFilters["Consuming Essence"] = {Enabled = self.Settings.PCEssenceEnabled}
	KM.Prince.CastFilters["Runic Feedback"] = {Enabled = self.Settings.RFeedbackEnabled}
	KM.Prince.CastFilters["Crushing Regret"] = {Enabled = self.Settings.CrushingEnabled}
	KM.Prince.CastFilters["Forked Blast"] = {Enabled = self.Settings.FBlastEnabled}
	KM.King.CastFilters["Frightening Shout"] = {Enabled = self.Settings.FShoutEnabled}
	KM.King.CastFilters["Cursed Blows"] = {Enabled = self.Settings.CursedEnabled}
	KM.King.CastFilters["Consuming Essence"] = {Enabled = self.Settings.KCEssenceEnabled}	
end

function KM:SaveVars()
	KM_Settings = self.Settings
end

function KM:RemoveUnits(UnitID)
	if self.KingID == UnitID then
		self.KingUnavail = true
	elseif self.PrinceID == UnitID then
		self.PrinceUnavail = true
	end
	if self.PrinceUnavail and self.KingUnavail then
		return true
	end
	return false
end

function KM:Death(UnitID)
	if self.KingID == UnitID then
		self.King.Dead = true
	elseif self.PrinceID == UnitID then
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
				if not self.KingID then
					self.KingID = unitID
					if not self.EncounterRunning then
						self.EncounterRunning = true
						KBM.Encounter = false
					end
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.KingLastHP = unitDetails.healthMax
					self.KingHPMax = self.KingLastHP
					self.FrameBase:SetVisible(true)
					self.KingDead = false
					self.KingUnavail = false
					self.KingCasting = false
				end
			elseif unitDetails.name == self.Prince.Name then
				if not self.PrinceID then
					self.PrinceID = unitID
					if not self.EncounterRunning then
						self.EncounterRunning = true
						KBM.Encounter = false
					end
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					self.PrinceLastHP = unitDetails.healthMax
					self.PrinceHPMax = self.PrinceLastHP
					self.FrameBase:SetVisible(true)
					self.PrinceDead = false
					self.PrinceUnavail = false
					self.PrinceCasting = false
				end
			end
		end
	end
end

function KM:Reset()
	KBM.Encounter = false
	self.EncounterRunning = false
	if self.KingID then
		KBM.BossID[self.KingID] = nil
	end
	self.KingID = nil
	if self.PrinceID then
		KBM.BossID[self.PrinceID] = nil
	end
	self.PrinceID = nil
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
	self.KingUnavail = false
	self.PrinceUnavail = false
	if self.Settings.Hidden then
		self.FrameBase:SetVisible(false)
	end
	self.KingCastbar:SetVisible(false)
	self.KingCastIcon:SetTexture("", "")
	self.KingCastIcon:SetVisible(false)
	self.KingCastProgress:SetWidth(0)
	self.KingCastText:SetText("")
	self.KingCasting = false
	self.PrinceCastbar:SetVisible(false)
	self.PrinceCastIcon:SetTexture("", "")
	self.PrinceCastIcon:SetVisible(false)
	self.PrinceCastProgress:SetWidth(0)
	self.PrinceCastText:SetText("")
	self.PrinceCasting = false
	print("Monitor reset.")
end

function KM:CheckTrends()
	-- Adjust the Current and Trend bars accordingly.
	
	if self.KingID ~= nil and self.PrinceID ~= nil then
		-- King Calc
		local KingForecastHP = self.KingLastHP-(self.KingSampleDPS * 4)
		local KingForecastP = KingForecastHP / self.KingHPMax
		local KingMulti = self.KingPerc*100
		local stupidKing = math.floor(KingMulti)
		if (KingMulti - stupidKing) > 0.005 then -- Account for lag
			stupidKing = stupidKing + 1
		end
		self.KingHPP = tostring(stupidKing).."%"
		-- Prince Calc
		local PrinceForecastHP = self.PrinceLastHP-(self.PrinceSampleDPS * 4)
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
	
	if self.KingID and self.PrinceID then
		local DumpDPS = 0
		local KingDetails = Inspect.Unit.Detail(self.KingID)
		local PrinceDetails = Inspect.Unit.Detail(self.PrinceID)
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
		self:CheckTrends()
	end
end

function KM.HPChangeCheck(units)
end

function KM:SetNormal()
	self.FrameBase:SetHeight(self.FBHeight)
	self.FrameBase:SetWidth(self.FBWidth)
	
	self.IconSize = 36
	
	self.KingCastbar:SetWidth(self.FBWidth)
	self.KingCastbar:SetHeight(self.IconSize)
	self.KingCastIcon:SetWidth(self.IconSize)
	self.KingCastIcon:SetHeight(self.IconSize)
	self.KingCastProgress:SetHeight(self.IconSize)
	self.KingCastProgress:SetWidth(0)
	self.KingCastText:SetFontSize(20)
	
	self.PrinceCastbar:SetWidth(self.FBWidth)
	self.PrinceCastbar:SetHeight(self.IconSize)
	self.PrinceCastIcon:SetWidth(self.IconSize)
	self.PrinceCastIcon:SetHeight(self.IconSize)
	self.PrinceCastProgress:SetHeight(self.IconSize)
	self.PrinceCastProgress:SetWidth(0)
	self.PrinceCastText:SetFontSize(20)
	
	self.KingText:SetWidth(self.KingText:GetFullWidth())
	self.KingText:SetHeight(self.KingText:GetFullHeight())
	
	self.PrinceText:SetWidth(self.PrinceText:GetFullWidth())
	self.PrinceText:SetHeight(self.PrinceText:GetFullHeight())
	
	self.KingPText:SetFontSize(16)
	self.KingPText:SetWidth(self.KingPText:GetFullWidth())
	self.KingPText:SetHeight(self.KingPText:GetFullHeight())
	self.KingPBack:SetWidth(self.KingPText:GetWidth() + 6)
	self.KingPBack:SetHeight(self.KingPText:GetHeight() + 4)

	self.PrincePText:SetFontSize(16)
	self.PrincePText:SetWidth(self.PrincePText:GetFullWidth())
	self.PrincePText:SetHeight(self.PrincePText:GetFullHeight())
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
	
	self.KingCastbar:SetWidth((self.FBWidth * 0.75))
	self.KingCastbar:SetHeight(self.IconSize)
	self.KingCastIcon:SetWidth(self.IconSize)
	self.KingCastIcon:SetHeight(self.IconSize)
	self.KingCastProgress:SetHeight(self.IconSize)
	self.KingCastProgress:SetWidth(0)
	self.KingCastText:SetFontSize(16)
	
	self.PrinceCastbar:SetWidth((self.FBWidth * 0.75))
	self.PrinceCastbar:SetHeight(self.IconSize)
	self.PrinceCastIcon:SetWidth(self.IconSize)
	self.PrinceCastIcon:SetHeight(self.IconSize)
	self.PrinceCastProgress:SetHeight(self.IconSize)
	self.PrinceCastProgress:SetWidth(0)
	self.PrinceCastText:SetFontSize(16)
	
	self.KingText:SetWidth(self.KingText:GetFullWidth())
	self.KingText:SetHeight(self.KingText:GetFullHeight())
	
	self.PrinceText:SetWidth(self.PrinceText:GetFullWidth())
	self.PrinceText:SetHeight(self.PrinceText:GetFullHeight())
	
	self.KingPText:SetFontSize(12)
	self.KingPText:SetWidth(self.KingPText:GetFullWidth())
	self.KingPText:SetHeight(self.KingPText:GetFullHeight())
	self.KingPBack:SetWidth(self.KingPText:GetWidth() + 2)
	self.KingPBack:SetHeight(self.KingPText:GetHeight() + 1)

	self.PrincePText:SetFontSize(12)
	self.PrincePText:SetWidth(self.PrincePText:GetFullWidth())
	self.PrincePText:SetHeight(self.PrincePText:GetFullHeight())
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
	if self.FBDefX == nil then
		self.FrameBase:SetPoint("CENTERX", UIParent, "CENTERX")
	else
		self.FrameBase:SetPoint("LEFT", UIParent, "LEFT", self.FBDefX, nil)
	end
	if self.FBDefY == nil then
		self.FrameBase:SetPoint("CENTERY", UIParent, "CENTERY")
	else
		self.FrameBase:SetPoint("TOP", UIParent, "TOP", nil, self.FBDefY)
	end
	self.FrameBase:SetBackgroundColor(0,0,0,0.4)
	self.FBLayer = self.FrameBase:GetLayer()
	
	self.KingCastbar = UI.CreateFrame("Frame", "KingCastbar", self.FrameBase)
	self.KingCastProgress = UI.CreateFrame("Frame", "KingCastProgress", self.KingCastbar)
	self.KingCastIcon = UI.CreateFrame("Texture", "KingCastIcon", self.FrameBase)
	self.KingCastText = UI.CreateFrame("Text", "KingCastText", self.KingCastbar)
	self.KingCastProgress:SetLayer(1)
	self.KingCastIcon:SetLayer(2)
	self.KingCastText:SetLayer(2)
	self.KingCastText:SetPoint("CENTER", self.KingCastbar, "CENTER")
	self.KingCastbar:SetPoint("BOTTOMRIGHT", self.FrameBase, "TOPRIGHT")
	self.KingCastIcon:SetPoint("BOTTOMLEFT", self.FrameBase, "TOPLEFT")
	self.KingCastProgress:SetPoint("TOPLEFT", self.KingCastbar, "TOPLEFT")
	self.KingCastbar:SetBackgroundColor(0,0,0,0.3)
	self.KingCastProgress:SetBackgroundColor(0.7,0,0,0.5)
	self.KingCastbar:SetVisible(false)
	
	self.PrinceCastbar = UI.CreateFrame("Frame", "PrinceCastbar", self.FrameBase)
	self.PrinceCastProgress = UI.CreateFrame("Frame", "PrinceCastProgress", self.PrinceCastbar)
	self.PrinceCastIcon = UI.CreateFrame("Texture", "PrinceCastIcon", self.FrameBase)
	self.PrinceCastText = UI.CreateFrame("Text", "PrinceCastText", self.PrinceCastbar)
	self.PrinceCastProgress:SetLayer(1)
	self.PrinceCastIcon:SetLayer(2)
	self.PrinceCastText:SetLayer(2)
	self.PrinceCastText:SetPoint("CENTER", self.PrinceCastbar, "CENTER")
	self.PrinceCastbar:SetPoint("TOPRIGHT", self.FrameBase, "BOTTOMRIGHT")
	self.PrinceCastIcon:SetPoint("TOPLEFT", self.FrameBase, "BOTTOMLEFT")
	self.PrinceCastProgress:SetPoint("TOPLEFT", self.PrinceCastbar, "TOPLEFT")
	self.PrinceCastbar:SetBackgroundColor(0,0,0,0.3)
	self.PrinceCastProgress:SetBackgroundColor(0.7,0,0,0.5)
	self.PrinceCastbar:SetVisible(false)
	
	self.KingText = UI.CreateFrame("Text", "KingText", self.FrameBase)
	self.KingText:SetText(self.KingName)
	self.KingText:SetPoint("TOPLEFT", self.FrameBase, "TOPLEFT", 1, 0)
	
	self.PrinceText = UI.CreateFrame("Text", "PrinceText", self.FrameBase)
	self.PrinceText:SetText(self.PrinceName)
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
		
	self.FrameBase:SetVisible(true)
	self.DragFrame = KBM.AttachDragFrame(self.FrameBase, KM.UpdateBaseVars, "FrameBase", 4)
	
	if not self.Settings.Compact then
		self:SetNormal()
	else
		self:SetCompact()
	end
		
	if self.Settings.Hidden then
		self.FrameBase:SetVisible(false)
	end
	if self.Settings.Locked then
		self.DragFrame:SetVisible(false)
	end
	
end

function KM.UpdateBaseVars(callType)
	if callType == "start" then
		KM.KingCastbar:SetVisible(true)
		KM.PrinceCastbar:SetVisible(true)
	elseif callType == "end" then
		KM.Settings.LocX = KM.FrameBase:GetLeft()
		KM.Settings.LocY = KM.FrameBase:GetTop()
		if not KM.KingCasting then
			KM.KingCastbar:SetVisible(false)
		end
		if not KM.PrinceCasting then
			KM.PrinceCastbar:SetVisible(false)
		end
	end
end

function KM:UpdateKingCast()
	local bDetails = Inspect.Unit.Castbar(self.KingID)
	if bDetails then
		if bDetails.abilityName then
			--print("(KING) Checking cast update: "..bDetails.abilityName)
			if KM.King.CastFilters[bDetails.abilityName] and KM.Settings.KingBar then
				--print("King Cast Found")
				if KM.King.CastFilters[bDetails.abilityName].Enabled then
					if not self.KingCasting then
						self.KingCasting = true
						self.KingCastbar:SetVisible(true)
					end
					bCastTime = bDetails.duration
					bProgress = bDetails.remaining
					self.KingCastProgress:SetWidth(self.KingCastbar:GetWidth() * (1-(bProgress/bCastTime)))
					self.KingCastText:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
					self.KingCastText:SetWidth(self.KingCastText:GetFullWidth())
					self.KingCastText:SetHeight(self.KingCastText:GetFullHeight())
				end
			end
			if self.KingLastCast ~= bDetails.abilityName then
				self.KingLastCast = bDetails.abilityName
				if self.King.Timers[bDetails.abilityName] then
					self.King.Timers[bDetails.abilityName]:Start(Inspect.Time.Real())
				end
			end
		end
	else
		self.KingCastbar:SetVisible(false)
		self.KingCastIcon:SetTexture("", "")
		self.KingCastIcon:SetVisible(false)
		self.KingCastProgress:SetWidth(0)
		self.KingCastText:SetText("")
		self.KingCasting = false
		self.KingLastCast = ""
	end
end

function KM:ManageKingCasts(Visible)
	--[[if Visible then
		local bDetails = Inspect.Unit.Castbar(self.KingID)
		if bDetails then
			if bDetails.abilityName then
				if self.AbilityWatch[bDetails.abilityName] then
					if self.AbilityWatch[bDetails.abilityName].KingWatch then
						--local aDetails = Inspect.Ability.Detail(bDetails.ability)
						if aDetails then
							self.KingCastIcon:SetTexture("Rift", aDetails.icon)
							self.KingCastIcon:SetVisible(true)
							self.KingCasting = true
							self.KingCastbar:SetVisible(true)
						else
						self.KingCasting = true
						self.KingCastbar:SetVisible(true)	
						--end
					end
				end
			end
		end
	else
		self.KingCastbar:SetVisible(false)
		self.KingCastIcon:SetTexture("", "")
		self.KingCastIcon:SetVisible(false)
		self.KingCastProgress:SetWidth(0)
		self.KingCastText:SetText("")
		self.KingCasting = false	
	end]]
end

function KM:UpdatePrinceCast()
	local bDetails = Inspect.Unit.Castbar(self.PrinceID)
	if bDetails then
		if bDetails.abilityName then
			--print("(PRINCE) Checking cast update: "..bDetails.abilityName)
			--print("Table: "..tostring(self.Prince.CastFilters[bDetails.abilityName]))
			if self.Prince.CastFilters[bDetails.abilityName] and self.Settings.PrinceBar then
				--print("Prince Cast Found")
				if self.Prince.CastFilters[bDetails.abilityName].Enabled then
					if not self.PrinceCasting then
						self.PrinceCasting = true
						self.PrinceCastbar:SetVisible(true)
					end
					bCastTime = bDetails.duration
					bProgress = bDetails.remaining
					self.PrinceCastProgress:SetWidth(self.PrinceCastbar:GetWidth() * (1-(bProgress/bCastTime)))
					self.PrinceCastText:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
					self.PrinceCastText:SetWidth(self.PrinceCastText:GetFullWidth())
					self.PrinceCastText:SetHeight(self.PrinceCastText:GetFullHeight())
				end
			end
			if self.PrinceLastCast ~= bDetails.abilityName then
				self.PrinceLastCast = bDetails.abilityName
				if self.Prince.Timers[bDetails.abilityName] then
					self.Prince.Timers[bDetails.abilityName]:Start(Inspect.Time.Real())
				end
			end
		end
	else
		self.PrinceCastbar:SetVisible(false)
		self.PrinceCastIcon:SetTexture("", "")
		self.PrinceCastIcon:SetVisible(false)
		self.PrinceCastProgress:SetWidth(0)
		self.PrinceCastText:SetText("")
		self.PrinceCasting = false
		self.PrinceLastCast = ""
	end
end

function KM:ManagePrinceCasts(Visible)
	--[[if Visible then
		local bDetails = Inspect.Unit.Castbar(self.PrinceID)
		if bDetails then
			if bDetails.abilityName then
				if self.AbilityWatch[bDetails.abilityName] then
					if self.AbilityWatch[bDetails.abilityName].PrinceWatch then
						--local aDetails = Inspect.Ability.Detail(bDetails.ability)
						if aDetails then
							self.PrinceCastIcon:SetTexture("Rift", aDetails.icon)
							self.PrinceCastIcon:SetVisible(true)
							self.PrinceCasting = true
							self.PrinceCastbar:SetVisible(true)
						else
							self.PrinceCasting = true
							self.PrinceCastbar:SetVisible(true)
						--end
					end
				end
			end
		end
	--else
		self.PrinceCastbar:SetVisible(false)
		self.PrinceCastIcon:SetTexture("", "")
		self.PrinceCastIcon:SetVisible(false)
		self.PrinceCastProgress:SetWidth(0)
		self.PrinceCastText:SetText("")
		self.PrinceCasting = false	
	end]]
end

function KM:CastBar(units)
	--[[local processed = 0
	for UnitID, Visible in pairs(units) do
		if UnitID == self.KingID then
			if self.Settings.KingBar then
				self:ManageKingCasts(Visible)
				--processed = processed + 1
			end
		elseif UnitID == self.PrinceID then
			if self.Settings.PrinceBar then
				self:ManagePrinceCasts(Visible)
				--processed = processed + 1
			end
		--elseif UnitID == KBM_PlayerID then
		--	self.ManageTestCasts(Visible)
		end
		if processed == 2 then
			return
		end
	end]]
end

function KM:Timer(current, diff)
	if self.EncounterRunning then
		local udiff = current - self.UpdateTime
		if diff >= 1 then
			self:DPSUpdate()
		elseif udiff > 0.095 then
			self:CheckTrends()
			self.UpdateTime = current
		end
		if self.PrinceID then
			self:UpdatePrinceCast()
		end
		if self.KingID then
			self:UpdateKingCast()
		end
	end
	--self.UpdateTestBar()
end

function KM.KingMolinar:OptionsClose()
	self.Monitor = nil
	self.KingMech = nil
	self.PrinceMech = nil
end

function KM.KingMolinar:Options()
	function self:Hidden(bool)
		KM.Settings.Hidden = bool
		if bool then
			KM.FrameBase:SetVisible(false)
		else
			KM.FrameBase:SetVisible(true)
		end
	end
	function self:Compact(bool)
		KM.Settings.Compact = bool
		if not KM.Settings.Compact then
			KM:SetNormal()
		else
			KM:SetCompact()
		end
	end
	function self:Locked(bool)
		KM.Settings.Locked = bool
		if bool then
			KM.DragFrame:SetVisible(false)
		else
			KM.DragFrame:SetVisible(true)
		end
	end
	function self:KingEnabled(bool)
		KM.Settings.KingBar = bool
	end
	function self:PrinceEnabled(bool)
		KM.Settings.PrinceBar = bool
	end
	function self:RendEnabled(bool)
		KM.Settings.RendEnabled = bool
		KM.Prince.CastFilters["Rend Life"].Enabled = bool
		print("Rend Life changed to: "..tostring(bool))
	end
	function self:TerminateEnabled(bool)
		KM.Settings.TerminateEnabled = bool
		KM.Prince.CastFilters["Terminate Life"].Enabled = bool
	end
	function self:PCEssenceEnabled(bool)
		KM.Settings.PCEssenceEnabled = bool
		KM.Prince.CastFilters["Consuming Essence"].Enabled = bool
	end
	function self:KCEssenceEnabled(bool)
		KM.Settings.KCEssenceEnabled = bool
		KM.King.CastFilters["Consuming Essence"].Enabled = bool
	end
	function self:CursedEnabled(bool)
		KM.Settings.CursedEnabled = bool
		KM.King.CastFilters["Cursed Blows"].Enabled = bool
	end
	function self:FShoutEnabled(bool)
		KM.Settings.FShoutEnabled = bool
		KM.King.CastFilters["Frightening Shout"].Enabled = bool
	end
	function self:RFeedbackEnabled(bool)
		KM.Settings.RFeedbackEnabled = bool
		KM.Prince.CastFilters["Runic Feedback"].Enabled = bool
	end
	function self:CrushingEnabled(bool)
		KM.Settings.CrushingEnabled = bool
		KM.Prince.CastFilters["Crushing Regret"].Enabled = bool
	end
	function self:FBlastEnabled(bool)
		KM.Settings.FBlastEnabled = bool
		KM.Prince.CastFilters["Forked Blast"].Enabled = bool
	end
	function self:MonitorEnabled(bool)
		if bool then
			--print("Monitor is now Enabled")
		else
			--print("Monitor is now Disabled")
		end
	end
	local Options = self.MenuItem.Options
	Options:SetTitle()
	local Monitor = Options:AddHeader("Show Percentage Monitor", self.MonitorEnabled, KM.Settings.Enabled)
	--self.Monitor.Check.Frame:SetEnabled(false) -- Temporarily disabled.
	Monitor:AddCheck("Hidden until encounter starts.", self.Hidden, KM.Settings.Hidden)
	Monitor:AddCheck("Compact Mode.", self.Compact, KM.Settings.Compact)
	Monitor:AddCheck("Locked in place.", self.Locked, KM.Settings.Locked)
	Options:AddSpacer()
	local KingMech = Options:AddHeader("Show King Molinar's cast-bar.", self.KingEnabled, KM.Settings.KingBar)
	KingMech:AddCheck("Frightening Shout cast.", self.FShoutEnabled, KM.Settings.FShoutEnabled)
	KingMech:AddCheck("Cursed Blows cast.", self.CursedEnabled, KM.Settings.CursedEnabled)
	KingMech:AddCheck("Consuming Essence cast.", self.KCEssenceEnabled, KM.Settings.KCEssenceEnabled)
	Options:AddSpacer()
	local PrinceMech = Options:AddHeader("Show Prince Dollin's cast-bar.", self.PrinceEnabled, KM.Settings.PrinceBar)
	PrinceMech:AddCheck("Rend Life cast.", self.RendEnabled, KM.Settings.RendEnabled)
	PrinceMech:AddCheck("Terminate Life cast.", self.TerminateEnabled, KM.Settings.TerminateEnabled)
	PrinceMech:AddCheck("Crushing Regret cast.", self.CrushingEnabled, KM.Settings.CrushingEnabled)
	PrinceMech:AddCheck("Consuming Essence cast.", self.PCEssenceEnabled, KM.Settings.PCEssenceEnabled)
	PrinceMech:AddCheck("Runic Feedback cast.", self.RFeedbackEnabled, KM.Settings.RFeedbackEnabled)
	PrinceMech:AddCheck("Forked Blast cast.", self.FBlastEnabled, KM.Settings.FBlastEnabled)
end

function KM:Start()
	self.FBDefX = self.Settings.LocX
	self.FBDefY = self.Settings.LocY
	self.Header = KBM.HeaderList[self.Instance]
	self.KingMolinar.MenuItem = KBM.MainWin.Menu:CreateEncounter(self.KingMolinar.Name, self.KingMolinar, true, self.Header)
	self.KingMolinar.MenuItem.Check:SetEnabled(false)
	
	KBM.MechTimer:Add("Cursed Blows", "cast", 55, self.King, true)
	KBM.MechTimer:Add("Consuming Essence", "cast", 22, self.King, true, "(King) Consuming Essence")
	KBM.MechTimer:Add("Terminate Life", "cast", 21, self.Prince, true)
	KBM.MechTimer:Add("Consuming Essence", "cast", 22, self.Prince, true, "(Prince) Consuming Essence")
	KBM.MechTimer:Add("Runic Feedback", "cast", 48, self.Prince, true)
			
	--self.KingMolinar:Options()
	if not self.DisplayReady then
		self.DisplayReady = true
		self:BuildDisplay()
	end	
end
