-- lint-mode: veek-object

_parent = "object"

function Object:init(body)
  if not body then
    body = ""
  end

  self.body = body
end

function Object:append(other)
  if other.is_a and other:is_a('veek-string') then
    other = other:cast('veek-string').body
  end

  if type(other) ~= 'string' then error("Invalid value.", 2) end

  self.body = self.body .. other

  return self
end

function Object:string()
  return self.body
end

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

function Object:iter()
  local pos = 0

  local function ret()
    pos = pos + 1

    if pos > #self.body then return nil end

    return self.body:sub(pos, pos)
  end

  return ret
end

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

function Object:substring(start, stop)
  return new('veek-string', self.body:sub(start, stop))
end

function Object:length()
  return #self.body
end
