-- Window Object
-- Written by Paul Snart
-- Copyright 2012
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

-- Define Window Events
LibSGui.Event.Window = {}
LibSGui.Event.Window.Close = Utility.Event.Create("SafesGUILib", "Event.Window.Close")
LibSGui.Event.Window.Move = Utility.Event.Create("SafesGUILib", "Event.Window.Move")
LibSGui.Event.Window.Moved = Utility.Event.Create("SafesGUILib", "Event.Window.Moved")

-- Define Area
LibSGui.Window = {}

function _int:pullWindow(_parent)
	local window
	local Count = self.base.window:Count()
	if Count == 0 then
		window = UI.CreateFrame("RiftWindow", "LibSGui_Window_"..Count, _parent)
		return window
	else
		--print("Window available in cache of "..Count)
		local windowObj, window = self.base.window:Last()
		self.base.window:Remove(windowObj)
		window:SetParent(_parent)
		--print("New Window count is: "..self.base.window:Count())
		return window
	end
end

function _int:pushWindow(window)
	if window then
		window:ClearAll()
		window:SetParent(self._context)
		window:SetLayer(1)
		self.base.window:Add(window)
		--print("Window added to cache: Total available = "..self.base.window:Count())
	else
		if _int._debug then
			error("No window supplied in: _int:pushWindow(window)")
		end
	end
end

function LibSGui.Window:Create(title, _parent, pTable)
	pTable = pTable or {}
	
	local window = _int:buildBase("window", _parent)
	
	window.Title = title
	
	function window:_adjustHandle()
		window.Handle:SetWidth(window.Border:GetWidth())
		window.Handle:SetHeight(window.Content:GetTop() - window.Border:GetTop())
	end
	
	window._cradle:SetVisible(pTable.Visible or false)
	if pTable.Width then
		window._cradle:SetWidth(pTable.Width)
	end
	if pTable.Height then
		window._cradle:SetHeight(pTable.Height)
	end
	window.win = _int:pullWindow(window._cradle, true)
	window.win:SetTitle(title)
	window.win:SetPoint("TOPLEFT", window._cradle, "TOPLEFT")
	window.win:SetPoint("BOTTOMRIGHT", window._cradle, "BOTTOMRIGHT")
	window.Content = window.win:GetContent()
	window.Border = window.win:GetBorder()
	window.Handle = _int:pullFrame(window.Border, true)
	window.Handle:SetPoint("TOPLEFT", window._cradle, "TOPLEFT")
	window:_adjustHandle()
	window.Handle:SetVisible(true)
	window.Handle.Window = window
	window.Canvas = _int:pullFrame(window.Content, true)
	window.Canvas:SetPoint("TOPLEFT", window.Content, "TOPLEFT", 2, 0)
	window.Canvas:SetPoint("BOTTOMRIGHT", window.Content, "BOTTOMRIGHT", -2, -2)
	
	if pTable.Close then
		window.close = _int:pullButton(window.Handle)
		window.close:SetSkin("close")
		window.close:SetPoint("BOTTOMRIGHT", window.Handle, "BOTTOMRIGHT", -8, -5.5)
		window.close:SetText("Close")
		window.close.Window = window
		
		function window.close:LeftClickHandler()
			if self.Window._active then
				LibSGui.Event.Window.Close(self.Window)
				if self.Window._callback then
					self.Window._callback(self.Window)
				end
			end
		end
		window.close:EventAttach(Event.UI.Input.Mouse.Left.Click, window.close.LeftClickHandler, "Window Close Click")
		
	end
	
	function window.Handle:MouseMoveHandler(handle, x, y)
		if self.Window._active then
			if self.Window._drag then
				self.Window.x = x - self.Window.offsetX or 0
				self.Window.y = y - self.Window.offsetY or 0
				self.Window.relx = self.Window.x / _int.env.w
				self.Window.rely = self.Window.y / _int.env.h
				if self.Window.x ~= self.Window._cradle:GetLeft() or self.Window.y ~= self.Window._cradle:GetTop() then
					LibSGui.Event.Window.Move(self.Window, self.Window.relx, self.Window.rely)
				end
				self.Window._cradle:SetPoint("TOPLEFT", UIParent, self.Window.relx, self.Window.rely)
			end
		end
	end
	
	function window.Handle:LeftDownHandler()
		if self.Window._active then
			if not self.Window._drag then
				local mouse = Inspect.Mouse()
				local holdx = self.Window._cradle:GetLeft()
				local holdy = self.Window._cradle:GetTop()
				self.Window.offsetX = mouse.x - holdx
				self.Window.offsetY = mouse.y - holdy
				self.Window._drag = true
				window.Handle:EventAttach(Event.UI.Input.Mouse.Cursor.Move, window.Handle.MouseMoveHandler, "Window Handle Move")
			end
		end
	end
	window.Handle:EventAttach(Event.UI.Input.Mouse.Left.Down, window.Handle.LeftDownHandler, "Window Handle Left Down")
		
	function window.Handle:LeftUpHandler()
		if self.Window._active then
			if self.Window._drag then
				window.Handle:EventDetach(Event.UI.Input.Mouse.Cursor.Move, window.Handle.MouseMoveHandler, "Window Handle Move")
				self.Window._drag = false
				LibSGui.Event.Window.Moved(self.Window, self.Window.relx, self.Window.rely)
			end
		end
	end
	window.Handle:EventAttach(Event.UI.Input.Mouse.Left.Up, window.Handle.LeftUpHandler, "Window Handle Left Up")
		
	function window:SetWidth(_width)
		window._cradle:SetWidth(_width)
		self:_adjustHandle()
	end
	
	function window:SetHeight(_height)
		window._cradle:SetHeight(_height)
		self:_adjustHandle()
	end
	
	function window:GetWidth()
		return window._cradle:GetWidth()
	end
	
	function window:GetHeight()
		return window._cradle:GetHeight()
	end
	
	function window:GetHandle()
		return self.Handle
	end
	
	function window:GetRiftWindow()
		return self.win
	end
	
	function window:GetX()
		return self.x
	end
	
	function window:GetY()
		return self.y
	end
	
	function window:GetRelativeX()
		return self.relx
	end
	
	function window:GetRelativeY()
		return self.rely
	end
	
	function window:SetCallback(cbFunction)
		if type(cbFunction) == "function" then
			self._callback = cbFunction
		else
			if _int._debug then
				error("[Setting Callback] Expecting function, got: "..type(cbFunction))
			end
		end
	end
	
	function window:Remove()
		window.Handle:EventDetach(Event.UI.Input.Mouse.Left.Down, window.Handle.LeftDownHandler, "Window Handle Left Down")
		window.Handle:EventDetach(Event.UI.Input.Mouse.Left.Up, window.Handle.LeftUpHandler, "Window Handle Left Up")
		window.Close:EventDetach(Event.UI.Input.Mouse.Left.Click, window.close.LeftClickHandler, "Window Close Click")
		window._active = false
		self._callbacks = nil
		self.User = nil
		if self.close then
			_int:pushButton(self.close)
		end
		_int:pushFrame(self.Handle)
		_int:pushWindow(self.win)
		_int:pushFrame(self._cradle)
	end
	window._active = true
	return window, window.Canvas
end
