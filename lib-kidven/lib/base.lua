local class_reg = {}

if kidven then
  class_reg = kidven.get_registery()
end

-----------------------------------------------------------
-- Internal Functions (Do not use!)
-----------------------------------------------------------

function get_registery()
  return class_reg
end

function _new(cls_name, ret, skip_parents)
  local cls = class_reg[cls_name]

  if cls == nil then
    error("No such class '" .. cls_name .. "'", 2)
  end

  for k, v in pairs(cls.class) do
    if ret[k] == nil then
      ret[k] = v
    end
  end

  ret._type = cls_name

  -- Parent me, baby!

  if not skip_parents then
    local prev_parents = {}

    repeat
      if not cls.parent then
        break
      end

      local parent_nice, _ = cls.parent:gsub('-', '_')

      ret[parent_nice] = _new(cls.parent, {}, true)

      local size = #prev_parents

      for i = size, 1, -1 do
        local prev_parent = prev_parents[i]

        ret[prev_parent][parent_nice] = ret[parent_nice]
      end

      table.insert(prev_parents, parent_nice)

      for k,v in pairs(ret[parent_nice]) do
        if ret[k] == nil then
          if type(v) == 'function' then
            ret[k] = function(self, ...)
              return self[parent_nice][k](self[parent_nice], ...)
            end
          end
        end
      end

      cls = class_reg[cls.parent]
    until not cls.parent
  end

  -- Add methods all objects should have.

  function ret:is_a(cls_name)
    if self._type == cls_name then
      return true
    elseif self[cls_name:gsub("-", '_')] then
      return true
    end
    return false
  end

  function ret:cast(cls_name)
    if not self:is_a(cls_name) then
      error("Invalid cast.", 2)
    end

    if self._type == cls_name then
      return self
    else
      return self[cls_name:gsub('-', '_')]
    end
  end

  return ret
end


-- Registers a new class
function register(name, cls, parent)
  class_reg[name] = {
    class = cls,
    parent = parent,
  }
end

function new(cls_name, ...)
  local ret = _new(cls_name, {})

  if not ret then
    error("Couldn't create object of type " .. cls_name, 2)
  end

  if ret.init then
    ret:init(...)
  end

  return ret
end

-- Verifys a function's signature.
-- This accepts a table containing all the arguments, and
-- a varargs containing all the expected types.
function verify(args, ...)
  local types = { ... }
  for i, v in ipairs(args) do
    if typeof(v) == "table" and types[i] ~= "table" then
      if not v.is_a or not v:is_a(types[i]) then
        error("Expected: " .. table.concat(types, ", "), 2)
      end
    elseif typeof(v) ~= types[i] then
      error("Expected: " .. table.concat(types, ", "), 2)
    end
  end
end

function load(ns_name, obj_name, file, e)
  local env = {}
  setmetatable(env, { __index = (e or _G) })

  env[ns_name] = {}

  -- Basic Primitives!
  env.new = new

  local f_object, err = loadfile(file, fs.getName(file))

  if f_object then
    setfenv(f_object, env)

    f_object()
  else
    error(err, 2)
  end

  register(obj_name, env[ns_name], env._parent)
end

-- Main Body.

load("Object", "object", "__LIB__/kidven/object")
