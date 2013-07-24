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

function _int.Default.Settings()
	local _set = {
		pinned = false, -- Is the castbar handled via a pin function. Usually castbars linked to other controlling frames.
		visible = false, -- Should the castbar be currently be rendered.
		relX = 0.5, -- Percentage based screen positioning. Default is central, top 3rd.
		relY = 0.25, --/
		unlocked = false, -- Can be moved via left mouse button hold and drag. Pinned Castbars can never be unlocked.
		alpha = 1.0, -- Global alpha for the entire castbar.
		name = true, -- Display casters name.
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
LibSCast.Default = {}
LibSCast.Default.BarSettings = _int.Default.Settings

function _int.Default.SimplePack()
	-- Required Structure for Castbar UI Objects
	-- Includes base methods and settings.
	--
	local _tBar = {
		id = "default", -- Must be unique local to a pack. An must always containt a "default" bar.
		_total = 0, -- used for unique Frame Names.
		_store = LibSata:Create(), -- For recycling UI elements.
	}
	
	function _tBar:Create(PackObj)
		-- Creates the UI elements, all custom elements should parent .cradle.
		-- This will only be called by the library if none are available in storage.
		local bar = {
			duration = 1, -- Default cast/channel duration in seconds.
			id = "default",
			ui = nil,-- UI Element location.
			packObj = PackObj, -- The bar which is requesting this ui element. Used for various settings.
			loaded = false,
		}
		--print("Simple Bar Created")
		function bar:Load()
			-- Used for initializing UI Elements. Either pulling from storage or create a new UI group.
			-- Best used when a CastObj:Start or CastObj:StartType is called to load all castbars in to memory.
			--
			--print("Standard Bar Loaded")
			self.ui = self._store:RemoveLast()
			if not self.ui then
				-- Create new UI elements.
				self.ui = {}
				self.ui.crwwadle = UI.CreateFrame("Frame", self.packObj.."_"..self.id.."_"..self._total, self._packObj.Parent)
			end
			self.loaded = true
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
		
		function bar:SetEditMode(bool)
		
		end
		bar.Update = bar.CastUpdate -- Set the default update handler.
		
		return bar
	end	
	
	local barPack = {
		default = _tBar, -- Required when sending bar packs.
	}
	LibSCast:TPackAdd("Simple", "Simple", barPack)
end

function _int.Default:RiftPack()
	-- Create Rift Style Castbar
	-- Default Normal Bar.
	--
	local _tBar = {
		id = "default",
		total = 0,
		store = LibSata:Create(),
	}
	
	function _tBar:Create(PackInstance)
		local bar = {
			duration = 1, -- Default cast/channel duration in seconds.
			id = self.id,
			ui = nil,-- UI Element location.
			store = self.store,
			barObj = self,
			packInstance = PackInstance, -- The bar which is requesting this ui element. Used for various settings.
			packObj = PackInstance.PackObj,
			loaded = false,
		}
		--print("---------")
		--print("Rift "..self.id.." Bar Created: "..PackInstance.CastObj.id)
		function bar:Load()
			if self.loaded then
				return
			end
			self.ui = self.store:RemoveLast()
			--print("Rift "..self.id.." Bar Loaded")
			if not self.ui then
				self.barObj.total = self.barObj.total + 1
				self.ui = {}
				self.ui.cradle = UI.CreateFrame("Frame", self.packObj.id.."_"..self.id.."_"..self.barObj.total, self.packInstance.parent)
				self.ui.cradle:SetVisible(false)
				--print("Rift "..self.id.." Bar Created new")
			else
				--print("Rift "..self.id.." Bar Pulled from Store")
			end
			self.loaded = true
		end
		
		function bar:Begin()
			--print("Rift "..self.id.." Bar cast started: "..self.packInstance.CastObj.Type)
			self.ui.cradle:SetVisible(true)
		end
		
		function bar:Interrupt()
			--print("Rift "..self.id.." Bar cast Interrupt: "..self.packInstance.CastObj.Type)
			self:Stop()
		end
		
		function bar:End()
			--print("Rift "..self.id.." Bar cast end: "..self.packInstance.CastObj.Type)
			self:Stop()
		end
		
		function bar:Stop()
			--print("Rift "..self.id.." Bar stopped: "..self.packInstance.CastObj.Type)
			self.ui.cradle:SetVisible(false)		
		end
			
		function bar:Recycle()
		end
		
		function bar:CastUpdate(progress, duration)			
		end
		
		function bar:InterruptAnim()		
		end
		
		function bar:EndAnim()	
		end

		function bar:SetEditMode(bool)
		end
		bar.Update = bar.CastUpdate -- Set the default update handler.
		
		return bar
	end
	
	local barPack = {
		default = _tBar, -- Required when sending bar packs.
	}	
	LibSCast:TPackAdd("Rift", "Rift", barPack)
end

function LibSCast:TPackAdd(PackID, Name, barPack)
	local Command = "LibSCast:TPackAdd(string PackID, string Name, table defBar): "
	if type(PackID) ~= "string" then
		error(Command.."Expecting string for PackID, got - "..type(PackID))
	else
		local PackObj = {
			id = PackID, -- Used for reference.
			name = Name, -- Display name for end users. (Building options lists for example)
			bars = {
				default = barPack.default,
				raid = barPack.raid or barPack.default, -- Usually bosses and some raid trash/adds.
				group = barPack.group or barPack.default, -- Most other elite units.
				player = barPack.player or barPack.default, -- Standard player bars (all player units), usually the same as default.
				pvp = barPack.pvp or barPack.default, -- Standard player/npc bars when they're flagged for PvP.
			}, -- Where the set bars are kept: raid, group, player, pvp, default
		}
		if not _int.Packs[PackObj.id] then
			_int.Packs[PackObj.id] = PackObj
		else
			error(Command.." ID conflict for: "..PackObj.id)
		end
				
		function PackObj:Create(CastObj)
			-- Creates an instance of a Pack Object or uses one from local storage.
			-- Used when a Cast Object starts via :StartType or :Start
			--
			local PackInstance = {
				id = self.id,
				PackObj = self,
				CastObj = CastObj,
				Type = "LibSCast_PackObj",
				barObj = {},
				bars = {},
				parent = CastObj.Parent, -- Frame/Context to parent to.
			}
			for id, barObj in pairs(self.bars) do
				if not PackInstance.barObj[barObj.id] then
					PackInstance.barObj[barObj.id] = barObj:Create(PackInstance)
				end
				PackInstance.bars[id] = PackInstance.barObj[barObj.id]
			end
			
			function PackInstance:LoadAll()
				for id, bar in pairs(self.barObj) do
					bar:Load()
				end
			end
			
			function PackInstance:Load(id)
				self.bars[id]:Load()
			end

			function PackInstance:Recycle()
				-- Places created Bar Objects in a store for later use.
				-- This instance is no longer usable.
				--
				for id, bar in pairs(self.bars) do
					if bar.loaded then
						bar:Recycle()
					end
				end
			end
			
			return PackInstance
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
		Cast = {},
		UnitID = UnitID,
		UnitObj = LibSUnit:RequestDetails(UnitID),
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
	
	function CastPro:Begin()
		-- Triggered when castbars become visible to the player.
		local CastData = Inspect.Unit.Castbar(self.UnitID)
		self.Cast.Data = CastData
		if CastData then
			if self.Active then
				if self.Cast.Start == CastData.begin then
					return
				else
					self:Visible(false)
				end
			end
			_active[self.UnitID] = self
			self.Cast.Start = CastData.begin
			for _, CastObj in pairs(self.Castbars) do
				if not CastObj.Passive then
					CastObj:Begin(self.Cast)
				end
			end
			self.Active = true
		end
	end
	
	function CastPro:Interrupt()
		-- Triggered when castbars are no longer visible to the player, but are possibly interrupted.
		_active[self.UnitID] = nil
		for _, CastObj in pairs(self.Castbars) do
			if not CastObj.Passive then
				CastObj:Interrupt()
			end
		end
	end
	
	function CastPro:End()
		-- Triggered when castbars are no longer visible to the player.
		_active[self.UnitID] = nil
		for _, CastObj in pairs(self.Castbars) do
			if not CastObj.Passive then
				CastObj:End()
			end
		end
	end
	
	function CastPro:Queue()
		-- Queue UI cast object for rendering.
		
	end
	
	function CastPro:Update()
		local CastData = Inspect.Unit.Castbar(self.UnitID)
		if CastData then
			if CastData.begin == self.Cast.Start then
				self.Cast.Data = CastData
			else
				self:Begin()
			end
		else
			self:Visible(false)
		end
	end
	
	function CastPro:Visible(bool)
		--print("------")
		--print("Cast State Changed: "..tostring(bool))
		if bool then
			CastPro:Begin()
			--print("Cast started for: "..self.UnitObj.Name)
		else
			if self.Active then
				--print("Cast ended for: "..self.UnitObj.Name)
				-- Calculate if the cast was interrupted.
				if self.UnitObj.CurrentKey ~= "Idle" then
					local Time = Inspect.Time.Real()
					local Expected = self.Cast.Start + self.Cast.Data.duration
					local Difference = Time - Expected
					if self.Cast.Data.remaining < 0.05 or self.Cast.Data.expired ~= nil or Difference > 0 then
						CastPro:End()
					else
						CastPro:Interrupt()
					end
					-- print("Time Started: "..tostring(self.Cast.Data.begin))
					-- print("Duration: "..tostring(self.Cast.Data.duration))
					-- print("Expired: "..tostring(self.Cast.Data.expired))
					-- print("Remaining: "..tostring(self.Cast.Data.remaining))
					-- print("Adjusted Difference: "..tostring(Difference))
				else
					CastPro:End()
				end
			end
			self.Active = false
		end
	end
	_tracking[UnitID] = CastPro
	
	return CastPro
end

function LibSCast:Create(ID, Parent, Pack, Settings, Style)
	-- Create a castbar object, this is something which can have settings.
	-- These have no UI until issued a CastObj:Start() or CastObj:StartType(UnitType)
	-- If no Pack is supplied this is a passive Castbar object with no UI.
	-- They can be interchangeable with any unit. Think of them as UI housing objects.
	--
	local CastObj = {
		id = ID,
		Settings = Settings or _int.Default:Settings(),
		Pack = Pack,
		Style = Style or "dynamic", -- Uses a set Bar type from the Pack if supplied, or Unit type if dynamic.
		Parent = Parent, -- Parent Frame to link to.
		Active = false,
		CurrentBar = nil, -- Current UI Object in use.
	}
	if Pack then
		CastObj.Passive = false
		CastObj.Pack = _int.Packs[Pack] or _int.Packs["Simple"]
		CastObj.PackInstance = CastObj.Pack:Create(CastObj)
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
			if not self.Type then
				self.Type = UnitID
			end
			self.UnitID = UnitID
			self.Active = true
			if _tracking[UnitID] then
				self.Engine = _tracking[UnitID]
				self.Engine:Add(self)
				if self.Engine.Active then
					self:Begin()
				end
			else
				self.Engine = _int:Castbar_Processor(UnitID)
				self.Engine:Add(self)
				self.Engine:Begin()
			end	
		end
		
		function CastObj:StartType(UnitType)
			-- Start a castbar object tracking via type ie; "player", "player.target" etc...
			self.Type = UnitType
			self.Static = true
			if self.Style == "dynamic" then
				self.PackInstance:LoadAll()
			else
				self.PackInstance:Load(self.Style)
			end
			local currentUID = Inspect.Unit.Lookup(UnitType)
			if currentUID then
				self:Start(currentUID)
			end
			if not _typeHandlers[UnitType] then
				_typeHandlers[UnitType] = Library.LibUnitChange.Register(UnitType)
			end
			function self.Handler(handle, NewID)
				if NewID then
					self:Start(NewID)
				else
					self:Stop()
				end
			end
			Command.Event.Attach(_typeHandlers[UnitType], self.Handler, "UnitID Change Handler for "..UnitType)
		end
		
		function CastObj:Stop()
			-- Stop tracking, and remove UI and place it in cache for recycling. (Used with CastObj:Start)
			-- Use this for simple removal from the castbar engine.
			if self.CurrentBar then
				self.CurrentBar:Stop()
			end
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
			if self.Static then
				Command.Event.Detach(_typeHandlers[UnitType], self.Handler)
			end
		end
		
		function CastObj:Begin()
			if self.Style == "dynamic" then
				local cDetails = LibSUnit:RequestDetails(self.UnitID) -- Caster Unit Details
				local tier = cDetails.tier or "default"
				if cDetails.pvp then
					tier = "pvp"
				elseif cDetails.player then
					tier = "player"
				end	
				self.CurrentBar = self.PackInstance.bars[tier]
			else			
				self.CurrentBar = self.PackInstance.bars[self.Style]
			end
			self.CurrentBar:Begin()
		end
		
		function CastObj:End()
			self.CurrentBar:End()
			self.CurrentBar = nil
		end
		
		function CastObj:Interrupt()
			self.CurrentBar:Interrupt()
			self.CurrentBar = nil
		end
		
		function CastObj:Pin(_pinFunction)
			-- When started, this castbar will call the _pinFunction to align itself.
			if type(_pinFunction) ~= "function" then
				error(self.id..":Pin(_pinFunction) expecting function got "..type(_pinFunction))
			end
			self.pinFunction = _pinFunction
			self.Settings.Pinned = true
			if self.Settings.Unlocked then
				-- Hide drag frame.
			end
		end
		
		function CastObj:Unpin()
			-- Returns a castbar to an unpinned state and will use relX,relY combo for positioning (defaults to center, top third of screen)
			self.Settings.Pinned = false
			self.pinFunction = nil
			if self.Settings.Unlocked then
				-- Show drag frame.
			end
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
	--local cTime = Inspect.Time.Real()
	--if cTime > _int.UpdateTime then
		for UnitID, CastPro in pairs(_active) do
			CastPro:Update()
		end
		--_int.UpdateTime = cTime + 0.02
	--end
end

function _int.Castbar_Handler(handle, units)
	for UnitID, Visible in pairs(units) do
		if _tracking[UnitID] then
			if Visible then
				_tracking[UnitID]:Visible(Visible)
			end
		end
	end
end

Command.Event.Attach(Event.Unit.Castbar, _int.Castbar_Handler, "Castbar Visibility Handler")
Command.Event.Attach(Event.System.Update.Begin, _int.Update_Handler, "Castbar Update Handler")

_int.Default:CreatePacks()