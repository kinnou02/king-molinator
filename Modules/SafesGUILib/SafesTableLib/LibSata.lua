-- Safe's Table Library
-- Written By Paul Snart
-- Copyright 2012
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesTableLib
-- Dependency: SafesTableLib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibSata = Inspect.Addon.Detail("SafesTableLib").data

local AddonIni, LibSata = ...

local _store = {}

function LibSata:Create()
	-- Creates a base Table Object and returns it
	local lst = {
		_type = "LibSata_Table",
		_first = nil,
		_last = nil,
		_count = 0,
		_list = {},
	}
	
	function lst:_createObject(value)
		-- Creates a new Object in a base table
		local newObj = {
			_type = "LibSata_Object",
			_after = nil,
			_before = nil,
			_data = value,
		}
		
		function newObj:GetData()
			-- Returns the ._data field (Supplied value), this can obviously be accessed with tableObject._data
			return self._data
		end
		
		-- Place this Table Object in a static list to allow for Weak Table/Temporary access from Addons.
		-- This is not the same as true Weak Tables in Lua, but more so the actual Table Object does not itself get collected by the GC.
		-- Use self:Remove(object) to allow this Table Object to be collected by the GC, and ensure no other outside references linger.
		self._list[newObj] = true
		-- Now increment the internal counter for quick count access.
		self._count = self._count + 1
		return newObj
	end
	
	function lst:Add(value)
		-- Adds a new Table Object to the end of the Table Data.
		local newObj = self:_createObject(value)
		if self._count == 1 then
			self._first = newObj
		else
			newObj._before = self._last
			newObj._before._after = newObj
		end
		self._last = newObj
		
		return newObj
	end
	
	function lst:InsertFirst(value)
		-- Inserts a new Table Object at the beginning of the Table List.
		-- This is a convenience wrapper, and can be achieved multiple ways.
		if self._first then
			return self:InsertBefore(self._first, value)
		else
			return self:Add(value)
		end
	end
	
	function lst:InsertBefore(object, value)
		-- Inserts a new Table Object before the supplied Table Object.
		if object._type == "LibSata_Object" then
			local newObj = self:_createObject(value)
			if object == self._first then
				self._first = newObj
			end
			newObj._before = object._before
			if newObj._before then
				newObj._before._after = newObj
			end
			newObj._after = object
			object._before = newObj
			return newObj
		end
		-- print("Warning: Supplied Table Object is not of type LibSata_Object")
	end
	
	function lst:InsertAfter(object, value)
		-- Inserts a new Table Object after the supplied Table Object.
		if object._type == "LibSata_Object" then
			local newObj = self:_createObject(value)
			if object == self._last then
				self._last = newObj
			end
			newObj._after = object._after
			if newObj._after then
				newObj._after._before = newObj
			end
			newObj._before = object
			object._after = newObj
			return newObj
		end
		-- print("Warning: Supplied Table Object is not of type LibSata_Object")
	end
	
	function lst:Remove(object)
		-- Safely remove the object from the Table and link appropriate Table Objects together
		if object._type == "LibSata_Object" then
			if object == self._last then
				self._last = object._before
			end
			if object == self._first then
				self._first = object._after
			end
			if object._before then
				if object._after then
					object._before._after = object._after
					object._after._before = object._before
				else
					object._before._after = nil
				end
			else
				if object._after then
					object._after._before = nil
				end
			end
			-- Allows this Table Object to now be collected via the GC.
			-- As noted with adding/inserting Table Objects. Outside refernces will need to be cleared if used.
			self._list[object] = nil
			-- Decrement the internal counter.
			self._count = self._count - 1
		else
			-- print("Warning: Supplied Table Object is not of type LibSata_Object")
		end
	end
	
	function lst:After(object)
		if object == self._last or self._count < 2 then
			return
		end
		return object._after, object._after._data
	end
	
	function lst:Before(object)
		if object == self._first or self._count < 2 then
			return
		end
		return object._before, object._after._data
	end
	
	function lst:First()
		if self._first then
			return self._first, self._first._data
		else
			return self._first
		end
	end
	
	function lst:Last()
		if self._last then
			return self._last, self._last._data
		else
			return self._last
		end
	end
	
	function lst:Count()
		return self._count
	end
	
	function lst:Delete()
		-- Remove from holding list (To allow GC, if you have locale/global active references you'll need to clear those too)
		_store[self] = nil
		-- Remove actual table reference as a fail-safe.
		self._list = nil
		-- Please note: If you reference any Base Table or Table Object outside of this system. They will not be collected by the GC,
		-- and could cause memory leaks. Data held in the _data field of a Table Object can be static and are not related to these tables.
	end
	
	function lst:EachIn(callback, startObject)
		-- Traverse a table from start to finish, supplying each entries data object to the callback
		-- Must receive at least a callback function to supply the object to.
		-- Optionally you can supply a start Table Object and the EachIn will start from that point (if it exists).
		if self._count == 0 then
			return
		end
		if type(callback) == "function" then
			if type(startObject) == "table" then
				if startObject._type ~= "LibSata_Object" then
					-- print("Warning: Supplied startObject is not of type LibSata_Object")
					startObject = nil
				end
			else
				startObject = nil
			end
			local currentObj = startObject or self._first
			if currentObj then
				local breakLoop
				repeat
					local nextObj = currentObj._after
					breakLoop = callback(currentObj._data, currentObj)
					if breakLoop then
						break
					end
					currentObj = nextObj
				until not currentObj
			end
		else
			error("Expecting Callback function: Got type "..type(callback))
		end
	end
	
	_store[lst] = true
	return lst
end

-- Create a Base Table
-- local TestTable = LibSata:Create()

-- Insert items in reverse order (Yes, I know could just count backwards, but would defeat the example)
-- for i = 1, 20 do
	-- TestTable:InsertFirst("Entry "..i)
-- end

-- Print the Table items to the console
-- TestTable:EachIn(function(data) print(data) end)

-- Remove the table reference: The method returns nil, so this serves to both set the local reference to nil and clear internal references.
-- Doing this allows for the GC to free the memory associated with the table.
-- TestTable = TestTable:Delete()