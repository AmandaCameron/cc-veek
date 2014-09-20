-- lint-mode: veek-object

_parent = "object"

function Object:init(body)
  self.body = body
end

function Object:append(other)
  self.body = other
end

function Object:string()
  return self.body
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
