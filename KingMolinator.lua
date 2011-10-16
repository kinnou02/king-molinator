-- King Molinator
-- Written By Paul Snart

KBM_GlobalOptions = nil
local KBM_BossMod = {}
local KingMol_Main = {}
local KBM = {}

KBM.Options = {
	AutoReset = true,
	Frame = {
		x = nil,
		y = nil,
	}
}

local function KBM_DefineVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM_GlobalOptions = KBM.Options
		for Mod in pairs(KBM_BossMod) do
			KBM_BossMod[Mod]:InitVars()
		end
	end
end

local function KBM_LoadVars(AddonID)
	if AddonID == "KingMolinator" then
		--if KBM_GlobalOptions then
		--	KBM.Options = KBM_GlobalOptions
		--end
		for Setting, Value in pairs(KBM_GlobalOptions) do
			KBM.Options[Setting] = Value
		end
		for Mod in pairs(KBM_BossMod) do
			KBM_BossMod[Mod]:LoadVars()
		end
	end
end

local function KBM_SaveVars(AddonID)
	if AddonID == "KingMolinator" then
		KBM_GlobalOptions = KBM.Options
		for Mod in pairs(KBM_BossMod) do
			KBM_BossMod[Mod]:SaveVars()
		end
	end
end

function KBM_ToAbilityID(num)
	return string.format("a%016X", num)
end

KBM.Lang = Inspect.System.Language()
local KBM_Boss = {}
KBM.BossID = {}
KBM.Encounter = false
local KBM_CurrentHook = nil
local KBM_CurrentCBHook = nil
local KBM_CurrentBoss = ""
local KBM_CurrentMod = nil
local KBM_PlayerID = nil
local KBM_TestIsCasting = false
local KBM_TestAbility = nil

local KBM_HeldTime = Inspect.Time.Real()
local KBM_StartTime = 0
local KBM_TimeElapsed = 0

-- Addon Primary Context
KBM.Context = UI.CreateContext("KBM_Context")
local KM_Name = "King Molinator"

-- Addon KBM Primary Frames
local KBM_MainWin = {
	Handle = {},
	Border = {},
	Content = {},
}

KBM.TimeVisual = {}
KBM.TimeVisual.String = "00"
KBM.TimeVisual.Seconds = 0
KBM.TimeVisual.Minutes = 0
KBM.TimeVisual.Hours = 0

function KBM_RegisterMod(ModID, Mod)
	KBM_BossMod[ModID] = Mod
	return KBM
end

local function KBM_InitOptions()
	KBM_MainWin = UI.CreateFrame("RiftWindow", "Safe's Boss Mods", KBM.Context)
	KBM_MainWin:SetVisible(false)
	KBM_MainWin:SetController("border")
	KBM_MainWin:SetWidth(750)
	KBM_MainWin:SetHeight(550)
	KBM_MainWin:SetTitle("KM Boss Mods: Options")
	
	KBM_MainWin.FrameStore = {}
	KBM_MainWin.CheckStore = {}
	KBM_MainWin.SlideStore = {}
	KBM_MainWin.TextfStore = {}
	
	function KBM_MainWin:CallFrame(parent)
		local frame = nil
		if #self.FrameStore == 0 then
			frame = UI.CreateFrame("Frame", "Frame Store", parent)
			function frame:Remove()
				table.insert(KBM_MainWin.FrameStore, self)
			end
		else
			frame = table.remove(self.FrameStore)
			frame:ClearAll()
			frame:SetParent(parent)
		end
		return frame
	end
	
	function KBM_MainWin:CallCheck(parent)
		local Checkbox = nil
		if #self.CheckStore == 0 then
			Checkbox = UI.CreateFrame("RiftCheckbox", "Check Store", parent)
			function Checkbox:Remove()
			
			end
		else
			Checkbox = table.remove(self.CheckStore)
			Checkbox:ClearAll()
			Checkbox:ResizeToDefault()
			Checkbox:SetParent(parent)
		end
		return Checkbox
	end
	
	function KBM_MainWin:CallText(parent)
		local Textbox = nil
		if #self.TextfStore == 0 then
			Textfbox = UI.CreateFrame("Text", "Textf Store", parent)
			function Textfbox:Remove()
			
			end
		else
			Textfbox = table.remove(self.TextfStore)
			Textfbox:ClearAll()
			Textfbox:SetParent(parent)
		end
		return Textfbox
	end
	
	if not KBM.Options.Frame.x then
		KBM_MainWin:SetPoint("CENTER", UIParent, "CENTER")
	else
		KBM_MainWin:SetPoint("TOPLEFT", UIParent, "TOPLEFT", KBM.Options.Frame.x, KBM.Options.Frame.y)
	end
	
	KBM_MainWin.Border = KBM_MainWin:GetBorder()
	KBM_MainWin.Content = KBM_MainWin:GetContent()

	BorderX = KBM_MainWin.Border:GetLeft()
	BorderY = KBM_MainWin.Border:GetTop()
	ContentX = KBM_MainWin.Content:GetLeft()
	ContentY = KBM_MainWin.Content:GetTop()
	ContentW = KBM_MainWin.Content:GetWidth()
	ContentH = KBM_MainWin.Content:GetHeight()
	
	KBM_MainWin.Handle = UI.CreateFrame("Frame", "SBM Window Handle", KBM_MainWin)
	KBM_MainWin.Handle:SetPoint("TOPLEFT", KBM_MainWin, "TOPLEFT")
	KBM_MainWin.Handle:SetWidth(KBM_MainWin.Border:GetWidth())
	KBM_MainWin.Handle:SetHeight(ContentY-BorderY)
	KBM_MainWin.Handle.parent = KBM_MainWin.Handle:GetParent()
	function KBM_MainWin.Handle.Event:LeftDown()
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
	function KBM_MainWin.Handle.Event:MouseMove(newX, newY)
		if self.MouseDown then
			self.parent:SetPoint("TOPLEFT", UIParent, "TOPLEFT", newX - self.OffsetX, newY - self.OffsetY)
		end
	end
	function KBM_MainWin.Handle.Event:LeftUp()
		if self.MouseDown then
			self.MouseDown = false
			KBM.Options.Frame.x = self:GetLeft()
			KBM.Options.Frame.y = self:GetTop()
		end
	end
	
	MenuWidth = math.floor(ContentW * 0.25)-10

	KBM_MainWin.Menu = UI.CreateFrame("Frame", "SBM Menu Frame", KBM_MainWin.Content)
	KBM_MainWin.Menu:SetWidth(MenuWidth)
	KBM_MainWin.Menu:SetHeight(ContentH)
	KBM_MainWin.Menu:SetPoint("TOPLEFT", KBM_MainWin.Content, "TOPLEFT",5, 5)
	KBM_MainWin.Menu.Headers = {}
	KBM_MainWin.Menu.LastHeader = nil
	
	KBM_MainWin.SplitFrame = UI.CreateFrame("Frame", "KBM Splitter", KBM_MainWin.Content)
	KBM_MainWin.SplitFrame:SetWidth(14)
	KBM_MainWin.SplitFrame:SetHeight(ContentH)
	KBM_MainWin.SplitFrame:SetPoint("LEFT", KBM_MainWin.Menu, "RIGHT")
	KBM_MainWin.SplitFrame:SetPoint("TOP", KBM_MainWin.Content, "TOP")
	KBM_MainWin.SplitHandle = UI.CreateFrame("Frame", "KBM Splitter Handle", KBM_MainWin.SplitFrame)
	KBM_MainWin.SplitHandle:SetWidth(5)
	KBM_MainWin.SplitHandle:SetHeight(ContentH)
	KBM_MainWin.SplitHandle:SetPoint("CENTER", KBM_MainWin.SplitFrame, "CENTER")
	KBM_MainWin.SplitHandle:SetBackgroundColor(1,1,1,0.5)

	OptionsWidth = ContentW - KBM_MainWin.Menu:GetWidth() - KBM_MainWin.SplitFrame:GetWidth() - 10
	KBM_MainWin.Options = UI.CreateFrame("Frame", "KBM Options Frame", KBM_MainWin.Content)
	KBM_MainWin.Options:SetWidth(OptionsWidth)
	KBM_MainWin.Options:SetHeight(ContentH)
	KBM_MainWin.Options:SetPoint("TOPLEFT", KBM_MainWin.SplitFrame, "TOPRIGHT")
	
	KBM_MainWin.Options.Close = UI.CreateFrame("RiftButton", "Close Options", KBM_MainWin.Options)
	KBM_MainWin.Options.Close:SetPoint("BOTTOMRIGHT", KBM_MainWin.Options, "BOTTOMRIGHT")
	KBM_MainWin.Options.Close:SetText("Close")
	function KBM_MainWin.Options.Close.Event:LeftPress()
		KBM_MainWin:SetVisible(false)
	end

	function KBM_MainWin.Menu:CreateHeader(Text, Hook, Default)
		Header = {}
		Header.Children = {}
		Header.Frame = KBM_MainWin:CallFrame(self)
		Header.Frame:SetWidth(self:GetWidth())
		Header.Check = KBM_MainWin:CallCheck(Header.Frame)
		Header.Check:SetPoint("CENTERLEFT", Header.Frame, "CENTERLEFT", 4, 0)
		Header.Check:SetChecked(Default)
		Header.Text = KBM_MainWin:CallText(Header.Frame)
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
	function KBM_MainWin.Menu:CreateEncounter(Text, Link, Default, Header)
		Child = {}
		Child.Frame = KBM_MainWin:CallFrame(self)
		Child.Frame:SetWidth(self:GetWidth()-Header.Check:GetWidth())
		Child.Frame:SetPoint("RIGHT", self, "RIGHT")
		Child.Check = KBM_MainWin:CallCheck(Child.Frame)
		Child.Check:SetPoint("CENTERLEFT", Child.Frame, "CENTERLEFT", 4, 0)
		Child.Check:SetChecked(Default)
		Child.Text = KBM_MainWin:CallText(Child.Frame)
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
		function Child:Enabled(bool)
			self.Check:SetEnabled(bool)
			if bool then
				self.Text:SetFontColor(1,1,1)
			else
				self.Text:SetFontColor(0.5,0.5,0.5)
			end
		end
		Child.Link = Link
		Child.Options = {}
		Child.Options.List = {}
		Child.Options.Child = Child
		Child.Header = Header
		Child.Options.Title = {}
		Child.Options.LastItem = nil
		function Child.Options:SetTitle()
			local Title = KBM_MainWin:CallFrame(KBM_MainWin.Content)
			Title:SetWidth(KBM_MainWin.Options:GetWidth())
			Title:SetPoint("TOPLEFT", KBM_MainWin.Options, "TOPLEFT")
			Title:SetBackgroundColor(0,0,0,0.25)
			Title.HeadText = KBM_MainWin:CallText(Title)
			Title.HeadText:SetText(self.Child.Header.Text:GetText())
			Title.HeadText:SetFontColor(0.85,0.65,0.0)
			Title.HeadText:SetFontSize(18)
			Title.HeadText:SetPoint("TOPRIGHT", Title, "TOPRIGHT")
			Title.HeadText:ResizeToText()
			Title.SubText = KBM_MainWin:CallText(Title)
			Title.SubText:SetText(self.Child.Text:GetText())
			Title.SubText:SetFontSize(18)
			Title.SubText:SetPoint("BOTTOMLEFT", Title, "BOTTOMLEFT")
			Title.SubText:ResizeToText()
			Title.Separator = KBM_MainWin:CallFrame(KBM_MainWin.Content)
			Title.Separator:SetWidth(Title:GetWidth())
			Title.Separator:SetHeight(10)
			Title.Separator:SetPoint("TOPLEFT", Title, "BOTTOMLEFT")
			self.LastItem = Title.Separator
			self.Title = Title
			function Title:Remove()
			
			end
		end
		function Child.Options:AddSpacer(Size)
			if not Size then
				Size = 10
			end
			local Spacer = KBM_MainWin:CallFrame(KBM_MainWin.Content)
			if self.LastItem.LastChild then
				Spacer:SetPoint("TOP", self.LastItem.LastChild, "BOTTOM")
				Spacer:SetPoint("LEFT", KBM_MainWin.Options, "LEFT")
			else
				Spacer:SetPoint("TOPLEFT", self.LastItem, "BOTTOMLEFT")
			end
			Spacer:SetWidth(KBM_MainWin.Content:GetWidth())
			Spacer:SetHeight(Size)
			self.LastItem = Spacer
			table.insert(self.List, Spacer)
			function Spacer:Remove()
			
			end
		end
		function Child.Options:AddHeader(Text, Callback, Default)
			local Header = KBM_MainWin:CallFrame(KBM_MainWin.Content)
			if self.LastItem.LastChild then
				Header:SetPoint("TOP", self.LastItem, "BOTTOM")
				Header:SetPoint("LEFT", KBM_MainWin.Options, "LEFT")
			else
				Header:SetPoint("TOPLEFT", self.LastItem, "BOTTOMLEFT")
			end
			Header.Text = KBM_MainWin:CallText(Header)
			Header.Text:SetText(Text)
			Header.Text:SetFontColor(0.85,0.65,0)
			Header.Text:SetFontSize(16)
			Header.Text:ResizeToText()
			Header.Check = KBM_MainWin:CallCheck(Header)
			Header.Check:SetPoint("CENTERLEFT", Header, "CENTERLEFT")
			if not Callback then
				Header.Check:SetEnabled(false)
				Header.Check:SetVisible(false)
			else
				Header.Check:SetChecked(Default)
				Header.Check.Callback = Callback
				function Header.Check.Event:CheckboxChange()
					self:Callback(self:GetChecked())
				end
			end
			Header.Text:SetPoint("CENTERLEFT", Header.Check, "CENTERRIGHT")
			Header:SetHeight(Header.Text:GetHeight())
			Header.Children = {}
			Header.LastChild = Header
			self.LastItem = Header
			table.insert(self.List, Header)
			function Header:AddCheck(Text, Callback, Default)
				local CheckFrame = KBM_MainWin:CallFrame(KBM_MainWin.Content)
				if self.LastChild == self then
					CheckFrame:SetPoint("LEFT", self.Check, "RIGHT")
					CheckFrame:SetPoint("TOP", self, "BOTTOM")
				else
					CheckFrame:SetPoint("TOPLEFT", self.LastChild, "BOTTOMLEFT")
				end
				CheckFrame:SetWidth(KBM_MainWin.Content:GetWidth())
				CheckFrame.Check = KBM_MainWin:CallCheck(CheckFrame)
				CheckFrame.Check:SetPoint("CENTERLEFT", CheckFrame, "CENTERLEFT")
				CheckFrame.Check:SetChecked(Default)
				CheckFrame.Text = KBM_MainWin:CallText(CheckFrame)
				CheckFrame.Text:SetText(Text)
				CheckFrame.Text:SetFontSize(14)
				CheckFrame.Text:SetPoint("CENTERLEFT", CheckFrame.Check, "CENTERRIGHT")
				CheckFrame.Text:ResizeToText()
				CheckFrame:SetHeight(CheckFrame.Text:GetHeight())
				CheckFrame.Check.Callback = Callback
				self.LastChild = CheckFrame
				table.insert(self.Children, CheckFrame)
				function CheckFrame:Revove()
				
				end
				function CheckFrame.Check.Event:CheckboxChange()
					self:Callback(self:GetChecked())
				end
				return CheckFrame
			end
			function Header:Remove()
			
			end
			return Header
		end
		function Child.Options:AddCheck(Text)
		end
		function Child.Options:ClearPage()
		
		end
		return Child
	end
			
end

local function KBM_Options()
	if KBM_MainWin:GetVisible() then
		KBM_MainWin:SetVisible(false)
	else
		KBM_MainWin:SetVisible(true)
	end
end

local function KBM_Dummy(units)
end

local function ROF_UnitHPCheck()
	
	if KBM.Encounter then
		uDetails = Inspect.Unit.Detail(KBM_CurrentBoss)
		if not uDetails then
			KBM.Encounter = false
			KBM.BossID[KBM_CurrentBoss] = nil
			KBM_CurrentBoss = nil
			KBM_CurrentHook = nil
			KBM_CurrentMod = nil
			--print("Encounter Ended")
		else -- Continue to manage the encounter.
		
		end
	end
	
end

local function KBM_Death(info)
	
	if KBM.Encounter then
		local UnitID = info.target
		if UnitID then
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not uDetails.player then
					if KBM.BossID[UnitID] then
						-- The Boss, or one of the bosses has died.
					end
				end
			end
		end
	end
	
end

local function KBM_UnitHPCheck(units)
	if not KBM.Encounter then -- check for bosses for an encounter start

		--print("Encounter Check")
		local uDetails = {}
		for UnitID, Specifier in pairs(units) do
			local uDetails = Inspect.Unit.Detail(UnitID)
			if uDetails then
				if not KBM.BossID[UnitID] then
					if KBM_Boss[uDetails.name] then
						--print("Boss seen (adding): "..UnitID.." ("..uDetails.name..") ")
						--if uDetails.level == "??" then
							KBM.BossID[UnitID] = {}
							KBM.BossID[UnitID].name = uDetails.name
							KBM.BossID[UnitID].monitor = true
							KBM.BossID[UnitID].hook = KBM_Boss[uDetails.name].DPSHook
							KBM.BossID[UnitID].CBHook = KBM_Boss[uDetails.name].CBHook
							KBM.BossID[UnitID].Mod = KBM_Boss[uDetails.name].Mod
							if uDetails.health > 0 then
								KBM.BossID[UnitID].dead = false
								KBM.Encounter = true
								KBM_CurrentHook = KBM.BossID[UnitID].hook
								KBM_CurrentBoss = UnitID
								KBM_CurrentHook(uDetails, UnitID)
								KBM_CurrentCBHook = KBM.BossID[UnitID].CBHook
								KBM_CurrentMod = KBM.BossID[UnitID].Mod
							else
								KBM.BossID[UnitID].dead = true
								--print("Boss has been killed: Removing")
								KBM.BossID[UnitID] = nil
							end
						--end
					else
						--print("Unit is not a boss: "..UnitID.." ("..uDetails.name..")")
					end
				else
					--print("Boss already seen. Redirecting "..KBM.BossID[UnitID].name)
					--KBM.BossID[UnitID].hook()
				end
			else
				--print(UnitID.." (n/a)")
			end
		end
	else
		if KBM_CurrentHook then
			--KBM_CurrentHook()
		else
			--KBM.Encounter = false
			--print("Encounter ended")
		end
	end
end

local function KBM_UnitRemoved(units)
	--[[local uDetails = {}]]
	if KBM.Encounter then
		if KBM.Options.AutoReset then
			for UnitID, Specifier in pairs(units) do
				if KBM.BossID[UnitID] then
					if KBM_CurrentMod then
						KBM_CurrentMod:RemoveUnits(UnitID)
					end
				end
			end
		end
	end
end

local function KBM_UnitAvailable(units)
end

function KBM.AttachDragFrame(parent, hook, name, layer)

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

local function KBM_Timer()
	local current = Inspect.Time.Real()
	
	if (current - KBM_HeldTime) >= 1 then
		KBM_HeldTime = KBM_HeldTime + 1
		if KBM.Encounter then
			KBM_TimeElapsed = KBM_HeldTime - KBM_StartTime
			if KBM_CurrentHook then
				KBM_CurrentHook()
			end
		end
	end
end


local function KBM_CastBar(units)
	--print("KBM_CastBar Event Handled")
	if KBM.Encounter then
		if KBM_CurrentCBHook then
			KBM_CurrentCBHook(units)
		end
	--else
		-- Testing Only!
		--KM_CastBar(units)
	end
end

function KBM:TimeToHours(Time)
	self.TimeVisual.String = "00"
	if Time >= 60 then
		self.TimeVisual.Minutes = math.floor(Time / 60)
		self.TimeVisual.Seconds = Time - (self.TimeVisual.Minutes * 60)
		if self.TimeVisual.Minutes >= 60 then
			self.TimeVisual.Hours = math.floor(self.TimeVisual.Minutes / 60)
			self.TimeVisual.Minutes = self.TimeVisual.Minutes - math.floor(self.TimeVisual.Hours * 60)
		else
			self.TimeVisual.String = string.format("%02d:%02d", self.TimeVisual.Minutes, self.TimeVisual.Seconds)
		end
	else
		self.TimeVisual.Seconds = Time
		self.TimeVisual.String = string.format("%02d", self.TimeVisual.Seconds)
	end
end

local function KM_ToggleEnabled(result)
	
end

local function KBM_Start()
	--KM_BuildDisplay()
	print("-- Welcome to KM:Boss Mods --")
	print("/kbmhelp for a list of commands.")
	print("/kbmoptions for options.")
	--table.insert(Event.Unit.Available, {KBM_UnitAvailable, "KingMolinator", "Event"})	
	table.insert(Event.Unit.Detail.Health, {KBM_UnitHPCheck, "KingMolinator", "Event"})
	table.insert(Event.Unit.Unavailable, {KBM_UnitRemoved, "KingMolinator", "Event"})
	--table.insert(Event.System.Update.Begin, {KBM_Timer, "KingMolinator", "Event"}) 
	table.insert(Event.Combat.Death, {KBM_Death, "KingMolinator", "Event"})
	table.insert(Event.Unit.Castbar, {KBM_CastBar, "KingMolinator", "Cast Bar Event"})
	KBM_InitOptions()	
end

--[[local function KM_Hide()
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
end]]

local function KBM_WaitReady(unitID)
	KBM_Start()
	for Mod in pairs(KBM_BossMod) do
		KBM_BossMod[Mod]:Start(KBM_MainWin)
		KBM_BossMod[Mod]:AddBosses(KBM_Boss)
	end
	KBM_PlayerID = unitID
	--print(KM_SwingMulti)
end

local function KBM_AutoReset()
	if KBM.Options.AutoReset then
		KBM.Options.AutoReset = false
		print("Auto-Reset is now off.")
	else
		KBM.Options.AutoReset = true
		print("Auto-Reset is now on (Experimental: Please report the accuracy of this.)")
	end
end

--[[local function KM_SizeToggle()
	if KM.Compact then
		KingMol_Main.Compact = false
		KM_SetNormal()
	else
		KingMol_Main.Compact = true
		KM_SetCompact()
	end
end]]

local function KBM_Help()
	print("King Molinator in game slash commands")
	--print("/kmshow -- Shows the monitor permanently.")
	--print("/kmhide -- Only shows the monitor during the encounter.")
	--print("/kmlock -- Stops the monitor from being moved.")
	--print("/kmunclock -- Allows the monitor to be moved.")
	--print("/kmsize -- Toggles between normal and compact sizes.")
	--print("/kmprincebar -- Toggles Prince's cast bar on/off.")
	--print("/kmkingbar -- Toggles King's cast bar on/off.")
	print("/kbmautoreset -- Toggle on/off, if you wish the addon to calculate a wipe (experimental).")
	print("/kbmreset -- Resets the monitor's data, and recalculates.")
	print("/kbmoptions -- Toggles the GUI Options screen.")
	print("/kbmhelp -- Displays what you're reading now :)")
end

local function KBM_Reset()
	if KBM.Encounter then
		if KBM_CurrentMod then
			KBM_CurrentMod:Reset()
		end
	else
		print("No encounter to reset.")
	end
end

-- Safes Boss Mods
-- Boss List (For encounter start monitoring)
--KBM_Boss["Trickster Maelow"] = ROF_UnitHPCheck

table.insert(Event.Addon.SavedVariables.Load.Begin, {KBM_DefineVars, "KingMolinator", "Pre Load"})
table.insert(Event.Addon.SavedVariables.Load.End, {KBM_LoadVars, "KingMolinator", "Event"})
table.insert(Event.Addon.SavedVariables.Save.Begin, {KBM_SaveVars, "KingMolinator", "Event"})
table.insert(Event.SafesRaidManager.Player.Ready, {KBM_WaitReady, "KingMolinator", "Sync Wait"})
--table.insert(Command.Slash.Register("kmshow"), {KM_Show, "KingMolinator", "KM Show"})
--table.insert(Command.Slash.Register("kmhide"), {KM_Hide, "KingMolinator", "KM Hide"})
--table.insert(Command.Slash.Register("kmlock"), {KM_Lock, "KingMolinator", "KM Lock"})
--table.insert(Command.Slash.Register("kmunlock"), {KM_Unlock, "KingMolinator", "KM Unloack"})
table.insert(Command.Slash.Register("kbmreset"), {KBM_Reset, "KingMolinator", "KM Reset"})
--table.insert(Command.Slash.Register("kmsize"), {KM_SizeToggle, "KingMolinator", "KM Size Toggle"})
table.insert(Command.Slash.Register("kbmhelp"), {KBM_Help, "KingMolinator", "KM Hekp"})
table.insert(Command.Slash.Register("kbmautoreset"), {KBM_AutoReset, "KingMolinator", "KM Auto Reset Toggle"})
--table.insert(Command.Slash.Register("kmkingbar"), {KM_ToggleKing, "KingMolinator", "KM Toggle King Bar"})
--table.insert(Command.Slash.Register("kmprincebar"), {KM_TogglePrince, "KingMolinator", "KM Toggle Prince Bar"})
table.insert(Command.Slash.Register("kbmoptions"), {KBM_Options, "KingMolinator", "KM Open Options"})