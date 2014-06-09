--- Threading library.
-- This is just an easy-to-use wrapper around coroutines
-- and implements a main loop for the threads.
-- Keep in mind that Lua uses cooperative multitasking.
-- Meaning at some point you must still yield.
-- @module thread

-- lint-mode: api

-- Dependencies!

os.loadAPI("__LIB__/kidven/kidven")

--- Thread Pool Object.
-- @type thread-pool
local Object = {}

--- Initializes a new thread-pool object.
function Object:init()
  self.coroutines = {}
  self.id = 0
end

--- Creates a new thread and adds it to it's queue.
-- @tparam function func The thread's function.
-- @tparam thread-handler handler Event handlers.
function Object:new(func, handler)
  local handler = handler or {}

  self.id = self.id + 1

  self.coroutines[self.id] = {
    co = coroutine.create(func),
    handler = handler,
    filter = nil,
  }

  if handler.created then
    handler:created()
  end

  return self.id
end

--- Stops all coroutines, uncleanly.
function Object:stop()
  self.coroutines = {}
end

--- Runs the coroutines sequentially, careful to handle ones that have since been stopped.
function Object:main()
  local evt = nil
  local args = {}

  while true do
    for id, t in pairs(self.coroutines) do
      if not t.filter or t.filter == evt or evt == "terminate" then
        local ok, res = coroutine.resume(t.co, evt, unpack(args))
        if not ok then
          if t.handler.error then
            t.handler:error(res)
          end
        else
          t.filter = res
        end
      end
    end

    local graves = {}

    local n = 0

    for id, t in pairs(self.coroutines) do
      n = n + 1

      if coroutine.status(t.co) == "dead" then
        table.insert(graves, id)
      end
    end

    for _, grave in ipairs(graves) do
      if self.coroutines[grave].handler.die then
        self.coroutines[grave].handler:die()
      end

      n = n - 1

      self.coroutines[grave] = nil
    end

    if n > 0 then
      args = { os.pullEventRaw() }
      evt = table.remove(args, 1)
    else
      break
    end
  end
end

kidven.register('thread-pool', Object, 'object')
