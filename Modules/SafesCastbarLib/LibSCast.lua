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

local _store = {}
local _int = {
	Default = {},
	Packs = {},
}
local _tracking = {}
local _active = {}

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
	-- You can create your own and supply it to LibSCast:TPackAdd(tPack)
	-- 
	-- Required methods and variables.
	local _tBar = {}
	
	function _tBar:Create()
		-- Creates the UI elements
		-- This will only be called by the library if none are available in storage.
		
	end
	function _tBar:Update(progress, duration)
		-- Updates the castbar progress state, use duration and progress to update texture and text where applicable.
		
	end
	
	return _tBar
end

function _int.Default:RiftPack()
		-- Create Rift Style Castbar
	local _tBar = {
		Duration = 1,
	}
	
	return _tBar
end

function LibSCast:TPackAdd(PackID, Name, defBar)
	local Command = "LibSCast:TPackAdd(string PackID, table defBar): "
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
			Settings = _int.Default:Settings()
		}
		if not _int.Packs[PackID] then
			if type(defBar) == "table" then
				if type(defBar.id) ~= "string" then
					error(Command.."defBar.id : Expecting string got "..type(defBar.id))
				else
					_int.Packs[tPack.id] = tPack
					_store[tPack.id] = {} -- Used for caching UI elements.
				end
			else
				error(Command.."Expecting table got "..type(tPack))
			end
		end
	end
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
			self.Castbars[CastObj] = true
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
	end
	
	function CastPro:Hide()
		-- Triggered when castbars are no longer visible to the player.
	end
	
	function CastPro:Queue()
		-- Queue UI cast object for rendering.
		
	end
	
	function CastPro:Update()
	
	end
	
	function CastPro:Visible(bool)
		if bool then
			CastPro:Show()
			self.CastData = Inspect.Unit.Castbar[self.UnitID]
			self.Active = true
			_active[self.UnitID] = self
		else
			-- Calculate if the cast was interrupted.
			self.Active = false
			self.CastData = nil
			_active[self.UnitID] = nil
		end
	end
	_tracking[UnitID] = CastPro
	
	return CastPro
end

function LibSCast:Create(ID, Pack, Settings, Style)
	-- Create a castbar object, this is something which can have settings.
	-- These have no UI until issued a CastObj:Start() or CastObj:StartType(UnitType)
	-- If no Pack is supplied this is a passive Castbar object with no UI.
	local CastObj = {
		ID = ID,
		Settings = Settings or _int.Default:Settings(),
		Pack = Pack,
		Style = Style,
		Active = false,
	}
	if Pack then
		CastObj.Passive = false
	else
		CastObj.Passive = true
	end
		
	if not _int[Pack] then
		error("LibSCast:Create(Pack, Settings) : Unknown Texture Pack '"..tostring(Pack).."'")
	else
		function CastObj:Start(UnitID)
			-- Start a castbar object tracking via UID only.
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
		function CastObj:Pin(_pinFunction)
			-- When started, this castbar will call the _pinFunction to align itself.
			if type(_pinFunction) ~= "function" then
				error(self.ID..":Pin(_pinFunction) expecting function got "..type(_pinFunction))
			end
			self.pinFunction = _pinFunction
			if self.Settings.Unlocked then
				-- Hide drag frame.
			end
		end
		function CastObj:Unpin()
			-- Returns a castbar to an unpinned state and will use relX,relY combo for positioning (defaults to center, top third of screen)
		
		end
		function CastObj:UnLocked(bool)
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
	for UnitID, CastPro in pairs(_tracking) do
		CastPro:Update()
	end
end

function _int.Castbar_Handler(handle, units)
	for UnitID, Visible in pairs(units) do
		if _tracking[UnitID] then
			
		end
	end
end

Command.Event.Attach(Event.Unit.Castbar, _int.Castbar_Handler, "Castbar Visibility Handler")
Command.Event.Attach(Event.System.Update.Begin, _int.Update_Handler, "Castbar Update Handler")