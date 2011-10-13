-- King Molinator
-- Written By Paul Snart

KingMol_Main = {}
SBM_GlobalOptions = {}

local SBM_Options = {}
SBM_Options.Frame = {
	x = nil,
	y = nil,
}

local function KM_LoadVars()
	if not SBM_GlobalOptions.Frame then
		SBM_GlobalOptions = SBM_Options
	else
		SBM_Options = SBM_GlobalOptions
	end
	if not KingMol_Main then
		KingMol_Main = {
			LocX = nil,
			LocY = nil,
			Size = 1,
			SampleDPS = 4,
			Hidden = false,
			Locked = false,
			Compact = false,
			AutoReset = true,
			PrinceBar = false,
			KingBar = false,
		}
	end
	if not KingMol_Main.SampleDPS then
		KingMol_Main.SampleDPS = 3
	end
	if not KingMol_Main.Size then
		KingMol_Main.Size = 1
	end
	if KingMol_Main.PrinceBar == nil then
		KingMol_Main.PrinceBar = true
	end
	if KingMol_Main.KingBar == nil then
		KingMol_Main.KingBar = true
	end
end

local function KM_SaveVars()
	SBM_GlobalOptions = SBM_Options
end

local function SBM_ToAbilityID(num)
	return string.format("a%016X", num)
end

local SBM_Lang = Inspect.System.Language()
local SBM_Boss = {}
local SBM_BossID = {}
local SBM_Encounter = false
local SBM_CurrentHook = nil
local SBM_CurrentCBHook = nil
local SBM_CurrentBoss = ""
local SBM_PlayerID = nil
local SBM_TestIsCasting = false
local SBM_TestAbility = nil

local SBM_HeldTime = Inspect.Time.Real()
local SBM_StartTime = 0
local SBM_TimeElapsed = 0

-- Addon Primary Context
local KM_Context = UI.CreateContext("KM_Context")
local SBM_Context = KM_Context
local KM_Name = "King Molinator"

-- Addon SBM Primary Frames
local SBM_MainWin = {
	Handle = {},
	Border = {},
	Content = {},
}

-- Addon Variables
-- Frames
local KM_FrameBase = nil -- Base Frame to attach fancy stuff to
local KM_DragFrame = nil -- Used for moving the monitor
local KM_KingText = nil -- King Molinar display name
local KM_PrinceText = nil -- Prince Dollin display name
local KM_PrincePBack = nil
local KM_PrincePText = nil
local KM_KingPBack = nil
local KM_KingPText = nil
local KM_StatusForecast = nil
local KM_StatusBar = nil
local KM_IconSize = nil
local KM_KingCastbar = nil
local KM_PrinceCastbar = nil
local KM_IconSize = nil
local KM_PrinceCastIcon = nil
local KM_KingCastIcon = nil
local KM_AbilityWatch = {}
local KM_KingCastText = nil
local KM_PrinceCastText = nil
KM_AbilityWatch[SBM_ToAbilityID(414115046)] = {
	Watch = true,
	ID = SBM_ToAbilityID(414115046),
}

-- Frame Defaults
local KM_FBWidth = 600
local KM_SwingMulti = (KM_FBWidth * 0.5) * 0.25
local KM_FBHeight = 100
local KM_SafeWidth = KM_FBWidth * 0.5
local KM_DangerWidth = KM_FBWidth * 0.125
local KM_StopWidth = (KM_FBWidth - KM_SafeWidth - (KM_DangerWidth * 2)) * 0.5
local KM_FBDefX = LocX -- Centered
local KM_FBDefY = LocY -- Centered
local KM_BossHPWidth = nil -- To be filled in later, size of King and Prince individual HP bars
local KM_HK = {
	Header = {},
	Name = "Hammerknell",
	Murdantix = {
		MenuItem = nil,
		Enabled = false,
		Handler = nil,
		Options = nil,
		Name = "Murdantix"
},
	Matron = {},
	Sicaron = {},
	Zilas = {},
	Prime = {},
	Grugonim = {},
	KingMolinar = {
		MenuItem = nil,
		Enabled = true,
		Handler = nil,
		Options = nil,
		Name = "King Molinar"
},
	Estrode = {},
	Inwar = {},
	Garau = {},
	Akylios = {},
}

-- Unit Variables
-- King Molinar
local KM_KingHPP = "100" -- Visual percentage.
local KM_KingPerc = 1 -- Decimal percentage holder.
local KM_KingHPMax = 7100000 -- Dummy HP value for testing, will be overridden during encounter start
local KM_KingDPSTable = {}
local KM_KingLastHP = 0
local KM_KingSample = 0 -- Total damage done to King Molinar over {SampleDPS} seconds
local KM_KingSampleDPS = 0 -- Average DPS done to King Molinar over {SampleDPS} seconds.
local KM_KingName = "Rune King Molinar"
local KM_KingSearchName = "Molinar"
local KM_KingDead = false
local KM_KingUnavail = false
local KM_KingCasting = false
-- Prince Dollin
local KM_PrinceHPP = "100" -- Visual percentage
local KM_PrincePerc = 1 -- Decimal percentage holder.
local KM_PrinceHPMax = 4200000 -- Dummy HP value for testing, will be overridden during encounter start
local KM_PrinceDPSTable = {}
local KM_PrinceLastHP = 0
local KM_PrinceSample = 0 -- Total damage done to Prince Dollin over {SampleDPS} seconds.
local KM_PrinceSampleDPS = 0 -- Average DPS done to Prince Dollin over {SampleDPS} seconds.
local KM_PrinceName = "Prince Dollin"
local KM_PrinceSearchName = "Dollin"
local KM_PrinceDead = false
local KM_PrinceUnavail = false
local KM_PrinceCasting = false
-- State Variables
local KM_EncounterRunning = false
local KM_KingID = nil
local KM_PrinceID = nil
local KM_StartTime = Inspect.Time.Real()
local KM_HeldTime = KM_StartTime
local KM_UpdateTime = KM_StartTime
local KM_TimeElapsed = 0
local KM_DisplayReady = false
local KM_CurrentSwing = 0
local KM_ForecastSwing = 0
local KM_TimeVisual = {}
KM_TimeVisual.String = "00"
KM_TimeVisual.Seconds = 0
KM_TimeVisual.Minutes = 0
KM_TimeVisual.Hours = 0

local function SBM_InitOptions()
	SBM_MainWin = UI.CreateFrame("RiftWindow", "Safe's Boss Mods", SBM_Context)
	SBM_MainWin:SetController("border")
	SBM_MainWin:SetWidth(750)
	SBM_MainWin:SetHeight(550)
	SBM_MainWin:SetTitle("KM Boss Mods: Options")
	
	SBM_MainWin.FrameStore = {}
	SBM_MainWin.CheckStore = {}
	SBM_MainWin.SlideStore = {}
	SBM_MainWin.TextfStore = {}
	
	function SBM_MainWin:CallFrame(parent)
		local frame = nil
		if #self.FrameStore == 0 then
			return UI.CreateFrame("Frame", "Frame Store", parent)
		else
			frame = table.remove(self.FrameStore)
			frame:ClearAll()
			frame:SetParent(parent)
			return frame
		end
	end
	
	function SBM_MainWin:CallCheck(parent)
		local Checkbox = nil
		if #self.CheckStore == 0 then
			return UI.CreateFrame("RiftCheckbox", "Check Store", parent)
		else
			Checkbox = table.remove(self.CheckStore)
			Checkbox:ClearAll()
			Checkbox:ResizeToDefault()
			Checkbox:SetParent(parent)
			return CheckBox
		end
	end
	
	function SBM_MainWin:CallText(parent)
		local Textbox = nil
		if #self.TextfStore == 0 then
			return UI.CreateFrame("Text", "Textf Store", parent)
		else
			Textfbox = table.remove(self.TextfStore)
			Textfbox:ClearAll()
			Textfbox:SetParent(parent)
			return Textfbox
		end
	end
	
	if not SBM_Options.Frame.x then
		SBM_MainWin:SetPoint("CENTER", UIParent, "CENTER")
	else
		SBM_MainWin:SetPoint("TOPLEFT", UIParent, "TOPLEFT", SBM_Options.Frame.x, SBM_Options.Frame.y)
	end
	
	SBM_MainWin.Border = SBM_MainWin:GetBorder()
	SBM_MainWin.Content = SBM_MainWin:GetContent()

	BorderX = SBM_MainWin.Border:GetLeft()
	BorderY = SBM_MainWin.Border:GetTop()
	ContentX = SBM_MainWin.Content:GetLeft()
	ContentY = SBM_MainWin.Content:GetTop()
	ContentW = SBM_MainWin.Content:GetWidth()
	ContentH = SBM_MainWin.Content:GetHeight()
	
	SBM_MainWin.Handle = UI.CreateFrame("Frame", "SBM Window Handle", SBM_MainWin)
	SBM_MainWin.Handle:SetPoint("TOPLEFT", SBM_MainWin, "TOPLEFT")
	SBM_MainWin.Handle:SetWidth(SBM_MainWin.Border:GetWidth())
	SBM_MainWin.Handle:SetHeight(ContentY-BorderY)
	SBM_MainWin.Handle.parent = SBM_MainWin.Handle:GetParent()
	function SBM_MainWin.Handle.Event:LeftDown()
		local cMouse = Inspect.Mouse()
		local holdx = self.parent:GetLeft()
		local holdy = self.parent:GetTop()
		local holdw = self.parent:GetWidth()
		local holdh = self.parent:GetHeight()
		self.OffsetX = cMouse.x - holdx
		self.OffsetY = cMouse.y - holdy
		self.MouseDown = true
		self.parent:ClearAll()
		self.parent:SetWidth(holdw)
		self.parent:SetHeight(holdh)
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", holdx, holdy)
	end
	function SBM_MainWin.Handle.Event:MouseMove(newX, newY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", newX - self.OffsetX, newY - self.OffsetY)
		end
	end
	function SBM_MainWin.Handle.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			SBM_Options.Frame.x = self:GetLeft()
			SBM_Options.Frame.y = self:GetTop()
		end
	end
	
	MenuWidth = math.floor(ContentW * 0.25)-10
	OptionsWidth = math.ceil(ContentW * 0.75)-10
	SBM_MainWin.Menu = UI.CreateFrame("Frame", "SBM Menu Frame", SBM_MainWin.Content)
	SBM_MainWin.Menu:SetWidth(MenuWidth)
	SBM_MainWin.Menu:SetHeight(ContentH)
	SBM_MainWin.Menu:SetPoint("TOPLEFT", SBM_MainWin.Content, "TOPLEFT",5, 5)
	SBM_MainWin.Menu.Headers = {}
	SBM_MainWin.Menu.LastHeader = nil
	function SBM_MainWin.Menu:CreateHeader(Text, Hook, Default)
		Header = {}
		Header.Children = {}
		Header.Frame = SBM_MainWin:CallFrame(self)
		Header.Frame:SetWidth(self:GetWidth())
		Header.Check = SBM_MainWin:CallCheck(Header.Frame)
		Header.Check:SetPoint("CENTERLEFT", Header.Frame, "CENTERLEFT", 4, 0)
		Header.Check:SetChecked(Default)
		Header.Text = SBM_MainWin:CallText(Header.Frame)
		Header.Text:SetWidth(Header.Frame:GetWidth() - Header.Check:GetWidth())
		Header.Text:SetText(Text)
		Header.Text:SetFontSize(16)
		Header.Text:SetHeight(Header.Text:GetFullHeight())
		Header.Frame:SetHeight(Header.Text:GetHeight())
		Header.Text:SetPoint("CENTERLEFT", Header.Check, "CENTERRIGHT")
		Header.Text:SetFontColor(0.85,0.65,0.0)
		table.insert(self.Headers, Header)
		if not self.LastHeader then
			self.LastHeader = Header
			Header.Frame:SetPoint("TOPLEFT", self, "TOPLEFT")
		else
			if self.LastHeader.LastChild then
			
			else
				Header.Frame:SetPoint("TOP", self.LastHeader.Frame, "BOTTOM")
				Header.Frame:SetPoint("LEFT", self, "LEFT")
				self.LastHeader = Header
			end
		end
		Header.LastChild = nil
		return Header
	end
	function SBM_MainWin.Menu:CreateEncounter(Text, Hook, Default, Header)
		Child = {}
		Child.Frame = SBM_MainWin:CallFrame(self)
		Child.Frame:SetWidth(self:GetWidth()-Header.Check:GetWidth())
		Child.Frame:SetPoint("RIGHT", self, "RIGHT")
		Child.Check = SBM_MainWin:CallCheck(Child.Frame)
		Child.Check:SetPoint("CENTERLEFT", Child.Frame, "CENTERLEFT", 4, 0)
		Child.Check:SetChecked(Default)
		Child.Text = SBM_MainWin:CallText(Child.Frame)
		Child.Text:SetWidth(Child.Frame:GetWidth() - Child.Check:GetWidth())
		Child.Text:SetText(Text)
		Child.Text:SetFontSize(13)
		Child.Text:SetHeight(Child.Text:GetFullHeight())
		Child.Frame:SetHeight(Child.Text:GetHeight())
		Child.Text:SetPoint("CENTERLEFT", Child.Check, "CENTERRIGHT")
		table.insert(Header.Children, Child)
		if not Header.LastChild then
			Header.LastChild = Child
			Child.Frame:SetPoint("TOP", Header.Frame, "BOTTOM")
		else
			Child.Frame:SetPoint("TOP", Header.LastChild.Frame, "BOTTOM")
			Header.LastChild = Child
		end
	end
	
	--SBM_MenuFrame:SetBackgroundColor(1,0,0,0.4)
	
	SBM_MainWin.Options = UI.CreateFrame("Frame", "SBM Options Frame", SBM_MainWin.Content)
	SBM_MainWin.Options:SetWidth(OptionsWidth)
	SBM_MainWin.Options:SetHeight(ContentH)
	SBM_MainWin.Options:SetPoint("TOPLEFT", SBM_MainWin.Menu, "TOPRIGHT")
	--SBM_OptionsFrame:SetBackgroundColor(0,1,0,0.4)
	
end

local function SBM_Options()
	if SBM_MainWin:GetVisible() then
		SBM_MainWin:SetVisible(false)
	else
		SBM_MainWin:SetVisible(true)
	end
end

local function SBM_Dummy(units)
end

local function KM_UnitHPCheck(unitDetails, unitID)
	
	if unitDetails and unitID then
		--print(unitDetails.name.." : "..tostring(unitID))
		if unitDetails.player == nil then
			if unitDetails.name == KM_KingName then
				--print("Checking Molinar")
				if KM_KingID then
					--KM_DPSUpdate()
				else
					--print("Activating Molinar")
					KM_KingID = unitID
					if not KM_EncounterRunning then
						KM_EncounterRunning = true
						SBM_Encounter = false
					end
					KM_StartTime = Inspect.Time.Real()
					KM_HeldTime = KM_StartTime
					KM_TimeElapsed = 0
					KM_KingLastHP = unitDetails.healthMax
					KM_KingHPMax = KM_KingLastHP
					KM_FrameBase:SetVisible(true)
					KM_KingDead = false
					KM_KingUnavail = false
					KM_KingCasting = false
					--print("King HP set: "..KM_KingLastHP)
					-- Temporary during testing
					-- KM_KingLastHP = KM_KingHPA
				end
			elseif unitDetails.name == KM_PrinceName then
				--print("Checking Dollin")
				if KM_PrinceID then
					--KM_DPSUpdate()
				else
					KM_PrinceID = unitID
					--print("Activating Dollin")
					if not KM_EncounterRunning then
						KM_EncounterRunning = true
						SBM_Encounter = false
					end
					KM_StartTime = Inspect.Time.Real()
					KM_HeldTime = KM_StartTime
					KM_TimeElapsed = 0
					KM_PrinceLastHP = unitDetails.healthMax
					KM_PrinceHPMax = KM_PrinceLastHP
					KM_FrameBase:SetVisible(true)
					KM_PrinceDead = false
					KM_PrinceUnavail = false
					KM_PrinceCasting = false
					--print("Prince HP set: "..KM_PrinceLastHP)
					-- Temporary during testing
					--KM_PrinceLastHP = KM_PrinceHPA
				end
			end
		end
	end
end

local function ROF_UnitHPCheck()
	
	if SBM_Encounter then
		uDetails = Inspect.Unit.Detail(SBM_CurrentBoss)
		if not uDetails then
			SBM_Encounter = false
			SBM_BossID[SBM_CurrentBoss] = nil
			SBM_CurrentBoss = nil
			SBM_CurrentHook = nil
			--print("Encounter Ended")
		else -- Continue to manage the encounter.
		
		end
	end
	
end

local function SBM_Death(info)
	
	if SBM_Encounter then
		local UnitID = info.target
		if UnitID then
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not uDetails.player then
					if SBM_BossID[UnitID] then
						-- The Boss, or one of the bosses has died.
					end
				end
			end
		end
	end
	
end

local function KM_Reset()
	SBM_Encounter = false
	KM_EncounterRunning = false
	if KM_KingID then
		SBM_BossID[KM_KingID] = nil
	end
	KM_KingID = nil
	if KM_PrinceID then
		SBM_BossID[KM_PrinceID] = nil
	end
	KM_PrinceID = nil
	KM_KingDPSTable = {}
	KM_PrinceDPSTable = {}
	SBM_CurrentBoss = ""
	SBM_CurrentHook = nil
	SBM_CurrentCBHook = nil
	KM_KingHPBar:SetWidth(KM_BossHPWidth)
	KM_PrinceHPBar:SetWidth(KM_BossHPWidth)
	KM_StatusBar:SetPoint("CENTER", KM_FrameBase, "CENTER")
	KM_StatusForecast:SetPoint("CENTER", KM_FrameBase, "CENTER")
	KM_KingHPP = "100%"
	KM_PrinceHPP = "100%"
	KM_KingPText:SetText("100%")
	KM_KingPText:SetWidth(KM_KingPText:GetFullWidth())
	KM_PrincePText:SetText("100%")
	KM_PrincePText:SetWidth(KM_PrincePText:GetFullWidth())
	KM_CurrentSwing = 0
	KM_KingPerc = 1
	KM_PrincePerc = 1
	KM_KingUnavail = false
	KM_PrinceUnavail = false
	if KingMol_Main.Hidden then
		KM_FrameBase:SetVisible(false)
	end
	KM_KingCastbar:SetVisible(false)
	KM_KingCastIcon:SetTexture("", "")
	KM_KingCastIcon:SetVisible(false)
	KM_KingCastProgress:SetWidth(0)
	KM_KingCastText:SetText("")
	KM_KingCasting = false
	KM_PrinceCastbar:SetVisible(false)
	KM_PrinceCastIcon:SetTexture("", "")
	KM_PrinceCastIcon:SetVisible(false)
	KM_PrinceCastProgress:SetWidth(0)
	KM_PrinceCastText:SetText("")
	KM_PrinceCasting = false	
	print("Monitor reset.")
end

local function SBM_UnitHPCheck(units)
	if not SBM_Encounter then -- check for bosses for an encounter start

		local uDetails = {}
		for UnitID, Specifier in pairs(units) do
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not SBM_BossID[UnitID] then
					if SBM_Boss[uDetails.name] then
						--print("Boss seen (adding): "..UnitID.." ("..uDetails.name..") ")
						--if uDetails.level == "??" then
							SBM_BossID[UnitID] = {}
							SBM_BossID[UnitID].name = uDetails.name
							SBM_BossID[UnitID].monitor = true
							SBM_BossID[UnitID].hook = SBM_Boss[uDetails.name].DPSHook
							SBM_BossID[UnitID].CBHook = SBM_Boss[uDetails.name].CBHook
							if uDetails.health > 0 then
								SBM_BossID[UnitID].dead = false
								SBM_Encounter = true
								SBM_CurrentHook = SBM_BossID[UnitID].hook
								SBM_CurrentBoss = UnitID
								SBM_CurrentHook(uDetails, UnitID)
								SBM_CurrentCBHook = SBM_BossID[UnitID].CBHook
							else
								SBM_BossID[UnitID].dead = true
								--print("Boss has been killed: Removing")
								SBM_BossID[UnitID] = nil
							end
						--end
					else
						--print("Unit is not a boss: "..UnitID.." ("..uDetails.name..")")
					end
				else
					--print("Boss already seen. Redirecting "..SBM_BossID[UnitID].name)
					--SBM_BossID[UnitID].hook()
				end
			else
				--print(UnitID.." (n/a)")
			end
		end
	else
		if SBM_CurrentHook then
			--SBM_CurrentHook()
		else
			--SBM_Encounter = false
			--print("Encounter ended")
		end
	end
end

local function SBM_UnitRemoved(units)
	--[[local uDetails = {}]]
	if SBM_Encounter then
		if KingMol_Main.AutoReset then
			for UnitID, Specifier in pairs(units) do
				if SBM_BossID[UnitID] then
					if KM_KingID == UnitID then
						KM_KingUnavail = true
					elseif KM_PrinceID == UnitID then
						KM_PrinceUnavail = true
					end
					if KM_PrinceUnavail and KM_KingUnavail then
						KM_Reset()
						print("Encounter ended")
					end
				end
			end
		end
	end
end

local function KM_CheckTrends()
	-- Adjust the Current and Trend bars accordingly.
	
	if KM_KingID ~= nil and KM_PrinceID ~= nil then
		-- King Calc
		local KingForecastHP = KM_KingLastHP-(KM_KingSampleDPS * 4)
		local KingForecastP = KingForecastHP / KM_KingHPMax
		local KingMulti = KM_KingPerc*100
		local stupidKing = math.floor(KingMulti)
		if (KingMulti - stupidKing) > 0.005 then -- Account for lag
			stupidKing = stupidKing + 1
		end
		KM_KingHPP = tostring(stupidKing).."%"
		-- Prince Calc
		local PrinceForecastHP = KM_PrinceLastHP-(KM_PrinceSampleDPS * 4)
		local PrinceForecastP = PrinceForecastHP / KM_PrinceHPMax
		local PrinceMulti = KM_PrincePerc*100
		local stupidPrince = math.floor(PrinceMulti)
		if (PrinceMulti - stupidPrince) > 0.005 then -- Account for lag
			stupidPrince = stupidPrince + 1
		end
		KM_PrinceHPP = tostring(stupidPrince).."%"
		KM_CurrentSwing = KM_KingPerc - KM_PrincePerc
		if KM_CurrentSwing > 0.04 then
			KM_CurrentSwing = 0.04
		elseif KM_CurrentSwing < -0.04 then
			KM_CurrentSwing = -0.04
		end
		KM_ForecastSwing = KingForecastP - PrinceForecastP
		if KM_ForecastSwing > 0.04 then
			KM_ForecastSwing = 0.04
		elseif KM_ForecastSwing < -0.04 then
			KM_ForecastSwing = -0.04
		end
		KM_StatusBar:SetPoint("CENTER", KM_FrameBase, "CENTER", (KM_CurrentSwing * KM_SwingMulti) * 100, 0)
		KM_StatusForecast:SetPoint("CENTER", KM_FrameBase, "CENTER", (KM_ForecastSwing * KM_SwingMulti) * 100, 0)
		KM_KingPText:SetText(KM_KingHPP)
		KM_KingPText:SetWidth(KM_KingPText:GetFullWidth())
		KM_KingHPBar:SetWidth(KM_BossHPWidth * KM_KingPerc)
		KM_PrincePText:SetText(KM_PrinceHPP)
		KM_PrincePText:SetWidth(KM_PrincePText:GetFullWidth())
		KM_PrinceHPBar:SetWidth(KM_BossHPWidth * KM_PrincePerc)
	end
end

local function KM_DPSUpdate()
	
	if KM_KingID ~= nil and KM_PrinceID ~= nil then
		--print("DPS Update: Time Elapsed "..KM_TimeVisual.String)
		local DumpDPS = 0
		local KingDetails = Inspect.Unit.Detail(KM_KingID)
		local PrinceDetails = Inspect.Unit.Detail(KM_PrinceID)
		local KingCurrentHP = KM_KingLastHP
		local KingDPS = 0
		if KingDetails then
			if KingDetails.health then
				KingCurrentHP = KingDetails.health
				KingDPS = KM_KingLastHP - KingCurrentHP
				--print(KingCurrentHP.."/"..KM_KingHPMax)
				KM_KingLastHP = KingCurrentHP
			else
				KingCurrentHP = 0
			end
		end
		KM_KingPerc = KingCurrentHP / KM_KingHPMax
		if #KM_KingDPSTable >= KingMol_Main.SampleDPS then
			DumpDPS = table.remove(KM_KingDPSTable, 1)
			table.insert(KM_KingDPSTable, KingDPS)
			if not DumpDPS then DumpDPS = 0 end
			KM_KingSample = KM_KingSample - DumpDPS + KingDPS
			KM_KingSampleDPS = KM_KingSample / KingMol_Main.SampleDPS
		else
			if KM_TimeElapsed < 1 then KM_TimeElapsed = 1 end
			KM_KingSampleDPS = KM_PrinceSample / KM_TimeElapsed
			table.insert(KM_KingDPSTable, KingDPS)
		end
		local PrinceCurrentHP = KM_PrinceLastHP
		local PrinceDPS = 0
		if PrinceDetails then
			if PrinceDetails.health then
				PrinceCurrentHP = PrinceDetails.health
				PrinceDPS = KM_PrinceLastHP - PrinceCurrentHP
				--print(PrinceCurrentHP.."/"..KM_PrinceHPMax)
				KM_PrinceLastHP = PrinceCurrentHP
			else
				PrinceCurrentHP = 0
			end
		end
		KM_PrincePerc = PrinceCurrentHP / KM_PrinceHPMax
		if #KM_PrinceDPSTable >= KingMol_Main.SampleDPS then
			DumpDPS = table.remove(KM_PrinceDPSTable, 1)
			table.insert(KM_PrinceDPSTable, PrinceDPS)
			if not DumpDPS then DumpDPS = 0 end
			KM_PrinceSample = KM_PrinceSample - DumpDPS + PrinceDPS
			KM_PrinceSampleDPS = KM_PrinceSample / KingMol_Main.SampleDPS
		else
			if KM_TimeElapsed < 1 then KM_TimeElapsed = 1 end
			KM_PrinceSampleDPS = KM_PrinceSample / KM_TimeElapsed
			table.insert(KM_PrinceDPSTable, PrinceDPS)
		end
		KM_CheckTrends()
		if PrinceCurrentHP == 0 and KingCurrentHP == 0 then
			KM_Reset()
		end
	else
		--[[ print("Error: Could not locate King Molinar and/or Prince Dollin. Encounter Ending.")
		KM_EncounterRunning = false
		--]]
	end
end

local function KM_HPChangeCheck(units)
end

local function SBM_UnitAvailable(units)
end

local function KM_UpdateBaseVars(callType)
	if callType == "start" then
		KM_KingCastbar:SetVisible(true)
		KM_PrinceCastbar:SetVisible(true)
	elseif callType == "end" then
		KingMol_Main.LocX = KM_FrameBase:GetLeft()
		KingMol_Main.LocY = KM_FrameBase:GetTop()
		if not KM_KingCasting then
			KM_KingCastbar:SetVisible(false)
		end
		if not KM_PrinceCasting then
			KM_PrinceCastbar:SetVisible(false)
		end
	end
end

local function AttachDragFrame(parent, hook, name, layer)

	if not name then name = "" end
	if not layer then layer = 0 end
	
	local DragFrame = UI.CreateFrame("Frame", name.."_DragFrame", parent)
	DragFrame:SetPoint("TOPLEFT", parent, "TOPLEFT")
	DragFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
	DragFrame.parent = parent
	DragFrame.MouseDown = false
	DragFrame:SetLayer(layer)
	DragFrame.hook = hook
	
	function DragFrame.Event:LeftDown()
		self.MouseDown = true
		mouseData = Inspect.Mouse()
		self.MyStartX = self.parent:GetLeft()
		self.MyStartY = self.parent:GetTop()
		self.StartX = mouseData.x - self.MyStartX
		self.StartY = mouseData.y - self.MyStartY
		tempX = self.parent:GetLeft()
		tempY = self.parent:GetTop()
		tempW = self.parent:GetWidth()
		tempH =	self.parent:GetHeight()
		self.parent:ClearAll()
		self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", tempX, tempY)
		self.parent:SetWidth(tempW)
		self.parent:SetHeight(tempH)
		self:SetBackgroundColor(0,0,0,0.5)
		self.hook("start")
	end
	function DragFrame.Event:MouseMove(mouseX, mouseY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", (mouseX - self.StartX), (mouseY - self.StartY))
		end
	end
	function DragFrame.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			self:SetBackgroundColor(0,0,0,0)
			self.hook("end")
		end
	end
	
	return DragFrame
end

local function KM_SetNormal()
	KM_FrameBase:SetHeight(KM_FBHeight)
	KM_FrameBase:SetWidth(KM_FBWidth)
	
	KM_IconSize = 36
	
	KM_KingCastbar:SetWidth(KM_FBWidth)
	KM_KingCastbar:SetHeight(KM_IconSize)
	KM_KingCastIcon:SetWidth(KM_IconSize)
	KM_KingCastIcon:SetHeight(KM_IconSize)
	KM_KingCastProgress:SetHeight(KM_IconSize)
	KM_KingCastProgress:SetWidth(0)
	KM_KingCastText:SetFontSize(20)
	
	KM_PrinceCastbar:SetWidth(KM_FBWidth)
	KM_PrinceCastbar:SetHeight(KM_IconSize)
	KM_PrinceCastIcon:SetWidth(KM_IconSize)
	KM_PrinceCastIcon:SetHeight(KM_IconSize)
	KM_PrinceCastProgress:SetHeight(KM_IconSize)
	KM_PrinceCastProgress:SetWidth(0)
	KM_PrinceCastText:SetFontSize(20)
	
	KM_KingText:SetWidth(KM_KingText:GetFullWidth())
	KM_KingText:SetHeight(KM_KingText:GetFullHeight())
	
	KM_PrinceText:SetWidth(KM_PrinceText:GetFullWidth())
	KM_PrinceText:SetHeight(KM_PrinceText:GetFullHeight())
	
	KM_KingPText:SetFontSize(16)
	KM_KingPText:SetWidth(KM_KingPText:GetFullWidth())
	KM_KingPText:SetHeight(KM_KingPText:GetFullHeight())
	KM_KingPBack:SetWidth(KM_KingPText:GetWidth() + 6)
	KM_KingPBack:SetHeight(KM_KingPText:GetHeight() + 4)

	KM_PrincePText:SetFontSize(16)
	KM_PrincePText:SetWidth(KM_PrincePText:GetFullWidth())
	KM_PrincePText:SetHeight(KM_PrincePText:GetFullHeight())
	KM_PrincePBack:SetWidth(KM_PrincePText:GetWidth() + 6)
	KM_PrincePBack:SetHeight(KM_PrincePText:GetHeight() + 4)

	KM_SafeZone:SetWidth(KM_SafeWidth)
	KM_KingDanger:SetWidth(KM_DangerWidth)
	KM_KingStop:SetWidth(KM_StopWidth)

	KM_BossHPWidth = (KM_FrameBase:GetWidth() * 0.5) - (KM_KingPBack:GetWidth() * 0.5) - 2
	KM_KingHPBar:SetWidth(KM_BossHPWidth)
	KM_KingHPBar:SetHeight(10)

	KM_PrinceStop:SetWidth(KM_StopWidth)
	KM_PrinceDanger:SetWidth(KM_DangerWidth)
	KM_PrinceHPBar:SetWidth(KM_BossHPWidth)
	KM_PrinceHPBar:SetHeight(10)
	
	KM_StatusBar:SetWidth(11)
	KM_StatusBar:SetHeight(KM_PrinceStop:GetHeight() + 10)
	KM_StatusForecast:SetWidth(11)
	KM_StatusForecast:SetHeight(KM_PrinceStop:GetHeight() + 10)
	
	KM_SwingMulti = (KM_FBWidth * 0.5) * 0.25
end

local function KM_SetCompact()
	KM_FrameBase:SetHeight(KM_FBHeight * 0.75)
	KM_FrameBase:SetWidth(KM_FBWidth * 0.75)
	
	KM_IconSize = 36 * 0.75
	
	KM_KingCastbar:SetWidth((KM_FBWidth * 0.75))
	KM_KingCastbar:SetHeight(KM_IconSize)
	KM_KingCastIcon:SetWidth(KM_IconSize)
	KM_KingCastIcon:SetHeight(KM_IconSize)
	KM_KingCastProgress:SetHeight(KM_IconSize)
	KM_KingCastProgress:SetWidth(0)
	KM_KingCastText:SetFontSize(16)
	
	KM_PrinceCastbar:SetWidth((KM_FBWidth * 0.75))
	KM_PrinceCastbar:SetHeight(KM_IconSize)
	KM_PrinceCastIcon:SetWidth(KM_IconSize)
	KM_PrinceCastIcon:SetHeight(KM_IconSize)
	KM_PrinceCastProgress:SetHeight(KM_IconSize)
	KM_PrinceCastProgress:SetWidth(0)
	KM_PrinceCastText:SetFontSize(16)
	
	KM_KingText:SetWidth(KM_KingText:GetFullWidth())
	KM_KingText:SetHeight(KM_KingText:GetFullHeight())
	
	KM_PrinceText:SetWidth(KM_PrinceText:GetFullWidth())
	KM_PrinceText:SetHeight(KM_PrinceText:GetFullHeight())
	
	KM_KingPText:SetFontSize(12)
	KM_KingPText:SetWidth(KM_KingPText:GetFullWidth())
	KM_KingPText:SetHeight(KM_KingPText:GetFullHeight())
	KM_KingPBack:SetWidth(KM_KingPText:GetWidth() + 2)
	KM_KingPBack:SetHeight(KM_KingPText:GetHeight() + 1)

	KM_PrincePText:SetFontSize(12)
	KM_PrincePText:SetWidth(KM_PrincePText:GetFullWidth())
	KM_PrincePText:SetHeight(KM_PrincePText:GetFullHeight())
	KM_PrincePBack:SetWidth(KM_PrincePText:GetWidth())
	KM_PrincePBack:SetHeight(KM_PrincePText:GetHeight())

	KM_SafeZone:SetWidth(KM_SafeWidth*0.75)
	KM_SafeZone:SetHeight(35)
	KM_KingDanger:SetWidth(KM_DangerWidth*0.75)
	KM_KingDanger:SetHeight(35)
	KM_KingStop:SetWidth(KM_StopWidth*0.75)
	KM_KingStop:SetHeight(35)

	KM_BossHPWidth = (KM_FrameBase:GetWidth() * 0.5) - (KM_KingPBack:GetWidth() * 0.5) - 2
	KM_KingHPBar:SetWidth(KM_BossHPWidth)
	KM_KingHPBar:SetHeight(7)

	KM_PrinceStop:SetWidth(KM_StopWidth * 0.75)
	KM_PrinceStop:SetHeight(35)
	KM_PrinceDanger:SetWidth(KM_DangerWidth * 0.75)
	KM_PrinceDanger:SetHeight(35)
	KM_PrinceHPBar:SetWidth(KM_BossHPWidth)
	KM_PrinceHPBar:SetHeight(7)
	
	KM_StatusBar:SetWidth(7)
	KM_StatusBar:SetHeight(KM_PrinceStop:GetHeight() + 4)
	KM_StatusForecast:SetWidth(7)
	KM_StatusForecast:SetHeight(KM_PrinceStop:GetHeight() + 4)
	
	KM_SwingMulti = ((KM_FBWidth * 0.75) * 0.5) * 0.25
end

local function KM_BuildDisplay()
	KM_FrameBase = UI.CreateFrame("Frame", "KM_FrameBase", KM_Context)
	KM_FrameBase:SetVisible(false)
	if KM_FBDefX == nil then
		KM_FrameBase:SetPoint("CENTERX", UIParent, "CENTERX")
	else
		KM_FrameBase:SetPoint("LEFT", UIParent, "LEFT", KM_FBDefX, nil)
	end
	if KM_FBDefY == nil then
		KM_FrameBase:SetPoint("CENTERY", UIParent, "CENTERY")
	else
		KM_FrameBase:SetPoint("TOP", UIParent, "TOP", nil, KM_FBDefY)
	end
	KM_FrameBase:SetBackgroundColor(0,0,0,0.4)
	KM_FBLayer = KM_FrameBase:GetLayer()
	
	KM_KingCastbar = UI.CreateFrame("Frame", "KM_KingCastbar", KM_FrameBase)
	KM_KingCastProgress = UI.CreateFrame("Frame", "KM_KingCastProgress", KM_KingCastbar)
	KM_KingCastIcon = UI.CreateFrame("Texture", "KM_KingCastIcon", KM_FrameBase)
	KM_KingCastText = UI.CreateFrame("Text", "KM_KingCastText", KM_KingCastbar)
	KM_KingCastProgress:SetLayer(1)
	KM_KingCastIcon:SetLayer(2)
	KM_KingCastText:SetLayer(2)
	KM_KingCastText:SetPoint("CENTER", KM_KingCastbar, "CENTER")
	KM_KingCastbar:SetPoint("BOTTOMRIGHT", KM_FrameBase, "TOPRIGHT")
	KM_KingCastIcon:SetPoint("BOTTOMLEFT", KM_FrameBase, "TOPLEFT")
	KM_KingCastProgress:SetPoint("TOPLEFT", KM_KingCastbar, "TOPLEFT")
	KM_KingCastbar:SetBackgroundColor(0,0,0,0.3)
	KM_KingCastProgress:SetBackgroundColor(0.7,0,0,0.5)
	KM_KingCastbar:SetVisible(false)
	
	KM_PrinceCastbar = UI.CreateFrame("Frame", "KM_PrinceCastbar", KM_FrameBase)
	KM_PrinceCastProgress = UI.CreateFrame("Frame", "KM_PrinceCastProgress", KM_PrinceCastbar)
	KM_PrinceCastIcon = UI.CreateFrame("Texture", "KM_PrinceCastIcon", KM_FrameBase)
	KM_PrinceCastText = UI.CreateFrame("Text", "KM_PrinceCastText", KM_PrinceCastbar)
	KM_PrinceCastProgress:SetLayer(1)
	KM_PrinceCastIcon:SetLayer(2)
	KM_PrinceCastText:SetLayer(2)
	KM_PrinceCastText:SetPoint("CENTER", KM_PrinceCastbar, "CENTER")
	KM_PrinceCastbar:SetPoint("TOPRIGHT", KM_FrameBase, "BOTTOMRIGHT")
	KM_PrinceCastIcon:SetPoint("TOPLEFT", KM_FrameBase, "BOTTOMLEFT")
	KM_PrinceCastProgress:SetPoint("TOPLEFT", KM_PrinceCastbar, "TOPLEFT")
	KM_PrinceCastbar:SetBackgroundColor(0,0,0,0.3)
	KM_PrinceCastProgress:SetBackgroundColor(0.7,0,0,0.5)
	KM_PrinceCastbar:SetVisible(false)
	
	KM_KingText = UI.CreateFrame("Text", "KM_KingText", KM_FrameBase)
	KM_KingText:SetText(KM_KingName)
	KM_KingText:SetPoint("TOPLEFT", KM_FrameBase, "TOPLEFT", 1, 0)
	
	KM_PrinceText = UI.CreateFrame("Text", "KM_PrinceText", KM_FrameBase)
	KM_PrinceText:SetText(KM_PrinceName)
	KM_PrinceText:SetPoint("BOTTOMRIGHT", KM_FrameBase, "BOTTOMRIGHT", -1, 0)
		
	KM_KingPBack = UI.CreateFrame("Frame", "KM_KingPBack", KM_FrameBase)
	KM_KingPText = UI.CreateFrame("Text", "KM_KingPText", KM_KingPBack)
	KM_KingPText:SetText("100%")
	KM_KingPBack:SetBackgroundColor(0,0,0,0.4)
	KM_KingPBack:SetPoint("TOPCENTER", KM_FrameBase, "TOPCENTER")
	KM_KingPText:SetPoint("CENTER", KM_KingPBack, "CENTER")
	KM_KingPBack:SetLayer(1)
	KM_KingPText:SetLayer(2)
	
	KM_PrincePBack = UI.CreateFrame("Frame", "KM_PrincePBack", KM_FrameBase)
	KM_PrincePText = UI.CreateFrame("Text", "KM_PrincePText", KM_PrincePBack)
	KM_PrincePText:SetText("100%")
	KM_PrincePBack:SetBackgroundColor(0,0,0,0.4)
	KM_PrincePBack:SetPoint("BOTTOMCENTER", KM_FrameBase, "BOTTOMCENTER")
	KM_PrincePText:SetPoint("CENTER", KM_PrincePBack, "CENTER")
	KM_PrincePBack:SetLayer(1)
	KM_PrincePText:SetLayer(2)
		
	KM_SafeZone = UI.CreateFrame("Frame", "KM_SafeZone", KM_FrameBase)
	KM_SafeZone:SetBackgroundColor(0,0.8,0,0.6)
	KM_SafeZone:SetPoint("CENTER", KM_FrameBase, "CENTER")
	
	KM_KingDanger = UI.CreateFrame("Frame", "KM_KingDanger", KM_FrameBase)
	KM_KingDanger:SetBackgroundColor(0.8,0.5,0,0.6)
	KM_KingDanger:SetPoint("TOPRIGHT", KM_SafeZone, "TOPLEFT")
	
	KM_PrinceDanger = UI.CreateFrame("Frame", "KM_PrinceDanger", KM_FrameBase)
	KM_PrinceDanger:SetBackgroundColor(0.8,0.5,0,0.6)
	KM_PrinceDanger:SetPoint("TOPLEFT", KM_SafeZone, "TOPRIGHT")
	
	KM_KingStop = UI.CreateFrame("Frame", "KM_KingStop", KM_FrameBase)
	KM_KingStop:SetBackgroundColor(0.8,0,0,0.6)
	KM_KingStop:SetPoint("TOPRIGHT", KM_KingDanger, "TOPLEFT")

	KM_KingHPBar = UI.CreateFrame("Frame", "KM_KingHPBar", KM_FrameBase)
	KM_KingHPBar:SetPoint("BOTTOMLEFT", KM_KingStop, "TOPLEFT", 0, -1)
	KM_KingHPBar:SetBackgroundColor(0,0.7,0,0.4)
	
	KM_PrinceStop = UI.CreateFrame("Frame", "KM_PrinceStop", KM_FrameBase)
	KM_PrinceStop:SetBackgroundColor(0.8,0,0,0.6)
	KM_PrinceStop:SetPoint("TOPLEFT", KM_PrinceDanger, "TOPRIGHT")

	KM_PrinceHPBar = UI.CreateFrame("Frame", "KM_PrinceHPBar", KM_FrameBase)
	KM_PrinceHPBar:SetPoint("TOPRIGHT", KM_PrinceStop, "BOTTOMRIGHT", 0, 1)
	KM_PrinceHPBar:SetBackgroundColor(0,0.7,0,0.4)
	
	KM_StatusBar = UI.CreateFrame("Frame", "KM_StatusBar", KM_FrameBase)
	KM_StatusBar:SetPoint("CENTER", KM_FrameBase, "CENTER")
	KM_StatusBar:SetBackgroundColor(0.9,0.9,0.9,0.9)
	KM_StatusBar:SetLayer(3)

	KM_StatusForecast = UI.CreateFrame("Frame", "KM_StatusForecast", KM_FrameBase)
	KM_StatusForecast:SetPoint("CENTER", KM_FrameBase, "CENTER")
	KM_StatusForecast:SetBackgroundColor(0.9,0.9,0.9,0.3)
	KM_StatusForecast:SetLayer(4)
		
	KM_FrameBase:SetVisible(true)
	KM_DragFrame = AttachDragFrame(KM_FrameBase, KM_UpdateBaseVars, "KM_FrameBase", 4)
	
	if not KingMol_Main.Compact then
		KM_SetNormal()
	else
		KM_SetCompact()
	end
		
	if KingMol_Main.Hidden then
		KM_FrameBase:SetVisible(false)
	end
	if KingMol_Main.Locked then
		KM_DragFrame:SetVisible(false)
	end
	
end

local function SBM_Timer()
	local current = Inspect.Time.Real()
	
	if (current - SBM_HeldTime) >= 1 then
		SBM_HeldTime = SBM_HeldTime + 1
		if SBM_Encounter then
			SBM_TimeElapsed = SBM_HeldTime - SBM_StartTime
			if SBM_CurrentHook then
				SBM_CurrentHook()
			end
		end
	end
end

local function KM_UpdateKingCast()
	local bDetails = Inspect.Unit.Castbar(KM_KingID)
	if bDetails then
		bCastTime = bDetails.duration
		bProgress = bDetails.remaining
		KM_KingCastProgress:SetWidth(KM_KingCastbar:GetWidth() * (1-(bProgress/bCastTime)))
		KM_KingCastText:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
		KM_KingCastText:SetWidth(KM_KingCastText:GetFullWidth())
		KM_KingCastText:SetHeight(KM_KingCastText:GetFullHeight())
	else
		KM_KingCastbar:SetVisible(false)
		KM_KingCastIcon:SetTexture("", "")
		KM_KingCastIcon:SetVisible(false)
		KM_KingCastProgress:SetWidth(0)
		KM_KingCastText:SetText("")
		KM_KingCasting = false		
	end
end

local function KM_ManageKingCasts(Visible)
	--if Visible then
		local bDetails = Inspect.Unit.Castbar(KM_KingID)
		if bDetails then
			--if KM_AbilityWatch[bDetails.ability] then
				--if KM_AbilityWatch[bDetails.ability].Watching then
				if bDetails.ability then
					local aDetails = Inspect.Ability.Detail(bDetails.ability)
					if aDetails then
						KM_KingCastIcon:SetTexture("Rift", aDetails.icon)
						KM_KingCastIcon:SetVisible(true)
						KM_KingCasting = true
						KM_KingCastbar:SetVisible(true)
					else
						KM_KingCasting = true
						KM_KingCastbar:SetVisible(true)	
					end
				else
					KM_KingCasting = true
					KM_KingCastbar:SetVisible(true)
				end
				--end
			--end
		end
	--[[else
		KM_KingCastbar:SetVisible(false)
		KM_KingCastIcon:SetTexture("", "")
		KM_KingCastIcon:SetVisible(false)
		KM_KingCastProgress:SetWidth(0)
		KM_KingCastText:SetText("")
		KM_KingCasting = false	
	end]]
end

local function KM_UpdatePrinceCast()
	local bDetails = Inspect.Unit.Castbar(KM_PrinceID)
	if bDetails then
		bCastTime = bDetails.duration
		bProgress = bDetails.remaining
		KM_PrinceCastProgress:SetWidth(KM_PrinceCastbar:GetWidth() * (1-(bProgress/bCastTime)))
		KM_PrinceCastText:SetText(string.format("%0.01f", bProgress).." - "..bDetails.abilityName)
		KM_PrinceCastText:SetWidth(KM_PrinceCastText:GetFullWidth())
		KM_PrinceCastText:SetHeight(KM_PrinceCastText:GetFullHeight())
	else
		KM_PrinceCastbar:SetVisible(false)
		KM_PrinceCastIcon:SetTexture("", "")
		KM_PrinceCastIcon:SetVisible(false)
		KM_PrinceCastProgress:SetWidth(0)
		KM_PrinceCastText:SetText("")
		KM_PrinceCasting = false		
	end
end

local function KM_ManagePrinceCasts(Visible)
	--if Visible then
		local bDetails = Inspect.Unit.Castbar(KM_PrinceID)
		if bDetails then
			--if KM_AbilityWatch[bDetails.ability] then
				--if KM_AbilityWatch[bDetails.ability].Watching then
				if bDetails.ability then
					local aDetails = Inspect.Ability.Detail(bDetails.ability)
					if aDetails then
						KM_PrinceCastIcon:SetTexture("Rift", aDetails.icon)
						KM_PrinceCastIcon:SetVisible(true)
						KM_PrinceCasting = true
						KM_PrinceCastbar:SetVisible(true)
					else
						KM_PrinceCasting = true
						KM_PrinceCastbar:SetVisible(true)
					end
				else
					KM_PrinceCasting = true
					KM_PrinceCastbar:SetVisible(true)
				end
				--end
			--end
		end
	--[[else
		KM_PrinceCastbar:SetVisible(false)
		KM_PrinceCastIcon:SetTexture("", "")
		KM_PrinceCastIcon:SetVisible(false)
		KM_PrinceCastProgress:SetWidth(0)
		KM_PrinceCastText:SetText("")
		KM_PrinceCasting = false	
	end]]
end

local function KM_UpdateTestBar()
	bDetails = Inspect.Unit.Castbar(SBM_PlayerID)
	if bDetails then
		if bDetails.ability then
			aDetails = Inspect.Ability.Detail(bDetails.ability)
			if aDetails then
				bCastTime = bDetails.duration
				bProgress = bDetails.remaining
				KM_KingCastProgress:SetWidth(KM_KingCastbar:GetWidth() * (1-(bProgress/bCastTime)))
				KM_KingCastText:SetText(string.format("%0.01f", bProgress).." - "..aDetails.name)
				KM_KingCastText:SetWidth(KM_KingCastText:GetFullWidth())
				KM_KingCastText:SetHeight(KM_KingCastText:GetFullHeight())
			end
		end
	end
end

local function KM_ManageTestCasts(Visible)
	if Visible then
		--print("Cast Start")
		bDetails = Inspect.Unit.Castbar(SBM_PlayerID)
		if bDetails then
			if bDetails.ability then
				local aDetails = Inspect.Ability.Detail(bDetails.ability)
				if aDetails then
					KM_KingCastIcon:SetTexture("Rift", aDetails.icon)
					KM_KingCastIcon:SetVisible(true)
					SBM_TestAbility = bDetails.ability
					SBM_TestIsCasting = true
					KM_KingCastbar:SetVisible(true)
				else
					
				end
			end
		end
	else
		KM_KingCastbar:SetVisible(false)
		KM_KingCastIcon:SetTexture("", "")
		KM_KingCastIcon:SetVisible(false)
		KM_KingCastProgress:SetWidth(0)
		KM_KingCastText:SetText("")
		SBM_TestIsCasting = false
		--print("Cast Stopped")
	end
end

local function KM_CastBar(units)
	local processed = 0
	for UnitID, Visible in pairs(units) do
		if UnitID == KM_KingID then
			if KingMol_Main.KingBar then
				KM_ManageKingCasts(Visible)
				--processed = processed + 1
			end
		elseif UnitID == KM_PrinceID then
			if KingMol_Main.PrinceBar then
				KM_ManagePrinceCasts(Visible)
				--processed = processed + 1
			end
		--elseif UnitID == SBM_PlayerID then
		--	KM_ManageTestCasts(Visible)
		end
		if processed == 2 then
			return
		end
	end
end

local function SBM_CastBar(units)
	--print("SBM_CastBar Event Handled")
	if SBM_Encounter then
		if SBM_CurrentCBHook then
			SBM_CurrentCBHook(units)
		end
	--else
		-- Testing Only!
		--KM_CastBar(units)
	end
end

local function KM_TimeToHours(Time)
	KM_TimeVisual.String = "00"
	if Time >= 60 then
		KM_TimeVisual.Minutes = math.floor(Time / 60)
		KM_TimeVisual.Seconds = Time - (KM_TimeVisual.Minutes * 60)
		if KM_TimeVisual.Minutes >= 60 then
			KM_TimeVisual.Hours = math.floor(KM_TimeVisual.Minutes / 60)
			KM_TimeVisual.Minutes = KM_TimeVisual.Minutes - math.floor(KM_TimeVisual.Hours * 60)
		else
			KM_TimeVisual.String = string.format("%02d:%02d", KM_TimeVisual.Minutes, KM_TimeVisual.Seconds)
		end
	else
		KM_TimeVisual.Seconds = Time
		KM_TimeVisual.String = string.format("%02d", KM_TimeVisual.Seconds)
	end
end

local function KM_Timer()
	if KM_EncounterRunning then
		local current = Inspect.Time.Real()
		local diff = (current - KM_HeldTime)
		local udiff = (current - KM_UpdateTime)
		if diff >= 1 then
			KM_TimeElapsed = KM_TimeElapsed + math.floor(diff)
			KM_TimeToHours(KM_TimeElapsed)
			KM_DPSUpdate()
			KM_HeldTime = current - (diff - math.floor(diff))
			KM_UpdateTime = current
		elseif udiff > 0.15 then
			KM_CheckTrends()
			KM_UpdateTime = current
		end
		if KingMol_Main.PrinceBar then
			if KM_PrinceID then
				KM_UpdatePrinceCast()
			end
		end
		if KingMol_Main.KingBar then
			if KM_KingID then
				KM_UpdateKingCast()
			end
		end
	end
	--KM_UpdateTestBar()
end

local function KM_ToggleEnabled(result)
	
end

local function KM_Start()
	--KM_BuildDisplay()
	print("-- Welcome to King Molinator --")
	print("please type /kmhelp for a list of commands.")
	KM_FBDefX = KingMol_Main.LocX
	KM_FBDefY = KingMol_Main.LocY
	--table.insert(Event.Unit.Available, {SBM_UnitAvailable, "KingMolinator", "Event"})	
	table.insert(Event.Unit.Detail.Health, {SBM_UnitHPCheck, "KingMolinator", "Event"})
	table.insert(Event.Unit.Unavailable, {SBM_UnitRemoved, "KingMolinator", "Event"})
	table.insert(Event.System.Update.Begin, {KM_Timer, "KingMolinator", "Event"}) -- Actual run-time timer.
	--table.insert(Event.System.Update.Begin, {SBM_Timer, "KingMolinator", "Event"}) 
	table.insert(Event.Combat.Death, {SBM_Death, "KingMolinator", "Event"})
	table.insert(Event.Unit.Castbar, {SBM_CastBar, "KingMolinator", "Cast Bar Event"})
	SBM_InitOptions()
	KM_HK.Header = SBM_MainWin.Menu:CreateHeader("Hammerknell", KM_ToggleEnabled, true)
	KM_HK.Murdantix.MenuItem = SBM_MainWin.Menu:CreateEncounter(KM_HK.Murdantix.Name, KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Matron.MenuItem = SBM_MainWin.Menu:CreateEncounter("Matron Zamira", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Sicaron.MenuItem = SBM_MainWin.Menu:CreateEncounter("Sicaron", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Zilas.MenuItem = SBM_MainWin.Menu:CreateEncounter("Soulrender Zilas", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Prime.MenuItem = SBM_MainWin.Menu:CreateEncounter("Vladmal Prime", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Grugonim.MenuItem = SBM_MainWin.Menu:CreateEncounter("Grugonim", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.KingMolinar.MenuItem = SBM_MainWin.Menu:CreateEncounter(KM_HK.KingMolinar.Name, KM_ToggleEnabled, true, KM_HK.Header)
	KM_HK.Estrode.MenuItem = SBM_MainWin.Menu:CreateEncounter("Estrode", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Garau.MenuItem = SBM_MainWin.Menu:CreateEncounter("Inquisitor Garau", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Inwar.MenuItem = SBM_MainWin.Menu:CreateEncounter("Inwar Darktide", KM_ToggleEnabled, false, KM_HK.Header)
	KM_HK.Akylios.MenuItem = SBM_MainWin.Menu:CreateEncounter("Akylios", KM_ToggleEnabled, false, KM_HK.Header)
end

local function KM_Hide()
	KM_FrameBase:SetVisible(false)
	KingMol_Main.Hidden = true
end

local function KM_Show()
	KM_FrameBase:SetVisible(true)
	KingMol_Main.Hidden = false
end

local function KM_Lock()
	KM_DragFrame:SetVisible(false)
	KingMol_Main.Locked = true
	print("Monitor is now locked.")
end

local function KM_Unlock()
	KM_DragFrame:SetVisible(true)
	KingMol_Main.Locked = false
	print("Monitor is now unlocked.")
end

local function KM_ToggleKing()
	if KingMol_Main.KingBar then
		KingMol_Main.KingBar = false
		print(KM_KingName.."'s cast bar is now off.")
	else
		KingMol_Main.KingBar = true
		print(KM_KingName.."'s cast bar is now on.")
	end
end

local function KM_TogglePrince()
	if KingMol_Main.PrinceBar then
		KingMol_Main.PrinceBar = false
		print(KM_PrinceName.."'s cast bar is now off.")
	else
		KingMol_Main.PrinceBar = true
		print(KM_PrinceName.."'s cast bar is now on.")
	end
end

local function KM_WaitReady(unitID)
	KM_Start()
	SBM_PlayerID = unitID
	if not KM_DisplayReady then
		KM_DisplayReady = true
		KM_BuildDisplay()
	end
	--print(KM_SwingMulti)
end

local function KM_AutoReset()
	if KingMol_Main.AutoReset then
		KingMol_Main.AutoReset = false
		print("Auto-Reset is now off.")
	else
		KingMol_Main.AutoReset = true
		print("Auto-Reset is now on (Experimental: Please report the accuracy of this.)")
	end
end

local function KM_SizeToggle()
	if KingMol_Main.Compact then
		KingMol_Main.Compact = false
		KM_SetNormal()
	else
		KingMol_Main.Compact = true
		KM_SetCompact()
	end
end

local function KM_Help()
	print("King Molinator in game slash commands")
	print("/kmshow -- Shows the monitor permanently.")
	print("/kmhide -- Only shows the monitor during the encounter.")
	print("/kmlock -- Stops the monitor from being moved.")
	print("/kmunclock -- Allows the monitor to be moved.")
	print("/kmsize -- Toggles between normal and compact sizes.")
	print("/kmprincebar -- Toggles Prince's cast bar on/off.")
	print("/kmkingbar -- Toggles King's cast bar on/off.")
	print("/kmautoreset -- Toggle on/off, if you wish the addon to calculate a wipe (experimental).")
	print("/kmreset -- Resets the monitor's data, and recalculates.")
	print("/kmhelp -- Displays what you're reading now :)")
end

-- Safes Boss Mods
-- Boss List (For encounter start monitoring)
--SBM_Boss["Trickster Maelow"] = ROF_UnitHPCheck

-- King Link Vars
local KM_ModDetails = {
		DPSHook = KM_UnitHPCheck,
		CBHook = KM_CastBar,
}

if SBM_Lang == "German" then
	KM_KingName = "Runenkönig Molinar"
	KM_PrinceName = "Prinz Dollin"
elseif SBM_Lang == "French" then
	KM_KingName = "Roi runique Molinar"
end
SBM_Boss[KM_PrinceName] = KM_ModDetails
SBM_Boss[KM_KingName] = KM_ModDetails

table.insert(Event.Addon.SavedVariables.Load.End, {KM_LoadVars, "KingMolinator", "Event"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {KM_SaveVars, "KingMolinator", "Event"})
table.insert(Event.SafesRaidManager.Player.Ready, {KM_WaitReady, "KingMolinator", "Sync Wait"})
table.insert(Command.Slash.Register("kmshow"), {KM_Show, "KingMolinator", "KM Show"})
table.insert(Command.Slash.Register("kmhide"), {KM_Hide, "KingMolinator", "KM Hide"})
table.insert(Command.Slash.Register("kmlock"), {KM_Lock, "KingMolinator", "KM Lock"})
table.insert(Command.Slash.Register("kmunlock"), {KM_Unlock, "KingMolinator", "KM Unloack"})
table.insert(Command.Slash.Register("kmreset"), {KM_Reset, "KingMolinator", "KM Reset"})
table.insert(Command.Slash.Register("kmsize"), {KM_SizeToggle, "KingMolinator", "KM Size Toggle"})
table.insert(Command.Slash.Register("kmhelp"), {KM_Help, "KingMolinator", "KM Hekp"})
table.insert(Command.Slash.Register("kmautoreset"), {KM_AutoReset, "KingMolinator", "KM Auto Reset Toggle"})
table.insert(Command.Slash.Register("kmkingbar"), {KM_ToggleKing, "KingMolinator", "KM Toggle King Bar"})
table.insert(Command.Slash.Register("kmprincebar"), {KM_TogglePrince, "KingMolinator", "KM Toggle Prince Bar"})
table.insert(Command.Slash.Register("sbmoptions"), {SBM_Options, "KingMolinator", "KM Open Options"})