-- Drop Down Object
-- Written by Paul Snart
-- Copyright 2014
--

local AddonIni, LibSGui = ...
local _int = LibSGui:_internal()
local LibSata = Inspect.Addon.Detail("SafesTableLib").data

local TH = _int.TH
local _defHeight = 24

-- Define Drop Down Events
LibSGui.Event.DropDown = {}
LibSGui.Event.DropDown.Scrollbar = {}
LibSGui.Event.DropDown.Scrollbar.Change = Utility.Event.Create("SafesGUILib", "DropDown.Scrollbar.Change")
LibSGui.Event.DropDown.Scrollbar.Active = Utility.Event.Create("SafesGUILib", "DropDown.Scrollbar.Active")
LibSGui.Event.DropDown.Change = Utility.Event.Create("SafesGUILib", "DropDown.Change")

-- Define Area
LibSGui.DropDown = {}

local ChildStore = LibSata:Create()
local ChildTotal = 0

local ddChild  = {}

function ddChild:Pull(parent, text)
	local ChildObj
	if ChildStore:Count() > 0 then
		ChildObj = ChildStore:RemoveFirst()
		ChildObj.Text:SetParent(parent.list.Content)
	else
		ChildTotal = ChildTotal + 1
		ChildObj = {}
		ChildObj.Text = _int:pullText(parent.list.Content, true)
		ChildObj._id = ChildTotal
	end
	ChildObj.Text:SetLayer(2)
	ChildObj.Text:SetText(text)
	ChildObj.Text:SetFontColor(1,1,1)
	ChildObj.Text:SetAlpha(0.7)
	ChildObj.Parent = parent
	
	function ChildObj.EventLeftClick()
		ChildObj.Parent:Select(ChildObj._index)
		LibSGui.Event.DropDown.Change(ChildObj.Parent, ChildObj._index)
	end
	
	function ChildObj.EventMouseIn()
		ChildObj.Text:SetAlpha(1)
		ChildObj.Parent.list._selector:SetPoint("TOPLEFT", ChildObj.Text, "TOPLEFT", -6, -4)
		ChildObj.Parent.list._selector:SetPoint("BOTTOMRIGHT", ChildObj.Text, "BOTTOMRIGHT", 0, 6)
		ChildObj.Parent.list._selector:SetVisible(true)
		ChildObj.Parent._currentItem = ChildObj._id
	end
	
	function ChildObj.EventMouseOut()
		ChildObj.Text:SetAlpha(0.7)
		if ChildObj.Parent._currentItem == ChildObj._id then
			ChildObj.Parent._currentItem = nil
			ChildObj.Parent.list._selector:SetVisible(false)
		end
	end
	
	ChildObj.Text:EventAttach(Event.UI.Input.Mouse.Left.Click, ChildObj.EventLeftClick, ChildObj._id.."_child_node_click")
	ChildObj.Text:EventAttach(Event.UI.Input.Mouse.Cursor.In, ChildObj.EventMouseIn, ChildObj._id.."_child_node_click")
	ChildObj.Text:EventAttach(Event.UI.Input.Mouse.Cursor.Out, ChildObj.EventMouseOut, ChildObj._id.."_child_node_click")
	return ChildObj
end

function ddChild:Push(Child)
	Child.Text:ClearAll()
	Child.Text:EventDetach(Event.UI.Input.Mouse.Left.Click, Child.EventLeftClick)
	Child.Text:EventDetach(Event.UI.Input.Mouse.Cursor.In, Child.EventMouseIn)
	Child.Text:EventDetach(Event.UI.Input.Mouse.Cursor.Out, Child.EventMouseOut)
	ChildStore:Add(Child)
end

function LibSGui.DropDown:Create(title, _parent, pTable)
	pTable = pTable or {}
	
	local dropDown = _int:buildBase("dropdown", _parent)

	dropDown.Title = title
	dropDown.Data = LibSata:Create()
	dropDown._cradle:SetVisible(pTable.Visible or false)
	dropDown._parent = _parent
	dropDown._children = LibSata:Create()
	dropDown._id = title
	dropDown.dropped = false
	dropDown.UserData = {}
	dropDown.selectedItem = 0
	
	-- Build Text Box
	dropDown.textBox = {}
	dropDown.textBox._leftEdge = _int:pullTexture(dropDown._cradle, true)
	TH.LoadTexture(dropDown.textBox._leftEdge, AddonIni.id, "Media/DD_Button_End.png")
	dropDown.textBox._leftEdge:SetPoint("TOPLEFT", dropDown._cradle, "TOPLEFT")
	dropDown.textBox._leftEdge:SetPoint("BOTTOM", dropDown._cradle, "BOTTOM")
	dropDown.textBox._button = _int:pullTexture(dropDown._cradle, true)
	dropDown.textBox._button:SetPoint("TOPRIGHT", dropDown._cradle, "TOPRIGHT")
	dropDown.textBox._button:SetPoint("BOTTOM", dropDown._cradle, "BOTTOM")
	dropDown.textBox._middle = _int:pullTexture(dropDown._cradle, true)
	TH.LoadTexture(dropDown.textBox._middle, AddonIni.id, "Media/DD_Button_Middle.png")
	dropDown.textBox._middle:SetPoint("TOPLEFT", dropDown.textBox._leftEdge, "TOPRIGHT")
	dropDown.textBox._middle:SetPoint("BOTTOMRIGHT", dropDown.textBox._button, "BOTTOMLEFT")
	dropDown.textBox._text = _int:pullText(dropDown._cradle, true)
	dropDown.textBox._text:SetText("None")
	dropDown.textBox._text:SetPoint("LEFT", dropDown.textBox._middle, "LEFT")
	dropDown.textBox._text:SetPoint("CENTERY", dropDown.textBox._middle, "CENTERY")
	dropDown.textBox._text:SetFontColor(1,1,1)
	dropDown.textBox._text:SetLayer(2)
	dropDown.textBox._text:SetFontColor(0.95, 0.95, 0.75)
		
	-- Build Drop Down
	dropDown.list = {}	
	dropDown.list._cradle = _int:pullFrame(dropDown._cradle, false)
	dropDown.list._cradle:SetHeight(_defHeight)
	dropDown.list._cradle:SetPoint("TOPLEFT", dropDown._cradle, "BOTTOMLEFT")
	dropDown.list._cradle:SetPoint("RIGHT", dropDown._cradle, "RIGHT")
	dropDown.list._border = _int:pullFrameDropDown(dropDown.list._cradle)
	dropDown.list.Content = dropDown.list._border.Content
	
	dropDown.list._selector = _int:pullTexture(dropDown.list.Content, false)
	TH.LoadTexture(dropDown.list._selector, "Rift", "ProgressBar_Glow_Sm.png.dds")
	dropDown.list._selector:SetMouseMasking("limited")
	dropDown.list._selector:SetAlpha(0.65)
	
	function dropDown:EventCursorIn()
		if self.mouseDown then
			TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Down.png")
		else
			TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Over.png")
		end
	end
	
	function dropDown:EventCursorOut()
		if self.mouseDown then
			TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Over.png")
		else
			TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Normal.png")
		end
	end
	
	function dropDown:EventMouseLeftDown()
		self.mouseDown = true
		TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Down.png")
	end
	
	function dropDown:EventMouseLeftUp()
		self.mouseDown = false
		TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Over.png")
		if self.dropped then
			self.dropped = false
			LibSGui:ClearFocus(self)
		else
			self.dropped = true
			LibSGui:SetFocus(self)
		end
		self.list._cradle:SetVisible(self.dropped)
	end
	
	function dropDown:EventMouseLeftUpoutside()
		if self.mouseDown then
			self.mouseDown = false
			TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Normal.png")
		end
	end
	
	--dropDown.list._border.Content:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, dropDown.list.EventUpOutside, dropDown._id.."_left_upoutside_handler")
	function dropDown:attachEvents()
		self._cradle:EventAttach(Event.UI.Input.Mouse.Cursor.In, function () self.EventCursorIn(self) end, self._id.."_mouse_cursor_in")
		self._cradle:EventAttach(Event.UI.Input.Mouse.Cursor.Out, function () self.EventCursorOut(self) end, self._id.."_mouse_cursor_out")
		self._cradle:EventAttach(Event.UI.Input.Mouse.Left.Down, function () self.EventMouseLeftDown(self) end, self._id.."_mouse_left_down")
		self._cradle:EventAttach(Event.UI.Input.Mouse.Left.Up, function () self.EventMouseLeftUp(self) end, self._id.."_mouse_left_up")
		self._cradle:EventAttach(Event.UI.Input.Mouse.Left.Upoutside, function() self.EventMouseLeftUpoutside(self) end, self._id.."_mouse_left_upoutside")
	end
	
	function dropDown:detachEvents()
		self._cradle:EventDetach(Event.UI.Input.Mouse.Cursor.In, nil, self._id.."_mouse_cursor_in")
		self._cradle:EventDetach(Event.UI.Input.Mouse.Cursor.Out, nil, self._id.."_mouse_cursor_out")
		self._cradle:EventDetach(Event.UI.Input.Mouse.Left.Down, nil, self._id.."_mouse_left_down")
		self._cradle:EventDetach(Event.UI.Input.Mouse.Left.Up, nil, self._id.."_mouse_left_up")
		self._cradle:EventDetach(Event.UI.Input.Mouse.Left.Upoutside, nil, self._id.."_mouse_left_upoutside")	
	end
	
	function dropDown:SetEnabled(bool)				
		if bool then
			if self.Enabled == false then
				TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Normal.png")
				self.textBox._text:SetAlpha(1)
				self:attachEvents()
			end
		else
			if self.Enabled == true then
				TH.LoadTexture(dropDown.textBox._button, AddonIni.id, "Media/DD_Button_Disabled.png")
				self.textBox._text:SetAlpha(0.5)
				self:detachEvents()
				self:Close()
			end
		end
		self.Enabled = bool		
	end
		
	function dropDown:Select(item)
		item = tonumber(item) or 0
		if item > 0 then
			if item ~= self.selectedItem then	
				if self.selectedItem > 0 then
					self._children[self.selectedItem].Text:SetFontColor(1, 1, 1)
				end
			end
			self.textBox._text:SetText(self._children[item].Text:GetText())
			self._children[item].Text:SetFontColor(0.95, 0.95, 0.75)
			self.selectedItem = item
			self:Close()
		end
	end
	
	function dropDown:Disable()
		self:SetEnabled(false)
	end
	
	function dropDown:Enable()
		self:SetEnabled(true)
	end
	
	function dropDown:Close()
		if self.dropped then
			self.dropped = false
			self.list._cradle:SetVisible(self.dropped)
			LibSGui:ClearFocus(self)
		end
	end
	
	function dropDown:SetItems(itemList)
		if type(itemList) == "table" then
			local Count = 0
			for _, item in ipairs(itemList) do
				local childObj = ddChild:Pull(self, item)
				Count = Count + 1
				table.insert(self._children, childObj)
				if Count > 1 then
					childObj.Text:SetPoint("TOPLEFT", self._children[Count -1].Text, "BOTTOMLEFT")
				else
					childObj.Text:SetPoint("TOP", self.list.Content, "TOP", nil, 2)
					childObj.Text:SetPoint("LEFT", self.textBox._text, "LEFT")
				end
				childObj.Text:SetPoint("RIGHT", self.list.Content, "RIGHT")
				childObj._index = Count
			end
			self.list._cradle:SetHeight(self._children[1].Text:GetHeight() * Count + 4)
		else
			error(":AddItems expecting table got "..type(itemList))
		end
	end
	
	function dropDown:RemoveAllItems()
		if #self._children > 0 then
			self.list._cradle:SetHeight(_defHeight)
			for _, item in ipairs(self._children) do
				ddChild:Push(item)
			end
			self._children = {}
			self:Close()
		end
	end
	
	dropDown:SetEnabled(false)
	return dropDown
end