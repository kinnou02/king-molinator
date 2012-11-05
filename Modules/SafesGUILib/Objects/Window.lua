-- Window Object
-- Written by Paul Snart
-- Copyright 2012
--

local AddonDetails, LibSGui = ...
local _int = LibSGui:_internal()

function LibSGui:CreateWindow(title, _parent, pTable)
	pTable = pTable or {}
	
	local window = _int:buildBase("window", _parent)
	
	window.Title = title
	
	function window:_adjustHandle()
		window.Handle:SetWidth(window.Border:GetWidth())
		window.Handle:SetHeight(window.Content:GetTop() - window.Border:GetTop())
	end
	
	window._cradle:SetVisible(pTable.Visible or false)
	window.win = _int:pullWindow(window._cradle)
	window.win:SetTitle(title)
	window.win:SetPoint("TOPLEFT", window._cradle, "TOPLEFT")
	window.win:SetPoint("BOTTOMRIGHT", window._cradle, "BOTTOMRIGHT")
	window.Content = window.win:GetContent()
	window.Border = window.win:GetBorder()
	window.Handle = _int:pullFrame(window.Border)
	window.Handle:SetPoint("TOPLEFT", window._cradle, "TOPLEFT")
	window:_adjustHandle()
	window.Handle:SetVisible(true)
	window.Handle.Window = window
	
	if pTable.Close then
		window.close = _int:pullButton(window.Handle)
		window.close:SetSkin("close")
		window.close:SetPoint("BOTTOMRIGHT", window.Handle, "BOTTOMRIGHT", -8, -5.5)
		window.close:SetText("Close")
		window.close.Window = window
		
		function window.close.Event:LeftClick()
			if self.Window._active then
				if self.Window._callbacks.Close then
					self.Window._callbacks.Close(self.Window)
				end
			end
		end
		
	end
	
	function window.Handle.Event:LeftDown()
		if self.Window._active then
			local mouse = Inspect.Mouse()
			local holdx = self.Window._cradle:GetLeft()
			local holdy = self.Window._cradle:GetTop()
			self.Window.offsetX = mouse.x - holdx
			self.Window.offsetY = mouse.y - holdy
			self.Window._drag = true
		end
	end
	
	function window.Handle.Event:MouseMove(x, y)
		if self.Window._active then
			if self.Window._drag then
				self.Window.x = x - self.Window.offsetX or 0
				self.Window.y = y - self.Window.offsetY or 0
				self.Window.relx = self.Window.x / _int.env.w
				self.Window.rely = self.Window.y / _int.env.h
				self.Window._cradle:SetPoint("TOPLEFT", UIParent, self.Window.relx, self.Window.rely)
			end
		end
	end
	
	function window.Handle.Event:LeftUp()
		if self.Window._active then
			if self.Window._drag then
				self.Window._drag = false
				if self.Window._callbacks.MoveEnd then
					self.Window._callbacks.MoveEnd(self.Window)
				end
			end
		end
	end
	
	function window:SetCloseCallback(_function)
		if not self.close then
			error("This window does not have a Close button")
		else
			if type(_function) ~= "function" then
				error("Function expected, got "..type(_function))
			else
				self._callbacks.Close = _function
			end
		end
	end
	
	function window:SetWidth(_width)
		window._cradle:SetWidth(_width)
		self:_adjustHandle()
	end
	
	function window:SetHeight(_height)
		window._cradle:SetHeight(_height)
		self:_adjustHandle()
	end
	
	function window:Remove()
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
	return window
end
