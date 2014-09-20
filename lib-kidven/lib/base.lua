--- Kidven objecting library.
-- @module kidven

-- lint-mode: api
-- lint-ignore-global-get: kidven

local class_reg = {}

if kidven then
  class_reg = kidven.get_registery()
end

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
  ret._implements = {}

  for _, impl in ipairs(cls.implements) do
    ret._implements[impl] = true
  end

  -- Parent me, baby!

  if not skip_parents then
    local prev_parents = {}

    repeat
      if not cls.parent then
        break
      end

      local parent_nice, _ = cls.parent:gsub('-', '_')

      ret[parent_nice] = _new(cls.parent, {}, true)

      for _, impl in ipairs(cls.implements) do
        ret._implements[impl] = true
      end

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
    elseif self._implements[cls_name] then
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
      if self._implements[cls_name] then
        return self
      end

      return self[cls_name:gsub('-', '_')]
    end
  end

  return ret
end


--- Registers a new class
-- @string name
-- @tab cls
-- @string parent
function register(name, cls, parent, impl)
  local impl = impl or {}

  class_reg[name] = {
    class = cls,
    parent = parent,
    implements = impl,
  }
end

--- Creates a new instance of the given class.
-- @string cls_name The class name to create.
-- @param ... The parameters to pass to the class's init()
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

--- Verifys a function's signature.
-- @tparam table args The arguments to check.
-- @param ... The types to check against.
function verify(args, ...)
  local types = { ... }
  for i, v in ipairs(args) do
    local opt = false

    if types[i]:sub(-1) == "?" then
      opt = true

      types[i] = types[i]:sub(1, -2)
    end

    if type(v) == "table" and types[i] ~= "table" then
      if not v.is_a or not v:is_a(types[i]) then
        if not opt then
          error("Expected: " .. table.concat(types, ", "), 2)
        end
      end
    elseif type(v) ~= types[i] then
      if not opt then
        error("Expected: " .. table.concat(types, ", "), 2)
      end
    end
  end
end

--- Loads a class from a file.
-- @string ns_name The in-file object name.
-- @string obj_name The object's name.
-- @string file The file to load from.
-- @tparam ?|table e The environment to use.
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

  register(obj_name, env[ns_name], env._parent, env._implements)
end

-- Main Body.

load("Object", "object", "__LIB__/kidven/object")

register("interface", {}, nil, {})
