--- String object, allows storing strings and operating on them in a more OO-ish
-- manner
-- @classmod veek-string


-- lint-mode: veek-object

_parent = "object"

--- Initalises a veek-string object, which encapsulates a Lua string with
-- lib-kidven stuff, to allow for a more OO-optimised approch to coding.
-- @tparam string|veek-string|nil body The body of the new string.
function Object:init(body)
  if not body then
    body = ""
  end

  if body.is_a and body:is_a('veek-string') then
    self.body = body:cast('veek-string').body
  else
    self.body = body
  end
end

--- Appends {other} to this string, also returning this string to allow chaining.
-- @tparam veek-string|string|nil other The other string to append to this one.
function Object:append(other)
  if other.is_a and other:is_a('veek-string') then
    other = other:cast('veek-string').body
  end

  if type(other) ~= 'string' then error("Invalid value.", 2) end

  self.body = self.body .. other

  return self
end

--- Returns this string's body.
-- @treturn string The string that this veek-string encapsolates
function Object:string()
  return self.body
end

--- Iterates this string, splitting by needle.
-- @tparam veek-string|string needle The string to split by.
-- @treturn iterator Iterator of sub-strings of this string.
function Object:split(needle)
  local parts = {}
  local idx = self:index_of(needle)
  local str = new('veek-string', self.body)

  while idx do
    parts[#parts + 1] = str:substring(1, idx - 1)
    str = str:substring(idx + #needle)

    idx = str:index_of(needle)
  end

  parts[#parts + 1] = str

  return ipairs(parts)
end

--- Iterates this string, character by character.
-- @treturn iterator This string's individual characters.
function Object:iter()
  local pos = 0

  local function ret()
    pos = pos + 1

    if pos > #self.body then return nil end

    return self.body:sub(pos, pos)
  end

  return ret
end

--- Returns the index of sub, optionally starting at idx.
-- @tparam string|veek-string sub The pattern to search for.
-- @tparam ?int idx The index to start at.
-- @treturn iterator The indivudual strings.
function Object:index_of(sub, idx)
  if type(sub) == "string" then
    -- Do Nothing.
  elseif sub.is_a and sub:is_a("veek-string") then
    sub = sub:cast('veek-string').body
  else
    error("Unexpected type " .. kidven.type_of(sub))
  end

  return self.body:find(sub, idx)
end

--- Returns a sub-string from {start} to {stop}
-- @int start The starting position.
-- @int? stop The end position.
-- @treturn veek-string The sub-string.
function Object:substring(start, stop)
  return new('veek-string', self.body:sub(start, stop))
end

--- Returns the length of this string.
-- @treturn int The string's length.
function Object:length()
  return #self.body
end
