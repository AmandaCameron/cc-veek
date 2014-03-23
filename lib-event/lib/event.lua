-- Converted from a private library written by Hako
-- and myself(Amanda)

local Object = {}

-- Object Essensials

function Object:init()
  self.object:init() -- Pass up for funsies.

  self.events = {}
  self.eid = 0
end

-----------------------------------------------------------
-- Helpers.
-----------------------------------------------------------

function Object:_must_event(evt_name)
  if not self.events[evt_name] then
    self.events[evt_name] = {}
  end
end

function Object:_trigger_raw(evt_name, ...)  
  if not self.events[evt_name] then
    return
  end

  local evts = {}

  for eid, cb in pairs(self.events[evt_name]) do
    evts[eid] = cb
  end

  for eid, cb in pairs(evts) do
    local ok, err = pcall(cb, ...)

    if not ok then
      printError(err)

      self:unsubscribe(evt_name, eid)
    end
  end
end

-----------------------------------------------------------
-- Subscription handling.
-----------------------------------------------------------

-- Subscribes to an event, returns the unique ID for
-- passing to unsubscribe()
-----------------------------------------------------------
-- Arguments: evt_name, callback
--    evt_name: The event to subscribe to.
--    callback: The function to call on the event.
function Object:subscribe(evt_name, callback)
  self:_must_event(evt_name)

  -- table.insert(events[evt_name], callback)
  self.eid = self.eid + 1

  self.events[evt_name][self.eid] = callback

  return self.eid
end

-- Subscribes to an event once, when it fires
-- it disconnects itself
-----------------------------------------------------------
-- Arguments: evt_name, callback
--    evt_name: The event to subscribe to.
--    callback: The function to call on the event.
function Object:subscribe_once(evt_name, callback)
  local eid = self:subscribe(evt_name, function(...)
    callback(...)
    self:unsubscribe(evt_name, eid)
  end)
end

-- Unsubscribes from the given event 
-----------------------------------------------------------
-- Arguments: evt_name, eid
--     evt_name: The event for which you wish to unsubscribe
--     eid: The event ID returned by subscribe()
function Object:unsubscribe(evt_name, eid)
  self:_must_event(evt_name)

  self.events[evt_name][eid] = nil

  return eid
end


-- Triggering

-- Triggers an event.
-----------------------------------------------------------
-- Arguments: evt_name, ...
--     evt_name: The event to fire. Takes the form of
--     ...: The arguments for the event. evt_name
--            will be prepended to this.
function Object:trigger(evt_name, ...)
  local s = ""
  self:_trigger_raw(evt_name, evt_name, ...)
  
  for match in evt_name:gmatch("[^.]+[.]") do
    self:_trigger_raw(s .. match .. '*', evt_name, ...)
    s = s .. match
  end
end

-----------------------------------------------------------
-- Event Groups
-----------------------------------------------------------


--[[
-- Creates a new Event Group, for mass connecions 
-- and disconnections from events.
-----------------------------------------------------------
-- Arguments: none

function new_group()
  local obj = {}

  obj.events = {}
  obj.evt_names = {}

  function obj:subscribe(evt_name, cb)
    local eid = subscribe(evt_name, cb)
    self.evt_names[eid] = evt_name

    table.insert(self.events, eid)
  end

  function obj:unsubscribe(evt_name, eid)
    local eid = unsubscribe(evt_name, eid)

    local new_events = {}
    for _, e in ipairs(self.events) do
      if e ~= eid then
        table.insert(new_events, e)
      end
    end

    self.events = new_events
  end

  function obj:done()
    for _, eid in ipairs(self.events) do
      unsubscribe(self.evt_names[eid], eid)
    end
  end

  return obj
end
]]--

-- Main Loop

-- Stops the main loop.
-----------------------------------------------------------
-- Arguments: None.
function Object:stop()
  self.running = false
end

-- Runs the main loop.
-----------------------------------------------------------
-- Arguments: None
function Object:main()
  self:trigger("program.start")

  self.running = true

  while self.running do
    local evt = { os.pullEventRaw() }
    local evt_name = table.remove(evt, 1)
    local args = evt

    if evt_name == "terminate" then
      break
    elseif evt_name then
      self:trigger("event." .. evt_name, unpack(args))
    end
  end

  self:trigger("program.exit")
end

-- Register us with kidven

os.loadAPI("__LIB__/kidven/kidven")

kidven.register("event-loop", Object, 'object')