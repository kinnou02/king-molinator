-- Turns the existing Event.Unit.Remove event into something a little more addon-developer friendly.
-- The Event.Unit.Add/Remove events are designed for power. Using them, you can, quite literally, track the entire potentially-infinite tree of .target chaining.
-- Most of the time, you don't want to. This library provides a simpler abstraction for events.

-- Usage: Create an event with Library.LibUnitChange.Register("player.target"). The Register function returns the event table, or you can find it in the event hierarchy under Event.LibUnitChange.player.target.Change. Add an event to this table and it will be called when the unit specifier changes, with a single parameter consisting of the new unit ID ("false" meaning "no unit".)

-- The documentation is a bit sparse.

if not Library then Library = {} end
if not Library.LibUnitChange then Library.LibUnitChange = {} end

local spec = {}
local id = {[false] = {}}
local current = {}
local registered = {}
local lookups = {}

local function process(handle, changes)
  -- figure out what's different
  local refreshes = {}
  for change in pairs(changes) do
    if id[change] then
      for element in pairs(id[change]) do
        refreshes[element] = true
        
        -- Add chains as well
        if spec[element] then
          for chain in pairs(spec[element]) do
            refreshes[chain] = true
          end
        end
      end
      
      id[change] = nil
    end
  end
  
  -- From here, we need to take every change and link it up to the new things it points to
  local newresults = Inspect.Unit.Lookup(refreshes)
  
  for unitspec in pairs(refreshes) do
    local unitid = newresults[unitspec] or false
    if not id[unitid] then
      id[unitid] = {}
    end
    id[unitid][unitspec] = true
    
    if current[unitspec] ~= unitid then
      registered[unitspec](unitid)
      current[unitspec] = unitid
    end
  end
end

local function registerWorker(identifier)
  if registered[identifier] then
    return
  end
  
  id[false][identifier] = true
  current[identifier] = false
        
  local acum = nil
  for subset in identifier:gmatch("[^.]+") do
    if acum then
      acum = acum .. "." .. subset
    else
      acum = subset
    end
    
    if not spec[acum] then
      spec[acum] = {}
    end
    spec[acum][identifier] = true
  end
    
  registered[identifier], lookups[identifier] = Utility.Event.Create("LibUnitChange", identifier .. ".Change")
end

function Library.LibUnitChange.Register(identifier)
  if registered[identifier] then
    return lookups[identifier]
  end
  
  if not id[false] then id[false] = {} end
  
  -- need to register every item that leads up to this also
  local acum = nil
  for subset in identifier:gmatch("[^.]+") do
    if acum then
      acum = acum .. "." .. subset
    else
      acum = subset
    end
    
    registerWorker(acum)
  end
  
  process({}, {[false] = false}) -- It's a fake message, but it's one that will get us to poll *everything*, which is exactly what we need right now.
  
  return lookups[identifier]
end

Command.Event.Attach(Event.Unit.Remove, process, "Update")
