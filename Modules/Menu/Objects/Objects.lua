-- KBM Menu System: Objects
-- Written by Paul Snart
-- Copyright 2013
--
local AddonIni, KBM = ...
local LibSata = Inspect.Addon.Detail("SafesTableLib").data
local LibSGui = Inspect.Addon.Detail("SafesGUILib").data

local Menu = KBM.Menu
local RenderQueue = LibSata:Create()
local MaxTime = 0.02

Menu.UI = {
	Store = {
		Check = LibSata:Create(),
		Group = LibSata:Create(),
		Header = LibSata:Create(),
		PlainHeader = LibSata:Create(),
		Color = LibSata:Create(),
		DropDown = LibSata:Create(),
	},
}
Menu.Object = {}
Menu.Renderer = nil
Menu.Queue = {}

Menu.DumpParent = UI.CreateFrame("Frame", "UI DumpFrame", KBM.Context)

function Menu.UI.SetDefaults(Object, Name, Settings, ID, Callback, Page)
	Object.UI = {}
	Object.Object = LibSata:Create()
	Object.Callback = Callback
	Object.Settings = Settings
	Object.ID = ID
	Object.Page = Page
	Object.Rendered = LibSata:Create()
	Object.Name = tostring(Name)
	Object._root = Page._root
	Object.ChildState = true
	Object.Enabled = true
	Page.Object:Add(Object)
	
	function Object:CreateCheck(Name, Settings, ID, Callback)
		return Menu.Object:CreateCheck(Name, Settings, ID, Callback, self)
	end
	function Object:CreateHeader(Name, Settings, ID, Callback)
		return Menu.Object:CreateHeader(Name, Settings, ID, Callback, self)
	end
	function Object:CreateGroup(Name, Settings, ID, Callback)
		return Menu.Object:CreateGroup(Name, Settings, ID, Callback, self)
	end
	function Object:CreateColorPicker(Name, Settings, ID, Callback)
		return Menu.Object:CreateColorPicker(Name, Settings, ID, Callback, self)
	end
	function Object:CreatePlainHeader(Name, Settings, ID, Callback)
		return Menu.Object:CreatePlainHeader(Name, Settings, ID, Callback, self)
	end
	function Object:CreateDropDown(Name, Settings, ID, Callback)
		return Menu.Object:CreateDropDown(Name, Settings, ID, Callback, self)
	end
	function Object:Queue()
		RenderQueue:Add(self)
		for _, SubObject in LibSata.EachIn(self.Object) do
			SubObject:Queue()
		end
	end
	
	function Object:Clear()
		for _, SubObject in LibSata.EachIn(self.Object) do
			SubObject:Clear()
		end
		self.Object = self.Object:Delete()
		self.Rendered = self.Rendered:Delete()
		for ID, Table in pairs(self) do
			self[ID] = nil
		end
	end

	function Object:DisableChildren(Children)
		if Children then
			self.ChildState = false
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					Object:Disable()
				end
			end
		else
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					Object:Disable()
				end
			end			
		end
	end
	
	function Object:Disable(Children)
		if not Children then
			self.Enabled = false
			self.UI.Check:SetEnabled(false)
			self.UI.Cradle:SetAlpha(0.5)
		end
		if Children ~= false then
			self:DisableChildren(Children)
		end
	end
	
	function Object:EnableChildren(Children)
		if Children then
			self.ChildState = true
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					Object:Enable()
				end
			end				
		else
			for tObj, Object in LibSata.EachIn(self.Object) do
				if Object.Active then
					if self.ChildState then
						Object:Enable()
					else
						Object:Disable()
					end
				end
			end
		end
	end
			
	function Object:Enable(Children)
		if not Children then
			self.Enabled = true
			self.UI.Check:SetEnabled(true)
			self.UI.Cradle:SetAlpha(1)
		end
		if Children ~= false then
			self:EnableChildren(Children)
		end
	end
	
	function Object:AddHeight()
		self.Height = self.UI.Cradle:GetHeight()
		self._root.Height = self._root.Height + self.Height
	end
	
	if Page._root.Type == "Encounter" then
		RenderQueue:Add(Object)
	end	
end

function Menu.Object:CreateSpacer()
	
end

function Menu.Queue.PageEnd(Page)
	local Marker = {
		Type = "End",
		Page = Page,
	}
	RenderQueue:Add(Marker)
end

function Menu.RenderHalt()
	RenderQueue:Clear()
end

function Menu.RenderUpdate()
	local endTime = Inspect.Time.Real() + MaxTime
	--local x = 0
	repeat 
		QueueObj = RenderQueue:RemoveFirst() 
		if QueueObj then
			if QueueObj.Type == "End" then
				QueueObj.Page:Displayed()
			else
				QueueObj:Render()
				if Inspect.Time.Real() >= endTime then
					-- x = x + 1
					--print("CC: Yield: "..x)
					coroutine.yield()
					endTime = Inspect.Time.Real() + MaxTime
				end
			end
		end
	until not QueueObj
	--print("CC: Rendering Complete")
end

function Menu.UI.UpdateHandler()
	-- if RenderQueue._count > 0 then
		-- Menu.RenderUpdate()
	-- end
	
	if Menu.Renderer then
		if coroutine.status(Menu.Renderer) == "dead" then
			Menu.Renderer = nil
			--print("Rendering Complete")		
		else
			--if Inspect.Time.Real() > Menu.NextCall then
				assert(coroutine.resume(Menu.Renderer))
				--Menu.NextCall = Inspect.Time.Real() + 1
			--end
		end
	else
		if RenderQueue._count > 0 then
			--print("Starting Renderer")
			Menu.Renderer = coroutine.create(Menu.RenderUpdate)
			assert(coroutine.resume(Menu.Renderer))
			--Menu.NextCall = Inspect.Time.Real() + 1 
		end
	end
end

Command.Event.Attach(Event.System.Update.Begin, Menu.UI.UpdateHandler, "Render Handler")