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
		if type(object) == "table" then
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
				return object._data
			else
				-- print("Warning: Supplied Table Object is not of type LibSata_Object")
			end
		else
			-- no valid timer object supplied
			error("Incorrect use of Table:Remove(): Expecting table [Lua:table] object got "..type(object))
		end
	end
	
	function lst:Clear()
		self._first = nil
		self._last = nil
		self._count = 0
		self._list = {}	
	end
	
	function lst:RemoveLast()
		if self._last then
			return self:Remove(self._last)
		end
	end
	
	function lst:RemoveFirst()
		if self._first then
			return self:Remove(self._first)
		end
	end
	
	function lst:After(object)
		if object == self._last or self._count < 2 then
			return
		end
		return object._after
	end
	
	function lst:Before(object)
		if object == self._first or self._count < 2 then
			return
		end
		return object._before
	end
	
	function lst:First()
		if self._first then
			return self._first, self._first._data
		end
	end
	
	function lst:Last()
		if self._last then
			return self._last, self._last._data
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
		
	_store[lst] = true
	return lst
end

function LibSata.EachIn(TableObj)
	-- Traverse a table from start to finish, supplying each entries data object to the callback
	-- Must receive at least a callback function to supply the object to.
	-- Optionally you can supply a start Table Object and the EachIn will start from that point (if it exists).
	-- print("[Constructor] Each in called")
	if type(TableObj) == "table" then
		if TableObj._type == "LibSata_Table" then
			if TableObj._count == 0 then
				return function() end, nil, nil
			end
			-- print("[Constructor] Returning new itterator, passing to internal handler")
			local function _iEachIn(_, currentObj)
				-- print("[Internal Handler] Each in called")
				if currentObj._after then
					-- print("[Internal Handler] Returning new itterator.")
					return currentObj._after, currentObj._after._data
				else
					-- print("[Internal Handler] No more objects in table, exit.")
					return
				end
			end
			return _iEachIn, _, {_after = TableObj._first}
		else
			-- print("[Constructor] TableObj is not of type LibSata_Object: ")
			-- for name, data in pairs(TableObj) do
				-- print(tostring(name).." > "..tostring(data))
			-- end
			return function() end, nil, nil
		end
	else
		-- print("[Constructor] No table object supplied, exit: "..type(TableObj))
		return function() end, nil, nil
	end
end

function LibSata.DebugTable(TableObj)
	for TableObj, TableData in LibSata.EachIn(TableObj) do
		print(tostring(TableObj))
		print(tostring(TableData))
		if type(TableData) == "table" then
			for k, v in pairs(TableData) do
				print(tostring(k)..": "..tostring(v))
			end
		end
	end
end