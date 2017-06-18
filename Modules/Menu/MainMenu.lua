-- KBM Menu System
-- Written by Paul Snart
-- Copyright 2013
--

local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

-- KBM and Menu system crossover.
function KBM.SetBossTimers(Boss, bool)
	if bool then
		for TimerID, TimerObj in pairs(Boss.TimersRef) do
			TimerObj.Enabled = TimerObj.Settings.Enabled
		end
	else
		for TimerID, TimerObj in pairs(Boss.TimersRef) do
			TimerObj.Enabled = false
		end
	end
end

function KBM.SetBossSpies(Boss, bool)
	if bool then
		for MechID, MechObj in pairs(Boss.MechRef) do
			MechObj.Enabled = MechObj.Settings.Enabled
		end
	else
		for MechID, MechObj in pairs(Boss.MechRef) do
			MechObj.Enabled = false
		end
	end
end

function KBM.SetBossAlerts(Boss, bool)
	if bool then
		for AlertID, AlertObj in pairs(Boss.AlertsRef) do
			AlertObj.Enabled = AlertObj.Settings.Enabled
		end
	else
		for AlertID, AlertObj in pairs(Boss.AlertsRef) do
			AlertObj.Enabled = false
		end
	end
end

function KBM.SetBossChat(Boss, bool)
	if bool then
		for ChatID, ChatObj in pairs(Boss.ChatRef) do
			ChatObj.Enabled = ChatObj.Settings.Enabled
		end
	else
		for ChatID, ChatObj in pairs(Boss.ChatRef) do
			ChatObj.Enabled = false
		end
	end
end

KBM.Menu = {}
local Menu = KBM.Menu

function Menu:Open()
	self.Active = true
	self.Window:SetVisible(true)
	KBM.Castbar.Anchor:SetVisible(KBM.Options.Castbar.Global.visible)
	KBM.Castbar.Global.CastObj:SetVisible(KBM.Options.Castbar.Global.visible)
	for ID, Castbar in pairs(KBM.Castbar.Player) do
		if Castbar.Settings.enabled then
			if Castbar.Settings.visible then
				Castbar.CastObj:SetVisible(Castbar.Settings.visible)
				Castbar.CastObj:Unlocked(Castbar.Settings.unlocked)
			end
		end
	end
	KBM.Alert:ApplySettings()
	KBM.MechTimer:ApplySettings()
	KBM.PhaseMonitor:ApplySettings()
	KBM.EncTimer:ApplySettings()
	KBM.MechSpy:ApplySettings()
	KBM.ResMaster.GUI:ApplySettings()
	KBM.PercentageMon.GUI.Cradle:SetVisible(KBM.PercentageMon.Settings.Enabled)
	if KBM.Options.TankSwap.Visible then
		KBM.TankSwap.Anchor:SetVisible(true)
		KBM.TankSwap.Anchor.Drag:SetVisible(KBM.Options.TankSwap.Unlocked)
	end
	if Menu.Current.Encounter then
		Menu.Current.Encounter:SetCastbars()
	end
	if KBM.PlugIn.Count > 0 then
		for ID, PlugIn in pairs(KBM.PlugIn.List) do
			if PlugIn.MenuOpen then
				PlugIn:MenuOpen()
			end
		end
	end
end

function Menu:Close()
	self.Active = false
	self.Window:SetVisible(false)
	if self.Current.Encounter then
		self.Current.Encounter:ClearCastbars()
	end
	if self.Current.Page.CloseLink then
		self.Current.Page:CloseLink()
	end
	KBM.Castbar.Global.CastObj:SetVisible(false)
	KBM.Castbar.Anchor:SetVisible(false)
	for ID, Castbar in pairs(KBM.Castbar.Player) do
		if Castbar.Settings.visible then
			Castbar.CastObj:SetVisible(false)
			Castbar.CastObj:Unlocked(false)
		end
	end
	if KBM.Encounter then
		if KBM.CurrentMod.Settings.Alerts then
			if KBM.CurrentMod.Settings.Alerts.Override then
				KBM.Alert.Settings = KBM.CurrentMod.Settings.Alerts
			else
				KBM.Alert.Settings = KBM.Options.Alerts
			end
		end
		if KBM.CurrentMod.Settings.MechTimer then
			if KBM.CurrentMod.Settings.MechTimer.Override then
				KBM.MechTimer.Settings = KBM.CurrentMod.Settings.MechTimer
			else
				KBM.MechTimer.Settings = KBM.Options.MechTimer
			end
		end
		if KBM.CurrentMod.Settings.PhaseMon then
			if KBM.CurrentMod.Settings.PhaseMon.Override then
				KBM.PhaseMonitor.Settings = KBM.CurrentMod.Settings.PhaseMon
			else
				KBM.PhaseMonitor.Settings = KBM.Options.PhaseMon
			end
		end
		if KBM.CurrentMod.Settings.EncTimer then
			if KBM.CurrentMod.Settings.EncTimer.Override then
				KBM.EncTimer.Settings = KBM.CurrentMod.Settings.EncTimer
			else
				KBM.EncTimer.Settings = KBM.Options.EncTimer
			end
		end
		if KBM.CurrentMod.Settings.CastBar then
			for BossName, BossObj in pairs(KBM.CurrentMod.Bosses) do
				if BossObj.CastBar then
					BossObj.CastBar:Hide()
				end
			end
		end
	end
	KBM.Alert:ApplySettings()
	KBM.MechTimer:ApplySettings()
	KBM.PhaseMonitor:ApplySettings()
	KBM.EncTimer:ApplySettings()
	KBM.MechSpy:ApplySettings()
	KBM.ResMaster.GUI:ApplySettings()
	KBM.TankSwap.Anchor:SetVisible(false)
	KBM.TankSwap.Anchor.Drag:SetVisible(false)
	if not KBM.PercentageMon.Active then
		KBM.PercentageMon.GUI.Cradle:SetVisible(false)
	end
	if KBM.PlugIn.Count > 0 then
		for ID, PlugIn in pairs(KBM.PlugIn.List) do
			if PlugIn.MenuClose then
				PlugIn:MenuClose()
			end
		end
	end
end

function Menu.CloseHandler()
	Menu:Close()
end

function Menu.UpdatePosition(handle, window, relX, relY)
	if window == Menu.Window then
		KBM.Options.Frame.RelX = relX
		KBM.Options.Frame.RelY = relY
	end
end

function Menu:Define(Addon)
	if Addon ~= AddonIni.id then
		return
	end

	self.Default = {
		Width = 820,
		Height = 600,
		TabList = {
			Main = {},
			Rift = {},
			Enc = {},
			Page = {},
		},
		Color = {
			MainHeader = {
				R = 0.88,
				G = 0.68,
				B = 0.25,
			},
			SubHeader = {
				R = 0.95, -- 0.78,
				G = 0.95, -- 0.88,
				B = 0.75, -- 0.45,
			},
		},
		Page = {
			Tabs = {
			},
			Panel = {
				Main = {
				},
				Sub = {
				},
			},
		},
	}
	
	-- Define Main Tabber
	table.insert(self.Default.TabList.Main, {ID = "Main", Name = "KBM", Icon = nil})
	table.insert(self.Default.TabList.Main, {ID = "Plug", Name = KBM.Language.Tabs.Plugins[KBM.Lang], Icon = nil})
	self.Default.TabDim = {}
	self.Default.TabDim.Main = {
		wScale = 0.27,
		hScale = 0.36,
		yOffset = 30,
	}
	
	-- Define Rift Version Tabber
	table.insert(self.Default.TabList.Rift, {ID = "Rift", Name = "Rift", Icon = "Media/RiftLogo.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Rift, {ID = "SL", Name = "Storm Legion", Icon = "Media/StormLegionLogo.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Rift, {ID = "NT", Name = "Nightmare Tide", Icon = "Media/NightmareTideLogo.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Rift, {ID = "PA", Name = "Prophecy of Ahnket", Icon = "Media/rift-ProphecyOfAhnket-logo.png", Location = AddonIni.id})
	
	-- Define Encounter Tabber
	table.insert(self.Default.TabList.Enc, {ID = "Raid", Name = "Raid", Icon = "Media/Raid_Icon.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Enc, {ID = "Sliver", Name = "Sliver", Icon = "Media/Sliver_Icon.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Enc, {ID = "Master", Name = "Master Mode", Icon = "Media/Master_Icon.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Enc, {ID = "Expert", Name = "Expert", Icon = "Media/Expert_Icon.png", Location = AddonIni.id})
	table.insert(self.Default.TabList.Enc, {ID = "Normal", Name = "Normal", Icon = "Media/Group_Icon.png", Location = AddonIni.id})
	
	-- Define Page Tabber
	table.insert(self.Default.TabList.Page, {ID = "Encounter", Name = KBM.Language.Tabs.Encounter[KBM.Lang], Style = "Single"})
	table.insert(self.Default.TabList.Page, {ID = "Timers", Name = KBM.Language.Tabs.Timers[KBM.Lang], Style = "Double"})
	table.insert(self.Default.TabList.Page, {ID = "Alerts", Name = KBM.Language.Tabs.Alerts[KBM.Lang], Style = "Double"})
	table.insert(self.Default.TabList.Page, {ID = "Castbars", Name = KBM.Language.Tabs.Castbars[KBM.Lang], Style = "Single"})
	table.insert(self.Default.TabList.Page, {ID = "Records", Name = KBM.Language.Tabs.Records[KBM.Lang], Style = "Single"})
	table.insert(self.Default.TabList.Page, {ID = "Triggers", Name = KBM.Language.Tabs.Triggers[KBM.Lang], Style = "Trigger"})
	
	-- Build Data Structure
	self.Tab = {}
	-- Define Main Tabber
	self.Tab.Main = {}
	for index, Table in pairs(self.Default.TabList.Main) do
		self.Tab.Main[Table.ID] = {ID = Table.ID, Name = Table.Name, Icon = Table.Icon, Location = Table.Location, Headers = {}}
		self.Tab.Main[Table.ID]._parent = self.Tab.Main
	end
	-- Define Rift and Encounter Tabber
	self.Tab.Rift = {}
	self.Tab.Enc = {}
	for index, Table in pairs(self.Default.TabList.Rift) do
		self.Tab.Rift[Table.ID] = {ID = Table.ID, Name = Table.Name, Icon = Table.Icon, Location = Table.Location, Headers = {}}
		self.Tab.Rift[Table.ID]._parent = self.Tab.Rift
		for index, TabDef in ipairs(self.Default.TabList.Enc) do
			self.Tab.Rift[Table.ID][TabDef.ID] = {ID = TabDef.ID, Name = TabDef.Name, Icon = TabDef.Icon, Location = TabDef.Location, Headers = {}}
			self.Tab.Rift[Table.ID][TabDef.ID]._parent = self.Tab.Rift[Table.ID]
		end
	end
	
	self.Current = {
		TreeView = nil,
		Node = nil,
	}
end

function Menu:Init(Addon)
	if Addon ~= AddonIni.id then
		-- Check to ensure Addon is KBM
		return
	end
	self:Define(Addon)

	self.Context = UI.CreateContext("KBM Menu")
	self.Window = LibSGui.Window:Create(KBM.Language.Options.Title[KBM.Lang], self.Context, {Close = true})
	self.Window:SetWidth(self.Default.Width)
	self.Window:SetHeight(self.Default.Height)
	if KBM.Options.Frame.RelX then
		self.Window:SetPoint("TOPLEFT", UIParent, KBM.Options.Frame.RelX, KBM.Options.Frame.RelY)
	else
		self.Window:SetPoint("TOPLEFT", UIParent, 0.25, 0.2)
	end

	self.Window:SetCallback(self.CloseHandler)
	Command.Event.Attach(Event.SafesGUILib.Window.Moved, self.UpdatePosition, "Menu Position Handler")
	
	-- Create Main TreeView/Tabber combo's
	self.Tab.Main.Tabber, self.Tab.Main.Main.Tab = LibSGui.Tabber:Create(self.Tab.Main.Main.Name, self.Window.Content, {Visible = true})
	self.Tab.Main.Plug.Tab = self.Tab.Main.Tabber:CreateTab(self.Tab.Main.Plug.Name)
	self.Tab.Main.Main.TreeView = LibSGui.TreeView:Create("Main", self.Window.Content, {Visible = true, w = math.ceil(self.Window.Content:GetWidth() * self.Default.TabDim.Main.wScale)})
	self.Tab.Main.Main.TreeView:ClearPoint("TOP")
	self.Tab.Main.Main.TreeView:SetPoint("TOP", self.Window.Content, "TOP", nil, self.Default.TabDim.Main.yOffset)
	self.Tab.Main.Main.TreeView:ClearPoint("BOTTOM")
	self.Tab.Main.Main.TreeView:SetPoint("BOTTOM", self.Window.Content, nil, self.Default.TabDim.Main.hScale)
	self.Tab.Main.Plug.TreeView = LibSGui.TreeView:Create("Plug", self.Window.Content, {Visible = false})
	self.Tab.Main.Plug.TreeView._cradle:SetAllPoints(self.Tab.Main.Main.TreeView._cradle)
	
	-- Define Tab links
	self.Tab.Main.Main.Tab.UserData = {
		_parent = self.Tab.Main.Main,
		_function = self._standardTab,
	}
	self.Tab.Main.Plug.Tab.UserData = {
		_parent = self.Tab.Main.Plug,
		_function = self._standardTab,
	}
	-- Set Current Tab for Main
	self.Tab.Main.Current = self.Tab.Main.Main.TreeView
	
	-- Adjust Tabber Position
	self.Tab.Main.Tabber:SetPoint("BOTTOMLEFT", self.Tab.Main.Main.TreeView._cradle, "TOPLEFT", 6, 4)
	self.Tab.Main.Tabber:SetWidth(self.Tab.Main.Main.TreeView:GetWidth() - 12)
	
	-- Create Encounter TreeViews/Tabber combo's
	self.Tab.Rift.Tabber, self.Tab.Rift.Rift.Tab = LibSGui.Tabber:Create(self.Tab.Rift.Rift.Name, self.Window.Content, {
		Visible = true, 
		Orientation = "BOTTOM", 
		Icon = self.Tab.Rift.Rift.Icon, 
		Location = self.Tab.Rift.Rift.Location,
	})
	self.Tab.Rift.SL.Tab = self.Tab.Rift.Tabber:CreateTab(self.Tab.Rift.SL.Name, self.Tab.Rift.SL.Icon, false, self.Tab.Rift.SL.Location)
	self.Tab.Rift.NT.Tab = self.Tab.Rift.Tabber:CreateTab(self.Tab.Rift.NT.Name, self.Tab.Rift.NT.Icon, false, self.Tab.Rift.NT.Location)
	self.Tab.Rift.PA.Tab = self.Tab.Rift.Tabber:CreateTab(self.Tab.Rift.PA.Name, self.Tab.Rift.PA.Icon, false, self.Tab.Rift.PA.Location)
	self.Tab.Enc.Cradle = LibSGui.Frame:Create(self.Window.Content, true)
	self.Tab.Enc.Cradle:ClearPoint("TOP")
	self.Tab.Enc.Cradle:SetPoint("TOP", self.Window.Content, "BOTTOM", nil, -math.ceil(self.Window.Content:GetHeight() * 0.64) + 28)
	self.Tab.Enc.Cradle:SetPoint("BOTTOM", self.Window.Content, "BOTTOM", nil, -30)
	self.Tab.Enc.Cradle:SetPoint("RIGHT", self.Tab.Main.Main.TreeView._cradle, "RIGHT")
	self.Tab.Enc.Cradle:SetPoint("LEFT", self.Tab.Main.Main.TreeView._cradle, "LEFT")
	self.Tab.Rift.Tabber:SetPoint("TOPLEFT", self.Tab.Enc.Cradle, "BOTTOMLEFT", 6, -4)
	self.Tab.Rift.Tabber:SetWidth(self.Tab.Enc.Cradle:GetWidth() - 12)

	-- Define Tab links
	self.Tab.Rift.Rift.Tab.UserData = {
		_parent = self.Tab.Rift.Rift,
		_function = self._riftTab,
	}
	self.Tab.Rift.SL.Tab.UserData = {
		_parent = self.Tab.Rift.SL,
		_function = self._riftTab,
	}
	self.Tab.Rift.NT.Tab.UserData = {
		_parent = self.Tab.Rift.NT,
		_function = self._riftTab,
	}
  self.Tab.Rift.PA.Tab.UserData = {
		_parent = self.Tab.Rift.PA,
		_function = self._riftTab,
	}
		
	function self:_createEncTab(RiftID)
		local Rift = self.Tab.Rift[RiftID]
		for index, TabDef in ipairs(self.Default.TabList.Enc) do
			local Enc = Rift[TabDef.ID]
			if not Rift.Tabber then
				Rift.Tabber, Enc.Tab = LibSGui.Tabber:Create(TabDef.Name, self.Window.Content, {Visible = false, Icon = TabDef.Icon, Location = TabDef.Location})
				Rift.Current = Enc
			else
				Enc.Tab = Rift.Tabber:CreateTab(TabDef.Name, TabDef.Icon, false, TabDef.Location)
				Enc.Tab:Disable()
			end
			Enc.TreeView = LibSGui.TreeView:Create(TabDef.Name, self.Tab.Enc.Cradle, {Visible = false})
			Enc.Tab.UserData = {
				_parent = Enc,
				_function = self._standardTab,
			}
		end
		Rift.Tabber:SetPoint("BOTTOMLEFT", self.Tab.Enc.Cradle, "TOPLEFT", 6, 4)
		Rift.Tabber:SetWidth(self.Tab.Enc.Cradle:GetWidth() - 12)
		Rift.Tabber.Controller = Rift
		function Rift:Show()	
		end
		function Rift:Hide()
		end
	end
	self:_createEncTab("Rift")
	self:_createEncTab("SL")
	self:_createEncTab("NT")
	self:_createEncTab("PA")
	if not self.Tab.Rift[KBM.Options.MenuExpac] then
		KBM.Options.MenuExpac = "Rift"
	end
	self.Tab.Rift[KBM.Options.MenuExpac].Tabber:SetVisible(true)
	self.Tab.Rift[KBM.Options.MenuExpac].Raid.TreeView:SetVisible(true)
	self.Tab.Rift.Current = self.Tab.Rift[KBM.Options.MenuExpac]
	self.Tab.Rift[KBM.Options.MenuExpac].Tab:Select()

	-- Set Current Tab for Rift type
	self.Tab.Rift.Rift.Current = self.Tab.Rift.Rift.Raid.TreeView
	self.Tab.Rift.SL.Current = self.Tab.Rift.SL.Raid.TreeView
	self.Tab.Rift.NT.Current = self.Tab.Rift.NT.Raid.TreeView
	self.Tab.Rift.PA.Current = self.Tab.Rift.PA.Raid.TreeView
	
	-- Create global panel enclosure.
	self.Panel = LibSGui.Group:Create("Main Panel", self.Window.Content, {Visible = true, Raised = false})
	self.Panel:SetPoint("LEFT", self.Tab.Main.Main.TreeView._cradle, "RIGHT")
	self.Panel:SetPoint("RIGHT", self.Window.Content, "RIGHT", -4, nil)
	self.Panel:SetPoint("BOTTOM", self.Window.Content, "BOTTOM", nil, -2)
	self.Panel:SetBorderWidth(4)
	
	-- Create global header section.
	self.Header = {}
	self.Header.Cradle = LibSGui.Frame:Create(self.Panel.Content, true)
	self.Header.Cradle:SetPoint("TOPLEFT", self.Panel.Content, "TOPLEFT")
	self.Header.Cradle:SetPoint("RIGHT", self.Panel.Content, "RIGHT")
	self.Header.Cradle:SetHeight(60)
	self.Header.MainText = LibSGui.ShadowText:Create(self.Header.Cradle, true)
	self.Header.MainText:SetText("Main Header Text")
	self.Header.MainText:SetPoint("TOPRIGHT", self.Header.Cradle, "TOPRIGHT", -6, 0)
	self.Header.MainText:SetFontSize(18)
	self.Header.MainText:SetFontColor(self.Default.Color.MainHeader.R, self.Default.Color.MainHeader.G, self.Default.Color.MainHeader.B)
	self.Header.SubText = LibSGui.ShadowText:Create(self.Header.Cradle, true)
	self.Header.SubText:SetText("Sub Header Text")
	self.Header.SubText:SetPoint("BOTTOMLEFT", self.Header.Cradle, "BOTTOMLEFT", 4, 0)
	self.Header.SubText:SetFontSize(16)
	self.Header.SubText:SetFontColor(self.Default.Color.SubHeader.R, self.Default.Color.SubHeader.G, self.Default.Color.SubHeader.B)
	self.Header.Split = LibSGui.Texture:Create(self.Panel.Content, true)
	self.Header.Split:SetTexture("Rift", "AreaQuest_Bar.png.dds")
	self.Header.Split:SetPoint("LEFT", self.Header.Cradle, "LEFT")
	self.Header.Split:SetPoint("RIGHT", self.Header.Cradle, "RIGHT")
	self.Header.Split:SetPoint(0, 0.5, self.Header.Cradle, 0, 0.5)
	
	-- Create global page container.
	self.PageUI = {}
	self.PageUI.Panel = LibSGui.Group:Create("Content Panel", self.Panel.Content, {Visible = true, Raised = true})
	self.PageUI.Panel:SetPoint("TOP", self.Header.Cradle, "BOTTOM", nil, 0)
	self.PageUI.Panel:SetBorderWidth(4)
	self.PageUI.Main = LibSGui.Group:Create("Main Content Window", self.PageUI.Panel.Content, {Visible = true})
	self.PageUI.Main.Scrollbar = self.PageUI.Main:AddScrollbar()
	
	self.PageUI.Side = LibSGui.Group:Create("Side Content Window", self.PageUI.Panel.Content, {Visible = false})
	self.PageUI.Side.Scrollbar = self.PageUI.Side:AddScrollbar({Hide = true, Dynamic = true})
	
	local TempTab
	self.PageUI.Tab = {}
	self.PageUI.Tabber, TempTab = LibSGui.Tabber:Create("Encounter", self.Panel.Content, {Visible = true})
	self.PageUI.Tabber:SetPoint("BOTTOMLEFT", self.PageUI.Panel._cradle, "TOPLEFT", 6, 4)
	self.PageUI.Tabber:SetWidth(self.PageUI.Panel:GetWidth() - 12)
	self.PageUI.Tabber.UserData._function = self.Instance._tabEventHandler
	
	self.PageUI.Panel:SetPoint("TOP", self.Header.Cradle, "BOTTOM", nil, self.PageUI.Tabber:GetHeight())
	-- Main Content
	for i, TabRef in pairs(self.Default.TabList.Page) do
		self.PageUI.Tab[TabRef.ID] = {}
		local PageObj = self.PageUI.Tab[TabRef.ID]
		PageObj.Content = LibSGui.Frame:Create(self.PageUI.Main.Content)
		PageObj.Content:SetPoint("TOPLEFT", self.PageUI.Main.Content, "TOPLEFT")
		PageObj.Content:SetHeight(8)
		if i > 1 then
			PageObj.Tab = self.PageUI.Tabber:CreateTab(TabRef.Name, false)
		else
			PageObj.Tab = TempTab
			self.Instance.CurrentTab = PageObj.Content
		end
		PageObj.Tab:Disable()
		PageObj.Tab.UserData = PageObj
		PageObj.ID = TabRef.ID
		
		PageObj.Anchor = LibSGui.Frame:Create(PageObj.Content, true)
		PageObj.Anchor:SetPoint("TOPLEFT", PageObj.Content, "TOPLEFT", 8, 2)
		PageObj.Anchor:SetPoint("RIGHT", self.PageUI.Main.Content, "RIGHT")
		PageObj.Anchor:SetHeight(8)
	end
	-- Side Content
	for i, TabRef in pairs(self.Default.TabList.Page) do
		self.PageUI.Tab[TabRef.ID].Side = {}
		local PageObj = self.PageUI.Tab[TabRef.ID].Side
		PageObj.Content = LibSGui.Frame:Create(self.PageUI.Side.Content)
		PageObj.Content:SetPoint("TOPLEFT", self.PageUI.Side.Content, "TOPLEFT")
		PageObj.Content:SetHeight(8)
		PageObj.Main = self.PageUI.Tab[TabRef.ID]
		PageObj.ID = TabRef.ID
		
		PageObj.Anchor = LibSGui.Frame:Create(PageObj.Content, true)
		PageObj.Anchor:SetPoint("TOPLEFT", PageObj.Content, "TOPLEFT", 6, 2)
		PageObj.Anchor:SetPoint("RIGHT", self.PageUI.Side.Content, "RIGHT")
		PageObj.Anchor:SetHeight(8)			
	end
	self.Instance:BuildTabs()
	
	self.PageUI.Content = LibSGui.Frame:Create(self.PageUI.Main.Content, true)
	self.PageUI.Content:SetPoint("TOPLEFT", self.PageUI.Main.Content, "TOPLEFT")
	self.PageUI.Content:SetHeight(8)
	
	self.PageUI.Anchor = LibSGui.Frame:Create(self.PageUI.Content, true)
	self.PageUI.Anchor:SetPoint("TOPLEFT", self.PageUI.Content, "TOPLEFT", 8, 2)
	self.PageUI.Anchor:SetHeight(8)	
end

function Menu:_riftTab(Tabber, Tab)
	local Root = Tab.UserData._parent._parent
	local Parent = Tab.UserData._parent
	Root.Current.Tabber:SetVisible(false)
	Root.Current.Current:SetVisible(false)
	Root.Current = Parent
	Root.Current.Tabber:SetVisible(true)
	Root.Current.Current:SetVisible(true)
	KBM.Options.MenuExpac = Root.Current.ID
end

function Menu:_standardTab(Tabber, Tab)
	local Root = Tab.UserData._parent._parent
	local Parent = Tab.UserData._parent
	Root.Current:SetVisible(false)
	Root.Current = Parent.TreeView
	Root.Current:SetVisible(true)
end

function Menu._tabHandler(handle, Tabber, Tab)
	if Tabber.UserData._function then
		Tabber.UserData._function(Tabber, Tab)
	else
		if Tab.UserData then
			if Tab.UserData._function then
				Tab.UserData._function(Menu, Tabber, Tab)
			end
		end
	end
end

function Menu._tvNodeHandler(handle, TreeView, Node)
	if Menu.Current.TreeView ~= TreeView then
		Menu.Current.TreeView:ClearSelected()
		Menu.Current.TreeView = TreeView
	end
	Menu.Current.Page:Close()
	Menu.Current.Node = Node
	Menu.Current.Page = Node.UserData._pageObj
	Menu.Current.Page:Open()
end

Command.Event.Attach(Event.Addon.SavedVariables.Load.End, function(handle, Addon) Menu:Init(Addon) end, "Addon Variable Define", -1)
Command.Event.Attach(Event.SafesGUILib.Tabber.Change, Menu._tabHandler, "Tab Change Handler")
Command.Event.Attach(Event.SafesGUILib.TreeView.Node.Change, Menu._tvNodeHandler, "Node Select Changed")