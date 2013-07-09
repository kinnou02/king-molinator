-- Safe's Castbar Library
-- Written By Paul Snart
-- Copyright 2013
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesCastbarLib
-- Dependency: SafesCastbarLib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibSCast = Inspect.Addon.Detail("SafesCastbarLib").data

local AddonIni, LibSCast = ...

local LSUIni = Inspect.Addon.Detail("SafesUnitLib")
local LibSUnit = LSUIni.data

local LSTIni = Inspect.Addon.Detail("SafesTableLib")
local LibSata = LSTIni.data

local _store = {}
local _int = {
	Default = {},
	Packs = {},
	UpdateTime = 0,
}
local _tracking = {}
local _active = {}
local _typeHandlers = {}

function _int.Default:Settings()
	local _set = {
		pinned = false, -- Is the castbar handled via a pin function. Usually castbars linked to other controlling frames.
		visible = false, -- Should the castbar be currently be rendered.
		relX = false, -- Percentage based screen positioning.
		relY = false, --/
		unlocked = false, -- Can be moved via left mouse button hold and drag. Pinned Castbars can never be unlocked.
		alpha = 1.0, -- Global alpha for the entire castbar.
		text = {
			enabled = true,
			alpha = 1.0,
			shadow = true, -- Enable text shadow
			glow = false, -- Enable text glow
			color = {
				font = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
				},
				shadow = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
				},
			},
		},
		texture = {
			background = {
				enabled = true, -- By default the background textures are enabled.
				alpha = 1.0, -- Alpha level 0.00 - 1.00
			},
			foreground = {
				enabled = true, -- By default the foreground textures are enabled.
				alpha = 1.0, -- Alpha level 0.00 - 1.00
			},
			icon = {
				enabled = false, -- Displays a cast icon, and uses "icon" frame.
				alpha = 1.0,
			},
			progbarI = {
				alpha = 1.0,
			},
			progbarN = {
				alpha = 1.0,
			},
			-- Add additional texture settings locally in your addon.
		},
		scale = {
			w = 1.0, -- Width Scale as percentage (1 = 100%)
			h = 1.0, -- Height Scale as percentage (1 = 100%)
			t = 1.0, -- Text Scale as percentage (1 = 100%)
		},
	}
	return _set
end

function _int.Default:SimplePack()
	-- Required Structure for Castbar UI Objects
	-- Includes base methods and settings.
	--
	local _tBar = {
		id = "default", -- Must be unique local to a pack. An must always containt a "default" bar.
		_store = {}, -- For recycling UI elements.
	}
	
	function _tBar:Create()
		-- Creates the UI elements, all custom elements should parent .cradle.
		-- This will only be called by the library if none are available in storage.
		local bar = {
			duration = 1, -- Default cast/channel duration in seconds.
			id = "default",
			ui = {},-- UI Element location.
		}
		function bar:Load()
			-- Used for initializing UI Elements. Either pulling from storage or create a new UI group.
			-- Best used when a CastObj:Start or CastObj:StartType is called to load all castbars in to memory.
			--
		end
		
		function bar:Start()
			-- Prepare the bar for visual display, setting any UI elements appropriately. 
			--
			self.Update = self.CastUpdate -- If you have animations for Interrupt or End events then ensure you set self.Update to the correct handler.
		
		end
		
		function bar:Interrupt()
			-- Change state to start an Interrupt animation, or End animation (if the same), or simply remove the bar UI from display.
			--
			self.Update = self.InterruptAnim -- If you wish to animate interrupt events change self.Update to self.InterruptAnim
			
		end
		
		function bar:End()
			-- Change state to start an End animation, or simply remove the bar UI from display.
			--
			self.Update = self.EndAnim -- If you wish to animate end of cast events change self.Update to self.EndAnim
		
		end
			
		function bar:Recycle()
			-- Used for placing UI elements in local storage.
			-- Best used when a CastObj:Stop is called.
			--
		end

		function bar:CastUpdate(progress, duration)
			-- Updates the castbar progress state, use duration and progress to update texture and text where applicable.
			
		end
		
		function bar:InterruptAnim()
			-- Only required if you're going to animate interruptions in any way. (Such as fading)
		
		end
		
		function bar:EndAnim()
			-- Only required if you're going to animate end of casts in any way. (Such as fading)
		
		end
		bar.Update = bar.CastUpdate -- Set the default update handler.
		
		return bar
	end
	
	LibSCast:TPackAdd("Simple", "Simple", _tBar)
end

function _int.Default:RiftPack()
	-- Create Rift Style Castbar
	-- Default Normal Bar.
	--
	local _tBar = {
		id = "default",
		_store = {},
	}
	
	function _tBar:Create()
		local bar = {
			duration = 1,
			id = "default",
			ui = {},
		}	
		
		function bar:Load()
		end
		
		function bar:Start()
		end
		
		function bar:Interrupt()		
		end
		
		function bar:End()		
		end
			
		function bar:Recycle()			
		end
		
		function bar:CastUpdate(progress, duration)			
		end
		
		function bar:InterruptAnim()		
		end
		
		function bar:EndAnim()	
		end
		bar.Update = bar.CastUpdate -- Set the default update handler.
		
		return bar
	end
	
	LibSCast:TPackAdd("Rift", "Rift", _tBar)
end

function LibSCast:TPackAdd(PackID, Name, defBar)
	local Command = "LibSCast:TPackAdd(string PackID, string Name, table defBar): "
	if type(PackID) ~= "string" then
		error(Command.."Expecting string for PackID, got - "..type(PackID))
	else
		local PackObj = {
			id = PackID, -- Used for reference.
			name = Name, -- Display name for end users. (Building options lists for example)
			bars = {
				default = defBar,
				raid = defBar, -- Usually bosses and some raid trash/adds.
				group = defBar, -- Most other elite units.
				player = defBar, -- Standard player bars (all player units)
				pvp = defBar, -- Standard player bars when they're flagged for PvP.
			}, -- Where the set bars are kept: raid, group, player, pvp, default
			_store = {}, -- Store for Castbar objects which are created and recycled.
		}
		if not _int.Packs[PackObj.id] then
			_int.Packs[PackObj.id] = PackObj
		else
			error(Command.." ID conflict for: "..PackObj.id)
		end
				
		function PackObj:Create()
			-- Creates an instance of a Pack Object or uses one from local storage.
			-- Used when a Cast Object starts via :StartType or :Start
			--
			local PackIn = {
				PackObj = self,
				barObj = {},
				bars = {},
			}
			for id, barObj in pairs(self.bars) do
				if not PackIn.barObj[barObj.id] then
					PackIn.barObj[barObj.id] = barObj:Create()
				end
				PackIn.bars[id] = PackIn.barObj[barObj.id]
			end

			function PackObj:Recycle()
				-- Places created Bar Objects in a store for later use.
				-- This instance is no longer usable.
				--
			end
			
			return PackIn
		end		
	end
end

function _int.Default:CreatePacks()
	self:SimplePack()
	self:RiftPack()
end

function _int:Castbar_Processor(UnitID)
	-- Handles data updates and dispatches render queue.
	local CastPro = {
		Castbars = {},
		UnitID = UnitID,
		Active = false,
		Count = 0,
	}
	
	function CastPro:Add(CastObj)
		-- Adds a cast object for events and/or rendering.
		if not self.Castbars[CastObj] then
			self.Castbars[CastObj] = CastObj
			self.Count = self.Count + 1
		end
	end
	
	function CastPro:Remove(CastObj)
		-- Removes a cast object from events and/or rendering.
		if self.Castbars[CastObj] then
			self.Castbars[CastObj] = nil
			self.Count = self.Count - 1
			if self.Count == 0 then
				_tracking[self.UnitID] = nil
			end
		end
	end
	
	function CastPro:Show()
		-- Triggered when castbars become visible to the player.
		_active[self.UnitID] = self
		self.CurrentTime = Inspect.Time.Frame()
		self.CastData = Inspect.Unit.Castbar(self.UnitID)
		for _, CastObj in pairs(self.Castbars) do
			CastObj:Show(self.CastData)
		end
	end
	
	function CastPro:Hide()
		-- Triggered when castbars are no longer visible to the player.
		_active[self.UnitID] = nil
		for _, CastObj in pairs(self.Castbars) do
			CastObj:Hide()
		end
	end
	
	function CastPro:Queue()
		-- Queue UI cast object for rendering.
		
	end
	
	function CastPro:Update()
		
	end
	
	function CastPro:Visible(bool)
		if bool then
			CastPro:Show()
			self.CastData = Inspect.Unit.Castbar(self.UnitID)
			self.Active = true
		else
			-- Calculate if the cast was interrupted.
			CastPro:Hide()
			self.Active = false
			self.CastData = nil
		end
	end
	_tracking[UnitID] = CastPro
	
	return CastPro
end

function LibSCast:Create(ID, Pack, Settings, Style)
	-- Create a castbar object, this is something which can have settings.
	-- These have no UI until issued a CastObj:Start() or CastObj:StartType(UnitType)
	-- If no Pack is supplied this is a passive Castbar object with no UI.
	-- They can be interchangeable with any unit. Think of them as UI housing objects.
	--
	local CastObj = {
		id = ID,
		Settings = Settings or _int.Default:Settings(),
		Pack = Pack,
		Style = Style or "dynamic",
		Active = false,
		CurrentBar = nil, -- Current UI Object in use.
	}
	if Pack then
		CastObj.Passive = false
		CastObj.Pack = _int.Packs[Pack] or _int.Packs["Simple"]
		CastObj.PackObj = CastObj.Pack:Create()
	else
		CastObj.Passive = true
	end
		
	if not _int.Packs[Pack] then
		error("LibSCast:Create(Pack, Settings) : Unknown Texture Pack '"..tostring(Pack).."'")
	else
		function CastObj:Start(UnitID)
			-- Start a castbar object tracking via UID only.
			if self.Active then
				self:Stop()
			end
			if _tracking[UnitID] then
				self.Engine = _tracking[UnitID]
			else
				self.Engine = _int:Castbar_Processor(UnitID)
			end
			self.Engine:Add(self)
			self.UnitID = UnitID
			self.Active = true
		end
		
		function CastObj:StartType(UnitType)
			-- Start a castbar object tracking via type ie; "player", "player.target" etc...
			self.Type = UnitType
			local currentUID = Inspect.Unit.Lookup(UnitType)
			if currentUID then
				self:Start(currentUID)
			end
			if not _typeHandlers[UnitType] then
				_typeHandlers[UnitType] = Library.LibUnitChange.Register(UnitType)
			end
			function self:Handler(NewID)
				if NewID then
					self:Start(NewID)
				else
					self:Stop()
				end
			end
			Command.Event.Attach(_typeHandlers[UnitType], function(handle, newID) self:Handler(newID) end, "UnitID Change Handler for "..UnitType)
		end
		
		function CastObj:Stop()
			-- Stop tracking, and remove UI and place it in cache for recycling. (Used with CastObj:Start)
			-- Use this for simple removal from the castbar engine.
			self.UnitID = nil
			if self.Engine then
				self.Engine:Remove(self)
			end
			self.Active = false
		end
		
		function CastObj:Remove()
			-- Advanced Feature: Removes the CastObj entirely. (Can be used with either CastObj:Start and CastObj:StartType)
			-- ** Warning: This will remove all access to the object and will no longer be available. Usually best with Passive Cast Objects **
			self:Stop()
		end
		
		function CastObj:Show()
			if self.Style == "dynamic" then
				local cDetails = LibSUnit.Lookup.UID[self.UnitID] -- Caster Unit Details
			else
				
				self.PackObj.bars[self.Style]:Start()
			end
		end
		
		function CastObj:Hide()
		
		end
		
		function CastObj:Interrupt()
		
		end
		
		function CastObj:Pin(_pinFunction)
			-- When started, this castbar will call the _pinFunction to align itself.
			if type(_pinFunction) ~= "function" then
				error(self.id..":Pin(_pinFunction) expecting function got "..type(_pinFunction))
			end
			self.pinFunction = _pinFunction
			if self.Settings.Unlocked then
				-- Hide drag frame.
			end
		end
		
		function CastObj:Unpin()
			-- Returns a castbar to an unpinned state and will use relX,relY combo for positioning (defaults to center, top third of screen)
		
		end
		
		function CastObj:Unlocked(bool)
			self.Settings.Unlocked = bool
			if not bool then
				-- Hide drag frame.
			
			else
				-- Show drag frame.
			
			end
		end
	end
	
	return CastObj
end

function _int.Update_Handler(handle)
	local cTime = Inspect.Time.Real()
	if cTime > _int.UpdateTime then
		for UnitID, CastPro in pairs(_active) do
			CastPro:Update()
		end
		_int.UpdateTime = cTime + 0.09
	end
end

function _int.Castbar_Handler(handle, units)
	for UnitID, Visible in pairs(units) do
		if _tracking[UnitID] then
			_tracking[UnitID]:Visible(Visible)
		end
	end
end

Command.Event.Attach(Event.Unit.Castbar, _int.Castbar_Handler, "Castbar Visibility Handler")
Command.Event.Attach(Event.System.Update.Begin, _int.Update_Handler, "Castbar Update Handler")

_int.Default:CreatePacks()